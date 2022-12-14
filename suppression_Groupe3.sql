prompt -------------------------------------------;
prompt --- Suppression des anciens tuples --------;
prompt -------------------------------------------;

DELETE FROM TRANSFUSE;
DELETE FROM TRAITE;
DELETE FROM DON;
DELETE FROM COLLECTE;
DELETE FROM HOPITAL;
DELETE FROM PATIENT;
DELETE FROM PERSONNEL;
DELETE FROM DONNEUR;
DELETE FROM PERSONNE;
DELETE FROM MSG_REFUS;

prompt -------------------------------------------;
prompt --------- Suppression des views -----------;
prompt -------------------------------------------;

DROP VIEW ALL_DONNEURS;
DROP VIEW ALL_PATIENTS;
DROP VIEW ALL_PERSONNELS;

prompt -------------------------------------------;
prompt -------- Suppression des objects ----------;
prompt -------------------------------------------;

DROP TRIGGER INSERT_DONNEUR;
DROP TRIGGER INSERT_PATIENT;
DROP TRIGGER INSERT_PERSONNEL;
DROP TRIGGER CHECK_VALID_DON;

DROP FUNCTION GET_INDEX;

prompt -------------------------------------------;
prompt ---    Suppression des relations   --------;
prompt -------------------------------------------;

prompt "Suppression des relations"
BEGIN
EXECUTE IMMEDIATE 'DROP TABLE TRANSFUSE CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE TRAITE CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE DON CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE COLLECTE CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE HOPITAL CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE PATIENT CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE PERSONNEL CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE DONNEUR CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE PERSONNE CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE MSG_REFUS CASCADE CONSTRAINTS';
EXCEPTION
 WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
	RAISE;
	END IF;
END;
/
