import networkx as nx
import pandas as pd

myedges = pd.read_excel('../data/Resource Interaction Table.xlsx')
myedges = myedges[myedges['predicate'] != 'has construction method']

G = nx.from_pandas_edgelist(myedges,
                            create_using=nx.DiGraph())


leaves = set([node for node in G.nodes() if G.in_degree(node)!=0 and G.out_degree(node)==0])


outdf = []
for node in G.nodes():
    if node not in leaves:
        tmp_desc = set(nx.descendants(G, node))
        #tmp_desc = leaves.intersection(tmp_desc)
        tmp_desc = list(tmp_desc)
        desc_dist = [nx.shortest_path_length(G, source=node, target=desc) for desc in tmp_desc]
            
        tmp_df = pd.DataFrame({'source':[node]*len(tmp_desc),
                               'target':tmp_desc,
                               'distance':desc_dist})
        outdf.append(tmp_df)

outdf = pd.concat(outdf)
outdf.to_csv('../data/expanded_edge_list.csv',
             index=False)
