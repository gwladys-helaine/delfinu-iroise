# Grands dauphins du Parc naturel marin d'Iroise : zones de concentration et trafic maritime

Exercice préparatoire réalisé dans le cadre de ma candidature au poste de **chargé(e) de mission projet Delfinu - Iroise** (OFB / Parc naturel marin d'Iroise).

> **📄 À lire en premier :** L'intégralité de la démarche, les cartes, les résultats détaillés, les limites et les perspectives sont présentés dans [`note.pdf`](note.pdf). **La page 1 contient une synthèse exécutive de l'exercice.**

<p align="center">
  <img src="carte_domaine_vital.png" width="49%" alt="Zones de concentration des observations">
  <img src="carte_trafic.png" width="49%" alt="Trafic maritime et zones de concentration">
</p>

## Objectifs du dépôt

Ce dépôt propose une chaîne de traitement reproductible, de la récupération de données ouvertes à leur analyse spatiale et leur bancarisation :
- **Contrôle qualité rigoureux :** Nettoyage automatisé de 918 observations brutes (OBIS, GBIF) pour écarter les biais (échouages, positions sur grille, doublons imprécis).
- **Analyse spatiale :** Estimation par noyau (KDE, isoplèthes 50% et 95%) sectorisée (Molène et Sein) et tests de sensibilité au découpage et à la largeur de bande.
- **Croisement habitat & trafic :** Analyse de la profondeur/distance à la côte et croisement descriptif avec le trafic AIS 2023 (plaisance, voile, passagers) en contrôlant l'effet de la proximité côtière.
- **Bancarisation :** Intégration des données nettoyées et des périmètres dans une base PostgreSQL/PostGIS interrogeable sous QGIS.

## Stack technique

- **Analyse & Statistiques :** R (`sf`, `terra`, `dplyr`, `ggplot2`)
- **Bases de données :** PostgreSQL / PostGIS
- **SIG :** QGIS (scripts d'automatisation Python inclus)
- **Rédaction & Rendu :** Quarto (`note.qmd` -> `note.pdf`)

## Structure du dépôt

| Fichier / Dossier | Description |
|---|---|
| `note.pdf` / `note.qmd` | **Note de synthèse principale** (version PDF et source Quarto) |
| `analyse.R` | Script R complet (téléchargement, nettoyage, KDE, habitat, trafic, graphiques) |
| `postgis.R` | Script de bancarisation sous PostgreSQL/PostGIS |
| `requetes.sql` & `lieux.sql` | Requêtes SQL spatiales d'exemple et création des repères |
| `fond_carte_qgis.py`, `etiquettes_lieux_qgis.py` | Scripts Python pour l'habillage sous QGIS |
| `data/propre/` & `outputs/` | Données nettoyées, journaux de nettoyage et figures générées |
| `GUIDE_IROISE.md` | Guide d'installation et de reproduction |

## Reproduire l'analyse

1. Ouvrir le projet RStudio `delfinu-iroise.Rproj`.
2. Déposer le périmètre du Parc (`sig_metrop.gpkg`) dans `data/raw/parc/` et les rasters EMODnet 2023 dans `data/raw/trafic/`.
3. Exécuter `analyse.R` pour relancer l'ensemble du traitement et régénérer les figures et tables de résultats.
4. Pour la partie SIG/BDD : suivre les instructions de `GUIDE_IROISE.md` pour configurer PostGIS et lancer `postgis.R`.

---
*Le code et la rédaction ont été réalisés avec l'aide d'un assistant d'IA (Claude, Anthropic). J'ai conduit la démarche, vérifié les données, les résultats et les références, et arbitré les choix de méthode et d'interprétation.*