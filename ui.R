#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  navbarPage("Shiny Application",
             tabPanel("Analysis",
                      fluidPage(
                        titlePanel("The relationship between Infant Mortality and variables"),
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("variable_single", "Linear Regression: Infant Mortality (IM) vs One Variable:",
                                        c("Agriculture" = "Agriculture",
                                          "Catholic" = "Catholic",
                                          "Education" = "Education",
                                          "Examination" = "Examination",
                                          "Fertility" = "Fertility"
                                        )),

                            checkboxInput("outliers", "Show BoxPlot's outliers", FALSE)
                          ),
                          
                          mainPanel(
                            h3(textOutput("caption")),
                            
                            tabsetPanel(type = "tabs",
                                        tabPanel("BoxPlot",
                                                 plotOutput("swBoxPlot")),
                                        tabPanel("IM vs One Var Regression model", 
                                                 plotOutput("swRegPlot"),
                                                 verbatimTextOutput("fit")
                                        ),
                                        tabPanel("Lasso Regression IM vs All - Feature Importance",
                                                 plotOutput("swLassoPlot"),
                                                 verbatimTextOutput("sigvars")),
                                        tabPanel("Correlation Plot",
                                                 plotOutput("swCorrPlot"))
                            )
                          )
                        )
                      )
             ),

             tabPanel("Dataset details",
                      h2("Swiss Fertility And Socioeconomic Indicators (1888) Data"),
                      hr(),
                      h3("Description"),
                      helpText("The data collected are for 47 French-speaking provinces at about 1888.",
                               "A data frame with 47 observations on 6 variables, each of which is in percent, i.e., in [0,100].",
                               "All variables but 'Fertility' give proportions of the population."),
                      h3("Format"),
                      p("The dataframe consists of 47 observations on 6 variables, each of which is in percent. 0 - 100"),
                      
                      p("  [, 1]   Fertility"),
                      p("  [, 2]	 Agriculture"),
                      p("  [, 3]	 Examination"),
                      p("  [, 4]	 Education"),
                      p("  [, 5]	 Catholic"),
                      p("  [, 6]   Infant.Mortality"),

                      
                      h3("Source"),
                      
                      p("Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988) The New S Language. Wadsworth & Brooks/Cole.")
             ),
             tabPanel("Github Repo",
                      a("https://github.com/3nchantment/DevelopingDataProductsAssignment"),
                      hr(),
                      h4("The name of the repository is Developing Data Products Week 4 Course Project")
             )
  )
)
