-- Repères géographiques pour les cartes QGIS (schéma « iroise »)
-- Mêmes lieux et mêmes coordonnées que dans analyse.R (bloc « Site étudié »).
-- Coordonnées saisies en longitude / latitude (WGS84, EPSG:4326),
-- converties en Lambert-93 (EPSG:2154) comme les autres tables.
-- À exécuter une fois : QGIS > Database > DB Manager > PostGIS > delfinu > SQL Window.

DROP TABLE IF EXISTS iroise.lieux;

CREATE TABLE iroise.lieux (
  id   serial PRIMARY KEY,
  nom  text NOT NULL,
  type text NOT NULL CHECK (type IN ('ville', 'ile', 'cap', 'passage', 'phare')),
  geom geometry(Point, 2154)
);

INSERT INTO iroise.lieux (nom, type, geom)
SELECT nom, type, ST_Transform(ST_SetSRID(ST_MakePoint(lon, lat), 4326), 2154)
FROM (VALUES
  ('Île de Sein',             'ville',   -4.851,  48.038),
  ('Le Conquet',              'ville',   -4.771,  48.360),
  ('Douarnenez',              'ville',   -4.329,  48.093),
  ('Camaret-sur-Mer',         'ville',   -4.595,  48.278),
  ('Brest',                   'ville',   -4.486,  48.390),
  ('Ouessant',                'ile',     -5.075,  48.462),
  ('Archipel de Molène',      'ile',     -4.958,  48.397),
  ('Presqu''île de Crozon',   'cap',     -4.450,  48.235),
  ('Cap Sizun',               'cap',     -4.600,  48.035),
  ('Raz de Sein',             'passage', -4.775,  48.045),
  ('Chenal du Four',          'passage', -4.800,  48.450),
  ('Phare d''Ar Men',         'phare',   -4.9983, 48.0500)
) AS l(nom, type, lon, lat);

CREATE INDEX lieux_geom_idx ON iroise.lieux USING GIST (geom);
COMMENT ON TABLE iroise.lieux IS 'Repères géographiques pour l''habillage des cartes (coordonnées approximatives pour les îles, caps et passages)';

-- Vérification
SELECT nom, type, ROUND(ST_X(ST_Transform(geom, 4326))::numeric, 3) AS lon,
       ROUND(ST_Y(ST_Transform(geom, 4326))::numeric, 3) AS lat
FROM iroise.lieux ORDER BY type, nom;
