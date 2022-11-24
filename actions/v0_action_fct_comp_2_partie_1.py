
import sqlite3
from utils import display
from PyQt5.QtWidgets import QDialog, QTableWidgetItem
from PyQt5.QtCore import pyqtSlot
from PyQt5 import uic

# Classe permettant d'afficher la fonction à compléter 4
class AppFctComp2Partie1(QDialog):

    # Constructeur
    def __init__(self, data:sqlite3.Connection):
        super(QDialog, self).__init__()
        self.ui = uic.loadUi("gui/fct_comp_2.ui", self)
        self.data = data

    # Fonction de mise à jour de l'affichage
    def refreshResult(self):
        # TODO 1.2 : fonction à modifier pour remplacer la zone de saisie par une liste de valeurs issues de la BD une
        #  fois le fichier ui correspondant mis à jour
        display.refreshLabel(self.ui.label_fct_comp_2, "")
        try:
            cursor = self.data.cursor()
            result = cursor.execute("SELECT DISTINCT categorieEp FROM V0_LesEpreuves")
            display.refreshGenericCombo(self.ui.comboBox_fct_comp_2, result)
        except Exception as e:
                self.ui.table_fct_comp_3.setRowCount(0)
                display.refreshLabel(self.ui.label_fct_comp_2, "Impossible de charger les catégorie : " + repr(e))
        else:
            if not self.ui.comboBox_fct_comp_2.currentText().strip():
                self.ui.table_fct_comp_2.setRowCount(0)
                display.refreshLabel(self.ui.label_fct_comp_2, "Veuillez indiquer un nom de catégorie")
            else:
                try:
                    cursor = self.data.cursor()
                    result = cursor.execute(
                        "SELECT numEp, nomEp, formeEp, nomDi, categorieEp, nbSportifsEp, strftime('%Y-%m-%d',dateEp,'unixepoch') FROM V0_LesEpreuves WHERE categorieEp = ?",
                        [self.ui.comboBox_fct_comp_2.currentText()])
                except Exception as e:
                    self.ui.table_fct_comp_3.setRowCount(0)
                    display.refreshLabel(self.ui.label_fct_comp_2, "Impossible d'afficher les résultats : " + repr(e))
                else:
                    i = display.refreshGenericData(self.ui.table_fct_comp_2, result)
                    if i == 0:
                        display.refreshLabel(self.ui.label_fct_comp_2, "Aucun résultat")