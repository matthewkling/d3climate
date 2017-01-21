library(raster)
library(colormap)

clim <- getData("worldclim", var="bio", res=10)
clim <- subset(clim, c("bio1", "bio12"))
clim$bio1 <- clim$bio1 / 100
clim$bio12 <- log10(clim$bio12)

clim <- aggregate(clim, 20)

d <- as.data.frame(rasterToPoints(clim))
id = 1:nrow(d)
d <- cbind(id, d)

d <- na.omit(d)
d$bio12[!is.finite(d$bio12)] <- min(d$bio12[is.finite(d$bio12)])

d$climColor <- colorwheel2d(d[,c("bio1", "bio12")], kernel=sqrt)
d$geoColor <- colorwheel2d(d[,c("x", "y")], kernel=sqrt)

write.csv(d, "~/documents/d3/d3climate/climate.csv", row.names=F)
