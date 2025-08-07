# Functions

## Define a function that takes the highest value in each column
pick_highest_level <- function(x, score_levels) {
  x_char <- as.character(x)
  x_idx <- match(x_char, score_levels)
  if (all(is.na(x_idx))) {
    return(ND)
  } else {
    max_idx <- max(x_idx, na.rm = TRUE)
    return(score_levels[max_idx])
  }
}

# Factors

## Ordered factor of materiality ratings
score_levels <- c("ND", "N/A", "VL", "L", "M", "H", "VH")

## Define all of the ENCORE pressure categories
# pressure_score_cols <- c(
#   "Disturbances (e.g noise, light)",
#   "Area of freshwater use",
#   "Emissions of GHG",
#   "Area of seabed use",
#   "Emissions of non-GHG air pollutants",
#   "Other biotic resource extraction (e.g. fish, timber)",
#   "Other abiotic resource extraction",
#   "Emissions of toxic soil and water pollutants",
#   "Emissions of nutrient soil and water pollutants",
#   "Generation and release of solid waste",
#   "Area of land use",
#   "Volume of water use",
#   "Introduction of invasive species"
# )

pressure_score_cols <- c(
  # Land and Seabed Use
  "Area of land use",
  "Area of seabed use",

  # Water Use and Related Pressures
  "Volume of water use",
  "Area of freshwater use",

  # Biotic and Abiotic Resource Extraction
  "Other biotic resource extraction (e.g. fish, timber)",
  "Other abiotic resource extraction",

  # Emissions: Greenhouse Gases and Air Pollutants
  "Emissions of GHG",
  "Emissions of non-GHG air pollutants",

  # Emissions: Soil and Water Pollutants
  "Emissions of toxic soil and water pollutants",
  "Emissions of nutrient soil and water pollutants",

  # Waste Generation
  "Generation and release of solid waste",

  # Invasive Species and Disturbances
  "Introduction of invasive species",
  "Disturbances (e.g noise, light)"
)

## Define all of the ENCORE dependency categories
# dependency_score_cols <- c(
#   "Other provisioning services - Animal-based energy",
#   "Biomass provisioning",
#   "Solid waste remediation",
#   "Soil and sediment retention",
#   "Water purification",
#   "Soil quality regulation",
#   "Other regulating and maintenance service - Dilution by atmosphere and ecosystems",
#   "Biological control",
#   "Air Filtration",
#   "Flood mitigation services",
#   "Genetic material",
#   "Global climate regulation",
#   "Water supply",
#   "Nursery population and habitat maintenance",
#   "Noise attenuation",
#   "Other regulating and maintenance service - Mediation of sensory impacts (other than noise)",
#   "Local (micro and meso) climate regulation",
#   "Pollination",
#   "Storm mitigation",
#   "Water flow regulation",
#   "Rainfall pattern regulation",
#   "Recreation related services",
#   "Visual amenity services",
#   "Education, scientific and research services",
#   "Spiritual, artistic and symbolic services"
# )

dependency_score_cols <- c(
  # Provisioning Services
  "Biomass provisioning",
  "Other provisioning services - Animal-based energy",
  "Genetic material",
  "Water supply",

  # Regulating and Maintenance Services – Water & Soil
  "Water purification",
  "Water flow regulation",
  "Rainfall pattern regulation",
  "Flood mitigation services",
  "Storm mitigation",
  "Soil and sediment retention",
  "Soil quality regulation",

  # Regulating and Maintenance Services – Climate & Air
  "Global climate regulation",
  "Local (micro and meso) climate regulation",
  "Air filtration",

  # Regulating and Maintenance Services – Pollution Control & Biological
  "Solid waste remediation",
  "Other regulating and maintenance service - Dilution by atmosphere and ecosystems",
  "Biological control",
  "Pollination",

  # Regulating and Maintenance Services – Sensory
  "Noise attenuation",
  "Other regulating and maintenance service - Mediation of sensory impacts (other than noise)",

  # Habitat and Nursery Services
  "Nursery population and habitat maintenance",

  # Cultural Services
  "Recreation related services",
  "Visual amenity services",
  "Education, scientific and research services",
  "Spiritual, artistic and symbolic services"
)

# Colours

## Color-blind-friendly pressure colors
pressure_colors <- c(
  "ND" = "#D3D3D3", # Light Grey (No Data)
  "N/A" = "#D3D3D3", # Light Grey (Not Applicable)
  "VL" = "#88CCEE", # Light Blue (Very Low Materiality)
  "L" = "#44AA99", # Teal-Green (Low Materiality)
  "M" = "#DDCC77", # Yellow (Medium Materiality)
  "H" = "#E69F00", # Orange (High Materiality)
  "VH" = "#882255" # Dark Red (Very High Materiality, indicating BAD)
)
