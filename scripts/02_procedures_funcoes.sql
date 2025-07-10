-- Função para calcular o preço de um jogo com desconto percentual
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

-- Função para criar um ticket de suporte
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