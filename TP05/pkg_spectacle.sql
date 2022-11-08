--------------------------------------------------------
--  Fichier cr�� - dimanche-octobre-23-2022   
--------------------------------------------------------
DROP PACKAGE "HEG_DEVELOPER"."PKG_SPECTACLE";
DROP PACKAGE BODY "HEG_DEVELOPER"."PKG_SPECTACLE";
--------------------------------------------------------
--  DDL for Package PKG_SPECTACLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HEG_DEVELOPER"."PKG_SPECTACLE" AS 

              
    v_sort_comedians_field VARCHAR2(20) := 'com_nom';
    v_is_sorted_asc BOOLEAN := TRUE;
   
   PROCEDURE QuiPeutJouerACetteDate(i_date IN cc_representation.rep_date%TYPE);
   
END PKG_SPECTACLE;

/
--------------------------------------------------------
--  DDL for Package Body PKG_SPECTACLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HEG_DEVELOPER"."PKG_SPECTACLE" AS
        
    FUNCTION derni�reRepr�sentation(i_spe_no IN cc_spectacle.spe_no%TYPE, i_date cc_representation.rep_date%TYPE) RETURN cc_representation.rep_date%TYPE IS
        v_derniere_date cc_representation.rep_date%TYPE;
    BEGIN
        SELECT MAX(rep_date) INTO v_derniere_date
        FROM cc_representation WHERE rep_spe_no = i_spe_no AND rep_date < i_date;
        RETURN v_derniere_date;           
    END;

    PROCEDURE QuiPeutJouerCeSpectacle(i_nom_spectacle IN cc_spectacle.spe_nom%TYPE) AS
    BEGIN
    
        DECLARE
            c_comedien SYS_REFCURSOR;
            v_sql VARCHAR2(500);
            v_qui_a_joue_quoi CC_QUI_A_JOUE_QUOI%ROWTYPE;
            
            invalid_identifier EXCEPTION;
            PRAGMA EXCEPTION_INIT(invalid_identifier, -904);
            
        BEGIN
            -- Requ�te pour ne r�cup�rer que les com�diens qui ont d�j� jou�
            v_sql:= 'SELECT * FROM cc_qui_a_joue_quoi WHERE spe_nom = '''|| i_nom_spectacle ||''' ORDER BY ' || v_sort_comedians_field || ' ';
            IF v_is_sorted_asc THEN
                v_sql:= v_sql || 'ASC';
            ELSE
                v_sql:= v_sql || 'DESC';
            END IF;
            
            OPEN c_comedien FOR v_sql;
            FETCH c_comedien INTO v_qui_a_joue_quoi;
            WHILE c_comedien%FOUND LOOP
                dbms_output.put_line('- ' || v_qui_a_joue_quoi.com_nom || ' joue depuis ' || v_qui_a_joue_quoi.com_debut || ' et a d�j� jou� ' || v_qui_a_joue_quoi.nb_joue || ' fois ce spectacle');
                FETCH c_comedien INTO v_qui_a_joue_quoi;
            END LOOP;
            
            CLOSE c_comedien;

            IF c_comedien%ROWCOUNT = 0 THEN
                RAISE NO_DATA_FOUND;
            END IF;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN dbms_output.put_line('Aucun com�dien n''a encore jou� ce spectacle !');
            WHEN invalid_identifier THEN dbms_output.put_line('Erreur dans la d�finition du champ pour trier les com�diens !');
            
        END;

    END QuiPeutJouerCeSpectacle;

    PROCEDURE QuiPeutJouerACetteDate(i_date IN cc_representation.rep_date%TYPE) AS
    BEGIN

        -- Requ�te pour ne r�cup�rer que les spectacles qui ont lieu � cette date
        DECLARE
            CURSOR c_rep IS SELECT spe_no, spe_nom FROM cc_representation JOIN cc_spectacle ON spe_no = rep_spe_no WHERE rep_date = i_date;
            v_spe cc_spectacle%ROWTYPE;
            v_date_derniere_representation cc_representation.rep_date%TYPE;
        BEGIN
        
            OPEN c_rep;
            FETCH c_rep INTO v_spe;
            WHILE c_rep%FOUND LOOP
                
                dbms_output.put_line('Liste des com�diens ayant d�j� jou� "' || v_spe.spe_nom || '" :');
                
                -- V�rifie quand � eu lieu la derni�re repr�sentation
                v_date_derniere_representation:= derni�reRepr�sentation(v_spe.spe_no, i_date);
                IF v_date_derniere_representation IS NULL THEN
                    dbms_output.put_line('==> Ce spectale n''a encore jamais �t� jou� ! ' || CHR(10));
                ELSE
                    -- Appel de la requ�te pour savoir parmis qui est capable de jouer la troupe
                    PKG_SPECTACLE.QuiPeutJouerCeSpectacle(v_spe.spe_nom);
                    dbms_output.put_line('==> Derni�re repr�sentation de ce spectacle : ' || TO_CHAR(v_date_derniere_representation,'DD/MM/YYYY') || CHR(10));
                END IF;
                

                FETCH c_rep INTO v_spe;
            END LOOP;
            
            -- Si il n'y a aucun spectacle pour la date en param�tre
            IF c_rep%ROWCOUNT = 0 THEN
                RAISE NO_DATA_FOUND;
            END IF;
            
        END;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN dbms_output.put_line('Aucun spectacle pr�vu � cette date.');
        
    END QuiPeutJouerACetteDate;

END PKG_SPECTACLE;

/
