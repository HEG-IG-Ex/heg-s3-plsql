/* ----------------------------------------------------------------------------
Script : 63-21 - BDD-PL/SQL - CC-Réappro-CreerEnv.sql     Auteur : Ch. Stettler
Objet  : Création et remplissage des tables pour le CC-Réappro du 21/10/2021
---------------------------------------------------------------------------- */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

DROP TABLE cc_ligne_cmde;
DROP TABLE cc_commande;
DROP TABLE cc_produit;
DROP TABLE cc_fournisseur;

CREATE TABLE cc_fournisseur (
   fou_no          NUMBER(5)    CONSTRAINT pk_cc_fournisseur PRIMARY KEY,
   fou_nom         VARCHAR2(20),
   fou_detail      VARCHAR2(40)
);

CREATE TABLE cc_produit (
   pro_no          NUMBER(5)    CONSTRAINT pk_cc_produit PRIMARY KEY,
   pro_nom         VARCHAR2(50),
   pro_stock       NUMBER(5),
   pro_prix_achat  NUMBER(7,2),
   pro_prix_vente  NUMBER(7,2),
   pro_seuil       NUMBER(5),
   pro_lot         NUMBER(5),
   pro_fou_no      NUMBER(5)    CONSTRAINT fk_cc_produit_fournisseur REFERENCES cc_fournisseur(fou_no) CONSTRAINT nn_pro_fou_no NOT NULL
);

CREATE TABLE cc_commande (
   com_no          NUMBER(5)    CONSTRAINT pk_cc_commande PRIMARY KEY,
   com_date        DATE,
   com_total       NUMBER(7,2)  CONSTRAINT ch_com_total CHECK(com_total > 100),
   com_fou_no      NUMBER(5)    CONSTRAINT fk_cc_commande_fournisseur REFERENCES cc_fournisseur(fou_no) CONSTRAINT nn_com_fou_no NOT NULL
);

CREATE TABLE cc_ligne_cmde (
   lig_com_no      NUMBER(5)    CONSTRAINT fk_cc_cmd_produit REFERENCES cc_commande(com_no),
   lig_pro_no      NUMBER(5)    CONSTRAINT fk_cc_produit_cmd REFERENCES cc_produit(pro_no) CONSTRAINT uk_lig_pro_no UNIQUE,
   lig_nombre      NUMBER(5),
   CONSTRAINT pk_cc_ligne_cmde PRIMARY KEY (lig_com_no, lig_pro_no)
);

INSERT INTO cc_fournisseur VALUES (1, 'ElectroShop', 'L''art de l''électronique, Carouge');
INSERT INTO cc_fournisseur VALUES (2, 'ACME', 'Fournitures de bureau, Carouge');
INSERT INTO cc_fournisseur VALUES (3, 'HomeShop', 'Tout pour la maison, Lancy');
INSERT INTO cc_fournisseur VALUES (4, 'Ikea', 'Mobilier et articles ménagers, Vernier');
INSERT INTO cc_fournisseur VALUES (5, 'ACME', 'Distributeur principal, Genève');
INSERT INTO cc_fournisseur VALUES (6, 'Jumbo', 'Magasin de bricolage, Meyrin');
COMMIT;

INSERT INTO cc_produit VALUES (10, 'Gomme à corriger les fautes de syntaxe', 18, 200, 290, 20, 10, 2);
INSERT INTO cc_produit VALUES (20, 'Clavier pour gaucher', 10, 60, 75, 10, 10, 1);
INSERT INTO cc_produit VALUES (30, 'Compas pour tracer des ovales', 14, 40, 55, 25, 20, 2);
INSERT INTO cc_produit VALUES (40, 'Écran braille pour mal voyant', 6, 200, 280, 5, 3, 1);
INSERT INTO cc_produit VALUES (50, 'Lit extra-plat contre le vertige', 3, 200, 300, 2, 1, 4);
INSERT INTO cc_produit VALUES (60, 'Machine à refouler le travail', 7, 200, 295, 10, 5, 3);
INSERT INTO cc_produit VALUES (70, 'Tournevis pour dévisser à gauche', 9, 5, 35, 10, 10, 6);
INSERT INTO cc_produit VALUES (80, 'Téléviseur à image fixe', 8, 70, 95, 5, 10, 1);
INSERT INTO cc_produit VALUES (90, 'Fusil courbé pour tirer dans les coins', 8, 150, 190, 10, 5, 5);
INSERT INTO cc_produit VALUES (100, 'Clavier 1 touche', 15, 60, 80, 10, 10, 1);
INSERT INTO cc_produit VALUES (110, 'Crayon à solution automatique', 40, 100, 125, 5, 5, 2);
INSERT INTO cc_produit VALUES (120, 'Équerre pour angles arrondis', 28, 30, 45, 10, 10, 2);
INSERT INTO cc_produit VALUES (130, 'Article 007 dit James Bond', 25, 100, 150, 5, 5, 5);
INSERT INTO cc_produit VALUES (140, 'Ordinateur en bois pour étudiant', 8, 100, 120, 5, 3, 3);
INSERT INTO cc_produit VALUES (150, 'Marteau à gondoler les vitres', 3, 8, 80, 5, 5, 6);
INSERT INTO cc_produit VALUES (160, 'Souris sans bouton', 13, 40, 65, 20, 25, 1);
INSERT INTO cc_produit VALUES (170, 'Thermomètre pour angle droit', 12, 60, 75, 5, 10, 5);
INSERT INTO cc_produit VALUES (180, 'Sommier antifatigue', 4, 100, 150, 5, 5, 3);
INSERT INTO cc_produit VALUES (190, 'Terminal à temps de réponse nul', 8, 200, 240, 3, 5, 1);
INSERT INTO cc_produit VALUES (200, 'Écouteur pour mal voyant', 10, 200, 230, 10, 3, 5);
COMMIT;
