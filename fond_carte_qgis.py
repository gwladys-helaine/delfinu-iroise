# Ajoute un fond de carte gris clair (Esri Light Gray) sous les couches du projet.
# À lancer dans QGIS : Plugins > Python Console > Show Editor > Run Script.
# Fond sans clé d'accès ; source à citer : « Fond de carte © Esri ».

from qgis.core import QgsRasterLayer, QgsProject

projet = QgsProject.instance()
nom = "Esri Light Gray"
url = ("https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/"
       "World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}")
fond = QgsRasterLayer("type=xyz&url=" + url + "&zmin=0&zmax=16", nom, "wms")

if fond.isValid():
    projet.addMapLayer(fond, False)
    projet.layerTreeRoot().addLayer(fond)   # tout en bas de la liste des couches
    print("Fond ajouté :", nom)
else:
    print("Le fond n'a pas pu être chargé : vérifier la connexion internet.")
