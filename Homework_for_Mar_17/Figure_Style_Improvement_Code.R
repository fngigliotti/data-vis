########################################
###R Data Visualization: Figure Style###
########################################

#Franco Gigliotti
#03/10/21

#################
###Description###
#################

#This code slightly modifies a figure from Darras et al. 2020 depicting relationships
#between true (known) bird distances and estimated bird distances from sound recordings
#collected by autonomous recording units (ARUs). The figure looks fairly nice as is,
#but some slight modifications can be made to improve the style of the figure.


##############################
###Load Packages and Set WD###
##############################

library(ggplot2)
library(colorspace)
setwd(choose.dir())

###############
###Load Data###
###############

load("distance1.R") 
#code to generate data not shown. 
#Available via https://datadryad.org/stash/dataset/doi:10.5061/dryad.h0qg353

##############
###Plotting###
##############

#First, inspect published plot (Figure 1 Darras et al. 2020)
pdf("Bird_Dist_Darras_et_al_2020.pdf", width = 11)
ggplot(distance1,aes(distance_m_direct,distance_audio,color=Species_call_type,label=ID))+
  geom_point(alpha=0.5)+
  scale_color_discrete(name="Bird species and call type")+
  stat_smooth(method="lm",se=F)+
  geom_abline(slope=1,intercept=0,lty=2)+
  labs(x="Measured distance to bird (m)",y="Estimated distance (m)\nto bird call in sound recording")+
  facet_grid(.~Estimator)+
  theme(legend.key.size = unit(2, 'lines'))
dev.off()

#List of desired modifications to plot:
###Modify levels so each species on same plot (4 plots showing 3 estimation types) 
###Change color palette to color-blind friendly
###Increase graphical redundancy (unique shapes and colors for species)
###Modify theme to reduce grid lines, change background color, fonts, legend
###Represent uncertainty in trendlines using shaded CIs

#Select colorblind friendly values
color.fill <- c("#009E73", "#F0E442", "#E69F00", "#CC79A7", 
                "#56B4E9", "#0072B2", "#D55E00", "#999999", "#000000")

#Legend labels
est.labels <- c("Naive Estimate", "Min Distance Known",
                "Min and Max\nDistance Known")
#Green, yellow, orange, pink, blue, dark blue, red, white, black

#New, updated plot
pdf(file = "Bird_Dist_Est.pdf", w = 11)
ggplot() +
  geom_point(data = distance1, aes(x = distance_m, 
    y = distance_audio, color = Estimator, fill = Estimator, shape = Estimator)) +
  stat_smooth(data = distance1 , method="lm",se=TRUE, size = 0.8,
    aes(x = distance_m, y = distance_audio, color = Estimator, fill = Estimator)) +
  geom_abline(slope = 1, intercept = 0, lty = 2, color = "gray30") +
  scale_color_manual(name = NULL, 
    labels = est.labels, values = darken(color.fill[c(4,3,1)], 0.3)) +
  scale_fill_manual(name = NULL, 
    labels = est.labels, values = color.fill[c(4,3,1)]) +
  scale_shape_manual(name = NULL, labels = est.labels, 
    values = c(21, 22, 24)) +
  labs(x="Known distance (m)",
    y="Estimated distance (m)", 
    title = "Accuracy of Bird Distance Estimates from Sound Recordings",
    color = "TEST") +
  theme(axis.text = element_text(color = "gray10"),  
    axis.title.x = element_text(vjust = 1, size = 14),
    axis.title.y = element_text(angle = 90, vjust = 1, size = 14),
    plot.title = element_text(hjust = 0.5, size = 17, face = "bold"),
    strip.text = element_text(face = "italic", hjust = 0.5, size = 12),
    legend.background = element_rect(color = "gray10", fill = "gray90"),
    legend.box.background = element_blank(),
    legend.title = element_text(hjust = 0, face = "bold"),
    panel.background = element_rect(fill = "white", color = NA),
    panel.border = element_rect(color = "gray50", fill = NA, size = 0.5),
    panel.grid.major = element_line(color = "gray80", size = .5),
    panel.grid.minor = element_blank()) +
  facet_wrap(.~Species)
dev.off()

##END
