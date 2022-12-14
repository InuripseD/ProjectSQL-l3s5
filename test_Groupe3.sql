prompt -------------------------------------------;
prompt --- Requetes sur la base de donnees -------;
prompt -------------------------------------------;

prompt --- Requete avec groupe by. (Nombre de Dons par Collecte.) ---;

SELECT ID_COLLECTE, COUNT(*) AS NB_DONS 
FROM COLLECTE 
JOIN DON ON ID_COLLECTE = ID_C 
GROUP BY ID_COLLECTE;

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

SELECT NUM_D, NOM, PRENOM
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
GROUP BY C1.ID_COLLECTE, P1.NOM, P1.PRENOM
HAVING COUNT(*) >= ALL (SELECT COUNT(*) 
                        FROM COLLECTE C2 
                        JOIN DON D2 ON D2.ID_C = C1.ID_COLLECTE 
                        JOIN TRAITE T2 ON D2.ID_DON = T2.ID_D 
                        WHERE C1.ID_COLLECTE = C2.ID_COLLECTE 
                        GROUP BY T2.NUM_PER);

prompt --- Utilisation de notre premier trigger. (Lorsqu'un traitement est NON_VALIDE alors on simule un envoie de message en inserant une ligne dans MSG_REFUS.) ---;

prompt --- Table initial MSG_REFUS ---;

SELECT * FROM MSG_REFUS;

prompt --- On fait notre Traitement refuse du Don numero 15. ---;

INSERT INTO TRAITE VALUES (27,15,5,'09-08-2020','NON_VALIDE','A+');

prompt --- Table MSG_REFUS après notre Traitement, le trigger Check_valid_don a cree la ligne. ---;

SELECT * FROM MSG_REFUS;

prompt --- Table TRAITE après notre Traitement, le traitement est tout de meme insere ---;

SELECT * FROM TRAITE;

prompt --- Fonction Get_index_MSG() et Get_index() pour savoir l'ID du prochain tuple de chaque table sont utilises dans les 2 triggers precedants. ---;
