# Analyse exploratoire — Grands dauphins d'Iroise et trafic maritime

Exercice préparatoire réalisé dans le cadre de ma candidature au poste de **chargé(e) de mission projet Delfinu - Iroise** (OFB / Parc naturel marin d'Iroise).

> **📄 À lire en premier :** Tout le travail d'analyse, les cartes, les résultats et les limites sont synthétisés dans [note.pdf](note.pdf) (la page 1 contient un résumé exécutif).

<p align="center">
  <img src="carte_domaine_vital.png" width="85%" alt="Zones de concentration des observations et bathymétrie en Iroise">
</p>
<p align="center"><em>Zones de concentration des observations (KDE) dans les secteurs de Molène et de Sein.</em></p>

## Objectifs du dépôt
- Nettoyage et contrôle qualité critique de données ouvertes (OBIS, GBIF) sur le grand dauphin (*Tursiops truncatus*) en Iroise.
- Estimation par noyau (KDE) des zones de concentration (Molène, Sein) et analyse de sensibilité.
- Croisement descriptif avec le trafic maritime (données AIS EMODnet 2023, hors pêche) en contrôlant l'effet de la proximité de la côte.
- Bancarisation sous PostgreSQL/PostGIS et intégration sous QGIS.

## Stack technique
- **Analyse statistique & spatiale :** R (`sf`, `terra`, `dplyr`, `ggplot2`)
- **Base de données :** PostgreSQL / PostGIS
- **Cartographie :** QGIS
- **Rédaction & Rendu :** Quarto (`note.qmd` -> `note.pdf`)

## Structure du projet
- `analyse.R` : Script principal (téléchargement, contrôle qualité, KDE, habitat, trafic, figures, exports).
- `postgis.R` & `requetes.sql` : Bancarisation et requêtes spatiales SQL d'exemple.
- `data/` & `outputs/` : Données nettoyées et graphiques générés.
- `GUIDE_IROISE.md` : Instructions de reproduction.

---
*Le code et la note ont été réalisés avec l'aide d'un assistant d'IA (Claude, Anthropic). J'ai conduit la démarche, vérifié les données, les résultats et les références, et arbitré les choix de méthode et d'interprétation.*