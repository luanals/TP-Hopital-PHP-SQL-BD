-- Suppression des tables existantes (ordre respectant les clés étrangères)
DROP TABLE IF EXISTS Medecins_Patients;
DROP TABLE IF EXISTS Localisation_spécialités;
DROP TABLE IF EXISTS Spécialités_Pathologies;
DROP TABLE IF EXISTS internation;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Médecins;
DROP TABLE IF EXISTS Chambre;
DROP TABLE IF EXISTS Pathologies;
DROP TABLE IF EXISTS Spécialités;
DROP TABLE IF EXISTS Bâtiments;


-- 1. Bâtiments
CREATE TABLE Bâtiments (
  id_bât CHAR PRIMARY KEY, -- Identifiant du bâtiment (A, B, C, etc.)
  nom_bâtiment VARCHAR(50), -- Nom du bâtiment
  capacité INTEGER NOT NULL -- Capacité d'accueil du bâtiment
);

INSERT INTO Bâtiments (id_bât, nom_bâtiment, capacité) VALUES
('A', 'Avicenne', 30),
('B', 'Louis Pasteur', 30),
('C', 'Trotula', 30),
('D', 'Agnodice', 30),
('E', 'Virginia Apgar', 30);


-- 2. Spécialités
CREATE TABLE Spécialités (
  nom_spécialité VARCHAR(50) PRIMARY KEY, -- Nom de la spécialité
  type VARCHAR(20) NOT NULL, -- Type : "Médicale" ou "Chirurgie"
  âge VARCHAR(20) NOT NULL -- Tranche d'âge : "adulte", "enfant", "tous"
);

INSERT INTO Spécialités (nom_spécialité, type, âge) VALUES
('Chirurgie buco-dentaire', 'Chirurgie', 'adulte'),
('Allergologie', 'Médicale', 'tous'),
('Anesthésie', 'Chirurgie', 'tous'),
('Gynécologie', 'Médicale', 'adulte'),
('Obstétrique', 'Médicale', 'adulte'),
('Dermatologie', 'Médicale', 'tous'),
('Néphrologie', 'Médicale', 'adulte'),
('Urologie', 'Chirurgie', 'adulte'),
('Ophtalmologie', 'Chirurgie', 'tous'),
('Chirurgie viscérale et digestive', 'Chirurgie', 'adulte'),
('Neurochirurgie', 'Chirurgie', 'tous'),
('Psychiatrie', 'Médicale', 'adulte'),
('Pédo-psychiatrie', 'Médicale', 'enfant'),
('Pneumologie', 'Médicale', 'tous'),
('Orthopédie', 'Chirurgie', 'tous'),
('ORL', 'Chirurgie', 'tous'),
('Rhumatologie', 'Médicale', 'adulte'),
('Cardiologie', 'Médicale', 'adulte'),
('Médecine scolaire', 'Médicale', 'tous'),
('Pédiatrie', 'Médicale', 'enfant'),
('Néonatologie', 'Médicale', 'enfant'),
('Neuropédiatrie', 'Médicale', 'enfant');


-- 3. Pathologies
CREATE TABLE Pathologies (
  id_pathologie INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique
  nom_pathologie VARCHAR(512) NOT NULL -- Nom de la pathologie
);

INSERT INTO Pathologies (id_pathologie, nom_pathologie) VALUES
(1, 'Asthme allergique'),
(2, 'Insuffisance cardiaque'),
(3, 'Hypertension artérielle'),
(4, 'Abcés dentaire'),
(5, 'Appendicite'),
(6, 'Psoriasis'),
(7, 'Endométriose'),
(8, 'Adenomiose'),
(9, "Cancer du col de l\'uterus"),
(10, 'Prématurité'),
(11, 'Calculs rénaux'),
(12, 'Tumeur cérébrale'),
(13, 'Prééclampsie'),
(14, 'Glaucome'),
(15, 'Rhinite allergique'),
(16, 'Fracture osseuse'),
(17, 'Trouble du spectre autistique'),
(18, 'Cancer du poumon'),
(19, 'Lupus'),
(20, 'Infection urinaire');


-- 4. Chambre
CREATE TABLE Chambre (
  id_chambre INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique de la chambre
  genre INT NOT NULL, -- 1 = femme, 2 = homme
  nb_lits INT NOT NULL, -- Nombre de lits
  nom_spécialité VARCHAR(512), -- Spécialité associée à la chambre
  FOREIGN KEY (nom_spécialité) REFERENCES Spécialités(nom_spécialité)
);

INSERT INTO Chambre (id_chambre, genre, nb_lits, nom_spécialité) VALUES
(1, 2, 7, 'Cardiologie'),
(2, 1, 1, 'Cardiologie'),
(3, 1, 10, 'Néonatologie'),
(4, 2, 10, 'Néonatologie'),
(5, 1, 1, 'Gynécologie'),
(6, 1, 2, 'Gynécologie'),
(7, 1, 6, 'Gynécologie'),
(8, 2, 6, 'Néphrologie'),
(9, 1, 4, 'ORL'),
(10, 1, 1, 'Cardiologie');


-- 5. Médecins
CREATE TABLE Médecins (
  medecinID INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(20) NOT NULL,
  prénom VARCHAR(20) NOT NULL,
  âge INT NOT NULL,
  sexe INT NOT NULL, -- 1 = femme, 2 = homme
  nom_spécialité VARCHAR(50), -- Spécialité exercée
  nombre_patients INT NOT NULL, -- Nombre actuel de patients suivis
  FOREIGN KEY (nom_spécialité) REFERENCES Spécialités(nom_spécialité)
);

INSERT INTO Médecins (nom, prénom, âge, sexe, nom_spécialité, nombre_patients) VALUES
('Godin', 'Didiane', 66, 1, 'Chirurgie buco-dentaire', 0),
('Bernard', 'Carolos', 53, 2, 'Chirurgie buco-dentaire', 0),
('Lécuyer', 'Tanguy', 57, 2, 'Néonatologie', 1),
('de Brisay', 'Serge', 50, 2, 'Allergologie', 1),
('Hétu', 'Alexandre', 34, 2, 'Allergologie', 0),
('Algernon', 'Tougas', 37, 2, 'Anesthésie', 0),
('Lafrenière', 'Isaac', 54, 2, 'Anesthésie', 0),
('Therriault', 'Huette', 41, 1, 'Gynécologie', 5),
('Marquis', 'Javier', 26, 2, 'Gynécologie', 1),
('Quiron', 'Rémy', 45, 2, 'Dermatologie', 0),
('Provencher', 'Bertrand', 32, 2, 'Dermatologie', 0),
('CinqMars', 'Archard', 29, 2, 'Néphrologie', 4),
('Dulin', 'Harbin', 72, 2, 'Néphrologie', 0),
('Langlais', 'Marmion', 51, 2, 'Urologie', 0),
('Coudert', 'Fayme', 63, 1, 'Urologie', 0),
('Boisclair', 'Fealty', 68, 1, 'Urologie', 0),
('Salmons', 'Durandana', 25, 1, 'Ophtalmologie', 0),
('Veronneau', 'Hugues', 41, 2, 'Chirurgie viscérale et digestive', 0),
('Grondin', 'Felicien', 60, 2, 'Neurochirurgie', 0),
('Marleau', 'Angélique', 66, 1, 'Gynécologie', 3),
('Duffet', 'Esperanza', 47, 1, 'Gynécologie', 0),
('Marquis', 'Forrest', 48, 2, 'ORL', 0),
('Mailloux', 'Medoro', 31, 2, 'ORL', 1),
('Patry', 'Fannette', 24, 1, 'Orthopédie', 0),
('Desilets', 'Fabrice', 70, 2, 'Cardiologie', 0),
('Marchesseault', 'Royden', 63, 2, 'Cardiologie', 0),
('Marquis', 'Davet', 50, 2, 'Pédiatrie', 0),
('Auger', 'Gérard', 25, 2, 'Néonatologie', 0),
('Deserres', 'Bruce', 65, 2, 'Néonatologie', 0),
('Ménard', 'Quennel', 37, 2, 'Pneumologie', 0),
('Charette', 'Sophie', 45, 1, 'Pneumologie', 0),
('Deschênes', 'Audric', 49, 2, 'Cardiologie', 0),
('Bousquet', 'Prunella', 29, 1, 'Cardiologie', 4),
('Wanderwoolsen', 'Lily', 52, 1, 'Orthopédie', 0),
('Ramirez', 'René', 47, 2, 'Cardiologie', 0);


-- 6. Patients
CREATE TABLE Patients (
  id_patient INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(512) NOT NULL,
  prénom VARCHAR(512) NOT NULL,
  âge INT NOT NULL,
  sexe INT NOT NULL,
  id_pathologie INT, -- id pathologie unique
  CHECK (NOT (id_pathologie = 10 AND âge >= 1)  -- Contrainte âge < 1 pour pathologie de type Néonatologie (maintenant juste id=10)
  ),
  FOREIGN KEY (id_pathologie) REFERENCES Pathologies(id_pathologie)
);

SELECT 'Merci de vérifier si le patient existe déjà dans la base de données avant de l''ajouter.\n 
si oui, update pathologie, create nouvelle internation avec vieux id_patient et nouvelle date_d’entree ';

INSERT INTO Patients (id_patient, nom, prénom, âge, sexe, id_pathologie) VALUES
(1, 'Durand', 'Claire', 34, 1, 2),
(2, 'Lemoine', 'Julien', 45, 2, 2),
(3, 'Nguyen', 'Minh', 0, 2, 10),
(4, 'Martin', 'Élodie', 0, 1, 10),
(5, 'Dubois', 'Luc', 33, 2, 11),
(6, 'Gabillaud', 'Gabrielle', 18, 1, 8),
(7, 'Muanza', 'David', 0, 2, 10),
(8, 'Capdevilla', 'Romane', 0, 1, 10),
(9, 'Poulat', 'Maelyss', 41, 1, 9),
(10, 'Lafont', 'Giselle', 58, 1, 7),
(11, 'Renard', 'Pauline', 38, 1, 7),
(12, 'Mercier', 'Thomas', 49, 2, 2),
(13, 'Giraud', 'Léna', 0, 1, 10),   
(14, 'Petit', 'Axel', 65, 2, 11),   
(15, 'Roy', 'Camille', 31, 1, 9),   
(16, 'Leclerc', 'Lucie', 25, 1, 3), 
(17, 'Fontaine', 'Louis', 60, 2, 3),
(18, 'Blanc', 'Emma', 8, 1, 15),   
(19, 'Moulin', 'Nina', 22, 1, 7),   
(20, 'Collet', 'Jules', 28, 2, 2);


-- 7. internation
CREATE TABLE internation ( -- admission des patients dans une chambre

  id_patient INT,
  id_chambre INT,
  date_entree DATE,
  date_sortie DATE, -- NULL si encore hospitalisé
  CHECK (date_entree <= date_sortie OR date_sortie IS NULL), -- vérifie que la date d'entrée du patient est antérieure à sa date de sortie
  PRIMARY KEY (id_patient, id_chambre),
  FOREIGN KEY (id_patient) REFERENCES Patients(id_patient),
  FOREIGN KEY (id_chambre) REFERENCES Chambre(id_chambre)
);

SELECT 'Merci de vérifier que la date d''entrée du patient ne se situe pas dans le futur.';

INSERT INTO internation (id_patient, id_chambre, date_entree, date_sortie) VALUES
(1, 2, '2024-03-21', NULL),
(2, 1, '2018-07-12', '2018-07-15'),
(3, 4, '2004-04-04', '2004-05-04'),
(4, 3, '2023-09-10', NULL),
(5, 8, '2006-08-08', '2006-09-10'),
(6, 6, '2025-02-27', NULL),
(7, 4, '2024-10-16', '2024-10-17'),
(8, 3, '2024-07-31', NULL),
(9, 7, '2025-03-05', NULL),
(10, 7, '2001-01-01', '2001-01-07'),
(11, 7, '2025-01-25', NULL),
(12, 1, '2025-01-12', NULL),
(13, 3, '2025-02-02', NULL),
(14, 8, '2025-03-28', NULL),
(15, 7, '2025-03-15', NULL),
(16, 10, '2025-03-05', NULL),
(17, 8, '2025-04-22', NULL),
(18, 9, '2025-04-15', NULL),
(19, 7, '2025-04-19', NULL),
(20, 1, '2025-04-05', NULL);


-- 8. Spécialités_Pathologies           --Associe les pathologies aux spécialités médicales
CREATE TABLE Spécialités_Pathologies ( 
  id_pathologie INT,
  nom_spécialité VARCHAR(50),
  PRIMARY KEY (nom_spécialité, id_pathologie),
  FOREIGN KEY (id_pathologie) REFERENCES Pathologies(id_pathologie),
  FOREIGN KEY (nom_spécialité) REFERENCES Spécialités(nom_spécialité)
);

INSERT INTO Spécialités_Pathologies (id_pathologie, nom_spécialité) VALUES
(1, 'Allergologie'),
(2, 'Cardiologie'),
(3, 'Cardiologie'),
(3, 'Néphrologie'),
(4, 'Chirurgie buco-dentaire'),
(5, 'Chirurgie viscérale et digestive'),
(6, 'Dermatologie'),
(7, 'Gynécologie'),
(8, 'Gynécologie'),
(9, 'Gynécologie'),
(10, 'Néonatologie'),
(11, 'Néphrologie'),
(12, 'Neurochirurgie'),
(13, 'Obstétrique'),
(14, 'Ophtalmologie'),
(15, 'ORL'),
(15, 'Allergologie'),
(16, 'Orthopédie'),
(17, 'Psychiatrie'),
(17, 'Pédo-psychiatrie'),
(18, 'Pneumologie'),
(19, 'Rhumatologie'),
(19, 'Néphrologie'),
(20, 'Urologie');


-- 9. Localisation_spécialités          -- Indique où sont localisées les spécialités médicales
CREATE TABLE Localisation_spécialités (
  id_bât CHAR,
  nom_spécialité VARCHAR(50),
  PRIMARY KEY (nom_spécialité, id_bât),
  FOREIGN KEY (id_bât) REFERENCES Bâtiments(id_bât),
  FOREIGN KEY (nom_spécialité) REFERENCES Spécialités(nom_spécialité)
);

INSERT INTO Localisation_spécialités (nom_spécialité, id_bât) VALUES
('Chirurgie buco-dentaire', 'A'),
('Cardiologie', 'A'),
('Allergologie', 'D'),
('Anesthésie', 'A'),
('Gynécologie', 'C'),
('Obstétrique', 'C'),
('Dermatologie', 'D'),
('Néphrologie', 'D'),
('Ophtalmologie', 'A'),
('Chirurgie viscérale et digestive', 'A'),
('Pédo-psychiatrie', 'C'),
('Pneumologie', 'B'),
('ORL', 'A'),
('Néonatologie', 'B');


-- 10. Medecins_Patients         -- Associe les médecins aux patients qu'ils traitent
CREATE TABLE Medecins_Patients (
  medecinID INT,
  id_patient INT,
  PRIMARY KEY (medecinID, id_patient),
  FOREIGN KEY (medecinID) REFERENCES Médecins(medecinID),
  FOREIGN KEY (id_patient) REFERENCES Patients(id_patient)
);

INSERT INTO Medecins_Patients (medecinID, id_patient) VALUES
(32, 1),
(33, 2),
(3, 3),
(3, 4),
(12, 5),
(8, 6),
(29, 7),
(29, 8),
(20, 9),
(8, 9),
(20, 10),
(8, 11),
(33, 12),
(3, 13),
(12, 14),
(8, 15),
(20, 15),
(33, 16),
(12, 16),
(33, 17),
(12, 17),
(4, 18),
(23, 18),
(8, 19),
(33, 20);