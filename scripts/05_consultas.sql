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

-- CONSULTA 2: Relatório de desempenho por editora
EXPLAIN ANALYZE SELECT
    e.nome_editora,
    COUNT(DISTINCT j.id_jogo) AS total_jogos_publicados,
    AVG(av.nota) AS media_geral_avaliacoes,
    COUNT(ju.id_jogo) AS total_copias_na_plataforma
FROM
    editoras e
JOIN
    jogos j ON e.id_editora = j.id_editora
LEFT JOIN
    avaliacoes_jogo av ON j.id_jogo = av.id_jogo
LEFT JOIN
    jogos_usuario ju ON j.id_jogo = ju.id_jogo
GROUP BY
    e.id_editora, e.nome_editora
ORDER BY
    total_copias_na_plataforma DESC;
--

-- -- CONSULTA 3: Sugerir jogos para um usuário alvo (ID = 123)
EXPLAIN ANALYZE
WITH JogosDoUsuarioAlvo AS (
    SELECT id_jogo FROM jogos_usuario WHERE id_usuario = 123
),
UsuariosSimilares AS (
    SELECT DISTINCT ju.id_usuario
    FROM jogos_usuario ju
    WHERE ju.id_jogo IN (SELECT id_jogo FROM JogosDoUsuarioAlvo)
      AND ju.id_usuario != 123
)

SELECT
    j.titulo,
    COUNT(ju.id_usuario) AS popularidade_entre_similares
FROM
    jogos_usuario ju
JOIN
    jogos j ON ju.id_jogo = j.id_jogo
WHERE
    ju.id_usuario IN (SELECT id_usuario FROM UsuariosSimilares)
    AND ju.id_jogo NOT IN (SELECT id_jogo FROM JogosDoUsuarioAlvo)
GROUP BY
    j.id_jogo, j.titulo
ORDER BY
    popularidade_entre_similares DESC
LIMIT 15;
--

-- Consulta 4:  Encontrar usuários que têm o jogo base mas não a DLC
EXPLAIN ANALYZE SELECT
    u.id_usuario,
    u.email
FROM
    usuarios u
JOIN
    jogos_usuario ju_base ON u.id_usuario = ju_base.id_usuario AND ju_base.id_jogo = 45)
WHERE
    NOT EXISTS (
        SELECT 1
        FROM jogos_usuario ju_dlc
        WHERE ju_dlc.id_usuario = u.id_usuario
          AND ju_dlc.id_jogo = (SELECT d.id_dlc FROM dlcs d WHERE d.id_dlc = 12)
    );
--

-- Consulta 5
    
--