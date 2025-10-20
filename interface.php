<?php
// connexion à ma base de données
$conn = new PDO("mysql:host=localhost;dbname="your database name";charset=utf8", "your login", "your password");


// Requête SQL pour récupérer toutes les pathologies
// Résultat : liste avec id_pathologie et nom_pathologie
$pathologies = $conn->query("SELECT id_pathologie, nom_pathologie FROM Pathologies")->fetchAll();


// Requête SQL pour récupérer toutes les spécialités
// Résultat : liste avec nom_spécialité
$specialites = $conn->query("SELECT nom_spécialité FROM Spécialités")->fetchAll();
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Recherche</title>
    <link rel="stylesheet" href="style.css"> <!-- Lien vers le fichier de style externe -->
</head>

<body>
     <!-- HEADER -->
  <header class="header">
    <h1>Hôpital Marseille</h1>
    <h1>Bienvenue sur notre plateforme de recherche</h1>
  </header>

<section class="flex-container"> 

<h1>Recherche d'information</h1>

    <!-- Formulaire de recherche envoyé via POST vers resultats.php -->
    <form method="post" action="resultats.php">

        <!-- Sélection d'une pathologie parmi les options -->
        <div class="bloc"> 
            <label>Pathologie :</label>
            <select name="pathologie" required> <!-- Liste déroulante obligatoire -->
                <?php foreach ($pathologies as $p): ?>
                    <option value="<?= $p['id_pathologie'] ?>">
                        <?= htmlspecialchars($p['nom_pathologie']) ?>
                    </option>
                <?php endforeach; ?>
            </select><br><br>
        </div>

        <!-- Choix multiple de spécialités (checkboxes) -->
        <div clas="bloc">
            <label>Spécialités :</label><br>
            <?php foreach ($specialites as $s): ?>
                <label>
                    <input type="checkbox" name="specialites[]" value="<?= htmlspecialchars($s['nom_spécialité']) ?>">
                    <?= htmlspecialchars($s['nom_spécialité']) ?>
                </label><br>
            <?php endforeach; ?><br>
        </div>

        <!-- Sélection du sexe du médecin recherché -->
        <div class="bloc">
            <label>Sexe des médecins :</label><br>
            <label><input type="radio" name="sexe" value="homme" checked> Homme</label>
            <label><input type="radio" name="sexe" value="femme"> Femme</label>
            <label><input type="radio" name="sexe" value="indifferent"> Indifférent</label><br><br>
        </div>

        <!-- Bouton pour soumettre le formulaire -->
        <button type="submit">Chercher</button>
    </form>
    <!-- FOOTER -->
  <footer>
    <p>By Meryem Boujdad & Luana Lopes Santiago GBM 4A</p>
  </footer>

</section>
    
</body>
</html>
