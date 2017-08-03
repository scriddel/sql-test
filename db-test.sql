-------------------
-- DOMAINS
-------------------

create domain D_ID as bigint;
create domain D_FIONAME as varchar(30) character set UTF8 collate UTF8;
create domain D_CAPTION as varchar(255) character set UTF8 collate UTF8;
create domain D_YEAR as integer;
create domain D_SMALLINT as smallint;

-------------------
-- TABLES
-------------------

create table AUTHORS (
  ID                D_ID not null,
  AUTHOR_LASTNAME   D_FIONAME not null,
  AUTHOR_FIRSTNAME  D_FIONAME not null,
  AUTHOR_SURNAME    D_FIONAME,
  constraint PK_AUTHORS primary key (ID)
);

alter table AUTHORS add constraint PK_AUTHORS primary key (ID);


create table BOOKS (
  ID            D_ID not null,
  BOOK_CAPTION  D_CAPTION not null,
  BOOK_YEAR     D_YEAR,
  BOOK_PAGES    D_SMALLINT,
  constraint PK_BOOKS primary key (ID)
);

alter table BOOKS add constraint PK_BOOKS primary key (ID);

create table AUTHOR_BOOKS (
  AUTHOR_ID D_ID not null,
  BOOK_ID   D_ID not null,
  constraint PK_AUTHOR_BOOKS primary key (AUTHOR_ID, BOOK_ID),
  constraint FK_AUTHOR_BOOKS_AUTH foreign key (AUTHOR_ID) references AUTHORS(ID)
    on delete cascade,
  constraint FK_AUTHOR_BOOKS_BOOK foreign key (BOOK_ID) references BOOKS(ID)
    on delete cascade
);

-------------------
-- SEQUENCES
-------------------
create sequence SEQ_AUTHORS;
create sequence SEQ_BOOKS;

-------------------
-- TRIGGERS
-------------------

create or alter trigger TRG_AUTHORS_SEQ for AUTHORS
  active before insert position 0
as
begin
  if (new.ID is null or new.ID = 0) then
    new.ID = next value for SEQ_AUTHORS;
end;

create or alter trigger TRG_BOOKS_SEQ for BOOKS
  active before insert position 0
as
begin
  if (new.ID is null or new.ID = 0) then
    new.ID = next value for SEQ_BOOKS;
end;

-------------------
-- QUERY
-------------------

select a.ID, a.AUTHOR_LASTNAME from
  (select ab.AUTHOR_ID from AUTHOR_BOOKS ab group by ab.AUTHOR_ID
    having count(ab.AUTHOR_ID) > 3) as ab
join AUTHORS a on a.ID = ab.AUTHOR_ID
