#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(glmnet)
library(datasets)
library(corrplot)

swdata <- swiss

Xn <- swdata[, !names(swdata) %in% c("Infant.Mortality")]
yn <- swdata["Infant.Mortality"]

X <- as.matrix(Xn)  
y <- as.matrix(yn)


lambdas <- 10^seq(-5, 5, length.out = 100)

lasso_cv <- cv.glmnet(X, y, alpha = 1, lambda = lambdas,
                      standardize = TRUE, nfolds = 10)

lambda_cv <- lasso_cv$lambda.min

model_cv <- glmnet(X, y, alpha = 1,
                   lambda = lambda_cv, standardize = TRUE)

y_hat_cv <- predict(model_cv, X)
rsq_lasso_cv <- cor(y, y_hat_cv)^2
lasso_coef_shrink <- glmnet(X, y, alpha = 1, lambda = lambdas, standardize = FALSE)

lcs <- glmnet(X, y, alpha = 1, lambda = lambda_cv, standardize = FALSE)

coeffs <- coef(lcs)
df <- data.frame(name = coeffs@Dimnames[[1]][coeffs@i + 1], coefficient = coeffs@x)
df$abs <- abs(df$coefficient)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  formulaText <- reactive({
    paste("Infant.Mortality ~", input$variable_single)
  })
  
  formulaTextPoint <- reactive({
    paste("Infant.Mortality ~", "as.integer(", input$variable_single, ")")
  })
  
  formulaTextM <- reactive({
    paste("Infant.Mortality ~", input$variable_multi)
  })
  
  formulaTextPointM <- reactive({
    paste("Infant.Mortality ~", "as.integer(", input$variable_multi, ")")
  })  
  
  fit <- reactive({
    lm(as.formula(formulaTextPoint()), data=swdata)
  })
  
  output$caption <- renderText({
    formulaText()
  })

  output$swBoxPlot <- renderPlot({
    boxplot(as.formula(formulaText()), 
            data = swdata,
            outline = input$outliers)
  })
  
  output$swCorrPlot <- renderPlot({
    corrplot(cor(swdata), type = 'upper', method ='color')
  })
  
  output$fit <- renderPrint({
    summary(fit())
  })
  
  output$sigvars <- renderPrint({
    
    df[order(df$abs, decreasing=TRUE),]
    
  })

#  output$swRegPlot <- renderPlot({
#    with(swdata, {
#      plot(as.formula(formulaTextPoint()))
#      abline(fit(), col=2)
#    })
#  })
  
  output$swRegPlot <- renderPlot({
    with(swdata, {
      model <- lm(as.formula(formulaTextPoint()))
        par(mfrow = c(2,2))
      plot(model)
    })
  })



  output$swLassoPlot <- renderPlot({

    par(mfrow = c(2, 1))
    plot(lasso_cv)
    title(main = "Analysis of Lambda's for Model Use")
    
    plot(lasso_coef_shrink, xvar = "lambda")
      title(main = 'Testing',
            sub = paste(c("Lambda used: ", format(lambda_cv, digits=3), ", Model R^2: ", format(rsq_lasso_cv, digits=3)), collapse = " "))
      legend("bottomright", lwd = 1, col=1:6, legend = colnames(Xn), cex = .7)
    })
  
  
})

