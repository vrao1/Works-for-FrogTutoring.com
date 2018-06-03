
#*************************************************************************************
#Following problem # 58 on page # 325 taken from the book "Mathematical Statistics and Data Analysis 3rd Edition by John A. Rice" 
#*************************************************************************************
#If gene frequencies are in equilibrium, the genotypes AA, Aa, and aa occur with probabilities (1 − θ )2 , 2θ (1 − θ ), and θ 2 , respectively. Plato et al. (1964) published the following data on haptoglobin type in a sample of 190 people:
#  Haptoglobin Type
#===================================================================================
# Hp1-1 Hp1-2 Hp2-2 
#  10    68    112
#====================================================================================
#a. Find the mle of θ.
#b. Find the asymptotic variance of the mle.
#c. Find an approximate 99% confidence interval for θ.
#d. Use the bootstrap to find the approximate standard deviation of the mle and
#compare to the result of part (b).
#e. Use the bootstrap to find an approximate 99% confidenceinterval and compare
#to part (c).
#*************************************************************************************
#Following problem referred and extended above problem # 58 on page # 325 taken from the book "Mathematical Statistics and Data Analysis 3rd Edition by John A. Rice" 
#*************************************************************************************
#HINT: This problem asks you to use the bootstrap procedure to estimate the sampling distribution of the MLE. Here are the basic steps, along with some simple R code to implement this. You should read through this code, implement it, and then see how you might want to modify it to adapt it to the particular assigned exercise.
#a) First, you want to use data you have to generate estimates for multinomial cell probabilities. Let pˆ = (pˆ1, pˆ2, pˆ3) be your estimates for these cell probabilities.
#b) Next, consider drawing 1000 realizations of a multinomial experiment with a total number of 190 ob- jects to be placed in one of K = 3 bins (where is 190 and K = 3 coming from?), with a vector of probabilities pˆ. Here is a snippet of code that will achieve this objective; in this case, the probability vector pˆ is given by pˆ = (0.2, 0.3, 0.5), for example, and the results of these multinomial realizations are saved in an array called multinom:
#     >multinom<-rmultinom(1000,190,c(0.2,0.3,0.5))
#For more information on the rmultinom function, see the documentation at
#https://stat.ethz.ch/R-manual/R-devel/library/stats/html/Multinom.html.
#c) Now, let’s use this array to try to understand, say, the distribution of a function of these multinomial random variables. Suppose, for example, that we want to understand the distribution of X2 + X3, where X2 and X3 are the number of objects placed into bins 2 and 3. To do this, the following code
#n
# √
#n(αˆMLE −α0)
# 2
#may be useful:
#y<-rep(0,1000)
#for(i in 1:1000){y[i]<-(multinom[2,i]+multinom[3,i])}
#Make sure you understand this code and what it is doing! In particular, once you have created the array multinom, type multinom at the command prompt to see what this array looks like and how R indexes its entries.
#d) To try to determine the distribution of X2 + X3, then, you can plot a histogram of the values in the vector y. You can also use the vector y to estimate the standard deviation of X2 + X3, for example (what command might you want to use to estimate this standard deviation?)
#*************************************************************************************
# Drawing 1000 realizations of a multinomial experiment with a total number of 190 ob- jects to be placed in one of K = 3 bins
# Using Estimated value of THETA = 0.7684
# prob_1 = (1-THETA)^2 
# prob_2 = 2*THETA*(1-THETA) 
# prob_3 = (THETA)^2 

THETA = 0.7684
prob_1 = (1-THETA)^2
prob_2 = 2*THETA*(1-THETA)
prob_3 = (THETA)^2

#The matrix multinom contains X1, X2 , X3 values for 1000 simulations in (3 x 1000) dimension matrix
multinom<-rmultinom(1000,190,c(prob_1, prob_2, prob_3))

# multinom is 3 x 1000 matrix , it can be viewed partially as follows
multinom

# Declaring y as an array of 1000 integers , that contains sum of X2 and X3 values stored in bins 2 and 3 respectively
y <- rep(0, 1000)

# Storing values obtained for MLE into y using following formula :
# (2 * X3 + X2)/(2*190)

for (i in 1:1000){
  y[i] <- (multinom[2,i] + 2* multinom[3,i]) / (2*190)
}

print(y)
par(mar=c(1,1,1,1))
hist(y,
     main="Histogram for Maximum Likehood Estimate",
     xlab="MLE",
     border="blue", 
     col="green",
     ylab="Frequency")

standardDeviation <- sd(y)
paste("The Standard Deviation through Bootstrap is ", standardDeviation)

paste("The 99% Confidence Interval through Bootstrap is (", THETA-2.576*standardDeviation, ", ", THETA+2.576*standardDeviation, " )")
