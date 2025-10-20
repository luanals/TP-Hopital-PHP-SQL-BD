<?php
//affiche les erreurs
ini_set('display_errors', 1);                              
error_reporting(E_ALL);                                    

// Connexion à ma base de données
$conn = new PDO("mysql:host=localhost;dbname="your database name";charset=utf8", "your login", "your password");

// Récupération des données POST envoyées par le formulaire
$pathologie_id = $_POST['pathologie'];                     // ID de la pathologie sélectionnée
$specialites = $_POST['specialites'];                      // Tableau des spécialités sélectionnées
$sexe_input = $_POST['sexe'];                              // Sexe sélectionné (homme, femme ou autre)

// Vérifie que l'utilisateur a sélectionné au moins une spécialité
if (empty($specialites) || !is_array($specialites)) {
    echo "<script>alert('Veuillez sélectionner au moins une spécialité.'); window.history.back();</script>";
    exit;
}

// Vérifie que l'utilisateur a sélectionné au moins une spécialité
if (count($specialites) === 0) {
    die("Veuillez sélectionner au moins une spécialité."); // Arrête le script si aucune spécialité n'est sélectionnée
}

// Transforme le tableau des spécialités en une chaîne SQL 
$specialites_list = "'" . implode("','", $specialites) . "'";

// Construction de la requête SQL en fonction du sexe sélectionné
if ($sexe_input === 'homme') {
    $sexe = 2;                                              // Code 2 pour les hommes
    $sql = "SELECT Médecins.nom_spécialité, COUNT(*) as nb
            FROM Médecins
            WHERE sexe = $sexe AND Médecins.nom_spécialité IN ($specialites_list)
            GROUP BY Médecins.nom_spécialité";
} elseif ($sexe_input === 'femme') {
    $sexe = 1;                                              // Code 1 pour les femmes
    $sql = "SELECT Médecins.nom_spécialité, COUNT(*) as nb
            FROM Médecins
            WHERE sexe = $sexe AND Médecins.nom_spécialité IN ($specialites_list)
            GROUP BY Médecins.nom_spécialité";
} else {
    // Sans filtre de sexe
    $sql = "SELECT Médecins.nom_spécialité, COUNT(*) as nb
            FROM Médecins
            WHERE Médecins.nom_spécialité IN ($specialites_list)
            GROUP BY Médecins.nom_spécialité";
}

// Exécution de la première requête (nombre de médecins par spécialité)
$stmt = $conn->prepare($sql);                              // Prépare la requête SQL
$stmt->execute();                                          // Exécute la requête
$medecins = $stmt->fetchAll();                             // Récupère tous les résultats dans un tableau

// Deuxième requête : spécialités associées à la pathologie sélectionnée
$sql2 = "SELECT sp.nom_spécialité
         FROM Spécialités_Pathologies sp
         JOIN Spécialités s ON sp.nom_spécialité = s.nom_spécialité
         WHERE sp.id_pathologie = $pathologie_id";
$stmt2 = $conn->prepare($sql2);                            // Prépare la requête
$stmt2->execute();                                         // Exécute la requête
$specialites_patho = $stmt2->fetchAll();                   // Récupère les résultats

// Troisième requête : nombre total de lits disponibles par spécialité
$sql3 = "SELECT c.nom_spécialité, SUM(c.nb_lits) AS total_lits
         FROM Chambre c
         WHERE c.nom_spécialité IN ($specialites_list)
         GROUP BY c.nom_spécialité";
$stmt3 = $conn->prepare($sql3);                            // Prépare la requête
$stmt3->execute();                                         // Exécute la requête
$lits = $stmt3->fetchAll();                                // Récupère les résultats

// Quatrième requête : pathologies traitées et nombre de patients
$sql4 = "SELECT p.nom_pathologie, COUNT(mp.id_patient) as nb_patients
         FROM Medecins_Patients mp
         JOIN Médecins m ON mp.medecinID = m.medecinID
         JOIN Spécialités_Pathologies sp ON sp.nom_spécialité = m.nom_spécialité
         JOIN Pathologies p ON sp.id_pathologie = p.id_pathologie
         WHERE m.nom_spécialité IN ($specialites_list)
         GROUP BY p.nom_pathologie
         ORDER BY nb_patients DESC";
$stmt4 = $conn->prepare($sql4);                            // Prépare la requête
$stmt4->execute();                                         // Exécute la requête
$patho_patient = $stmt4->fetchAll();                       // Récupère les résultats
?>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8">                                    
  <title>Résultats</title>                                 
  <link rel="stylesheet" href="style1.css">                 <!-- Lien vers la feuille de style -->
</head>
<body>

  <!-- HEADER -->
  <header>
    <h1>Consulter les résultats</h1>                       
  </header>

  <!-- MAIN CONTENT -->
  <div class="container">

    <!-- Section 1 : Médecins par spécialité -->
    <section>
      <h2>Médecins par spécialité (<?= htmlspecialchars($sexe_input) ?>)</h2>
      <?php if (empty($medecins)): ?>                      <!-- Vérifie s’il y a des résultats -->
        <p>Aucun médecin trouvé.</p>
      <?php else: ?>
        <ul>
          <?php foreach ($medecins as $m): ?>              <!-- Parcours les spécialités et affiche le nombre de médecins -->
            <li><?= htmlspecialchars($m['nom_spécialité']) ?> : <?= htmlspecialchars($m['nb']) ?> médecin(s)</li>
          <?php endforeach; ?>
        </ul>
      <?php endif; ?>
    </section>

    <!-- Section 2 : Spécialités liées à la pathologie -->
    <section>
      <h2>Spécialités impliquées dans la pathologie</h2>
      <ul>
        <?php foreach ($specialites_patho as $s): ?>       <!-- Affiche chaque spécialité liée à la pathologie -->
          <li><?= htmlspecialchars($s['nom_spécialité']) ?></li>
        <?php endforeach; ?>
      </ul>
    </section>

    <!-- Section 3 : Nombre de lits -->
    <section>
      <h2>Nombre de lits par spécialité</h2>
      <ul>
        <?php foreach ($lits as $l): ?>                    <!-- Affiche le nombre total de lits par spécialité -->
          <li><?= htmlspecialchars($l['nom_spécialité']) ?> : <?= htmlspecialchars($l['total_lits']) ?> lits</li>
        <?php endforeach; ?>
      </ul>
    </section>

    <!-- Section 4 : Pathologies et patients -->
    <section>
      <h2>Pathologies traitées et patients</h2>
      <ol>
        <?php foreach ($patho_patient as $pp): ?>          <!-- Affiche chaque pathologie avec le nombre de patients associés -->
          <li><?= htmlspecialchars($pp['nom_pathologie']) ?> – <?= htmlspecialchars($pp['nb_patients']) ?> patients</li>
        <?php endforeach; ?>
      </ol>
    </section>

  </div>

  <!-- FOOTER -->
  <footer>
    <p>By Meryem Boujdad & Luana Lopes Santiago GBM 4A</p> <!-- Signature -->
  </footer>

</body>
</html>
