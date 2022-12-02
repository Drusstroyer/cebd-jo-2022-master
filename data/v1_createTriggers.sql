
-- CONSTRAINT EQ_PAYS_FK FOREIGN KEY (pays) REFERENCES LesSportifs(pays),
DROP TRIGGER IF EXISTS DuMemePays;
CREATE TRIGGER DuMemePays
	BEFORE INSERT ON LesMembres
	WHEN NOT EXISTS (SELECT pays FROM LesSportifs join LesMembres using (numSp) WHERE NEW.numEq = LesMembres.numEq AND pays IN (SELECT pays FROM LesSportifs WHERE numSp = NEW.numSp))
BEGIN
	SELECT RAISE (ABORT, 'Cannot make a team with Sportifs from different countries');
END;

--Un participant ne peut remporter des médailles que sur les épreuves où il s'inscrit

DROP TRIGGER IF EXISTS DoitEtreInscrit;
CREATE TRIGGER DoitEtreInscrit
	BEFORE INSERT ON LesResultats
	WHEN NOT EXISTS (SELECT * FROM LesInscrits WHERE NEW.numOr in(Select numParticipant FROM LesInscrits WHERE NEW.numEp = LesInscrits.numEp) AND NEW.numArg in(Select numParticipant FROM LesInscrits WHERE NEW.numEp = LesInscrits.numEp) AND NEW.numBrze in(Select numParticipant FROM LesInscrits WHERE NEW.numEp = LesInscrits.numEp))
	BEGIN
		SELECT RAISE (ABORT, 'Cannot win if not inscrits');
	END;
	
--Une épreuve par équipe n'admets que des équipes
DROP TRIGGER IF EXISTS epreuvesParEquipes;
CREATE TRIGGER epreuvesParEquipes
BEFORE INSERT ON LesInscrits
	WHEN NEW.numParticipant < 101 AND EXISTS (SELECT formeEp FROM LesEpreuves WHERE NEW.numEp = LesEpreuves.numEp AND formeEp !='par equipe')
	BEGIN
		SELECT RAISE (ABORT, 'Cannot sign up to a team event alone');
	END;
	
--Les épreuves individuelles n'admets que des sportifs

DROP TRIGGER IF EXISTS epreuvesIndividuelle;
CREATE TRIGGER epreuvesIndividuelle
BEFORE INSERT ON LesInscrits
	WHEN NEW.numParticipant > 101 AND EXISTS (SELECT formeEp FROM LesEpreuves WHERE NEW.numEp = LesEpreuves.numEp AND formeEp !='individuelle')
	BEGIN
		SELECT RAISE (ABORT, 'Cannot sign up to a solo event as a team');
	END;
	
	