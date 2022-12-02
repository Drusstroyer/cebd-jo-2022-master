

CREATE TRIGGER DuMemePays
	BEFORE INSERT ON LesMembres
	WHEN  EXISTS (SELECT pays FROM LesSportifs join LesMembres using (numSp) WHERE NEW.numEq = LesMembres.numEq AND pays NOT IN (SELECT pays FROM LesSportifs WHERE numSp = NEW.numSp))
    BEGIN
	SELECT RAISE (ABORT, 'Cannot make a team with Sportifs from different countries');
    END/;



CREATE TRIGGER DoitEtreInscrit
	BEFORE INSERT ON LesResultats
	WHEN NOT EXISTS (SELECT * FROM LesInscrits WHERE EXISTS (Select numParticipant FROM LesInscrits WHERE NEW.numEp = LesInscrits.numEp INTERSECT
	                                                           SELECT numParticipant from LesInscrits WHERE NEW.numOr = LesInscrits.numParticipant
	                                                           UNION ALL SELECT numParticipant from LesInscrits WHERE NEW.numArg = LesInscrits.numParticipant
	                                                           UNION ALL SELECT numParticipant from LesInscrits WHERE NEW.numBrze = LesInscrits.numParticipant))
    BEGIN
		SELECT RAISE (ABORT, 'Cannot win if not inscrits');
    END/;


CREATE TRIGGER epreuvesParEquipes
    BEFORE INSERT ON LesInscrits
    WHEN ((NEW.numParticipant < 101) AND  (SELECT formeEp FROM LesEpreuves WHERE NEW.numEp = LesEpreuves.numEp AND formeEp !='par equipe'))
    BEGIN
        SELECT RAISE (ABORT, 'Cannot sign up to a team event alone');
    END/;



CREATE TRIGGER epreuvesIndividuelle
    BEFORE INSERT ON LesInscrits
    WHEN ((NEW.numParticipant > 101) AND  (SELECT formeEp FROM LesEpreuves WHERE NEW.numEp = LesEpreuves.numEp AND formeEp !='individuelle'))
    BEGIN
        SELECT RAISE (ABORT, 'Cannot sign up to a solo event as a team');
    END/;

