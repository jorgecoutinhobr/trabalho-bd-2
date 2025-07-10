DO $$
DECLARE
    num_usuarios INT := 200000;
    num_jogos INT := 50000;
    num_noticias INT := 5000;
    num_promocoes INT := 2000;
    num_registros_biblioteca BIGINT := 3000000; -- Média de 15 jogos por usuário

BEGIN
    ----------------------------------------------------------------------------------
    -- 1. LIMPEZA DO BANCO DE DADOS
    ----------------------------------------------------------------------------------
    RAISE NOTICE 'Iniciando limpeza do banco de dados...';
    TRUNCATE TABLE
        usuarios, desenvolvedoras, editoras, jogos, dlcs, categorias, promocoes, noticias,
        compras, itens_compra, carrinhos_compra, itens_carrinho, jogos_usuario,
        avaliacoes_jogo, jogo_categoria, jogo_promocao, requisitos_sistema,
        tickets_suporte, mensagens_ticket
    RESTART IDENTITY CASCADE;


    ----------------------------------------------------------------------------------
    -- 2. DADOS BASE
    ----------------------------------------------------------------------------------
    RAISE NOTICE 'Inserindo dados base (desenvolvedoras, editoras, categorias)...';
    INSERT INTO desenvolvedoras (nome_desenvolvedora, site) VALUES
    ('Pixel Dreams', 'https://www.pixeldreams.com.br'), ('CyberConnect', 'https://www.cyberconnect.com'),
    ('Aquiris Game Studio', 'https://www.aquiris.com.br'), ('Lumentech', 'https://www.lumentech.com'),
    ('CD Projekt Red', 'https://www.cdprojektred.com'), ('Stardew Valley Games', 'https://www.stardewvalley.net'),
    ('Ghost Ship Games', 'https://www.ghostship.dk'), ('FromSoftware', 'https://www.fromsoftware.jp');

    INSERT INTO editoras (nome_editora, site) VALUES
    ('Galaxy Games', 'https://www.galaxygames.com'), ('PlayGlobal', 'https://www.playglobal.com'),
    ('Aquiris', 'https://www.aquiris.com.br'), ('CD Projekt', 'https://www.cdprojekt.com'),
    ('Coffee Stain Publishing', 'https://www.coffeestainpublishing.com'), ('Bandai Namco', 'https://www.bandainamcoent.com');

    INSERT INTO categorias (nome_categoria) VALUES
    ('Ação'), ('Aventura'), ('RPG'), ('Estratégia'), ('Simulação'), ('Corrida'),
    ('Indie'), ('Terror'), ('Cooperativo'), ('Mundo Aberto'), ('Souls-like');


    ----------------------------------------------------------------------------------
    -- 3. POPULAÇÃO MASSIVA USANDO VARIÁVEIS
    ----------------------------------------------------------------------------------

    RAISE NOTICE 'Populando % usuários...', num_usuarios;
    INSERT INTO usuarios (id_usuario, nome_usuario, email, senha_hash, data_registro, ultimo_login)
    SELECT
        s, 'usuario_' || s, 'usuario_' || s || '@emailaleatorio.com', 'hash_senha_padrao_' || md5(random()::text),
        NOW() - (random() * 1095) * INTERVAL '1 day', NOW() - (random() * 60) * INTERVAL '1 day'
    FROM generate_series(1, num_usuarios) s;

    RAISE NOTICE 'Populando % jogos...', num_jogos;
    INSERT INTO jogos (titulo, descricao, preco, data_lancamento, id_desenvolvedora, id_editora, url_imagem_capa, classificacao_media)
    SELECT
        (ARRAY['Crônicas', 'Lendas', 'Sombras', 'Guerreiros', 'Mistérios', 'Reinos', 'Fragmentos'])[floor(random()*7)+1] || ' de ' || (ARRAY['Valéria', 'Zarthia', 'Neon', 'Aethel', 'Oblivion', 'Eldoria'])[floor(random()*6)+1] || ' ' || s,
        'Descrição gerada proceduralmente para o jogo ' || s, (random() * 200 + 20)::decimal(10,2),
        '2018-01-01'::date + (random() * 2500)::int * INTERVAL '1 day',
        floor(random() * (SELECT COUNT(*) FROM desenvolvedoras) + 1)::int,
        floor(random() * (SELECT COUNT(*) FROM editoras) + 1)::int,
        'https://placehold.co/600x900/2a2a3a/ffffff?text=Jogo+' || s,
        (random() * 5 + 5)::decimal(3,1)
    FROM generate_series(1, num_jogos) s;

    RAISE NOTICE 'Populando DLCs...';
    INSERT INTO dlcs (id_jogo_base, titulo_dlc, descricao_dlc, preco_dlc, data_lancamento_dlc)
    SELECT
        id_jogo, 'Expansão: ' || (ARRAY['O Despertar', 'A Vingança', 'Novos Horizontes', 'Segredos Obscuros'])[floor(random()*4)+1],
        'Conteúdo adicional para o jogo base.', (preco * (random() * 0.4 + 0.2))::decimal(10,2),
        data_lancamento + (random() * 365 + 180) * INTERVAL '1 day'
    FROM jogos WHERE random() < 0.2;

    RAISE NOTICE 'Populando % registros na biblioteca dos usuários...', num_registros_biblioteca;
    INSERT INTO jogos_usuario (id_usuario, id_jogo, data_aquisicao)
    SELECT
        floor(random() * num_usuarios + 1)::int, floor(random() * num_jogos + 1)::int,
        NOW() - (random() * 1000)::int * INTERVAL '1 day'
    FROM generate_series(1, num_registros_biblioteca)
    ON CONFLICT (id_usuario, id_jogo) DO NOTHING;

    RAISE NOTICE 'Populando avaliações de jogos...';
    INSERT INTO avaliacoes_jogo (id_usuario, id_jogo, nota, comentario, data_avaliacao)
    SELECT
        ju.id_usuario, ju.id_jogo, floor(random() * 11)::int,
        (ARRAY['Ótimo jogo!', 'Poderia ser melhor.', 'Divertido, mas com bugs.', 'Uma obra-prima!', 'Não recomendo.', 'Perfeito para jogar com amigos.'])[floor(random()*6)+1],
        ju.data_aquisicao + (random() * 100)::int * INTERVAL '1 day'
    FROM jogos_usuario ju WHERE random() < 0.25;

    RAISE NOTICE 'Associando categorias aos jogos...';
    INSERT INTO jogo_categoria (id_jogo, id_categoria)
    SELECT g.id_jogo, c.id_categoria FROM jogos g
    CROSS JOIN LATERAL (
        SELECT id_categoria FROM categorias ORDER BY random() LIMIT floor(random() * 3 + 1)::int
    ) c ON CONFLICT (id_jogo, id_categoria) DO NOTHING;

    RAISE NOTICE 'Populando % promoções...', num_promocoes;
    INSERT INTO promocoes (nome_promocao, descricao, data_inicio, data_fim, tipo_desconto, valor_desconto)
    SELECT
        'Promoção ' || (ARRAY['Relâmpago', 'de Verão', 'de Inverno', 'Temática', 'de Aniversário', 'Fim de Semana', 'da Publisher'])[floor(random()*7)+1] || ' #' || s,
        'Grande oportunidade para adquirir novos jogos com desconto!', NOW() - (random() * 45) * INTERVAL '1 day',
        NOW() + (random() * 45 - 15) * INTERVAL '1 day', 'PERCENTUAL', (floor(random() * 15) * 5 + 10)::decimal(5,2)
    FROM generate_series(1, num_promocoes) s;

    RAISE NOTICE 'Associando jogos a promoções ativas...';
    WITH promocoes_ativas AS (SELECT id_promocao FROM promocoes WHERE data_fim > NOW())
    INSERT INTO jogo_promocao (id_jogo, id_promocao)
    SELECT j.id_jogo, p.id_promocao FROM promocoes_ativas p
    CROSS JOIN LATERAL (
        SELECT id_jogo FROM jogos ORDER BY random() LIMIT floor(random() * 100 + 20)::int
    ) j ON CONFLICT (id_jogo, id_promocao) DO NOTHING;

    RAISE NOTICE 'Populando % notícias...', num_noticias;
    INSERT INTO noticias (titulo, conteudo, data_publicacao, id_jogo_relacionado)
    SELECT
        'Notícia Importante ' || s, 'Conteúdo gerado proceduralmente sobre as últimas novidades do mundo dos games.',
        NOW() - (random() * 730) * INTERVAL '1 day',
        CASE WHEN random() < 0.7 THEN floor(random() * num_jogos + 1)::int ELSE NULL END
    FROM generate_series(1, num_noticias) s;

    RAISE NOTICE 'Populando requisitos de sistema...';
    INSERT INTO requisitos_sistema (id_jogo, os, processador, memoria_ram, placa_video, armazenamento, notas_adicionais)
    SELECT
        j.id_jogo, 'Windows 10/11 64-bit',
        (ARRAY['Intel Core i7-9700K', 'AMD Ryzen 7 3700X', 'Intel Core i5-8400', 'AMD Ryzen 5 2600'])[floor(random()*4)+1],
        (ARRAY['8 GB', '16 GB', '32 GB'])[floor(random()*3)+1] || ' RAM',
        (ARRAY['NVIDIA RTX 2070', 'AMD Radeon RX 5700 XT', 'NVIDIA GTX 1060', 'AMD Radeon RX 580'])[floor(random()*4)+1],
        (floor(random() * 180) + 20) || ' GB', 'Recomendamos o uso de um SSD para uma melhor experiência.'
    FROM jogos j ON CONFLICT (id_jogo) DO NOTHING;

    RAISE NOTICE 'Criando carrinhos de compra...';
    INSERT INTO carrinhos_compra (id_usuario, data_criacao, ultima_atualizacao)
    SELECT id_usuario, NOW() - (random() * 10) * INTERVAL '1 day', NOW() - (random() * 2) * INTERVAL '1 day'
    FROM usuarios WHERE random() < 0.05;

    RAISE NOTICE 'Adicionando itens aos carrinhos...';
    INSERT INTO itens_carrinho (id_carrinho, id_jogo, id_dlc, quantidade, preco_no_carrinho)
    WITH carrinhos AS (SELECT id_carrinho FROM carrinhos_compra)
    SELECT c.id_carrinho, j.id_jogo, NULL as id_dlc, 1 as quantidade, j.preco
    FROM carrinhos c CROSS JOIN LATERAL (
        SELECT id_jogo, preco FROM jogos ORDER BY random() LIMIT floor(random() * 3 + 1)::int
    ) j;

    RAISE NOTICE 'Criando tickets de suporte...';
    INSERT INTO tickets_suporte (id_usuario, assunto, descricao, status, data_abertura, data_ultima_atualizacao, prioridade)
    SELECT
        id_usuario, 'Problema com o jogo ' || (SELECT titulo FROM jogos ORDER BY random() LIMIT 1),
        'Descrição do problema gerada aleatoriamente.', (ARRAY['ABERTO', 'EM ANDAMENTO', 'FECHADO'])[floor(random()*3)+1],
        NOW() - (random() * 90) * INTERVAL '1 day', NOW() - (random() * 30) * INTERVAL '1 day',
        (ARRAY['BAIXA', 'NORMAL', 'ALTA'])[floor(random()*3)+1]
    FROM usuarios WHERE random() < 0.01;

    RAISE NOTICE 'Adicionando mensagens aos tickets...';
    INSERT INTO mensagens_ticket (id_ticket, id_remetente, conteudo, data_envio)
    SELECT id_ticket, id_usuario, 'Esta é a primeira mensagem do ticket, enviada pelo usuário.', data_abertura
    FROM tickets_suporte;

    INSERT INTO mensagens_ticket (id_ticket, id_remetente, conteudo, data_envio)
    SELECT
        id_ticket, (SELECT id_usuario FROM usuarios ORDER BY random() LIMIT 1),
        'Olá! Obrigado por entrar em contato. Estamos analisando o seu problema e retornaremos em breve.',
        data_ultima_atualizacao + INTERVAL '1 hour'
    FROM tickets_suporte WHERE status != 'FECHADO' AND random() < 0.8;

    -- Passo 1: Gerar as compras.
    RAISE NOTICE 'Gerando registros de compras...';
    -- CORREÇÃO APLICADA: Removida a coluna "metodo_pagamento".
    INSERT INTO compras (id_usuario, data_compra, valor_total, status_compra)
    WITH usuarios_compradores AS (
        SELECT id_usuario, data_registro FROM usuarios WHERE random() < 0.4
    )
    SELECT
        uc.id_usuario,
        uc.data_registro + (random() * (NOW() - uc.data_registro))::interval,
        0, -- Valor total será atualizado depois
        'APROVADA'
    FROM usuarios_compradores uc
    CROSS JOIN LATERAL generate_series(1, floor(random() * 3 + 1)::int);

    -- Passo 2: Gerar os itens para cada compra.
    RAISE NOTICE 'Gerando itens de compra com preços históricos...';
    -- CORREÇÃO APLICADA: Inserindo em "preco_unitario" e removendo colunas inexistentes.
    INSERT INTO itens_compra (id_compra, id_jogo, id_dlc, preco_unitario)
    WITH compras_info AS (
        SELECT id_compra, data_compra FROM compras
    )
    SELECT
        ci.id_compra,
        jogos_comprados.id_jogo,
        NULL,
        -- Calcula o preço unitário no momento da compra, aplicando o desconto se houver.
        round(jogos_comprados.preco * (1 - COALESCE(promo.valor_desconto, 0) / 100), 2)
    FROM compras_info ci
    CROSS JOIN LATERAL (
        SELECT id_jogo, preco FROM jogos ORDER BY random() LIMIT floor(random() * 4 + 1)::int
    ) AS jogos_comprados
    LEFT JOIN LATERAL (
        SELECT p.valor_desconto FROM jogo_promocao jp
        JOIN promocoes p ON jp.id_promocao = p.id_promocao
        WHERE jp.id_jogo = jogos_comprados.id_jogo AND ci.data_compra BETWEEN p.data_inicio AND p.data_fim
        ORDER BY p.valor_desconto DESC LIMIT 1
    ) AS promo ON true;

    -- Passo 3: Atualizar o valor total de cada compra.
    RAISE NOTICE 'Atualizando valores totais das compras...';
    -- CORREÇÃO APLICADA: Somando "preco_unitario".
    WITH totais_compra AS (
      SELECT id_compra, SUM(preco_unitario) AS total_calculado
      FROM itens_compra
      GROUP BY id_compra
    )
    UPDATE compras c
    SET valor_total = tc.total_calculado
    FROM totais_compra tc
    WHERE c.id_compra = tc.id_compra;

    RAISE NOTICE 'População do banco de dados concluída com sucesso!';
END $$;

SELECT
    (SELECT COUNT(*) FROM usuarios) AS total_usuarios,
    (SELECT COUNT(*) FROM jogos) AS total_jogos,
    (SELECT COUNT(*) FROM jogos_usuario) AS total_jogos_nas_bibliotecas,
    (SELECT COUNT(*) FROM promocoes) AS total_promocoes,
    (SELECT COUNT(*) FROM noticias) AS total_noticias;