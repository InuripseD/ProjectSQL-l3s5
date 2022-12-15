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
des attributs differents il est judicieux de faire une table mere
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
pour pouvoir envoyer un message au Donneur en cas de non validation
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
De même de Donneur, Patient est une table fille de Personne.
Ici on ne stock en plus que le GROUPE_SANGUIN pour permettre 
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
et l'anciennete. 
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
pouvoir Analyser(Traiter) les Dons. Simplement un code d'hopital, un nom et
une adresse pour les differencier.
*/
CREATE TABLE HOPITAL (
    CODE_HOPITAL NUMERIC(10,0),
    NOM VARCHAR(128),
    ADRESSE VARCHAR(128),
    CONSTRAINT PK_CODE_HOPITAL PRIMARY KEY (CODE_HOPITAL)
);

/*
Les Collectes sont la pour recolter les dons. Elles ont une date de debut et 
une date de fin. Une adresse a laquel la collecte prend place et une niveau
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
Un Don a une ID unique, lorsqu'un Donneur(NUM_D) fait un Don pendant 
une Collecte(ID_C). Le Don à une quantité de sang donne, une date de 
don, et un status d'Urgence, urgent si le Donneur est mineur est que la
Collecte est en status Urgent, et normal si le Donneur est majeur.
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
dans un Hopital(CODE_H). Le traitement du don ce fait a une certaine date, et lors
du Traitement le Personnel dit si le Don est Valide ou Non auquel cas un MSG_Refus 
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
Un MSG_REFUS est cree automatiquement lors qu'un Don est Traite puis est determine
comme non valide. Cette table donne la liste de tous les messages qui sont envoie
pour au Donneur don leur Don est Non Valide.
*/
CREATE TABLE MSG_REFUS (
    ID_MSG NUMERIC(10,0),
    ID_D NUMERIC(10,0),
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
est appele pour completer a la fois la table Personne est la table fille
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
Comme mentionne plus haut, ces 3 trigger vont remplire la table Personne
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
de Don NON Valide.
*/
CREATE OR REPLACE TRIGGER Check_valid_don
    AFTER INSERT ON TRAITE
    FOR EACH ROW
DECLARE
    MSG_INDEX INTEGER;
BEGIN
    MSG_INDEX := Get_index_MSG();
    IF(:NEW.VALIDITE = 'NON_VALIDE') THEN
       INSERT INTO MSG_REFUS VALUES (MSG_INDEX, :NEW.ID_D);
    END IF;
END Check_valid_don;
/

/*
CREATE OR REPLACE PROCEDURE INSERT_INTO_DONNEUR( 
    NUMERO PERSONNE.NUM_PERSO%TYPE, 
    NOM PERSONNE.NOM%TYPE, 
    PRENOM PERSONNE.PRENOM%TYPE, 
    CONTACT PERSONNE%TYPE, 
    AGE PERSONNE%TYPE, 
    EMAIL DONNEUR.EMAIL%TYPE) IS
BEGIN
    INSERT INTO PERSONNE(NUMERO, NOM, PRENOM, CONTACT, AGE);
    INSERT INTO DONNEUR(NUMERO, EMAIL);

END;
/
*/

/*
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

BEGIN
    Insert_donneur('Durant','Pierro',0101010212,'12-06-1998','Stagiaire','05-10-2022');
END;
/
*/

prompt -------------------------------------------;
prompt -------- Remplissage des tables! ----------;
prompt -------------------------------------------;

START remplissage_Groupe3.sql;

/*
-------------------------------------------;
-------- Requetes/T sur la base de donnees ----------;
-------------------------------------------;
*/
/*
START test_Groupe3.sql;
*/

