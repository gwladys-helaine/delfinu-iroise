# Guide d'installation et d'exécution

Ce guide décrit comment reproduire l'analyse et la base PostGIS sur un poste Linux (testé sous Debian, environnement Linux de ChromeOS).

## 1. Préparer le projet

1. Copier les fichiers du dépôt dans un dossier de travail.
2. Créer les sous-dossiers `data/raw/parc` et `data/raw/trafic` (le script les crée aussi au premier lancement).

## 2. Déposer les données non téléchargées par le script

- **Périmètre du Parc** : `sig_metrop.gpkg` (base des espaces protégés, PatriNat) dans `data/raw/parc/`. Le script y sélectionne le Parc naturel marin d'Iroise.
- **Trafic maritime** : rasters de densité de navires d'EMODnet Human Activities (*Vessel density*, moyenne annuelle 2023), à télécharger manuellement et à renommer dans `data/raw/trafic/` :
  - `tous_navires_2023.tif` (toutes catégories)
  - `plaisance_2023.tif` (catégorie 05, *Pleasure craft*)
  - `voile_2023.tif` (catégorie 04, *Sailing*)
  - `passagers_2023.tif` (catégorie 08, *Passenger*)

  Un fichier dont le nom contient « peche » est ignoré : la pêche professionnelle est exclue de l'analyse.

Les observations (OBIS, GBIF) et la bathymétrie (NOAA ETOPO 2022) sont téléchargées par le script.

## 3. Lancer l'analyse

Ouvrir `delfinu-iroise.Rproj` dans RStudio, puis exécuter `analyse.R` (bouton **Source**). Les résultats sont écrits dans `data/propre/` et `outputs/`.

## 4. Installer PostgreSQL et PostGIS (une seule fois)

Dans un terminal :

```bash
sudo apt update
sudo apt install -y postgresql postgis libpq-dev
sudo service postgresql start
sudo -u postgres createuser --superuser $USER
createdb delfinu
psql -d delfinu -c "CREATE EXTENSION postgis;"
psql -d delfinu -c "SELECT postgis_version();"
```

La dernière commande doit afficher un numéro de version de PostGIS. Après un redémarrage, relancer le serveur si besoin : `sudo service postgresql start`.

## 5. Bancariser dans PostGIS

1. Dans la console R, après `analyse.R` : `source("postgis.R", encoding = "UTF-8")`. Le script crée le schéma `iroise`, écrit les tables, ajoute les index spatiaux et une contrainte de cohérence, puis exécute les requêtes de `requetes.sql` et enregistre leurs résultats dans `outputs/tableaux/requetes/`.
2. Dans un terminal : `psql -d delfinu -f lieux.sql` (table des repères géographiques).

## 6. Afficher la base dans QGIS

**Layer > Add Layer > Add PostGIS Layers**, puis **New** :
- Host : laisser vide (connexion locale) ; Port : `5432` ; Database : `delfinu` ; SSL mode : `disable`.

Les tables du schéma `iroise` apparaissent. Les scripts `fond_carte_qgis.py` et `etiquettes_lieux_qgis.py` (console Python de QGIS) ajoutent un fond de carte et les repères géographiques avec leurs étiquettes.

## 7. Rendre la note

Dans un terminal, depuis le dossier du projet : `quarto render note.qmd --to typst`.
