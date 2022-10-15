/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 03-Curseurs-TP.sql          Auteur : Ch. Stettler
Objet  : TP compétitions sur les curseurs
---------------------------------------------------------------------------- */

CREATE OR REPLACE PACKAGE pkg_compet IS
   PROCEDURE AffiParticipant(i_per_no IN heg_personne.per_no%TYPE);
   PROCEDURE AffiParticipant;
END pkg_compet;
/
CREATE OR REPLACE PACKAGE BODY pkg_compet IS

   PROCEDURE AffiParticipant(i_per_no IN heg_personne.per_no%TYPE) IS
      v_personne    heg_personne%ROWTYPE;
      v_club        heg_club%ROWTYPE;
      v_nb          NUMBER;
   BEGIN
      SELECT * INTO v_personne FROM heg_personne WHERE per_no = i_per_no;
      dbms_output.put(INITCAP(v_personne.per_prenom) || ' ' || UPPER(v_personne.per_nom) || ' (n° ' || v_personne.per_no || ') ');
      
      IF v_personne.per_clu_no IS NOT NULL THEN
         SELECT * INTO v_club FROM heg_club WHERE clu_no = v_personne.per_clu_no;
         dbms_output.put('est membre ');
         IF v_club.clu_per_no = v_personne.per_no THEN
            dbms_output.put('& président ');
         END IF;
         dbms_output.put_line('du club ' || v_club.clu_nom);
      ELSE
         dbms_output.put_line('n''est membre d''aucun club');
      END IF;

      IF UPPER(v_personne.per_sexe)='M' THEN dbms_output.put('Il '); ELSE dbms_output.put('Elle '); END IF;
      SELECT COUNT(*) INTO v_nb FROM heg_participe JOIN heg_competition ON com_no=par_com_no WHERE par_per_no = v_personne.per_no AND com_date<SYSDATE;
      IF v_nb = 0 THEN
         dbms_output.put_line('n''a participé à aucune compétition');
      ELSE
         dbms_output.put_line('a participé aux compétitions suivantes :');
         DECLARE
            CURSOR c_competition IS SELECT com_nom, com_date, com_ville FROM heg_participe JOIN heg_competition ON com_no=par_com_no WHERE par_per_no = v_personne.per_no AND com_date<SYSDATE ORDER BY com_date DESC;
            v_com_nom    heg_competition.com_nom%TYPE;
            v_com_date   heg_competition.com_date%TYPE;
            v_com_ville  heg_competition.com_ville%TYPE;
         BEGIN
            -- FOR v_competition IN c_competition LOOP
            --    dbms_output.put_line(' - ' || v_competition.com_nom || ' du ' || v_competition.com_date || ' à ' || v_competition.com_ville);
            -- END LOOP;
            OPEN c_competition;
            FETCH c_competition INTO v_com_nom, v_com_date, v_com_ville;
            WHILE c_competition%FOUND AND c_competition%ROWCOUNT <= 3 LOOP
               dbms_output.put_line(' - ' || v_com_nom || ' du ' || v_com_date || ' à ' || v_com_ville);
               FETCH c_competition INTO v_com_nom, v_com_date, v_com_ville;
            END LOOP;
            IF v_nb>3 THEN dbms_output.put_line(' - ... ainsi que ' || (v_nb-3) || ' autres compétitions'); END IF;
            CLOSE c_competition;
         END;
      END IF;
      dbms_output.new_line;
   EXCEPTION
      WHEN no_data_found THEN
         dbms_output.put_line('La personne n° ' || i_per_no || ' n''existe pas !');
   END AffiParticipant;

   PROCEDURE AffiParticipant IS
      CURSOR c_personne IS SELECT per_no FROM heg_personne;
   BEGIN
      FOR v_personne IN c_personne LOOP
         AffiParticipant(v_personne.per_no);
      END LOOP;
   END AffiParticipant;

END pkg_compet;
/

/************************************************************/
/* Jeux de tests                                            */
/************************************************************/

BEGIN
   pkg_compet.AffiParticipant(2);
   pkg_compet.AffiParticipant(3);
   pkg_compet.AffiParticipant(5);
   pkg_compet.AffiParticipant(6);
   pkg_compet.AffiParticipant(7);
   pkg_compet.AffiParticipant(20);
   pkg_compet.AffiParticipant(55);
   dbms_output.put_line('===========================================');
   pkg_compet.AffiParticipant;
END;
