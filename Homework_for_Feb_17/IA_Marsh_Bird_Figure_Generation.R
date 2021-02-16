##########################################
###R Data Visualization: Feb. 17th 2021###
##########################################

#################
###Description###
#################

##This code generates figures in ggplot that represent relationships between 
##variables from a dataset containing marsh bird survey data collected in 
##2016 and 2017 in Iowa marshes by Vanausdall et al. 2020:
##https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0227825#sec010

###############################################
###Load necessary packages and set directory###
###############################################

library(ggplot2)
library(dplyr)
setwd(choose.dir()) #easier than writing out full dir

################################
###Read in data and summarize###
################################

#Two separate datasets that both pertain to point counts
data.1<-read.csv("MAWR_YHBL_RWBL_COYE_SWSP_Data.csv")
data.2<-read.csv("VIRA_PBGR_Data.csv")

head(data.1) ; head(data.2) #Inspecting
data.2$CallNum<-NULL #Removing CallNum variable because irrelevant for most spp.

data<-rbind(data.1,data.2) #combining datasets
rm(data.1, data.2) #clean workspace

#Renaming ABA 4-letter codes to full common name
data$Species[data$Species == "RWBL" ] <- "Red-winged Blackbird"
data$Species[data$Species == "PBGR" ] <- "Pied-billed Grebe"
data$Species[data$Species == "COYE" ] <- "Common Yellowthroat"
data$Species[data$Species == "SWSP" ] <- "Swamp Sparrow"
data$Species[data$Species == "VIRA" ] <- "Virginia Rail"
data$Species[data$Species == "YHBL" ] <- "Yellow-headed Blackbird"

#Summarize to create counts of each species by restoration type
data$Count<-1 #every row corresponds to one individual

sum.data<-data %>%
  group_by(Species, RestorationState) %>%
  summarise(sum(Count))

sum.data<-as.data.frame(sum.data)

#Renaming columns to appropriate names
colnames(sum.data)<-c("Species", "RestorationState", "Count")

#Change order of categorical variable (restoration type)
sum.data$RestorationState<- factor(sum.data$RestorationState,
                                   levels = c("Not restored", "1-5 years", "6-11 years"))
###############################
###Visualizing Relationships###
###############################

#Side-by-side bars showing counts for each species by restoration state
pdf(file = "Side_by_Side_Bars_IA_Marshbirds.pdf", w=11)
ggplot(sum.data, aes(Species, Count, fill = RestorationState)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(y = "Number of Birds Observed", fill = "Restoration State",
       title = "Marshbird Communities by Restoration Type") +
  theme_custom() +
  scale_fill_brewer(palette = "Dark2") +
  scale_y_continuous(breaks = seq(0, 400, 100))
dev.off()

#Stacked bars showing spread of species counts by restoration state type
sum.data$Percent<-NA
sum.data$Percent[which(sum.data$RestorationState=="1-5 years")]<-sum.data$Count[which(sum.data$RestorationState=="1-5 years")]/sum(sum.data$Count[which(sum.data$RestorationState=="1-5 years")])
sum.data$Percent[which(sum.data$RestorationState=="6-11 years")]<-sum.data$Count[which(sum.data$RestorationState=="6-11 years")]/sum(sum.data$Count[which(sum.data$RestorationState=="6-11 years")])
sum.data$Percent[which(sum.data$RestorationState=="Not restored")]<-sum.data$Count[which(sum.data$RestorationState=="Not restored")]/sum(sum.data$Count[which(sum.data$RestorationState=="Not restored")])

#Stacked bars showing spread of species counts by restoration state type
pdf(file = "Stacked_Bars_IA_Marshbirds.pdf", w=11)
ggplot(sum.data, aes(RestorationState, Percent, fill = Species)) +
  geom_bar(position = "stack", stat = "identity", color = "grey") +
  labs(x = "Years Since Restoration", y = "Proportion of Total Birds Observed", 
       title = "Marshbird Communities by Restoration Type") +
  theme_custom_2() +
  scale_fill_brewer(palette = "Set1")
dev.off()

######################################
##Custom themes for plots (could probably be condensed some but looks pretty good)
theme_custom <- function (base_size = 12, base_family = "serif") {
  half_line <- base_size/2
  theme(
    line = element_line(color = "black", size = .5,
                        linetype = 1, lineend = "butt"),
    rect = element_rect(fill = "white", color = "black",
                        size = .5, linetype = 1),
    text = element_text(family = base_family, face = "plain",
                        color = "black", size = base_size,
                        lineheight = .9, hjust = .5, vjust = .5,
                        angle = 0, margin = margin(), debug = FALSE),
    axis.line = element_blank(),
    axis.text = element_text(size = base_size * 1.1, color = "gray10"),
    axis.text.x = element_text(angle = 45, margin = margin(t = .8 * half_line/2),
                               vjust = 1, hjust = 1),
    axis.text.x.top = element_text(margin = margin(b = .8 * half_line/2),
                                   vjust = 0),
    axis.text.y = element_text(margin = margin(r = .8 * half_line/2),
                               hjust = 1),
    axis.text.y.right = element_text(margin = margin(l = .8 * half_line/2),
                                     hjust = 0),
    axis.ticks = element_line(color = "gray30", size = .7),
    axis.ticks.length = unit(half_line / 1.5, "pt"),
    axis.title.x = element_text(margin = margin(t = half_line),
                                vjust = 1, size = base_size * 1.3),
    axis.title.x.top = element_text(margin = margin(b = half_line),
                                    vjust = 0),
    axis.title.y = element_text(angle = 90, vjust = 1,
                                margin = margin(r = half_line),
                                size = base_size * 1.3),
    axis.title.y.right = element_text(angle = -90, vjust = 0,
                                      margin = margin(l = half_line)),
    legend.background = element_rect(color = "gray30"),
    legend.spacing = unit(.4, "cm"),
    legend.margin = margin(.2, .2, .2, .2, "cm"),
    legend.key = element_rect(fill = "gray95", color = "white"),
    legend.key.size = unit(1.2, "lines"),
    legend.text = element_text(size = rel(.8)),
    legend.title = element_text(hjust = 0),
    legend.position = "right",
    legend.justification = "center",
    legend.box.margin = margin(0, 0, 0, 0, "cm"),
    legend.box.background = element_blank(),
    legend.box.spacing = unit(.4, "cm"),
    panel.background = element_rect(fill = "white", color = NA),
    panel.border = element_rect(color = "gray30",
                                fill = NA, size = .7),
    panel.grid.major.y = element_line(color = "gray30", size = .5,
                                    linetype = "dashed"),
    panel.grid.minor = element_blank(),
    panel.spacing = unit(base_size, "pt"),
    panel.ontop = FALSE,
    strip.background = element_rect(fill = "white", color = "gray30"),
    strip.text = element_text(color = "black", size = base_size),
    strip.text.x = element_text(margin = margin(t = half_line,
                                                b = half_line)),
    strip.text.y = element_text(angle = -90,
                                margin = margin(l = half_line,
                                                r = half_line)),
    strip.text.y.left = element_text(angle = 90),
    strip.placement = "inside",
    strip.switch.pad.grid = unit(0.1, "cm"),
    strip.switch.pad.wrap = unit(0.1, "cm"),
    plot.background = element_rect(color = NA),
    plot.title = element_text(size = base_size * 1.6, hjust = .5,
                              vjust = 1, face = "bold",
                              margin = margin(b = half_line * 1.2)),
    plot.title.position = "panel",
    plot.margin = margin(base_size, base_size, base_size, base_size),
    complete = TRUE
  )
}

##Custom themes for plots (could probably be condensed some but looks pretty good)
theme_custom_2 <- function (base_size = 12, base_family = "serif") {
  half_line <- base_size/2
  theme(
    line = element_line(color = "black", size = .5,
                        linetype = 1, lineend = "butt"),
    rect = element_rect(fill = "white", color = "black",
                        size = .5, linetype = 1),
    text = element_text(family = base_family, face = "plain",
                        color = "black", size = base_size,
                        lineheight = .9, hjust = .5, vjust = .5,
                        angle = 0, margin = margin(), debug = FALSE),
    axis.line = element_blank(),
    axis.text = element_text(size = base_size * 1.1, color = "gray10"),
    axis.text.x = element_text(margin = margin(t = .8 * half_line/2),
                               vjust = 1),
    axis.text.x.top = element_text(margin = margin(b = .8 * half_line/2),
                                   vjust = 0),
    axis.text.y = element_text(margin = margin(r = .8 * half_line/2),
                               hjust = 1),
    axis.text.y.right = element_text(margin = margin(l = .8 * half_line/2),
                                     hjust = 0),
    axis.ticks = element_line(color = "gray30", size = .7),
    axis.ticks.length = unit(half_line / 1.5, "pt"),
    axis.title.x = element_text(margin = margin(t = half_line),
                                vjust = 1, size = base_size * 1.3),
    axis.title.x.top = element_text(margin = margin(b = half_line),
                                    vjust = 0),
    axis.title.y = element_text(angle = 90, vjust = 1,
                                margin = margin(r = half_line),
                                size = base_size * 1.3),
    axis.title.y.right = element_text(angle = -90, vjust = 0,
                                      margin = margin(l = half_line)),
    legend.background = element_rect(color = "gray30"),
    legend.spacing = unit(.4, "cm"),
    legend.margin = margin(.2, .2, .2, .2, "cm"),
    legend.key = element_rect(fill = "gray95", color = "white"),
    legend.key.size = unit(1.2, "lines"),
    legend.text = element_text(size = rel(.8)),
    legend.title = element_text(hjust = 0),
    legend.position = "right",
    legend.justification = "center",
    legend.box.margin = margin(0, 0, 0, 0, "cm"),
    legend.box.background = element_blank(),
    legend.box.spacing = unit(.4, "cm"),
    panel.background = element_rect(fill = "white", color = NA),
    panel.border = element_rect(color = "gray30",
                                fill = NA, size = .7),
    panel.grid.major.y = element_line(color = "gray30", size = .5,
                                    linetype = "dashed"),
    panel.grid.minor = element_blank(),
    panel.spacing = unit(base_size, "pt"),
    panel.ontop = FALSE,
    strip.background = element_rect(fill = "white", color = "gray30"),
    strip.text = element_text(color = "black", size = base_size),
    strip.text.x = element_text(margin = margin(t = half_line,
                                                b = half_line)),
    strip.text.y = element_text(angle = -90,
                                margin = margin(l = half_line,
                                                r = half_line)),
    strip.text.y.left = element_text(angle = 90),
    strip.placement = "inside",
    strip.switch.pad.grid = unit(0.1, "cm"),
    strip.switch.pad.wrap = unit(0.1, "cm"),
    plot.background = element_rect(color = NA),
    plot.title = element_text(size = base_size * 1.6, hjust = .5,
                              vjust = 1, face = "bold",
                              margin = margin(b = half_line * 1.2)),
    plot.title.position = "panel",
    plot.margin = margin(base_size, base_size, base_size, base_size),
    complete = TRUE
  )
}

