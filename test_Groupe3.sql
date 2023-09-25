prompt -------------------------------------------;
prompt -------- TESTS triggers/fonctions ---------;
prompt -------------------------------------------;
prompt
prompt --- Utilisation de notre premier trigger Check_valid_don. 
prompt --- (Lorsqu'on insert un Traitement NON_VALIDE alors on simule un envoie de message en inserant une ligne dans MSG_REFUS.)
prompt
prompt --- Table initial MSG_REFUS ( Il y a deja des lignes car elles ont ete cree lors de l'insertion de Traitement de Don NON_VALIDE )

SELECT * FROM MSG_REFUS;

prompt --- On fait notre Traitement du Don numero 15 est on le met en NON_VALIDE. 

INSERT INTO TRAITE VALUES (27,15,5,'09-08-2020','NON_VALIDE','A+');

prompt --- Table MSG_REFUS après notre Traitement, le trigger Check_valid_don a cree la ligne pour notre Don 15 NON_VALIDE. 

SELECT * FROM MSG_REFUS WHERE ID_D = 15;

prompt --- Voici notre table TRAITE après notre Traitement car le Traitement est tout de meme insere.
prompt --- On peut aussi notifier que le Fonction Get_index_MSG a ete appele et l'id du message a ete incremente automatiquement.

SELECT * FROM TRAITE WHERE ID_D = 15;

prompt --- La Fonction Get_index_MSG est appele dans le Trigger Check_valid_don et sert donc comme auto incrementeur.

prompt

prompt --- Maintenant utilisation de notre deuxieme trigger Insert_[membre]. 
prompt --- Il existe sous 3 variantes est s'active lors d'insertion dans une de nos 3 vues (Donneur, Patient et Personnel).
prompt
prompt --- Tout d'abord on peut voir notre table de PERSONNEL contient 11 membres et que Personne n'est nomme ANTOINE Benoit dans la table PERSONNE.

SELECT COUNT(*) AS NB_PERSONNEL FROM PERSONNEL;

SELECT * FROM PERSONNE WHERE NOM = 'ANTOINE' AND PRENOM = 'Benoit';

prompt --- Seulement on n'a un soucis, car pour inserer une personne on doit verifier le NUM_PERSO a lui donner, de plus Benoit est un INFIRMIER donc
prompt --- on veut le mettre dans PERSONNEL. Donc on a cree une view ALL_PERSONNELS qui combine les PERSONNE et PERSONNEL pour pouvoir inserer a la fois
prompt --- ces coordonees, nom, prenom et aussi son status d'infirmier et la date d'anciennete.
prompt
prompt --- Donc on va inserer Benoit dans la vue ALL_PERSONNELS et le Trigger va inserer toutes les infos respective dans PERSONNE et PERSONNEL.
prompt --- De plus, l'appel a la fonction Get_index va s'effectuer dans le trigger pour etre sur de donner a Benoit une ID non utilise (ni par des Donneurs, ni par des Patients, ni par personne).

INSERT INTO ALL_PERSONNELS(NOM, PRENOM, CONTACT, DATE_NAISSANCE, FONCTION, DATE_ANCIENNETE) VALUES ('ANTOINE','Benoit',0753605050,'26-07-1987','Infirmier','01-05-2010');

prompt --- Donc maintenant Benoit est bien un membre du personnel avec un NUM_PERSONNEL unique grace a la fonction Get_index.

SELECT * FROM PERSONNE WHERE PRENOM = 'Benoit';

SELECT * FROM PERSONNE JOIN PERSONNEL ON NUM_PERSONNEL = NUM_PERSO AND PRENOM = 'Benoit';

prompt -------------------------------------------;
prompt ------------ TESTS procedures -------------;
prompt -------------------------------------------;
prompt 
prompt --- Maintenant utilisation de notre premiere procedure Make_non_valide. 
prompt --- (Procedure pour mettre a jour les dons. Elle va mettre les Dons qui ont ete utilise pour une Transfusion ou s'ils ont ete realise il y plus de 2 mois en NON_VALIDE)
prompt 
prompt --- Tout d'abord on voit que les Traitement sont soit Valide soit Non_Valide. 

SELECT * FROM TRAITE;

prompt --- Maintenant remettons les pendules a l'heure en mettant en NON_VALIDE les Traitement de Dons vieux de plus de 2 mois ou deja utilise pour une Transfusion.

BEGIN
  Make_non_valide();
END;
/

prompt --- On voit qu'il nous reste que le 25 et 26 qui ont ete traite recemment en Valide (si vous lancez la commande avant le 10 fevrier sinon ils seront en NON_VALIDE).

SELECT * FROM TRAITE WHERE VALIDITE = 'VALIDE';

prompt --- Or maintenant si on transfuse le Don 25 a un patient et que l'on refait un coup de Make_non_valide, le Traitement du Don 25 sera en NON_VALIDE;

INSERT INTO TRANSFUSE VALUES (25,20,8,'15-12-2022');

BEGIN
  Make_non_valide();
END;
/

SELECT * FROM TRAITE WHERE ID_D = 25;

prompt --- Grace a cette procedure on peut mettre à jour la liste des Dons qui sont encore VALIDE.

SELECT * FROM TRAITE JOIN DON ON ID_DON = ID_D WHERE VALIDITE = 'VALIDE';
