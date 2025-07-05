-- Consulta 1
EXPLAIN ANALYSE SELECT
    u.nome_usuario,
    j.titulo AS titulo_do_jogo,
    c.nome_categoria,
    aj.nota AS nota_atribuida,
    aj.data_avaliacao
FROM
    usuarios u
JOIN
    avaliacoes_jogo aj ON u.id_usuario = aj.id_usuario
JOIN
    jogos j ON aj.id_jogo = j.id_jogo
JOIN
    jogo_categoria jc ON j.id_jogo = jc.id_jogo
JOIN
    categorias c ON jc.id_categoria = c.id_categoria
WHERE
    u.email = 'usuario_1@emailaleatorio.com'
AND
    c.nome_categoria = 'RPG'
AND
    aj.nota >= 8
ORDER BY
    aj.data_avaliacao DESC;
----

