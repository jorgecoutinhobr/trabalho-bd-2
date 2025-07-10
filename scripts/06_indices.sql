-- indices para consulta 1
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios (email);
CREATE INDEX IF NOT EXISTS idx_avaliacoes_jogo_id_usuario ON avaliacoes_jogo (id_usuario);
CREATE INDEX IF NOT EXISTS idx_categorias_nome_categoria ON categorias (nome_categoria);
CREATE INDEX IF NOT EXISTS idx_jogo_categoria_id_categoria ON jogo_categoria (id_categoria);
--

-- indices consulta 2
CREATE INDEX IF NOT EXISTS idx_jogos_id_editora ON jogos (id_editora);
CREATE INDEX IF NOT EXISTS idx_avaliacoes_jogo_id_jogo ON avaliacoes_jogo (id_jogo);
CREATE INDEX IF NOT EXISTS idx_jogos_usuario_id_jogo ON jogos_usuario (id_jogo);
--

-- indices consulta 3
CREATE INDEX IF NOT EXISTS idx_jogos_usuario_id_usuario_id_jogo ON jogos_usuario (id_usuario, id_jogo);
CREATE INDEX IF NOT EXISTS idx_jogos_usuario_id_jogo_id_usuario ON jogos_usuario (id_jogo, id_usuario);
--

-- indices consulta 4
CREATE INDEX IF NOT EXISTS idx_jogos_usuario_id_usuario_id_jogo ON jogos_usuario (id_usuario, id_jogo);
CREATE INDEX IF NOT EXISTS idx_jogos_usuario_id_jogo_id_usuario ON jogos_usuario (id_jogo, id_usuario);
-- 