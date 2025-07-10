CREATE OR REPLACE VIEW vw_jogos_em_promocao AS
SELECT DISTINCT ON (j.id_jogo)
    j.id_jogo,
    j.titulo,
    j.preco AS preco_original,
    p.nome_promocao,
    p.valor_desconto AS percentual_desconto,
    fn_calcular_preco_com_desconto(j.id_jogo) AS preco_final
FROM jogos j
JOIN jogo_promocao jp ON j.id_jogo = jp.id_jogo
JOIN promocoes p ON jp.id_promocao = p.id_promocao
WHERE NOW() BETWEEN p.data_inicio AND p.data_fim
ORDER BY j.id_jogo, p.valor_desconto DESC;

CREATE OR REPLACE VIEW vw_estatisticas_desenvolvedora AS
SELECT
    d.nome_desenvolvedora,
    COUNT(DISTINCT j.id_jogo) AS total_jogos,
    ROUND(AVG(j.classificacao_media), 2) AS media_classificacao_geral,
    COUNT(ju.id_usuario) AS total_vendas,
    SUM(COALESCE(j.preco, 0)) AS receita_estimada
FROM desenvolvedoras d
LEFT JOIN jogos j ON d.id_desenvolvedora = j.id_desenvolvedora
LEFT JOIN jogos_usuario ju ON j.id_jogo = ju.id_jogo
GROUP BY d.id_desenvolvedora, d.nome_desenvolvedora
ORDER BY d.nome_desenvolvedora;