# Import packages
library(tidyverse)
library(janitor)

# Cleans ENCORE data

# Import, clean, and save ENCORE pressure data
encore_pressure <- read_csv("encore_download/07. Pressure mat ratings.csv") |>
  slice(2:273) |>
  select(2:20) |>
  row_to_names(row_number = 1) |>
  rename(
    # Rename due to inconsistencies in the naming of the original ENCORE dataset
    `ISIC Unique Code` = `ISIC Unique code`
  ) |>
  # Filter out any rows of D_35_351 that are NOT Fossil fuels energy production. This is because the
  # D_35_351 unique code captures multiple classes, and we only want to retain one
  # Fossil fuels suit Victoria's electricity supply best as most of it is from brown coal
  filter(
    !(`ISIC Unique Code` == "D_35_351" &
      `ISIC Class` != "Fossil fuels energy production")
  )

write_csv(encore_pressure, "encore_download/clean/encore_pressure_ratings.csv")

# Import, clean, and save ENCORE dependency data
encore_dependency <- read_csv(
  "encore_download/06. Dependency mat ratings.csv"
) |>
  slice(2:273) |>
  row_to_names(row_number = 1) |>
  rename(
    `ISIC Unique Code` = `ISIC Unique code`
  ) |>
  # Filter out any rows of D_35_351 that are NOT Fossil fuels energy production. This is because the
  # D_35_351 unique code captures multiple classes, and we only want to retain one
  # Fossil fuels suit Victoria's electricity supply best as most of it is from brown coal
  filter(
    !(`ISIC Unique Code` == "D_35_351" &
      `ISIC Class` != "Fossil fuels energy production")
  ) |>
  rename(
    `Air filtration` = `Air Filtration`
  )

write_csv(
  encore_dependency,
  "encore_download/clean/encore_dependency_ratings.csv"
)

# Upstream links
upstream_links <- read_csv("encore_download/16. Upstream links.csv")

write_csv(upstream_links, "encore_download/clean/upstream_links.csv")

# Import downstream value chain links
downstream_links <- read_csv("encore_download/17. Downstream links.csv")

write_csv(downstream_links, "encore_download/clean/downstream_links.csv")
