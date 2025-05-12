#####
# Clay Karnis
#
# sankey diagram for land cover change from type to type
#####

require(ggplot2)
require(ggalluvial)
require(ggthemes)
require(dplyr)
require(tidyr)


lc_85_to_04 <- read.csv("./out_puts/lc_t_1985_2004.csv")
lc_04_to_23 <- read.csv("./out_puts/lc_t_2004_2023.csv")

colnames(lc_85_to_04) <- c("Count_85_04", "From_85", "To_04")
colnames(lc_04_to_23) <- c("Count_04_23", "From_04", "To_23")


transition_data <- merge(lc_85_to_04, lc_04_to_23, by.x = "To_04", by.y = "From_04")

transition_data$Count <- pmin(transition_data$Count_85_04, transition_data$Count_04_23)

transition_data$Count <- pmin(transition_data$Count_85_04, transition_data$Count_04_23)

landcover_lookup <- data.frame(
  code = c(11, 21, 22, 
           23, 24, 31, 
           41, 42, 43, 
           52, 71, 81, 
           82, 90, 95),
  name = c("Water", "Developed - Open Space", "Developed - Low Intensity", 
           "Developed - Medium Intensity", "Developed - High Intensity","Barren Land", 
           "Deciduous Forest", "Evergreen Forest", "Mixed Forest",
           "Shrub", "Grassland", "Pasture", 
           "Cropland", "Woody Wetlands","Herb Wetlands")
)


final_data <- transition_data |>
  select(From_85, To_04, To_23, Count)

final_data <- final_data |>
  left_join(landcover_lookup, by = c("From_85" = "code")) |>
  rename(From_85_name = name) |>
  left_join(landcover_lookup, by = c("To_04" = "code")) |>
  rename(To_04_name = name) |>
  left_join(landcover_lookup, by = c("To_23" = "code")) |>
  rename(To_23_name = name) |>
  drop_na() |>
  filter(
    From_85_name != "Water",
    To_04_name != "Water",
    To_23_name != "Water"
  )

#####
s_plot <- ggplot(final_data,
       aes(axis1 = From_85_name, axis2 = To_04_name, axis3 = To_23_name, y = Count)) +
  geom_alluvium(aes(fill = From_85_name)) +
  geom_stratum(aes(fill = after_stat(stratum))) +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)), size = 3) +
  scale_x_discrete(limits = c("1985", "2004", "2023"), expand = c(0.1, 0.1)) +
  scale_fill_manual(
    values = c("Developed - Open Space" = "brown1", "Developed - Low Intensity" = "brown2", 
               "Developed - Medium Intensity" = "brown3", "Developed - High Intensity" = "brown4",
               "Barren Land" = "gray60", "Deciduous Forest" = "forestgreen", 
               "Evergreen Forest" = "darkgreen", "Mixed Forest" = "olivedrab4", 
               "Shrub" = "yellow4", "Grassland" = "yellowgreen", 
               "Pasture" = "yellow2", "Cropland" = "tan3", 
               "Woody Wetlands" = "turquoise3","Herb Wetlands" = "mediumaquamarine")
  ) +
  theme_economist() +
  theme(legend.position = "none", 
        panel.grid.major = element_blank(),   
        panel.grid.minor = element_blank(),          
        axis.title.y = element_blank(),       
        axis.text.y = element_blank(),       
        axis.ticks.y = element_blank(),
        axis.title.x = element_text(size = 14,
                                    face = "bold", 
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5, 
                                    angle = 0,
                                    margin = margin(t = 20)),
        
        axis.text.x = element_text(size = 12,
                                   family = "sans",
                                   hjust = 0.5,
                                   vjust = 0.5, 
                                   angle = 0),
        plot.title = element_text(size = 16, 
                                  face = "bold", 
                                  family = "sans", 
                                  hjust = 0.5, 
                                  vjust = 0.5),
        plot.caption = element_text(size = 8,
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5),
        plot.caption.position = "panel") +
  labs(title = "Land Cover Transitions from 1985 - 2004 - 2023")

ggsave("./s_plot.png", s_plot,
       width = 10, 
       height = 8, 
       units = "in", 
       dpi = 600)





