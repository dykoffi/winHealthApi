exports.add_contante = {
    name: 'add_contants',
    text: `INSERT INTO dpi.Constantes (
    dateConstante,
    heureConstante, 
    poids,
    taille,
    temperature,
    pouls,
    tensionArterielle,
    frequenceRespiratoire,
    perimetreOmbrilical,
    perimetreThoracique,
    perimetreBrachial,
    perimetreCranien,
    sejourConstante,
    auteurConstante
    )
    VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14)`
}

exports.add_consultation = {
    name : "add_consultation",
    text : `INSERT INTO dpi.Consultation (
    dateConsultation ,
    heureConsultation ,
    observationConsultation,
    diagnosticConsultation,
    prescriptionConsultation,
    conclusionConsultation,
    sejourConsultation,
    intervenantConsultattion)
    VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`
}