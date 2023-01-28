# Linear-model-and-Lasso-linear-model-simulation

#### BIOST 561: Computational Skills for Biostatistics
#### Instructor: Eardi Lila

In this problem, you will use the package `simulator` to perform the following simulation study.

Let $X$ be a $n \times p$ data matrix where each entry is generated from a normal distribution with mean 0 and
standard deviation 1. 
Let $y$ be the vector of responses

$$y = X \beta + \epsilon,$$

with $\beta$ = (0,1,2,0,0) (and therefore p = 5) and $\epsilon$ a $n$-vector where each entry is generated from a normal
distribution with mean 0 and standard deviation $\sigma$.

We decide to approach the estimation of $\beta$ with the following two methods:

-   Simple linear model (`lm`)

-   Lasso linear model: Suppose now you want to take advantage of the fact that some entries of the unknown vector $\beta$ are zero, i.e. $\beta$ is sparse. You therefore decide to apply a lasso linear model for the estimation of $\beta$. 


For the two methods above, you want evaluate the estimation accuracy using the two metrics:
-    L2 norm: $\sum_i {\beta_j - \hat{\beta_j}}^2$

-    Support recovery, i.e. the proportion of entries of $\beta$ that were correctly estimated to be equal to or
different from zero (in other words, the proportion of entries $j = 1,...,p$ for which the following
statement holds true: ($\beta_j>0$ and $\hat{\beta_j}>0$) or ($\beta_j=0$ and $\hat{\beta_j}=0$) )

Run a simulation study with $n$ = 40 and $\sigma^2$= {1,4,7,10}. Plot the results of the estimation accuracy (L2
norm and support recovery) in function of $\sigma^2$= {1,4,7,10}.
Comment on the results.

$$\left( \sum_{k=1}^n a_k b_k \right)^2 \leq \left( \sum_{k=1}^n a_k^2 \right) \left( \sum_{k=1}^n b_k^2 \right)$$
