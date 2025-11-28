// Carregar todos os arquivos JSON da pasta local
CALL apoc.load.directory("*.json") YIELD value
WITH value AS arquivo

// Ler cada arquivo JSON
CALL apoc.load.json(arquivo) YIELD value
UNWIND value.data AS tweet

// Criar nó de Tweet
MERGE (t:Tweet {id_tuite: tweet.id})
ON CREATE SET
    t.texto = tweet.text,
    t.data_criacao = tweet.created_at,
    t.autor_id = tweet.author_id,
    t.ru = '4688889'

// Criar nós de Hashtag e relacionar com Tweet
FOREACH (h IN tweet.entities.hashtags |
    MERGE (tag:Hashtag {
        hashtag: apoc.text.replace(
                    apoc.text.clean(h.tag),
                    '[^a-zA-Z0-9]',
                    ''
                )
    })
    MERGE (t)-[:POSSUI]->(tag)
)

// Criar relacionamentos de referência (retweets, replies, quotes)
FOREACH (ref IN tweet.referenced_tweets |
    SET t.tipo_ref = coalesce(t.tipo_ref, []) + ref.type,
        t.id_ref  = coalesce(t.id_ref, []) + ref.id
);
