library(odbc)
library(DBI)
library(dplyr)
library(dbplyr)
library(plumber)

#* @apiTitle Extract mtcars from Snowflake DB
#* @apiDescription Example workflow using a Plumber API to extract data from Snowflake DB.

#* Return mtcars dataset
#* @get /data
function() {
  # Create the ODBC connection
  con <- DBI::dbConnect(odbc::odbc(), 
                        "Snowflake", 
                        timeout = 10)
  
  # Execute the query
  snowflake_mtcars <- tbl(con, in_schema("PUBLIC", "mtcars")) |>
    select(mpg, cyl, disp, hp, wt) |> 
    collect()
  
  # Close the database connection
  dbDisconnect(con)
  
  return(snowflake_mtcars)
}


