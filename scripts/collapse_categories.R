myedges <- read_xlsx('./data/Resource Interaction Table.xlsx')
mynodes <- read_xlsx('./data/Resource Interaction Table.xlsx', sheet = 2)

mynodes %>% 
  filter(category == 'Integrated DB') %>% 
  pull(node) -> idbs

myedges %>% 
  filter(source %in% idbs) %>% 
  merge(mynodes, by.x = 'target', by.y = 'node') %>% 
  select(source, predicate, category) %>% 
  distinct() %>% 
  rename(target = category) %>% 
  arrange(desc(source), desc(target)) -> category_edges

write_tsv(category_edges, './data/category_edges.tsv')
