SELECT ipppatient, numerocompte, montanttotalfacture, restefacture FROM 
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif LEFT OUTER JOIN  gap.Comptes ON ipppatient=patientcompte
    WHERE
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        Sejours.statusSejour='en attente'