#------------------------------------------------------------------------------#
## Project :  Wastewater
## Purpose :  Makes the FIO vs N figures
##  Date   :  07/08/2020
## Author  :  Gordon Blasco
#------------------------------------------------------------------------------#
# FINAL FIGURE 4 SCRIPT
#### Libraries & Data ####
#------------------------------------------------------------------------------#
library(tidyverse)
library(sf)
library(patchwork)
library(ggpubr)
library(ggrepel)

FIO_sheds <- sf::read_sf("/home/shares/ohi/git-annex/land-based/wastewater/data/processed/FIO_effluent_output/effluent_FIO_watersheds.shp")
N_sheds <- sf::read_sf("/home/shares/ohi/git-annex/land-based/wastewater/data/processed/N_effluent_output/effluent_N_watersheds_all.shp")

#### prep data ####
#------------------------------------------------------------------------------#
 

FIO_tidy <- FIO_sheds %>% 
  st_set_geometry(NULL) %>% 
  select(basin_id, effluent) %>% 
  rename(fio = effluent)

N_tidy <- N_sheds %>% 
  st_set_geometry(NULL) %>% 
  select(basin_id, tot_N) %>% 
  rename(n = tot_N) %>% 
  left_join(FIO_tidy) %>% 
  filter(fio != 0 & n != 0)

N_zoomed <- N_tidy %>% 
  arrange(-n) %>% 
  tail((nrow(N_tidy)-100)) %>% # remove top 100 nitrogen obs
  arrange(-fio) %>% 
  tail((nrow(.)-5))# remove top 5 remaining fio obs

#### add lm info ####
#------------------------------------------------------------------------------#

n_linear <- N_tidy

fit <- lm(n~fio, data = n_linear)


n_linear$predicted <- predict(fit)   # Save the predicted values
n_linear$residuals <- residuals(fit) # Save the residual values
sd_residuals<-sd(residuals(fit))


n_lm_plotted <- n_linear %>% 
  mutate(outside_sd = case_when(residuals >= sd_residuals ~"above",
                                residuals <= -sd_residuals ~ "below",
                                T~"inside")) %>% 
  select(basin_id, outside_sd)

N_plot <- N_tidy %>% left_join(n_lm_plotted)
Z_plot <- N_zoomed %>% left_join(n_lm_plotted)

#### plot it up! ####
#------------------------------------------------------------------------------#



alph_val = .3



n <- ggplot(N_plot, aes(x = fio, y = n/1000))+
  geom_point(alpha = alph_val, aes(color = outside_sd))+
  #geom_abline()+
  geom_smooth(method = "lm")+
  # coord_fixed(ratio=1/100000)+
  labs(
    x = "FIO (unitless)",
    y = "Nitrogen (kg)",
    title = "Watershed level totals of Nitrogen and FIO's compared"
  )+
  theme_bw()


z <- ggplot(Z_plot, aes(x = fio, y = n/1000))+
  geom_point(alpha = alph_val, aes(color = outside_sd))+
  #geom_abline()+
  geom_smooth(method = "lm")+
  #coord_fixed()+
  labs(
    x = "FIO (unitless)",
    y = "Nitrogen (kg)",
    title = "Zoomed in"
  )+
  theme_bw()

N_plot %>%
  group_by(outside_sd) %>%
  summarise(
    n()
  )
Z_plot %>%
  group_by(outside_sd) %>%
  summarise(
    n()
  )

n|z +
  plot_layout(guides = 'collect')


outlier_sheds <- N_plot %>% 
  filter(outside_sd != "inside") 

plot_outlier_sheds <- N_sheds %>% 
  inner_join(outlier_sheds)

plot(plot_outlier_sheds["outside_sd"], key.pos = 1)








residual_shades <- N_sheds %>% 
  inner_join(n_linear) %>% 
  left_join(n_lm_plotted) %>% 
  mutate(zscore = residuals/sd(residuals),
         sd_score = case_when(
           zscore <=  0.1 & zscore >= -0.1 ~  0,
           zscore <=  1   & zscore >   0.1 ~  1,
           zscore >= -1   & zscore <  -0.1 ~ -1,
           zscore <=  2   & zscore >   1   ~  2,
           zscore >= -2   & zscore <  -1   ~ -2,
           zscore <=  3   & zscore >   2   ~  3,
           zscore >= -3   & zscore <  -2   ~ -3,
           zscore >   3                    ~  4,
           zscore <   3                    ~ -4
         ),
         sd_score = factor(sd_score, levels = c(4, 3 ,2 ,1, 0, -1 , -2, -3, -4)))# %>% 
  #filter(sd_score == "3")

#plot(residual_shades["outside_sd"], key.pos = 1)
#plot(residual_shades["residuals"], key.pos = 1)


map <- ggplot(residual_shades)+
  geom_sf(aes(fill = sd_score), size = 0.1)+
  theme_classic()+
  #labs(subtitle = "Septic")
  theme(legend.position = "bottom")+
  #labs(subtitle = "D) Open")+
  #theme(plot.subtitle = element_text(hjust = 0.5))+
  # scale_fill_gradient2(low = "red",
  #                      mid = "green",
  #                      high = "blue",
  #                      midpoint = 0)
  scale_fill_brewer(palette = "Spectral",
                    #direction = -1,
                    label = c("> 4", "3", "2", "1", "0", "-1", "-2", "-3", "< -4" ))+
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())+
  guides(fill = guide_legend(nrow = 1,
                             reverse = TRUE,
                             title.position = "top",
                             title.hjust = .5,
                             # title.vjust = .75,
                             label.position = "bottom"))+
  labs(
    title = "A)",
    fill =  "Standard Deviation Range"
  )
map

map_legends <- map + labs(fill = "High N  High FIO")+
  guides(fill = guide_legend(nrow = 1,
                             reverse = TRUE,
                             title.position = "left",
                             title.hjust = .5,
                             title.vjust = .79,
                             label.position = "bottom"))

map_legends

ggplot(residual_shades %>% group_by(sd_score) %>% slice(1) %>% ungroup())+
  geom_sf(aes(fill = sd_score))+
  theme_classic()+
  #labs(subtitle = "Septic")
  theme(legend.position = "bottom")+
  #labs(subtitle = "D) Open")+
  #theme(plot.subtitle = element_text(hjust = 0.5))+
  # scale_fill_gradient2(low = "red",
  #                      mid = "green",
  #                      high = "blue",
  #                      midpoint = 0)
  scale_fill_brewer(palette = "Spectral",
                    label = c("> 4", "3", "2", "1", "0", "-1", "-2", "-3", "< -4" ),
                    guide = guide_legend(reverse = TRUE))+
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())+
  guides(fill = guide_legend(nrow = 1,
                             title.position = "left",
                             reverse = TRUE,
                             title.hjust = .5,
                             title.vjust = .79,
                             label.position = "bottom"))+
  labs(
    title = "A)",
    fill =  "High FIO"
  )

ggplot(residual_shades %>% arrange(-n) %>% head(5))+
  geom_sf(aes(fill = sd_score))+
  theme_classic()+
  #labs(subtitle = "Septic")
  theme(legend.position = "bottom")+
  #labs(subtitle = "D) Open")+
  #theme(plot.subtitle = element_text(hjust = 0.5))+
  # scale_fill_gradient2(low = "red",
  #                      mid = "green",
  #                      high = "blue",
  #                      midpoint = 0)
  scale_fill_brewer(palette = "Spectral",
                    label = c("> 4", "3", "2", "1", "0", "-1", "-2", "-3", "< -4" ),
                    guide = guide_legend(reverse = TRUE))+
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())+
  guides(fill = guide_legend(nrow = 1,
                             title.position = "left",
                             reverse = TRUE,
                             title.hjust = .5,
                             title.vjust = .79,
                             label.position = "bottom"))+
  labs(
    title = "A)",
    fill =  "High FIO"
  )



#### new_scatter ####
#------------------------------------------------------------------------------#

info <- residual_shades %>% 
  mutate(area = st_area(.)) %>% 
  st_set_geometry(NULL)

N_plot <- N_tidy %>% left_join(info)
Z_plot <- N_zoomed %>% left_join(info)

alph_val = .5


min_val <- min(Z_plot$area)
max_val <- max(N_plot$area)

z_mid_val_y <- (max(Z_plot$n)/1000)/2
z_mid_val_x <- max(Z_plot$fio, na.rm = TRUE)/2

h_vline_color = "grey60"

bb <- c(5e+05, 5e+010, 1e+012, 4e+012,max_val)

ll <- c("0.5", "5e+04", "1e+06", "4e+06", "6e+06")


N_plot_labs <- N_plot %>% 
  mutate(labels_names = case_when(
    basin_id == "al_12731" ~ "Shanghai",
    basin_id == "al_13237" ~ "Meghna River",
    basin_id == "al_13478" ~ "Shenwan",
    basin_id == "af_16862" ~ "Alexandria"
  ))


n <- ggplot(N_plot_labs, aes(x = fio, y = n/1000))+
  geom_vline(xintercept = z_mid_val_x, color = h_vline_color)+
  geom_hline(yintercept = z_mid_val_y, color = h_vline_color)+
  geom_point(aes(fill = sd_score,
                 size = area,
                 color = abs(as.integer(as.character(sd_score)))),
             stroke = .5,
             #alpha = alph_val,
             pch=21)+
  scale_color_gradient(low = "grey60", 
                       high = "grey30")+
  scale_fill_brewer(palette = "Spectral")+
  geom_smooth(method = "lm")+
  labs(
    x = "FIO (unitless)",
    y = "Nitrogen (kg)",
    size = "Km Squared",
    title = "B)"
  )+
  theme_bw()+
 # theme(legend.position = "none") +
  guides(
    colour =FALSE,
    fill = FALSE
  )+
  theme(panel.grid = element_blank())+
  scale_size_continuous(limits = c(min_val, max_val),
                        breaks = bb,
                        labels = ll)#+
  #geom_label_repel(aes(label = labels_names))
n

Z_plot_labs <- Z_plot %>% 
  mutate(labels_names = case_when(
    basin_id == "al_12879" ~ "Shenzhen",
    basin_id == "na_70998" ~ "New York",
    
    basin_id == "eu_30871" ~ "Istanbul",
    
    basin_id == "na_70998" ~ "New York"
  ))

check <- Z_plot %>% 
  filter(basin_id %in% c("sa_02859")) %>% 
  pull(basin_id)

z <- ggplot(Z_plot_labs, aes(x = fio, y = n/1000))+
  geom_vline(xintercept = z_mid_val_x, color = h_vline_color)+
  geom_hline(yintercept = z_mid_val_y, color = h_vline_color)+
  geom_point(aes(fill = sd_score,
                 size = area,
                 color = abs(as.integer(as.character(sd_score)))),
             stroke = .5,
             #alpha = alph_val,
             pch=21)+
  scale_color_gradient(low = "grey60", 
                        high = "grey30")+
  scale_fill_brewer(palette = "Spectral")+
  geom_smooth(method = "lm")+
  labs(
    x ="FIO (unitless)",
    y ="Nitrogen (kg)",
    title = "C)"
  )+
  theme_bw()+
  scale_size_continuous(limits = c(min_val, max_val),
                        breaks = bb,
                        labels = ll)+
  scale_y_continuous(position = 'right') + 
   theme(legend.position = "none",
         #axis.title.y = element_text(position = "right"),
         panel.grid = element_blank()) +
  guides(
    colour =FALSE,
    fill = FALSE
  )#+
  #geom_label_repel(aes(label = labels_names))

z

n+z

x_plot <- Z_plot %>% group_by(sd_score) %>% sample_frac(.1) %>% ungroup()


ggplot(x_plot, aes(x = fio, y = n/1000))+
  geom_point(aes(fill = sd_score),
             color = "black",
             stroke = .11,
             pch=21)



N_plot %>% 
  group_by(outside_sd) %>% 
  summarise(
    n()
  )
Z_plot %>% 
  group_by(outside_sd) %>% 
  summarise(
    n()
  )


layout <- c(
  patchwork::area(t = 1, l = 1, b = 4, r = 4),
  patchwork::area(t = 5, l = 1, b = 6, r = 2),
  patchwork::area(t = 5, l = 3, b = 6, r = 4)
)
 
plot(layout)


figure_4_final <- map + n +z  + 
  #theme(strip.placement = NULL)+
  plot_layout(design = layout)

figure_4_final




ggsave(plot = figure_4_final, 
       device = "tiff",
       filename = "scratch/gordon/final_figures/figure_4.tiff",
       dpi = 300,
       units = "cm",
       width = 22,
       height = 22)



figure_4_legends <- map_legends + n +z  + 
  #theme(strip.placement = NULL)+
  plot_layout(design = layout)

figure_4_legends

ggsave(plot = figure_4_legends, 
       device = "tiff",
       filename = "scratch/gordon/final_figures/figure_4_legend_bits.tiff",
       dpi = 300,
       units = "cm",
       width = 22,
       height = 22)




#### N ####
#------------------------------------------------------------------------------#

N_norm <- info %>% 
  mutate(norm_n = tot_N/area) %>% 
  arrange(-norm_n)



mean(N_norm$norm_n)
sd(N_norm$norm_n)
