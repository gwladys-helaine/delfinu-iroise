-- Requêtes d'exemple sur la base « delfinu » (schéma « iroise »)
-- Chaque bloc commence par une ligne « -- @nom » ; postgis.R les exécute dans l'ordre.
-- Elles peuvent aussi être copiées dans psql ou dans le gestionnaire de bases de QGIS.

-- @Nombre d'observations par source et par décennie
SELECT source,
       (annee / 10) * 10 AS decennie,
       COUNT(*)          AS n
FROM iroise.observations
GROUP BY source, decennie
ORDER BY decennie, source;

-- @Observations situées dans le Parc (jointure spatiale)
SELECT COUNT(*) AS n_dans_parc
FROM iroise.observations o
JOIN iroise.parc p ON ST_Within(o.geom, p.geom);

-- @Observations à moins de 5 km de l'île de Sein
-- (le point est saisi en longitude / latitude puis converti en Lambert-93)
SELECT COUNT(*) AS n_moins_5km_sein,
       MIN(annee) AS premiere_annee,
       MAX(annee) AS derniere_annee
FROM iroise.observations
WHERE ST_DWithin(geom,
                 ST_Transform(ST_SetSRID(ST_MakePoint(-4.851, 48.038), 4326), 2154),
                 5000);

-- @Surface du domaine vital par secteur et par niveau (km²)
SELECT secteur, facteur_h, niveau,
       ROUND((ST_Area(geom) / 1e6)::numeric, 1) AS surface_km2
FROM iroise.domaine_vital_secteurs
ORDER BY secteur, facteur_h DESC, niveau;

-- @Part des observations du Parc situées dans un cœur de secteur (href)
SELECT ROUND(100.0 * AVG(
         CASE WHEN EXISTS (SELECT 1 FROM iroise.domaine_vital_secteurs d
                           WHERE d.niveau = 'KDE 50 %' AND d.facteur_h = 1
                             AND ST_Within(o.geom, d.geom))
              THEN 1 ELSE 0 END), 1) AS pct_dans_un_coeur
FROM iroise.observations o
JOIN iroise.parc p ON ST_Within(o.geom, p.geom);

-- @Distance entre les deux cœurs (km)
SELECT ROUND((ST_Distance(a.geom, b.geom) / 1000)::numeric, 1) AS distance_km
FROM iroise.domaine_vital_secteurs a, iroise.domaine_vital_secteurs b
WHERE a.secteur = 'Molène' AND b.secteur = 'Sein'
  AND a.niveau = 'KDE 50 %' AND b.niveau = 'KDE 50 %'
  AND a.facteur_h = 1 AND b.facteur_h = 1;

-- @Contrôle qualité : doublons éventuels (même position à 100 m et même date)
SELECT a.date, COUNT(*) AS n
FROM iroise.observations a
JOIN iroise.observations b
  ON a.date = b.date AND a.ctid < b.ctid AND ST_DWithin(a.geom, b.geom, 100)
GROUP BY a.date
ORDER BY n DESC
LIMIT 10;
