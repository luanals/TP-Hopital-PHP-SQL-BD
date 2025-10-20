# 🏥 Projet Base de Données - Système de Gestion Hospitalière

## Introduction

Ce projet représente la mise en place d'une base de données relationnelle pour la gestion des informations d'un hôpital, associée à une interface de recherche utilisateur développée en **PHP** (PDO) et **HTML/CSS**.

Le système permet aux utilisateurs de naviguer dans les données des médecins, des spécialités, des pathologies, des chambres et des patients.

Ce projet a été réalisé par **Meryem Boujdad** et **Luana Lopes Santiago**, étudiantes en **GBM 4A - 2024**.

---

## 🌐 Démo en ligne

Vous pouvez consulter l'interface fonctionnelle du projet à l'adresse suivante :
[interface.php](https://luana-lopes-santiago-etu.pedaweb.univ-amu.fr/extranet/TP/interface.php)

---

## Fonctionnalités de l'Application (PHP/SQL)

L'interface web (`interface.php`) permet d'effectuer des recherches complexes en soumettant un formulaire basé sur les critères suivants :

* **Pathologie :** Sélection d'une pathologie spécifique.
* **Spécialités :** Choix multiple de spécialités (via cases à cocher).
* **Sexe des médecins :** Filtrage par homme, femme ou indifférent (via boutons radio).

La page de résultats (`resultats.php`) exécute plusieurs requêtes complexes pour afficher :

1.  Le **nombre de médecins** par spécialité sélectionnée, en fonction du filtre de sexe.
2.  La **liste des spécialités** officiellement impliquées dans la pathologie sélectionnée.
3.  Le **nombre total de lits** disponibles pour les spécialités sélectionnées.
4.  Les **pathologies traitées** par les spécialités sélectionnées, classées par nombre de patients suivis.

---

## 🖼️ Modélisation et Schéma

### Modèle Conceptuel de Données (MCD)

Le MCD ci-dessous illustre l'organisation et les relations entre les principales entités du système hospitalier : **Bâtiments**, **Spécialités**, **Pathologies**, **Chambre**, **Médecins**, et **Patients**.

![Schéma Conceptuel (MCD)](/MCD.png)

### Modèle Logique (MLD)
BÂTIMENTS(<ins>id_bât</ins>, nom_bâtiment, capacité)  
SPÉCIALITÉS(<ins>nom_spécialité</ins>, type, âge)  
LOCALISATION_SPECIALITÉS(<ins>#id_bât, #nom_spécialité</ins>)  
PATHOLOGIES(<ins>id_pathologie</ins>, nom_pathologie)  
SPÉCIALITÉS_PATHOLOGIES(<ins>#id_pathologie, #nom_spécialité</ins>)  
CHAMBRE(<ins>id_chambre</ins>, genre, nb_lits, #nom_spécialité)  
PATIENTS(<ins>id_patient</ins>, nom, prénom, âge, sexe, #id_pathologie)  
INTERNATION(<ins>#id_patient, #id_chambre</ins>, date_entree, date_sortie)  
MÉDECINS(<ins>medecinID</ins>, nom, prénom, âge, sexe, #nom_spécialité, nombre_patients)  
MÉDECINS_PATIENTS(<ins>#medecinID,#id_patient</ins>)  

### Requêtes et Procédures Avancées

Le fichier `database/Queries-Examples.sql` contient la logique SQL pour les procédures complexes, notamment :

* Calcul du nombre de **lits libres** par spécialité.
* Procédure d'**entrée d'un patient** : Vérification d'existence, mise à jour de la pathologie, recherche d'une chambre compatible (genre/spécialité) avec un lit libre, et affectation au médecin ayant le moins de patients dans cette spécialité.
* Procédure de **sortie d'un patient** : Mise à jour de la date de sortie, diminution du nombre de patients du médecin, et suppression de la relation médecin-patient.

---

## 🛠️ Structure du Projet
Hospital-Management-Project/  
├── interface.php # Formulaire de recherche utilisateur  
├── resultats.php # Page affichant les résultats des requêtes SQL   
├── style.css # Styles pour interface.php   
├── style1.css # Styles pour resultats.php   
├── database/  
│ ├── All-Tables-Setup.sql # Création des tables et insertion des données   
│ └── Queries-Examples.sql # Exemples de requêtes et de procédures de gestion   
└── README.md

