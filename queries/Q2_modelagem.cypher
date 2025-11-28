// ---------- Q2 - Criação dos Relacionamentos (Modelagem do Grafo) ----------

// Criar relacionamento entre Tweet -> Usuário (autor)
MATCH (t:Tweet), (u:Autor {id_autor: t.autor_id})
MERGE (u)-[:PUBLICOU]->(t);

// Criar relacionamento entre Tweet -> Hashtag
MATCH (t:Tweet)-[:POSSUI]->(h:Hashtag)
RETURN t, h;

// Criar relacionamento de referência (retweets, replies, quotes)
MATCH (t:Tweet)
WHERE t.tipo_ref IS NOT NULL
MATCH (t2:Tweet {id_tuite: t.id_ref})
MERGE (t)-[r:REFERENCIA]->(t2)
SET r.tipo = t.tipo_ref;

// Indexes para otimizar consultas
CREATE INDEX tweet_id IF NOT EXISTS
FOR (t:Tweet)
ON (t.id_tuite);

CREATE INDEX hashtag_name IF NOT EXISTS
FOR (h:Hashtag)
ON (h.hashtag);

CREATE INDEX autor_id IF NOT EXISTS
FOR (a:Autor)
ON (a.id_autor);
