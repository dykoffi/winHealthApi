DROP TABLE Users;
CREATE TABLE Users (
    id int PRIMARY KEY NOT NULL,
    nom VARCHAR(20),
    prenoms VARCHAR(50),
    contact VARCHAR(20),
    mail VARCHAR(30),
    poste VARCHAR(100),
    profil VARCHAR(100),
    app VARCHAR(30),
    pass VARCHAR(200)
);

INSERT INTO Users(id,nom, prenoms,contact,mail, poste, profil, app, pass) VALUES (1,'Koffi','Edy','51 88 64 78','koffiedy@gmail.com', 'Agent ALTEA', 'ADMIN','admin','7859')
