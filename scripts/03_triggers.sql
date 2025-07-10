CREATE OR REPLACE FUNCTION fn_atualizar_classificacao_media()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE jogos
    SET classificacao_media = (
        SELECT ROUND(AVG(nota), 1)
        FROM avaliacoes_jogo
        WHERE id_jogo = COALESCE(NEW.id_jogo, OLD.id_jogo)
    )
    WHERE id_jogo = COALESCE(NEW.id_jogo, OLD.id_jogo);

	RETURN NULL;
    
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE TRIGGER tg_atualizar_classificacao_media
AFTER INSERT OR UPDATE OR DELETE ON avaliacoes_jogo
FOR EACH ROW
EXECUTE FUNCTION fn_atualizar_classificacao_media();

CREATE OR REPLACE FUNCTION fn_atualizar_timestamp_carrinho()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE carrinhos_compra
    SET ultima_atualizacao = NOW()
    WHERE id_carrinho = COALESCE(NEW.id_carrinho, OLD.id_carrinho);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tg_atualizar_timestamp_carrinho
AFTER INSERT OR UPDATE OR DELETE ON itens_carrinho
FOR EACH ROW
EXECUTE FUNCTION fn_atualizar_timestamp_carrinho();

