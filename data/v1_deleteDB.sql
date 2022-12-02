DROP TABLE IF EXISTS LesMembres;

DROP TABLE IF EXISTS LesSportifs;
DROP TABLE IF EXISTS LesEquipes;
DROP TABLE IF EXISTS LesResultats;
DROP TABLE IF EXISTS LesInscrits;
DROP TABLE IF EXISTS LesEpreuves;
DROP TABLE IF EXISTS LesDisciplines;




-- TODO 3.3 : pensez à détruire vos triggers !
DROP TRIGGER IF EXISTS DuMemePays;
DROP TRIGGER IF EXISTS DoitEtreInscrit;
DROP TRIGGER IF EXISTS epreuvesParEquipes;
DROP TRIGGER IF EXISTS epreuvesIndividuelle;