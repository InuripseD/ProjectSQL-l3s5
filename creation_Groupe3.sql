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

CREATE TABLE PERSONNE (
    NUM_PERSO NUMERIC(10,0),
    NOM VARCHAR(32) CONSTRAINT NOMPERSO NOT NULL,
    PRENOM VARCHAR(32),
    CONTACT NUMERIC(10,0) CHECK (CONTACT BETWEEN 0100000000 AND 9999999999),
    DATE_NAISSANCE DATE,
    CONSTRAINT PK_NUM_PERSO PRIMARY KEY (NUM_PERSO)
);

CREATE TABLE DONNEUR (
    NUM_DONNEUR NUMERIC(10,0),
    EMAIL VARCHAR(64) CONSTRAINT EMAIL_CONSTRAINT_NOT_NULL NOT NULL,
    CONSTRAINT PK_NUM_DONNEUR PRIMARY KEY (NUM_DONNEUR),
    FOREIGN KEY (NUM_DONNEUR) REFERENCES PERSONNE(NUM_PERSO) ON DELETE CASCADE
);

CREATE TABLE PATIENT (
    NUM_PATIENT NUMERIC(10,0),
    GROUPE_SANG VARCHAR(3) CHECK (GROUPE_SANG IN ('O-','O+','A-','A+','B-','B+','AB-','AB+')),
    CONSTRAINT PK_PATIENT PRIMARY KEY (NUM_PATIENT),
    FOREIGN KEY (NUM_PATIENT) REFERENCES PERSONNE(NUM_PERSO) ON DELETE CASCADE
);

CREATE TABLE PERSONNEL (
    NUM_PERSONNEL NUMERIC(10,0),
    FONCTION VARCHAR(32),
    DATE_ANCIENNETE DATE,
    CONSTRAINT PK_PERSONNEL PRIMARY KEY (NUM_PERSONNEL),
    FOREIGN KEY (NUM_PERSONNEL) REFERENCES PERSONNE(NUM_PERSO) ON DELETE CASCADE
);

CREATE TABLE HOPITAL (
    CODE_HOPITAL NUMERIC(10,0),
    NOM VARCHAR(128),
    ADRESSE VARCHAR(128),
    CONSTRAINT PK_CODE_HOPITAL PRIMARY KEY (CODE_HOPITAL)
);

CREATE TABLE COLLECTE (
    ID_COLLECTE NUMERIC(10,0),
    DATE_DEBUT DATE,
    DATE_FIN DATE,
    LOCALISATION VARCHAR(128),
    URGENCE VARCHAR(10) CHECK (URGENCE IN ('URGENT','NORMAL')),
    CONSTRAINT PK_ID_COLLECTE PRIMARY KEY (ID_COLLECTE)
);

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

CREATE TABLE MSG_REFUS (
    ID_MSG NUMERIC(10,0),
    ID_D NUMERIC(10,0),
    CONSTRAINT ID_MSG PRIMARY KEY (ID_MSG),
    FOREIGN KEY (ID_D) REFERENCES DON (ID_DON) ON DELETE CASCADE
);

prompt -------------------------------------------;
prompt ---------- Creation des views! ------------;
prompt -------------------------------------------;

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

CREATE OR REPLACE PROCEDURE SELECT_TRANFUSIONS(
    
)

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
