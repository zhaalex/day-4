# =====================================================================================================================
# = Simpsons Guest Stars                                                                                              =
# =                                                                                                                   =
# = - Scrape a table.                                                                                                =
# = - Remove elements from DOM.                                                                                       =
# =                                                                                                                   =
# = Author: Andrew B. Collier <andrew@exegetic.biz> | @datawookie                                                     =
# =====================================================================================================================

# CONFIGURATION -------------------------------------------------------------------------------------------------------

URL = "https://en.wikipedia.org/wiki/List_of_The_Simpsons_guest_stars"

# LIBRARIES -----------------------------------------------------------------------------------------------------------

library(rvest)
library(httr)

# ---------------------------------------------------------------------------------------------------------------------

UA <- "Andrew collier | andrew@exegetic.biz"
#
page <- GET(URL, user_agent("UA")) %>% read_html()

guest_stars <- page %>% html_nodes("table.wikitable") %>% .[[1]] %>% html_table()
#
# There's a problem though: there's an additional (hidden) tag in the table which is causing name duplication.

# Let's find a hack to delete those nodes.
#
sortkey <- page %>% html_nodes("th > span.sortkey")
#
xml_remove(sortkey)

# Try again.
#
guest_stars <- page %>% html_nodes("table.wikitable") %>% .[[1]] %>% html_table()
#
# Much better!

# EXERCISES -----------------------------------------------------------------------------------------------------------

# 1. Remove the episode number and production code columns.
# 2. Clean up the Guest Star Episode Title columns.
# 3. Convert the Role(s) column into a list column (split multiple roles).
# 4. Which guest star has appeared the most times?
# 5. Scrape the table of guest animators.