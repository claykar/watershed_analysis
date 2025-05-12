#####
# Clay Karnis
#
# find land cover percent change 
# find change in runoff risk 
#####

require(ggplot2)
require(tidyr)
require(dplyr)
require(ggthemes)

#####

years <- 1985:2023

years_table <- data.frame()

for (y in years) {
  year_table <- read.csv(paste0("./out_puts/lc_stats_", y, ".csv"))
  year_table$year <- y
  year_table <- year_table[, !(names(year_table) %in% c("OID_", "NoData"))]
  years_table <- rbind(years_table, year_table)
}

rm(y)
rm(year_table)
###

base_1985 <- years_table |> filter(year == 1985)

years_table <- years_table |>
  mutate(across(-year, ~ (. - base_1985[[cur_column()]]) / base_1985[[cur_column()]] * 100))

#####
years <- 1985:2023

risk_table <- data.frame(
  year = integer(),
  risk = numeric()
)


for (y in years) {
  r_years_table <- read.csv(paste0("./out_puts/runoff_stats_", y, ".csv"))
  weighted_mean_risk <- sum(r_years_table$COUNT * r_years_table$MEAN) / sum(r_years_table$COUNT)
  risk_table <- rbind(risk_table, data.frame(year = y, risk = weighted_mean_risk))
}

rm(y)
rm(r_years_table)
rm(weighted_mean_risk)
rm(years)
###

base_1985 <- risk_table |> filter(year == 1985)

risk_table <- risk_table |>
  mutate(across(-year, ~ (. - base_1985[[cur_column()]]) / base_1985[[cur_column()]] * 100))

rm(base_1985)

whole_table <- left_join(years_table, risk_table, by = "year")

whole_table <- whole_table |>
  pivot_longer(cols = -year, names_to = "type", values_to = "percent_change")

nat_lc <- whole_table |> filter(type %in% c("risk", "C_41",  "C_42",  "C_43", "C_90", "C_95"))


dev_lc <- whole_table |> filter(type %in% c("risk", "C_21", "C_22", "C_23", "C_24"))

unnat_lc <- whole_table |> filter(type %in% c("risk", "C_31", "C_81", "C_82", "C_52", "C_71"))

#####





unnat_line_plot <- ggplot(unnat_lc, aes(x = year, y = percent_change, color = type)) +
  geom_line() +
  geom_point() +
  theme_economist() +
  scale_color_manual(
    values = c("risk" = "red", "C_31" = "grey",  "C_81" = "goldenrod3",  
               "C_82" = "darkkhaki", "C_52" = "darkolivegreen3", "C_71" = "lightgreen"),
    labels = c("risk" = "Runoff Risk", "C_31" = "Barren Land (Rock/Sand/Clay)",  "C_81" = "Pasture/Hay",  
               "C_82" = "Cultivated Crops", "C_52" = "Shrub/Scrub", "C_71" = "Grassland/Herbaceous")
  ) +
  theme(legend.position = "right",
        legend.title = element_text(size = 12,
                                    face = "bold",
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5),
        legend.text = element_text(size = 10,
                                   family = "sans",
                                   hjust = 0.5,
                                   vjust = 0.5),
        axis.title.x = element_text(size = 14,
                                    face = "bold", 
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5, 
                                    angle = 0,
                                    margin = margin(t = 20)),
        axis.title.y = element_text(size = 14,
                                    face = "bold", 
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5, 
                                    angle = 90,
                                    margin = margin(r = 20)),
        axis.text.x = element_text(size = 12,
                                   family = "sans",
                                   hjust = 0.5,
                                   vjust = 0.5, 
                                   angle = 0),
        axis.text.y = element_text(size = 12,
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
  labs(title = "Change in Land Cover Types from 1985",
       x = "Year",
       y = "Percent Change (%)",
       color = "Land Cover Class") 

ggsave("./unnat_lc_plot.png", unnat_line_plot,
       width = 8, 
       height = 5, 
       units = "in", 
       dpi = 600)




dev_line_plot <- ggplot(dev_lc, aes(x = year, y = percent_change, color = type)) +
  geom_line() +
  geom_point() +
  theme_economist() +
  scale_color_manual(
    values = c("risk" = "red", "C_21" = "gray74",  "C_22" = "gray41",  
               "C_23" = "gray28", "C_24" = "black"),
    labels = c("risk" = "Runoff Risk", "C_21" = "Developed, Open Space",  "C_22" = "Developed, Low Intensity",  
               "C_23" = "Developed, Medium Intensity", "C_24" = "Developed High Intensity")
  ) +
  theme(legend.position = "right",
        legend.title = element_text(size = 12,
                                    face = "bold",
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5),
        legend.text = element_text(size = 10,
                                   family = "sans",
                                   hjust = 0.5,
                                   vjust = 0.5),
        axis.title.x = element_text(size = 14,
                                    face = "bold", 
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5, 
                                    angle = 0,
                                    margin = margin(t = 20)),
        axis.title.y = element_text(size = 14,
                                    face = "bold", 
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5, 
                                    angle = 90,
                                    margin = margin(r = 20)),
        axis.text.x = element_text(size = 12,
                                   family = "sans",
                                   hjust = 0.5,
                                   vjust = 0.5, 
                                   angle = 0),
        axis.text.y = element_text(size = 12,
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
  labs(title = "Change in Developed Land Cover Types from 1985",
       x = "Year",
       y = "Percent Change (%)",
       color = "Land Cover Class")

ggsave("./dev_lc_plot.png", dev_line_plot,
       width = 8, 
       height = 5, 
       units = "in", 
       dpi = 600)



nat_line_plot <- ggplot(nat_lc, aes(x = year, y = percent_change, color = type)) +
  geom_line() +
  geom_point() +
  theme_economist() +
  scale_color_manual(
    values = c("risk" = "red", "C_41" = "darkgreen",  "C_42" = "chartreuse4",  
               "C_43" = "green3", "C_90" = "lightseagreen", "C_95" = "mediumspringgreen"),
    labels = c("risk" = "Runoff Risk", "C_41" = "Deciduous Forest",  "C_42" = "Evergreen Forest",  
               "C_43" = "Mixed Forest", "C_90" = "Woody Wetlands", "C_95" = "Emergent Herbaceous Wetlands")
  ) +
  theme(legend.position = "right",
        legend.title = element_text(size = 12,
                                    face = "bold",
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5),
        legend.text = element_text(size = 10,
                                   family = "sans",
                                   hjust = 0.5,
                                   vjust = 0.5),
        axis.title.x = element_text(size = 14,
                                    face = "bold", 
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5, 
                                    angle = 0,
                                    margin = margin(t = 20)),
        axis.title.y = element_text(size = 14,
                                    face = "bold", 
                                    family = "sans",
                                    hjust = 0.5,
                                    vjust = 0.5, 
                                    angle = 90,
                                    margin = margin(r = 20)),
        axis.text.x = element_text(size = 12,
                                   family = "sans",
                                   hjust = 0.5,
                                   vjust = 0.5, 
                                   angle = 0),
        axis.text.y = element_text(size = 12,
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
  labs(title = "Change in Natural Land Cover Types from 1985",
       x = "Year",
       y = "Percent Change (%)",
       color = "Land Cover Class")

ggsave("./nat_lc_plot.png", nat_line_plot,
       width = 8, 
       height = 5, 
       units = "in", 
       dpi = 600)


