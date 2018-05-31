# =====================================================================================================================
# = Using rvest (HTML from URL)                                                                                       =
# =                                                                                                                   =
# = Author: Andrew B. Collier <andrew@exegetic.biz> | @datawookie                                                     =
# =====================================================================================================================

# Scrape two sets of data:
#
# - World University Rankings and
# - Popular R jobs.

# CONFIGURATION -------------------------------------------------------------------------------------------------------

URL_UNI_RANK = "http://cwur.org/2015.php"
URL_R_USERS = "http://www.r-users.com/"

# LIBRARIES -----------------------------------------------------------------------------------------------------------

library(dplyr)
library(stringr)
library(rvest)

# WORLD UNIVERSITY RANKINGS -------------------------------------------------------------------------------------------

# We'll start by scraping World University Rankings from http://cwur.org/2015.php.

rankings <- read_html(URL_UNI_RANK) %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table(trim = TRUE)
#
# Q. Use the browser to get a more specific CSS selector for this table.
# Q. Is the .[[1]] necessary?

# Clean up the column names.
#
names(rankings)
#
names(rankings) <- names(rankings) %>% str_replace_all("[[:space:]]", "_") %>% tolower()

# Use filter() to find the ranking of your university.
#
rankings %>% filter(grepl("Royal", institution), location == "Sweden")

# POPULAR R JOBS ------------------------------------------------------------------------------------------------------

# Extract the text and links from the Popular Jobs Today section at http://www.r-users.com/.

rusers <- read_html(URL_R_USERS)

# METHOD 1

# Grab the <li> nodes.
#
rusers.li <- html_nodes(rusers, xpath = '//*[@id="top_listings-2"]/div[2]/ul/li')
#
# Grab the child nodes (could have done this directly with more specific XPath above).
#
rusers.a <- html_children(rusers.li)

# METHOD 2
#
rusers.a <- html_nodes(rusers, xpath = '//*[@id="top_listings-2"]/div[2]/ul/li/a')

html_attr(rusers.a, name = "href")
html_text(rusers.a)
#
# Turn this into a table.
#
tibble(
  title = html_text(rusers.a),
  link = html_attr(rusers.a, name = "href")
)
