library(tidyverse)

data =   readr::read_delim(file = "data/Input/Import_BBBB.txt",delim = "\t" ,col_types = cols(
                 .default = col_character()), locale = readr::locale(encoding = "Latin1")  )


variables = names(data)[6:ncol(data)]
first_var = variables %>% first()
last_var = variables %>% last()

table_names = paste0("dd", variables %>% tolower())


data_long = data %>% pivot_longer(
  cols = !!(first_var):!!(last_var),
  values_to = "values",
  names_to = "variable"
)


output_col = c("Station",	"Datee",	"Valuee",
                  "Codee",	"CumulValue",	"DayNum",
                  "NumStns",	"Source")


for (i in 1:length(variables)) {


main_df = data_long %>% 
       filter(variable == variables[i]) %>%
       unite( Date,  c(year, month, day), sep = "/") %>% 
       select(Station_ID, Date, values)


main_df$Codee = "0"
main_df$CumulValue = "0"
main_df$DayNum = "0"
main_df$NumStns = "0"
main_df$Source = "CYODA"

names(main_df) = output_col



head_df = rbind(
  f_head = c(table_names[i], rep( x = NA, ncol(main_df) - 1) ),
  output_col
) %>% as_tibble()

names(head_df) = output_col



result =  rbind(head_df, main_df %>%  filter( !is.na( Valuee ) ) )

result %>% write_delim(file = paste0("data/output/", variables[i], ".txt") , delim = "\t", na = "", col_names = FALSE)

# main_df %>% write.table(file = paste0("data/test/", variables[i], ".txt") , sep = "\t", na = "", col.names = FALSE, row.names = FALSE)


}
