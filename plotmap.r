#http://bcb.dfci.harvard.edu/~aedin/courses/R/CDC/maps.html

require(maps)
data(county.fips)

costs <- read.table("temp.csv", header=FALSE, sep=";")
#temp.csv should be in fip; name; $ form:
#1001; Autauga County;18509
#1003; Baldwin County;18232
#1005; Barbour County;16909
#1007; Bibb County;19140

#should be one color for each range of values
colors = c("#333333", "#334433", "#335533", "#336633", "#337733", "#338833", "#339933", "#33aa33", "#33bb33", "#33cc33", "#33dd33", "#33ee33", "#00ff00")
costs$colorBuckets <- as.numeric(cut(costs$V3, c(0, 15000, 16000, 17000, 18000, 19000, 20000, 21000, 22000, 23000, 24000, 25000, 27000, 30000)))


#These 4 counties are newish, and were messing up the plot:
#fips  index   name
#35061 1797 Valencia, NM
#04012 0074 La Paz, AZ
#55078 3030 Menominee, WI
#08014 0223 Broomfield, CO
#they are at the end of the list not in the middle where they belong.
#even though we match on county.fips here they were still wrong.
#so we instead remove them with some splices and put them at the end of the vector
y <- costs$colorBuckets[match(county.fips$fips, costs$V1)]
colorsmatched = c(y[1:73], y[75:222], y[224:1796], y[1798:3029], y[3031:3085], y[1797], y[74], y[3030],y[223])
#colorsmatched = y


png(file = "map.png", width = 1400, height = 1000)
map("county", col = colors[colorsmatched], fill = TRUE, resolution = 0, lty = 0, projection = "polyconic") #plot counties
map("county", col = "white", fill = FALSE, add = TRUE, lty = 1, lwd = 0.2, projection = "polyconic") #plot thin white lines for county borders
map("state", col = "white", fill = FALSE, add = TRUE, lty = 1, lwd = 1, projection = "polyconic") #plot thicker white lines for state borders
title(sub="data source: http://livingwage.mit.edu/") #text goes at bottom of plot
title("Cost of living by county", cex.main=2) #main title
mtext("single adult, thousands of dollars per year") #subtitle, goes right below main title
legend("bottom", c("<15", "15-16", "16-17", "17-18", "18-19", "19-20", "20-21", "21-22", "22-23", "23-24", "24-25", "25-27", ">27"), horiz = TRUE, fill = colors)
dev.off() #explort to png

