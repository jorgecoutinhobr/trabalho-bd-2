# trabalho-bd-2
# Projeto de Banco de Dados: E-commerce de jogos

## Descrição

Este projeto foi desenvolvido como parte da disciplina de Projeto de Banco de Dados, atendendo aos requisitos propostos para a construção de um sistema completo baseado no tema "E-commerce de Jogos". O objetivo é modelar, implementar e consultar um banco de dados relacional.

## Estrutura do Projeto

- **Modelo Conceitual:** Diagrama Entidade-Relacionamento (DER) representando as entidades, relacionamentos e restrições do sistema.
- **Esquema Relacional:** Scripts SQL para criação das tabelas no Postgresql.
- **Stored Procedures/Funções:** Implementação de pelo menos 5 procedimentos armazenados ou funções para operações avançadas.
- **Triggers:** Implementação gatilhos para automação.
- **Visões:** Criação visões para facilitar consultas e abstrair complexidade.
- **Consultas SQL:** Proposição de consultas relevantes e não triviais sobre o banco de dados.
- **Índices:** Criação de índices para otimizar as consultas propostas.
- **Relatório:** Estrutura do banco de dados com lista de tabelas, atributos e relacionamentos. Também possui o relatório comparativo de tempo de execução das consultas com e se índices. 


## Requisitos Atendidos

1. **Modelo Conceitual:** Disponível em [Modelo Conceitual .drawio](https://drive.google.com/file/d/13t2XCs8EjKttNhXES9wBtwa8IRrb5XFT/view?usp=sharing) e `/modelo_conceitual/`.
2. **Esquema Relacional:** Scripts em `/scripts/01_criacao_tabelas.sql`.
3. **Mínimo de 15 Tabelas:** O banco possui 19 tabelas relacionadas ao tema.
4. **Stored Procedures/Funções:** Implementadas em `/scripts/02_procedures_funcoes.sql`.
5. **Triggers:** Implementadas em `/scripts/03_triggers.sql`.
6. **Visões:** Implementadas em `/scripts/04_visoes.sql`.
7. **Consultas:** Disponíveis em `/scripts/05_consultas.sql`.
8. **Índices:** Implementados em `/scripts/06_indices.sql`.
9. **Relatório** Implementado em [Relatório do Projeto](https://docs.google.com/document/d/1EGmtMMJ8T8DuVHet8bo3V2950g52j_khJlIAOe0lG54/edit?usp=sharing) e `/relatorio/`.

## Como Executar

1. Instale o Postgresql.
2. Execute os scripts na ordem:
   - 01_criacao_tabelas.sql
   - 02_procedures_funcoes.sql
   - 03_triggers.sql
   - 04_visoes.sql
   - 06_indices.sql
3. Utilize o script 05_consultas.sql para testar as consultas propostas.

## Autores

- Jorge Coutinho dos Santos Neto
- Rafaela Abrahão de Sá
- Higor Marques de Abreu Souza
- Gabriel Villa Verde Reis