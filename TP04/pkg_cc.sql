--------------------------------------------------------
--  Fichier créé - jeudi-octobre-13-2022   
--------------------------------------------------------
DROP PACKAGE "HEG_DEVELOPER"."PKG_CC";
DROP PACKAGE BODY "HEG_DEVELOPER"."PKG_CC";
--------------------------------------------------------
--  DDL for Package PKG_CC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HEG_DEVELOPER"."PKG_CC" AS 

  PROCEDURE AfficherLesVendeurs(i_nom_champ IN VARCHAR2);

END PKG_CC;

/
--------------------------------------------------------
--  DDL for Package Body PKG_CC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HEG_DEVELOPER"."PKG_CC" AS

  FUNCTION MeilleursVendeursParPays(i_pay_no IN cc_pays.pay_no%TYPE) RETURN VARCHAR2 IS
  BEGIN
    DECLARE 
        c_vendeur SYS_REFCURSOR;
        v_sql VARCHAR2(200) := 'SELECT * FROM cc_vendeur WHERE ven_pay_no = ' || i_pay_no ||' ORDER BY ven_nbventes DESC';
        v_vendeur cc_vendeur%ROWTYPE;
        v_total_ventes cc_vendeur.ven_nbventes%TYPE := 0;
        v_output VARCHAR2(200);
    BEGIN
        -- Open the cursor
        OPEN c_vendeur FOR v_sql;
        FETCH c_vendeur INTO v_vendeur;
        
        -- Iterate in the recordset until empty AND the total sales greater than 100
        WHILE c_vendeur%FOUND AND v_total_ventes < 100 LOOP
            v_output :=  v_output || CHR(9) || v_vendeur.ven_nom || ' (' || v_vendeur.ven_nbventes || ')';
            v_total_ventes := v_total_ventes + v_vendeur.ven_nbventes;
            FETCH c_vendeur INTO v_vendeur;
        END LOOP;  
        
        RETURN v_output;
    END;
  END MeilleursVendeursParPays;
  
  PROCEDURE AfficherLesVendeurs(i_nom_champ IN VARCHAR2) IS
    exc_invalid_id EXCEPTION;
    PRAGMA EXCEPTION_INIT(exc_invalid_id, -904);
  BEGIN

    DECLARE 
        c_pays SYS_REFCURSOR;
        v_suffix VARCHAR2(4) := 'pay_';
        v_fieldname VARCHAR2(50);
        v_sql VARCHAR2(1000);
        
        TYPE ty_pays_avec_total_ventes IS RECORD
        (pay_no cc_pays.pay_no%TYPE,
         pay_champ VARCHAR2(100),
         pay_nom cc_pays.pay_nom%TYPE,
         total_ventes cc_vendeur.ven_nbventes%TYPE);
        v_pays_avec_ventes ty_pays_avec_total_ventes;
        
    BEGIN

        -- Configure field
        v_fieldname := v_suffix || i_nom_champ;       
        v_sql := 'SELECT all_fields.pay_no, all_fields.'|| v_fieldname ||', all_fields.pay_nom, aggregated_data.total_ventes FROM cc_pays all_fields 
                  JOIN (
                      SELECT pay_no, SUM(ven_nbventes) AS total_ventes 
                      FROM cc_pays 
                      JOIN cc_vendeur ON ven_pay_no = pay_no 
                      WHERE pay_no IN (SELECT DISTINCT ven_pay_no FROM cc_vendeur) 
                      GROUP BY pay_no
                  ) aggregated_data 
                  ON all_fields.pay_no = aggregated_data.pay_no
                  ORDER BY ' || v_fieldname || ' ASC';

        -- Open the cursor
        OPEN c_pays FOR v_sql;
        FETCH c_pays INTO v_pays_avec_ventes;
        
        dbms_output.put_line('Liste des vendeurs par pays, les pays sont triés par ' || i_nom_champ);
                
        -- Iterate in the recordset until empty
        WHILE c_pays%FOUND LOOP
            dbms_output.put_line(v_pays_avec_ventes.pay_champ ||' (' || v_pays_avec_ventes.pay_nom || ') - Total des ventes = ' || v_pays_avec_ventes.total_ventes);
            dbms_output.put_line(MeilleursVendeursParPays( v_pays_avec_ventes.pay_no));
            FETCH c_pays INTO v_pays_avec_ventes;
        END LOOP;
    
    EXCEPTION
        WHEN exc_invalid_id THEN
            dbms_output.put_line('Le champ ' || i_nom_champ || ' n''existe pas');
    END;
  END AfficherLesVendeurs;

END PKG_CC;

/
