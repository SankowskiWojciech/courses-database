/*
DROP TABLE IF EXISTS LESSON_FILE_ACCESS;
DROP TABLE IF EXISTS FILE;
DROP TABLE IF EXISTS INDIVIDUAL_LESSON;
DROP TABLE IF EXISTS GROUP_LESSON;
DROP TABLE IF EXISTS TOKEN;
DROP TABLE IF EXISTS LOGIN_CREDENTIALS;
DROP TABLE IF EXISTS SUBDOMAIN_USER_ACCESS;
DROP TABLE IF EXISTS SUBDOMAIN;
DROP TABLE IF EXISTS STUDENT_GROUP_ACCESS;
DROP TABLE IF EXISTS GROUP_OF_STUDENTS;
DROP TABLE IF EXISTS STUDENT;
DROP TABLE IF EXISTS PARENT;
DROP TABLE IF EXISTS TUTOR;
DROP TABLE IF EXISTS ORGANIZATION;
*/

CREATE TABLE ORGANIZATION
(
    EMAIL_ADDRESS VARCHAR(50) PRIMARY KEY,
    ALIAS         VARCHAR(20) UNIQUE NOT NULL,
    NAME          VARCHAR(100)       NOT NULL,
    DESCRIPTION   VARCHAR(500),
    PHONE_NUMBER  VARCHAR(9),
    WEBSITE_URL   VARCHAR(30)
);

CREATE TABLE TUTOR
(
    EMAIL_ADDRESS VARCHAR(50) PRIMARY KEY,
    ALIAS         VARCHAR(20) UNIQUE NOT NULL,
    FIRST_NAME    VARCHAR(15)        NOT NULL,
    LAST_NAME     VARCHAR(30)        NOT NULL,
    DESCRIPTION   VARCHAR(500),
    PHONE_NUMBER  VARCHAR(9)
);

CREATE TABLE PARENT
(
    EMAIL_ADDRESS VARCHAR(50) PRIMARY KEY,
    FIRST_NAME    VARCHAR(15) NOT NULL,
    LAST_NAME     VARCHAR(30) NOT NULL,
    PHONE_NUMBER  VARCHAR(9)
);

CREATE TABLE STUDENT
(
    EMAIL_ADDRESS VARCHAR(50) PRIMARY KEY,
    FIRST_NAME    VARCHAR(15) NOT NULL,
    LAST_NAME     VARCHAR(30) NOT NULL,
    PHONE_NUMBER  VARCHAR(9),
    PARENT_ID     VARCHAR(50) REFERENCES PARENT (EMAIL_ADDRESS)
);

CREATE TABLE GROUP_OF_STUDENTS
(
    ID                 VARCHAR(36) PRIMARY KEY,
    NAME               VARCHAR(50)                                     NOT NULL,
    DESCRIPTION        VARCHAR(1000),
    CREATION_DATE_TIME TIMESTAMPTZ                                     NOT NULL,
    SUBDOMAIN_ID       VARCHAR(20) REFERENCES SUBDOMAIN (SUBDOMAIN_ID) NOT NULL,
    TUTOR_ID           VARCHAR(50) REFERENCES TUTOR (EMAIL_ADDRESS)    NOT NULL
);

CREATE TABLE STUDENT_GROUP_ACCESS
(
    STUDENT_ID VARCHAR(50) NOT NULL REFERENCES STUDENT (EMAIL_ADDRESS),
    GROUP_ID   VARCHAR(36) NOT NULL REFERENCES GROUP_OF_STUDENTS (ID),
    PRIMARY KEY (STUDENT_ID, GROUP_ID)
);

CREATE TABLE SUBDOMAIN
(
    SUBDOMAIN_ID   VARCHAR(20) PRIMARY KEY,
    SUBDOMAIN_TYPE VARCHAR(12) NOT NULL
);

CREATE TABLE SUBDOMAIN_USER_ACCESS
(
    SUBDOMAIN_ID       VARCHAR(20) NOT NULL REFERENCES SUBDOMAIN (SUBDOMAIN_ID),
    USER_EMAIL_ADDRESS VARCHAR(50) NOT NULL,
    PRIMARY KEY (SUBDOMAIN_ID, USER_EMAIL_ADDRESS)
);

CREATE TABLE LOGIN_CREDENTIALS
(
    USER_EMAIL_ADDRESS VARCHAR(50) PRIMARY KEY,
    PASSWORD_HASH      VARCHAR(60) NOT NULL,
    ACCOUNT_TYPE       VARCHAR(12) NOT NULL
);

CREATE TABLE TOKEN
(
    TOKEN_ID             VARCHAR(36) PRIMARY KEY,
    TOKEN_VALUE          VARCHAR(354) NOT NULL,
    USER_EMAIL_ADDRESS   VARCHAR(50)  NOT NULL,
    ACCOUNT_TYPE         VARCHAR(12)  NOT NULL,
    RSA_PUBLIC_KEY       VARCHAR(212) NOT NULL,
    CREATION_DATE_TIME   TIMESTAMPTZ  NOT NULL,
    EXPIRATION_DATE_TIME TIMESTAMPTZ  NOT NULL,
    REVOCATION_DATE_TIME TIMESTAMPTZ
);

CREATE TABLE GROUP_LESSON
(
    ID                     VARCHAR(36) PRIMARY KEY,
    TITLE                  VARCHAR(50)                                   NOT NULL,
    START_DATE             TIMESTAMPTZ                                   NOT NULL,
    END_DATE               TIMESTAMPTZ                                   NOT NULL,
    DESCRIPTION            VARCHAR(2000),
    CREATION_DATE_TIME     TIMESTAMPTZ                                   NOT NULL,
    MODIFICATION_DATE_TIME TIMESTAMPTZ,
    ORGANIZATION_ID        VARCHAR(50) REFERENCES ORGANIZATION (EMAIL_ADDRESS),
    TUTOR_ID               VARCHAR(50) REFERENCES TUTOR (EMAIL_ADDRESS)  NOT NULL,
    GROUP_ID               VARCHAR(50) REFERENCES GROUP_OF_STUDENTS (ID) NOT NULL
);

CREATE TABLE INDIVIDUAL_LESSON
(
    ID                     VARCHAR(36) PRIMARY KEY,
    TITLE                  VARCHAR(50)                                    NOT NULL,
    START_DATE             TIMESTAMPTZ                                    NOT NULL,
    END_DATE               TIMESTAMPTZ                                    NOT NULL,
    DESCRIPTION            VARCHAR(2000),
    CREATION_DATE_TIME     TIMESTAMPTZ                                    NOT NULL,
    MODIFICATION_DATE_TIME TIMESTAMPTZ,
    ORGANIZATION_ID        VARCHAR(50) REFERENCES ORGANIZATION (EMAIL_ADDRESS),
    TUTOR_ID               VARCHAR(50) REFERENCES TUTOR (EMAIL_ADDRESS)   NOT NULL,
    STUDENT_ID             VARCHAR(50) REFERENCES STUDENT (EMAIL_ADDRESS) NOT NULL
);

CREATE TABLE FILE
(
    ID                 VARCHAR(36) PRIMARY KEY,
    NAME               VARCHAR(50) NOT NULL,
    EXTENSION          VARCHAR(5),
    CONTENT            BYTEA       NOT NULL,
    CREATED_BY         VARCHAR(50) NOT NULL,
    CREATION_DATE_TIME TIMESTAMPTZ NOT NULL
);

CREATE TABLE LESSON_FILE_ACCESS
(
    LESSON_ID VARCHAR(36) NOT NULL,
    FILE_ID   VARCHAR(36) NOT NULL REFERENCES FILE (ID),
    PRIMARY KEY (LESSON_ID, FILE_ID)
);