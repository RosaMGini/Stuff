####################
# bug AdhereR

# clean environment

rm(list=ls(all.names=TRUE))

# set the directory where the file is saved as the working directory

if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir <- setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir <- setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# load packages

if (!require("data.table")) install.packages("data.table")
library(data.table)
if (!require("lubridate")) install.packages("lubridate")
library(lubridate)
if (!require("AdhereR")) install.packages("AdhereR")
library(AdhereR)
if (!require("xlsx")) install.packages("xlsx")
library(xlsx)

# load input data: there are 18 records. each record has a perfect twin. all records have the same medication and same duration (30 days). there are 3 groups of records: 
# 1) the first group has 2 records on day 1, 2 on day 61, and 2 on day 121
# 2) the second group is equal to the first but translated by 400 days
# 3) the third group is equal to the first but translated by 800 days.

dispensings <- as.data.table(readxl::read_excel((file.path(thisdir,  "dispensings.xlsx") )))

# convert dates

baseline_date <- as.Date(lubridate::ymd(20150101))
dispensings_date <- copy(dispensings)[, date := as.Date(date + baseline_date)]

# run AdhereR to create episodes, with no options

episodes_date <- compute.treatment.episodes(dispensings_date,
                                   ID.colname= "person_id",
                                   event.date.colname= "date",
                                   event.duration.colname= "duration",
                                   medication.class.colname= "label"
)

episodes_date <- as.data.table(episodes_date)

# reconvert dates in integers

vectordates <- c("episode.start","episode.end")

episodes <- copy(episodes_date)

for (variable in vectordates) {
  episodes[, (variable) := as.integer(get(variable) - baseline_date)]
}

# only 2 groups are created: one from day 1 to day 181 and one from day 401 to day 581. the third group, that should be from day 801 to day 981, is not created.

# export

write.xlsx(episodes,file.path(thisdir,"episodes.xlsx") , row.names = F)
