#-------------------------------
# Example 1: Create dataset with confounded association between LIGHTER and CANCER. The association between LIGHTER and CIGARETTES is what create the confounding, because the true causal association is between CIGARETTES and CANCER

rm(list=ls(all.names=TRUE))

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir <- setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir <- setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Store in a variable the size of the dataset
df_size <- 10000

# Create an empty data frame
data <- data.frame(PERSON_ID = 1:df_size, LIGHTER = rep(0, df_size), CIGARETTES = rep(0, df_size), CANCER = rep(0, df_size))

# Generate CIGARETTES variable (binary variable with 1 in 50 records)
data$CIGARETTES[sample(1:df_size, df_size/2)] <- 1

# Set a seed for reproducibility
set.seed(124)

# Generate LIGHTER variable based on CIGARETTES
data$LIGHTER[data$CIGARETTES == 1] <- sample(c(0, 1), size = sum(data$CIGARETTES == 1), prob = c(2/10, 8/10), replace = TRUE)
data$LIGHTER[data$CIGARETTES == 0] <- sample(c(0, 1), size = sum(data$CIGARETTES == 0), prob = c(9/10, 1/10), replace = TRUE)

# Set a seed for reproducibility
set.seed(227)

# Generate CANCER variable based on CIGARETTES
data$CANCER[data$CIGARETTES == 1] <- sample(c(0, 1), size = sum(data$CIGARETTES == 1), prob = c(3/10, 7/10), replace = TRUE)
data$CANCER[data$CIGARETTES == 0] <- sample(c(0, 1), size = sum(data$CIGARETTES == 0), prob = c(9/10, 1/10), replace = TRUE)

# save the dataset in csv format

write.csv(data, paste0(thisdir,"/dataset_complete.csv"), row.names = FALSE)

# remove CIGARETTES and save the dataset in csv format

dataset_confounding <- data[, !(names(data) == "CIGARETTES")]
write.csv(dataset_confounding, paste0(thisdir,"/dataset_confounding.csv"), row.names = FALSE)

