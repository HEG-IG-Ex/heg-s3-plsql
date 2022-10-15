/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 04-VentesParPays-CreerEnv.sql   Auteur : Stettler
Objet  : Curseurs dynamiques  -  Modèle VendeursParPays  -  Création et remplissage des tables
---------------------------------------------------------------------------- */

DROP TABLE cc_vendeur CASCADE CONSTRAINTS;
DROP TABLE cc_pays CASCADE CONSTRAINTS;

CREATE TABLE cc_pays (
   pay_no       NUMBER(5) CONSTRAINT pk_cc_pays PRIMARY KEY,
   pay_nom      VARCHAR2(25),
   pay_code     VARCHAR2(3),
   pay_iso2     VARCHAR2(3),
   pay_iso3     VARCHAR2(3),
   pay_ison     VARCHAR2(3),
   pay_web      VARCHAR2(3),
   pay_descr    VARCHAR2(60),
   pay_capitale VARCHAR2(20),
   pay_monnaie  VARCHAR2(3),
   pay_tel      VARCHAR2(4)
);

CREATE TABLE cc_vendeur (
   ven_no       NUMBER(5) CONSTRAINT pk_cc_vendeur PRIMARY KEY,
   ven_nom      VARCHAR2(25),
   ven_nbVentes NUMBER(5),
   ven_pay_no   NUMBER(5) CONSTRAINT fk_cc_pays_vendeur REFERENCES cc_pays(pay_no)
);

INSERT INTO cc_pays VALUES (1, 'Albanie', 'ALB', 'AL', 'ALB', '008', '.al', 'Republic of Albania', 'Tirana', 'ALL', '+355');
INSERT INTO cc_pays VALUES (2, 'Allemagne', 'GER', 'DE', 'DEU', '276', '.de', 'Federal Republic of Germany', 'Berlin', 'EUR', '+49');
INSERT INTO cc_pays VALUES (3, 'Andorre', 'AND', 'AD', 'AND', '020', '.ad', 'Principality of Andorra', 'Andorra la Vella', 'EUR', '+376');
INSERT INTO cc_pays VALUES (4, 'Autriche', 'AUT', 'AT', 'AUT', '040', '.at', 'Republic of Austria', 'Vienna', 'EUR', '+43');
INSERT INTO cc_pays VALUES (5, 'Belgique', 'BEL', 'BE', 'BEL', '056', '.be', 'Kingdom of Belgium', 'Brussels', 'EUR', '+32');
INSERT INTO cc_pays VALUES (6, 'Biélorussie', 'BLR', 'BY', 'BLR', '112', '.by', 'Republic of Belarus', 'Minsk', 'BYR', '+375');
INSERT INTO cc_pays VALUES (7, 'Bosnie-Herzégovine', 'BIH', 'BA', 'BIH', '070', '.ba', 'Bosnia and Herzegovina', 'Sarajevo', 'BAM', '+387');
INSERT INTO cc_pays VALUES (8, 'Bulgarie', 'BUL', 'BG', 'BGR', '100', '.bg', 'Republic of Bulgaria', 'Sofia', 'BGN', '+359');
INSERT INTO cc_pays VALUES (9, 'Chypre', 'CYP', 'CY', 'CYP', '196', '.cy', 'Republic of Cyprus', 'Nicosia', 'CYP', '+357');
INSERT INTO cc_pays VALUES (10, 'Croatie', 'CRO', 'HR', 'HRV', '191', '.hr', 'Republic of Croatia', 'Zagreb', 'HRK', '+385');
INSERT INTO cc_pays VALUES (11, 'Danemark', 'DEN', 'DK', 'DNK', '208', '.dk', 'Kingdom of Denmark', 'Copenhagen', 'DKK', '+45');
INSERT INTO cc_pays VALUES (12, 'Espagne', 'ESP', 'ES', 'ESP', '724', '.es', 'Kingdom of Spain', 'Madrid', 'EUR', '+34');
INSERT INTO cc_pays VALUES (13, 'Estonie', 'EST', 'EE', 'EST', '233', '.ee', 'Republic of Estonia', 'Tallinn', 'EEK', '+372');
INSERT INTO cc_pays VALUES (14, 'Finlande', 'FIN', 'FI', 'FIN', '246', '.fi', 'Republic of Finland', 'Helsinki', 'EUR', '+358');
INSERT INTO cc_pays VALUES (15, 'France', 'FRA', 'FR', 'FRA', '250', '.fr', 'French Republic', 'Paris', 'EUR', '+33');
INSERT INTO cc_pays VALUES (16, 'Grèce', 'GRE', 'GR', 'GRC', '300', '.gr', 'Hellenic Republic', 'Athens', 'EUR', '+30');
INSERT INTO cc_pays VALUES (17, 'Hongrie', 'HUN', 'HU', 'HUN', '348', '.hu', 'Republic of Hungary', 'Budapest', 'HUF', '+36');
INSERT INTO cc_pays VALUES (18, 'Irlande', 'IRL', 'IE', 'IRL', '372', '.ie', 'Ireland', 'Dublin', 'EUR', '+353');
INSERT INTO cc_pays VALUES (19, 'Islande', 'ISL', 'IS', 'ISL', '352', '.is', 'Republic of Iceland', 'Reykjavik', 'ISK', '+354');
INSERT INTO cc_pays VALUES (20, 'Italie', 'ITA', 'IT', 'ITA', '380', '.it', 'Italian Republic', 'Rome', 'EUR', '+39');
INSERT INTO cc_pays VALUES (21, 'Lettonie', 'LAT', 'LV', 'LVA', '428', '.lv', 'Republic of Latvia', 'Riga', 'LVL', '+371');
INSERT INTO cc_pays VALUES (22, 'Liechtenstein', 'LIE', 'LI', 'LIE', '438', '.li', 'Principality of Liechtenstein', 'Vaduz', 'CHF', '+423');
INSERT INTO cc_pays VALUES (23, 'Lituanie', 'LTU', 'LT', 'LTU', '440', '.lt', 'Republic of Lithuania', 'Vilnius', 'LTL', '+370');
INSERT INTO cc_pays VALUES (24, 'Luxembourg', 'LUX', 'LU', 'LUX', '442', '.lu', 'Grand Duchy of Luxembourg', 'Luxembourg', 'EUR', '+352');
INSERT INTO cc_pays VALUES (25, 'Malte', 'MLT', 'MT', 'MLT', '470', '.mt', 'Republic of Malta', 'Valletta', 'MTL', '+356');
INSERT INTO cc_pays VALUES (26, 'Moldavie', 'MDA', 'MD', 'MDA', '498', '.md', 'Republic of Moldova', 'Chisinau', 'MDL', '+373');
INSERT INTO cc_pays VALUES (27, 'Monaco', 'MON', 'MC', 'MCO', '492', '.mc', 'Principality of Monaco', 'Monaco', 'EUR', '+377');
INSERT INTO cc_pays VALUES (28, 'Monténégro', 'MNE', 'ME', 'MNE', '499', '.me', 'Republic of Montenegro', 'Podgorica', 'EUR', '+382');
INSERT INTO cc_pays VALUES (29, 'Norvège', 'NOR', 'NO', 'NOR', '578', '.no', 'Kingdom of Norway', 'Oslo', 'NOK', '+47');
INSERT INTO cc_pays VALUES (30, 'Pays-Bas', 'NED', 'NL', 'NLD', '528', '.nl', 'Kingdom of the Netherlands', 'Amsterdam', 'EUR', '+31');
INSERT INTO cc_pays VALUES (31, 'Pologne', 'POL', 'PL', 'POL', '616', '.pl', 'Republic of Poland', 'Warsaw', 'PLN', '+48');
INSERT INTO cc_pays VALUES (32, 'Portugal', 'POR', 'PT', 'PRT', '620', '.pt', 'Portuguese Republic', 'Lisbon', 'EUR', '+351');
INSERT INTO cc_pays VALUES (33, 'République de Macédoine', 'MKD', 'MK', 'MKD', '807', '.mk', 'Republic of Macedonia', 'Skopje', 'MKD', '+389');
INSERT INTO cc_pays VALUES (34, 'République tchèque', 'CZE', 'CZ', 'CZE', '203', '.cz', 'Czech Republic', 'Prague', 'CZK', '+420');
INSERT INTO cc_pays VALUES (35, 'Roumanie', 'ROU', 'RO', 'ROU', '642', '.ro', 'Romania', 'Bucharest', 'RON', '+40');
INSERT INTO cc_pays VALUES (36, 'Royaume-Uni', 'GBR', 'GB', 'GBR', '826', '.uk', 'United Kingdom of Great Britain and Northern Ireland', 'London', 'GBP', '+44');
INSERT INTO cc_pays VALUES (37, 'Russie', 'RUS', 'RU', 'RUS', '643', '.ru', 'Russian Federation', 'Moscow', 'RUB', '+7');
INSERT INTO cc_pays VALUES (38, 'Saint-Marin', 'SMR', 'SM', 'SMR', '674', '.sm', 'Republic of San Marino', 'San Marino', 'EUR', '+378');
INSERT INTO cc_pays VALUES (39, 'Serbie', 'SRB', 'RS', 'SRB', '688', '.rs', 'Republic of Serbia', 'Belgrade', 'RSD', '+381');
INSERT INTO cc_pays VALUES (40, 'Slovaquie', 'SVK', 'SK', 'SVK', '703', '.sk', 'Slovak Republic', 'Bratislava', 'SKK', '+421');
INSERT INTO cc_pays VALUES (41, 'Slovénie', 'SLO', 'SI', 'SVN', '705', '.si', 'Republic of Slovenia', 'Ljubljana', 'EUR', '+386');
INSERT INTO cc_pays VALUES (42, 'Suède', 'SWE', 'SE', 'SWE', '752', '.se', 'Kingdom of Sweden', 'Stockholm', 'SEK', '+46');
INSERT INTO cc_pays VALUES (43, 'Suisse', 'SUI', 'CH', 'CHE', '756', '.ch', 'Swiss Confederation', 'Bern', 'CHF', '+41');
INSERT INTO cc_pays VALUES (44, 'Ukraine', 'UKR', 'UA', 'UKR', '804', '.ua', 'Ukraine', 'Kiev', 'UAH', '+380');
COMMIT;

INSERT INTO cc_vendeur VALUES (1, 'Sauser Alexandre', 33, 15);
INSERT INTO cc_vendeur VALUES (2, 'Blanco Raphael', 44, 12);
INSERT INTO cc_vendeur VALUES (3, 'Parisot Noe', 44, 15);
INSERT INTO cc_vendeur VALUES (4, 'Piaget Juliette', 33, 20);
INSERT INTO cc_vendeur VALUES (5, 'Gorgerat Alexandre', 14, 43);
INSERT INTO cc_vendeur VALUES (6, 'Rey Emilie', 11, 15);
INSERT INTO cc_vendeur VALUES (7, 'Charles Geraldine', 11, 43);
INSERT INTO cc_vendeur VALUES (8, 'Favre Arthur', 33, 43);
INSERT INTO cc_vendeur VALUES (9, 'Minder Liam', 33, 20);
INSERT INTO cc_vendeur VALUES (10, 'Saillen Lynn', 5, 43);
INSERT INTO cc_vendeur VALUES (11, 'Bartolini Jan-Lucas', 5, 43);
INSERT INTO cc_vendeur VALUES (12, 'Fraiseau Samantha', 14, 43);
INSERT INTO cc_vendeur VALUES (13, 'Nasser Theo', 22, 20);
INSERT INTO cc_vendeur VALUES (14, 'Seppey Loris', 55, 2);
INSERT INTO cc_vendeur VALUES (15, 'Pirolli Antonia', 11, 20);
INSERT INTO cc_vendeur VALUES (16, 'Stucki Marianne', 33, 15);
INSERT INTO cc_vendeur VALUES (17, 'Hofmann Simon', 22, 15);
INSERT INTO cc_vendeur VALUES (18, 'Delrio Tom', 22, 43);
INSERT INTO cc_vendeur VALUES (19, 'Sandoz Flavio', 3, 43);
INSERT INTO cc_vendeur VALUES (20, 'Blum Kylian', 1, 43);
INSERT INTO cc_vendeur VALUES (21, 'Ames Paul', 22, 15);
INSERT INTO cc_vendeur VALUES (22, 'Perroud Cindy', 10, 43);
INSERT INTO cc_vendeur VALUES (23, 'Kern Gaetano', 11, 43);
INSERT INTO cc_vendeur VALUES (24, 'Cortez Guillaume', 10, 43);
INSERT INTO cc_vendeur VALUES (25, 'Jaccard Mandarine', 2, 43);
INSERT INTO cc_vendeur VALUES (26, 'Lynch Corentin', 11, 15);
INSERT INTO cc_vendeur VALUES (27, 'Nogueira Sacha', 22, 20);
INSERT INTO cc_vendeur VALUES (28, 'Major Camille', 20, 43);
INSERT INTO cc_vendeur VALUES (29, 'Hofmann Pascal', 66, 32);
INSERT INTO cc_vendeur VALUES (30, 'Coulon Aline', 22, 12);
INSERT INTO cc_vendeur VALUES (31, 'Pasche Killian', 11, 20);
INSERT INTO cc_vendeur VALUES (32, 'Pessina Sylvie', 111, 20);
INSERT INTO cc_vendeur VALUES (33, 'Sarrasin Johann', 33, 43);
INSERT INTO cc_vendeur VALUES (34, 'Etchepareborda Linda', 15, 43);
INSERT INTO cc_vendeur VALUES (35, 'Martin Gilles', 22, 15);
INSERT INTO cc_vendeur VALUES (36, 'Bichsel Basile', 66, 12);
INSERT INTO cc_vendeur VALUES (37, 'Oguey Melvyn', 11, 20);
INSERT INTO cc_vendeur VALUES (38, 'Gallaz Rayan', 11, 15);
INSERT INTO cc_vendeur VALUES (39, 'Hostettler Justine', 77, 2);
INSERT INTO cc_vendeur VALUES (40, 'Matthys Nils', 11, 43);
COMMIT;
