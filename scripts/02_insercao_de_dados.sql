TRUNCATE TABLE
    usuarios, desenvolvedoras, editoras, jogos, dlcs, categorias, promocoes, noticias,
    compras, itens_compra, carrinhos_compra, itens_carrinho, jogos_usuario,
    avaliacoes_jogo, jogo_categoria, jogo_promocao, requisitos_sistema,
    tickets_suporte, mensagens_ticket
RESTART IDENTITY CASCADE;

INSERT INTO desenvolvedoras (nome_desenvolvedora, site) VALUES
('Pixel Dreams', 'https://www.pixeldreams.com.br'),
('CyberConnect', 'https://www.cyberconnect.com'),
('Aquiris Game Studio', 'https://www.aquiris.com.br'),
('Lumentech', 'https://www.lumentech.com'),
('CD Projekt Red', 'https://www.cdprojektred.com'),
('Stardew Valley Games', 'https://www.stardewvalley.net'),
('Ghost Ship Games', 'https://www.ghostship.dk'),
('FromSoftware', 'https://www.fromsoftware.jp');

INSERT INTO editoras (nome_editora, site) VALUES
('Galaxy Games', 'https://www.galaxygames.com'),
('PlayGlobal', 'https://www.playglobal.com'),
('Aquiris', 'https://www.aquiris.com.br'),
('CD Projekt', 'https://www.cdprojekt.com'),
('Coffee Stain Publishing', 'https://www.coffeestainpublishing.com'),
('Bandai Namco', 'https://www.bandainamcoent.com');

INSERT INTO categorias (nome_categoria) VALUES
('Ação'), ('Aventura'), ('RPG'), ('Estratégia'), ('Simulação'), ('Corrida'), ('Indie'), ('Terror'), ('Cooperativo'), ('Mundo Aberto'), ('Souls-like');

INSERT INTO usuarios (id_usuario, nome_usuario, email, senha_hash, data_registro, ultimo_login)
SELECT
    s,
    'usuario_' || s,
    'usuario_' || s || '@emailaleatorio.com',
    'hash_senha_padrao_' || md5(random()::text),
    NOW() - (random() * 365) * INTERVAL '1 day',
    NOW() - (random() * 30) * INTERVAL '1 day'
FROM generate_series(1, 100) s
UNION ALL
VALUES (101, 'suporte_tech', 'suporte@loja.com', 'hash_suporte_seguro', NOW(), NOW());


INSERT INTO jogos (titulo, descricao, preco, data_lancamento, id_desenvolvedora, id_editora, url_imagem_capa, classificacao_media)
SELECT
    (ARRAY['Crônicas', 'Lendas', 'Sombras', 'Guerreiros', 'Mistérios', 'Reinos', 'Fragmentos'])[floor(random()*7)+1] || ' de ' || (ARRAY['Valéria', 'Zarthia', 'Neon', 'Aethel', 'Oblivion', 'Eldoria'])[floor(random()*6)+1] || ' ' || s,
    'Descrição gerada proceduralmente para o jogo ' || s,
    (random() * 200 + 20)::decimal(10,2),
    '2020-01-01'::date + (random() * 1500)::int * INTERVAL '1 day',
    floor(random() * (SELECT COUNT(*) FROM desenvolvedoras) + 1)::int,
    floor(random() * (SELECT COUNT(*) FROM editoras) + 1)::int,
    'https://placehold.co/600x900/2a2a3a/ffffff?text=Jogo+' || s,
    (random() * 5 + 5)::decimal(3,1)
FROM generate_series(1, 50) s;

INSERT INTO dlcs (id_jogo_base, titulo_dlc, descricao_dlc, preco_dlc, data_lancamento_dlc)
SELECT
    id_jogo,
    'Expansão: ' || (ARRAY['O Despertar', 'A Vingança', 'Novos Horizontes', 'Segredos Obscuros'])[floor(random()*4)+1],
    'Conteúdo adicional para o jogo base.',
    (preco * (random() * 0.4 + 0.2))::decimal(10,2), 
    data_lancamento + (random() * 365 + 180) * INTERVAL '1 day'
FROM jogos
WHERE random() < 0.3;

INSERT INTO jogos_usuario (id_usuario, id_jogo, data_aquisicao)
WITH user_ids AS (SELECT id_usuario FROM usuarios WHERE id_usuario <= 100)
SELECT
    u.id_usuario,
    j.id_jogo,
    j.data_lancamento + (random() * 365)::int * INTERVAL '1 day' AS data_aquisicao
FROM user_ids u
CROSS JOIN LATERAL (
    SELECT id_jogo, data_lancamento
    FROM jogos
    ORDER BY random()
    LIMIT floor(random() * 11 + 5)::int
) j
ON CONFLICT (id_usuario, id_jogo) DO NOTHING; 

INSERT INTO avaliacoes_jogo (id_usuario, id_jogo, nota, comentario, data_avaliacao)
SELECT
    ju.id_usuario,
    ju.id_jogo,
    floor(random() * 11)::int, 
    (ARRAY['Ótimo jogo!', 'Poderia ser melhor.', 'Divertido, mas com bugs.', 'Uma obra-prima!', 'Não recomendo.', 'Perfeito para jogar com amigos.'])[floor(random()*6)+1],
    ju.data_aquisicao + (random() * 100)::int * INTERVAL '1 day'
FROM jogos_usuario ju
WHERE random() < 0.4;

INSERT INTO jogo_categoria (id_jogo, id_categoria)
WITH game_ids AS (SELECT id_jogo FROM jogos)
SELECT
    g.id_jogo,
    c.id_categoria
FROM game_ids g
CROSS JOIN LATERAL (
    SELECT id_categoria
    FROM categorias
    ORDER BY random()
    LIMIT floor(random() * 3 + 1)::int
) c
ON CONFLICT (id_jogo, id_categoria) DO NOTHING;

INSERT INTO promocoes (nome_promocao, descricao, data_inicio, data_fim, tipo_desconto, valor_desconto)
SELECT
    'Promoção ' || (ARRAY['Relâmpago', 'de Verão', 'de Inverno', 'Temática', 'de Aniversário'])[s],
    'Grande oportunidade para adquirir novos jogos!',
    NOW() - (random() * 30) * INTERVAL '1 day',
    NOW() + (random() * 30 - 15) * INTERVAL '1 day',
    'PERCENTUAL',
    (floor(random() * 15) * 5 + 10)::decimal(5,2)
FROM generate_series(1, 5) s;

INSERT INTO jogo_promocao (id_jogo, id_promocao)
SELECT
    j.id_jogo,
    p.id_promocao
FROM jogos j, promocoes p
WHERE p.data_fim > NOW() AND random() < 0.2; 

INSERT INTO requisitos_sistema (id_jogo, os, processador, memoria_ram, placa_video, armazenamento, notas_adicionais)
SELECT
    j.id_jogo,
    'Windows 10/11 64-bit',
    (ARRAY['Intel Core i7-9700K', 'AMD Ryzen 7 3700X'])[floor(random()*2)+1],
    '16 GB',
    (ARRAY['NVIDIA RTX 2070', 'AMD Radeon RX 5700 XT'])[floor(random()*2)+1],
    (floor(random() * 100) + 20) || ' GB',
    'Recomendamos o uso de um SSD para uma melhor experiência.'
FROM jogos j
ON CONFLICT (id_jogo) DO NOTHING;

INSERT INTO noticias (titulo, conteudo, data_publicacao, id_jogo_relacionado)
SELECT
    'Notícia Importante ' || s,
    'Conteúdo gerado proceduralmente sobre as últimas novidades do mundo dos games.',
    NOW() - (random() * 365) * INTERVAL '1 day',
    CASE WHEN random() < 0.7 THEN floor(random() * 50 + 1)::int ELSE NULL END 
FROM generate_series(1, 25) s;

INSERT INTO carrinhos_compra (id_usuario, data_criacao, ultima_atualizacao)
SELECT
    id_usuario,
    NOW() - (random() * 10) * INTERVAL '1 day',
    NOW() - (random() * 2) * INTERVAL '1 day'
FROM usuarios
WHERE id_usuario <= 100 AND random() < 0.2;

INSERT INTO itens_carrinho (id_carrinho, id_jogo, id_dlc, quantidade, preco_no_carrinho)
WITH carrinhos AS (SELECT id_carrinho FROM carrinhos_compra)
SELECT
    c.id_carrinho,
    j.id_jogo,
    NULL as id_dlc,
    1 as quantidade,
    j.preco
FROM carrinhos c
CROSS JOIN LATERAL (
    SELECT id_jogo, preco FROM jogos ORDER BY random() LIMIT floor(random() * 3 + 1)::int
) j;

INSERT INTO tickets_suporte (id_usuario, assunto, descricao, status, data_abertura, data_ultima_atualizacao, prioridade)
SELECT
    id_usuario,
    'Problema com o jogo ' || (SELECT titulo FROM jogos ORDER BY random() LIMIT 1),
    'Descrição do problema gerada aleatoriamente.',
    (ARRAY['ABERTO', 'EM ANDAMENTO', 'FECHADO'])[floor(random()*3)+1],
    NOW() - (random() * 90) * INTERVAL '1 day',
    NOW() - (random() * 30) * INTERVAL '1 day',
    (ARRAY['BAIXA', 'NORMAL', 'ALTA'])[floor(random()*3)+1]
FROM usuarios
WHERE id_usuario <= 100 AND random() < 0.1; 

INSERT INTO mensagens_ticket (id_ticket, id_remetente, conteudo, data_envio)
SELECT
    id_ticket,
    id_usuario,
    'Esta é a primeira mensagem do ticket, enviada pelo usuário.',
    data_abertura
FROM tickets_suporte;

INSERT INTO mensagens_ticket (id_ticket, id_remetente, conteudo, data_envio)
SELECT
    id_ticket,
    101, 
    'Olá! Obrigado por entrar em contato. Estamos analisando o seu problema e retornaremos em breve.',
    data_ultima_atualizacao + INTERVAL '1 hour'
FROM tickets_suporte
WHERE status != 'FECHADO' AND random() < 0.8;

SELECT 'Banco de dados populado com sucesso usando GENERATE_SERIES!' as status;
