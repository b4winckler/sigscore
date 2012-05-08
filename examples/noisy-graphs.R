# Graphs with added noise
library(ggplot2)

numBins <- 10
binSize <- 8

# Compute sin(x) + N(0,s)
noisySin <- function(x=0, s=1, n=binSize)
  unlist(lapply(x, function(t) rnorm(n, mean=sin(pi*t), sd=s)))

# Compute signature score for columns in given matrix after binning them
# according to the given categories.
sigscore <- function(cats, mat)
{
    if (length(cats) != dim(mat)[1]) {
        warning('Number of categories does not match rows of data')
        return()
    }

    message('Computing signature scores...')
    m <- rbind(cats, t(mat))

    fname <- tempfile()
    csv <- write.table(m, file=fname, row.names=FALSE, col.names=FALSE,
                       na="", sep=",")

    z <- system(paste('sigscore',fname), intern=TRUE)
    system(paste('rm',fname))
    as.numeric(z)
}

devAskNewPage(TRUE)
x <- 0:(numBins-1) / (numBins-1)

## Example of how signature score varies with noise level.
#
# Take sin(x) for 0 < x < pi and sample for 'numBins' values of x.  Then add
# Gaussian noise with varying levels of standard deviation and compute the
# signature score.
#
# Conclusion: If standard deviation is about a quarter of the variation of
# the function (1 in this case), then it becomes hard to distinguish data
# from noise by only looking at the signature score.
#
X <- rep(x, each=binSize)
cats <- as.integer(factor(X))
s <- rep(1:100/40, each=10)
Y <- lapply(s, noisySin, x=x)
names(Y) <- paste("sd", s, sep='-')
df <- data.frame(Y)
score <- sigscore(cats, df)
print(qplot(s, score, alpha=I(0.2),
            main="sin(x) + N(0,sd), 0 < x < pi",
            xlab="sd", ylab="Signature score"))


## Graphs of sin(x)+N(0,sd) for varying levels of sd.
#
idx <- c(11,100,200)
df <- data.frame(sd=rep(s[idx],each=length(X)), x=rep(X,length(idx)),
                 y=unlist(Y[idx]))
print(qplot(x, y, data=df, facets=sd ~ .,
            main="sin(x)+N(0,sd), for different values of sd",
            geom=c("point","smooth")))


## Example of how signature score varies with bin size.
#
# Do same thing as in the first example, except keep standard deviation fixed
# and vary the bin size instead.
#
# Conclusion: If bin size is small then there is more uncertainty in the
# signature score.
#
score <- list()
N <- 1:20
M <- 10
for (n in N) {
    Y <- lapply(1:M, function(k) noisySin(x=x, s=0.25, n=n))
    df <- data.frame(y=Y)
    X <- rep(x, each=n)
    cats <- as.integer(factor(X))
    score[[n]] <- sigscore(cats, df)
}
score <- unlist(score)
print(qplot(rep(N,each=M), score, xlab='Bin size', 'Signature score',
            main="sin(x) + N(0,0.25), 0 < x < pi"))

devAskNewPage(FALSE)
