/* ISQL: create ABOOK database scripts */

DBTOOL CREATE DATABASE "e:\database\sqlany\abook.db" ;

/*********************************************/

CREATE TABLE friend (
 sname char (10) NOT NULL PRIMARY KEY,
 lname varchar (60),
 city char (2),
 bdate date,
 phone varchar (20),
 occupy char (2),
 company char (10),
 email varchar (30)
)

CREATE TABLE company (
 sname char (10) NOT NULL PRIMARY KEY,
 lname varchar (60),
 addr1 varchar (60),
 addr2 varchar (60),
 type char (2)
)

CREATE TABLE tbctrl (
 code char (2) NOT NULL PRIMARY KEY,
 name varchar (30)
)

CREATE TABLE tbdata (
 tabref char (2) NOT NULL,
 code char (2) NOT NULL,
 name varchar (30),
 PRIMARY KEY ( tabref, code )
)

/* Index */
CREATE INDEX IX_friend ON friend (lname);
CREATE INDEX IX_company ON company (lname);

/* Relationship & Referntial Integrity */
ALTER TABLE friend ADD 
  FOREIGN KEY (company) REFERENCES company (sname)
  ON UPDATE CASCADE
  ON DELETE SET NULL ;

ALTER TABLE tbdata ADD 
  FOREIGN KEY (tabref) REFERENCES tbctrl (code)
  ON UPDATE CASCADE
  ON DELETE CASCADE ;

/********************
 * Initialized Data *
 ********************/

/* TABLE: tbctrl */
INSERT INTO tbctrl (code,name) VALUES ('01','จังหวัด')
INSERT INTO tbctrl (code,name) VALUES ('02','อาชีพ')
INSERT INTO tbctrl (code,name) VALUES ('03','ประเภทธุรกิจ')
