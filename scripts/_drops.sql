-- DROP DAS TABLES
DROP TABLE IF EXISTS mensagens_ticket CASCADE;
DROP TABLE IF EXISTS tickets_suporte CASCADE;
DROP TABLE IF EXISTS requisitos_sistema CASCADE;
DROP TABLE IF EXISTS jogo_promocao CASCADE;
DROP TABLE IF EXISTS jogo_categoria CASCADE;
DROP TABLE IF EXISTS avaliacoes_jogo CASCADE;
DROP TABLE IF EXISTS jogos_usuario CASCADE;
DROP TABLE IF EXISTS itens_carrinho CASCADE;
DROP TABLE IF EXISTS carrinhos_compra CASCADE;
DROP TABLE IF EXISTS itens_compra CASCADE;
DROP TABLE IF EXISTS compras CASCADE;
DROP TABLE IF EXISTS noticias CASCADE;
DROP TABLE IF EXISTS promocoes CASCADE;
DROP TABLE IF EXISTS dlcs CASCADE;

DROP TABLE IF EXISTS categorias CASCADE;
DROP TABLE IF EXISTS jogos CASCADE;
DROP TABLE IF EXISTS editoras CASCADE;
DROP TABLE IF EXISTS desenvolvedoras CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- DROP DOS INDEXES
DROP INDEX IF EXISTS idx_compras_data_compra;
DROP INDEX IF EXISTS idx_usuarios_email;
DROP INDEX IF EXISTS idx_avaliacoes_jogo_id_usuario;
DROP INDEX IF EXISTS idx_categorias_nome_categoria;
DROP INDEX IF EXISTS idx_jogo_categoria_id_categoria;
DROP INDEX IF EXISTS idx_jogos_id_editora;
DROP INDEX IF EXISTS idx_avaliacoes_jogo_id_jogo;
DROP INDEX IF EXISTS idx_jogos_usuario_id_jogo;
DROP INDEX IF EXISTS idx_jogos_usuario_id_usuario_id_jogo;
DROP INDEX IF EXISTS idx_jogos_usuario_id_jogo_id_usuario;
DROP INDEX IF EXISTS idx_gin_jogos_titulo;
DROP INDEX IF EXISTS idx_compras_data_compra;
DROP INDEX IF EXISTS idx_itens_compra_id_jogo;
DROP INDEX IF EXISTS idx_avaliacoes_jogo_id_jogo_nota;

--DROP DAS VIEWS
DROP VIEW IF EXISTS vw_jogos_em_promocao;
DROP VIEW IF EXISTS vw_estatisticas_desenvolvedora;