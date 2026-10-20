# Charge la table iroise.lieux depuis la base PostGIS et l'habille :
# symbole selon le type de lieu, étiquette du nom avec un halo blanc.
# À lancer dans QGIS : Plugins > Python Console > Show Editor > Run Script,
# après avoir exécuté lieux.sql.

from qgis.core import (QgsDataSourceUri, QgsVectorLayer, QgsProject,
                       QgsPalLayerSettings, QgsTextFormat, QgsTextBufferSettings,
                       QgsVectorLayerSimpleLabeling, QgsMarkerSymbol,
                       QgsCategorizedSymbolRenderer, QgsRendererCategory)
from qgis.core import Qgis, QgsProperty
from qgis.PyQt.QtGui import QColor, QFont

# Connexion à la base locale (hôte vide = connexion directe, sans mot de passe)
uri = QgsDataSourceUri()
uri.setConnection("", "5432", "delfinu", "", "")
uri.setDataSource("iroise", "lieux", "geom", "", "id")
lieux = QgsVectorLayer(uri.uri(), "lieux", "postgres")
if not lieux.isValid():
    raise Exception("Table iroise.lieux introuvable : exécuter d'abord lieux.sql")

# Symboles : carré noir pour les villes, triangle pour le phare, rien pour
# les îles, caps et passages (seul le nom est affiché)
styles = {
    "ville":   ("square",   "0,0,0,255",     "1.6"),
    "phare":   ("triangle", "255,255,255,255", "2.2"),
    "ile":     ("circle",   "0,0,0,0",       "0"),
    "cap":     ("circle",   "0,0,0,0",       "0"),
    "passage": ("circle",   "0,0,0,0",       "0"),
}
categories = []
for type_lieu, (forme, couleur, taille) in styles.items():
    symbole = QgsMarkerSymbol.createSimple({
        "name": forme, "color": couleur, "size": taille,
        "outline_color": "0,0,0,255" if taille != "0" else "0,0,0,0",
        "outline_width": "0.3"})
    categories.append(QgsRendererCategory(type_lieu, symbole, type_lieu))
lieux.setRenderer(QgsCategorizedSymbolRenderer("type", categories))

# Étiquettes : noir droit pour les villes, gris italique pour les îles et
# caps, bleu marine italique pour les passages et le phare ; halo blanc
reglages = QgsPalLayerSettings()
reglages.fieldName = "nom"
# (le nom de cette option a changé selon les versions de QGIS)
try:
    reglages.placement = Qgis.LabelPlacement.OverPoint
except AttributeError:
    reglages.placement = QgsPalLayerSettings.OverPoint
reglages.yOffset = -2.5  # étiquette au-dessus du point (mm)

texte = QgsTextFormat()
texte.setFont(QFont("Sans", 9))
texte.setSize(9)
halo = QgsTextBufferSettings()
halo.setEnabled(True)
halo.setSize(0.8)
halo.setColor(QColor("white"))
texte.setBuffer(halo)
reglages.setFormat(texte)

# Couleur et style selon le type, par expressions
proprietes = reglages.dataDefinedProperties()
try:
    P_COULEUR, P_ITALIQUE = QgsPalLayerSettings.Property.Color, QgsPalLayerSettings.Property.Italic
except AttributeError:
    P_COULEUR, P_ITALIQUE = QgsPalLayerSettings.Color, QgsPalLayerSettings.Italic
proprietes.setProperty(P_COULEUR, QgsProperty.fromExpression(
    "CASE WHEN \"type\" = 'ville' THEN '#1a1a1a' "
    "WHEN \"type\" IN ('passage', 'phare') THEN '#08306b' ELSE '#4d4d4d' END"))
proprietes.setProperty(P_ITALIQUE, QgsProperty.fromExpression(
    "\"type\" <> 'ville'"))
reglages.setDataDefinedProperties(proprietes)

lieux.setLabeling(QgsVectorLayerSimpleLabeling(reglages))
lieux.setLabelsEnabled(True)

# Ajouter la couche tout en haut de la liste
projet = QgsProject.instance()
projet.addMapLayer(lieux, False)
projet.layerTreeRoot().insertLayer(0, lieux)
print("Couche « lieux » ajoutée :", lieux.featureCount(), "repères")
