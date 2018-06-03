library(dplyr)

#loading kiva data
kiva_loans <- read.csv("kiva_loans.csv", stringsAsFactors = F, na.strings = "")

kiva_regions <- read.csv("kiva_mpi_region_locations.csv",
                         stringsAsFactors = F, na.strings = "")

regional_loan_themes <- read.csv("loan_themes_by_region.csv",
                                 stringsAsFactors = F, na.strings = "")

kiva_loan_themes <- read.csv("loan_theme_ids.csv",
                             stringsAsFactors = F, na.strings = "")


MPI_national <- read.csv("MPI_national.csv",
                         stringsAsFactors = F, na.strings = "")

MPI_subnational <- read.csv("MPI_subnational.csv",
                         stringsAsFactors = F, na.strings = "")

country_stats <- read.csv("country_stats.csv",
                          stringsAsFactors = F, na.strings = "")

#creating country table
country_table <- country_stats %>%
  rename(Country = country_name,
         ISO = country_code3,
         Human.Dev.Index = hdi,
         Gross.National.Income = gni) %>%
  mutate(population_below_poverty_line = population_below_poverty_line * .01) %>%
  select(Country, ISO, population, population_below_poverty_line, Human.Dev.Index,
         life_expectancy, mean_years_of_schooling, Gross.National.Income,
         expected_years_of_schooling) %>%
  rename_all(tolower)

country_table <- MPI_subnational %>%
  rename(iso = ISO.country.code) %>%
  select(iso, MPI.National) %>%
  filter(duplicated(iso) == F) %>%
  right_join(country_table)

country_table <- country_table %>%
  mutate(country_code = 1:nrow(country_table)) %>%
  select(country_code, country, iso, population, population_below_poverty_line, human.dev.index,
         life_expectancy, mean_years_of_schooling, gross.national.income,
         expected_years_of_schooling, MPI.National)

#creating region table
MPI_subnational <- MPI_subnational %>%
  select(-MPI.National)

regional_table <- kiva_regions %>%
  select(region, lat, lon, MPI, ISO, country)

MPI_subnational <- MPI_subnational %>%
  rename(region = Sub.national.region) %>%
  select(region, MPI.Regional, Headcount.Ratio.Regional, Intensity.of.deprivation.Regional) %>%
  left_join(regional_table, by = "region")

regional_table <- inner_join(regional_table, MPI_subnational)

regional_table <- regional_loan_themes %>%
  select(region, rural_pct) %>%
  right_join(regional_table)

regional_table <- regional_table %>%
  mutate(region_id = 1:nrow(regional_table)) %>%
  select(region_id, region, lat, lon, MPI, ISO, Headcount.Ratio.Regional,
         Intensity.of.deprivation.Regional, rural_pct) %>%
  rename_all(tolower)

regional_table <- country_table %>%
  select(iso, country_code) %>%
  right_join(regional_table) %>%
  filter(duplicated(region) == F)

regional_table <- regional_table %>%
  mutate(region = gsub(pattern = ",", replacement = "", regional_table$region)) %>%
  select(region_id, region, lat, lon, mpi, country_code, headcount.ratio.regional,
         intensity.of.deprivation.regional, rural_pct) %>%
  filter(is.na(country_code) == F)

write.csv(country_table, "Country.csv", row.names = F, na = "NULL")

write.csv(regional_table, "Region.csv", row.names = F, na = "NULL")

#final table or partner
partner <- read.csv("Partner.csv", stringsAsFactors = F, header = F)

partner <- partner %>%
  mutate(V2 = gsub(pattern = "N/A,|NA|N/A|,", replacement = "", partner$V2))

write.csv(partner, "Partner.csv", row.names = F)
