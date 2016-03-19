#Load libraries and data
library("dplyr")
library("plyr")

df <- read.csv("refine_original.csv", header = T, sep = ",")

#Lower the letters
df$company = tolower(df$company)

#Search company pattern, replace with desired one
idx <- agrep(pattern = "phillips", x = df$company, ignore.case = FALSE, value = FALSE, max.distance = 3)
df$company[idx] <- "phillips"

idx <- agrep(pattern = "van houten", x = df$company, ignore.case = FALSE, value = FALSE, max.distance = 3)
df$company[idx] <- "van houten"

idx <- agrep(pattern = "unilever", x = df$company, ignore.case = FALSE, value = FALSE, max.distance = 3)
df$company[idx] <- "unilever"

idx <- agrep(pattern = "akzo", x = df$company, ignore.case = FALSE, value = FALSE, max.distance = 1)
df$company[idx] <- "akzo"

#Separate product code and number
df = df %>% separate("Product.code...number", into = c("product code", "product number"), sep = "-")

#Add product categories
categories = c(p = "smartphone", v = "tv", x = "laptop", q = "tablet")
df <- rename(df, c("product code" = "product.code"))
product_category <- categories[df$product.code]
df <- mutate(df, product.cat = product_category)

#Add address for geocoding
df <- mutate(df, full.address = paste(df$address, df$city, df$country, sep = ","))

#Create dummy variables for company and product category
company_data <- df$company
company_data <- as.numeric(company_data == "phillips")
df$phillips <- company_data

company_data <- df$company
company_data <- as.numeric(company_data == "akzo")
df$akzo <- company_data

company_data <- df$company
company_data <- as.numeric(company_data == "van houten")
df$vanhouten <- company_data

company_data <- df$company
company_data <- as.numeric(company_data == "unilever")
df$unilever <- company_data

#Write csv
write.csv(df, file = "refine_clean.csv")