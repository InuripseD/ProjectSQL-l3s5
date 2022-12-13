ALTER session SET NLS_DATE_FORMAT='DD-MM-YYYY';

SET PAGESIZE 30
COLUMN COLUMN_NAME FORMAT A30
SET LINESIZE 300

/*
Effacer les anciennes valeurs des relations
*/

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

prompt -------------------------------------------;
prompt --- Insertion des nouveaux tuples ---------;
prompt -------------------------------------------;

prompt ------------------------------------------;
prompt ---------- insertion DONNEUR -------------;
prompt ------------------------------------------;

INSERT INTO DONNEUR VALUES ();
