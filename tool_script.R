# MATERIALITY ASSESSMENT TOOL ----

# PACKAGES ----
library(tidyverse)
library(readxl)
library(writexl)
library(janitor)
library(patchwork)

# CONFIGURATION ----

# Define heatmap color scheme for materiality levels
pressure_colors <- c(
  "ND"  = "#D3D3D3", # Light Grey (No Data)
  "N/A" = "#D3D3D3", # Light Grey (Not Applicable)
  "VL"  = "#88CCEE", # Light Blue (Very Low Materiality)
  "L"   = "#44AA99", # Teal-Green (Low Materiality)
  "M"   = "#DDCC77", # Yellow (Medium Materiality)
  "H"   = "#E69F00", # Orange (High Materiality)
  "VH"  = "#882255"  # Dark Red (Very High Materiality)
)

# Define materiality levels in order (for aggregation)
score_levels <- c("ND", "N/A", "VL", "L", "M", "H", "VH")

# Function to select highest materiality level when aggregating
# (Used when multiple ISIC codes map to one category)
pick_highest_level <- function(x, score_levels) {
  x_char <- as.character(x)
  x_idx <- match(x_char, score_levels)
  if (all(is.na(x_idx))) {
    return("ND")
  } else {
    max_idx <- max(x_idx, na.rm = TRUE)
    return(score_levels[max_idx])
  }
}

# DATA IMPORT ----

# 1. Import procurement spend data
# Note: Update filename to meet organisations needs
procurement <- read_excel("procurement_classifications/2023 Procurement Data.xlsx")  #### CHANGE FILE HERE ####

# 2. Import classification mappings
# Maps procurement categories (AUNP) to ISIC Rev. 4 
isic_to_procurement <- read_excel("procurement_classifications/AUPN_into_ISIC_Classification.xlsx") #### CHANGE FILE HERE IF NOT IN AUPN ####

# 3. Import ENCORE data
# Pressure data
encore_pressure_csv <- read_csv("encore_download/07. Pressure mat ratings.csv")

# Clean pressure data
encore_pressure <- encore_pressure_csv |>
  slice(2:273) |>
  select(2:20) |>
  row_to_names(row_number = 1) |>
  rename(`ISIC Unique Code` = `ISIC Unique code`) |>
  # Remove duplicate D_35_351 entries, keeping only fossil fuel energy
  # (Victoria primarily uses fossil fuels for energy generation)
  filter(!(`ISIC Unique Code` == "D_35_351" & 
             `ISIC Class` != "Fossil fuels energy production"))

# Dependency data
encore_dependency_csv <- read_csv("encore_download/06. Dependency mat ratings.csv")

# Clean dependency data
encore_dependency <- encore_dependency_csv |>
  slice(2:273) |>
  row_to_names(row_number = 1) |>
  rename(`ISIC Unique Code` = `ISIC Unique code`) |>
  filter(!(`ISIC Unique Code` == "D_35_351" & 
             `ISIC Class` != "Fossil fuels energy production"))

# 4. Import ISIC to university spend category mapping
# Consolidates 77 ISIC categories into 19 university-specific categories
isic_to_aupn <- read_excel("procurement_classifications/isic_summary_classes.xlsx") #### CHANGE FILE HERE TO MATCH ORGANISATION ####

# DATA PROCESSING - LINKING PROCUREMENT TO MATERIALITY RATINGS ----

# Create unique keys for joining procurement to ISIC classifications
# (L3 titles can be duplicated, so we need a composite key)
procurement_mapping <- procurement |>
  mutate(
    Mega_L1_2_3 = str_c(
      `Mega Category (Taxonomy)`,
      `Level 1 (Taxonomy)`,
      `Level 2 (Taxonomy)`,
      `Level 3 (Taxonomy)`,
      sep = "|"
    )
  )

isic_mapping <- isic_to_procurement |>
  mutate(
    Mega_L1_2_3 = str_c(
      `Mega Category (Taxonomy)`,
      `Level 1 (Taxonomy)`,
      `Level 2 (Taxonomy)`,
      `Level 3 (Taxonomy)`,
      sep = "|"
    )
  )

# Join procurement data with ISIC classifications
procurement_to_isic <- left_join(
  procurement_mapping,
  isic_mapping,
  by = "Mega_L1_2_3"
) |>
  select(-Mega_L1_2_3)

# Verify no duplicate rows created
nrow(procurement_to_isic) - nrow(procurement_mapping)

# Add ENCORE pressure ratings to procurement data
procurement_pressure <- inner_join(
  procurement_to_isic,
  encore_pressure,
  by = "ISIC Unique Code"
) |>
  select(-ends_with(".x"), -`Match Quality`, -`Comments`) |>
  rename_with(~ str_replace(.x, "\\.y$", ""), ends_with(".y"))

# Add ENCORE dependency ratings to procurement data
procurement_dependency <- inner_join(
  procurement_to_isic,
  encore_dependency,
  by = "ISIC Unique Code"
) |>
  select(-ends_with(".x"), -`Match Quality`, -`Comments`) |>
  rename_with(~ str_replace(.x, "\\.y$", ""), ends_with(".y"))

# CREATE FULL HEATMAPS (ALL ISIC GROUPS) ----

# Pressure heatmap data preparation
pressure_data <- procurement_pressure |>
  select(
    `ISIC Group`, `ISIC Class`,
    `Disturbances (e.g noise, light)`,
    `Area of freshwater use`,
    `Emissions of GHG`,
    `Area of seabed use`,
    `Emissions of non-GHG air pollutants`,
    `Other biotic resource extraction (e.g. fish, timber)`,
    `Other abiotic resource extraction`,
    `Emissions of toxic soil and water pollutants`,
    `Emissions of nutrient soil and water pollutants`,
    `Generation and release of solid waste`,
    `Area of land use`,
    `Volume of water use`,
    `Introduction of invasive species`
  ) |>
  distinct(`ISIC Group`, `ISIC Class`, .keep_all = TRUE) |>
  mutate(
    `ISIC Group and Class` = ifelse(
      !is.na(`ISIC Class`),
      str_c(`ISIC Group`, " (", `ISIC Class`, ")"),
      `ISIC Group`
    )
  ) |>
  select(-`ISIC Group`, -`ISIC Class`)

# Convert to long format for plotting
pressure_data_long <- pressure_data |>
  pivot_longer(
    cols = -`ISIC Group and Class`,
    names_to = "Category",
    values_to = "Value"
  )

# Create full pressure heatmap
full_pressure_map <- ggplot(
  pressure_data_long,
  aes(
    x = Category,
    y = factor(`ISIC Group and Class`, levels = rev(unique(`ISIC Group and Class`))),
    fill = Value
  )
) +
  geom_tile(color = "white") +
  scale_fill_manual(values = pressure_colors) +
  labs(
    title = "Environmental Pressure by Industry Group",
    x = "Pressure Category",
    y = "ISIC Group",
    fill = "Materiality"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5)
  )

# Dependency heatmap data preparation
dependency_data <- procurement_dependency |>
  select(
    `ISIC Group`, `ISIC Class`,
    `Other provisioning services - Animal-based energy`,
    `Biomass provisioning`,
    `Solid waste remediation`,
    `Soil and sediment retention`,
    `Water purification`,
    `Soil quality regulation`,
    `Other regulating and maintenance service - Dilution by atmosphere and ecosystems`,
    `Biological control`,
    `Air Filtration`,
    `Flood mitigation services`,
    `Genetic material`,
    `Global climate regulation`,
    `Water supply`,
    `Nursery population and habitat maintenance`,
    `Noise attenuation`,
    `Other regulating and maintenance service - Mediation of sensory impacts (other than noise)`,
    `Local (micro and meso) climate regulation`,
    `Pollination`,
    `Storm mitigation`,
    `Water flow regulation`,
    `Rainfall pattern regulation`,
    `Recreation related services`,
    `Visual amenity services`,
    `Education, scientific and research services`,
    `Spiritual, artistic and symbolic services`
  ) |>
  distinct(`ISIC Group`, `ISIC Class`, .keep_all = TRUE) |>
  mutate(
    `ISIC Group and Class` = ifelse(
      !is.na(`ISIC Class`),
      str_c(`ISIC Group`, " (", `ISIC Class`, ")"),
      `ISIC Group`
    )
  ) |>
  select(-`ISIC Group`, -`ISIC Class`)

# Convert to long format for plotting
dependency_data_long <- dependency_data |>
  pivot_longer(
    cols = -`ISIC Group and Class`,
    names_to = "Category",
    values_to = "Value"
  )

# Create full dependency heatmap
full_dependency_map <- ggplot(
  dependency_data_long,
  aes(
    x = Category,
    y = factor(`ISIC Group and Class`, levels = rev(unique(`ISIC Group and Class`))),
    fill = Value
  )
) +
  geom_tile(color = "white") +
  scale_fill_manual(values = pressure_colors) +
  labs(
    title = "Ecosystem Service Dependencies by Industry Group",
    x = "Dependency Category",
    y = "ISIC Group",
    fill = "Materiality"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5)
  )

# AGGREGATE TO UNIVERSITY SPEND CATEGORIES ----

# Map ISIC codes to university spend categories
code_isic <- isic_to_aupn |>
  select(`ISIC Unique Code`, summary_classification) |>
  distinct(`ISIC Unique Code`, .keep_all = TRUE)

procurement_pressure_data <- inner_join(
  procurement_pressure,
  code_isic,
  by = "ISIC Unique Code"
)

procurement_dependency_data <- inner_join(
  procurement_dependency,
  code_isic,
  by = "ISIC Unique Code"
)

# Define pressure and dependency categories for analysis
pressure_score_cols <- c(
  "Disturbances (e.g noise, light)",
  "Area of freshwater use",
  "Emissions of GHG",
  "Area of seabed use",
  "Emissions of non-GHG air pollutants",
  "Other biotic resource extraction (e.g. fish, timber)",
  "Other abiotic resource extraction",
  "Emissions of toxic soil and water pollutants",
  "Emissions of nutrient soil and water pollutants",
  "Generation and release of solid waste",
  "Area of land use",
  "Volume of water use",
  "Introduction of invasive species"
)

dependency_score_cols <- c(
  "Other provisioning services - Animal-based energy",
  "Biomass provisioning",
  "Solid waste remediation",
  "Soil and sediment retention",
  "Water purification",
  "Soil quality regulation",
  "Other regulating and maintenance service - Dilution by atmosphere and ecosystems",
  "Biological control",
  "Air Filtration",
  "Flood mitigation services",
  "Genetic material",
  "Global climate regulation",
  "Water supply",
  "Nursery population and habitat maintenance",
  "Noise attenuation",
  "Other regulating and maintenance service - Mediation of sensory impacts (other than noise)",
  "Local (micro and meso) climate regulation",
  "Pollination",
  "Storm mitigation",
  "Water flow regulation",
  "Rainfall pattern regulation",
  "Recreation related services",
  "Visual amenity services",
  "Education, scientific and research services",
  "Spiritual, artistic and symbolic services"
)

# PRESSURE SUMMARY HEATMAP FOR REPORTING ----

# Aggregate pressure data by university spend category
pressure_plot_data <- procurement_pressure_data |>
  group_by(summary_classification) |>
  summarise(
    # Sum spend
    across(where(is.numeric), ~ sum(.x, na.rm = TRUE)),
    # Take worst-case materiality rating
    across(all_of(pressure_score_cols), ~ pick_highest_level(.x, score_levels))
  ) |>
  ungroup()

# Calculate total procurement spend for percentage calculations
total_procurement_spend <- sum(procurement$Spend, na.rm = TRUE)

# Prepare pressure data for plotting
pressure_impact_plot_data <- pressure_plot_data |>
  pivot_longer(
    cols = all_of(pressure_score_cols),
    names_to = "Category",
    values_to = "Value"
  ) |>
  mutate(
    percentage_spend = (Spend / total_procurement_spend) * 100
  ) |>
  # Filter for significant spend categories (>$2M) and remove less relevant pressures
  filter(
    Spend > 2e6,
    !Category %in% c(
      "Other abiotic resource extraction",
      "Other biotic resource extraction (e.g. fish, timber)"
    )
  ) |>
  mutate(
    # Remove duplicate percentage values for cleaner visualization
    percentage_spend = if_else(duplicated(percentage_spend), 0, percentage_spend),
    # Simplify N/A and ND to single category
    Value = if_else(Value %in% c("N/A", "ND"), "ND", Value)
  )

# Order by spend (highest first)
pressure_impact_plot_data_ordered <- pressure_impact_plot_data |>
  arrange(desc(Spend)) |>
  mutate(
    summary_classification = factor(
      summary_classification,
      levels = rev(unique(summary_classification))
    )
  )

# Create pressure heatmap
p_heatmap <- ggplot(
  pressure_impact_plot_data_ordered,
  aes(x = Category, y = summary_classification, fill = Value)
) +
  geom_tile(color = "white", size = 0.6) +
  scale_fill_manual(
    values = pressure_colors,
    drop = FALSE,
    name = "Materiality\nScore",
    breaks = c("ND", "VL", "L", "M", "H", "VH"),
    labels = c("No Data", "Very Low", "Low", "Medium", "High", "Very High")
  ) +
  labs(x = "Pressure Category", y = "Spend Category") +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
  scale_y_discrete(labels = function(x) str_wrap(x, width = 20)) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, color = "black", size = 12),
    axis.text.y = element_text(color = "black", size = 12),
    axis.title = element_text(face = "bold"),
    panel.grid = element_blank(),
    legend.position = "bottom",
    legend.direction = "horizontal"
  )

# Create spend bar chart
p_bar <- ggplot(
  pressure_impact_plot_data_ordered,
  aes(x = percentage_spend, y = summary_classification)
) +
  geom_col(fill = "#C8C8C8", color = NA) +
  labs(x = str_wrap("Percentage of Total\nProcurement Spend", width = 20), y = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.y = element_blank(),
    axis.title.x = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank()
  )

# Combine plots
pressure_combined_plot <- p_heatmap + p_bar +
  plot_layout(widths = c(5, 1)) +
  plot_annotation(theme = theme(plot.background = element_rect(fill = "white", color = NA)))

pressure_combined_plot

# DEPENDENCY SUMMARY HEATMAP FOR REPORT ----

# Aggregate dependency data by university spend category
dependency_plot_data <- procurement_dependency_data |>
  group_by(summary_classification) |>
  summarise(
    # Sum spend
    across(where(is.numeric), ~ sum(.x, na.rm = TRUE)),
    # Take worst-case materiality rating
    across(all_of(dependency_score_cols), ~ pick_highest_level(.x, score_levels))
  ) |>
  ungroup()

# Prepare dependency data for plotting
dependency_impact_plot_data <- dependency_plot_data |>
  pivot_longer(
    cols = all_of(dependency_score_cols),
    names_to = "Category",
    values_to = "Value"
  ) |>
  mutate(
    percentage_spend = (Spend / total_procurement_spend) * 100
  ) |>
  # Filter for significant spend categories and relevant dependencies
  filter(
    Spend > 2e6,
    !Category %in% c(
      "Education, scientific and research services",  # Less relevant for procurement
      "Genetic material",
      "Nursery population and habitat maintenance",
      "Other provisioning services - Animal-based energy",
      "Other regulating and maintenance service - Dilution by atmosphere and ecosystems",
      "Other regulating and maintenance service - Mediation of sensory impacts (other than noise)",
      "Pollination",
      "Local (micro and meso) climate regulation",
      "Soil quality regulation",
      "Biomass provisioning"
    )
  ) |>
  mutate(
    # Remove duplicate percentage values for cleaner visualization
    percentage_spend = if_else(duplicated(percentage_spend), 0, percentage_spend),
    # Simplify N/A and ND to single category
    Value = if_else(Value %in% c("N/A", "ND"), "ND", Value)
  )

# Define logical grouping for dependency categories
dep_levels <- c(
  # Water-related dependencies
  "Water purification",
  "Water supply",
  "Water flow regulation",
  # Waste and environmental quality
  "Solid waste remediation",
  "Soil and sediment retention",
  "Biological control",
  "Air Filtration",
  # Climate and weather regulation
  "Flood mitigation services",
  "Storm mitigation",
  "Global climate regulation",
  "Rainfall pattern regulation",
  # Cultural and amenity services
  "Visual amenity services",
  "Spiritual, artistic and symbolic services",
  "Recreation related services",
  "Noise attenuation"
)

# Apply category ordering
dependency_impact_plot_data <- dependency_impact_plot_data |>
  mutate(Category = factor(Category, levels = dep_levels))

# Order by spend (highest first)
dependency_impact_plot_data_ordered <- dependency_impact_plot_data |>
  arrange(desc(Spend)) |>
  mutate(
    summary_classification = factor(
      summary_classification,
      levels = rev(unique(summary_classification))
    )
  )

# Create dependency heatmap
d_heatmap <- ggplot(
  dependency_impact_plot_data_ordered,
  aes(x = Category, y = summary_classification, fill = Value)
) +
  geom_tile(color = "white", size = 0.6) +
  scale_fill_manual(
    values = pressure_colors,
    drop = FALSE,
    name = "Materiality\nScore",
    breaks = c("ND", "VL", "L", "M", "H", "VH"),
    labels = c("No Data", "Very Low", "Low", "Medium", "High", "Very High")
  ) +
  labs(x = "Dependency Category", y = "Spend Category") +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
  scale_y_discrete(labels = function(x) str_wrap(x, width = 20)) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, color = "black", size = 12),
    axis.text.y = element_text(color = "black", size = 12),
    axis.title = element_text(face = "bold"),
    panel.grid = element_blank(),
    legend.position = "bottom",
    legend.direction = "horizontal"
  ) +
  guides(
    fill = guide_legend(
      title.position = "left",
      nrow = 1,
      byrow = TRUE,
      label.position = "top",
      keywidth = 2.2,
      keyheight = 1.2
    )
  )

# Create dependency spend bar chart
d_bar <- ggplot(
  dependency_impact_plot_data_ordered,
  aes(x = percentage_spend, y = summary_classification)
) +
  geom_col(fill = "#C8C8C8", color = NA) +
  labs(x = str_wrap("Percentage of Total\nProcurement Spend", width = 20), y = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.y = element_blank(),
    axis.title.x = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank()
  )

# Combine dependency plots
dependency_combined_plot <- d_heatmap + d_bar +
  plot_layout(widths = c(5, 1)) +
  plot_annotation(theme = theme(plot.background = element_rect(fill = "white", color = NA)))

dependency_combined_plot

# SUPPLIER-LEVEL ANALYSIS ----

# Aggregate by supplier with worst-case materiality ratings
procurement_pressure_with_supplier_total <- procurement_pressure |>
  group_by(
    `Supplier Name`,
    `Level 1 (Taxonomy)`,
    `Level 2 (Taxonomy)`,
    `Level 3 (Taxonomy)`,
    `ISIC Unique Code`
  ) |>
  summarise(
    Total_Spend = sum(Spend, na.rm = TRUE),
    across(all_of(pressure_score_cols), ~ pick_highest_level(.x, score_levels)),
    .groups = "drop"
  ) |>
  arrange(desc(Total_Spend))

# Aggregate dependency data by supplier
procurement_dependency_with_supplier_total <- procurement_dependency |>
  group_by(
    `Supplier Name`,
    `Level 1 (Taxonomy)`,
    `Level 2 (Taxonomy)`,
    `Level 3 (Taxonomy)`,
    `ISIC Unique Code`
  ) |>
  summarise(
    Total_Spend = sum(Spend, na.rm = TRUE),
    across(all_of(dependency_score_cols), ~ pick_highest_level(.x, score_levels)),
    .groups = "drop"
  ) |>
  arrange(desc(Total_Spend))

# Create ISIC to university classification mapping for reference
isic_to_aupn_class <- procurement_dependency_data |>
  mutate(unique_l23 = str_c(`Level 2 (Taxonomy)`, `Level 3 (Taxonomy)`, sep = "|")) |>
  distinct(unique_l23, .keep_all = TRUE) |>
  select(
    `Level 1 (Taxonomy)`,
    `Level 2 (Taxonomy)`,
    `Level 3 (Taxonomy)`,
    `ISIC Unique Code`,
    `ISIC Section`,
    `ISIC Division`,
    `ISIC Group`,
    `ISIC Class`,
    `summary_classification`
  )

# EXPORT RESULTS IN EXCEL WORKBOOK ----

# Compile all data into Excel workbook
write_xlsx(
  list(
    "Procurement" = procurement,
    "Encore Pressure" = encore_pressure,
    "Encore Dependency" = encore_dependency,
    "AUPN to ISIC" = isic_to_procurement,
    "ISIC to Spend Category" = isic_to_aupn,
    "Procurement & Pressure" = procurement_pressure,
    "Procurement & Dependency" = procurement_dependency,
    "Supplier & Pressure" = procurement_pressure_with_supplier_total,
    "Supplier & Dependency" = procurement_dependency_with_supplier_total
  ),
  path = "workbooks/Materiality Workbook.xlsx"
)
