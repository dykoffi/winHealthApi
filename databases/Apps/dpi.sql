CREATE SCHEMA dpi CASCADE;

CREATE TABLE dpi.Consultations (
    idConsultation SERIAL PRIMARY KEY,
    dateConsultation datetime,
    observationConsultation VARCHAR(200),
    diagnosticConsultation VARCHAR(100),
    prescriptionConsultation VARCHAR(200),
    conclusionConsultation VARCHAR(100),
    patientConsultation REFERENCES gap.DossierAdministratif (idPatient),
    intervenantConsultattion REFERENCES public.Users (idUser)
)

CREATE TABLE dpi.Constantes (
    idContantes SERIAL PRIMARY KEY,
    poids VARCHAR(10),
    taille VARCHAR(10),
    temperature VARCHAR(10),
    pouls VARCHAR(10),
    tensionArterielle VARCHAR(10),
    frequenceRespiratoire VARCHAR(10),
    perimetreOmbilical VARCHAR(20),
    perimetreThoracique VARCHAR(20),
    perimetreBrachial VARCHAR(20),
    perimetreCranien VARCHAR(20)
)

CREATE TABLE dpi.DossierMedical (
    idDossier SERIAL PRIMARY KEY,
    codeDossier VARCHAR(20) UNIQUE
);

CREATE TABLE dpi.Hospitalisations (
    idHospitalisation SERIAL PRIMARY KEY,
)

CREATE TABLE dpi.Soins (
    idSoin SERIAL PRIMARY KEY, 
)

