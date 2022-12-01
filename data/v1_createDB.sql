CREATE TABLE LesSportifs
(
  numSp NUMBER(4) PRIMARY KEY,
  nomSp VARCHAR2(20) NOT NULL,
  prenomSp VARCHAR2(20) NOT NULL,
  pays VARCHAR2(20) NOT NULL,
  categorieSp VARCHAR2(10),
  dateNaisSp DATE NOT NULL,
  CONSTRAINT SP_CK1 CHECK(numSp > 999),
  CONSTRAINT SP_CK2 CHECK(numSp < 1501),
  CONSTRAINT SP_CK3 CHECK(categorieSp IN ('feminin','masculin')),
  CONSTRAINT SP_NSP_FK FOREIGN KEY (numSp) REFERENCES LesInscrits(numParticipant),
  CONSTRAINT SP_CSP1_FK FOREIGN KEY (categorieSp) REFERENCES LesEquipes(categorieEq),
  CONSTRAINT SP_CSP2_FK FOREIGN KEY (categorieSp) REFERENCES LesEpreuves(categorieEp)
);

CREATE TABLE LesEquipes
(
 numEq NUMBER(4) PRIMARY KEY,
 categorieEq VARCHAR(10),
 pays VARCHAR(20),
 CONSTRAINT EQ_CK1 CHECK(numEq > 0),
 CONSTRAINT EQ_CK2 CHECK(numEq <101),
 CONSTRAINT EQ_CK2 CHECK(categorieEq IN ('feminin','masculin','mixte')),
 CONSTRAINT EQ_CAT_FK FOREIGN KEY (categorieEq) REFERENCES LesEpreuves(categorieEp),
 CONSTRAINT EQ_PAYS_FK FOREIGN KEY (pays) REFERENCES LesSportifs(pays),
 CONSTRAINT EQ_NUM_FK FOREIGN KEY (numEq) REFERENCES LesInscrits(numParticipant)

);

CREATE TABLE LesMembres
(
 numSp NUMBER(4),
 numEq NUMBER(4) NOT NULL,
 CONSTRAINT AP_FK1 FOREIGN KEY (numSp) REFERENCES LesSportifs(numSp),
 CONSTRAINT AP_FK2 FOREIGN KEY (numEq) REFERENCES LesEquipes(numEq)
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

CREATE TABLE LesResultats
(
    numEp NUMBER(3) PRIMARY KEY,
    numOr NUMBER(4),
    numArg NUMBER(4),
    numBrze NUMBER(4),
    CONSTRAINT RES_nEP_FK FOREIGN KEY (numEp) REFERENCES LesEpreuves(numEp),
    CONSTRAINT RES_OR_FK FOREIGN KEY (numOr) REFERENCES LesInscrits(numParticipant),
    CONSTRAINT RES_ARG_FK FOREIGN KEY (numArg) REFERENCES LesInscrits(numParticipant),
    CONSTRAINT RES_BRZE_FK FOREIGN KEY (numBrze) REFERENCES LesInscrits(numParticipant)
);

CREATE TABLE LesInscrits
(
 numParticipant NUMBER(4),
 numEp NUMBER(3),
 CONSTRAINT INS_EP_FK FOREIGN KEY (numEp) REFERENCES LesEpreuves(numEp)
);

DROP VIEW IF EXISTS LesAgesSportifs;
CREATE VIEW IF NOT EXISTS LesAgesSportifs
AS
SELECT numSp, CURRENT_DATE-dateNaisSp  AS age FROM LesSportifs;

DROP VIEW IF EXISTS LesNbsEquipiers;
CREATE VIEW IF NOT EXISTS LesNbsEquipiers
AS
SELECT numEq, COUNT(numSp) as nbEquipiers
FROM LesMembres
GROUP BY numEq;

-- TODO 3.3 : ajouter les éléments nécessaires pour créer le trigger (attention, syntaxe SQLite différent qu'Oracle)
