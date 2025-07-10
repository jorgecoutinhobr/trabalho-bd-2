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