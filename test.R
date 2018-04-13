script.dir <- dirname(sys.frame(1)$ofile)

cat(script.dir)

sys.frame()
source("merge.R", chdir = T)



