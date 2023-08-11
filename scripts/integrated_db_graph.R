library(igraph)
library(ggraph)
library(tidygraph)
library(tidyverse)
library(readxl)

mydat <- read_xlsx('./data/Resource Interaction Table.xlsx')
mynodes <- read_xlsx('./data/Resource Interaction Table.xlsx', sheet = 2)

mydat %>% 
  filter(predicate != 'has construction method') %>% 
  select(-predicate) -> mydat

mydat %>% 
  group_by(target) %>% 
  summarise(inDegree = n()) %>% 
  rename(node = target) -> inDegree

mynodes %>% 
  merge(inDegree, all = T) %>% 
  mutate(inDegree = if_else(is.na(inDegree), 0, inDegree),
         ISDB = as.character(category == 'Integrated DB')) -> mynodes

G <- graph_from_data_frame(mydat, directed = T, mynodes)

lay = create_layout(G, layout = "circle")

ggraph(lay) + 
  geom_edge_link(color = 'grey50', 
                 arrow = arrow(length = unit(3, 'mm')),
                 end_cap = circle(3, 'mm')) + 
  geom_node_point(aes(fill = category, 
                      size = inDegree,
                      shape = ISDB),
                  pch = 21) +
  geom_node_text(aes(label = name), repel=TRUE) +
  theme_graph(base_size = 18) +
  scale_fill_brewer(palette = 'Dark2')
