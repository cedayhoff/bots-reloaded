CREATE DATABASE botsdb;

\c botsdb;

BEGIN;

CREATE TABLE IF NOT EXISTS auth_user (
    id SERIAL PRIMARY KEY NOT NULL,
    password VARCHAR(128) NOT NULL,
    last_login TIMESTAMP,
    is_superuser BOOLEAN NOT NULL,
    username VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(75) NOT NULL,
    is_staff BOOLEAN NOT NULL,
    is_active BOOLEAN NOT NULL,
    date_joined TIMESTAMP NOT NULL
);


CREATE TABLE IF NOT EXISTS auth_permission (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(50) NOT NULL,
    content_type_id INTEGER NOT NULL,
    codename VARCHAR(100) NOT NULL,
    UNIQUE(content_type_id, codename)
);

CREATE TABLE IF NOT EXISTS auth_group_permissions (
    id SERIAL PRIMARY KEY NOT NULL,
    group_id INTEGER NOT NULL,
    permission_id INTEGER NOT NULL,
    FOREIGN KEY(permission_id) REFERENCES auth_permission(id),
    UNIQUE(group_id, permission_id)
);

CREATE TABLE IF NOT EXISTS auth_group (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS auth_user_groups (
    id SERIAL PRIMARY KEY NOT NULL,
    user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    FOREIGN KEY(group_id) REFERENCES auth_group(id),
    UNIQUE(user_id, group_id)
);

CREATE TABLE IF NOT EXISTS auth_user_user_permissions (
    id SERIAL PRIMARY KEY NOT NULL,
    user_id INTEGER NOT NULL,
    permission_id INTEGER NOT NULL,
    FOREIGN KEY (permission_id) REFERENCES auth_permission(id),
    UNIQUE (user_id, permission_id)
);

CREATE TABLE IF NOT EXISTS django_content_type (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    app_label VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    UNIQUE (app_label, model)
);

CREATE TABLE IF NOT EXISTS django_session (
    session_key VARCHAR(40) NOT NULL,
    session_data TEXT NOT NULL,
    expire_date TIMESTAMP NOT NULL,
    PRIMARY KEY (session_key)
);

CREATE TABLE IF NOT EXISTS django_admin_log (
    id SERIAL PRIMARY KEY NOT NULL,
    action_time TIMESTAMP NOT NULL,
    user_id INTEGER NOT NULL,
    content_type_id INTEGER,
    object_id TEXT,
    object_repr VARCHAR(200) NOT NULL,
    action_flag INTEGER NOT NULL,
    change_message TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES auth_user(id),
    FOREIGN KEY (content_type_id) REFERENCES django_content_type(id)
);

CREATE TABLE IF NOT EXISTS confirmrule (
    id SERIAL PRIMARY KEY NOT NULL,
    active BOOLEAN NOT NULL,
    confirmtype VARCHAR(35) NOT NULL,
    ruletype VARCHAR(35) NOT NULL,
    negativerule BOOLEAN NOT NULL,
    frompartner_id VARCHAR(35),
    topartner_id VARCHAR(35),
    idroute VARCHAR(35),
    idchannel_id VARCHAR(35),
    editype VARCHAR(35) NOT NULL,
    messagetype VARCHAR(35) NOT NULL,
    rsrv1 VARCHAR(35),
    rsrv2 INTEGER
);

CREATE TABLE IF NOT EXISTS ccodetrigger (
    ccodeid VARCHAR(35) NOT NULL,
    ccodeid_desc TEXT,
    PRIMARY KEY (ccodeid)
);

CREATE TABLE IF NOT EXISTS ccode (
    id SERIAL PRIMARY KEY NOT NULL,
    ccodeid_id VARCHAR(35) NOT NULL,
    leftcode VARCHAR(35) NOT NULL,
    rightcode VARCHAR(70) NOT NULL,
    attr1 VARCHAR(70) NOT NULL,
    attr2 VARCHAR(35) NOT NULL,
    attr3 VARCHAR(35) NOT NULL,
    attr4 VARCHAR(35) NOT NULL,
    attr5 VARCHAR(35) NOT NULL,
    attr6 VARCHAR(35) NOT NULL,
    attr7 VARCHAR(35) NOT NULL,
    attr8 VARCHAR(35) NOT NULL,
    FOREIGN KEY (ccodeid_id) REFERENCES ccodetrigger(ccodeid),
    UNIQUE (ccodeid_id, leftcode, rightcode)
);

CREATE TABLE IF NOT EXISTS channel (
    idchannel VARCHAR(35) NOT NULL,
    inorout VARCHAR(35) NOT NULL,
    type VARCHAR(35) NOT NULL,
    charset VARCHAR(35) NOT NULL,
    host VARCHAR(256) NOT NULL,
    port INTEGER,
    username VARCHAR(35) NOT NULL,
    secret VARCHAR(35) NOT NULL,
    starttls BOOLEAN NOT NULL,
    apop BOOLEAN NOT NULL,
    remove BOOLEAN NOT NULL,
    path VARCHAR(256) NOT NULL,
    filename VARCHAR(256) NOT NULL,
    lockname VARCHAR(35) NOT NULL,
    syslock BOOLEAN NOT NULL,
    parameters VARCHAR(70) NOT NULL,
    ftpaccount VARCHAR(35) NOT NULL,
    ftpactive BOOLEAN NOT NULL,
    ftpbinary BOOLEAN NOT NULL,
    askmdn VARCHAR(17) NOT NULL,
    sendmdn VARCHAR(17) NOT NULL,
    mdnchannel VARCHAR(35) NOT NULL,
    archivepath VARCHAR(256) NOT NULL,
    "desc" TEXT,
    rsrv1 VARCHAR(35),
    rsrv2 INTEGER,
    rsrv3 INTEGER,
    keyfile VARCHAR(256),
    certfile VARCHAR(256),
    testpath VARCHAR(256) NOT NULL,
    PRIMARY KEY (idchannel)
);

CREATE TABLE IF NOT EXISTS partnergroup (
    id SERIAL PRIMARY KEY NOT NULL,
    from_partner_id VARCHAR(35) NOT NULL,
    to_partner_id VARCHAR(35) NOT NULL,
    UNIQUE (from_partner_id, to_partner_id)
);

CREATE TABLE IF NOT EXISTS partner (
    idpartner VARCHAR(35) PRIMARY KEY NOT NULL,
    active BOOLEAN NOT NULL,
    isgroup BOOLEAN NOT NULL,
    name VARCHAR(256) NOT NULL,
    mail VARCHAR(256) NOT NULL,
    cc VARCHAR(256) NOT NULL,
    rsrv1 VARCHAR(35),
    rsrv2 INTEGER,
    name1 VARCHAR(70),
    name2 VARCHAR(70),
    name3 VARCHAR(70),
    address1 VARCHAR(70),
    address2 VARCHAR(70),
    address3 VARCHAR(70),
    city VARCHAR(35),
    postalcode VARCHAR(17),
    countrysubdivision VARCHAR(9),
    countrycode VARCHAR(3),
    phone1 VARCHAR(17),
    phone2 VARCHAR(17),
    startdate DATE,
    enddate DATE,
    "desc" TEXT,
    attr1 VARCHAR(35),
    attr2 VARCHAR(35),
    attr3 VARCHAR(35),
    attr4 VARCHAR(35),
    attr5 VARCHAR(35)
);

CREATE TABLE IF NOT EXISTS chanpar (
    id SERIAL PRIMARY KEY NOT NULL,
    idpartner_id VARCHAR(35) NOT NULL,
    idchannel_id VARCHAR(35) NOT NULL,
    mail VARCHAR(256) NOT NULL,
    cc VARCHAR(256) NOT NULL,
    askmdn BOOLEAN NOT NULL,
    sendmdn BOOLEAN NOT NULL,
    FOREIGN KEY (idchannel_id) REFERENCES channel(idchannel),
    FOREIGN KEY (idpartner_id) REFERENCES partner(idpartner),
    UNIQUE (idpartner_id, idchannel_id)
);

CREATE TABLE IF NOT EXISTS translate (
    id SERIAL PRIMARY KEY NOT NULL,
    active BOOLEAN NOT NULL,
    fromeditype VARCHAR(35) NOT NULL,
    frommessagetype VARCHAR(35) NOT NULL,
    alt VARCHAR(35) NOT NULL,
    frompartner_id VARCHAR(35),
    topartner_id VARCHAR(35),
    tscript VARCHAR(35) NOT NULL,
    toeditype VARCHAR(35) NOT NULL,
    tomessagetype VARCHAR(35) NOT NULL,
    "desc" TEXT,
    rsrv1 VARCHAR(35),
    rsrv2 INTEGER,
    FOREIGN KEY (frompartner_id) REFERENCES partner(idpartner),
    FOREIGN KEY (topartner_id) REFERENCES partner(idpartner)
);

CREATE TABLE IF NOT EXISTS routes (
    id SERIAL PRIMARY KEY NOT NULL,
    idroute VARCHAR(35) NOT NULL,
    seq INTEGER NOT NULL,
    active BOOLEAN NOT NULL,
    fromchannel_id VARCHAR(35),
    fromeditype VARCHAR(35) NOT NULL,
    frommessagetype VARCHAR(35) NOT NULL,
    tochannel_id VARCHAR(35),
    toeditype VARCHAR(35) NOT NULL,
    tomessagetype VARCHAR(35) NOT NULL,
    alt VARCHAR(35) NOT NULL,
    frompartner_id VARCHAR(35),
    topartner_id VARCHAR(35),
    frompartner_tochannel_id VARCHAR(35),
    topartner_tochannel_id VARCHAR(35),
    testindicator VARCHAR(1) NOT NULL,
    translateind INTEGER NOT NULL,
    notindefaultrun BOOLEAN NOT NULL,
    "desc" TEXT,
    rsrv1 VARCHAR(35),
    rsrv2 INTEGER,
    defer BOOLEAN NOT NULL,
    zip_incoming INTEGER,
    zip_outgoing INTEGER,
    FOREIGN KEY (frompartner_id) REFERENCES partner(idpartner),
    FOREIGN KEY (fromchannel_id) REFERENCES channel(idchannel),
    FOREIGN KEY (topartner_id) REFERENCES partner(idpartner),
    FOREIGN KEY (frompartner_tochannel_id) REFERENCES partner(idpartner),
    FOREIGN KEY (topartner_tochannel_id) REFERENCES partner(idpartner),
    FOREIGN KEY (tochannel_id) REFERENCES channel(idchannel),
    UNIQUE (idroute, seq)
);

CREATE TABLE IF NOT EXISTS filereport (
    idta SERIAL PRIMARY KEY NOT NULL,
    reportidta INTEGER NOT NULL,
    statust INTEGER NOT NULL,
    retransmit INTEGER NOT NULL,
    idroute VARCHAR(35) NOT NULL,
    fromchannel VARCHAR(35) NOT NULL,
    tochannel VARCHAR(35) NOT NULL,
    frompartner VARCHAR(35) NOT NULL,
    topartner VARCHAR(35) NOT NULL,
    frommail VARCHAR(256) NOT NULL,
    tomail VARCHAR(256) NOT NULL,
    ineditype VARCHAR(35) NOT NULL,
    inmessagetype VARCHAR(35) NOT NULL,
    outeditype VARCHAR(35) NOT NULL,
    outmessagetype VARCHAR(35) NOT NULL,
    incontenttype VARCHAR(35) NOT NULL,
    outcontenttype VARCHAR(35) NOT NULL,
    nrmessages INTEGER NOT NULL,
    ts TIMESTAMP NOT NULL,
    infilename VARCHAR(256) NOT NULL,
    inidta INTEGER,
    outfilename VARCHAR(256) NOT NULL,
    outidta INTEGER NOT NULL,
    divtext VARCHAR(35) NOT NULL,
    errortext TEXT NOT NULL,
    rsrv1 VARCHAR(35),
    rsrv2 INTEGER,
    filesize INTEGER
);

CREATE TABLE IF NOT EXISTS report (
    idta SERIAL PRIMARY KEY NOT NULL,
    lastreceived INTEGER NOT NULL,
    lastdone INTEGER NOT NULL,
    lastopen INTEGER NOT NULL,
    lastok INTEGER NOT NULL,
    lasterror INTEGER NOT NULL,
    send INTEGER NOT NULL,
    processerrors INTEGER NOT NULL,
    ts TIMESTAMP NOT NULL,
    type VARCHAR(35) NOT NULL,
    status BOOLEAN NOT NULL, 
    rsrv1 VARCHAR(35),
    rsrv2 INTEGER,
    filesize INTEGER,
    acceptance INTEGER
);

CREATE TABLE IF NOT EXISTS mutex (
    mutexk SERIAL PRIMARY KEY NOT NULL,
    mutexer INTEGER DEFAULT 0,
    ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS persist (
    domein VARCHAR(35),
    botskey VARCHAR(35),
    content TEXT,
    ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (domein, botskey)
);

CREATE TABLE IF NOT EXISTS ta (
    idta SERIAL PRIMARY KEY NOT NULL,
    statust INTEGER DEFAULT 0,
    status INTEGER DEFAULT 0,
    parent INTEGER DEFAULT 0,
    child INTEGER DEFAULT 0,
    script INTEGER DEFAULT 0,
    idroute VARCHAR(35) DEFAULT '',
    filename VARCHAR(256) DEFAULT '',
    frompartner VARCHAR(35) DEFAULT '',
    topartner VARCHAR(35) DEFAULT '',
    fromchannel VARCHAR(35) DEFAULT '',
    tochannel VARCHAR(35) DEFAULT '',
    editype VARCHAR(35) DEFAULT '',
    messagetype VARCHAR(35) DEFAULT '',
    alt VARCHAR(35) DEFAULT '',
    divtext VARCHAR(35) DEFAULT '',
    merge BOOLEAN DEFAULT FALSE,
    nrmessages INTEGER DEFAULT 1,
    testindicator VARCHAR(10) DEFAULT '',
    reference VARCHAR(70) DEFAULT '',
    frommail VARCHAR(256) DEFAULT '',
    tomail VARCHAR(256) DEFAULT '',
    charset VARCHAR(35) DEFAULT '',
    statuse INTEGER DEFAULT 0,
    retransmit BOOLEAN DEFAULT FALSE,
    contenttype VARCHAR(35) DEFAULT 'text/plain',
    errortext TEXT,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    confirmasked BOOLEAN DEFAULT FALSE,
    confirmed BOOLEAN DEFAULT FALSE,
    confirmtype VARCHAR(35) DEFAULT '',
    confirmidta INTEGER DEFAULT 0,
    envelope VARCHAR(35) DEFAULT '',
    botskey VARCHAR(35) DEFAULT '',
    cc VARCHAR(512) DEFAULT '',
    rsrv1 VARCHAR(35) DEFAULT '',
    rsrv2 INTEGER DEFAULT 0,
    rsrv3 VARCHAR(35) DEFAULT '',
    rsrv4 INTEGER DEFAULT 0,
    filesize INTEGER DEFAULT 0,
    numberofresends INTEGER DEFAULT 0,
    rsrv5 VARCHAR(35) DEFAULT ''
);

CREATE TABLE IF NOT EXISTS uniek (
    domein VARCHAR(35) NOT NULL,
    nummer INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (domein)
);


INSERT INTO "auth_permission" VALUES (1,'Can add permission',1,'add_permission');
INSERT INTO "auth_permission" VALUES (2,'Can change permission',1,'change_permission');
INSERT INTO "auth_permission" VALUES (3,'Can delete permission',1,'delete_permission');
INSERT INTO "auth_permission" VALUES (4,'Can add group',2,'add_group');
INSERT INTO "auth_permission" VALUES (5,'Can change group',2,'change_group');
INSERT INTO "auth_permission" VALUES (6,'Can delete group',2,'delete_group');
INSERT INTO "auth_permission" VALUES (7,'Can add user',3,'add_user');
INSERT INTO "auth_permission" VALUES (8,'Can change user',3,'change_user');
INSERT INTO "auth_permission" VALUES (9,'Can delete user',3,'delete_user');
INSERT INTO "auth_permission" VALUES (10,'Can add content type',4,'add_contenttype');
INSERT INTO "auth_permission" VALUES (11,'Can change content type',4,'change_contenttype');
INSERT INTO "auth_permission" VALUES (12,'Can delete content type',4,'delete_contenttype');
INSERT INTO "auth_permission" VALUES (13,'Can add session',5,'add_session');
INSERT INTO "auth_permission" VALUES (14,'Can change session',5,'change_session');
INSERT INTO "auth_permission" VALUES (15,'Can delete session',5,'delete_session');
INSERT INTO "auth_permission" VALUES (16,'Can add log entry',6,'add_logentry');
INSERT INTO "auth_permission" VALUES (17,'Can change log entry',6,'change_logentry');
INSERT INTO "auth_permission" VALUES (18,'Can delete log entry',6,'delete_logentry');
INSERT INTO "auth_permission" VALUES (19,'Can add confirm rule',7,'add_confirmrule');
INSERT INTO "auth_permission" VALUES (20,'Can change confirm rule',7,'change_confirmrule');
INSERT INTO "auth_permission" VALUES (21,'Can delete confirm rule',7,'delete_confirmrule');
INSERT INTO "auth_permission" VALUES (22,'Can add user code type',8,'add_ccodetrigger');
INSERT INTO "auth_permission" VALUES (23,'Can change user code type',8,'change_ccodetrigger');
INSERT INTO "auth_permission" VALUES (24,'Can delete user code type',8,'delete_ccodetrigger');
INSERT INTO "auth_permission" VALUES (25,'Can add user code',9,'add_ccode');
INSERT INTO "auth_permission" VALUES (26,'Can change user code',9,'change_ccode');
INSERT INTO "auth_permission" VALUES (27,'Can delete user code',9,'delete_ccode');
INSERT INTO "auth_permission" VALUES (28,'Can add channel',10,'add_channel');
INSERT INTO "auth_permission" VALUES (29,'Can change channel',10,'change_channel');
INSERT INTO "auth_permission" VALUES (30,'Can delete channel',10,'delete_channel');
INSERT INTO "auth_permission" VALUES (31,'Can add partner',11,'add_partner');
INSERT INTO "auth_permission" VALUES (32,'Can change partner',11,'change_partner');
INSERT INTO "auth_permission" VALUES (33,'Can delete partner',11,'delete_partner');
INSERT INTO "auth_permission" VALUES (34,'Can add partnergroep',11,'add_partnergroep');
INSERT INTO "auth_permission" VALUES (35,'Can change partnergroep',11,'change_partnergroep');
INSERT INTO "auth_permission" VALUES (36,'Can delete partnergroep',11,'delete_partnergroep');
INSERT INTO "auth_permission" VALUES (37,'Can add email address per channel',12,'add_chanpar');
INSERT INTO "auth_permission" VALUES (38,'Can change email address per channel',12,'change_chanpar');
INSERT INTO "auth_permission" VALUES (39,'Can delete email address per channel',12,'delete_chanpar');
INSERT INTO "auth_permission" VALUES (40,'Can add translation rule',13,'add_translate');
INSERT INTO "auth_permission" VALUES (41,'Can change translation rule',13,'change_translate');
INSERT INTO "auth_permission" VALUES (42,'Can delete translation rule',13,'delete_translate');
INSERT INTO "auth_permission" VALUES (43,'Can add route',14,'add_routes');
INSERT INTO "auth_permission" VALUES (44,'Can change route',14,'change_routes');
INSERT INTO "auth_permission" VALUES (45,'Can delete route',14,'delete_routes');
INSERT INTO "auth_permission" VALUES (46,'Can add filereport',15,'add_filereport');
INSERT INTO "auth_permission" VALUES (47,'Can change filereport',15,'change_filereport');
INSERT INTO "auth_permission" VALUES (48,'Can delete filereport',15,'delete_filereport');
INSERT INTO "auth_permission" VALUES (49,'Can add mutex',16,'add_mutex');
INSERT INTO "auth_permission" VALUES (50,'Can change mutex',16,'change_mutex');
INSERT INTO "auth_permission" VALUES (51,'Can delete mutex',16,'delete_mutex');
INSERT INTO "auth_permission" VALUES (52,'Can add persist',17,'add_persist');
INSERT INTO "auth_permission" VALUES (53,'Can change persist',17,'change_persist');
INSERT INTO "auth_permission" VALUES (54,'Can delete persist',17,'delete_persist');
INSERT INTO "auth_permission" VALUES (55,'Can add report',18,'add_report');
INSERT INTO "auth_permission" VALUES (56,'Can change report',18,'change_report');
INSERT INTO "auth_permission" VALUES (57,'Can delete report',18,'delete_report');
INSERT INTO "auth_permission" VALUES (58,'Can add ta',19,'add_ta');
INSERT INTO "auth_permission" VALUES (59,'Can change ta',19,'change_ta');
INSERT INTO "auth_permission" VALUES (60,'Can delete ta',19,'delete_ta');
INSERT INTO "auth_permission" VALUES (61,'Can add counter',20,'add_uniek');
INSERT INTO "auth_permission" VALUES (62,'Can change counter',20,'change_uniek');
INSERT INTO "auth_permission" VALUES (63,'Can delete counter',20,'delete_uniek');
INSERT INTO "django_content_type" VALUES (1,'permission','auth','permission');
INSERT INTO "django_content_type" VALUES (2,'group','auth','group');
INSERT INTO "django_content_type" VALUES (3,'user','auth','user');
INSERT INTO "django_content_type" VALUES (4,'content type','contenttypes','contenttype');
INSERT INTO "django_content_type" VALUES (5,'session','sessions','session');
INSERT INTO "django_content_type" VALUES (6,'log entry','admin','logentry');
INSERT INTO "django_content_type" VALUES (7,'confirm rule','bots','confirmrule');
INSERT INTO "django_content_type" VALUES (8,'user code type','bots','ccodetrigger');
INSERT INTO "django_content_type" VALUES (9,'user code','bots','ccode');
INSERT INTO "django_content_type" VALUES (10,'channel','bots','channel');
INSERT INTO "django_content_type" VALUES (11,'partner','bots','partner');
INSERT INTO "django_content_type" VALUES (12,'email address per channel','bots','chanpar');
INSERT INTO "django_content_type" VALUES (13,'translation rule','bots','translate');
INSERT INTO "django_content_type" VALUES (14,'route','bots','routes');
INSERT INTO "django_content_type" VALUES (15,'filereport','bots','filereport');
INSERT INTO "django_content_type" VALUES (16,'mutex','bots','mutex');
INSERT INTO "django_content_type" VALUES (17,'persist','bots','persist');
INSERT INTO "django_content_type" VALUES (18,'report','bots','report');
INSERT INTO "django_content_type" VALUES (19,'ta','bots','ta');
INSERT INTO "django_content_type" VALUES (20,'counter','bots','uniek');
INSERT INTO "django_content_type" VALUES (21,'partnergroep','bots','partnergroep');
INSERT INTO "auth_user" VALUES (1,'pbkdf2_sha256$12000$59AB2wJ6aY7e$6d1B5K+LEKAFG+t+j7WWxLhaPQ2vp00XzjgbtYf5oO8=','2014-02-14 17:29:39.880521',TRUE,'bots','','','bots@bots.com',TRUE,TRUE,'2014-02-14 17:29:39.880521');
CREATE INDEX auth_permission_37ef4eb4 ON auth_permission (content_type_id);
CREATE INDEX auth_group_permissions_5f412f9a ON auth_group_permissions (group_id);
CREATE INDEX auth_group_permissions_83d7f98b ON auth_group_permissions (permission_id);
CREATE INDEX auth_user_groups_6340c63c ON auth_user_groups (user_id);
CREATE INDEX auth_user_groups_5f412f9a ON auth_user_groups (group_id);
CREATE INDEX auth_user_user_permissions_6340c63c ON auth_user_user_permissions (user_id);
CREATE INDEX auth_user_user_permissions_83d7f98b ON auth_user_user_permissions (permission_id);
CREATE INDEX django_session_b7b81f0c ON django_session (expire_date);
CREATE INDEX django_admin_log_6340c63c ON django_admin_log (user_id);
CREATE INDEX django_admin_log_37ef4eb4 ON django_admin_log (content_type_id);
CREATE INDEX confirmrule_9f2879f7 ON confirmrule (frompartner_id);
CREATE INDEX confirmrule_a39bed9d ON confirmrule (topartner_id);
CREATE INDEX confirmrule_b6bd199d ON confirmrule (idchannel_id);
CREATE INDEX ccode_9aaa43b0 ON ccode (ccodeid_id);
CREATE INDEX ccode_b9a4ebf7 ON ccode (leftcode);
CREATE INDEX ccode_4d1302e0 ON ccode (rightcode);
CREATE INDEX partnergroup_4b808ee5 ON partnergroup (from_partner_id);
CREATE INDEX partnergroup_6119dc58 ON partnergroup (to_partner_id);
CREATE INDEX chanpar_dbf9b140 ON chanpar (idpartner_id);
CREATE INDEX chanpar_b6bd199d ON chanpar (idchannel_id);
CREATE INDEX translate_9f2879f7 ON translate (frompartner_id);
CREATE INDEX translate_a39bed9d ON translate (topartner_id);
CREATE INDEX routes_9709b79a ON routes (idroute);
CREATE INDEX routes_bd6552e7 ON routes (fromchannel_id);
CREATE INDEX routes_7b20824a ON routes (tochannel_id);
CREATE INDEX routes_9f2879f7 ON routes (frompartner_id);
CREATE INDEX routes_a39bed9d ON routes (topartner_id);
CREATE INDEX routes_9d2ef12d ON routes (frompartner_tochannel_id);
CREATE INDEX routes_c023a596 ON routes (topartner_tochannel_id);
CREATE INDEX filereport_6c4d89a3 ON filereport (ts);
CREATE INDEX report_6c4d89a3 ON report (ts);
CREATE INDEX ta_410d0aac ON ta (parent);
CREATE INDEX ta_171cbadd ON ta (reference);
CREATE OR REPLACE FUNCTION update_persist_ts()
RETURNS TRIGGER AS $$
BEGIN
    NEW.ts := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER persist_update 
AFTER UPDATE OF content ON persist
FOR EACH ROW
EXECUTE FUNCTION update_persist_ts();

COMMIT;
