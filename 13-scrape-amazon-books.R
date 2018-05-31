# =====================================================================================================================
# = "Data Science" books on Amazon                                                                                    =
# =                                                                                                                   =
# = Author: Andrew B. Collier <andrew@exegetic.biz> | @datawookie                                                     =
# =====================================================================================================================

# CONFIGURATION -------------------------------------------------------------------------------------------------------

URL = "https://www.amazon.com/"

# LIBRARIES -----------------------------------------------------------------------------------------------------------

library(RSelenium)
library(stringr)

# CONNECTION ----------------------------------------------------------------------------------------------------------

BROWSER_OPTIONS = list(
  chromeOptions = list(
    args = c(
      '--disable-gpu',
      # '--headless',
      '--window-size=1280,800')
  )
)

browser <- remoteDriver(browserName = "chrome",
                        extraCapabilities = BROWSER_OPTIONS,
                        remoteServerAddr = "localhost",
                        port = 4444L)
browser$open()

browser$navigate(URL)

# CATEGORY ------------------------------------------------------------------------------------------------------------

# Select and click the category dropdown.
#
category <- browser$findElement(using = 'css selector', "#searchDropdownBox")
category$clickElement()

# Find the options in the dropdown (this takes a little time to execute!).
#
options = sapply(category$findChildElements(using = 'css selector', "option"), function(tag) {
  tag$getElementText()[[1]]
  }) %>% str_trim()

books_index = which(options == "Books")
#
books_selector = sprintf("#searchDropdownBox > option:nth-child(%d)", books_index)

# Select the Books category.
#
category_books <- browser$findElement(using = 'css selector', books_selector)
category_books$clickElement()

# SEARCH TERM ---------------------------------------------------------------------------------------------------------

search_box <- browser$findElement(using = 'css selector', "#twotabsearchtextbox")
search_box$sendKeysToElement(list("Data Science"))

search_button <- browser$findElement(using = 'css selector', "#nav-search > form > div.nav-right > div > input")
search_button$clickElement()

# GATHER RESULTS ------------------------------------------------------------------------------------------------------

# Found the CSS selector using SelectorGadget.
#
titles <- sapply(browser$findElements(using = 'css selector', ".s-access-title"),
                 function(tag) tag$getElementText()[[1]])

# Found the CSS selector using SelectorGadget.
#
# What does ".a-color-secondary+ .a-color-secondary" mean?
#
# This selector will only match tags with class a-color-secondary following another tag with the same class!
#
authors <- sapply(browser$findElements(using = 'css selector', ".a-color-secondary+ .a-color-secondary"),
                  function(tag) tag$getElementText())
#
# Note: There's a minor hitch here, which will require some mangling to fix!

# EXERCISES -----------------------------------------------------------------------------------------------------------

# 1. Search for "Data Science" books on http://ebay.com/. For each book retrieve the title and price.
