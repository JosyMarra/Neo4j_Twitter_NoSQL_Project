# 📊 Projeto NoSQL e Modelagem de Grafos com Neo4j – Twitter Analysis
*Por Josy Marra – Cientista de Dados em Formação*

Este projeto teve como objetivo aplicar técnicas de **NoSQL**, **modelagem de grafos** e **Cypher** utilizando o **Neo4j** para analisar dados estruturados em JSON contendo tweets e suas referências (retweets, respostas e citações).

O trabalho foi desenvolvido como atividade prática acadêmica e transformado aqui em formato de portfólio profissional.

---

## 🚀 Objetivos do Projeto

- Criar um banco de dados em grafo usando Neo4j  
- Importar múltiplos arquivos JSON contendo tweets  
- Tratar dados com **APOC**  
- Criar nós e relacionamentos com Cypher  
- Normalizar hashtags  
- Identificar relações entre tweets, usuários e hashtags  
- Responder perguntas analíticas com consultas Cypher

---

## 🛠 Tecnologias Utilizadas

- **Neo4j 5.x**
- **Cypher Query Language**
- **APOC Library**
- **JSON datasets**
- **Python/Scripts auxiliares**

---

## 📥 1. Importação e Criação do Grafo

Arquivo: `queries/Q1_import.cypher`

```cypher
CALL apoc.load.directory('*.json') YIELD value
WITH value AS arquivo
CALL apoc.load.json(arquivo) YIELD value
UNWIND value.data AS tweet

MERGE (t:Tweet {id_tuite: tweet.id})
ON CREATE SET
    t.texto        = tweet.text,
    t.data_criacao = tweet.created_at,
    t.autor_id     = tweet.author_id,
    t.ru           = '4688889'

FOREACH (h IN tweet.entities.hashtags |
    MERGE (tag:Hashtag {
        hashtag: apoc.text.replace(
                     apoc.text.clean(h.tag),
                     '[^a-zA-Z0-9]', ''
                 )
    })
    MERGE (t)-[:POSSUI]->(tag)
)

FOREACH (ref IN tweet.referenced_tweets |
    SET t.tipo_ref = coalesce(t.tipo_ref, []) + ref.type,
        t.id_ref   = coalesce(t.id_ref, []) + ref.id
);
