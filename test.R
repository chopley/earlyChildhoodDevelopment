library('fuzzyjoin')
head(random_allocation)
head(unique_sa_clinical_facilities)

#clean up the various columns for Eastern Cape
head(random_allocation)
random_allocation$province <- gsub("ec", "", random_allocation$province)
random_allocation$province <- gsub("Province", "", random_allocation$province)
random_allocation$district <- gsub("ec", "", random_allocation$district)
random_allocation$subdistrict <- gsub("ec", "", random_allocation$subdistrict)
random_allocation$facility <- gsub("ec", "", random_allocation$facility)

head(random_allocation)
unique_sa_clinical_facilities[grep('.*Philani.*',unique_sa_clinical_facilities$fac_name),]


unique_sa_clinical_facilities <- unique(sa_clinical_facilities[c('fac_name','municipality','testURL','gps_coords')])
unique_sa_clinical_facilities$province[grep('.*/western-cape.*',unique_sa_clinical_facilities$testURL)] <-'Western Cape'
unique_sa_clinical_facilities$province[grep('.*/eastern-cape.*',unique_sa_clinical_facilities$testURL)] <-'Eastern Cape'
unique_sa_clinical_facilities$province[grep('.*/northern-cape.*',unique_sa_clinical_facilities$testURL)] <-'Northern Cape'
unique_sa_clinical_facilities$province[grep('.*/gauteng.*',unique_sa_clinical_facilities$testURL)] <-'Gauteng'
unique_sa_clinical_facilities$province[grep('.*/north-west.*',unique_sa_clinical_facilities$testURL)] <-'North West'
unique_sa_clinical_facilities$province[grep('.*/limpopo.*',unique_sa_clinical_facilities$testURL)] <-'Limpopo'
unique_sa_clinical_facilities$province[grep('.*/mpumalanga-.*',unique_sa_clinical_facilities$testURL)] <-'Mpumalanga'




df$test <- gsub("kz", "Kwazulu-Natal", df$facility)
df$test <- gsub("nw", "North West", df$facility)
df$test <- gsub("wc", "Western Cape", df$facility)
df$test <- gsub("nc", "Northern Cape", df$facility)
