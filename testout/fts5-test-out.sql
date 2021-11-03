.load dist/spellfix


CREATE VIRTUAL TABLE tri USING fts5(a, tokenize="trigram");
INSERT INTO tri VALUES('abcdefghij KLMNOPQRST uvwxyz');

-- The following queries all match the single row in the table
SELECT * FROM tri('cdefg');
[{"a":"abcdefghij KLMNOPQRST uvwxyz"}]
SELECT * FROM tri('cdefg AND pqr');
[{"a":"abcdefghij KLMNOPQRST uvwxyz"}]
SELECT * FROM tri('"hij klm" NOT stuv');
[{"a":"abcdefghij KLMNOPQRST uvwxyz"}]

SELECT * FROM tri WHERE a LIKE '%cdefg%';
[{"a":"abcdefghij KLMNOPQRST uvwxyz"}]
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
[{"b":"Golf VII","c":"cool shit"},
{"b":"Golf V","c":"cool shit"}]
SELECT * FROM fts_idx WHERE b LIKE '%VII%';
[{"b":"Golf VII","c":"cool shit"}]
SELECT * FROM fts_idx WHERE b LIKE '%V%';
[{"b":"Golf VII","c":"cool shit"},
{"b":"Golf V","c":"cool shit"}]


select rowid, * from tbl where rowid in (
  select rowid from fts_idx where b LIKE  '%Golf%'
) order by rowid limit 10;
[{"a":3,"a":3,"b":"Golf VII","c":"cool shit"},
{"a":4,"a":4,"b":"Golf V","c":"cool shit"}]


select rowid, * from tbl where rowid in (
  select rowid from fts_idx where b LIKE  '%V%'
) order by rowid limit 10;
[{"a":3,"a":3,"b":"Golf VII","c":"cool shit"},
{"a":4,"a":4,"b":"Golf V","c":"cool shit"}]
