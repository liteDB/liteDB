.read test/_settings.sql
.load dist/spellfix


CREATE VIRTUAL TABLE tri USING fts5(a, tokenize="trigram");
INSERT INTO tri VALUES('abcdefghij KLMNOPQRST uvwxyz');

-- The following queries all match the single row in the table
SELECT * FROM tri('cdefg');
SELECT * FROM tri('cdefg AND pqr');
SELECT * FROM tri('"hij klm" NOT stuv');

SELECT * FROM tri WHERE a LIKE '%cdefg%';
SELECT * FROM tri WHERE a GLOB '*ij klm*xyz';



-- If the database schema is:
-- CREATE TABLE tbl (a, b, c, d INTEGER PRIMARY KEY);
-- CREATE VIRTUAL TABLE fts USING fts5(a, c, content=tbl, content_rowid=d);


-- Create a table. And an external content fts5 table to index it.
CREATE TABLE tbl(a INTEGER PRIMARY KEY, b, c);
CREATE VIRTUAL TABLE fts_idx USING fts5(b, c, content='tbl', content_rowid='a');

-- Triggers to keep the FTS index up to date.
CREATE TRIGGER tbl_ai AFTER INSERT ON tbl BEGIN
  INSERT INTO fts_idx(rowid, b, c) VALUES (new.a, new.b, new.c);
END;
CREATE TRIGGER tbl_ad AFTER DELETE ON tbl BEGIN
  INSERT INTO fts_idx(fts_idx, rowid, b, c) VALUES('delete', old.a, old.b, old.c);
END;
CREATE TRIGGER tbl_au AFTER UPDATE ON tbl BEGIN
  INSERT INTO fts_idx(fts_idx, rowid, b, c) VALUES('delete', old.a, old.b, old.c);
  INSERT INTO fts_idx(rowid, b, c) VALUES (new.a, new.b, new.c);
END;

insert into tbl(b, c) values ('more and more', 'cool shit');
insert into tbl(b, c) values ('here I am', 'cool shit');
insert into tbl(b, c) values ('Golf VII', 'cool shit');
insert into tbl(b, c) values ('Golf V', 'cool shit');

SELECT * FROM fts_idx WHERE b LIKE '%Golf%';
SELECT * FROM fts_idx WHERE b LIKE '%VII%';
SELECT * FROM fts_idx WHERE b LIKE '%V%';


select rowid, * from tbl where rowid in (
  select rowid from fts_idx where b LIKE  '%Golf%'
) order by rowid limit 10;


select rowid, * from tbl where rowid in (
  select rowid from fts_idx where b LIKE  '%V%'
) order by rowid limit 10;