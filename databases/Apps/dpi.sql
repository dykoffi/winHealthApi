DROP SCHEMA dpi CASCADE;
CREATE SCHEMA dpi;

CREATE TABLE dpi.Consultations (
    idConsultation SERIAL PRIMARY KEY,
    dateConsultation VARCHAR(30),
    heureConsultation VARCHAR(20),
    observationConsultation VARCHAR(200),
    diagnosticConsultation VARCHAR(100),
    prescriptionConsultation VARCHAR(200),
    conclusionConsultation VARCHAR(100),
    sejourConsultation INTEGER REFERENCES gap.Sejours (idSejour),
    intervenantConsultattion INTEGER REFERENCES public.Users (idUser)
);

CREATE TABLE dpi.Constantes (
    idConstante SERIAL PRIMARY KEY,
    dateConstante VARCHAR(30),
    heureConstante VARCHAR(20),
    poids VARCHAR(10),
    taille VARCHAR(10),
    temperature VARCHAR(10),
    pouls VARCHAR(10),
    tensionArterielle VARCHAR(10),
    frequenceRespiratoire VARCHAR(10),
    perimetreOmbrilical VARCHAR(20),
    perimetreThoracique VARCHAR(20),
    perimetreBrachial VARCHAR(20),
    perimetreCranien VARCHAR(20),
    auteurConstante VARCHAR(100),
    sejourConstante INTEGER REFERENCES gap.Sejours (idSejour)
);

CREATE TABLE dpi.DossierMedical (
    idDossier SERIAL PRIMARY KEY,
    codeDossier VARCHAR(20) UNIQUE
);

CREATE TABLE dpi.Hospitalisations (
    idHospitalisation SERIAL PRIMARY KEY
);

CREATE TABLE dpi.Soins (
    idSoin SERIAL PRIMARY KEY
);
