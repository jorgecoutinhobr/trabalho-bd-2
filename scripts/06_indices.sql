-- indices para consulta 1
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios (email);
CREATE INDEX IF NOT EXISTS idx_avaliacoes_jogo_id_usuario ON avaliacoes_jogo (id_usuario);
CREATE INDEX IF NOT EXISTS idx_categorias_nome_categoria ON categorias (nome_categoria);
CREATE INDEX IF NOT EXISTS idx_jogo_categoria_id_categoria ON jogo_categoria (id_categoria);
--

-- indices consulta 2
--