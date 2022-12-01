import sqlite3
import re
from sqlite3 import IntegrityError

import pandas

def read_excel_file_V0(data:sqlite3.Connection, file):
    # Lecture de l'onglet du fichier excel LesSportifsEQ, en interprétant toutes les colonnes comme des strings
    # pour construire uniformement la requête
    df_sportifs = pandas.read_excel(file, sheet_name='LesSportifsEQ', dtype=str)
    df_sportifs = df_sportifs.where(pandas.notnull(df_sportifs), 'null')

    cursor = data.cursor()
    for ix, row in df_sportifs.iterrows():
        try:
            query = "insert into V0_LesSportifsEQ values ({},'{}','{}','{}','{}','{}',{})".format(
                row['numSp'], row['nomSp'], row['prenomSp'], row['pays'], row['categorieSp'], row['dateNaisSp'], row['numEq'])
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.

            cursor.execute(query)
        except IntegrityError as err:
            print(err)

    # Lecture de l'onglet LesEpreuves du fichier excel, en interprétant toutes les colonnes comme des string
    # pour construire uniformement la requête
    df_epreuves = pandas.read_excel(file, sheet_name='LesEpreuves', dtype=str)
    df_epreuves = df_epreuves.where(pandas.notnull(df_epreuves), 'null')

    cursor = data.cursor()
    for ix, row in df_epreuves.iterrows():
        try:
            query = "insert into V0_LesEpreuves values ({},'{}','{}','{}','{}',{},".format(
                row['numEp'], row['nomEp'], row['formeEp'], row['nomDi'], row['categorieEp'], row['nbSportifsEp'])

            if (row['dateEp'] != 'null'):
                query = query + "'{}')".format(row['dateEp'])
            else:
                query = query + "null)"
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.

            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")


def read_excel_file_V1(data:sqlite3.Connection, file):
    # Lecture de l'onglet du fichier excel LesSportifsEQ, en interprétant toutes les colonnes comme des strings
    # pour construire uniformement la requête
    df_sportifs = pandas.read_excel(file, sheet_name='LesSportifsEQ', dtype=str)
    df_sportifs = df_sportifs.where(pandas.notnull(df_sportifs), 'null')

    cursor = data.cursor()
    for ix, row in df_sportifs.iterrows():
        try:
            query = "insert into LesSportifs values ({},'{}','{}','{}','{}','{}')".format(
                row['numSp'], row['nomSp'], row['prenomSp'], row['pays'], row['categorieSp'], row['dateNaisSp'])
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            #
            cursor.execute(query)
        except IntegrityError as err:
            print(err)

    cursor = data.cursor()
    for ix, row in df_sportifs.iterrows():
        try:
            if(row['numEq'] != 'null'):
                query = "insert into LesMembres values ({},'{}')".format(row['numSp'], row['numEq'])

                cursor.execute(query)

        except IntegrityError as err:
            print(err)


    # Lecture de l'onglet du fichier excel LesEpreuves, en interprétant toutes les colonnes comme des string
    # pour construire uniformement la requête
    df_epreuves = pandas.read_excel(file, sheet_name='LesEpreuves', dtype=str)
    df_epreuves = df_epreuves.where(pandas.notnull(df_epreuves), 'null')


    cursor = data.cursor()
    for ix, row in df_epreuves.iterrows():
        try:
            query = "insert into LesEpreuves values ({},'{}','{}','{}','{}',{},".format(
                row['numEp'], row['nomEp'], row['formeEp'], row['nomDi'], row['categorieEp'], row['nbSportifsEp'])

            if (row['dateEp'] != 'null'):
                query = query + "'{}')".format(row['dateEp'])
            else:
                query = query + "null)"
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            #
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")


    df_Inscriptions = pandas.read_excel(file, sheet_name='LesInscriptions', dtype=str)
    df_Inscriptions = df_Inscriptions.where(pandas.notnull(df_Inscriptions), 'null')


    cursor = data.cursor()
    for ix, row in df_Inscriptions.iterrows():
        try:
            query = "insert into LesInscrits values ({},'{}')".format(
                row['numIn'], row['numEp'])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            #
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")


    df_res = pandas.read_excel(file, sheet_name='LesResultats', dtype=str)
    df_res = df_res.where(pandas.notnull(df_res), 'null')


    cursor = data.cursor()
    for ix, row in df_res.iterrows():
        try:
            query = "insert into LesResultats values ({},'{}','{}','{}')".format(
                row['numEp'], row['gold'],row['silver'],row['bronze'])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.

            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")

    cursor = data.cursor()
    query1 = "SELECT DISTINCT nomDi FROM LesEpreuves"
    cursor.execute(query1)
    result = cursor.fetchall()
    for row in result:
        try:
            query = "insert into LesDisciplines values ('{}')".format(row[0])
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            #
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")

    cursor = data.cursor()
    query1 = "SELECT DISTINCT numEq FROM LesMembres"
    cursor.execute(query1)
    result = cursor.fetchall()
    for row in result:
        try:
            query = "insert into LesEquipes values ({},".format(row[0])

            query2 = "SELECT categorieSp FROM LesSportifs JOIN LesMembres using (numSp) where numEq = {}".format(row[0])
            cursor.execute(query2)
            res_cat_1 = cursor.fetchone()
            res_cat = cursor.fetchall()
            same = True
            for cat_row in res_cat:
                if(res_cat_1[0] != cat_row[0]):
                    same = False

            if(same):
                query = query + "'{}',".format(res_cat_1[0])
            else:
                query = query + "'mixte',"

            query2 = "SELECT pays FROM LesSportifs JOIN LesMembres using (numSp) where numEq = {}".format(row[0])
            cursor.execute(query2)
            res_pays_1 = cursor.fetchone()
            query = query + "'{}')".format(res_pays_1[0])

            # On affiche la requête pour comprendre la construction. A enlever une fois compris.

            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")




