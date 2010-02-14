rcumsum <- function(x) {
 x_right_shifted <- c(0,x[1:(length(x)-1)])
 x - x_right_shifted
}

hue_scale = c("#FF6C91", "#BC9D01", "#00BC57", "#00B8E5", "#CD79FF")

num_classifiers = 5
num_test_runs = 7
m = matrix(nrow=num_classifiers, ncol=num_test_runs)

data = read.csv('results.csv')

png("g20.png", width = 800, height = 480, bg = "transparent")
data_training = data[data$training==20,]

for(n in 1:7) {
	run_stats = as.vector(data_training[n,][,2:6], mode='numeric')	
#	m[,n] = rcumsum(run_stats)
	m[,n] = run_stats
}

# Expand right side of clipping rect to make room for the legend
# (from http://www.harding.edu/fmccown/R/)
par(mar=c(5, 4, 4, 2) + 0.1)
par(xpd=T, mar=par()$mar+c(0,0,0,5))
barplot(m, ylim=0:1, col=hue_scale)
legend(8.75,0.75, rev(names(data)[2:6]), fill=rev(hue_scale))
title("semi supervised naive bayes")
dev.off()


