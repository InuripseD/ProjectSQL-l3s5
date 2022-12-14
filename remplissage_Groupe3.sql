ALTER session SET NLS_DATE_FORMAT='DD-MM-YYYY';

SET PAGESIZE 30
COLUMN COLUMN_NAME FORMAT A30
SET LINESIZE 300

prompt -------------------------------------------;
prompt --- Insertion des nouveaux tuples ---------;
prompt -------------------------------------------;


prompt ------------------------------------------;
prompt ---------- insertion DONNEUR -------------;
prompt ------------------------------------------;

INSERT INTO ALL_DONNEURS(NOM, PRENOM, CONTACT, DATE_NAISSANCE, EMAIL) VALUES ('Durant','Pierro',0432658594,'16-09-1982','durant.p@umontpellier.fr');
/*
INSERT INTO ALL_DONNEURS VALUES(5,'MARTIN','Martin',0756548595,'05-05-2001','martintiktok@mail.fr');
*/

prompt ------------------------------------------;
prompt ---------- insertion PATIENT -------------;
prompt ------------------------------------------;

INSERT INTO ALL_PATIENTS VALUES(2,'DONT LA','Claire',0636600236,'29-01-1998','A+');

prompt ------------------------------------------;
prompt --------- insertion PERSONNEL ------------;
prompt ------------------------------------------;

INSERT INTO ALL_PERSONNELS VALUES(3,'LAMARCHE','Diego',0636600236,'08-11-1996','Infirmier','10-06-2015');

prompt ------------------------------------------;
prompt ---------- insertion HOPITAL -------------;
prompt ------------------------------------------;

INSERT INTO HOPITAL VALUES (1,'Hopital Lapeyronie','371 Av. du Doyen Gaston Giraud');
INSERT INTO HOPITAL VALUES (2,'Polyclinique Pasteur','3 Rue Pasteur, 34120 Pezenas');
INSERT INTO HOPITAL VALUES (3,'Polyclinique des Trois Vallees','4 Rte de Saint-Pons, 34600 Bedarieux');
INSERT INTO HOPITAL VALUES (4,'Hopital Prive Arnault Tzanck Mougins Sophia Antipolis','122 Av. Maurice Donat, 06250 Mougins');
INSERT INTO HOPITAL VALUES (5,'Hopital prive La Louviere - Ramsay Sante','69 Rue de la Louviere, 59800 Lille');
INSERT INTO HOPITAL VALUES (6,'Hopital Prive Saint-François','62 Rue Saint-François, 57535 Marange-Silvange');
INSERT INTO HOPITAL VALUES (7,'Hopital Suisse de Paris ','10 Rue Minard, 92130 Issy-les-Moulineaux');
INSERT INTO HOPITAL VALUES (8,'Hopital Albert Schweitzer','201 Av. d Alsace, 68000 Colmar');
INSERT INTO HOPITAL VALUES (9,'Centre Hospitalier St-Marcellin','1 Av. Felix Faure, 38160 Saint-Marcellin');
INSERT INTO HOPITAL VALUES (10,'Clinique Medipole Garonne','45 Rue de Gironis, 31036 Toulouse');


prompt ------------------------------------------;
prompt ---------- insertion COLLECTE ------------;
prompt ------------------------------------------;

INSERT INTO COLLECTE VALUES (1,'10-03-2020','30-03-2020','30, Faculte des Sciences de Montpellier, Place E. Bataillon, 34095 Montpellier','NORMAL');
INSERT INTO COLLECTE VALUES (2,'30-03-2020','15-04-2020','22 Av. President Doumer, 66000 Perpignan','URGENT');
INSERT INTO COLLECTE VALUES (3,'30-03-2020','15-04-2020',' 3 Av. Dr Ecoiffier, 66300 Thuir','NORMAL');
INSERT INTO COLLECTE VALUES (4,'17-06-2020','30-06-2020','201 Av. d Alsace, 68000 Colmar','URGENT');
INSERT INTO COLLECTE VALUES (5,'03-01-2019','18-01-2019','Rte de Mende, 34090 Montpellier','NORMAL');
INSERT INTO COLLECTE VALUES (6,'03-01-2019','18-01-2019','52 Av. Paul Alduy, 66100 Perpignan','NORMAL');
INSERT INTO COLLECTE VALUES (7,'25-02-2019','08-03-2019','45 Rue de Gironis, 31036 Toulouse','NORMAL');
INSERT INTO COLLECTE VALUES (8,'13-05-2019','31-05-2019','118 Rte de Narbonne, 31062 Toulouse','NORMAL');
INSERT INTO COLLECTE VALUES (9,'08-08-2020','22-08-2020','7 Pl. Gabriel Peri, 30000 Nîmes','URGENT');
INSERT INTO COLLECTE VALUES (10,'08-08-2020','22-08-2020','10 Rue Trefilerie, 42100 Saint-etienne','NORMAL');
