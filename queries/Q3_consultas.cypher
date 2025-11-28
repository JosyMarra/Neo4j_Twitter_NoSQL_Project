// ---------- Q3 - Consultas Analíticas no Grafo ----------

// 1. Contar total de tweets importados
MATCH (t:Tweet)
RETURN count(t) AS total_tweets;

// 2. Listar hashtags mais usadas
MATCH (:Tweet)-[:POSSUI]->(h:Hashtag)
RETURN h.hashtag AS hashtag, count(*) AS ocorrencias
ORDER BY ocorrencias DESC
LIMIT 10;

// 3. Top autores com mais tweets
MATCH (a:Autor)-[:PUBLICOU]->(t:Tweet)
RETURN a.id_autor AS autor, count(t) AS total_tweets
ORDER BY total_tweets DESC
LIMIT 10;

// 4. Tweets que possuem mais referências (retweets, replies, quotes)
MATCH (t:Tweet)<-[:REFERENCIA]-()
RETURN t.texto AS tweet, count(*) AS total_referencias
ORDER BY total_referencias DESC
LIMIT 10;

// 5. Buscar tweets contendo palavra-chave
MATCH (t:Tweet)
WHERE toLower(t.texto) CONTAINS "neo4j"
RETURN t.texto AS tweet, t.data_criacao
ORDER BY t.data_criacao DESC;

// 6. Número de tweets por dia
MATCH (t:Tweet)
RETURN t.data_criacao AS data, count(*) AS total
ORDER BY data ASC;

// 7. Rede de relacionamento entre tweets
MATCH (t1:Tweet)-[r:REFERENCIA]->(t2:Tweet)
RETURN t1, r, t2
LIMIT 50;

// 8. Encontrar autores que mais utilizam hashtags
MATCH (a:Autor)-[:PUBLICOU]->(:Tweet)-[:POSSUI]->(h:Hashtag)
RETURN a.id_autor AS autor, count(h) AS total_hashtags
ORDER BY total_hashtags DESC
LIMIT 10;

// 9. Top hashtags coocorrentes
MATCH (t:Tweet)-[:POSSUI]->(h1:Hashtag),
      (t)-[:POSSUI]->(h2:Hashtag)
WHERE h1 <> h2
RETURN h1.hashtag AS hashtag1, h2.hashtag AS hashtag2, count(*) AS ocorrencias
ORDER BY ocorrencias DESC
LIMIT 20;

// 10. Encontrar tweets citados mais de 3 vezes
MATCH (t:Tweet)<-[:REFERENCIA]-()
WITH t, count(*) AS total
WHERE total > 3
RETURN t.texto AS tweet, total
ORDER BY total DESC;
