/*Kings League equipo 2*/
/*Trigger que controla el maximo de jugadores*/
CREATE OR REPLACE TRIGGER MAX_JUGADORES
FOR INSERT OR UPDATE ON ContratoJugadores 
COMPOUND TRIGGER

    /*Variables*/
    num_habituales NUMBER(2);
    num_wildcards NUMBER;
    new_tipo_jug VARCHAR(20);

 BEFORE EACH ROW IS
 BEGIN
    /*Select para sacar recuento de jugadores habituales de un equipo*/
    SELECT COUNT(*) INTO num_habituales
    FROM ContratoJugadores
    WHERE ID_EQUIPO = :NEW.ID_EQUIPO
    AND ID_JUG IN (SELECT ID_JUG 
                   FROM JUGADORES WHERE UPPER(TIPO) = 'HABITUAL');

    /*Select para sacar recuento de jugadores wildcard de un equipo*/
    SELECT COUNT(*) INTO num_wildcards
    FROM ContratoJugadores
    WHERE ID_EQUIPO = :NEW.ID_EQUIPO
    AND ID_JUG IN (SELECT ID_JUG 
                   FROM JUGADORES WHERE UPPER(TIPO) = 'WILDCARD');
        
    SELECT TIPO INTO NEW_TIPO_JUG FROM JUGADORES WHERE ID_JUG = :NEW.ID_JUG;     
    
 END BEFORE EACH ROW;
 AFTER EACH ROW IS
 BEGIN

    /*Condicion si los jugadores wildcard superan 2*/
    IF UPPER(NEW_TIPO_JUG) = 'WILDCARD' THEN
        IF num_wildcards = 2 THEN
            RAISE_APPLICATION_ERROR(-20001, 'NO SE PUEDEN TENER MAS DE 2 JUGADORES DE TIPO WILDCARD');
        END IF;
    ELSE

    /*Condicion si los jugadores habituales superan 8*/
        IF num_habituales = 8 THEN
            RAISE_APPLICATION_ERROR(-20001, 'NO SE PUEDEN TENER MAS DE 8 JUGADORES DE TIPO HABITUAL');
        END IF;
    END IF;
END AFTER EACH ROW;  
END MAX_JUGADORES;

