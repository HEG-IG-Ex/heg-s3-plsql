--------------------------------------------------------
--  Fichier créé - jeudi-septembre-29-2022   
--------------------------------------------------------
DROP PACKAGE PKG_COMPET;

--------------------------------------------------------
--  DDL for Package PKG_COMPET
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PACKAGE PKG_COMPET AS 

    PROCEDURE AfficherCompetition(i_com_no IN heg_competition.com_no%TYPE);  

END PKG_COMPET;

/

CREATE OR REPLACE EDITIONABLE PACKAGE BODY PKG_COMPET AS

   /* ==========================================================================
        NAME :
            participantSentence
        INPUT : 
            Numéro de competition
        OUTPUT: Phrase en fonction du nombre de participant
            - Pas de participant => ''
            - 1 Participant => - Seul participant : Sam Dissoire (Football Club 62-21)
            - >1 Participants => 10 participants            
    ==========================================================================*/ 
    FUNCTION participantSentence(i_com_no IN heg_competition.com_no%TYPE, i_total_participant IN NUMBER) RETURN STRING IS
        vb_sentence VARCHAR2(100);
    BEGIN
         
        IF i_total_participant = 1 THEN
        
            DECLARE
                v_participant heg_personne%ROWTYPE;
                v_club heg_club%ROWTYPE;
            BEGIN
                SELECT heg_personne.* INTO v_participant FROM heg_personne JOIN heg_participe ON per_no = par_per_no WHERE par_com_no = i_com_no;
                SELECT heg_club.* INTO v_club FROM heg_club WHERE clu_no = v_participant.per_clu_no;
                vb_sentence := 'Seul participant: ' ||v_participant.per_prenom || ' ' || v_participant.per_nom || ' (' || v_club.clu_nom || ')';
            END;

        ELSIF i_total_participant > 1 THEN
            vb_sentence := '- ' || i_total_participant || ' participants';
        ELSE
            vb_sentence := NULL;
        END IF;
        
        RETURN vb_sentence;
    END participantSentence;

    /* ==========================================================================
        NAME :
            timingSentence
        INPUT : 
            Date de competition
        OUTPUT: Phrase en fonction de la date de la competition
            - > 2 mois avant/après => Unités = Mois sinon Unité = Jours
            - Dans le passé => Elle a eu lieu il y a 6 jours
            - Dans le futur => Elle aura lieu dans 3 mois          
    ==========================================================================*/ 
    FUNCTION timingSentence(i_date DATE) RETURN STRING IS
        v_nb_days NUMBER(3);
        v_nb_months NUMBER(2);
        v_display_in_month BOOLEAN;
        v_is_past BOOLEAN;
        v_unit VARCHAR2(5);
        v_value NUMBER(3);
        vb_sentence VARCHAR2(50);
    BEGIN

        v_nb_days := LAST_DAY(SYSDATE) - i_date;
        v_nb_months := MONTHS_BETWEEN(SYSDATE, i_date);
        v_display_in_month := ABS(v_nb_months) > 2;
        v_is_past := v_nb_days > 0;
        
        IF v_display_in_month THEN 
            v_unit := 'mois'; 
            v_value := ABS(v_nb_months);
        ELSE 
            v_unit := 'jours'; 
            v_value := ABS(v_nb_days);
        END IF; 
        
        IF v_is_past THEN
            vb_sentence := '- Elle a eu lieu il y a ' || v_value || ' ' || v_unit; 
        ELSE
            vb_sentence := '- Elle aura lieu dans ' || v_value || ' ' || v_unit; 
        END IF;
        
        RETURN vb_sentence;
        
    END timingSentence;

/* ==========================================================================
    NAME :
        AfficherCompetition
    INPUT : 
        Numéro de competition
    OUTPUT: Only display in the console
        Compétition TouDouMollo-Run du 31/10/22 :
        - Lieu : Bout-du-monde (Genève)
        - Elle aura lieu dans 34 jours
        - 16 participants
        - Organisée par le Traînes-Savates BDD (Président: Paul Hochon)
        - Prix d'inscription : 30.-
==========================================================================*/
    PROCEDURE AfficherCompetition(i_com_no IN heg_competition.com_no%TYPE) IS
        v_compet heg_competition%ROWTYPE;
        v_president heg_personne%ROWTYPE;
        v_club heg_club%ROWTYPE; 
        v_total_participant NUMBER(5);
    BEGIN
        DECLARE
            v_no_club BOOLEAN := FALSE;
            v_no_president BOOLEAN := FALSE;
        BEGIN
            SELECT * INTO v_compet FROM heg_competition WHERE com_no = i_com_no;
            
            BEGIN
                SELECT * INTO v_club FROM heg_club WHERE clu_no = v_compet.com_clu_no;
            EXCEPTION
                WHEN no_data_found THEN v_no_club := TRUE;
            END;
            
            BEGIN
                SELECT * INTO v_president FROM heg_personne WHERE per_no = v_club.clu_per_no;
            EXCEPTION
                WHEN no_data_found THEN v_no_president := TRUE;
            END;
            
            SELECT COUNT(*) INTO v_total_participant FROM heg_participe WHERE heg_participe.par_com_no = i_com_no;
            
                    
            dbms_output.put_line('Compétition ' || v_compet.com_nom || ' du ' || v_compet.com_date || ' :');
            dbms_output.put_line('- Lieu : ' || v_compet.com_lieu || ' (' || v_compet.com_ville || ')');
            dbms_output.put_line(timingSentence(v_compet.com_date));
            IF NOT v_total_participant = 0 THEN dbms_output.put_line(participantSentence(i_com_no, v_total_participant)); END IF;
            IF NOT v_no_club THEN dbms_output.put_line('- Organisée par le ' || v_club.clu_nom || ' (Président: ' || v_president.per_prenom || ' ' || v_president.per_nom || ')'); END IF;
            IF v_compet.com_prix IS NOT NULL THEN dbms_output.put_line('- Prix d''inscription : ' || v_compet.com_prix || '.-'); END IF;
            dbms_output.put_line('');
        EXCEPTION
            WHEN no_data_found THEN dbms_output.put_line('La compétition n° ' || i_com_no ||' n''existe pas !');
        END;
        
    END AfficherCompetition;
    
END PKG_COMPET;

/
