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
DROP FUNCTION Get_index_MSG;

prompt -------------------------------------------;
prompt ---    Suppression des relations   --------;
prompt -------------------------------------------;

DROP TABLE TRANSFUSE CASCADE CONSTRAINTS;
DROP TABLE TRAITE CASCADE CONSTRAINTS;
DROP TABLE DON CASCADE CONSTRAINTS;
DROP TABLE COLLECTE CASCADE CONSTRAINTS;
DROP TABLE HOPITAL CASCADE CONSTRAINTS;
DROP TABLE PATIENT CASCADE CONSTRAINTS;
DROP TABLE PERSONNEL CASCADE CONSTRAINTS;
DROP TABLE DONNEUR CASCADE CONSTRAINTS;
DROP TABLE PERSONNE CASCADE CONSTRAINTS;
DROP TABLE MSG_REFUS CASCADE CONSTRAINTS;
