https://docs.google.com/document/d/1vbcbqvZPNH7nLveeizmyAZhd6issmrTYZsAAWsdnKkk/edit



RAPPORT DE PROJET
HAI502I GROUPE B


Numéro de carte étudiant : 22010095		     	Groupe du projet : GROUPE 3
Nom : FAURA BEHAGUE				
Prenom : MATTEO					                Sujet du projet : GESTION DE DON DE SANG				
									
Numéro de carte étudiant : 22020352 		    Professeur de TD : Mr.Guillaume Perution
Nom : DJUNAEDI
Prenom : Rendra					



SPECIFICATIONS :

Notre base de données contiendra des collectes qui auront une date de début, une date de fin, une localisation et les collectes sont identifiées par une id de collecte.

Les collectes récoltent des dons de sang qui seront par la suite envoyés dans des hôpitaux. Chaque don est effectué par un donneur caractérisé par son numéro donneur, ses coordonnées et son numéro de contact. -Le groupe sanguin de ce dernier n'est connu qu'après le traitement/analyse de son don-.

Un don est caractérisé par son id_don, la quantité de sang donnée, la date à laquelle le don a été effectuée pour pouvoir en déduire sa date de péremption (validité du sang) .

Les dons sont envoyés aux hôpitaux qui sont caractérisés par le code hôpital, le nom et l'adresse.

Le don sera analysé par le personnel de l'hôpital et validé ou pas -auquel cas un message sera envoyé au donneur-.

Chaque hôpital reçoit des patients pouvant bénéficier de dons de sang et chaque patient est caractérisé par son id patient, son groupe sanguin et ses coordonnées. -La transfusion n'est faite que si le don est compatible avec le groupe sanguin du patient (après analyse et validation du don par le personnel) -

cordialement,		  


SCHEMA RELATIONNEL :

PERSONNE (NUM_PERSO, NOM, PRENOM, CONTACT, DATE_NAISSANCE)
DONNEUR (#NUM_DONNEUR, EMAIL)
PATIENT (#NUM_PATIENT, GROUPE_SANG)
PERSONNEL (#NUM_PERSONNEL, FONCTION, DATE_ANCIENNETE)
HOPITAL (CODE_HOPITAL, NOM, ADRESSE)
COLLECTE (ID_COLLECTE, DATE_DEBUT, DATE_FIN, LOCALISATION, URGENCE)
DON (ID_DON, QUANTITE, NATURE_DON, DATE_DON, #NUM_D, #ID_C)
MSG_REFUS (ID_MSG, #ID_D)
TRAITE (#NUM_PER, #ID_D, #CODE_H, DATE_TRAITEMENT, VALIDITE, TYPE_SANG)
TRANSFUSE (#ID_D, #NUM_P, #CODE_H, D_TRANSFUSION)


BILAN CE QU'IL RESTE A FAIRE:
- UNE PROCEDURE 
- EXPLICATION REQUETES TRIGGERS ETC...




BONUS:
- AJOUTER REQUETES
