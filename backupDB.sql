--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4 (Ubuntu 12.4-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.4 (Ubuntu 12.4-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: admin; Type: SCHEMA; Schema: -; Owner: psante
--

CREATE SCHEMA admin;


ALTER SCHEMA admin OWNER TO psante;

--
-- Name: gap; Type: SCHEMA; Schema: -; Owner: psante
--

CREATE SCHEMA gap;


ALTER SCHEMA gap OWNER TO psante;

--
-- Name: general; Type: SCHEMA; Schema: -; Owner: psante
--

CREATE SCHEMA general;


ALTER SCHEMA general OWNER TO psante;

--
-- Name: get_controle_sejour(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_controle_sejour(numerosejour text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT COUNT(*)::INT nb_controle
FROM gap.Controles,
    gap.Sejours
WHERE sejourControle = $1 $_$;


ALTER FUNCTION public.get_controle_sejour(numerosejour text) OWNER TO psante;

--
-- Name: get_date_sejour(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_date_sejour(numerosejour text) RETURNS date
    LANGUAGE sql STRICT
    AS $_$
SELECT dateDebutSejour::DATE
FROM gap.Sejours
WHERE numerosejour = $1 $_$;


ALTER FUNCTION public.get_date_sejour(numerosejour text) OWNER TO psante;

--
-- Name: get_delai_controle(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_delai_controle(numerosejour text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT (current_date - get_date_sejour($1));
$_$;


ALTER FUNCTION public.get_delai_controle(numerosejour text) OWNER TO psante;

--
-- Name: get_ipp(); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_ipp() RETURNS text
    LANGUAGE sql STRICT
    AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(nextval('ipp_sequence')::TEXT, 4, '000'),
        'P'
    ) $$;


ALTER FUNCTION public.get_ipp() OWNER TO psante;

--
-- Name: get_montant_compte(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_montant_compte(numerocompte text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT SUM(montantTransaction::INT)::INT
FROM gap.Comptes,
    gap.Transactions
WHERE Comptes.numeroCompte = $1
    AND compteTransaction = numeroCompte
GROUP BY numeroCompte $_$;


ALTER FUNCTION public.get_montant_compte(numerocompte text) OWNER TO psante;

--
-- Name: get_montant_davoir(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_montant_davoir(numerfacture text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT montanttotalfacture
FROM gap.Factures
WHERE parentfacture = $1 $_$;


ALTER FUNCTION public.get_montant_davoir(numerfacture text) OWNER TO psante;

--
-- Name: get_montant_total_bordereau(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_montant_total_bordereau(numerobordereau text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT SUM(montanttotalfacture)::INT
FROM gap.Bordereau_factures B,
    gap.factures F
WHERE F.numeroFacture = B.numerofacture
    AND typeFacture = 'original'
    AND numeroBordereau = $1 $_$;


ALTER FUNCTION public.get_montant_total_bordereau(numerobordereau text) OWNER TO psante;

--
-- Name: get_nbfacture_bordereau(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_nbfacture_bordereau(numerobordereau text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT COUNT(*)::INT
FROM gap.Bordereau_factures
WHERE numeroBordereau = $1 $_$;


ALTER FUNCTION public.get_nbfacture_bordereau(numerobordereau text) OWNER TO psante;

--
-- Name: get_nombre_factures(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_nombre_factures(numerobordereau text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT COUNT(*)::INT
FROM gap.Bordereau_factures
WHERE numeroBordereau = $1 $_$;


ALTER FUNCTION public.get_nombre_factures(numerobordereau text) OWNER TO psante;

--
-- Name: get_numerobordereau(); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_numerobordereau() RETURNS text
    LANGUAGE sql STRICT
    AS $$
SELECT concat(
        lpad(
            nextval('numeroBordereau_sequence')::TEXT,
            4,
            '00000'
        ),
        'B'
    ) $$;


ALTER FUNCTION public.get_numerobordereau() OWNER TO psante;

--
-- Name: get_numerocompte(); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_numerocompte() RETURNS text
    LANGUAGE sql STRICT
    AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(nextval('numeroCompte_sequence')::TEXT, 4, '000'),
        'C'
    ) $$;


ALTER FUNCTION public.get_numerocompte() OWNER TO psante;

--
-- Name: get_numerofacture(); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_numerofacture() RETURNS text
    LANGUAGE sql STRICT
    AS $$
SELECT concat(
        lpad(
            nextval('numeroFacture_sequence')::TEXT,
            4,
            '00000'
        ),
        'F'
    ) $$;


ALTER FUNCTION public.get_numerofacture() OWNER TO psante;

--
-- Name: get_numeropaiement(); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_numeropaiement() RETURNS text
    LANGUAGE sql STRICT
    AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(
            nextval('numeroPaiement_sequence')::TEXT,
            4,
            '000'
        ),
        'Re'
    ) $$;


ALTER FUNCTION public.get_numeropaiement() OWNER TO psante;

--
-- Name: get_numerorecu(); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_numerorecu() RETURNS text
    LANGUAGE sql STRICT
    AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(nextval('numeroRecu_sequence')::TEXT, 4, '000'),
        'R'
    ) $$;


ALTER FUNCTION public.get_numerorecu() OWNER TO psante;

--
-- Name: get_numerosejour(); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_numerosejour() RETURNS text
    LANGUAGE sql STRICT
    AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(
            nextval('numeroSejour_sequence')::TEXT,
            4,
            '00000'
        ),
        'S'
    ) $$;


ALTER FUNCTION public.get_numerosejour() OWNER TO psante;

--
-- Name: get_paiement_assurance(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_paiement_assurance(numerofacture text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT CASE
        WHEN SUM(montantPaiement::INT)::INT isnull THEN 0
        WHEN SUM(montantPaiement::INT)::INT is not null THEN SUM(montantPaiement::INT)::INT
    END AS somme
FROM gap.paiements,
    gap.Factures
WHERE numeroFacture = facturePaiement
    AND sourcePaiement = 'Assurance'
    AND numeroFacture = $1 $_$;


ALTER FUNCTION public.get_paiement_assurance(numerofacture text) OWNER TO psante;

--
-- Name: get_paiement_patient(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_paiement_patient(numerofacture text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT CASE
        WHEN SUM(montantPaiement::INT)::INT isnull THEN 0
        WHEN SUM(montantPaiement::INT)::INT is not null THEN SUM(montantPaiement::INT)::INT
    END AS somme
FROM gap.paiements,
    gap.Factures
WHERE numeroFacture = facturePaiement
    AND sourcePaiement = 'Patient'
    AND numeroFacture = $1 $_$;


ALTER FUNCTION public.get_paiement_patient(numerofacture text) OWNER TO psante;

--
-- Name: get_part_assurance(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_part_assurance(numerosejour text) RETURNS numeric
    LANGUAGE sql STRICT
    AS $_$
SELECT (
        ((taux::INT) *(get_total_facture_Assurance($1))) / 100
    )::NUMERIC(15, 2)
FROM gap.Sejours
WHERE numeroSejour = $1 $_$;


ALTER FUNCTION public.get_part_assurance(numerosejour text) OWNER TO psante;

--
-- Name: get_part_assurance_bordereau(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_part_assurance_bordereau(numerobordereau text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT SUM(partassurancefacture)::INT
FROM gap.Bordereau_factures B,
    gap.factures F
WHERE F.numeroFacture = B.numerofacture
    AND typeFacture = 'original'
    AND numeroBordereau = $1 $_$;


ALTER FUNCTION public.get_part_assurance_bordereau(numerobordereau text) OWNER TO psante;

--
-- Name: get_part_patient(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_part_patient(numerosejour text) RETURNS numeric
    LANGUAGE sql STRICT
    AS $_$
SELECT (get_total_facture($1) - get_part_assurance($1))::NUMERIC(15, 2) $_$;


ALTER FUNCTION public.get_part_patient(numerosejour text) OWNER TO psante;

--
-- Name: get_part_patient_bordereau(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_part_patient_bordereau(numerobordereau text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT SUM(partpatientfacture)::INT
FROM gap.Bordereau_factures B,
    gap.factures F
WHERE F.numeroFacture = B.numerofacture
    AND typeFacture = 'original'
    AND numeroBordereau = $1 $_$;


ALTER FUNCTION public.get_part_patient_bordereau(numerobordereau text) OWNER TO psante;

--
-- Name: get_prix_acte(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_prix_acte(lettrecle text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT prixActe::INT
FROM general.Prix_Actes
WHERE lettreCleActe = $1 $_$;


ALTER FUNCTION public.get_prix_acte(lettrecle text) OWNER TO psante;

--
-- Name: get_reste_assurance(text, text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_reste_assurance(numerosejour text, numerofacture text) RETURNS numeric
    LANGUAGE sql STRICT
    AS $$
SELECT (
        get_part_assurance(numeroSejour) - get_paiement_assurance(numeroFacture)
    )::NUMERIC(15, 2) $$;


ALTER FUNCTION public.get_reste_assurance(numerosejour text, numerofacture text) OWNER TO psante;

--
-- Name: get_reste_patient(text, text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_reste_patient(numerosejour text, numerofacture text) RETURNS numeric
    LANGUAGE sql STRICT
    AS $$
SELECT get_part_patient(numeroSejour) - get_paiement_patient(numeroFacture) $$;


ALTER FUNCTION public.get_reste_patient(numerosejour text, numerofacture text) OWNER TO psante;

--
-- Name: get_total_facture(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_total_facture(numerosejour text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT SUM(prixActe::INT)::INT
FROM gap.Sejour_Acte
WHERE Sejour_Acte.numeroSejour = $1
GROUP BY Sejour_Acte.numeroSejour $_$;


ALTER FUNCTION public.get_total_facture(numerosejour text) OWNER TO psante;

--
-- Name: get_total_facture_assurance(text); Type: FUNCTION; Schema: public; Owner: psante
--

CREATE FUNCTION public.get_total_facture_assurance(numerosejour text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT SUM(prixActeAssurance::INT)::INT
FROM gap.Sejour_Acte
WHERE Sejour_Acte.numeroSejour = $1
GROUP BY Sejour_Acte.numeroSejour $_$;


ALTER FUNCTION public.get_total_facture_assurance(numerosejour text) OWNER TO psante;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: apps; Type: TABLE; Schema: admin; Owner: psante
--

CREATE TABLE admin.apps (
    idapp integer NOT NULL,
    codeapp character varying(20),
    nomapp character varying(50),
    descapp character varying(50)
);


ALTER TABLE admin.apps OWNER TO psante;

--
-- Name: apps_idapp_seq; Type: SEQUENCE; Schema: admin; Owner: psante
--

CREATE SEQUENCE admin.apps_idapp_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin.apps_idapp_seq OWNER TO psante;

--
-- Name: apps_idapp_seq; Type: SEQUENCE OWNED BY; Schema: admin; Owner: psante
--

ALTER SEQUENCE admin.apps_idapp_seq OWNED BY admin.apps.idapp;


--
-- Name: connections; Type: TABLE; Schema: admin; Owner: psante
--

CREATE TABLE admin.connections (
    idconnection integer NOT NULL,
    statusconnection character varying(100),
    userconnection integer
);


ALTER TABLE admin.connections OWNER TO psante;

--
-- Name: connections_idconnection_seq; Type: SEQUENCE; Schema: admin; Owner: psante
--

CREATE SEQUENCE admin.connections_idconnection_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin.connections_idconnection_seq OWNER TO psante;

--
-- Name: connections_idconnection_seq; Type: SEQUENCE OWNED BY; Schema: admin; Owner: psante
--

ALTER SEQUENCE admin.connections_idconnection_seq OWNED BY admin.connections.idconnection;


--
-- Name: logs; Type: TABLE; Schema: admin; Owner: psante
--

CREATE TABLE admin.logs (
    idlogs integer NOT NULL,
    datelog date DEFAULT (now())::date,
    heurelog time without time zone DEFAULT (now())::time without time zone,
    typelog character varying(200),
    objetlog character varying(200),
    auteurlog character varying(50),
    operationlog text,
    actionlog text,
    app character varying(50)
);


ALTER TABLE admin.logs OWNER TO psante;

--
-- Name: logs_idlogs_seq; Type: SEQUENCE; Schema: admin; Owner: psante
--

CREATE SEQUENCE admin.logs_idlogs_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin.logs_idlogs_seq OWNER TO psante;

--
-- Name: logs_idlogs_seq; Type: SEQUENCE OWNED BY; Schema: admin; Owner: psante
--

ALTER SEQUENCE admin.logs_idlogs_seq OWNED BY admin.logs.idlogs;


--
-- Name: profils; Type: TABLE; Schema: admin; Owner: psante
--

CREATE TABLE admin.profils (
    idprofil integer NOT NULL,
    labelprofil character varying(100),
    dateprofil date DEFAULT now(),
    codeapp character varying(20),
    permissionsprofil text
);


ALTER TABLE admin.profils OWNER TO psante;

--
-- Name: profils_idprofil_seq; Type: SEQUENCE; Schema: admin; Owner: psante
--

CREATE SEQUENCE admin.profils_idprofil_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin.profils_idprofil_seq OWNER TO psante;

--
-- Name: profils_idprofil_seq; Type: SEQUENCE OWNED BY; Schema: admin; Owner: psante
--

ALTER SEQUENCE admin.profils_idprofil_seq OWNED BY admin.profils.idprofil;


--
-- Name: users; Type: TABLE; Schema: admin; Owner: psante
--

CREATE TABLE admin.users (
    iduser integer NOT NULL,
    nomuser character varying(20),
    prenomsuser character varying(50),
    contactuser character varying(20),
    mailuser character varying(30),
    posteuser character varying(100),
    serviceuser character varying(100),
    loginuser character varying(100),
    passuser character varying(255),
    profiluser character varying(100)
);


ALTER TABLE admin.users OWNER TO psante;

--
-- Name: users_iduser_seq; Type: SEQUENCE; Schema: admin; Owner: psante
--

CREATE SEQUENCE admin.users_iduser_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin.users_iduser_seq OWNER TO psante;

--
-- Name: users_iduser_seq; Type: SEQUENCE OWNED BY; Schema: admin; Owner: psante
--

ALTER SEQUENCE admin.users_iduser_seq OWNED BY admin.users.iduser;


--
-- Name: assurances; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.assurances (
    idassurance integer NOT NULL,
    nomassurance character varying(50) NOT NULL,
    codeassurance character varying(20),
    typeassurance character varying(20),
    faxassurance character varying(30),
    telassurance character varying(50),
    mailassurance character varying(30),
    localassurance character varying(100),
    siteassurance character varying(100)
);


ALTER TABLE gap.assurances OWNER TO psante;

--
-- Name: assurances_idassurance_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.assurances_idassurance_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.assurances_idassurance_seq OWNER TO psante;

--
-- Name: assurances_idassurance_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.assurances_idassurance_seq OWNED BY gap.assurances.idassurance;


--
-- Name: bordereau_factures; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.bordereau_factures (
    idbordereau_facture integer NOT NULL,
    numerofacture character varying(100),
    numerobordereau character varying(100)
);


ALTER TABLE gap.bordereau_factures OWNER TO psante;

--
-- Name: bordereau_factures_idbordereau_facture_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.bordereau_factures_idbordereau_facture_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.bordereau_factures_idbordereau_facture_seq OWNER TO psante;

--
-- Name: bordereau_factures_idbordereau_facture_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.bordereau_factures_idbordereau_facture_seq OWNED BY gap.bordereau_factures.idbordereau_facture;


--
-- Name: bordereaux; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.bordereaux (
    idbordereau integer NOT NULL,
    numerobordereau character varying(30) DEFAULT public.get_numerobordereau(),
    datecreationbordereau character varying(30),
    heurecreationbordereau character varying(30),
    datelimitebordereau character varying(30),
    gestionnairebordereau character varying(100),
    organismebordereau character varying(100),
    typesejourbordereau character varying(100),
    montanttotal integer,
    partassurance integer,
    partpatient integer,
    statutbordereau character varying(100),
    commentairebordereau text
);


ALTER TABLE gap.bordereaux OWNER TO psante;

--
-- Name: bordereaux_idbordereau_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.bordereaux_idbordereau_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.bordereaux_idbordereau_seq OWNER TO psante;

--
-- Name: bordereaux_idbordereau_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.bordereaux_idbordereau_seq OWNED BY gap.bordereaux.idbordereau;


--
-- Name: comptes; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.comptes (
    idcompte integer NOT NULL,
    numerocompte character varying(30) DEFAULT public.get_numerocompte(),
    montantcompte integer DEFAULT 0,
    datecompte character varying(20),
    heurecompte character varying(10),
    patientcompte character varying(20)
);


ALTER TABLE gap.comptes OWNER TO psante;

--
-- Name: comptes_idcompte_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.comptes_idcompte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.comptes_idcompte_seq OWNER TO psante;

--
-- Name: comptes_idcompte_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.comptes_idcompte_seq OWNED BY gap.comptes.idcompte;


--
-- Name: controles; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.controles (
    idcontrole integer NOT NULL,
    datedebutcontrole character varying(30),
    heuredebutcontrole character varying(20),
    datefincontrole character varying(30),
    heurefincontrole character varying(20),
    typecontrole character varying(30) DEFAULT 'Controle'::character varying,
    statutcontrole character varying(30) DEFAULT 'attente(infirmier)'::character varying,
    sejourcontrole character varying(20)
);


ALTER TABLE gap.controles OWNER TO psante;

--
-- Name: controles_idcontrole_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.controles_idcontrole_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.controles_idcontrole_seq OWNER TO psante;

--
-- Name: controles_idcontrole_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.controles_idcontrole_seq OWNED BY gap.controles.idcontrole;


--
-- Name: dossieradministratif; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.dossieradministratif (
    iddossier integer NOT NULL,
    ipppatient character varying(200) DEFAULT public.get_ipp(),
    nompatient character varying(100),
    prenomspatient character varying(200),
    civilitepatient character varying(200),
    sexepatient character varying(15),
    datenaissancepatient character varying(100),
    lieunaissancepatient character varying(100),
    nationalitepatient character varying(50),
    professionpatient character varying(100),
    situationmatrimonialepatient character varying(50),
    religionpatient character varying(100),
    habitationpatient character varying(100),
    contactpatient character varying(50),
    nomperepatient character varying(100),
    prenomsperepatient character varying(100),
    contactperepatient character varying(100),
    nommerepatient character varying(100),
    prenomsmerepatient character varying(100),
    contactmerepatient character varying(100),
    nomtuteurpatient character varying(100),
    prenomstuteurpatient character varying(100),
    contacttuteurpatient character varying(100),
    nompersonnesurepatient character varying(100),
    prenomspersonnesurepatient character varying(100),
    contactpersonnesurepatient character varying(100),
    qualitepersonnesurepatient character varying(100)
);


ALTER TABLE gap.dossieradministratif OWNER TO psante;

--
-- Name: dossieradministratif_iddossier_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.dossieradministratif_iddossier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.dossieradministratif_iddossier_seq OWNER TO psante;

--
-- Name: dossieradministratif_iddossier_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.dossieradministratif_iddossier_seq OWNED BY gap.dossieradministratif.iddossier;


--
-- Name: encaissements; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.encaissements (
    id integer NOT NULL,
    numeroencaissement character varying(30) DEFAULT public.get_numeropaiement(),
    dateencaissement date DEFAULT (now())::date,
    heureencaissement time without time zone DEFAULT (now())::time without time zone,
    modepaiementencaissement character varying(100),
    commentaireencaissement text,
    montantencaissement integer,
    resteencaissement integer,
    assuranceencaissement character varying(200),
    recepteurencaissement character varying(200)
);


ALTER TABLE gap.encaissements OWNER TO psante;

--
-- Name: encaissements_id_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.encaissements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.encaissements_id_seq OWNER TO psante;

--
-- Name: encaissements_id_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.encaissements_id_seq OWNED BY gap.encaissements.id;


--
-- Name: factures; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.factures (
    idfacture integer NOT NULL,
    numerofacture character varying(100) DEFAULT public.get_numerofacture(),
    typefacture character varying(40),
    parentfacture character varying(50) DEFAULT ''::character varying,
    datefacture character varying(20),
    heurefacture character varying(10),
    auteurfacture character varying(100),
    montanttotalfacture integer DEFAULT 0,
    partassurancefacture integer DEFAULT 0,
    partpatientfacture integer DEFAULT 0,
    resteassurancefacture integer DEFAULT 0,
    restepatientfacture integer DEFAULT 0,
    statutfacture character varying(50) DEFAULT 'attente'::character varying,
    erreurfacture character varying(100) DEFAULT ''::character varying,
    commentairefacture text DEFAULT ''::text,
    sejourfacture character varying(30)
);


ALTER TABLE gap.factures OWNER TO psante;

--
-- Name: factures_idfacture_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.factures_idfacture_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.factures_idfacture_seq OWNER TO psante;

--
-- Name: factures_idfacture_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.factures_idfacture_seq OWNED BY gap.factures.idfacture;


--
-- Name: paiements; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.paiements (
    idpaiement integer NOT NULL,
    numeropaiement character varying(30) DEFAULT public.get_numeropaiement(),
    modepaiement character varying(100),
    montantpaiement character varying(50) NOT NULL,
    sourcepaiement character varying(30),
    facturepaiement character varying(30)
);


ALTER TABLE gap.paiements OWNER TO psante;

--
-- Name: paiements_idpaiement_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.paiements_idpaiement_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.paiements_idpaiement_seq OWNER TO psante;

--
-- Name: paiements_idpaiement_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.paiements_idpaiement_seq OWNED BY gap.paiements.idpaiement;


--
-- Name: recus; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.recus (
    idrecu integer NOT NULL,
    numerorecu character varying(30) DEFAULT public.get_numerorecu(),
    montantrecu integer,
    daterecu date,
    patientrecu character varying(100),
    facturerecu character varying(30),
    paiementrecu character varying(30),
    sejourrecu character varying(30)
);


ALTER TABLE gap.recus OWNER TO psante;

--
-- Name: recus_idrecu_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.recus_idrecu_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.recus_idrecu_seq OWNER TO psante;

--
-- Name: recus_idrecu_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.recus_idrecu_seq OWNED BY gap.recus.idrecu;


--
-- Name: sejour_acte; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.sejour_acte (
    idsejouracte integer NOT NULL,
    numerosejour character varying(20),
    codeacte character varying(20),
    prixunique numeric(15,2),
    plafondassurance numeric(15,2),
    quantite integer,
    prixacte numeric(15,2),
    prixacteassurance numeric(15,2) GENERATED ALWAYS AS ((plafondassurance * (quantite)::numeric)) STORED
);


ALTER TABLE gap.sejour_acte OWNER TO psante;

--
-- Name: sejour_acte_idsejouracte_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.sejour_acte_idsejouracte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.sejour_acte_idsejouracte_seq OWNER TO psante;

--
-- Name: sejour_acte_idsejouracte_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.sejour_acte_idsejouracte_seq OWNED BY gap.sejour_acte.idsejouracte;


--
-- Name: sejours; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.sejours (
    idsejour integer NOT NULL,
    numerosejour character varying(30) DEFAULT public.get_numerosejour(),
    datedebutsejour character varying(50),
    datefinsejour character varying(50),
    heuredebutsejour character varying(50),
    heurefinsejour character varying(50),
    specialitesejour character varying(50),
    typesejour character varying(50),
    statussejour character varying(50),
    medecinsejour character varying(200),
    patientsejour integer,
    etablissementsejour integer,
    gestionnaire character varying(100),
    organisme character varying(100),
    beneficiaire character varying(50),
    assureprinc character varying(100),
    matriculeassure character varying(50),
    numeropec character varying(20),
    taux integer DEFAULT 0
);


ALTER TABLE gap.sejours OWNER TO psante;

--
-- Name: sejours_idsejour_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.sejours_idsejour_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.sejours_idsejour_seq OWNER TO psante;

--
-- Name: sejours_idsejour_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.sejours_idsejour_seq OWNED BY gap.sejours.idsejour;


--
-- Name: transactions; Type: TABLE; Schema: gap; Owner: psante
--

CREATE TABLE gap.transactions (
    idtransaction integer NOT NULL,
    datetransaction character varying(20),
    heuretransaction character varying(10),
    montanttransaction integer,
    modetransaction character varying(20),
    typetransaction character varying(20),
    comptetransaction character varying(20)
);


ALTER TABLE gap.transactions OWNER TO psante;

--
-- Name: transactions_idtransaction_seq; Type: SEQUENCE; Schema: gap; Owner: psante
--

CREATE SEQUENCE gap.transactions_idtransaction_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gap.transactions_idtransaction_seq OWNER TO psante;

--
-- Name: transactions_idtransaction_seq; Type: SEQUENCE OWNED BY; Schema: gap; Owner: psante
--

ALTER SEQUENCE gap.transactions_idtransaction_seq OWNED BY gap.transactions.idtransaction;


--
-- Name: actes; Type: TABLE; Schema: general; Owner: psante
--

CREATE TABLE general.actes (
    idacte integer NOT NULL,
    codeacte character varying(30),
    typeacte character varying(100),
    libelleacte text,
    lettrecleacte character varying(10),
    prixlettrecleacte numeric(10,2),
    regroupementacte character varying(10),
    cotationacte numeric(10,2),
    prixacte numeric(10,2) GENERATED ALWAYS AS ((cotationacte * prixlettrecleacte)) STORED
);


ALTER TABLE general.actes OWNER TO psante;

--
-- Name: actes_idacte_seq; Type: SEQUENCE; Schema: general; Owner: psante
--

CREATE SEQUENCE general.actes_idacte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE general.actes_idacte_seq OWNER TO psante;

--
-- Name: actes_idacte_seq; Type: SEQUENCE OWNED BY; Schema: general; Owner: psante
--

ALTER SEQUENCE general.actes_idacte_seq OWNED BY general.actes.idacte;


--
-- Name: chambre; Type: TABLE; Schema: general; Owner: psante
--

CREATE TABLE general.chambre (
);


ALTER TABLE general.chambre OWNER TO psante;

--
-- Name: etablissement; Type: TABLE; Schema: general; Owner: psante
--

CREATE TABLE general.etablissement (
    idetablissement integer NOT NULL,
    regionetabblissement character varying(100),
    districtetablissement character varying(100),
    nometablissement character varying(100),
    statusetablissement character varying(100),
    adresseetablissement character varying(200),
    codepostaleetablissement character varying(100),
    teletablissement character varying(50),
    faxetablissement character varying(20),
    emailetablissement character varying(30),
    sitewebetablissement character varying(20),
    logoetablissement character varying(200)
);


ALTER TABLE general.etablissement OWNER TO psante;

--
-- Name: etablissement_idetablissement_seq; Type: SEQUENCE; Schema: general; Owner: psante
--

CREATE SEQUENCE general.etablissement_idetablissement_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE general.etablissement_idetablissement_seq OWNER TO psante;

--
-- Name: etablissement_idetablissement_seq; Type: SEQUENCE OWNED BY; Schema: general; Owner: psante
--

ALTER SEQUENCE general.etablissement_idetablissement_seq OWNED BY general.etablissement.idetablissement;


--
-- Name: prix_actes; Type: TABLE; Schema: general; Owner: psante
--

CREATE TABLE general.prix_actes (
    idprixactes integer NOT NULL,
    lettrecleacte character varying(10),
    prixacte integer
);


ALTER TABLE general.prix_actes OWNER TO psante;

--
-- Name: prix_actes_idprixactes_seq; Type: SEQUENCE; Schema: general; Owner: psante
--

CREATE SEQUENCE general.prix_actes_idprixactes_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE general.prix_actes_idprixactes_seq OWNER TO psante;

--
-- Name: prix_actes_idprixactes_seq; Type: SEQUENCE OWNED BY; Schema: general; Owner: psante
--

ALTER SEQUENCE general.prix_actes_idprixactes_seq OWNED BY general.prix_actes.idprixactes;


--
-- Name: unitefonctionnelle; Type: TABLE; Schema: general; Owner: psante
--

CREATE TABLE general.unitefonctionnelle (
);


ALTER TABLE general.unitefonctionnelle OWNER TO psante;

--
-- Name: unitemedicale; Type: TABLE; Schema: general; Owner: psante
--

CREATE TABLE general.unitemedicale (
);


ALTER TABLE general.unitemedicale OWNER TO psante;

--
-- Name: ipp_sequence; Type: SEQUENCE; Schema: public; Owner: psante
--

CREATE SEQUENCE public.ipp_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1;


ALTER TABLE public.ipp_sequence OWNER TO psante;

--
-- Name: numerobordereau_sequence; Type: SEQUENCE; Schema: public; Owner: psante
--

CREATE SEQUENCE public.numerobordereau_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1;


ALTER TABLE public.numerobordereau_sequence OWNER TO psante;

--
-- Name: numerocompte_sequence; Type: SEQUENCE; Schema: public; Owner: psante
--

CREATE SEQUENCE public.numerocompte_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1;


ALTER TABLE public.numerocompte_sequence OWNER TO psante;

--
-- Name: numerofacture_sequence; Type: SEQUENCE; Schema: public; Owner: psante
--

CREATE SEQUENCE public.numerofacture_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1;


ALTER TABLE public.numerofacture_sequence OWNER TO psante;

--
-- Name: numeropaiement_sequence; Type: SEQUENCE; Schema: public; Owner: psante
--

CREATE SEQUENCE public.numeropaiement_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1;


ALTER TABLE public.numeropaiement_sequence OWNER TO psante;

--
-- Name: numerorecu_sequence; Type: SEQUENCE; Schema: public; Owner: psante
--

CREATE SEQUENCE public.numerorecu_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1;


ALTER TABLE public.numerorecu_sequence OWNER TO psante;

--
-- Name: numerosejour_sequence; Type: SEQUENCE; Schema: public; Owner: psante
--

CREATE SEQUENCE public.numerosejour_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1;


ALTER TABLE public.numerosejour_sequence OWNER TO psante;

--
-- Name: apps idapp; Type: DEFAULT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.apps ALTER COLUMN idapp SET DEFAULT nextval('admin.apps_idapp_seq'::regclass);


--
-- Name: connections idconnection; Type: DEFAULT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.connections ALTER COLUMN idconnection SET DEFAULT nextval('admin.connections_idconnection_seq'::regclass);


--
-- Name: logs idlogs; Type: DEFAULT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.logs ALTER COLUMN idlogs SET DEFAULT nextval('admin.logs_idlogs_seq'::regclass);


--
-- Name: profils idprofil; Type: DEFAULT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.profils ALTER COLUMN idprofil SET DEFAULT nextval('admin.profils_idprofil_seq'::regclass);


--
-- Name: users iduser; Type: DEFAULT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.users ALTER COLUMN iduser SET DEFAULT nextval('admin.users_iduser_seq'::regclass);


--
-- Name: assurances idassurance; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.assurances ALTER COLUMN idassurance SET DEFAULT nextval('gap.assurances_idassurance_seq'::regclass);


--
-- Name: bordereau_factures idbordereau_facture; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.bordereau_factures ALTER COLUMN idbordereau_facture SET DEFAULT nextval('gap.bordereau_factures_idbordereau_facture_seq'::regclass);


--
-- Name: bordereaux idbordereau; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.bordereaux ALTER COLUMN idbordereau SET DEFAULT nextval('gap.bordereaux_idbordereau_seq'::regclass);


--
-- Name: comptes idcompte; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.comptes ALTER COLUMN idcompte SET DEFAULT nextval('gap.comptes_idcompte_seq'::regclass);


--
-- Name: controles idcontrole; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.controles ALTER COLUMN idcontrole SET DEFAULT nextval('gap.controles_idcontrole_seq'::regclass);


--
-- Name: dossieradministratif iddossier; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.dossieradministratif ALTER COLUMN iddossier SET DEFAULT nextval('gap.dossieradministratif_iddossier_seq'::regclass);


--
-- Name: encaissements id; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.encaissements ALTER COLUMN id SET DEFAULT nextval('gap.encaissements_id_seq'::regclass);


--
-- Name: factures idfacture; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.factures ALTER COLUMN idfacture SET DEFAULT nextval('gap.factures_idfacture_seq'::regclass);


--
-- Name: paiements idpaiement; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.paiements ALTER COLUMN idpaiement SET DEFAULT nextval('gap.paiements_idpaiement_seq'::regclass);


--
-- Name: recus idrecu; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.recus ALTER COLUMN idrecu SET DEFAULT nextval('gap.recus_idrecu_seq'::regclass);


--
-- Name: sejour_acte idsejouracte; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.sejour_acte ALTER COLUMN idsejouracte SET DEFAULT nextval('gap.sejour_acte_idsejouracte_seq'::regclass);


--
-- Name: sejours idsejour; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.sejours ALTER COLUMN idsejour SET DEFAULT nextval('gap.sejours_idsejour_seq'::regclass);


--
-- Name: transactions idtransaction; Type: DEFAULT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.transactions ALTER COLUMN idtransaction SET DEFAULT nextval('gap.transactions_idtransaction_seq'::regclass);


--
-- Name: actes idacte; Type: DEFAULT; Schema: general; Owner: psante
--

ALTER TABLE ONLY general.actes ALTER COLUMN idacte SET DEFAULT nextval('general.actes_idacte_seq'::regclass);


--
-- Name: etablissement idetablissement; Type: DEFAULT; Schema: general; Owner: psante
--

ALTER TABLE ONLY general.etablissement ALTER COLUMN idetablissement SET DEFAULT nextval('general.etablissement_idetablissement_seq'::regclass);


--
-- Name: prix_actes idprixactes; Type: DEFAULT; Schema: general; Owner: psante
--

ALTER TABLE ONLY general.prix_actes ALTER COLUMN idprixactes SET DEFAULT nextval('general.prix_actes_idprixactes_seq'::regclass);


--
-- Data for Name: apps; Type: TABLE DATA; Schema: admin; Owner: psante
--

COPY admin.apps (idapp, codeapp, nomapp, descapp) FROM stdin;
1	COAP001	GAP	Gestion administrative du patient
2	COAP002	DPI	Dossier patient informatisé
3	COAP003	PUI	Pharmacie à usage interne
4	COAP004	ADMIN	Administrateur du systeme
\.


--
-- Data for Name: connections; Type: TABLE DATA; Schema: admin; Owner: psante
--

COPY admin.connections (idconnection, statusconnection, userconnection) FROM stdin;
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: admin; Owner: psante
--

COPY admin.logs (idlogs, datelog, heurelog, typelog, objetlog, auteurlog, operationlog, actionlog, app) FROM stdin;
1	2020-09-20	23:38:40.107494	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
2	2020-09-20	23:39:24.033143	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
3	2020-09-20	23:39:56.158386	Création	Patient	KOFFI Edy	Création du patient null	{"iddossier":1,"ipppatient":null,"nompatient":"KOFFI","prenomspatient":"EDY","civilitepatient":"Mme","sexepatient":"M","datenaissancepatient":"20-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Marcory","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 51 263 563","qualitepersonnesurepatient":""}	COAP001
4	2020-09-20	23:41:17.565262	Création	Patient	KOFFI Edy	Création du patient 2020264-0001P	{"iddossier":1,"ipppatient":"2020264-0001P","nompatient":"KOFFI","prenomspatient":"EDY","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"20-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Marcory","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 51 889 632","qualitepersonnesurepatient":""}	COAP001
5	2020-09-20	23:42:06.623513	CREATION	Séjour	KOFFI Edy	Création du séjour 2020264-0001S	{"numerosejour":"2020264-0001S","idsejour":1,"datedebutsejour":"20-09-2020","datefinsejour":"20-09-2020","heuredebutsejour":"11:41","heurefinsejour":"11:46","specialitesejour":"Gynécologie","typesejour":"Consultation","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":1,"etablissementsejour":1,"gestionnaire":"","organisme":"","beneficiaire":"","assureprinc":"","matriculeassure":"","numeropec":"","taux":0}	COAP001
6	2020-09-20	23:42:06.709702	CREATION	Facture	KOFFI Edy	Création de la facture 0001F	{"idfacture":1,"numerofacture":"0001F","typefacture":"original","parentfacture":"","datefacture":"20-09-2020","heurefacture":"11:42","auteurfacture":"KOFFI Edy","montanttotalfacture":900,"partassurancefacture":0,"partpatientfacture":900,"resteassurancefacture":0,"restepatientfacture":900,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020264-0001S"}	COAP001
7	2020-09-20	23:46:40.299376	CREATION	Séjour	KOFFI Edy	Création du séjour 2020264-0002S	{"numerosejour":"2020264-0002S","idsejour":2,"datedebutsejour":"20-09-2020","datefinsejour":"20-09-2020","heuredebutsejour":"11:45","heurefinsejour":"11:56","specialitesejour":"Mèdecine générale","typesejour":"hospitalisation","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":1,"etablissementsejour":1,"gestionnaire":"MCI CARE","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"KOFFI EDY","matriculeassure":"785312","numeropec":"325632","taux":40}	COAP001
8	2020-09-20	23:46:40.385319	CREATION	Facture	KOFFI Edy	Création de la facture 0002F	{"idfacture":2,"numerofacture":"0002F","typefacture":"original","parentfacture":"","datefacture":"20-09-2020","heurefacture":"11:46","auteurfacture":"KOFFI Edy","montanttotalfacture":1350,"partassurancefacture":540,"partpatientfacture":810,"resteassurancefacture":540,"restepatientfacture":810,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020264-0002S"}	COAP001
9	2020-09-20	23:47:38.430698	CREATION	Encaissement	KOFFI Edy	Ajout de l'encaissement 2020264-0001Re	{"id":1,"numeroencaissement":"2020264-0001Re","dateencaissement":"2020-09-20T00:00:00.000Z","heureencaissement":"23:47:38.37759","modepaiementencaissement":"Espèces","commentaireencaissement":"Pour les factures allianz","montantencaissement":2000000,"resteencaissement":2000000,"assuranceencaissement":"ALLAINZ","recepteurencaissement":"KOFFI Edy"}	COAP001
10	2020-09-21	00:20:55.749185	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
11	2020-09-21	06:30:03.199432	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
12	2020-09-21	08:38:04.886615	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
13	2020-09-21	08:39:36.21891	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
14	2020-09-21	08:49:35.254127	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
15	2020-09-21	09:38:37.065301	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
16	2020-09-21	09:41:11.59314	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
17	2020-09-21	10:39:10.342685	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
18	2020-09-21	10:57:53.068355	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
19	2020-09-21	12:04:32.338922	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
20	2020-09-21	13:10:50.948857	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
21	2020-09-21	14:16:47.154343	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
22	2020-09-21	14:17:47.354175	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
23	2020-09-21	19:56:25.380348	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
24	2020-09-22	03:03:23.285224	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
25	2020-09-22	03:04:41.334571	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
26	2020-09-22	03:07:14.439169	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
27	2020-09-22	08:46:25.803598	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
28	2020-09-22	08:49:05.059442	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
29	2020-09-22	08:58:10.275495	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
30	2020-09-22	08:59:03.289332	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
31	2020-09-22	09:06:29.691601	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
32	2020-09-22	09:11:46.692164	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
33	2020-09-22	09:12:03.38453	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
34	2020-09-22	09:20:56.871803	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
35	2020-09-22	09:43:34.283035	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
36	2020-09-22	09:47:41.670579	Création	Patient	KOFFI Edy	Création du patient 2020266-0002P	{"iddossier":2,"ipppatient":"2020266-0002P","nompatient":"GUISSO","prenomspatient":"Dorgeless","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"03-12-2000","lieunaissancepatient":"COCODY","nationalitepatient":"Côte d Ivoire","professionpatient":"etudiant","situationmatrimonialepatient":"Célibataire","religionpatient":"Chrétient","habitationpatient":"Dokui Mahou","contactpatient":"(225) 79 706 312","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"DADJE","prenomsmerepatient":"Hortense","contactmerepatient":"(225) 77 135 212","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"DADJE","prenomspersonnesurepatient":"Hortense","contactpersonnesurepatient":"(225) 77 135 212","qualitepersonnesurepatient":"Mère"}	COAP001
37	2020-09-22	10:01:13.178281	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
38	2020-09-22	10:50:17.860025	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
39	2020-09-22	10:56:22.532014	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0003S	{"numerosejour":"2020266-0003S","idsejour":3,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"10:55","heurefinsejour":"10:55","specialitesejour":"Gynécologie","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"GBADJE Wilfried","patientsejour":2,"etablissementsejour":1,"gestionnaire":"ALLAINZ","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"GUISSO Dorgeless","matriculeassure":"123","numeropec":"963","taux":70}	COAP001
40	2020-09-22	10:56:22.722338	CREATION	Facture	KOFFI Edy	Création de la facture 0003F	{"idfacture":3,"numerofacture":"0003F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"10:56","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":350,"partpatientfacture":150,"resteassurancefacture":350,"restepatientfacture":150,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0003S"}	COAP001
41	2020-09-22	10:56:46.062042	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0004S	{"numerosejour":"2020266-0004S","idsejour":4,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"10:56","heurefinsejour":"10:56","specialitesejour":"Mèdecine générale","typesejour":"Imagerie","statussejour":"en attente","medecinsejour":"ZAKI Audrey","patientsejour":2,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"GUISSO Dorgeless","matriculeassure":"d6","numeropec":"862","taux":60}	COAP001
42	2020-09-22	10:56:46.148631	CREATION	Facture	KOFFI Edy	Création de la facture 0004F	{"idfacture":4,"numerofacture":"0004F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"10:56","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":300,"partpatientfacture":200,"resteassurancefacture":300,"restepatientfacture":200,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0004S"}	COAP001
43	2020-09-22	10:58:19.20942	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0005S	{"numerosejour":"2020266-0005S","idsejour":5,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"10:56","heurefinsejour":"10:56","specialitesejour":"Mèdecine générale","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"GBADJE Wilfried","patientsejour":2,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"GUISSO Dorgeless","matriculeassure":"32","numeropec":"963","taux":90}	COAP001
44	2020-09-22	10:58:19.283388	CREATION	Facture	KOFFI Edy	Création de la facture 0005F	{"idfacture":5,"numerofacture":"0005F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"10:58","auteurfacture":"KOFFI Edy","montanttotalfacture":7300,"partassurancefacture":6570,"partpatientfacture":730,"resteassurancefacture":6570,"restepatientfacture":730,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0005S"}	COAP001
45	2020-09-22	11:01:20.880655	Création	Patient	KOFFI Edy	Création du patient 2020266-0003P	{"iddossier":3,"ipppatient":"2020266-0003P","nompatient":"Amoya","prenomspatient":"Arsene","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Barbade","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Cocody","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 63 589 632","qualitepersonnesurepatient":""}	COAP001
46	2020-09-22	11:01:59.167748	Création	Patient	KOFFI Edy	Création du patient 2020266-0004P	{"iddossier":4,"ipppatient":"2020266-0004P","nompatient":"Aka","prenomspatient":"Jaures","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Côte d Ivoire","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Agban","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 88 623 235","qualitepersonnesurepatient":""}	COAP001
47	2020-09-22	11:02:34.275412	Création	Patient	KOFFI Edy	Création du patient 2020266-0005P	{"iddossier":5,"ipppatient":"2020266-0005P","nompatient":"Bogui","prenomspatient":"Audrey","civilitepatient":"Mme","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"France","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Cocody","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"(225) 89 658 965","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 12 365 489","qualitepersonnesurepatient":""}	COAP001
48	2020-09-22	11:03:19.203837	Création	Patient	KOFFI Edy	Création du patient 2020266-0006P	{"iddossier":6,"ipppatient":"2020266-0006P","nompatient":"Diakité","prenomspatient":"YAsser","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Guinée","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Treichville","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 32 159 853","qualitepersonnesurepatient":""}	COAP001
49	2020-09-22	11:04:01.444371	Création	Patient	KOFFI Edy	Création du patient 2020266-0007P	{"iddossier":7,"ipppatient":"2020266-0007P","nompatient":"Gbadje","prenomspatient":"Wilfried","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Côte d Ivoire","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Abobo","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 79 626 652","qualitepersonnesurepatient":""}	COAP001
50	2020-09-22	11:04:25.29868	Création	Patient	KOFFI Edy	Création du patient 2020266-0008P	{"iddossier":8,"ipppatient":"2020266-0008P","nompatient":"N'Dongo","prenomspatient":"Abdoul","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Sénégal","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Cocody","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 78 526 536","qualitepersonnesurepatient":""}	COAP001
51	2020-09-22	11:04:52.68646	Création	Patient	KOFFI Edy	Création du patient 2020266-0009P	{"iddossier":9,"ipppatient":"2020266-0009P","nompatient":"Soumahoro","prenomspatient":"YAssine","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Marcory","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 98 436 354","qualitepersonnesurepatient":""}	COAP001
52	2020-09-22	11:05:36.201047	Création	Patient	KOFFI Edy	Création du patient 2020266-0010P	{"iddossier":10,"ipppatient":"2020266-0010P","nompatient":"Goho","prenomspatient":"Bah Tanguy","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Côte d Ivoire","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Abobo","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 87 465 436","qualitepersonnesurepatient":""}	COAP001
53	2020-09-22	11:06:13.626997	Création	Patient	KOFFI Edy	Création du patient 2020266-0011P	{"iddossier":11,"ipppatient":"2020266-0011P","nompatient":"Koua","prenomspatient":"Hermine","civilitepatient":"M","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Côte d Ivoire","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Treichville","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 78 365 456","qualitepersonnesurepatient":""}	COAP001
54	2020-09-22	11:06:58.273447	Création	Patient	KOFFI Edy	Création du patient 2020266-0012P	{"iddossier":12,"ipppatient":"2020266-0012P","nompatient":"Tiemele","prenomspatient":"Eliud","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Côte d Ivoire","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Port bouët","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 874 646","qualitepersonnesurepatient":""}	COAP001
55	2020-09-22	11:07:38.869206	Création	Patient	KOFFI Edy	Création du patient 2020266-0013P	{"iddossier":13,"ipppatient":"2020266-0013P","nompatient":"Aka","prenomspatient":"chris","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Côte d Ivoire","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Yopougon","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 68 436 546","qualitepersonnesurepatient":""}	COAP001
56	2020-09-22	11:08:00.647958	Création	Patient	KOFFI Edy	Création du patient 2020266-0014P	{"iddossier":14,"ipppatient":"2020266-0014P","nompatient":"ZIE","prenomspatient":"Mohamed","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Treichville","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 854 356","qualitepersonnesurepatient":""}	COAP001
57	2020-09-22	11:08:25.106844	Création	Patient	KOFFI Edy	Création du patient 2020266-0015P	{"iddossier":15,"ipppatient":"2020266-0015P","nompatient":"Silué","prenomspatient":"Désiré","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Korogho","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 98 563 546","qualitepersonnesurepatient":""}	COAP001
109	2020-09-22	14:51:59.625461	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0012S	{"numerosejour":"2020266-0012S","idsejour":12,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:51","heurefinsejour":"02:51","specialitesejour":"Mèdecine générale","typesejour":"hospitalisation","statussejour":"en attente","medecinsejour":"KOFFI Edy","patientsejour":13,"etablissementsejour":1,"gestionnaire":"ALLAINZ","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"36463","numeropec":"64","taux":60}	COAP001
58	2020-09-22	11:08:45.714687	Création	Patient	KOFFI Edy	Création du patient 2020266-0016P	{"iddossier":16,"ipppatient":"2020266-0016P","nompatient":"Aste","prenomspatient":"Stephanie","civilitepatient":"Mme","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Cocody","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 843 654","qualitepersonnesurepatient":""}	COAP001
59	2020-09-22	11:09:16.713493	Création	Patient	KOFFI Edy	Création du patient 2020266-0017P	{"iddossier":17,"ipppatient":"2020266-0017P","nompatient":"Toure","prenomspatient":"Yanan","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Côte d Ivoire","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Yopougon","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 854 365","qualitepersonnesurepatient":""}	COAP001
60	2020-09-22	11:10:33.304926	MODIFICATION	Patient	KOFFI Edy	Modification du patient 2020266-0011P	{"iddossier":11,"ipppatient":"2020266-0011P","nompatient":"Koua","prenomspatient":"Hermine","civilitepatient":"Mlle","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Côte d Ivoire","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Treichville","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 78 365 456","qualitepersonnesurepatient":""}	COAP001
61	2020-09-22	11:10:45.882407	MODIFICATION	Patient	KOFFI Edy	Modification du patient 2020266-0016P	{"iddossier":16,"ipppatient":"2020266-0016P","nompatient":"Aste","prenomspatient":"Stephanie","civilitepatient":"Mlle","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Cocody","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 843 654","qualitepersonnesurepatient":""}	COAP001
62	2020-09-22	11:12:25.17944	Création	Patient	KOFFI Edy	Création du patient 2020266-0018P	{"iddossier":18,"ipppatient":"2020266-0018P","nompatient":"Soro","prenomspatient":"Fougnigué","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"Côte d Ivoire","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Korogho","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 98 743 564","qualitepersonnesurepatient":""}	COAP001
63	2020-09-22	11:13:34.587555	Création	Patient	KOFFI Edy	Création du patient 2020266-0019P	{"iddossier":19,"ipppatient":"2020266-0019P","nompatient":"Cisse","prenomspatient":"Yaya","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Korogho","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 846 343","qualitepersonnesurepatient":""}	COAP001
64	2020-09-22	11:13:57.384247	Création	Patient	KOFFI Edy	Création du patient 2020266-0020P	{"iddossier":20,"ipppatient":"2020266-0020P","nompatient":"Popouin","prenomspatient":"Yves","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Koumassi","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 451 645","qualitepersonnesurepatient":""}	COAP001
65	2020-09-22	11:15:36.081442	Création	Patient	KOFFI Edy	Création du patient 2020266-0021P	{"iddossier":21,"ipppatient":"2020266-0021P","nompatient":"kolo","prenomspatient":"Mina","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Bouaké","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 78 943 168","qualitepersonnesurepatient":""}	COAP001
66	2020-09-22	11:15:57.049097	Création	Patient	KOFFI Edy	Création du patient 2020266-0022P	{"iddossier":22,"ipppatient":"2020266-0022P","nompatient":"MOirl","prenomspatient":"Loli ediu","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Adjame","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 96 416 353","qualitepersonnesurepatient":""}	COAP001
110	2020-09-22	14:51:59.711396	CREATION	Facture	KOFFI Edy	Création de la facture 0012F	{"idfacture":12,"numerofacture":"0012F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:51","auteurfacture":"KOFFI Edy","montanttotalfacture":750,"partassurancefacture":450,"partpatientfacture":300,"resteassurancefacture":450,"restepatientfacture":300,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0012S"}	COAP001
130	2020-09-22	20:27:09.703915	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
67	2020-09-22	11:16:16.578704	Création	Patient	KOFFI Edy	Création du patient 2020266-0023P	{"iddossier":23,"ipppatient":"2020266-0023P","nompatient":"Kila","prenomspatient":"Ferue","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Abobo","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 541 686","qualitepersonnesurepatient":""}	COAP001
68	2020-09-22	11:21:28.3442	Création	Patient	KOFFI Edy	Création du patient 2020266-0024P	{"iddossier":24,"ipppatient":"2020266-0024P","nompatient":"Kouassi","prenomspatient":"Charles","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Koumassi","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 76 513 546","qualitepersonnesurepatient":""}	COAP001
69	2020-09-22	11:35:28.530991	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0006S	{"numerosejour":"2020266-0006S","idsejour":6,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"11:34","heurefinsejour":"11:34","specialitesejour":"Mèdecine générale","typesejour":"Consultation","statussejour":"en attente","medecinsejour":"ZAKI Audrey","patientsejour":2,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"GUISSO Dorgeless","matriculeassure":"115","numeropec":"451","taux":70}	COAP001
70	2020-09-22	11:35:28.796	CREATION	Facture	KOFFI Edy	Création de la facture 0006F	{"idfacture":6,"numerofacture":"0006F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"11:35","auteurfacture":"KOFFI Edy","montanttotalfacture":1000,"partassurancefacture":700,"partpatientfacture":300,"resteassurancefacture":700,"restepatientfacture":300,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0006S"}	COAP001
71	2020-09-22	11:38:04.875872	Création	Patient	KOFFI Edy	Création du patient 2020266-0025P	{"iddossier":25,"ipppatient":"2020266-0025P","nompatient":"Bakayoko","prenomspatient":"Mouan olivia","civilitepatient":"Mlle","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Abobo","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 97 456 123","qualitepersonnesurepatient":""}	COAP001
72	2020-09-22	11:38:31.527407	Création	Patient	KOFFI Edy	Création du patient 2020266-0026P	{"iddossier":26,"ipppatient":"2020266-0026P","nompatient":"Bessan","prenomspatient":"Eugène","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"POrt bouët","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 65 433 546","qualitepersonnesurepatient":""}	COAP001
73	2020-09-22	11:38:59.694987	Création	Patient	KOFFI Edy	Création du patient 2020266-0027P	{"iddossier":27,"ipppatient":"2020266-0027P","nompatient":"Bosso","prenomspatient":"Axel","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Bingerville","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 65 464 654","qualitepersonnesurepatient":""}	COAP001
74	2020-09-22	11:39:22.196137	Création	Patient	KOFFI Edy	Création du patient 2020266-0028P	{"iddossier":28,"ipppatient":"2020266-0028P","nompatient":"Deya","prenomspatient":"Jean delore","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"cocody","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 446 435","qualitepersonnesurepatient":""}	COAP001
75	2020-09-22	11:39:41.605876	Création	Patient	KOFFI Edy	Création du patient 2020266-0029P	{"iddossier":29,"ipppatient":"2020266-0029P","nompatient":"Doumbia","prenomspatient":"Al moustapha","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Abobo","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 846 469","qualitepersonnesurepatient":""}	COAP001
76	2020-09-22	11:40:06.641145	Création	Patient	KOFFI Edy	Création du patient 2020266-0030P	{"iddossier":30,"ipppatient":"2020266-0030P","nompatient":"Coulibaly","prenomspatient":"Abdoulaye","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Bouaké","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 854 364","qualitepersonnesurepatient":""}	COAP001
77	2020-09-22	11:40:52.835364	Création	Patient	KOFFI Edy	Création du patient 2020266-0031P	{"iddossier":31,"ipppatient":"2020266-0031P","nompatient":"Fofana","prenomspatient":"nafi","civilitepatient":"Mlle","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Bouaké","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 64 569 786","qualitepersonnesurepatient":""}	COAP001
78	2020-09-22	11:41:17.972177	Création	Patient	KOFFI Edy	Création du patient 2020266-0032P	{"iddossier":32,"ipppatient":"2020266-0032P","nompatient":"Kouakou","prenomspatient":"Aristide","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Abobo","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 36 467 846","qualitepersonnesurepatient":""}	COAP001
79	2020-09-22	11:41:44.90491	Création	Patient	KOFFI Edy	Création du patient 2020266-0033P	{"iddossier":33,"ipppatient":"2020266-0033P","nompatient":"Traoré","prenomspatient":"Aziz","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Koumassi","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 36 576 453","qualitepersonnesurepatient":""}	COAP001
80	2020-09-22	11:42:10.703078	Création	Patient	KOFFI Edy	Création du patient 2020266-0034P	{"iddossier":34,"ipppatient":"2020266-0034P","nompatient":"Konaté","prenomspatient":"Mohamed","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Abobo","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 436 546","qualitepersonnesurepatient":""}	COAP001
81	2020-09-22	11:42:31.665901	Création	Patient	KOFFI Edy	Création du patient 2020266-0035P	{"iddossier":35,"ipppatient":"2020266-0035P","nompatient":"Yara","prenomspatient":"Mohamed","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Abobo","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 63 546 436","qualitepersonnesurepatient":""}	COAP001
82	2020-09-22	11:44:50.031868	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0007S	{"numerosejour":"2020266-0007S","idsejour":7,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"11:35","heurefinsejour":"11:35","specialitesejour":"Mèdecine générale","typesejour":"Consultation","statussejour":"en attente","medecinsejour":"ZAKI Audrey","patientsejour":2,"etablissementsejour":1,"gestionnaire":"","organisme":"","beneficiaire":"","assureprinc":"","matriculeassure":"","numeropec":"","taux":0}	COAP001
83	2020-09-22	11:44:50.116892	CREATION	Facture	KOFFI Edy	Création de la facture 0007F	{"idfacture":7,"numerofacture":"0007F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"11:44","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":0,"partpatientfacture":500,"resteassurancefacture":0,"restepatientfacture":500,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0007S"}	COAP001
84	2020-09-22	11:51:21.60295	Création	Patient	KOFFI Edy	Création du patient 2020266-0036P	{"iddossier":36,"ipppatient":"2020266-0036P","nompatient":"kone","prenomspatient":"Adjoumani","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Koumassi","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 67 646 694","qualitepersonnesurepatient":""}	COAP001
85	2020-09-22	11:52:17.026016	Création	Patient	KOFFI Edy	Création du patient 2020266-0037P	{"iddossier":37,"ipppatient":"2020266-0037P","nompatient":"Oyewole","prenomspatient":"Moussa","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Abobo","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 35 646 846","qualitepersonnesurepatient":""}	COAP001
86	2020-09-22	11:53:09.421785	Création	Patient	KOFFI Edy	Création du patient 2020266-0038P	{"iddossier":38,"ipppatient":"2020266-0038P","nompatient":"Soro","prenomspatient":"Faragbé","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Treichville","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 63 554 649","qualitepersonnesurepatient":""}	COAP001
112	2020-09-22	14:52:17.832776	CREATION	Facture	KOFFI Edy	Création de la facture 0013F	{"idfacture":13,"numerofacture":"0013F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:52","auteurfacture":"KOFFI Edy","montanttotalfacture":400,"partassurancefacture":280,"partpatientfacture":120,"resteassurancefacture":280,"restepatientfacture":120,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0013S"}	COAP001
87	2020-09-22	11:53:34.99539	Création	Patient	KOFFI Edy	Création du patient 2020266-0039P	{"iddossier":39,"ipppatient":"2020266-0039P","nompatient":"N'dri","prenomspatient":"David","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Bouaké","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 65 469 986","qualitepersonnesurepatient":""}	COAP001
88	2020-09-22	11:54:01.562634	Création	Patient	KOFFI Edy	Création du patient 2020266-0040P	{"iddossier":40,"ipppatient":"2020266-0040P","nompatient":"Silué","prenomspatient":"Salimata","civilitepatient":"Mlle","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Korogho","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 36 464 694","qualitepersonnesurepatient":""}	COAP001
89	2020-09-22	11:54:29.659751	MODIFICATION	Patient	KOFFI Edy	Modification du patient 2020266-0038P	{"iddossier":38,"ipppatient":"2020266-0038P","nompatient":"Soro","prenomspatient":"Faragbé","civilitepatient":"Mlle","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Treichville","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 63 554 649","qualitepersonnesurepatient":""}	COAP001
90	2020-09-22	11:55:00.198685	Création	Patient	KOFFI Edy	Création du patient 2020266-0041P	{"iddossier":41,"ipppatient":"2020266-0041P","nompatient":"Yao","prenomspatient":"Bini","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Koumassi","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 68 764 635","qualitepersonnesurepatient":""}	COAP001
91	2020-09-22	11:55:25.990457	Création	Patient	KOFFI Edy	Création du patient 2020266-0042P	{"iddossier":42,"ipppatient":"2020266-0042P","nompatient":"Kouamé","prenomspatient":"Bénié","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Koumassi","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 36 576 995","qualitepersonnesurepatient":""}	COAP001
92	2020-09-22	11:55:59.872468	Création	Patient	KOFFI Edy	Création du patient 2020266-0043P	{"iddossier":43,"ipppatient":"2020266-0043P","nompatient":"Ouattara","prenomspatient":"Moctar","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Adjamé","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 66 845 464","qualitepersonnesurepatient":""}	COAP001
93	2020-09-22	11:56:32.536143	Création	Patient	KOFFI Edy	Création du patient 2020266-0044P	{"iddossier":44,"ipppatient":"2020266-0044P","nompatient":"Coulibaly","prenomspatient":"Drissa","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"yopougon","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 36 546 465","qualitepersonnesurepatient":""}	COAP001
94	2020-09-22	12:00:06.066289	Création	Patient	KOFFI Edy	Création du patient 2020266-0045P	{"iddossier":45,"ipppatient":"2020266-0045P","nompatient":"Tahou","prenomspatient":"Jédidia","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Cocody","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 65 467 894","qualitepersonnesurepatient":""}	COAP001
95	2020-09-22	12:00:38.612699	Création	Patient	KOFFI Edy	Création du patient 2020266-0046P	{"iddossier":46,"ipppatient":"2020266-0046P","nompatient":"Kouakou","prenomspatient":"Boris","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Yopougon","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 35 767 849","qualitepersonnesurepatient":""}	COAP001
111	2020-09-22	14:52:17.747461	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0013S	{"numerosejour":"2020266-0013S","idsejour":13,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:51","heurefinsejour":"02:51","specialitesejour":"Mèdecine générale","typesejour":"hospitalisation","statussejour":"en attente","medecinsejour":"GBADJE Wilfried","patientsejour":13,"etablissementsejour":1,"gestionnaire":"ALLAINZ","organisme":"ALLAINZ","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"63845","numeropec":"6","taux":70}	COAP001
96	2020-09-22	12:01:27.455473	Création	Patient	KOFFI Edy	Création du patient 2020266-0047P	{"iddossier":47,"ipppatient":"2020266-0047P","nompatient":"Bakabou","prenomspatient":"Ruth","civilitepatient":"Mlle","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Yopougon","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 64 949 465","qualitepersonnesurepatient":""}	COAP001
97	2020-09-22	12:01:56.683643	Création	Patient	KOFFI Edy	Création du patient 2020266-0048P	{"iddossier":48,"ipppatient":"2020266-0048P","nompatient":"Yéo","prenomspatient":"Éric","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Yopougon","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 36 846 498","qualitepersonnesurepatient":""}	COAP001
98	2020-09-22	12:02:13.391034	Création	Patient	KOFFI Edy	Création du patient 2020266-0049P	{"iddossier":49,"ipppatient":"2020266-0049P","nompatient":"Kra","prenomspatient":"Fabrice","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Yopougon","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 36 546 546","qualitepersonnesurepatient":""}	COAP001
99	2020-09-22	12:02:31.65012	Création	Patient	KOFFI Edy	Création du patient 2020266-0050P	{"iddossier":50,"ipppatient":"2020266-0050P","nompatient":"Traoré","prenomspatient":"Zié","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Koumassi","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 894 646","qualitepersonnesurepatient":""}	COAP001
100	2020-09-22	12:55:20.396299	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
101	2020-09-22	14:50:04.851223	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0008S	{"numerosejour":"2020266-0008S","idsejour":8,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:49","heurefinsejour":"02:49","specialitesejour":"Gynécologie","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"ALLAINZ","organisme":"ALLAINZ","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"3554","numeropec":"65","taux":50}	COAP001
102	2020-09-22	14:50:04.940236	CREATION	Facture	KOFFI Edy	Création de la facture 0008F	{"idfacture":8,"numerofacture":"0008F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:50","auteurfacture":"KOFFI Edy","montanttotalfacture":650,"partassurancefacture":325,"partpatientfacture":325,"resteassurancefacture":325,"restepatientfacture":325,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0008S"}	COAP001
103	2020-09-22	14:50:40.543949	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0009S	{"numerosejour":"2020266-0009S","idsejour":9,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:50","heurefinsejour":"02:00","specialitesejour":"Mèdecine générale","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"ALLAINZ","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"3865","numeropec":"635","taux":75}	COAP001
104	2020-09-22	14:50:40.652362	CREATION	Facture	KOFFI Edy	Création de la facture 0009F	{"idfacture":9,"numerofacture":"0009F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:50","auteurfacture":"KOFFI Edy","montanttotalfacture":1150,"partassurancefacture":862,"partpatientfacture":288,"resteassurancefacture":862,"restepatientfacture":288,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0009S"}	COAP001
105	2020-09-22	14:51:03.775669	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0010S	{"numerosejour":"2020266-0010S","idsejour":10,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:50","heurefinsejour":"02:50","specialitesejour":"Mèdecine générale","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"ALLAINZ","organisme":"ALLAINZ","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"35463","numeropec":"654","taux":80}	COAP001
106	2020-09-22	14:51:03.869429	CREATION	Facture	KOFFI Edy	Création de la facture 0010F	{"idfacture":10,"numerofacture":"0010F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:51","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":400,"partpatientfacture":100,"resteassurancefacture":400,"restepatientfacture":100,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0010S"}	COAP001
107	2020-09-22	14:51:30.766545	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0011S	{"numerosejour":"2020266-0011S","idsejour":11,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:51","heurefinsejour":"02:51","specialitesejour":"Mèdecine générale","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"ALLAINZ","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"3645","numeropec":"3684","taux":75}	COAP001
108	2020-09-22	14:51:30.91914	CREATION	Facture	KOFFI Edy	Création de la facture 0011F	{"idfacture":11,"numerofacture":"0011F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:51","auteurfacture":"KOFFI Edy","montanttotalfacture":800,"partassurancefacture":600,"partpatientfacture":200,"resteassurancefacture":600,"restepatientfacture":200,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0011S"}	COAP001
129	2020-09-22	20:23:04.678961	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
113	2020-09-22	14:53:04.109438	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0014S	{"numerosejour":"2020266-0014S","idsejour":14,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:52","heurefinsejour":"02:52","specialitesejour":"Mèdecine générale","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"GBADJE Wilfried","patientsejour":13,"etablissementsejour":1,"gestionnaire":"WILLIS TOWER","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"3654","numeropec":"368","taux":70}	COAP001
114	2020-09-22	14:53:04.183686	CREATION	Facture	KOFFI Edy	Création de la facture 0014F	{"idfacture":14,"numerofacture":"0014F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:53","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":350,"partpatientfacture":150,"resteassurancefacture":350,"restepatientfacture":150,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0014S"}	COAP001
115	2020-09-22	14:53:22.443684	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0015S	{"numerosejour":"2020266-0015S","idsejour":15,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:53","heurefinsejour":"02:53","specialitesejour":"Mèdecine générale","typesejour":"hospitalisation","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"WILLIS TOWER","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"3683","numeropec":"638","taux":60}	COAP001
116	2020-09-22	14:53:22.518419	CREATION	Facture	KOFFI Edy	Création de la facture 0015F	{"idfacture":15,"numerofacture":"0015F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:53","auteurfacture":"KOFFI Edy","montanttotalfacture":200,"partassurancefacture":120,"partpatientfacture":80,"resteassurancefacture":120,"restepatientfacture":80,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0015S"}	COAP001
117	2020-09-22	14:53:42.047226	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0016S	{"numerosejour":"2020266-0016S","idsejour":16,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:53","heurefinsejour":"02:53","specialitesejour":"Mèdecine générale","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"ALLAINZ","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"43678","numeropec":"575","taux":40}	COAP001
118	2020-09-22	14:53:42.133476	CREATION	Facture	KOFFI Edy	Création de la facture 0016F	{"idfacture":16,"numerofacture":"0016F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:53","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":200,"partpatientfacture":300,"resteassurancefacture":200,"restepatientfacture":300,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0016S"}	COAP001
119	2020-09-22	14:54:03.42862	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0017S	{"numerosejour":"2020266-0017S","idsejour":17,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:53","heurefinsejour":"02:53","specialitesejour":"Mèdecine générale","typesejour":"Biologie","statussejour":"en attente","medecinsejour":"GBADJE Wilfried","patientsejour":13,"etablissementsejour":1,"gestionnaire":"ALLAINZ","organisme":"ALLAINZ","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"2876","numeropec":"6763","taux":60}	COAP001
120	2020-09-22	14:54:03.514955	CREATION	Facture	KOFFI Edy	Création de la facture 0017F	{"idfacture":17,"numerofacture":"0017F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:54","auteurfacture":"KOFFI Edy","montanttotalfacture":200,"partassurancefacture":120,"partpatientfacture":80,"resteassurancefacture":120,"restepatientfacture":80,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0017S"}	COAP001
121	2020-09-22	14:54:40.811139	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0018S	{"numerosejour":"2020266-0018S","idsejour":18,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"02:54","heurefinsejour":"02:54","specialitesejour":"Mèdecine générale","typesejour":"Imagerie","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"6453","numeropec":"36735","taux":75}	COAP001
122	2020-09-22	14:54:40.950556	CREATION	Facture	KOFFI Edy	Création de la facture 0018F	{"idfacture":18,"numerofacture":"0018F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"02:54","auteurfacture":"KOFFI Edy","montanttotalfacture":600,"partassurancefacture":450,"partpatientfacture":150,"resteassurancefacture":450,"restepatientfacture":150,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0018S"}	COAP001
123	2020-09-22	15:13:38.285022	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
124	2020-09-22	19:31:34.48066	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
125	2020-09-22	20:12:17.04824	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0019S	{"numerosejour":"2020266-0019S","idsejour":19,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"08:11","heurefinsejour":"08:42","specialitesejour":"Mèdecine générale","typesejour":"Biologie","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"","organisme":"","beneficiaire":"","assureprinc":"","matriculeassure":"","numeropec":"","taux":0}	COAP001
126	2020-09-22	20:12:17.135859	CREATION	Facture	KOFFI Edy	Création de la facture 0019F	{"idfacture":19,"numerofacture":"0019F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"08:12","auteurfacture":"KOFFI Edy","montanttotalfacture":450,"partassurancefacture":0,"partpatientfacture":450,"resteassurancefacture":0,"restepatientfacture":450,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0019S"}	COAP001
127	2020-09-22	20:19:00.928461	CREATION	Séjour	KOFFI Edy	Création du séjour 2020266-0020S	{"numerosejour":"2020266-0020S","idsejour":20,"datedebutsejour":"22-09-2020","datefinsejour":"22-09-2020","heuredebutsejour":"08:18","heurefinsejour":"08:18","specialitesejour":"Gynécologie","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"GBADJE Wilfried","patientsejour":13,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"sx36545","numeropec":"368","taux":60}	COAP001
128	2020-09-22	20:19:01.020219	CREATION	Facture	KOFFI Edy	Création de la facture 0020F	{"idfacture":20,"numerofacture":"0020F","typefacture":"original","parentfacture":"","datefacture":"22-09-2020","heurefacture":"08:19","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":300,"partpatientfacture":200,"resteassurancefacture":300,"restepatientfacture":200,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020266-0020S"}	COAP001
131	2020-09-23	04:16:06.207953	CREATION	Séjour	KOFFI Edy	Création du séjour 2020267-0021S	{"numerosejour":"2020267-0021S","idsejour":21,"datedebutsejour":"23-09-2020","datefinsejour":"23-09-2020","heuredebutsejour":"04:15","heurefinsejour":"04:15","specialitesejour":"Gynécologie","typesejour":"Consultation","statussejour":"en attente","medecinsejour":"ZAKI Audrey","patientsejour":16,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"Aste Stephanie","matriculeassure":"46946","numeropec":"1668","taux":70}	COAP001
132	2020-09-23	04:16:06.319014	CREATION	Facture	KOFFI Edy	Création de la facture 0021F	{"idfacture":21,"numerofacture":"0021F","typefacture":"original","parentfacture":"","datefacture":"23-09-2020","heurefacture":"04:16","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":350,"partpatientfacture":150,"resteassurancefacture":350,"restepatientfacture":150,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020267-0021S"}	COAP001
133	2020-09-23	04:20:28.579242	CREATION	Séjour	KOFFI Edy	Création du séjour 2020267-0022S	{"numerosejour":"2020267-0022S","idsejour":22,"datedebutsejour":"23-09-2020","datefinsejour":"23-09-2020","heuredebutsejour":"04:16","heurefinsejour":"04:16","specialitesejour":"Mèdecine générale","typesejour":"Biologie","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":16,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"Aste Stephanie","matriculeassure":"5785","numeropec":"587587","taux":60}	COAP001
134	2020-09-23	04:20:28.685866	CREATION	Facture	KOFFI Edy	Création de la facture 0022F	{"idfacture":22,"numerofacture":"0022F","typefacture":"original","parentfacture":"","datefacture":"23-09-2020","heurefacture":"04:20","auteurfacture":"KOFFI Edy","montanttotalfacture":750,"partassurancefacture":450,"partpatientfacture":300,"resteassurancefacture":450,"restepatientfacture":300,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020267-0022S"}	COAP001
135	2020-09-23	08:41:36.346364	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
136	2020-09-23	08:52:01.819013	MODIFICATION	Patient	KOFFI Edy	Modification du patient 2020266-0016P	{"iddossier":16,"ipppatient":"2020266-0016P","nompatient":"Atse","prenomspatient":"Stephanie","civilitepatient":"Mlle","sexepatient":"F","datenaissancepatient":"22-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Cocody","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 69 843 654","qualitepersonnesurepatient":""}	COAP001
137	2020-09-23	08:54:21.660402	CREATION	Séjour	KOFFI Edy	Création du séjour 2020267-0023S	{"numerosejour":"2020267-0023S","idsejour":23,"datedebutsejour":"23-09-2020","datefinsejour":"23-09-2020","heuredebutsejour":"08:53","heurefinsejour":"08:53","specialitesejour":"Gynécologie","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":16,"etablissementsejour":1,"gestionnaire":"MCI CARE","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"Atse Stephanie","matriculeassure":"uklim63","numeropec":"638","taux":70}	COAP001
138	2020-09-23	08:54:21.827328	CREATION	Facture	KOFFI Edy	Création de la facture 0024F	{"idfacture":24,"numerofacture":"0024F","typefacture":"original","parentfacture":"","datefacture":"23-09-2020","heurefacture":"08:54","auteurfacture":"KOFFI Edy","montanttotalfacture":1300,"partassurancefacture":910,"partpatientfacture":390,"resteassurancefacture":910,"restepatientfacture":390,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020267-0023S"}	COAP001
139	2020-09-23	08:55:18.366962	CREATION	Séjour	KOFFI Edy	Création du séjour 2020267-0024S	{"numerosejour":"2020267-0024S","idsejour":24,"datedebutsejour":"23-09-2020","datefinsejour":"23-09-2020","heuredebutsejour":"08:54","heurefinsejour":"08:54","specialitesejour":"Gynécologie","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"GBADJE Wilfried","patientsejour":16,"etablissementsejour":1,"gestionnaire":"MCI CARE","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"Atse Stephanie","matriculeassure":"6987jyt","numeropec":"638j","taux":80}	COAP001
140	2020-09-23	08:55:18.452529	CREATION	Facture	KOFFI Edy	Création de la facture 0025F	{"idfacture":25,"numerofacture":"0025F","typefacture":"original","parentfacture":"","datefacture":"23-09-2020","heurefacture":"08:55","auteurfacture":"KOFFI Edy","montanttotalfacture":1150,"partassurancefacture":920,"partpatientfacture":230,"resteassurancefacture":920,"restepatientfacture":230,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020267-0024S"}	COAP001
141	2020-09-23	08:56:43.089345	CREATION	Séjour	KOFFI Edy	Création du séjour 2020267-0025S	{"numerosejour":"2020267-0025S","idsejour":25,"datedebutsejour":"23-09-2020","datefinsejour":"23-09-2020","heuredebutsejour":"08:55","heurefinsejour":"08:55","specialitesejour":"Mèdecine générale","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"ZAKI Audrey","patientsejour":16,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"Atse Stephanie","matriculeassure":"ez:k363","numeropec":"696","taux":75}	COAP001
142	2020-09-23	08:56:43.175571	CREATION	Facture	KOFFI Edy	Création de la facture 0026F	{"idfacture":26,"numerofacture":"0026F","typefacture":"original","parentfacture":"","datefacture":"23-09-2020","heurefacture":"08:56","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":375,"partpatientfacture":125,"resteassurancefacture":375,"restepatientfacture":125,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020267-0025S"}	COAP001
143	2020-09-23	09:15:28.780432	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
144	2020-09-23	09:24:26.681583	CREATION	Séjour	KOFFI Edy	Création du séjour 2020267-0026S	{"numerosejour":"2020267-0026S","idsejour":26,"datedebutsejour":"23-09-2020","datefinsejour":"Invalid date","heuredebutsejour":"09:23","heurefinsejour":"Invalid date","specialitesejour":"Mèdecine générale","typesejour":"hospitalisation","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"","organisme":"","beneficiaire":"","assureprinc":"","matriculeassure":"","numeropec":"","taux":0}	COAP001
145	2020-09-23	09:24:26.777194	CREATION	Facture	KOFFI Edy	Création de la facture 0027F	{"idfacture":27,"numerofacture":"0027F","typefacture":"original","parentfacture":"","datefacture":"23-09-2020","heurefacture":"09:24","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":0,"partpatientfacture":500,"resteassurancefacture":0,"restepatientfacture":500,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020267-0026S"}	COAP001
146	2020-09-23	09:53:54.349255	CREATION	Encaissement	KOFFI Edy	Ajout de l'encaissement 2020267-0021Re	{"id":2,"numeroencaissement":"2020267-0021Re","dateencaissement":"2020-09-23T00:00:00.000Z","heureencaissement":"09:53:54.147875","modepaiementencaissement":"Chèque","commentaireencaissement":"pour les factures du mois de aout","montantencaissement":2000000,"resteencaissement":2000000,"assuranceencaissement":"MCI CARE","recepteurencaissement":"KOFFI Edy"}	COAP001
147	2020-09-24	08:44:08.39758	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
148	2020-09-24	09:23:39.989267	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
149	2020-09-24	10:05:19.508909	CREATION	Séjour	KOFFI Edy	Création du séjour 2020268-0027S	{"numerosejour":"2020268-0027S","idsejour":27,"datedebutsejour":"24-09-2020","datefinsejour":"24-09-2020","heuredebutsejour":"10:04","heurefinsejour":"10:04","specialitesejour":"Gynécologie","typesejour":"Biologie","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":3,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"Amoya Arsene","matriculeassure":"3987jh","numeropec":"365468","taux":60}	COAP001
150	2020-09-24	10:05:19.707588	CREATION	Facture	KOFFI Edy	Création de la facture 0028F	{"idfacture":28,"numerofacture":"0028F","typefacture":"original","parentfacture":"","datefacture":"24-09-2020","heurefacture":"10:05","auteurfacture":"KOFFI Edy","montanttotalfacture":1000,"partassurancefacture":600,"partpatientfacture":400,"resteassurancefacture":600,"restepatientfacture":400,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020268-0027S"}	COAP001
151	2020-09-24	10:06:05.623249	CREATION	Séjour	KOFFI Edy	Création du séjour 2020268-0028S	{"numerosejour":"2020268-0028S","idsejour":28,"datedebutsejour":"24-09-2020","datefinsejour":"24-09-2020","heuredebutsejour":"10:05","heurefinsejour":"10:05","specialitesejour":"Pédiatrie","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":3,"etablissementsejour":1,"gestionnaire":"MCI CARE","organisme":"MCI CARE","beneficiaire":"assuré","assureprinc":"Amoya Arsene","matriculeassure":"5698l","numeropec":"58kug","taux":75}	COAP001
152	2020-09-24	10:06:05.696505	CREATION	Facture	KOFFI Edy	Création de la facture 0029F	{"idfacture":29,"numerofacture":"0029F","typefacture":"original","parentfacture":"","datefacture":"24-09-2020","heurefacture":"10:06","auteurfacture":"KOFFI Edy","montanttotalfacture":1150,"partassurancefacture":862,"partpatientfacture":288,"resteassurancefacture":862,"restepatientfacture":288,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020268-0028S"}	COAP001
153	2020-09-24	10:06:23.995732	CREATION	Séjour	KOFFI Edy	Création du séjour 2020268-0029S	{"numerosejour":"2020268-0029S","idsejour":29,"datedebutsejour":"24-09-2020","datefinsejour":"24-09-2020","heuredebutsejour":"10:06","heurefinsejour":"10:06","specialitesejour":"Pédiatrie","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"KOFFI Edy","patientsejour":3,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"Amoya Arsene","matriculeassure":"568","numeropec":"256k","taux":75}	COAP001
154	2020-09-24	10:06:24.06973	CREATION	Facture	KOFFI Edy	Création de la facture 0030F	{"idfacture":30,"numerofacture":"0030F","typefacture":"original","parentfacture":"","datefacture":"24-09-2020","heurefacture":"10:06","auteurfacture":"KOFFI Edy","montanttotalfacture":150,"partassurancefacture":112,"partpatientfacture":38,"resteassurancefacture":112,"restepatientfacture":38,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020268-0029S"}	COAP001
155	2020-09-24	10:06:45.857246	CREATION	Séjour	KOFFI Edy	Création du séjour 2020268-0030S	{"numerosejour":"2020268-0030S","idsejour":30,"datedebutsejour":"24-09-2020","datefinsejour":"24-09-2020","heuredebutsejour":"10:06","heurefinsejour":"10:06","specialitesejour":"Mèdecine générale","typesejour":"Biologie","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":3,"etablissementsejour":1,"gestionnaire":"ALLIANZ","organisme":"ALLIANZ","beneficiaire":"assuré","assureprinc":"Amoya Arsene","matriculeassure":"268k","numeropec":"59j","taux":60}	COAP001
156	2020-09-24	10:06:45.932836	CREATION	Facture	KOFFI Edy	Création de la facture 0031F	{"idfacture":31,"numerofacture":"0031F","typefacture":"original","parentfacture":"","datefacture":"24-09-2020","heurefacture":"10:06","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":300,"partpatientfacture":200,"resteassurancefacture":300,"restepatientfacture":200,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020268-0030S"}	COAP001
157	2020-09-24	10:07:53.136693	CREATION	Séjour	KOFFI Edy	Création du séjour 2020268-0031S	{"numerosejour":"2020268-0031S","idsejour":31,"datedebutsejour":"24-09-2020","datefinsejour":"24-09-2020","heuredebutsejour":"10:07","heurefinsejour":"10:07","specialitesejour":"Gynécologie","typesejour":"Consultation","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":3,"etablissementsejour":1,"gestionnaire":"WILLIS TOWER","organisme":"WILLIS TOWER","beneficiaire":"assuré","assureprinc":"Amoya Arsene","matriculeassure":"68k","numeropec":"37h","taux":75}	COAP001
158	2020-09-24	10:07:53.210752	CREATION	Facture	KOFFI Edy	Création de la facture 0032F	{"idfacture":32,"numerofacture":"0032F","typefacture":"original","parentfacture":"","datefacture":"24-09-2020","heurefacture":"10:07","auteurfacture":"KOFFI Edy","montanttotalfacture":1350,"partassurancefacture":1012,"partpatientfacture":338,"resteassurancefacture":1012,"restepatientfacture":338,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020268-0031S"}	COAP001
159	2020-09-24	10:08:29.031544	CREATION	Séjour	KOFFI Edy	Création du séjour 2020268-0032S	{"numerosejour":"2020268-0032S","idsejour":32,"datedebutsejour":"24-09-2020","datefinsejour":"24-09-2020","heuredebutsejour":"10:07","heurefinsejour":"10:07","specialitesejour":"Pédiatrie","typesejour":"Consultation","statussejour":"en attente","medecinsejour":"KOFFI Edy","patientsejour":3,"etablissementsejour":1,"gestionnaire":"Ascoma","organisme":"Ascoma","beneficiaire":"assuré","assureprinc":"Amoya Arsene","matriculeassure":"23687y","numeropec":"368j","taux":60}	COAP001
160	2020-09-24	10:08:29.105786	CREATION	Facture	KOFFI Edy	Création de la facture 0033F	{"idfacture":33,"numerofacture":"0033F","typefacture":"original","parentfacture":"","datefacture":"24-09-2020","heurefacture":"10:08","auteurfacture":"KOFFI Edy","montanttotalfacture":700,"partassurancefacture":420,"partpatientfacture":280,"resteassurancefacture":420,"restepatientfacture":280,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020268-0032S"}	COAP001
161	2020-09-24	10:55:21.074567	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
162	2020-09-24	10:55:57.886103	CREATION	Séjour	KOFFI Edy	Création du séjour 2020268-0033S	{"numerosejour":"2020268-0033S","idsejour":33,"datedebutsejour":"24-09-2020","datefinsejour":"24-09-2020","heuredebutsejour":"10:55","heurefinsejour":"10:55","specialitesejour":"Pédiatrie","typesejour":"Urgence","statussejour":"en attente","medecinsejour":"KOFFI Edy","patientsejour":13,"etablissementsejour":1,"gestionnaire":"ALLIANZ","organisme":"ALLIANZ","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"8676","numeropec":"845f","taux":60}	COAP001
163	2020-09-24	10:55:58.026518	CREATION	Facture	KOFFI Edy	Création de la facture 0034F	{"idfacture":34,"numerofacture":"0034F","typefacture":"original","parentfacture":"","datefacture":"24-09-2020","heurefacture":"10:55","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":300,"partpatientfacture":200,"resteassurancefacture":300,"restepatientfacture":200,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020268-0033S"}	COAP001
164	2020-09-24	11:23:40.329687	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
165	2020-09-24	11:24:37.936054	Création	Patient	KOFFI Edy	Création du patient 2020268-0051P	{"iddossier":51,"ipppatient":"2020268-0051P","nompatient":"Kouassi ","prenomspatient":"eric","civilitepatient":"M","sexepatient":"M","datenaissancepatient":"24-09-2020","lieunaissancepatient":"","nationalitepatient":"","professionpatient":"","situationmatrimonialepatient":"","religionpatient":"","habitationpatient":"Cocody","contactpatient":"","nomperepatient":"","prenomsperepatient":"","contactperepatient":"","nommerepatient":"","prenomsmerepatient":"","contactmerepatient":"","nomtuteurpatient":"","prenomstuteurpatient":"","contacttuteurpatient":"","nompersonnesurepatient":"","prenomspersonnesurepatient":"","contactpersonnesurepatient":"(225) 54 826 533","qualitepersonnesurepatient":""}	COAP001
166	2020-09-24	11:26:43.477514	CREATION	Séjour	KOFFI Edy	Création du séjour 2020268-0034S	{"numerosejour":"2020268-0034S","idsejour":34,"datedebutsejour":"24-09-2020","datefinsejour":"24-09-2020","heuredebutsejour":"11:24","heurefinsejour":"11:24","specialitesejour":"Pédiatrie","typesejour":"Consultation","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":51,"etablissementsejour":1,"gestionnaire":"ALLIANZ","organisme":"ALLIANZ","beneficiaire":"assuré","assureprinc":"Kouassi  eric","matriculeassure":"257655","numeropec":"8596","taux":60}	COAP001
167	2020-09-24	11:26:43.551354	CREATION	Facture	KOFFI Edy	Création de la facture 0035F	{"idfacture":35,"numerofacture":"0035F","typefacture":"original","parentfacture":"","datefacture":"24-09-2020","heurefacture":"11:26","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":300,"partpatientfacture":200,"resteassurancefacture":300,"restepatientfacture":200,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020268-0034S"}	COAP001
168	2020-09-24	11:44:02.250677	CREATION	Séjour	KOFFI Edy	Création du séjour 2020268-0035S	{"numerosejour":"2020268-0035S","idsejour":35,"datedebutsejour":"24-09-2020","datefinsejour":"24-09-2020","heuredebutsejour":"11:43","heurefinsejour":"11:43","specialitesejour":"Gynécologie","typesejour":"Consultation","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":51,"etablissementsejour":1,"gestionnaire":"","organisme":"","beneficiaire":"","assureprinc":"","matriculeassure":"","numeropec":"","taux":0}	COAP001
169	2020-09-24	11:44:02.335581	CREATION	Facture	KOFFI Edy	Création de la facture 0036F	{"idfacture":36,"numerofacture":"0036F","typefacture":"original","parentfacture":"","datefacture":"24-09-2020","heurefacture":"11:44","auteurfacture":"KOFFI Edy","montanttotalfacture":500,"partassurancefacture":0,"partpatientfacture":500,"resteassurancefacture":0,"restepatientfacture":500,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020268-0035S"}	COAP001
170	2020-09-24	13:22:13.081482	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
171	2020-09-24	14:29:10.634264	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
172	2020-09-25	02:22:59.963778	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
173	2020-09-25	02:36:28.24453	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
174	2020-09-25	03:08:59.603537	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
175	2020-09-27	11:28:41.907524	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
176	2020-09-27	11:33:18.630845	CREATION	Séjour	KOFFI Edy	Création du séjour 2020271-0036S	{"numerosejour":"2020271-0036S","idsejour":36,"datedebutsejour":"27-09-2020","datefinsejour":"27-09-2020","heuredebutsejour":"11:32","heurefinsejour":"11:32","specialitesejour":"Mèdecine générale","typesejour":"Biologie","statussejour":"en attente","medecinsejour":"N'DONGO Abdoulaye","patientsejour":13,"etablissementsejour":1,"gestionnaire":"ALLIANZ","organisme":"ALLIANZ","beneficiaire":"assuré","assureprinc":"Aka chris","matriculeassure":"69879","numeropec":"65465","taux":50}	COAP001
177	2020-09-27	11:33:18.750801	CREATION	Facture	KOFFI Edy	Création de la facture 0037F	{"idfacture":37,"numerofacture":"0037F","typefacture":"original","parentfacture":"","datefacture":"27-09-2020","heurefacture":"11:33","auteurfacture":"KOFFI Edy","montanttotalfacture":100,"partassurancefacture":50,"partpatientfacture":50,"resteassurancefacture":50,"restepatientfacture":50,"statutfacture":"attente","erreurfacture":"","commentairefacture":"","sejourfacture":"2020271-0036S"}	COAP001
178	2020-09-27	13:36:08.746109	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
179	2020-09-27	13:37:32.25603	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
180	2020-09-27	13:38:49.270234	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
181	2020-09-27	22:52:48.834029	CONNEXION	Utilisateur	KOFFI Edy	Connexion au serveur	{"login":"edy","pass":"****"}	COAP001
\.


--
-- Data for Name: profils; Type: TABLE DATA; Schema: admin; Owner: psante
--

COPY admin.profils (idprofil, labelprofil, dateprofil, codeapp, permissionsprofil) FROM stdin;
1	Admin	2020-09-20	COAP001	{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Admission","subfunctions":[{"target":"listPatient"},{"target":"dossiersPatient"}]},{"name":"Caisse","subfunctions":[{"target":"attenteFacture"},{"target":"patientFacture"},{"target":"avoirFacture"},{"target":"compte"}]},{"name":"Statistiques","subfunctions":[{"target":"bordereaux"}]},{"name":"Assurance","subfunctions":[{"target":"listeAssurances"},{"target":"facturesRecues"},{"target":"facturesValides"},{"target":"bordereaux"}]}]}
2	Admission	2020-09-20	COAP001	{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Admission","subfunctions":[{"target":"listPatient"},{"target":"dossiersPatient"}]}]}
3	Caisse	2020-09-20	COAP001	{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Caisse","subfunctions":[{"target":"attenteFacture"},{"target":"patientFacture"},{"target":"avoirFacture"},{"target":"compte"}]}]}
4	Facturation	2020-09-20	COAP001	{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Statistiques","subfunctions":[{"target":"bordereaux"}]},{"name":"Assurance","subfunctions":[{"target":"listeAssurances"},{"target":"facturesRecues"},{"target":"facturesValides"},{"target":"bordereaux"}]}]}
5	Statistique	2020-09-20	COAP001	{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Statistiques","subfunctions":[{"target":"bordereaux"}]},{"name":"Assurance","subfunctions":[{"target":"listeAssurances"},{"target":"facturesRecues"},{"target":"facturesValides"}]}]}
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: admin; Owner: psante
--

COPY admin.users (iduser, nomuser, prenomsuser, contactuser, mailuser, posteuser, serviceuser, loginuser, passuser, profiluser) FROM stdin;
1	KOFFI	Edy	51 88 64 78	edy@altea-ci.com	Agent ALTEA GAP	Assistance	edy	21232f297a57a5a743894a0e4a801fc3	Admin
2	GBADJE	Wilfried	53 26 58 95	wilfried@altea-ci.com	Agent ALTEA GAP	Assistance	wilfried	21232f297a57a5a743894a0e4a801fc3	Caisse
3	BOGUI	Audrey	48 56 25 98	audrey@altea-ci.com	Agent ALTEA GAP	Assistance	audrey	21232f297a57a5a743894a0e4a801fc3	Admission
4	N DONGO	Abdoulaye	01 54 52 56	abdoul@altea-ci.com	Agent ALTEA GAP	Assistance	abdoul	21232f297a57a5a743894a0e4a801fc3	Facturation
5	KEBE	Almamy	21 45 85 89	almamy@altea-ci.com	Agent ALTEA GAP	Assistance	almamy	21232f297a57a5a743894a0e4a801fc3	Statistique
\.


--
-- Data for Name: assurances; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.assurances (idassurance, nomassurance, codeassurance, typeassurance, faxassurance, telassurance, mailassurance, localassurance, siteassurance) FROM stdin;
2	Ascoma	75s	Gestionnaire	(225) 31 563 256	(225) 25 356 325	ascoma@gmail.com	marcory	ascoma.com
3	MCI CARE	638FSV	Gestionnaire	(225) 56 563 256	(225) 34 565 645	mci@gmail.com	abobo	mci.com
4	WILLIS TOWER	57fd	Gestionnaire	(225) 32 121 548	(225) 45 656 456	willis@gmail.com	II plateau	willis.com
1	ALLIANZ	68768	Gestionnaire	(225) 35 632 563	(225) 21 521 563	allianzgmail	II PLATEAU	allianz.com
5	Mugefci	mug38	Gestionnaire	(225) 64 654 564	(225) 38 764 645	mugefci@gmail.com	II plateau	mugefci.com
6	Ivoire Santé	ivois368	Gestionnaire	(225) 23 457 896	(225) 12 658 985	ivoire@gmail.com	Cocody	ivoire.sante.com
7	NSIA Assurance	nsij286	Gestionnaire	(225) 12 321 654	(225) 12 325 688	nsia@gmail.com	II plateau	nsia.sante.com
8	Sotra Assurance	sote53	Gestionnaire	(225) 16 548 987	(225) 12 321 549	sotraAssurance@gmail.com	Vridi	sotra.assurance.ci
\.


--
-- Data for Name: bordereau_factures; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.bordereau_factures (idbordereau_facture, numerofacture, numerobordereau) FROM stdin;
1	0010F	0001B
2	0008F	0001B
3	0004F	0002B
4	0018F	0002B
7	0014F	0004B
10	0002F	0006B
\.


--
-- Data for Name: bordereaux; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.bordereaux (idbordereau, numerobordereau, datecreationbordereau, heurecreationbordereau, datelimitebordereau, gestionnairebordereau, organismebordereau, typesejourbordereau, montanttotal, partassurance, partpatient, statutbordereau, commentairebordereau) FROM stdin;
1	0001B	2020-09-22	15:09	2020-09-28	ALLAINZ	ALLAINZ	Urgence	1150	725	425	Envoie	\N
2	0002B	2020-09-22	15:09	2020-09-28	Ascoma	Ascoma	Imagerie	1100	750	350	Envoie	\N
4	0004B	2020-09-22	16:09	2020-09-28	WILLIS TOWER	MCI CARE	Urgence	500	350	150	Envoie	\N
6	0006B	2020-09-23	09:09	2020-09-26	Tous	Tous	Tous	1350	540	810	Envoie	\N
\.


--
-- Data for Name: comptes; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.comptes (idcompte, numerocompte, montantcompte, datecompte, heurecompte, patientcompte) FROM stdin;
1	2020266-0001C	1998290	22-09-2020	03:22	2020264-0001P
2	2020266-0002C	1500000	22-09-2020	02:08	2020266-0002P
3	2020267-0003C	0	23-09-2020	03:25	2020266-0003P
4	2020267-0004C	0	23-09-2020	03:29	2020266-0004P
5	2020267-0005C	0	23-09-2020	03:34	2020266-0005P
6	2020267-0006C	0	23-09-2020	03:38	2020266-0006P
7	2020267-0007C	0	23-09-2020	03:42	2020266-0008P
8	2020267-0008C	0	23-09-2020	03:47	2020266-0007P
9	2020267-0009C	0	23-09-2020	03:51	2020266-0010P
10	2020267-0010C	0	23-09-2020	03:55	2020266-0012P
11	2020267-0011C	0	23-09-2020	03:01	2020266-0022P
12	2020267-0012C	0	23-09-2020	03:06	2020266-0009P
13	2020267-0013C	0	23-09-2020	03:13	2020266-0020P
14	2020267-0014C	0	23-09-2020	03:21	2020266-0014P
15	2020267-0015C	0	23-09-2020	03:35	2020266-0018P
17	2020267-0017C	0	23-09-2020	03:43	2020266-0015P
18	2020267-0018C	0	23-09-2020	03:48	2020266-0017P
19	2020267-0019C	0	23-09-2020	03:53	2020266-0016P
20	2020267-0020C	0	23-09-2020	03:02	2020266-0019P
21	2020267-0021C	0	23-09-2020	03:06	2020266-0011P
22	2020267-0022C	0	23-09-2020	03:23	2020266-0021P
23	2020267-0023C	0	23-09-2020	03:41	2020266-0023P
16	2020267-0016C	2000000	23-09-2020	03:39	2020266-0013P
\.


--
-- Data for Name: controles; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.controles (idcontrole, datedebutcontrole, heuredebutcontrole, datefincontrole, heurefincontrole, typecontrole, statutcontrole, sejourcontrole) FROM stdin;
\.


--
-- Data for Name: dossieradministratif; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.dossieradministratif (iddossier, ipppatient, nompatient, prenomspatient, civilitepatient, sexepatient, datenaissancepatient, lieunaissancepatient, nationalitepatient, professionpatient, situationmatrimonialepatient, religionpatient, habitationpatient, contactpatient, nomperepatient, prenomsperepatient, contactperepatient, nommerepatient, prenomsmerepatient, contactmerepatient, nomtuteurpatient, prenomstuteurpatient, contacttuteurpatient, nompersonnesurepatient, prenomspersonnesurepatient, contactpersonnesurepatient, qualitepersonnesurepatient) FROM stdin;
1	2020264-0001P	KOFFI	EDY	M	M	20-09-2020						Marcory													(225) 51 889 632	
2	2020266-0002P	GUISSO	Dorgeless	M	M	03-12-2000	COCODY	Côte d Ivoire	etudiant	Célibataire	Chrétient	Dokui Mahou	(225) 79 706 312				DADJE	Hortense	(225) 77 135 212				DADJE	Hortense	(225) 77 135 212	Mère
3	2020266-0003P	Amoya	Arsene	M	M	22-09-2020		Barbade				Cocody													(225) 63 589 632	
4	2020266-0004P	Aka	Jaures	M	M	22-09-2020		Côte d Ivoire				Agban													(225) 88 623 235	
5	2020266-0005P	Bogui	Audrey	Mme	M	22-09-2020		France				Cocody										(225) 89 658 965			(225) 12 365 489	
6	2020266-0006P	Diakité	YAsser	M	M	22-09-2020		Guinée				Treichville													(225) 32 159 853	
7	2020266-0007P	Gbadje	Wilfried	M	M	22-09-2020		Côte d Ivoire				Abobo													(225) 79 626 652	
8	2020266-0008P	N'Dongo	Abdoul	M	M	22-09-2020		Sénégal				Cocody													(225) 78 526 536	
9	2020266-0009P	Soumahoro	YAssine	M	M	22-09-2020						Marcory													(225) 98 436 354	
10	2020266-0010P	Goho	Bah Tanguy	M	M	22-09-2020		Côte d Ivoire				Abobo													(225) 87 465 436	
12	2020266-0012P	Tiemele	Eliud	M	M	22-09-2020		Côte d Ivoire				Port bouët													(225) 69 874 646	
13	2020266-0013P	Aka	chris	M	M	22-09-2020		Côte d Ivoire				Yopougon													(225) 68 436 546	
14	2020266-0014P	ZIE	Mohamed	M	M	22-09-2020						Treichville													(225) 69 854 356	
15	2020266-0015P	Silué	Désiré	M	M	22-09-2020						Korogho													(225) 98 563 546	
17	2020266-0017P	Toure	Yanan	M	M	22-09-2020		Côte d Ivoire				Yopougon													(225) 69 854 365	
11	2020266-0011P	Koua	Hermine	Mlle	F	22-09-2020		Côte d Ivoire				Treichville													(225) 78 365 456	
18	2020266-0018P	Soro	Fougnigué	M	M	22-09-2020		Côte d Ivoire				Korogho													(225) 98 743 564	
19	2020266-0019P	Cisse	Yaya	M	M	22-09-2020						Korogho													(225) 69 846 343	
20	2020266-0020P	Popouin	Yves	M	M	22-09-2020						Koumassi													(225) 69 451 645	
21	2020266-0021P	kolo	Mina	M	M	22-09-2020						Bouaké													(225) 78 943 168	
22	2020266-0022P	MOirl	Loli ediu	M	M	22-09-2020						Adjame													(225) 96 416 353	
23	2020266-0023P	Kila	Ferue	M	M	22-09-2020						Abobo													(225) 69 541 686	
24	2020266-0024P	Kouassi	Charles	M	M	22-09-2020						Koumassi													(225) 76 513 546	
25	2020266-0025P	Bakayoko	Mouan olivia	Mlle	F	22-09-2020						Abobo													(225) 97 456 123	
26	2020266-0026P	Bessan	Eugène	M	M	22-09-2020						POrt bouët													(225) 65 433 546	
27	2020266-0027P	Bosso	Axel	M	M	22-09-2020						Bingerville													(225) 65 464 654	
28	2020266-0028P	Deya	Jean delore	M	M	22-09-2020						cocody													(225) 69 446 435	
29	2020266-0029P	Doumbia	Al moustapha	M	M	22-09-2020						Abobo													(225) 69 846 469	
30	2020266-0030P	Coulibaly	Abdoulaye	M	M	22-09-2020						Bouaké													(225) 69 854 364	
31	2020266-0031P	Fofana	nafi	Mlle	F	22-09-2020						Bouaké													(225) 64 569 786	
32	2020266-0032P	Kouakou	Aristide	M	M	22-09-2020						Abobo													(225) 36 467 846	
33	2020266-0033P	Traoré	Aziz	M	M	22-09-2020						Koumassi													(225) 36 576 453	
34	2020266-0034P	Konaté	Mohamed	M	M	22-09-2020						Abobo													(225) 69 436 546	
35	2020266-0035P	Yara	Mohamed	M	M	22-09-2020						Abobo													(225) 63 546 436	
36	2020266-0036P	kone	Adjoumani	M	M	22-09-2020						Koumassi													(225) 67 646 694	
37	2020266-0037P	Oyewole	Moussa	M	M	22-09-2020						Abobo													(225) 35 646 846	
39	2020266-0039P	N'dri	David	M	M	22-09-2020						Bouaké													(225) 65 469 986	
40	2020266-0040P	Silué	Salimata	Mlle	F	22-09-2020						Korogho													(225) 36 464 694	
38	2020266-0038P	Soro	Faragbé	Mlle	F	22-09-2020						Treichville													(225) 63 554 649	
41	2020266-0041P	Yao	Bini	M	M	22-09-2020						Koumassi													(225) 68 764 635	
42	2020266-0042P	Kouamé	Bénié	M	M	22-09-2020						Koumassi													(225) 36 576 995	
43	2020266-0043P	Ouattara	Moctar	M	M	22-09-2020						Adjamé													(225) 66 845 464	
44	2020266-0044P	Coulibaly	Drissa	M	M	22-09-2020						yopougon													(225) 36 546 465	
45	2020266-0045P	Tahou	Jédidia	M	M	22-09-2020						Cocody													(225) 65 467 894	
46	2020266-0046P	Kouakou	Boris	M	M	22-09-2020						Yopougon													(225) 35 767 849	
47	2020266-0047P	Bakabou	Ruth	Mlle	F	22-09-2020						Yopougon													(225) 64 949 465	
48	2020266-0048P	Yéo	Éric	M	M	22-09-2020						Yopougon													(225) 36 846 498	
49	2020266-0049P	Kra	Fabrice	M	M	22-09-2020						Yopougon													(225) 36 546 546	
50	2020266-0050P	Traoré	Zié	M	M	22-09-2020						Koumassi													(225) 69 894 646	
16	2020266-0016P	Atse	Stephanie	Mlle	F	22-09-2020						Cocody													(225) 69 843 654	
51	2020268-0051P	Kouassi 	eric	M	M	24-09-2020						Cocody													(225) 54 826 533	
\.


--
-- Data for Name: encaissements; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.encaissements (id, numeroencaissement, dateencaissement, heureencaissement, modepaiementencaissement, commentaireencaissement, montantencaissement, resteencaissement, assuranceencaissement, recepteurencaissement) FROM stdin;
1	2020264-0001Re	2020-09-20	23:47:38.37759	Espèces	Pour les factures allianz	2000000	2000000	ALLAINZ	KOFFI Edy
2	2020267-0021Re	2020-09-23	09:53:54.147875	Chèque	pour les factures du mois de aout	2000000	1999500	MCI CARE	KOFFI Edy
\.


--
-- Data for Name: factures; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.factures (idfacture, numerofacture, typefacture, parentfacture, datefacture, heurefacture, auteurfacture, montanttotalfacture, partassurancefacture, partpatientfacture, resteassurancefacture, restepatientfacture, statutfacture, erreurfacture, commentairefacture, sejourfacture) FROM stdin;
1	0001F	original		20-09-2020	11:42	KOFFI Edy	900	0	900	0	0	attente			2020264-0001S
7	0007F	original		22-09-2020	11:44	KOFFI Edy	500	0	500	0	0	attente			2020266-0007S
15	0015F	original		22-09-2020	02:53	KOFFI Edy	200	120	80	120	0	valide			2020266-0015S
14	0014F	original		22-09-2020	02:53	KOFFI Edy	500	350	150	350	0	bordereau			2020266-0014S
34	0034F	original		24-09-2020	10:55	KOFFI Edy	500	300	200	300	200	recu			2020268-0033S
35	0035F	original		24-09-2020	11:26	KOFFI Edy	500	300	200	300	0	valide			2020268-0034S
13	0013F	original		22-09-2020	02:52	KOFFI Edy	400	280	120	280	0	valide			2020266-0013S
12	0012F	original		22-09-2020	02:51	KOFFI Edy	750	450	300	450	0	valide			2020266-0012S
19	0019F	original		22-09-2020	08:12	KOFFI Edy	450	0	450	0	450	attente			2020266-0019S
23	0023F	avoir	0022F	23-09-2020	04:20	KOFFI Edy	-200	450	300	450	300	attente		\N	2020267-0022S
20	0020F	original		22-09-2020	08:19	KOFFI Edy	500	300	200	300	200	recu			2020266-0020S
21	0021F	original		23-09-2020	04:16	KOFFI Edy	500	350	150	350	150	recu			2020267-0021S
27	0027F	original		23-09-2020	09:24	KOFFI Edy	500	0	500	0	500	attente			2020267-0026S
22	0022F	original	0023F	23-09-2020	04:20	KOFFI Edy	750	450	300	450	300	valide			2020267-0022S
2	0002F	original		20-09-2020	11:46	KOFFI Edy	1350	540	810	40	0	bordereau			2020264-0002S
24	0024F	original		23-09-2020	08:54	KOFFI Edy	1300	910	390	910	390	recu			2020267-0023S
25	0025F	original		23-09-2020	08:55	KOFFI Edy	1150	920	230	920	230	recu			2020267-0024S
26	0026F	original		23-09-2020	08:56	KOFFI Edy	500	375	125	375	125	recu			2020267-0025S
28	0028F	original		24-09-2020	10:05	KOFFI Edy	1000	600	400	600	400	recu			2020268-0027S
29	0029F	original		24-09-2020	10:06	KOFFI Edy	1150	862	288	862	288	recu			2020268-0028S
30	0030F	original		24-09-2020	10:06	KOFFI Edy	150	112	38	112	38	recu			2020268-0029S
31	0031F	original		24-09-2020	10:06	KOFFI Edy	500	300	200	300	200	recu			2020268-0030S
32	0032F	original		24-09-2020	10:07	KOFFI Edy	1350	1012	338	1012	338	recu			2020268-0031S
33	0033F	original		24-09-2020	10:08	KOFFI Edy	700	420	280	420	280	recu			2020268-0032S
17	0017F	original		22-09-2020	02:54	KOFFI Edy	200	120	80	120	0	valide			2020266-0017S
36	0036F	original		24-09-2020	11:44	KOFFI Edy	500	0	500	0	500	attente			2020268-0035S
10	0010F	original		22-09-2020	02:51	KOFFI Edy	500	400	100	400	0	bordereau			2020266-0010S
8	0008F	original		22-09-2020	02:50	KOFFI Edy	650	325	325	325	0	bordereau			2020266-0008S
5	0005F	original		22-09-2020	10:58	KOFFI Edy	7300	6570	730	6570	0	valide			2020266-0005S
6	0006F	original		22-09-2020	11:35	KOFFI Edy	1000	400	600	400	300	valide			2020266-0006S
4	0004F	original		22-09-2020	10:56	KOFFI Edy	500	300	200	300	0	bordereau			2020266-0004S
18	0018F	original		22-09-2020	02:54	KOFFI Edy	600	450	150	450	0	bordereau			2020266-0018S
37	0037F	original		27-09-2020	11:33	KOFFI Edy	100	50	50	50	50	attente			2020271-0036S
16	0016F	original		22-09-2020	02:53	KOFFI Edy	500	200	300	200	0	valide			2020266-0016S
9	0009F	original		22-09-2020	02:50	KOFFI Edy	1150	862	288	862	0	valide			2020266-0009S
3	0003F	original		22-09-2020	10:56	KOFFI Edy	500	350	150	350	0	valide			2020266-0003S
11	0011F	original		22-09-2020	02:51	KOFFI Edy	800	600	200	600	0	valide			2020266-0011S
\.


--
-- Data for Name: paiements; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.paiements (idpaiement, numeropaiement, modepaiement, montantpaiement, sourcepaiement, facturepaiement) FROM stdin;
1	2020266-0002Re	Espèces	150	Patient	0003F
2	2020266-0003Re	Compte	900	Patient	0001F
3	2020266-0004Re	Espèces	250	Patient	0007F
4	2020266-0005Re	Espèces	250	Patient	0007F
5	2020266-0006Re	Espèces	300	Patient	0006F
6	2020266-0007Re	Espèces	730	Patient	0005F
7	2020266-0008Re	Espèces	200	Patient	0004F
8	2020266-0009Re	Compte	810	Patient	0002F
9	2020266-0010Re	Espèces	325	Patient	0008F
10	2020266-0011Re	Espèces	288	Patient	0009F
11	2020266-0012Re	Espèces	100	Patient	0010F
12	2020266-0013Re	Espèces	200	Patient	0011F
13	2020266-0014Re	Espèces	300	Patient	0012F
14	2020266-0015Re	Espèces	120	Patient	0013F
15	2020266-0016Re	Espèces	150	Patient	0014F
16	2020266-0017Re	Espèces	80	Patient	0015F
17	2020266-0018Re	Espèces	300	Patient	0016F
18	2020266-0019Re	Espèces	80	Patient	0017F
19	2020266-0020Re	Espèces	150	Patient	0018F
20	2020267-0022Re	Encaissement N° 2020267-0021Re	500	Assurance	0002F
21	2020268-0023Re	Espèces	200	Patient	0035F
\.


--
-- Data for Name: recus; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.recus (idrecu, numerorecu, montantrecu, daterecu, patientrecu, facturerecu, paiementrecu, sejourrecu) FROM stdin;
1	2020266-0001R	150	2020-09-22	GUISSO Dorgeless	0003F	2020266-0002Re	2020266-0003S
2	2020266-0002R	900	2020-09-22	KOFFI EDY	0001F	2020266-0003Re	2020264-0001S
3	2020266-0003R	250	2020-09-22	GUISSO Dorgeless	0007F	2020266-0004Re	2020266-0007S
4	2020266-0004R	250	2020-09-22	GUISSO Dorgeless	0007F	2020266-0005Re	2020266-0007S
5	2020266-0005R	300	2020-09-22	GUISSO Dorgeless	0006F	2020266-0006Re	2020266-0006S
6	2020266-0006R	730	2020-09-22	GUISSO Dorgeless	0005F	2020266-0007Re	2020266-0005S
7	2020266-0007R	200	2020-09-22	GUISSO Dorgeless	0004F	2020266-0008Re	2020266-0004S
8	2020266-0008R	810	2020-09-22	KOFFI EDY	0002F	2020266-0009Re	2020264-0002S
9	2020268-0009R	200	2020-09-24	\N	0035F	2020268-0023Re	2020268-0034S
\.


--
-- Data for Name: sejour_acte; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.sejour_acte (idsejouracte, numerosejour, codeacte, prixunique, plafondassurance, quantite, prixacte) FROM stdin;
1	2020264-0001S	TJTY004	400.00	400.00	1	400.00
2	2020264-0001S	TETY001	500.00	500.00	1	500.00
3	2020264-0002S	ZAGV006	500.00	500.00	1	500.00
4	2020264-0002S	TAGV005	500.00	500.00	1	500.00
5	2020264-0002S	TEDY001	150.00	150.00	1	150.00
6	2020264-0002S	TETY002	200.00	200.00	1	200.00
7	2020266-0003S	TAGV005	500.00	500.00	1	500.00
8	2020266-0004S	TETY001	500.00	500.00	1	500.00
9	2020266-0005S	TEDY001	150.00	150.00	6	900.00
10	2020266-0005S	TETY001	500.00	500.00	5	2500.00
11	2020266-0005S	TETY005	100.00	100.00	6	600.00
12	2020266-0005S	TZTY005	100.00	100.00	6	600.00
13	2020266-0005S	TZTY003	100.00	100.00	6	600.00
14	2020266-0005S	THTY003	300.00	300.00	7	2100.00
15	2020266-0006S	MAGC001	500.00	500.00	1	500.00
16	2020266-0006S	DAGC003	500.00	500.00	1	500.00
17	2020266-0007S	MAGC001	500.00	500.00	1	500.00
18	2020266-0008S	TAGC006	500.00	500.00	1	500.00
19	2020266-0008S	TEDY001	150.00	150.00	1	150.00
20	2020266-0009S	MAGV003	500.00	500.00	1	500.00
21	2020266-0009S	MAGV002	500.00	500.00	1	500.00
22	2020266-0009S	TEDY001	150.00	150.00	1	150.00
23	2020266-0010S	MAGV003	500.00	500.00	1	500.00
24	2020266-0011S	TETY005	100.00	100.00	1	100.00
25	2020266-0011S	TZTY008	200.00	200.00	1	200.00
26	2020266-0011S	MAGC001	500.00	500.00	1	500.00
27	2020266-0012S	MAGV001	500.00	500.00	1	500.00
28	2020266-0012S	TEDY001	150.00	150.00	1	150.00
29	2020266-0012S	TETY005	100.00	100.00	1	100.00
30	2020266-0013S	THTY002	400.00	400.00	1	400.00
31	2020266-0014S	TETY001	500.00	500.00	1	500.00
32	2020266-0015S	TETY002	200.00	200.00	1	200.00
33	2020266-0016S	MAGV003	500.00	500.00	1	500.00
34	2020266-0017S	TZTY011	200.00	200.00	1	200.00
35	2020266-0018S	TETY002	200.00	200.00	1	200.00
36	2020266-0018S	TETY002	200.00	200.00	1	200.00
37	2020266-0018S	TZTY011	200.00	200.00	1	200.00
38	2020266-0019S	TEDY001	150.00	150.00	3	450.00
39	2020266-0020S	MAGV004	500.00	500.00	1	500.00
40	2020267-0021S	TAGC006	500.00	500.00	1	500.00
41	2020267-0022S	TETY003	250.00	250.00	1	250.00
42	2020267-0022S	MAGV004	500.00	500.00	1	500.00
43	2020267-0023S	TAGC006	500.00	500.00	1	500.00
44	2020267-0023S	TETY002	200.00	200.00	3	600.00
45	2020267-0023S	TETY002	200.00	200.00	1	200.00
46	2020267-0024S	TAGV005	500.00	500.00	1	500.00
47	2020267-0024S	TAGC006	500.00	500.00	1	500.00
48	2020267-0024S	TEDY001	150.00	150.00	1	150.00
49	2020267-0025S	MAGV003	500.00	500.00	1	500.00
50	2020267-0026S	MAGC001	500.00	500.00	1	500.00
51	2020268-0027S	TAGC006	500.00	500.00	1	500.00
52	2020268-0027S	TETY001	500.00	500.00	1	500.00
53	2020268-0028S	TAGC006	500.00	500.00	1	500.00
54	2020268-0028S	TEDY001	150.00	150.00	1	150.00
55	2020268-0028S	TETY001	500.00	500.00	1	500.00
56	2020268-0029S	TEDY001	150.00	150.00	1	150.00
57	2020268-0030S	TAGV005	500.00	500.00	1	500.00
58	2020268-0031S	TETY001	500.00	500.00	1	500.00
59	2020268-0031S	TEDY001	150.00	150.00	1	150.00
60	2020268-0031S	TETY002	200.00	200.00	1	200.00
61	2020268-0031S	TZTY005	100.00	100.00	1	100.00
62	2020268-0031S	THTY002	400.00	400.00	1	400.00
63	2020268-0032S	TETY001	500.00	500.00	1	500.00
64	2020268-0032S	TZTY008	200.00	200.00	1	200.00
65	2020268-0033S	MAGV002	500.00	500.00	1	500.00
66	2020268-0034S	MAGC001	500.00	500.00	1	500.00
67	2020268-0035S	MAGV001	500.00	500.00	1	500.00
68	2020271-0036S	TETY005	100.00	100.00	1	100.00
\.


--
-- Data for Name: sejours; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.sejours (idsejour, numerosejour, datedebutsejour, datefinsejour, heuredebutsejour, heurefinsejour, specialitesejour, typesejour, statussejour, medecinsejour, patientsejour, etablissementsejour, gestionnaire, organisme, beneficiaire, assureprinc, matriculeassure, numeropec, taux) FROM stdin;
1	2020264-0001S	20-09-2020	20-09-2020	11:41	11:46	Gynécologie	Consultation	en attente	N'DONGO Abdoulaye	1	1							0
2	2020264-0002S	20-09-2020	20-09-2020	11:45	11:56	Mèdecine générale	hospitalisation	en attente	N'DONGO Abdoulaye	1	1	MCI CARE	MCI CARE	assuré	KOFFI EDY	785312	325632	40
3	2020266-0003S	22-09-2020	22-09-2020	10:55	10:55	Gynécologie	Urgence	en attente	GBADJE Wilfried	2	1	ALLAINZ	MCI CARE	assuré	GUISSO Dorgeless	123	963	70
4	2020266-0004S	22-09-2020	22-09-2020	10:56	10:56	Mèdecine générale	Imagerie	en attente	ZAKI Audrey	2	1	Ascoma	Ascoma	assuré	GUISSO Dorgeless	d6	862	60
5	2020266-0005S	22-09-2020	22-09-2020	10:56	10:56	Mèdecine générale	Urgence	en attente	GBADJE Wilfried	2	1	Ascoma	Ascoma	assuré	GUISSO Dorgeless	32	963	90
7	2020266-0007S	22-09-2020	22-09-2020	11:35	11:35	Mèdecine générale	Consultation	en attente	ZAKI Audrey	2	1							0
8	2020266-0008S	22-09-2020	22-09-2020	02:49	02:49	Gynécologie	Urgence	en attente	N'DONGO Abdoulaye	13	1	ALLAINZ	ALLAINZ	assuré	Aka chris	3554	65	50
9	2020266-0009S	22-09-2020	22-09-2020	02:50	02:00	Mèdecine générale	Urgence	en attente	N'DONGO Abdoulaye	13	1	ALLAINZ	MCI CARE	assuré	Aka chris	3865	635	75
10	2020266-0010S	22-09-2020	22-09-2020	02:50	02:50	Mèdecine générale	Urgence	en attente	N'DONGO Abdoulaye	13	1	ALLAINZ	ALLAINZ	assuré	Aka chris	35463	654	80
11	2020266-0011S	22-09-2020	22-09-2020	02:51	02:51	Mèdecine générale	Urgence	en attente	N'DONGO Abdoulaye	13	1	ALLAINZ	Ascoma	assuré	Aka chris	3645	3684	75
12	2020266-0012S	22-09-2020	22-09-2020	02:51	02:51	Mèdecine générale	hospitalisation	en attente	KOFFI Edy	13	1	ALLAINZ	Ascoma	assuré	Aka chris	36463	64	60
13	2020266-0013S	22-09-2020	22-09-2020	02:51	02:51	Mèdecine générale	hospitalisation	en attente	GBADJE Wilfried	13	1	ALLAINZ	ALLAINZ	assuré	Aka chris	63845	6	70
14	2020266-0014S	22-09-2020	22-09-2020	02:52	02:52	Mèdecine générale	Urgence	en attente	GBADJE Wilfried	13	1	WILLIS TOWER	MCI CARE	assuré	Aka chris	3654	368	70
15	2020266-0015S	22-09-2020	22-09-2020	02:53	02:53	Mèdecine générale	hospitalisation	en attente	N'DONGO Abdoulaye	13	1	WILLIS TOWER	MCI CARE	assuré	Aka chris	3683	638	60
16	2020266-0016S	22-09-2020	22-09-2020	02:53	02:53	Mèdecine générale	Urgence	en attente	N'DONGO Abdoulaye	13	1	Ascoma	ALLAINZ	assuré	Aka chris	43678	575	40
17	2020266-0017S	22-09-2020	22-09-2020	02:53	02:53	Mèdecine générale	Biologie	en attente	GBADJE Wilfried	13	1	ALLAINZ	ALLAINZ	assuré	Aka chris	2876	6763	60
18	2020266-0018S	22-09-2020	22-09-2020	02:54	02:54	Mèdecine générale	Imagerie	en attente	N'DONGO Abdoulaye	13	1	Ascoma	Ascoma	assuré	Aka chris	6453	36735	75
19	2020266-0019S	22-09-2020	22-09-2020	08:11	08:42	Mèdecine générale	Biologie	en attente	N'DONGO Abdoulaye	13	1							0
20	2020266-0020S	22-09-2020	22-09-2020	08:18	08:18	Gynécologie	Urgence	en attente	GBADJE Wilfried	13	1	Ascoma	MCI CARE	assuré	Aka chris	sx36545	368	60
21	2020267-0021S	23-09-2020	23-09-2020	04:15	04:15	Gynécologie	Consultation	en attente	ZAKI Audrey	16	1	Ascoma	Ascoma	assuré	Aste Stephanie	46946	1668	70
22	2020267-0022S	23-09-2020	23-09-2020	04:16	04:16	Mèdecine générale	Biologie	en attente	N'DONGO Abdoulaye	16	1	Ascoma	MCI CARE	assuré	Aste Stephanie	5785	587587	60
23	2020267-0023S	23-09-2020	23-09-2020	08:53	08:53	Gynécologie	Urgence	en attente	N'DONGO Abdoulaye	16	1	MCI CARE	MCI CARE	assuré	Atse Stephanie	uklim63	638	70
24	2020267-0024S	23-09-2020	23-09-2020	08:54	08:54	Gynécologie	Urgence	en attente	GBADJE Wilfried	16	1	MCI CARE	MCI CARE	assuré	Atse Stephanie	6987jyt	638j	80
25	2020267-0025S	23-09-2020	23-09-2020	08:55	08:55	Mèdecine générale	Urgence	en attente	ZAKI Audrey	16	1	Ascoma	Ascoma	assuré	Atse Stephanie	ez:k363	696	75
26	2020267-0026S	23-09-2020	Invalid date	09:23	Invalid date	Mèdecine générale	hospitalisation	en attente	N'DONGO Abdoulaye	13	1							0
27	2020268-0027S	24-09-2020	24-09-2020	10:04	10:04	Gynécologie	Biologie	en attente	N'DONGO Abdoulaye	3	1	Ascoma	Ascoma	assuré	Amoya Arsene	3987jh	365468	60
28	2020268-0028S	24-09-2020	24-09-2020	10:05	10:05	Pédiatrie	Urgence	en attente	N'DONGO Abdoulaye	3	1	MCI CARE	MCI CARE	assuré	Amoya Arsene	5698l	58kug	75
29	2020268-0029S	24-09-2020	24-09-2020	10:06	10:06	Pédiatrie	Urgence	en attente	KOFFI Edy	3	1	Ascoma	Ascoma	assuré	Amoya Arsene	568	256k	75
30	2020268-0030S	24-09-2020	24-09-2020	10:06	10:06	Mèdecine générale	Biologie	en attente	N'DONGO Abdoulaye	3	1	ALLIANZ	ALLIANZ	assuré	Amoya Arsene	268k	59j	60
31	2020268-0031S	24-09-2020	24-09-2020	10:07	10:07	Gynécologie	Consultation	en attente	N'DONGO Abdoulaye	3	1	WILLIS TOWER	WILLIS TOWER	assuré	Amoya Arsene	68k	37h	75
32	2020268-0032S	24-09-2020	24-09-2020	10:07	10:07	Pédiatrie	Consultation	en attente	KOFFI Edy	3	1	Ascoma	Ascoma	assuré	Amoya Arsene	23687y	368j	60
33	2020268-0033S	24-09-2020	24-09-2020	10:55	10:55	Pédiatrie	Urgence	en attente	KOFFI Edy	13	1	ALLIANZ	ALLIANZ	assuré	Aka chris	8676	845f	60
34	2020268-0034S	24-09-2020	24-09-2020	11:24	11:24	Pédiatrie	Consultation	en attente	N'DONGO Abdoulaye	51	1	ALLIANZ	ALLIANZ	assuré	Kouassi  eric	257655	8596	60
6	2020266-0006S	22-09-2020	22-09-2020	11:34	11:34	Mèdecine générale	Consultation	en attente	ZAKI Audrey	2	1	Ascoma	Ascoma	assuré	GUISSO Dorgeless	115	451	40
35	2020268-0035S	24-09-2020	24-09-2020	11:43	11:43	Gynécologie	Consultation	en attente	N'DONGO Abdoulaye	51	1							0
36	2020271-0036S	27-09-2020	27-09-2020	11:32	11:32	Mèdecine générale	Biologie	en attente	N'DONGO Abdoulaye	13	1	ALLIANZ	ALLIANZ	assuré	Aka chris	69879	65465	50
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: gap; Owner: psante
--

COPY gap.transactions (idtransaction, datetransaction, heuretransaction, montanttransaction, modetransaction, typetransaction, comptetransaction) FROM stdin;
1	22-09-2020	03:33	2000000	Dépot	Chèque	2020266-0001C
2	22-09-2020	02:05	-900	Retrait	Paiement facture	2020266-0001C
3	22-09-2020	02:26	-810	Retrait	Paiement facture	2020266-0001C
4	22-09-2020	02:02	1500000	Dépot	Chèque	2020266-0002C
5	24-09-2020	08:22	2000000	Dépot	Chèque	2020267-0016C
\.


--
-- Data for Name: actes; Type: TABLE DATA; Schema: general; Owner: psante
--

COPY general.actes (idacte, codeacte, typeacte, libelleacte, lettrecleacte, prixlettrecleacte, regroupementacte, cotationacte) FROM stdin;
1	MAGC001	consultation	Consultation par le médecin généraliste	C	500.00		1.00
2	MAGC002	consultation	Consultation par le médecin spécialiste	CS	500.00		1.00
3	DAGC003	consultation	Consultation au cabinet du médecin dentiste	CD	500.00		1.00
4	DAGC004	consultation	Consultation au cabinet du médecin dentiste spécialiste	CDS	500.00		1.00
5	MAGC005	consultation	Consultation au cabinet du médecin psychiatre ou neurologue	CNPSY	500.00		1.00
6	TAGC006	consultation	Consultation de la sage-femme	CSF	500.00		1.00
7	MAGV001	visite	Visite à domicile du médecin généraliste	V	500.00		1.00
8	MAGV002	visite	Visite à domicile du médecin dentiste	VD	500.00		1.00
9	MAGV003	visite	Visite à domicile du médecin spécialiste	VS	500.00		1.00
10	MAGV004	visite	Visite à domicile de médecin psychiatre	VNPSY	500.00		1.00
11	TAGV005	visite	Visite à domicile de la sage-femme	VSF	500.00		1.00
12	ZAGV006	visite	Visite à domicile de nuit (de 21 h à 7h) du médecin généraliste, médecin spécialiste, chirurgien-dentiste et sage-femme	VN	500.00		1.00
13	ZAGV007	visite	Visite à domicile dimanche et jours fériés du médecin généraliste, médecin spécialiste, chirurgien-dentiste et sage-femme	VF	500.00		1.00
14	TEDY001	prélèvements et injection	Prélèvement par ponction venieuse directe	AMI	100.00	ATM	1.50
15	TETY001	prélèvements et injection	saignée	AMI	100.00	ATM	5.00
16	TEDY002	prélèvements et injection	Prélèvement aseptique cutané ou de sécrétions muqueuses, prélèvement de selles ou d'urine pour examens cytologiques, bactériologiques, mycologique, virologiques ou parasitologues	AMI	100.00	ATM	1.00
17	TETY002	prélèvements et injection	Injection intraveineuse directe isolée	AMI	100.00	ATM	2.00
18	TETY003	prélèvements et injection	Injection intraveineuse directe en série	AMI	100.00	ATM	2.50
19	TETY004	prélèvements et injection	Injection intraveineuse directe chez un enfant de moins de cinq ans	AMI	100.00	ATM	2.00
20	TETY005	prélèvements et injection	Injection intramusculaire	AMI	100.00	ATM	1.00
21	TZTY001	prélèvements et injection	Supplément pour vaccination antigrippale hors-primo injection dans le cadre de la campagne de vaccination anti-grippale organisée par l’assurance maladie	AMI	100.00	ATM	1.00
22	TZTY002	prélèvements et injection	Injection d'un sérum d'origine humaine ou animale selon la méthode de Besredka, y compris la surveillance	AMI	100.00	ATM	5.00
23	TZTY003	prélèvements et injection	Injection sous-cutanée	AMI	100.00	ATM	1.00
24	TZTY004	prélèvements et injection	Supplément pour vaccination antigrippale hors-primo injection dans le cadre de la campagne de vaccination anti-grippale organisée par l’assurance maladie	AMI	100.00	ATM	1.00
25	TZTY005	prélèvements et injection	Injection intradermique	AMI	100.00	ATM	1.00
26	TZTY006	prélèvements et injection	Injection d'un ou plusieurs allergènes, poursuivant un traitement d'hyposensibilisation spécifique, selon le protocole écrit, y compris la surveillance, la tenue du dossier de soins, la transmission des informations au médecin prescripteur	AMI	100.00	ATM	3.00
27	TZTY007	prélèvements et injection	Injection d'un implant sous cutané	AMI	100.00	ATM	2.50
28	TZTY008	prélèvements et injection	Injection en goutte à goutte par voie rectale	AMI	100.00	ATM	2.00
29	THTY001	pansements courants	Pansement de stomie	AMI	100.00	ATM	2.00
30	TGTY001	pansements courants	Pansement de trachéotomie, y compris l'aspiration et l'éventuel changement de canule ou sonde	AMI	100.00	ATM	2.50
31	TZTY009	pansements courants	Ablation de fils ou d'agrafes, dix ou moins, y compris le pansement éventuel	AMI	100.00	ATM	2.00
32	TZTY010	pansements courants	Ablation de fils ou d'agrafes, plus de dix, y compris le pansement éventuel	AMI	100.00	ATM	4.00
33	TZTY011	pansements courants	Autre pansement	AMI	100.00	ATM	2.00
34	TZTY012	pansements lourds et complexes	Pansements lourds et complexes nécessitant des conditions d'asepsie rigoureuse	AMI	100.00	ATM	4.00
35	TQTY001	pansements lourds et complexes	Pansements de brûlure étendue ou de plaie chimique ou thermique étendue, sur une surface supérieure à 5 % de la surface corporelle	AMI	100.00	ATM	4.00
36	TQTY002	pansements lourds et complexes	Pansement d'ulcère étendu ou de greffe cutanée, sur une surface supérieure à 60 cm²	AMI	100.00	ATM	4.00
37	TPTY001	pansements lourds et complexes	Pansement d'amputation nécessitant détersion, épluchage et régularisation	AMI	100.00	ATM	4.00
38	THTY002	pansements lourds et complexes	Pansement de fistule digestive	AMI	100.00	ATM	4.00
39	TPTY002	pansements lourds et complexes	Pansement pour pertes de substance traumatique ou néoplasique, avec lésions profondes, sous aponévrotiques, musculaires, tendineuses ou osseuses	AMI	100.00	ATM	4.00
40	TQTY003	pansements lourds et complexes	Pansement chirurgical nécessitant un méchage ou une irrigation	AMI	100.00	ATM	4.00
41	TQTY004	pansements lourds et complexes	Pansement d'escarre profonde et étendue atteignant les muscles ou les tendons	AMI	100.00	ATM	4.00
42	TPTY003	pansements lourds et complexes	Pansement chirurgical avec matériel d'ostéosynthèse extériorisé	AMI	100.00	ATM	4.00
43	THTY003	pose de sonde et alimentation	Pose de sonde gastrique	AMI	100.00	ATM	3.00
44	THTY004	pose de sonde et alimentation	Alimentation entérale par gavage ou en déclive ou par nutri-pompe, y compris la surveillance, par séance	AMI	100.00	ATM	3.00
45	THTY005	pose de sonde et alimentation	Alimentation entérale par voie jéjunale avec sondage de la stomie, y compris le pansement et la surveillance, par séance	AMI	100.00	ATM	4.00
46	TGTY002	soins portant sur l'appareil respiratoire	Séance d'aérosol	AMI	100.00	ATM	1.50
47	TGTY003	soins portant sur l'appareil respiratoire	Lavage d'un sinus	AMI	100.00	ATM	2.00
48	TJTY001	soins portant sur l'appareil génito-urinaire	Injection vaginale	AMI	100.00	ATM	1.50
49	TJTY002	soins portant sur l'appareil génito-urinaire	Soins gynécologiques au décours immédiat d'un traitement par curiethérapie	AMI	100.00	ATM	1.50
50	TJTY003	soins portant sur l'appareil génito-urinaire	Cathétérisme urétral chez la femme	AMI	100.00	ATM	3.00
51	TJTY004	soins portant sur l'appareil génito-urinaire	Cathétérisme urétral chez l'homme	AMI	100.00	ATM	4.00
52	TJTY005	soins portant sur l'appareil génito-urinaire	Changement de sonde urinaire à demeure chez la femme	AMI	100.00	ATM	3.00
53	TJTY006	soins portant sur l'appareil génito-urinaire	 Changement de sonde urinaire à demeure chez l'homme	AMI	100.00	ATM	4.00
54	TJTY007	soins portant sur l'appareil génito-urinaire	Éducation à l'autosondage comprenant le sondage éventuel, avec un maximum de dix séances	AMI	100.00	ATM	3.50
55	TJTY008	soins portant sur l'appareil génito-urinaire	 Réadaptation de vessie neurologique comprenant le sondage éventuel	AMI	100.00	ATM	4.50
56	TJTY010	soins portant sur l'appareil génito-urinaire	Instillation et/ou lavage vésical (sonde en place)	AMI	100.00	ATM	1.50
57	TJTY011	soins portant sur l'appareil génito-urinaire	Pose isolée d'un étui pénien, une fois par vingt-quatre heures	AMI	100.00	ATM	1.00
58	THTY006	soins portant sur l'appareil digestif	Soins de bouche avec application de produits médicamenteux au décours immédiat d'une radiothérapie	AMI	100.00	ATM	1.50
59	THTY007	soins portant sur l'appareil digestif	Lavement évacuateur ou médicamenteux	AMI	100.00	ATM	3.00
\.


--
-- Data for Name: chambre; Type: TABLE DATA; Schema: general; Owner: psante
--

COPY general.chambre  FROM stdin;
\.


--
-- Data for Name: etablissement; Type: TABLE DATA; Schema: general; Owner: psante
--

COPY general.etablissement (idetablissement, regionetabblissement, districtetablissement, nometablissement, statusetablissement, adresseetablissement, codepostaleetablissement, teletablissement, faxetablissement, emailetablissement, sitewebetablissement, logoetablissement) FROM stdin;
1	ABIDJAN 2	DS COCODY-BINGERVILLE	POLYCLINIQUE ALTEA	Centre privée de soins	Cocody angré 7ème tranche	Abidjan BP 2014	21 35 60 15	21 55 96 35	info@altea-ci.com	www.altea.com	logoAltea.jpeg
\.


--
-- Data for Name: prix_actes; Type: TABLE DATA; Schema: general; Owner: psante
--

COPY general.prix_actes (idprixactes, lettrecleacte, prixacte) FROM stdin;
1	K	250
2	Z	300
3	B	100
4	D	200
5	AMI	100
6	AMK	100
7	SFI	100
8	C	500
9	CS	500
10	CD	500
11	CDS	500
12	CNPSY	500
13	CSF	500
14	V	500
15	VD	500
16	VS	500
17	VNPSY	500
18	VSF	500
19	VN	500
20	VF	500
\.


--
-- Data for Name: unitefonctionnelle; Type: TABLE DATA; Schema: general; Owner: psante
--

COPY general.unitefonctionnelle  FROM stdin;
\.


--
-- Data for Name: unitemedicale; Type: TABLE DATA; Schema: general; Owner: psante
--

COPY general.unitemedicale  FROM stdin;
\.


--
-- Name: apps_idapp_seq; Type: SEQUENCE SET; Schema: admin; Owner: psante
--

SELECT pg_catalog.setval('admin.apps_idapp_seq', 4, true);


--
-- Name: connections_idconnection_seq; Type: SEQUENCE SET; Schema: admin; Owner: psante
--

SELECT pg_catalog.setval('admin.connections_idconnection_seq', 1, false);


--
-- Name: logs_idlogs_seq; Type: SEQUENCE SET; Schema: admin; Owner: psante
--

SELECT pg_catalog.setval('admin.logs_idlogs_seq', 181, true);


--
-- Name: profils_idprofil_seq; Type: SEQUENCE SET; Schema: admin; Owner: psante
--

SELECT pg_catalog.setval('admin.profils_idprofil_seq', 5, true);


--
-- Name: users_iduser_seq; Type: SEQUENCE SET; Schema: admin; Owner: psante
--

SELECT pg_catalog.setval('admin.users_iduser_seq', 5, true);


--
-- Name: assurances_idassurance_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.assurances_idassurance_seq', 8, true);


--
-- Name: bordereau_factures_idbordereau_facture_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.bordereau_factures_idbordereau_facture_seq', 12, true);


--
-- Name: bordereaux_idbordereau_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.bordereaux_idbordereau_seq', 7, true);


--
-- Name: comptes_idcompte_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.comptes_idcompte_seq', 23, true);


--
-- Name: controles_idcontrole_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.controles_idcontrole_seq', 1, false);


--
-- Name: dossieradministratif_iddossier_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.dossieradministratif_iddossier_seq', 51, true);


--
-- Name: encaissements_id_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.encaissements_id_seq', 2, true);


--
-- Name: factures_idfacture_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.factures_idfacture_seq', 37, true);


--
-- Name: paiements_idpaiement_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.paiements_idpaiement_seq', 21, true);


--
-- Name: recus_idrecu_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.recus_idrecu_seq', 9, true);


--
-- Name: sejour_acte_idsejouracte_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.sejour_acte_idsejouracte_seq', 68, true);


--
-- Name: sejours_idsejour_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.sejours_idsejour_seq', 36, true);


--
-- Name: transactions_idtransaction_seq; Type: SEQUENCE SET; Schema: gap; Owner: psante
--

SELECT pg_catalog.setval('gap.transactions_idtransaction_seq', 5, true);


--
-- Name: actes_idacte_seq; Type: SEQUENCE SET; Schema: general; Owner: psante
--

SELECT pg_catalog.setval('general.actes_idacte_seq', 59, true);


--
-- Name: etablissement_idetablissement_seq; Type: SEQUENCE SET; Schema: general; Owner: psante
--

SELECT pg_catalog.setval('general.etablissement_idetablissement_seq', 1, true);


--
-- Name: prix_actes_idprixactes_seq; Type: SEQUENCE SET; Schema: general; Owner: psante
--

SELECT pg_catalog.setval('general.prix_actes_idprixactes_seq', 20, true);


--
-- Name: ipp_sequence; Type: SEQUENCE SET; Schema: public; Owner: psante
--

SELECT pg_catalog.setval('public.ipp_sequence', 51, true);


--
-- Name: numerobordereau_sequence; Type: SEQUENCE SET; Schema: public; Owner: psante
--

SELECT pg_catalog.setval('public.numerobordereau_sequence', 7, true);


--
-- Name: numerocompte_sequence; Type: SEQUENCE SET; Schema: public; Owner: psante
--

SELECT pg_catalog.setval('public.numerocompte_sequence', 23, true);


--
-- Name: numerofacture_sequence; Type: SEQUENCE SET; Schema: public; Owner: psante
--

SELECT pg_catalog.setval('public.numerofacture_sequence', 37, true);


--
-- Name: numeropaiement_sequence; Type: SEQUENCE SET; Schema: public; Owner: psante
--

SELECT pg_catalog.setval('public.numeropaiement_sequence', 23, true);


--
-- Name: numerorecu_sequence; Type: SEQUENCE SET; Schema: public; Owner: psante
--

SELECT pg_catalog.setval('public.numerorecu_sequence', 9, true);


--
-- Name: numerosejour_sequence; Type: SEQUENCE SET; Schema: public; Owner: psante
--

SELECT pg_catalog.setval('public.numerosejour_sequence', 36, true);


--
-- Name: apps apps_codeapp_key; Type: CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.apps
    ADD CONSTRAINT apps_codeapp_key UNIQUE (codeapp);


--
-- Name: apps apps_nomapp_key; Type: CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.apps
    ADD CONSTRAINT apps_nomapp_key UNIQUE (nomapp);


--
-- Name: apps apps_pkey; Type: CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (idapp);


--
-- Name: connections connections_pkey; Type: CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.connections
    ADD CONSTRAINT connections_pkey PRIMARY KEY (idconnection);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (idlogs);


--
-- Name: profils profils_labelprofil_key; Type: CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.profils
    ADD CONSTRAINT profils_labelprofil_key UNIQUE (labelprofil);


--
-- Name: profils profils_pkey; Type: CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.profils
    ADD CONSTRAINT profils_pkey PRIMARY KEY (idprofil);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (iduser);


--
-- Name: assurances assurances_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.assurances
    ADD CONSTRAINT assurances_pkey PRIMARY KEY (idassurance);


--
-- Name: bordereau_factures bordereau_factures_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.bordereau_factures
    ADD CONSTRAINT bordereau_factures_pkey PRIMARY KEY (idbordereau_facture);


--
-- Name: bordereaux bordereaux_numerobordereau_key; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.bordereaux
    ADD CONSTRAINT bordereaux_numerobordereau_key UNIQUE (numerobordereau);


--
-- Name: bordereaux bordereaux_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.bordereaux
    ADD CONSTRAINT bordereaux_pkey PRIMARY KEY (idbordereau);


--
-- Name: comptes comptes_numerocompte_key; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.comptes
    ADD CONSTRAINT comptes_numerocompte_key UNIQUE (numerocompte);


--
-- Name: comptes comptes_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.comptes
    ADD CONSTRAINT comptes_pkey PRIMARY KEY (idcompte);


--
-- Name: controles controles_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.controles
    ADD CONSTRAINT controles_pkey PRIMARY KEY (idcontrole);


--
-- Name: dossieradministratif dossieradministratif_ipppatient_key; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.dossieradministratif
    ADD CONSTRAINT dossieradministratif_ipppatient_key UNIQUE (ipppatient);


--
-- Name: dossieradministratif dossieradministratif_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.dossieradministratif
    ADD CONSTRAINT dossieradministratif_pkey PRIMARY KEY (iddossier);


--
-- Name: encaissements encaissements_numeroencaissement_key; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.encaissements
    ADD CONSTRAINT encaissements_numeroencaissement_key UNIQUE (numeroencaissement);


--
-- Name: encaissements encaissements_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.encaissements
    ADD CONSTRAINT encaissements_pkey PRIMARY KEY (id);


--
-- Name: factures factures_numerofacture_key; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.factures
    ADD CONSTRAINT factures_numerofacture_key UNIQUE (numerofacture);


--
-- Name: factures factures_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.factures
    ADD CONSTRAINT factures_pkey PRIMARY KEY (idfacture);


--
-- Name: paiements paiements_numeropaiement_key; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.paiements
    ADD CONSTRAINT paiements_numeropaiement_key UNIQUE (numeropaiement);


--
-- Name: paiements paiements_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.paiements
    ADD CONSTRAINT paiements_pkey PRIMARY KEY (idpaiement);


--
-- Name: recus recus_numerorecu_key; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.recus
    ADD CONSTRAINT recus_numerorecu_key UNIQUE (numerorecu);


--
-- Name: recus recus_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.recus
    ADD CONSTRAINT recus_pkey PRIMARY KEY (idrecu);


--
-- Name: sejour_acte sejour_acte_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.sejour_acte
    ADD CONSTRAINT sejour_acte_pkey PRIMARY KEY (idsejouracte);


--
-- Name: sejours sejours_numerosejour_key; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.sejours
    ADD CONSTRAINT sejours_numerosejour_key UNIQUE (numerosejour);


--
-- Name: sejours sejours_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.sejours
    ADD CONSTRAINT sejours_pkey PRIMARY KEY (idsejour);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (idtransaction);


--
-- Name: actes actes_codeacte_key; Type: CONSTRAINT; Schema: general; Owner: psante
--

ALTER TABLE ONLY general.actes
    ADD CONSTRAINT actes_codeacte_key UNIQUE (codeacte);


--
-- Name: actes actes_pkey; Type: CONSTRAINT; Schema: general; Owner: psante
--

ALTER TABLE ONLY general.actes
    ADD CONSTRAINT actes_pkey PRIMARY KEY (idacte);


--
-- Name: etablissement etablissement_pkey; Type: CONSTRAINT; Schema: general; Owner: psante
--

ALTER TABLE ONLY general.etablissement
    ADD CONSTRAINT etablissement_pkey PRIMARY KEY (idetablissement);


--
-- Name: prix_actes prix_actes_lettrecleacte_key; Type: CONSTRAINT; Schema: general; Owner: psante
--

ALTER TABLE ONLY general.prix_actes
    ADD CONSTRAINT prix_actes_lettrecleacte_key UNIQUE (lettrecleacte);


--
-- Name: prix_actes prix_actes_pkey; Type: CONSTRAINT; Schema: general; Owner: psante
--

ALTER TABLE ONLY general.prix_actes
    ADD CONSTRAINT prix_actes_pkey PRIMARY KEY (idprixactes);


--
-- Name: connections connections_userconnection_fkey; Type: FK CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.connections
    ADD CONSTRAINT connections_userconnection_fkey FOREIGN KEY (userconnection) REFERENCES admin.users(iduser);


--
-- Name: logs logs_app_fkey; Type: FK CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.logs
    ADD CONSTRAINT logs_app_fkey FOREIGN KEY (app) REFERENCES admin.apps(codeapp);


--
-- Name: profils profils_codeapp_fkey; Type: FK CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.profils
    ADD CONSTRAINT profils_codeapp_fkey FOREIGN KEY (codeapp) REFERENCES admin.apps(codeapp);


--
-- Name: users users_profiluser_fkey; Type: FK CONSTRAINT; Schema: admin; Owner: psante
--

ALTER TABLE ONLY admin.users
    ADD CONSTRAINT users_profiluser_fkey FOREIGN KEY (profiluser) REFERENCES admin.profils(labelprofil);


--
-- Name: bordereau_factures bordereau_factures_numerobordereau_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.bordereau_factures
    ADD CONSTRAINT bordereau_factures_numerobordereau_fkey FOREIGN KEY (numerobordereau) REFERENCES gap.bordereaux(numerobordereau) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bordereau_factures bordereau_factures_numerofacture_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.bordereau_factures
    ADD CONSTRAINT bordereau_factures_numerofacture_fkey FOREIGN KEY (numerofacture) REFERENCES gap.factures(numerofacture) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comptes comptes_patientcompte_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.comptes
    ADD CONSTRAINT comptes_patientcompte_fkey FOREIGN KEY (patientcompte) REFERENCES gap.dossieradministratif(ipppatient) ON DELETE CASCADE;


--
-- Name: controles controles_sejourcontrole_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.controles
    ADD CONSTRAINT controles_sejourcontrole_fkey FOREIGN KEY (sejourcontrole) REFERENCES gap.sejours(numerosejour) ON DELETE CASCADE;


--
-- Name: factures factures_sejourfacture_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.factures
    ADD CONSTRAINT factures_sejourfacture_fkey FOREIGN KEY (sejourfacture) REFERENCES gap.sejours(numerosejour) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: paiements paiements_facturepaiement_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.paiements
    ADD CONSTRAINT paiements_facturepaiement_fkey FOREIGN KEY (facturepaiement) REFERENCES gap.factures(numerofacture) ON DELETE CASCADE;


--
-- Name: recus recus_facturerecu_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.recus
    ADD CONSTRAINT recus_facturerecu_fkey FOREIGN KEY (facturerecu) REFERENCES gap.factures(numerofacture) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recus recus_paiementrecu_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.recus
    ADD CONSTRAINT recus_paiementrecu_fkey FOREIGN KEY (paiementrecu) REFERENCES gap.paiements(numeropaiement) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recus recus_sejourrecu_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.recus
    ADD CONSTRAINT recus_sejourrecu_fkey FOREIGN KEY (sejourrecu) REFERENCES gap.sejours(numerosejour) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sejour_acte sejour_acte_codeacte_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.sejour_acte
    ADD CONSTRAINT sejour_acte_codeacte_fkey FOREIGN KEY (codeacte) REFERENCES general.actes(codeacte) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sejour_acte sejour_acte_numerosejour_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.sejour_acte
    ADD CONSTRAINT sejour_acte_numerosejour_fkey FOREIGN KEY (numerosejour) REFERENCES gap.sejours(numerosejour) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sejours sejours_etablissementsejour_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.sejours
    ADD CONSTRAINT sejours_etablissementsejour_fkey FOREIGN KEY (etablissementsejour) REFERENCES general.etablissement(idetablissement) ON DELETE RESTRICT;


--
-- Name: sejours sejours_patientsejour_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.sejours
    ADD CONSTRAINT sejours_patientsejour_fkey FOREIGN KEY (patientsejour) REFERENCES gap.dossieradministratif(iddossier) ON DELETE CASCADE;


--
-- Name: transactions transactions_comptetransaction_fkey; Type: FK CONSTRAINT; Schema: gap; Owner: psante
--

ALTER TABLE ONLY gap.transactions
    ADD CONSTRAINT transactions_comptetransaction_fkey FOREIGN KEY (comptetransaction) REFERENCES gap.comptes(numerocompte) ON DELETE CASCADE;


--
-- Name: actes actes_lettrecleacte_fkey; Type: FK CONSTRAINT; Schema: general; Owner: psante
--

ALTER TABLE ONLY general.actes
    ADD CONSTRAINT actes_lettrecleacte_fkey FOREIGN KEY (lettrecleacte) REFERENCES general.prix_actes(lettrecleacte) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

