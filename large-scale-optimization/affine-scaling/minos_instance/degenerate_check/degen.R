library(readxl)
probs596 <- read_excel("probs596.xlsx", col_names = FALSE)
a=0
for (i in 1:nrow(probs596[,2])) {
  if (probs596[i,2]<0.00001){
    a = a + 1
  }
}

# p596: degeneration?
138-56<a   # TRUE: degeneration
# variables degenerated
a-(138-56) # 1

probs597 <- read_excel("probs597.xlsx", col_names = FALSE)
b=0
for (i in 1:nrow(probs597[,2])) {
  if (probs597[i,2]<0.00001){
    b = b + 1
  }
}

# p597: degeneration?
51-27<b   # TRUE: degeneration
# variables degenerated
b-(51-27) # 9


probs598 <- read_excel("probs598.xlsx", col_names = FALSE)
c=0
for (i in 1:nrow(probs598[,2])) {
  if (probs598[i,2]<0.00001){
    c = c + 1
  }
}

# p598: degeneration?
615-488<c   # TRUE: degeneration
# variables degenerated
c-(615-488) # 34

