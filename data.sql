SELECT 
    idDossier, 
    ippPatient, 
    nomPatient, 
    prenomsPatient, 
    sexePatient, 
    dateNaissancePatient, 
    lieuNaissancePatient, 
    nationalitePatient,
    habitationPatient, 
    contactPatient  
    FROM gap.DossierAdministratif, gap.Sejours WHERE 
    Sejours.patientSejour=iddossier AND
    Sejours.statusSejour='validé';