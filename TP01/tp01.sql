-- 1) Afficher la liste des personnes faisant partie du même club que Dorsa 
SELECT filtered_pers.* FROM heg_personne filtered_pers WHERE 
per_clu_no = (SELECT per_clu_no FROM heg_personne WHERE per_nom = 'Dorsa');

-- 2) Afficher la liste de tous les mails « @heg.ch » (les mails des personnes et des clubs)
SELECT * FROM 
    (SELECT per_email AS mail FROM heg_personne
    UNION
    SELECT clu_email AS mail FROM heg_club)
WHERE INSTR(mail, '@heg.ch') > 0;

-- 3) Afficher la liste des clubs, avec leur nombre de membres, et le nombre de compétitions qu'ils organisent
SELECT 
    clu_nom,
    CASE WHEN (total_per IS NULL) THEN 0 ELSE  total_per END, 
    CASE WHEN (total_com IS NULL) THEN 0 ELSE  total_com END 
FROM heg_club
LEFT JOIN (SELECT per_clu_no, COUNT(per_no) AS total_per FROM heg_personne GROUP BY per_clu_no) ON clu_no = per_clu_no
LEFT JOIN (SELECT com_clu_no, COUNT(com_no) AS total_com FROM heg_competition GROUP BY com_clu_no) ON clu_no = com_clu_no;

-- 4) Conservez pour chaque club la fédération à laquelle il est affilié
CREATE TABLE heg_federation (
    fed_no      NUMBER(5) CONSTRAINT pk_heg_federation PRIMARY KEY,
	fed_nom     VARCHAR2(36) CONSTRAINT nn_fed_nom NOT NULL
);
INSERT INTO heg_federation VALUES(1, 'Swiss Athletics');
INSERT INTO heg_federation VALUES(2, 'ASF (Association Suisse de Football)');
COMMIT;

ALTER TABLE heg_club ADD (clu_fed_no NUMBER(5) CONSTRAINT fk_clu_fed_no REFERENCES heg_federation(fed_no));
COMMIT;

UPDATE heg_club SET clu_federation = 1 WHERE clu_no IN(1,3);
UPDATE heg_club SET clu_federation = 2 WHERE clu_no = 2;
COMMIT;

-- 5) Insérer le nouveau club « HEG-Footing », affilié également à « Swiss Athletics », ayant comme président « Alain Proviste ». L’email du club est le même que celui de son président (la ville également)
INSERT INTO heg_club VALUES (
    (SELECT MAX(clu_no)+1 FROM heg_club), 
    'HEG-Footing',
    (SELECT per_email FROM heg_personne WHERE per_no = 4),
    (SELECT per_ville FROM heg_personne WHERE per_no = 4),
    4, 
    1
);
COMMIT;


-- 6) PL/SQL - Sur le modèle de données Compétition, écrivez le code PL/SQL (dans un bloc anonyme) permettant d’afficher les informations suivantes concernant le club nommé « heg-running »
CREATE OR REPLACE FUNCTION fct_getTotalMembers(idClub IN NUMBER) 
RETURN NUMBER IS 
   v_total NUMBER(5) := 0; 
BEGIN 
    SELECT COUNT(per_no) INTO v_total FROM heg_personne 
    WHERE per_clu_no = idClub;
    
   RETURN v_total; 
END; 
/ 

CREATE OR REPLACE FUNCTION fct_getTotalCompet(idClub IN NUMBER) 
RETURN NUMBER IS 
   v_total NUMBER(5) := 0; 
BEGIN 
    SELECT COUNT(com_no) INTO v_total FROM heg_competition 
    WHERE com_clu_no = idClub;
    
   RETURN v_total; 
END; 
/

CREATE OR REPLACE FUNCTION fct_getAvgCompetPrices(idClub IN NUMBER) 
RETURN NUMBER IS 
   v_average NUMBER(5,2) := 0; 
BEGIN 
    SELECT AVG(com_prix) INTO v_average FROM heg_competition 
    WHERE com_clu_no = idClub;
    
   RETURN v_average; 
END; 
/ 

CREATE OR REPLACE PROCEDURE prc_get_club_details(i_clu_no IN heg_club.clu_no%TYPE) IS
    v_total_members     NUMBER(5) := 0;
    v_total_compet      NUMBER(5) := 0;
    v_avg_price_compet  NUMBER(5,2) := 0;
    v_club              heg_club%ROWTYPE;
    v_president         heg_personne%ROWTYPE;
BEGIN
    v_total_members := fct_getTotalMembers(i_clu_no);
    v_total_compet := fct_getTotalCompet(i_clu_no);
    v_avg_price_compet := fct_getAvgCompetPrices(i_clu_no);
    SELECT * INTO v_club FROM heg_club WHERE clu_no = i_clu_no;
    SELECT * INTO v_president FROM heg_personne WHERE per_no = v_club.clu_per_no;
    
    -- Données du club HEG-Running :
    -- N° du club : 1
    -- Nom : HEG-Running
    -- Ville : Carouge
    -- Président : Alex Terieur (n°3)
    -- Nombre de membres : 11
    -- Nombre de compétitions organisées : 4, prix moyen : Frs 21,67
    dbms_output.put_line('Données du club ' || v_club.clu_nom);
    dbms_output.put_line('N° du club : ' || v_club.clu_no);
    dbms_output.put_line('Nom : ' || v_club.clu_nom);
    dbms_output.put_line('Ville : ' || v_club.clu_ville);
    dbms_output.put_line('Président : ' || v_president.per_prenom || ' ' || v_president.per_nom || '(n°'|| v_president.per_no ||')');
    dbms_output.put_line('Nombre de membres : ' || v_total_members);
    dbms_output.put_line('Nombre de compétitions organisées : ' || v_total_compet || ', prix moyen : Frs ' || v_avg_price_compet);
END;
/

BEGIN
    prc_get_club_details(1);
END;
/
