/*
L3 GROUPE B - PROJET DON DE SANG GROUPE 3 -
*/
/*
Numéro de carte étudiant : 22020352
Nom : DJUNAEDI
Prénom : Rendra
*/
/*
Numéro de carte étudiant : 22010095 
Nom : FAURA BEHAGUE
Prénom : MATTEO
*/

prompt -------------------------------------------;
prompt --- Creation des relations/tables! --------;
prompt -------------------------------------------;

/*
Table mere pour rassembler les elements en commun entre Donneur,
Patient et Personnel. Etant donne que les 3 tables filles possedent
des attributs differents, il est judicieux de faire une table mere
Personne pour contenir le Nom, le Prenom, la Date de naissance etc...
*/
CREATE TABLE PERSONNE (
    NUM_PERSO NUMERIC(10,0),
    NOM VARCHAR(32) CONSTRAINT NOMPERSO NOT NULL,
    PRENOM VARCHAR(32),
    CONTACT NUMERIC(10,0) CHECK (CONTACT BETWEEN 0100000000 AND 9999999999),
    DATE_NAISSANCE DATE,
    CONSTRAINT PK_NUM_PERSO PRIMARY KEY (NUM_PERSO)
);

/*
Table fille de Personne, ici on ne stock qu'un email obligatoire
pour pouvoir envoyer un message au Donneur en cas de Don NON_VALIDE
du Don lors du Traitement. De plus, etant une table fille de Personne,
NUM_DONNEUR est une clef etrangere de Personne mais aussi la clef primaire
de cette table.
*/
CREATE TABLE DONNEUR (
    NUM_DONNEUR NUMERIC(10,0),
    EMAIL VARCHAR(64) CONSTRAINT EMAIL_CONSTRAINT_NOT_NULL NOT NULL,
    CONSTRAINT PK_NUM_DONNEUR PRIMARY KEY (NUM_DONNEUR),
    FOREIGN KEY (NUM_DONNEUR) REFERENCES PERSONNE(NUM_PERSO) ON DELETE CASCADE
);

/*
De même qu'avec Donneur, Patient est une table fille de Personne.
Ici on ne stock en plus que le GROUPE_SANGUIN pour  
pouvoir transfuser le bon type de sang lors d'une transfusion.
*/
CREATE TABLE PATIENT (
    NUM_PATIENT NUMERIC(10,0),
    GROUPE_SANG VARCHAR(3) CHECK (GROUPE_SANG IN ('O-','O+','A-','A+','B-','B+','AB-','AB+')),
    CONSTRAINT PK_PATIENT PRIMARY KEY (NUM_PATIENT),
    FOREIGN KEY (NUM_PATIENT) REFERENCES PERSONNE(NUM_PERSO) ON DELETE CASCADE
);

/*
La table Personnel est une table fille de Personne. Elle contient la fonction
et l'anciennete de chaque Membre du Personnel. 
*/
CREATE TABLE PERSONNEL (
    NUM_PERSONNEL NUMERIC(10,0),
    FONCTION VARCHAR(32),
    DATE_ANCIENNETE DATE,
    CONSTRAINT PK_PERSONNEL PRIMARY KEY (NUM_PERSONNEL),
    FOREIGN KEY (NUM_PERSONNEL) REFERENCES PERSONNE(NUM_PERSO) ON DELETE CASCADE
);

/*
Les Hopitaux sont present dans la table car ils hebergent le Personnel pour
pouvoir Traiter les Dons. Simplement un code d'hopital, un nom et
une adresse pour les differencier. L'Hopital est aussi present lorsqu'il 
s'agit de devoir faire des injections.
*/
CREATE TABLE HOPITAL (
    CODE_HOPITAL NUMERIC(10,0),
    NOM VARCHAR(128),
    ADRESSE VARCHAR(128),
    CONSTRAINT PK_CODE_HOPITAL PRIMARY KEY (CODE_HOPITAL)
);

/*
Les Collectes sont la pour recolter les dons. Elles ont une date de debut et 
une date de fin. Une adresse a laquel la collecte prend place et un niveau
d'urgence. Urgent si la Collecte accepte les Dons de mineurs, et Normal si ce
n'est pas le cas.
*/
CREATE TABLE COLLECTE (
    ID_COLLECTE NUMERIC(10,0),
    DATE_DEBUT DATE,
    DATE_FIN DATE,
    LOCALISATION VARCHAR(128),
    URGENCE VARCHAR(10) CHECK (URGENCE IN ('URGENT','NORMAL')),
    CONSTRAINT PK_ID_COLLECTE PRIMARY KEY (ID_COLLECTE)
);

/*
Un Don a une ID unique, est prend place quand Donneur(NUM_D) fait un Don pendant 
une Collecte(ID_C). Le Don à une quantité de sang, une date de 
don, et un status d'urgence, URGENT si le Donneur est mineur est que la
Collecte est en status Urgent, et NORMAL si le Donneur est majeur.
*/
CREATE TABLE DON (
    ID_DON NUMERIC(10,0),
    QUANTITE INT CHECK (QUANTITE BETWEEN 400 AND 500),
    NATURE_DON VARCHAR(10) CHECK (NATURE_DON IN ('URGENT','NORMAL')),
    DATE_DON DATE,
    NUM_D NUMERIC(10,0),
    ID_C NUMERIC(10,0),
    CONSTRAINT PK_ID_DON PRIMARY KEY (ID_DON),
    FOREIGN KEY (NUM_D) REFERENCES DONNEUR (NUM_DONNEUR) ON DELETE CASCADE,
    FOREIGN KEY (ID_C) REFERENCES COLLECTE (ID_COLLECTE) ON DELETE CASCADE
);

/*
La clef primaire de Traite est le num du Personnel(NUM_PER) qui Traite un Don(ID_D)
dans un Hopital(CODE_H). Le traitement du Don ce fait a une certaine date, et lors
du Traitement le Personnel dit si le Don est VALIDE ou NON_VALIDE auquel cas un MSG_REFUS 
est cree. De plus, le groupe sanguin du sang du Don est determine.
*/
CREATE TABLE TRAITE (
    NUM_PER NUMERIC(10,0),
    ID_D NUMERIC(10,0),
    CODE_H NUMERIC(10,0),
    DATE_TRAITEMENT DATE,
    VALIDITE VARCHAR(15) CHECK (VALIDITE IN ('VALIDE','NON_VALIDE')),
    TYPE_SANG VARCHAR(3) CHECK (TYPE_SANG IN ('O-','O+','A-','A+','B-','B+','AB-','AB+')),
    CONSTRAINT NUM_TRAITE PRIMARY KEY (NUM_PER, ID_D, CODE_H),
    FOREIGN KEY (NUM_PER) REFERENCES PERSONNEL (NUM_PERSONNEL) ON DELETE CASCADE,
    FOREIGN KEY (ID_D) REFERENCES DON (ID_DON) ON DELETE CASCADE,
    FOREIGN KEY (CODE_H) REFERENCES HOPITAL (CODE_HOPITAL) ON DELETE CASCADE
);

/*
Une Transfusion s'effectue d'un Don (ID_D) a un Patient (NUM_P) dans un Hopital (CODE_H) 
a une certaine Date.
*/
CREATE TABLE TRANSFUSE (
    ID_D NUMERIC(10,0),
    NUM_P NUMERIC(10,0),
    CODE_H NUMERIC(10,0),
    D_TRANSFUSION DATE,
    CONSTRAINT NUM_TRANSUSION PRIMARY KEY (ID_D, NUM_P, CODE_H),
    FOREIGN KEY (ID_D) REFERENCES DON (ID_DON) ON DELETE CASCADE,
    FOREIGN KEY (NUM_P) REFERENCES PATIENT (NUM_PATIENT) ON DELETE CASCADE,
    FOREIGN KEY (CODE_H) REFERENCES HOPITAL (CODE_HOPITAL) ON DELETE CASCADE
);

/*
Un MSG_REFUS est cree automatiquement lorsqu'un Don(ID_D) Traite est determine comme NON_VALIDE.
Cette table donne la liste de tous les messages qui sont envoye au Donneur dont 
leur Don est NON_VALIDE. (On n'a recopie le mail du Donneur pour mieux similuer l'envoie).
*/
CREATE TABLE MSG_REFUS (
    ID_MSG NUMERIC(10,0),
    ID_D NUMERIC(10,0),
    MAIL_DONNEUR VARCHAR(64),
    CONSTRAINT ID_MSG PRIMARY KEY (ID_MSG),
    FOREIGN KEY (ID_D) REFERENCES DON (ID_DON) ON DELETE CASCADE
);

prompt -------------------------------------------;
prompt ---------- Creation des views! ------------;
prompt -------------------------------------------;

/*
Ces 3 views sont creees pour permettre le remplissage des tables
Personne et de ces tables filles en meme temps. Lors de l'insertion
d'une ligne dans l'une de ces tables, les trigger Insert_[Type_de_Personne] 
sont appelees pour completer a la fois la table Personne est la table fille
Donneur, Patient ou Personnel. Ainsi on n'insere jamais directement dans 
Les tables mais plutôt dans ces 3 views, puis les triggers ce charge du reste.
*/

CREATE VIEW ALL_DONNEURS AS 
	SELECT NUM_PERSO, NOM, PRENOM, CONTACT, DATE_NAISSANCE, EMAIL
		FROM PERSONNE
		JOIN DONNEUR ON NUM_DONNEUR = NUM_PERSO;

CREATE VIEW ALL_PATIENTS AS 
	SELECT NUM_PERSO, NOM, PRENOM, CONTACT, DATE_NAISSANCE, GROUPE_SANG
		FROM PERSONNE
		JOIN PATIENT ON NUM_PATIENT = NUM_PERSO;
    
CREATE VIEW ALL_PERSONNELS AS 
	SELECT NUM_PERSO, NOM, PRENOM, CONTACT, DATE_NAISSANCE, FONCTION, DATE_ANCIENNETE
		FROM PERSONNE
		JOIN PERSONNEL ON NUM_PERSONNEL = NUM_PERSO;

prompt -------------------------------------------;
prompt -------- Création des objects! ------------;
prompt -------------------------------------------;

/*
Permet de connaitre l'id de la derniere Personne.
Cette fontion est utile pour les triggers. 
*/
CREATE OR REPLACE FUNCTION Get_index
RETURN INTEGER IS
    NUM_INDEX INTEGER;
BEGIN
    SELECT COUNT(*) INTO NUM_INDEX FROM PERSONNE;
    IF NUM_INDEX = 0 THEN
        NUM_INDEX := 1;
    ELSE
        SELECT MAX(NUM_PERSO) INTO NUM_INDEX FROM PERSONNE;
        NUM_INDEX := NUM_INDEX + 1;
    END IF;
    RETURN (NUM_INDEX);
END;
/

/*
Permet de connaitre l'id du dernier MSG de Refus.
Cette fontion est utile pour les triggers. 
*/
CREATE OR REPLACE FUNCTION Get_index_MSG
RETURN INTEGER IS
    MSG_INDEX INTEGER;
BEGIN
    SELECT COUNT(*) INTO MSG_INDEX FROM MSG_REFUS;
    IF MSG_INDEX = 0 THEN
        MSG_INDEX := 1;
    ELSE
        SELECT MAX(ID_MSG) INTO MSG_INDEX FROM MSG_REFUS;
        MSG_INDEX := MSG_INDEX + 1;
    END IF;
    RETURN (MSG_INDEX);
END;
/

/*
Comme mentionne plus haut, ces 3 triggers vont remplire la table Personne
et la table fille associe. 
*/
CREATE OR REPLACE TRIGGER Insert_donneur
    INSTEAD OF INSERT ON ALL_DONNEURS
    DECLARE
        NUM_INDEX INTEGER;
BEGIN
    NUM_INDEX := Get_index();
    INSERT INTO PERSONNE (NUM_PERSO, NOM, PRENOM,CONTACT,DATE_NAISSANCE) VALUES (NUM_INDEX,:NEW.NOM,:NEW.PRENOM,:NEW.CONTACT,:NEW.DATE_NAISSANCE);
    INSERT INTO DONNEUR (NUM_DONNEUR, EMAIL) VALUES (NUM_INDEX,:NEW.EMAIL);
END Insert_donneur;
/

CREATE OR REPLACE TRIGGER Insert_patient
    INSTEAD OF INSERT ON ALL_PATIENTS
    DECLARE
        NUM_INDEX INTEGER;
BEGIN
    NUM_INDEX := Get_index();
    INSERT INTO PERSONNE (NUM_PERSO, NOM, PRENOM,CONTACT,DATE_NAISSANCE) VALUES (NUM_INDEX,:NEW.NOM,:NEW.PRENOM,:NEW.CONTACT,:NEW.DATE_NAISSANCE);
    INSERT INTO PATIENT (NUM_PATIENT, GROUPE_SANG) VALUES (NUM_INDEX,:NEW.GROUPE_SANG);
END Insert_patient;
/

CREATE OR REPLACE TRIGGER Insert_personnel
    INSTEAD OF INSERT ON ALL_PERSONNELS
    DECLARE
        NUM_INDEX INTEGER;
BEGIN
    NUM_INDEX := Get_index();
    INSERT INTO PERSONNE (NUM_PERSO, NOM, PRENOM,CONTACT,DATE_NAISSANCE) VALUES (NUM_INDEX,:NEW.NOM,:NEW.PRENOM,:NEW.CONTACT,:NEW.DATE_NAISSANCE);
    INSERT INTO PERSONNEL (NUM_PERSONNEL, FONCTION, DATE_ANCIENNETE) VALUES (NUM_INDEX,:NEW.FONCTION,:NEW.DATE_ANCIENNETE);
END Insert_personnel;
/

/*
Ce trigger va creer un MSG de Refus lors de l'insertion de Traitement
de Don NON_VALIDE.
*/
CREATE OR REPLACE TRIGGER Check_valid_don
    AFTER INSERT ON TRAITE
    FOR EACH ROW
DECLARE
    MSG_INDEX INTEGER;
    MAIL VARCHAR(64);
BEGIN
    MSG_INDEX := Get_index_MSG();
    SELECT EMAIL INTO MAIL FROM DONNEUR WHERE NUM_DONNEUR IN (SELECT NUM_D FROM DON WHERE :NEW.ID_D = ID_DON);
    IF(:NEW.VALIDITE = 'NON_VALIDE') THEN
       INSERT INTO MSG_REFUS VALUES (MSG_INDEX, :NEW.ID_D, MAIL);
    END IF;
END Check_valid_don;
/

/*
Ctte procedure va mettre a jour la table Traite en mettant les Traitement de Don en mode NON_VALIDE
s'il sont vieux de plus de 2 mois ou si le don en question a ete Transfuse.
On remarque ici qu'il n'est pas question d'envoyer de message de refus.
*/
CREATE OR REPLACE PROCEDURE Make_non_valide AS
BEGIN
    UPDATE TRAITE SET VALIDITE = 'NON_VALIDE' 
        WHERE (SELECT MONTHS_BETWEEN((SELECT SYSDATE FROM DUAL),DATE_TRAITEMENT) FROM DUAL) > 2 
        OR TRAITE.ID_D IN (SELECT TRANSFUSE.ID_D FROM TRANSFUSE);
END;
/


/*

-------------------------------------------;
------ Requetes/Tests sur la base ---------;
-------------------------------------------;

prompt --- Procedure pour obtenir la liste des dons qui sont valides est du meme groupe sanguin qu'un patient pour pouvoir lui faire une injection.

CREATE OR REPLACE PROCEDURE Know_transfuse(NUMERO_PATIENT IN NUMERIC(10,0))
AS
    CURSOR LesBonsDons IS SELECT * FROM TRAITE WHERE VALIDITE = 'VALIDE' AND TYPE_SANG IN (SELECT GROUPE_SANG FROM PATIENT WHERE NUM_PATIENT = NUMERO_PATIENT);
    un_don DON%TYPE;
BEGIN
    OPEN LesBonsDons;
    LOOP
    FETCH LesBonsDons INTO un_don;
    DBMS_OUTPUT.PUT_LINE(un_don.ID_DON);
    EXIT WHEN LesBonsDons%NOTFOUND;
    END LOOP;
    CLOSE LesBonsDons;
END;
/

prompt --- T'entative de Procedure a la place des triggers plus views.

CREATE OR REPLACE PROCEDURE Insert_donneur(
    p_nom IN VARCHAR(32), 
    p_prenom IN VARCHAR(32), 
    p_contact IN NUMERIC(10,0), 
    p_date_naissance IN DATE, 
    p_fonction IN VARCHAR(32),
    p_date_anciennete IN DATE)
IS
    NUM_INDEX INTEGER;
BEGIN
    NUM_INDEX = Get_index();
    INSERT INTO PERSONNE (NUM_PERSO, NOM, PRENOM, CONTACT, DATE_NAISSANCE) VALUES (NUM_INDEX, p_nom, p_prenom, p_contact, p_date_naissance);
    INSERT INTO PERSONNEL (NUM_PERSONNEL,FONCTION,DATE_ANCIENNETE) VALUES (NUM_INDEX, p_fonction, p_date_anciennete);
    COMMIT;
END;
/
*/

prompt -------------------------------------------;
prompt -------- Remplissage des tables! ----------;
prompt -------------------------------------------;

START remplissage_Groupe3.sql;

prompt -------------------------------------------;
prompt --- Requetes sur la base de donnees -------;
prompt -------------------------------------------;
prompt
prompt --- Requete avec groupe by. ( On demande le nombre de Dons par Collecte.) ---;
/*
L'utilisation d'un left join ecrit qu'il y a un don dan les collecte ou il n'y en a pas.
C'est pourquoi on a procede comme suivant.
*/

SELECT ID_COLLECTE, COUNT(*) AS NB_DONS 
FROM COLLECTE 
JOIN DON ON ID_COLLECTE = ID_C 
GROUP BY ID_COLLECTE
UNION
SELECT ID_COLLECTE, 0 AS NB_DONS
FROM COLLECTE WHERE ID_COLLECTE NOT IN ( SELECT ID_COLLECTE 
                                         FROM COLLECTE 
                                         JOIN DON ON ID_COLLECTE = ID_C 
                                         GROUP BY ID_COLLECTE);

prompt --- Requete utilisant une division. (Existe-t-il une collecte ou tous les Donneurs sont alles ?) ---;

SELECT DISTINCT C.ID_COLLECTE
FROM COLLECTE C
WHERE NOT EXISTS (SELECT * FROM DONNEUR D 
                    WHERE NOT EXISTS (SELECT * FROM DON D1
                                      WHERE C.ID_COLLECTE = D1.ID_C
                                        AND D1.NUM_D = D.NUM_DONNEUR));

prompt --- Requete utilisant une division. (Existe-t-il une collecte ou tous les Donneurs nommes SANCHEZ sont alles DEPUIS 01-01-2019?) ---;

SELECT DISTINCT C.ID_COLLECTE
FROM COLLECTE C
WHERE DATE_DEBUT > TO_DATE('01-01-2019') AND NOT EXISTS (SELECT * FROM DONNEUR D JOIN PERSONNE P ON P.NUM_PERSO = D.NUM_DONNEUR
                    WHERE P.NOM = 'SANCHEZ' AND NOT EXISTS (SELECT * FROM DON D1
                                      WHERE C.ID_COLLECTE = D1.ID_C
                                        AND D1.NUM_D = D.NUM_DONNEUR));

prompt --- Requete contenant deux sous requete. (Nom des Donneurs de la collecte pour laquelle il y a eu le plus de Don.) ---;

SELECT ID_COLLECTE, NUM_D, NOM, PRENOM
FROM COLLECTE
JOIN DON ON ID_COLLECTE = ID_C
JOIN PERSONNE ON NUM_PERSO = ID_DON
WHERE ID_COLLECTE IN ( SELECT ID_C
				  FROM DON
				  GROUP BY ID_C
				  HAVING COUNT(*) > = ALL (SELECT COUNT(*) 
                                           FROM DON 
                                           GROUP BY ID_C) ); 

prompt --- Requete contenant une sous requete correlative. (Pour chaque collecte, le nom du Personnel(s) ayant traité le plus de Don.) ---;

prompt --- On voit ici que pour la collecte d'id 10, on a Diego qui a fait 2 analyses et Louis qui en fait qu'une.

SELECT C1.ID_COLLECTE, P1.NOM, P1.PRENOM, COUNT(*) AS NB_TRAITEMENT
FROM PERSONNE P1 
JOIN TRAITE T1 ON P1.NUM_PERSO = T1.NUM_PER
JOIN DON D1 ON T1.ID_D = D1.ID_DON
JOIN COLLECTE C1 ON D1.ID_C = C1.ID_COLLECTE
GROUP BY C1.ID_COLLECTE, P1.NOM, P1.PRENOM;

prompt --- Et donc ici Louis n'est pas mentionne car ce n'est pas celui qui a fait le plus d'analyse pour la collecte numero 10.

SELECT C1.ID_COLLECTE, P1.NOM, P1.PRENOM, COUNT(*) AS NB_TRAITEMENT
FROM PERSONNE P1 
JOIN TRAITE T1 ON P1.NUM_PERSO = T1.NUM_PER
JOIN DON D1 ON T1.ID_D = D1.ID_DON
JOIN COLLECTE C1 ON D1.ID_C = C1.ID_COLLECTE
GROUP BY C1.ID_COLLECTE, T1.NUM_PER, P1.NOM, P1.PRENOM
HAVING COUNT(*) >= ALL (SELECT COUNT(*) 
                        FROM COLLECTE C2 
                        JOIN DON D2 ON D2.ID_C = C1.ID_COLLECTE 
                        JOIN TRAITE T2 ON D2.ID_DON = T2.ID_D 
                        WHERE C1.ID_COLLECTE = C2.ID_COLLECTE 
                        GROUP BY T2.NUM_PER);

