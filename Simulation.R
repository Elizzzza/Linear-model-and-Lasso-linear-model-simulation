## Linear model and Lasso linear model simulation
devtools::install_github("jacobbien/simulator")
library(simulator)
library(glmnet)
library(purrr)
cv.out <- cv.glmnet(x,y,alpha=1,nfolds=5) # Cross validated choice of the penalty
optimal_lambda = cv.out$lambda[which.min(cv.out$cvm)]
beta_est = as.numeric(glmnet(x,y,alpha=1, lambda = optimal_lambda)$beta) # Run model
beta_est #This is the lasso estimate of beta



make_mv_linear_model <- function(n, beta, sigma_sq) 
{
        new_model(          # Model constructor
                name = "mv_lm", 
                label = sprintf("n = %s, beta = %s, sigma_sq = %s", n, paste(beta, collapse = " "), sigma_sq),
                params = list(beta = beta, sigma_sq = sigma_sq, n = n),
                simulate = function(n, beta, sigma_sq, nsim)
                {
                        sim_list =  map(1:nsim, function(ii){
                                p = length(beta)
                                x <- matrix(rnorm(n*p, mean = 0, sd = 1), nrow = n, ncol = p)
                                y <- x %*% beta + rnorm(n, 0, sqrt(sigma_sq))
                                list("x" = x, "y" = y)})
                        
                        return(sim_list) 
                }
        )
}


lse <- new_method("lse", "LSE  w/o intrcpt",
                  method = function(model, draw) {
                          yy <- draw$y
                          xx <- draw$x
                          fit <- lm(yy ~ xx - 1)
                          list(betahat = fit$coef)
                  })


lasso <- new_method("lasso", "LASSO  w/o intrcpt",
                    method = function(model, draw) {
                            yy <- draw$y
                            xx <- draw$x
                            
                            cv.out <- cv.glmnet(xx,yy,alpha=1,nfolds=5)   # Cross validated choice of the penalty
                            optimal_lambda = cv.out$lambda[which.min(cv.out$cvm)]
                            beta_est = as.numeric(glmnet(xx,yy,alpha=1, lambda = optimal_lambda)$beta)  # Run model 
                            
                            list(betahat = beta_est)
                    })

sq_err <- new_metric("l2", 
                     "Squared error",
                     metric = function(model, out) {
                             sum((out$betahat - model$beta)^2)   # beta is a scalar
                     })

prop_est <- new_metric("support", 
                       "support recovery",
                       metric = function(model, out) {
                               p = length(model$beta)
                               correct= 0
                               for (i in 1:p){
                                       if (model$beta[i] == 0 & out$betahat[i] == 0){
                                               correct = correct + 1
                                       }
                                       else if (model$beta[i] > 0 & out$betahat[i] > 0){
                                               correct = correct + 1
                                       }
                               }
                               correct/p
                       })


sim <- new_simulation("ls_vs_lasso", "l2 vs support") %>%
        generate_model(make_mv_linear_model,  # Specify data generation function
                       n = 40,   # Data generation parameter 1
                       sigma_sq = as.list(c(1,4,7,10)),
                       beta = c(0,1,2,0,0),
                       vary_along = c("sigma_sq")) %>%
        simulate_from_model(nsim = 15)  %>%
        run_method(list(lse,lasso)) %>%
        evaluate(list(sq_err, prop_est))

sim %>% plot_eval(metric_name = "l2")
sim %>% plot_eval(metric_name = "support")