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