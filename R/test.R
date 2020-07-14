library(randomNames)
library(tibble)

# Create sample data ------------------------------------------------------


subjid <- 100:109
name <- randomNames(10)
sex <- factor(c("M", "F", "F", "M", "M", "F", "M", "F", "F", "M"),
              levels =  c("M", "F", "UNK"))
age <- c(41, 53, 43, 39, 47, 52, 21, 38, 62, 26)
arm <- c(rep("A", 5), rep("B", 5))



ft <- fibble(subjid, name, sex, age, arm)
ft
class(ft)

arm_decode <- c(A = "Treatment A", B = "Treatment B")

attr(ft$arm, "format") <- arm_decode
str(ft$arm)
attr(ft$sex, "format") <- sex_fmt
str(ft$sex)



format(ft)








is.null(attr(ft$subjid, "format"))

sex_fmt(ft$sex)

res <- sapply(ft$sex, sex_fmt)


# Create data frame
df <- data.frame(subjid, name, sex, age, arm)
df


f <- fibble(df)
f
trunc_mat()
class(f)
# 
# 
ft <- fibble(tibble(df))
ft

class(ft)

tibble(mtcars)
ft$format <-


txt<-"test"
for(col in 29:47){ cat(paste0("\033[0;", col, "m", col, txt,"\033[0m","\n"))}

cat(paste0("\033[0;", "37", "m", "hello","\033[0m","\n"))


