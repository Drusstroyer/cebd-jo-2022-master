-- TODO 1.3a : Créer les tables manquantes et modifier celles ci-dessous
CREATE TABLE LesSportifs
(
  numSp NUMBER(4) primary KEY,
  nomSp VARCHAR2(20) NOT NULL,
  prenomSp VARCHAR2(20) NOT NULL,
  pays VARCHAR2(20) NOT NULL,
  categorieSp VARCHAR2(10),
  dateNaisSp DATE,
  CONSTRAINT SP_CK1 CHECK(numSp > 0),
  CONSTRAINT SP_CK2 CHECK(categorieSp IN ('feminin','masculin'))
);

CREATE TABLE LesEquipes
(
 numEq NUMBER(4) PRIMARY KEY,
 categorieEq VARCHAR(10),
 pays VARCHAR(20),
 CONSTRAINT EQ_CK1 CHECK(numEq > 0),
 CONSTRAINT EQ_CK2 CHECK(numEq <101),
 CONSTRAINT EQ_CK2 CHECK(categorieEq IN ('feminin','masculin','mixte'))
);

CREATE TABLE Appartient
(
 numSp NUMBER(4),
 numEq NUMBER(4),
 CONSTRAINT AP_CK1 FOREIGN KEY (nomSp) REFERENCES LesSportifs(numSp),
 CONSTRAINT AP_CK2 FOREIGN KEY (nomEq) REFERENCES LesEquipes(numEq)
);
CREATE TABLE LesDisciplines
(
 nomDi VARCHAR(25) PRIMARY KEY
);
CREATE TABLE LesEpreuves
(
  numEp NUMBER(3),
  nomEp VARCHAR2(20),
  formeEp VARCHAR2(13),
  nomDi VARCHAR2(25),
  categorieEp VARCHAR2(10),
  nbSportifsEp NUMBER(2),
  dateEp DATE,
  CONSTRAINT EP_PK PRIMARY KEY (numEp),
  CONSTRAINT EP_CK1 CHECK (formeEp IN ('individuelle','par equipe','par couple')),
  CONSTRAINT EP_CK2 CHECK (categorieEp IN ('feminin','masculin','mixte')),
  CONSTRAINT EP_CK3 CHECK (numEp > 0),
  CONSTRAINT EP_CK4 CHECK (nbSportifsEp > 0),
  CONSTRAINT EP_CK5 FOREIGN KEY (nomDi) REFERENCES LesDisciplines(nomDi)
);

CREATE TABLE Lesinscrits
(
 NumParticipant NUMBER(4),
 numEp NUMBER(3),
 CONSTRAINT INS_CK1 FOREIGN
);

-- TODO 1.4a : ajouter la définition de la vue LesAgesSportifs
-- TODO 1.5a : ajouter la définition de la vue LesNbsEquipiers
-- TODO 3.3 : ajouter les éléments nécessaires pour créer le trigger (attention, syntaxe SQLite différent qu'Oracle)
