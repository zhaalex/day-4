# =====================================================================================================================
# = Scrape AccuWeather                                                                                                =
# =                                                                                                                   =
# = Author: Andrew B. Collier <andrew@exegetic.biz> | @datawookie                                                     =
# =====================================================================================================================

# Scrape weather information for Cape Town from AccuWeather.

# CONFIGURATION -------------------------------------------------------------------------------------------------------

URL = "https://www.accuweather.com"
#
URLPATH = "/en/za/cape-town/306633/weather-forecast/306633?lang=en-gb"

# LIBRARIES -----------------------------------------------------------------------------------------------------------

library(rvest)
library(httr)
library(dplyr)
library(stringr)

# ACCESS PAGE ---------------------------------------------------------------------------------------------------------

url = paste0(URL, URLPATH)

cape.town <- read_html(url)
#
# We get a 403 Forbidden error. This probably means that the site perceives us as a robot.

# Let's try with a more anonymous User Agent string.
#
UA <- "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36"
#
cape.town <- html_session(url, user_agent(UA))

# What about an ethical User Agent string?
#
UA <- "Andrew collier | andrew@exegetic.biz"
#
cape.town <- html_session(url, user_agent(UA))

# ---------------------------------------------------------------------------------------------------------------------

# Current temperature.
#
cape.town %>%
  html_node(".c .large-temp") %>%
  html_text()

# Can you simplify the CSS selector and still get the same information?

# Temperature units.
#
cape.town %>%
  html_node("span.temp-label") %>%
  html_text()

# Current conditions.
#
cape.town %>%
  html_node(".c .cond") %>%
  html_text()

# EXERCISES -----------------------------------------------------------------------------------------------------------

# 1. Look at the extended forecast for Cape Town.
#
#    https://www.accuweather.com/en/za/cape-town/306633/daily-weather-forecast/306633
#
#    a) Get the day/night predicted temperatures for the next three days.
#    b) Get the predicted conditions for the next three days.
#    c) Consolidated these data in a data frame.
#    d) Find the time of sunrise and sunset.

# SOLUTIONS -----------------------------------------------------------------------------------------------------------

url = "https://www.accuweather.com/en/za/cape-town/306633/daily-weather-forecast/306633"
#
cape.town <- html_session(url, user_agent(UA))

# Predicted day and night temperatures for tomorrow.
#
cape.town %>% html_node("li.fday2 .large-temp") %>% html_text()
cape.town %>% html_node("li.fday2 .small-temp") %>% html_text()

# Predicted day and night temperatures for the next day.
#
cape.town %>% html_node("li.fday3 .large-temp") %>% html_text()
cape.town %>% html_node("li.fday3 .small-temp") %>% html_text()

# Predicted day and night temperatures for the day after.
#
cape.town %>% html_node("li.fday4 .large-temp") %>% html_text()
cape.town %>% html_node("li.fday4 .small-temp") %>% html_text()

# Predicted conditions for tomorrow.
#
cape.town %>% html_node("li.fday2 .info > span") %>% html_text()

# Let's wrap that up in a loop.
#
next_days <- lapply(2:4, function(nday) {
  selector_day = sprintf("li.fday%d", nday)
  #
  tibble(
    day = nday,
    temperature_max = cape.town %>% html_node(paste(selector_day, ".large-temp")) %>% html_text(),
    temperature_min = cape.town %>% html_node(paste(selector_day, ".small-temp")) %>% html_text(),
    conditions = cape.town %>% html_node(paste(selector_day, ".info > span")) %>% html_text()
  )
}) %>% bind_rows()
#
# Now clean it up.
#
next_days %>% mutate_at(
  c("temperature_max", "temperature_min"),
  function(temperature) {
    temperature %>% str_replace("°", "") %>% str_replace("^/", "") %>% as.integer()
  }
)

# Sunrise and sunset.
#
cape.town %>% html_node("#feature-sun li:nth-child(1) > span") %>% html_text()
cape.town %>% html_node("#feature-sun li:nth-child(2) > span") %>% html_text()
#
cape.town %>% html_nodes("#feature-sun li > span") %>% html_text() %>% .[1:2]

