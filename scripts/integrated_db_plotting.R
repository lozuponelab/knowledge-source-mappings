library(cowplot)
library(readxl)
library(stringr)
library(tidyverse)
library(stringr)

setwd('./')
full_edges <- read_csv('../data/expanded_edge_list.csv')
orig_edges <- read_xlsx('../data/Resource Interaction Table.xlsx', sheet = 1)

fill_deg <- max(full_edges$distance) + 1

nodes <- read_xlsx('../data/Resource Interaction Table.xlsx', sheet = 2)

nodes %>% 
  filter(category == 'General\nAggregate\nDB') %>% 
  pull(node) -> reffed_idbs

full_edges %>% 
  pull(distance) %>% 
  unique() %>% 
  factor() -> distance_factor

levels(distance_factor) <- rev(levels(distance_factor))
category_sorted <- c('Microbe', 'Protein', 
                     'Metabolites','Pathway','Disease',
                     'General Aggregate DB')

full_edges %>% 
  select(source, target, distance) %>% 
  mutate(distance = as.numeric(distance),
         distance = abs(distance - fill_deg)) %>% 
  spread(target, distance, fill = 0) -> edge_mat

source_order <- hclust(dist(edge_mat[,-1]))$order
source_sorted <- edge_mat[source_order,1]$source

full_edges %>% 
  merge(nodes, by.x = 'target', by.y = 'node') %>% 
  mutate(distance = factor(distance, levels = levels(distance_factor)),
         category = factor(category, levels = category_sorted),
         reffed_idbs = source %in% reffed_idbs,
         source_f = factor(source, 
                           levels = source_sorted)) -> plot_dat 

# New facet label names for category variable
category_labels <- c('Microbe'='Microbe', 'Protein'='Protein', 
                     'Metabolites'='Metabolite','Pathway'='PW','Disease'='Disease',
                     'General Aggregate DB'='General Aggregate DB')

plot_dat %>% 
  ggplot(aes(x = target, y = source_f, 
             fill = distance)) +
  geom_tile(color = 'black') +
  facet_grid(~category, scales = 'free', space = 'free',labeller = labeller(category = category_labels)) +
  theme_bw(base_size = 16) + 
  theme(axis.text.x = element_text(angle = 270 + 45,
                                   hjust = 0,
                                   vjust = 0.5),
      plot.title = element_text(size = 18, face = "bold"),
      #legend.position = "bottom",
      legend.text = element_text(size=10),
      legend.spacing.y = unit(0.5, 'cm')) +
  scale_fill_brewer(guide = guide_legend(reverse = TRUE,byrow=TRUE),
      labels = c(str_wrap("3 (indirect mapping through 2 resources)",width=25,exdent=2),
                 str_wrap("2 (indirect mapping through 1 resource)",width=25,exdent=2),
                 "1 (direct mapping)")) +
  labs(x = 'Primary Source',
       #y = 'Integrated Resource',
       y = 'General Aggregated Database',
       fill = 'Reference Degree',
       #title = 'Primary Source Mappings of all Integrated Resources') -> db_viz_final
       title = 'Primary Source Mappings of General Aggregated Databases') -> db_viz_final

ggsave('../db_viz_final.png',
       plot = db_viz_final,
       width = 12, 
       height = 5)
