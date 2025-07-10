-- Função 1: Calcular o preço de um jogo com desconto percentual
CREATE OR REPLACE FUNCTION fn_calcular_preco_com_desconto(id_jogo_param INT)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    preco_original DECIMAL(10,2);
    maior_desconto DECIMAL(5,2);
    preco_final DECIMAL(10,2);
BEGIN
    SELECT preco INTO preco_original FROM jogos WHERE id_jogo = id_jogo_param;

    SELECT MAX(p.valor_desconto)
    INTO maior_desconto
    FROM promocoes p
    JOIN jogo_promocao jp ON p.id_promocao = jp.id_promocao
    WHERE jp.id_jogo = id_jogo_param
      AND p.tipo_desconto = 'PERCENTUAL'
      AND NOW() BETWEEN p.data_inicio AND p.data_fim;

    IF maior_desconto IS NULL THEN
        preco_final := preco_original;
    ELSE
        preco_final := preco_original * (1 - maior_desconto / 100.0);
    END IF;

    RETURN ROUND(preco_final, 2);
END;
$$ LANGUAGE plpgsql;

-- Função 2: Criar um ticket de suporte
CREATE OR REPLACE PROCEDURE sp_criar_ticket_suporte(
    p_id_remetente INT,
    p_assunto VARCHAR(255),
    p_descricao TEXT,
    p_prioridade VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_ticket INT;
BEGIN
    BEGIN
        INSERT INTO tickets_suporte (assunto, descricao, status, data_abertura, data_ultima_atualizacao, prioridade)
        VALUES (p_assunto, p_descricao, 'Aberto', NOW(), NOW(), p_prioridade)
        RETURNING id_ticket INTO v_id_ticket;

        INSERT INTO mensagens_ticket (id_ticket, id_remetente, conteudo, data_envio)
        VALUES (v_id_ticket, p_id_remetente, p_descricao, NOW());
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Ocorreu um erro ao criar o ticket de suporte. A transação foi revertida.';
            RAISE;
    END;
END;
$$;

-- Função 3: Atualizar a classificação média de um jogo
CREATE OR REPLACE PROCEDURE sp_AtualizarClassificacaoMedia(
    IN p_id_jogo INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_nova_media DECIMAL(3,1);
BEGIN
    SELECT
        COALESCE(AVG(nota), 0)
    INTO
        v_nova_media
    FROM
        avaliacoes_jogo
    WHERE
        id_jogo = p_id_jogo;
    UPDATE
        jogos
    SET
        classificacao_media = v_nova_media
    WHERE
        id_jogo = p_id_jogo;
END;
$$;

-- Função 4: Associar um jogo à uma categoria
CREATE OR REPLACE PROCEDURE sp_AssociarJogoCategoria(
    IN p_id_jogo INT,
    IN p_id_categoria INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_associacao_existente INT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM jogos WHERE id_jogo = p_id_jogo) THEN
        RAISE EXCEPTION 'Erro: O jogo com ID % não foi encontrado.', p_id_jogo;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM categorias WHERE id_categoria = p_id_categoria) THEN
        RAISE EXCEPTION 'Erro: A categoria com ID % não foi encontrada.', p_id_categoria;
    END IF;

    SELECT COUNT(*) INTO v_associacao_existente
    FROM jogo_categoria
    WHERE id_jogo = p_id_jogo AND id_categoria = p_id_categoria;

    IF v_associacao_existente > 0 THEN
        RAISE EXCEPTION 'Erro: O jogo % já está associado à categoria %.', p_id_jogo, p_id_categoria;
    END IF;

    INSERT INTO jogo_categoria (id_jogo, id_categoria)
    VALUES (p_id_jogo, p_id_categoria);

    RAISE NOTICE 'Jogo % associado à categoria % com sucesso.', p_id_jogo, p_id_categoria;

END;
$$;

-- Função 5: Adicionar um jogo à biblioteca de um usuário
CREATE OR REPLACE PROCEDURE sp_AdicionarJogoBibliotecaUsuario(
    IN p_id_usuario INT,
    IN p_id_jogo INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuarios WHERE id_usuario = p_id_usuario) THEN
        RAISE EXCEPTION 'Erro: O usuário com ID % não foi encontrado.', p_id_usuario;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM jogos WHERE id_jogo = p_id_jogo) THEN
        RAISE EXCEPTION 'Erro: O jogo com ID % não foi encontrado.', p_id_jogo;
    END IF;

    IF EXISTS (SELECT 1 FROM jogos_usuario WHERE id_usuario = p_id_usuario AND id_jogo = p_id_jogo) THEN
        RAISE EXCEPTION 'Erro: O usuário % já possui o jogo % em sua biblioteca.', p_id_usuario, p_id_jogo;
    END IF;

    INSERT INTO jogos_usuario (id_usuario, id_jogo, data_aquisicao)
    VALUES (p_id_usuario, p_id_jogo, NOW());

    RAISE NOTICE 'Jogo % adicionado à biblioteca do usuário % com sucesso.', p_id_jogo, p_id_usuario;

END;