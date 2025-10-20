-- 1. obtenir les patients, avec leurs caractéristiques, dans l'ordre alphabétique 

SELECT * FROM `Patients` ORDER BY nom ASC; -- récupère toutes les colonnes (patients + caractéristiques) depuis la table Patients et les trie par ordre alphabétique croissant selon leur nom.

-- 2. obtenir le nombre de patients adultes hospitalisés, 

SELECT COUNT(id_patient) AS 'nombre de patients adultes hospitalisés' FROM `Patients` WHERE âge >= 18; -- compte le nombre de patients parmi ceux qui ont 18 ans ou plus (adultes)

-- 3. obtenir les médecins qui suivent moins de 3 patients, 

SELECT nom, prénom FROM `Médecins` WHERE nombre_patients < 3; --  noms et prénoms des médecins dont le nombre de patients est inférieur à 3

-- 4. obtenir le nombre de médecins pour chaque pathologie, 

SELECT p.nom_pathologie, COUNT(DISTINCT m.medecinID) AS nombre_medecins  -- Compte le nombre unique des médecins liés à chaque pathologie
FROM Pathologies p JOIN Spécialités_Pathologies sp ON p.id_pathologie = sp.id_pathologie JOIN Médecins m ON sp.nom_spécialité = m.nom_spécialité 
GROUP BY p.nom_pathologie; -- regroupe les résultats par pathologie

-- 5. obtenir le nombre de lits libres par spécialité 

SELECT c.nom_spécialité,
  SUM(c.nb_lits) - SUM(nb_occupe.nb_occupe_par_chambre) AS lits_libres -- Calcul des lits libres
FROM Chambre c
-- Faire une jointure avec un sous-ensemble qui compte le nombre de patients actuellement hospitalisés par chambre
LEFT JOIN (
    SELECT i.id_chambre,
      COUNT(*) AS nb_occupe_par_chambre -- Nombre de patients dans cette chambre (seulement ceux encore hospitalisés)
    FROM internation i
    WHERE i.date_sortie IS NULL -- Ne prendre en compte que les patients encore hospitalisés (pas encore sortis)
    GROUP BY i.id_chambre -- Regrouper par chambre pour compter le nombre de patients par chambre
) AS nb_occupe
ON c.id_chambre = nb_occupe.id_chambre -- Associer chaque chambre à son nombre de patients actuellement hospitalisés
GROUP BY c.nom_spécialité; -- Regrouper le résultat final par spécialité


-- 6. obtenir la liste des patientes (femmes) traîtées par une spécialité chirurgicale 

SELECT P.* FROM `Patients` P JOIN Spécialités_Pathologies SP ON P.id_pathologie=SP.id_pathologie JOIN Spécialités S ON SP.nom_spécialité=S.nom_spécialité WHERE S.type = "Chirurgie" AND P.sexe=1;

-- 7. obtenir les numéros des chambres où il reste un lit disponible pour un homme, et la spécialité de laquelle elles dépendent 

SELECT C.id_chambre, C.nom_spécialité,
       C.nb_lits - COUNT(I.id_patient) AS lits_libres_pour_hommes -- lit(s) disponible(s)
FROM `Chambre` C LEFT JOIN internation I ON C.id_chambre=I.id_chambre 
WHERE C.genre=2 -- chambres pour hommes
GROUP BY C.id_chambre; 

-- 8. procéder à l'entrée d'un patient 

-- vérifier si le patient existe déjà dans la base de données avant de l'ajouter-- 

-- -- 1. Si le patient n'existe pas, insérez-le 
INSERT INTO Patients(nom, prénom, âge, sexe, id_pathologie) VALUES ('Lopes Santiago', 'Luana', 22, 1, 8); 

-- -- 2. Stockez l'ID du nouveau patient 
SET @id_patient := LAST_INSERT_ID(); 

-- -- 3. Trouvez la spécialité associée 
SET @specialite := (SELECT nom_spécialité FROM Spécialités_Pathologies WHERE id_pathologie = (SELECT id_pathologie FROM Patients WHERE id_patient = @id_patient) LIMIT 1); 

-- -- 4. Trouvez une chambre avec cette spécialité qui a au moins un lit libre et un genre compatible 
SET @id_chambre := ( SELECT C.id_chambre FROM Chambre C LEFT JOIN internation I ON C.id_chambre = I.id_chambre AND I.date_sortie IS NULL WHERE C.nom_spécialité = @specialite AND (C.genre = 0 OR C.genre = (SELECT sexe FROM Patients WHERE id_patient = @id_patient)) GROUP BY C.id_chambre, C.nb_lits HAVING C.nb_lits - COUNT(I.id_patient) >= 1 LIMIT 1 ); 

-- -- 5. Insérez dans 'internation' 
INSERT INTO internation (id_patient, id_chambre, date_entree, date_sortie) VALUES (@id_patient, @id_chambre, CURDATE(), NULL); 

-- -- 6. Assignez le médecin avec le moins de patients de cette spécialité 
SET @medecinID := (SELECT medecinID FROM Médecins WHERE nom_spécialité = @specialite ORDER BY nombre_patients ASC LIMIT 1); 

-- -- 7. Insérez dans 'Medecins_Patients' 
INSERT INTO Medecins_Patients (medecinID, id_patient) VALUES (@medecinID, @id_patient); 

-- -- 8. Mettez à jour le nombre de patients du médecin 
UPDATE Médecins SET nombre_patients = nombre_patients + 1 WHERE medecinID = @medecinID; 

 
-- 9. procéder à la sortie d'un patient (vous déciderez si vous voulez conserver ou non les patients hospitalisés après leur sortie) 

-- -- 1. Mettre à jour la table 'internation' avec la date de sortie 

UPDATE internation 
SET date_sortie = CURDATE() 
WHERE id_patient = 21; #id du patient désiré 

-- -- 2. Mettre à jour la table 'Médecins' pour diminuer le nombre de patients du médecin 

UPDATE Médecins 
SET nombre_patients = nombre_patients - 1 
WHERE medecinID = (SELECT medecinID FROM Medecins_Patients WHERE id_patient = 21 LIMIT 1); 

-- -- 3. Retirer la relation entre le patient et le médecin dans 'Medecins_Patients' 

DELETE FROM Medecins_Patients 
WHERE id_patient = 21; 
 
-- 10. chercher un patient et obtenir sa pathologie, la ou les spécialités qui le traîtent et le ou les médecins qui le suivent. 

SELECT DISTINCT Pat.id_patient, Pat.nom AS nom_patient, Pat.prénom AS prénom_patient, Path.nom_pathologie, SP.nom_spécialité, M.medecinID, M.nom AS nom_médecin, M.prénom AS prénom_médecin
FROM Patients Pat 
JOIN Pathologies Path ON Pat.id_pathologie = Path.id_pathologie
JOIN Spécialités_Pathologies SP ON Path.id_pathologie = SP.id_pathologie
JOIN Medecins_Patients MP ON Pat.id_patient = MP.id_patient
JOIN Médecins M ON MP.medecinID = M.medecinID
WHERE Pat.id_patient = 17 -- id_patient du patient recherché 
AND SP.nom_spécialité = M.nom_spécialité;