BEGIN;

/* --------------------------------------------------------
Structure of table "pdtypes"
-------------------------------------------------------- */

DROP TABLE IF EXISTS pdtypes CASCADE;
CREATE TABLE pdtypes (
    id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    description varchar(254) DEFAULT NULL,
    defaultflag boolean DEFAULT NULL
);

/* --------------------------------------------------------
Structure of table "pdcategories"
-------------------------------------------------------- */

DROP TABLE IF EXISTS pdcategories CASCADE;
CREATE TABLE pdcategories (
    id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    description varchar(254) DEFAULT NULL
);

/* --------------------------------------------------------
Structure of table "pds"
-------------------------------------------------------- */

DROP TABLE IF EXISTS pds CASCADE;
CREATE TABLE pds (
    id serial PRIMARY KEY,
    fullnumber varchar(50) NOT NULL,
    cdate integer NOT NULL,
    sdate integer NOT NULL,
    deadline integer DEFAULT NULL,
    paydate integer DEFAULT NULL,
    paytype smallint NOT NULL,
    supplierid integer NOT NULL
        CONSTRAINT pds_supplierid_fkey REFERENCES customers (id) ON DELETE SET NULL ON UPDATE CASCADE,
    iban varchar(26) DEFAULT NULL,
    typeid integer DEFAULT NULL
        CONSTRAINT pds_typeid_fkey REFERENCES pdtypes (id) ON DELETE SET NULL ON UPDATE CASCADE,
    userid integer DEFAULT NULL
        CONSTRAINT pds_userid_fkey REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT pds_supplierid_ukey UNIQUE (fullnumber, supplierid)
);

/* --------------------------------------------------------
Structure of table "pdcontents"
-------------------------------------------------------- */

DROP TABLE IF EXISTS pdcontents CASCADE;
CREATE TABLE pdcontents (
    id serial PRIMARY KEY,
    pdid integer NOT NULL
        CONSTRAINT pdcontents_pdid_fkey REFERENCES pds (id) ON DELETE CASCADE ON UPDATE CASCADE,
    netvalue numeric(9,2) NOT NULL,
    taxid integer NOT NULL
        CONSTRAINT pds_taxid_fkey REFERENCES taxes (id) ON DELETE SET NULL ON UPDATE CASCADE,
    description varchar(254) DEFAULT NULL
);

/* --------------------------------------------------------
Structure of table "pdcontentcat"
-------------------------------------------------------- */

DROP TABLE IF EXISTS pdcontentcat CASCADE;
CREATE TABLE pdcontentcat (
    id serial PRIMARY KEY,
    contentid integer NOT NULL
        CONSTRAINT pdcontentcat_contentid_fkey REFERENCES pdcontents (id) ON DELETE CASCADE ON UPDATE CASCADE,
    categoryid integer DEFAULT NULL
        CONSTRAINT pdcontentcat_categoryid_fkey REFERENCES pdcategories (id) ON DELETE SET NULL ON UPDATE CASCADE
);

/* --------------------------------------------------------
Structure of table "pdcontentinvprojects"
-------------------------------------------------------- */

DROP TABLE IF EXISTS pdcontentinvprojects CASCADE;
CREATE TABLE pdcontentinvprojects (
    id serial PRIMARY KEY,
    contentid integer NOT NULL,
    invprojectid integer NOT NULL
        CONSTRAINT pdcontentinvprojects_invprojectid_fkey REFERENCES invprojects (id) ON DELETE CASCADE ON UPDATE CASCADE
);

/* --------------------------------------------------------
Structure of table "pdattachments"
-------------------------------------------------------- */

DROP TABLE IF EXISTS pdattachments CASCADE;
CREATE TABLE pdattachments (
    id serial PRIMARY KEY,
    pdid integer NOT NULL
        CONSTRAINT pdattachments_pdid_fkey REFERENCES pds (id) ON DELETE CASCADE ON UPDATE CASCADE,
    filename varchar(255) DEFAULT '' NOT NULL,
    contenttype varchar(255) DEFAULT '' NOT NULL
);

INSERT INTO pdtypes (id, name, description, defaultflag) VALUES (1, 'faktura VAT', NULL, true);
INSERT INTO pdtypes (id, name, description, defaultflag) VALUES (2, 'faktura VAT-marża', NULL, false);
INSERT INTO pdtypes (id, name, description, defaultflag) VALUES (3, 'korekta', NULL, false);
INSERT INTO pdtypes (id, name, description, defaultflag) VALUES (4, 'rachunek', NULL, false);
INSERT INTO pdtypes (id, name, description, defaultflag) VALUES (5, 'decyzja płatnicza', NULL, false);
INSERT INTO pdtypes (id, name, description, defaultflag) VALUES (6, 'opłata za rachunek bankowy', NULL, false);
INSERT INTO pdtypes (id, name, description, defaultflag) VALUES (7, 'proforma', NULL, false);
INSERT INTO pdtypes (id, name, description, defaultflag) VALUES (8, 'nota księgowa', NULL, false);

INSERT INTO uiconfig (section, var, value, description, disabled) VALUES ('pd', 'filter_default_period', '6', 'Domyślny filtr okresu wartości: -1, 1-6', 0) ON CONFLICT (section, var, userid, divisionid) DO NOTHING;
INSERT INTO uiconfig (section, var, value, description, disabled) VALUES ('pd', 'storage_dir', 'storage/pd', 'Katalog ze skanami dokumentów kosztowych', 0) ON CONFLICT (section, var, userid, divisionid) DO NOTHING;
INSERT INTO uiconfig (section, var, value, description, disabled) VALUES ('pd', 'default_taxid', '3', 'ID domyślnej stawki podatku', 1) ON CONFLICT (section, var, userid, divisionid) DO NOTHING;

INSERT INTO dbinfo (keytype, keyvalue) VALUES ('dbversion_LMSPurchasesPlugin', '2021112700') ON CONFLICT (keytype) DO UPDATE SET keyvalue='2021112700';

COMMIT;