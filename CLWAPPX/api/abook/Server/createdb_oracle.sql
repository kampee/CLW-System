/* create ABOOK database scripts */

CREATE DATABASE abook
CONTROLFILE REUSE
LOGFILE GROUP 1 ('e:\database\oracle\abook_log1.log') SIZE 512K,
        GROUP 2 ('e:\database\oracle\abook_log2.log') SIZE 512K
DATAFILE 'e:\database\oracle\abook.dbf' SIZE 10M AUTOEXTEND ON NEXT 5M MAXSIZE 50M
CHARACTER SET TH8TISASCII ;

/*********************************************/

CREATE TABLE friend (
 sname char (10) NOT NULL
       CONSTRAINT PK_friend PRIMARY KEY,
 lname varchar (60) ,
 city char (2) ,
 bdate date ,
 phone varchar (20) ,
 occupy char (2) ,
 company char (10) ,
 email varchar (30)
);

CREATE TABLE company (
 sname char (10) NOT NULL
       CONSTRAINT PK_company PRIMARY KEY,
 lname varchar (60) ,
 addr1 varchar (60) ,
 addr2 varchar (60) ,
 type char (2) 
);

CREATE TABLE tbctrl (
 code char (2) NOT NULL 
      CONSTRAINT PK_tbctrl PRIMARY KEY,
 name varchar (30)
);

CREATE TABLE tbdata (
 tabref char (2) NOT NULL ,
 code char (2) NOT NULL ,
 name varchar (30) ,
 CONSTRAINT PK_tbdata PRIMARY KEY ( tabref, code )
);

/* Index */
CREATE INDEX IX_friend ON friend (lname);
CREATE INDEX IX_company ON company (lname);

/* Relationship */
ALTER TABLE tbdata ADD
  CONSTRAINT FK_tbdata_tbctrl FOREIGN KEY (tabref) REFERENCES tbctrl (code)
  ON DELETE CASCADE ;

/* Referential Integrity Rule */
  
CREATE TRIGGER tr_company_delete
AFTER DELETE ON company
/* delete set null */
FOR EACH ROW
BEGIN
  UPDATE friend SET friend.company = NULL
    WHERE friend.company = :old.sname ;
END;

CREATE TRIGGER tr_company_update 
AFTER UPDATE OF sname ON company
/* Cascade Update */
FOR EACH ROW
BEGIN
  UPDATE friend SET friend.company = :new.sname
    WHERE friend.company = :old.sname ;
END;


/********************
 * Initialized Data *
 ********************/

/* TABLE: tbctrl */
INSERT INTO tbctrl (code,name) VALUES ('01','จังหวัด')
INSERT INTO tbctrl (code,name) VALUES ('02','อาชีพ')
INSERT INTO tbctrl (code,name) VALUES ('03','ประเภทธุรกิจ')
