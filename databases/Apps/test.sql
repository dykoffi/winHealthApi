-- INSERT INTO gap.Comptes (
--     montantCompte,
--     dateCompte ,
--     heureCompte,
--     patientCompte
-- ) VALUES (
--    0,
--    '2020-05-28',
--    '20:50',
--    '2020149-0002P'
-- );

 INSERT INTO gap.Transactions (
     dateTransaction,
     heureTransaction,
     montantTransaction,
     modeTransaction,
     typeTransaction,
     compteTransaction ) VALUES (
         '2020-05-28',
         '20:55',
         153000,
         'especes',
         'depot',
         '2020149-0001C'
     );

--  SELECT SUM(montantTransaction::INT)::INT FROM 
--     gap.Comptes,
--     gap.Transactions
--     WHERE compteTransaction=numeroCompte AND
--      Comptes.numeroCompte='0002C'
--     GROUP BY numeroCompte