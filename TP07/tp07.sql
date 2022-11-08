--------------------------------------------------------
--  Fichier créé - jeudi-novembre-03-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger TRG_CHANGEMENT_CLUB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HEG_DEVELOPER"."TRG_CHANGEMENT_CLUB" 
AFTER UPDATE OF PER_CLU_NO ON HEG_PERSONNE 
FOR EACH ROW
DECLARE
    v_old_clu_nom heg_club.clu_nom%TYPE;
    v_new_clu_nom heg_club.clu_nom%TYPE;
BEGIN
    v_old_clu_nom := PKG_COMPETITION.getClubNamePerCluNo(:OLD.per_clu_no);
    v_new_clu_nom := PKG_COMPETITION.getClubNamePerCluNo(:NEW.per_clu_no);
    
    dbms_output.put_line(:OLD.per_prenom ||' ' || :OLD.per_nom || ' a changé de club :' );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('Ancien club : ' || v_old_clu_nom);
    dbms_output.put_line('Nouveau club : ' || v_new_clu_nom);
    
END;
/
ALTER TRIGGER "HEG_DEVELOPER"."TRG_CHANGEMENT_CLUB" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DELETE_COMPET
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HEG_DEVELOPER"."TRG_DELETE_COMPET" 

-- 3) Trigger doit se déclencher juste avant ou après l'évènement spécifié
AFTER 

-- 2) Sur quel event surveiller ? Au pluriel, plusieur par triger ? INSERT/UPDATE/DELETE
DELETE 

-- 1) Sur quel objet ? Au singulier, un par trigger ! sur quelle table (voire view) ?
ON heg_competition

FOR EACH ROW

BEGIN
    pkg_competition.deleteAllParticipantPerCompetition(:OLD.com_no);
END;


/
ALTER TRIGGER "HEG_DEVELOPER"."TRG_DELETE_COMPET" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_INSERT_PERSONNE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HEG_DEVELOPER"."TRG_INSERT_PERSONNE" 
BEFORE INSERT ON HEG_PERSONNE
FOR EACH ROW
BEGIN
  :NEW.PER_NO := PKG_COMPETITION.getNextNoPer;
END;
/
ALTER TRIGGER "HEG_DEVELOPER"."TRG_INSERT_PERSONNE" ENABLE;
--------------------------------------------------------
--  DDL for Package PKG_COMPETITION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HEG_DEVELOPER"."PKG_COMPETITION" AS 

  PROCEDURE deleteAllParticipantPerCompetition(i_no_com IN heg_competition.com_no%TYPE); 
  FUNCTION getNextNoPer RETURN heg_personne.per_no%TYPE;
  FUNCTION getClubNamePerCluNo(i_clu_no heg_club.clu_no%TYPE) RETURN heg_club.clu_nom%TYPE;

END PKG_COMPETITION;

/
