/* create ABOOK database scripts */

CREATE DATABASE abook
ON 
( NAME = 'abook_data',
  FILENAME = 'e:\database\sequel\abook.mdf',
  SIZE = 1,
  MAXSIZE = 10,
  FILEGROWTH = 1 )
LOG ON
( NAME = 'abook_log',
  FILENAME = 'e:\database\sequel\abook.ldf',
  SIZE = 1,
  MAXSIZE = 5,
  FILEGROWTH = 1 )

/*********************************************/

CREATE TABLE friend (
 sname char (10) NOT NULL
       CONSTRAINT PK_friend PRIMARY KEY,
 lname varchar (60) NULL ,
 city char (2) NULL ,
 bdate smalldatetime NULL ,
 phone varchar (20) NULL ,
 occupy char (2) NULL ,
 company char (10) NULL ,
 email varchar (30) NULL 
)

CREATE TABLE company (
 sname char (10) NOT NULL
       CONSTRAINT PK_company PRIMARY KEY,
 lname varchar (60) NULL ,
 addr1 varchar (60) NULL ,
 addr2 varchar (60) NULL ,
 type char (2) NULL 
)

CREATE TABLE tbctrl (
 code char (2) NOT NULL 
      CONSTRAINT PK_tbctrl PRIMARY KEY,
 name varchar (30) NULL 
)

CREATE TABLE tbdata (
 tabref char (2) NOT NULL ,
 code char (2) NOT NULL ,
 name varchar (30) NULL ,
 CONSTRAINT PK_tbdata PRIMARY KEY ( tabref, code )
)

GO

/* Index */
CREATE INDEX IX_friend ON friend (lname)
CREATE INDEX IX_company ON company (lname)

GO

/* Relationship */
ALTER TABLE tbdata ADD 
  CONSTRAINT FK_tbdata_tbctrl FOREIGN KEY (tabref) REFERENCES tbctrl (code)

GO

/* Referential Integrity Rule */

CREATE TRIGGER tr_friend_insupd ON friend
FOR INSERT, UPDATE
AS
IF UPDATE(company)
  BEGIN
  IF EXISTS(SELECT company FROM inserted WHERE company IS NOT NULL) AND
     NOT EXISTS(SELECT sname FROM company WHERE sname IN (SELECT company FROM inserted))
     BEGIN
      ROLLBACK TRANSACTION
      RAISERROR ('company not found in table "company".',0,1)
     END
  END

GO

CREATE TRIGGER tr_company_delete ON company
FOR DELETE
AS
IF @@ROWCOUNT = 0
   RAISERROR ("selected row(s) not found !",0,1)
ELSE
  /* 1. Cascade Delete */
  -- DELETE friend WHERE company IN (SELECT sname FROM deleted) 
  -- or --
  /* DELETE friend
     FROM friend, deleted
     WHERE friend.company = deleted.sname */

  /* 2. SetNull Delete */
  UPDATE friend
      SET friend.company = NULL
        FROM friend, deleted
        WHERE friend.company = deleted.sname

GO

CREATE TRIGGER tr_company_update ON company
FOR UPDATE
AS
/* Cascade Update */
DECLARE @nRowCount INTEGER
SELECT @nRowCount = @@ROWCOUNT
IF UPDATE(sname)
  BEGIN
  IF @nRowCount = 1
    BEGIN
     /* UPDATE friend
     SET friend.company = (SELECT sname FROM inserted)
     FROM friend INNER JOIN deleted
     ON friend.company = deleted.sname */
     UPDATE friend
       SET friend.company = inserted.sname
       FROM friend, deleted, inserted
       WHERE friend.company = deleted.sname 
    END
  ELSE
   IF @nRowCount > 1
     BEGIN
      ROLLBACK TRANSACTION
      RAISERROR ('Multi-row update on table "company" not allowed.',0,1)
     END
   ELSE
     RAISERROR ("selected row(s) not found !",0,1)
  END

GO

/* TABLE: tbctrl */
INSERT INTO tbctrl (code,name) VALUES ('01','จังหวัด')
INSERT INTO tbctrl (code,name) VALUES ('02','อาชีพ')
INSERT INTO tbctrl (code,name) VALUES ('03','ประเภทธุรกิจ')

GO
