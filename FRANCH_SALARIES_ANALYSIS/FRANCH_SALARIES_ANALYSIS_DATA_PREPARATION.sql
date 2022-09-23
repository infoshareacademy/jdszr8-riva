---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
-----SALARIES TABLE--------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------

--creating table
create table
  salaries (
    codgeo VARCHAR,
    libgeo VARCHAR,
    snhm14 FLOAT,
    snhmc14 FLOAT,
    snhmp14 FLOAT,
    snhme14 FLOAT,
    snhmo14 FLOAT,
    snhmf14 FLOAT,
    snhmfc14 FLOAT,
    snhmfp14 FLOAT,
    snhmfe14 FLOAT,
    snhmfo14 FLOAT,
    snhmh14 FLOAT,
    snhmhc14 FLOAT,
    snhmhp14 FLOAT,
    snhmhe14 FLOAT,
    snhmho14 FLOAT,
    snhm1814 FLOAT,
    snhm2614 FLOAT,
    snhm5014 FLOAT,
    snhmf1814 FLOAT,
    snhmf2614 FLOAT,
    snhmf5014 FLOAT,
    snhmh1814 FLOAT,
    snhmh2614 FLOAT,
    snhmh5014 FLOAT
  );

--exploring the data
select
  *
from
  salaries s;

--exploring the data
select
  count(*)
from
  salaries s;

--exploring the data
select
  *
from
  salaries s
where
  codgeo is null
  or libgeo is null
  or snhm14 is null
  or snhmc14 is null
  or snhmp14 is null
  or snhme14 is null
  or snhmo14 is null
  or snhmf14 is null
  or snhmfc14 is null
  or snhmfp14 is null
  or snhmfe14 is null
  or snhmfo14 is null
  or snhmh14 is null
  or snhmhc14 is null
  or snhmhp14 is null
  or snhmhe14 is null
  or snhmho14 is null
  or snhm1814 is null
  or snhm2614 is null
  or snhm5014 is null
  or snhmf1814 is null
  or snhmf2614 is null
  or snhmf5014 is null
  or snhmh1814 is null
  or snhmh2614 is null
  or snhmh5014 is null;

--exploring data 
select
  *
from
  salaries s
where
  codgeo = '97404' --check if there is no duplicate citis with a given code

--exploring data 
select
  (
    select
      distinct count(codgeo)
    from
      salaries s
  ) as number_of_unique_rows,
  count(codgeo) as number_of_codgeo_numbers,
  count(distinct codgeo) as number_of_unique_codgeo_numbers
from
  salaries s;

--exploring compatibility between tables 
sprawdzanie spojnosci danych z tabela geography przed i po aktualizacji danych
with
  data as (
    select
      s.codgeo,
      s.libgeo,
      g.code_insee,
      g.nom_commune case
        when s.codgeo = g.code_insee then 'ok'
        else 'check'
      end as _check
    from
      salaries s
      left join geography g on s.codgeo = g.code_insee
  )


--exploring data
select
  count(codgeo),
  count(distinct codgeo)
from
  salaries s;

--exploring data
select
  count(codgeo),
  count(distinct codgeo)
from
  companies c;

--exploring data
--city names repeat themselves as a result of table structure
--requires caution while using joins
select
  count(codgeo),
  count(distinct codgeo)
from
  population p;

--exploring data
--city names repeat themselves as a result of table structure
--requires caution while using joins
--unique values: 5136
with
  check_table as (
    select
      s.codgeo as kod,
      s.libgeo,
      g.code_insee,
      g.nom_commune
    from
      salaries s
      join geography g on s.codgeo = g.code_insee
  )
select
  count(*) as wiersze,
  count(distinct kod) as unikaty
from
  check_table;

--city sain etienne repeates itself in geography table
select
  *
from
  salaries s
where
  s.codgeo = '42218';

--exploring data
select
  *
from
  geography g
where
  g.code_insee = '42218';

--5136 unique cities in company table
with
  check_table as (
    select
      s.codgeo as kod,
      s.libgeo,
      c.codgeo,
      c.libgeo
    from
      salaries s
      join companies c on s.codgeo = c.codgeo
  )
select
  count(*) as wiersze,
  count(distinct kod) as unikaty
from
  check_table;

--looking for city code in population table
--population table has duplicates
--unique values = 5107, it means that some cities are missing compare to cities from salaries
with
  check_table as (
    select
      s.codgeo as kod,
      s.libgeo,
      p.codgeo,
      p.libgeo
    from
      salaries s
      join population p on s.codgeo = p.codgeo
  )
select
  count(*) as wiersze,
  count(distinct kod) as unikaty
from
  check_table;

--looking for missing data cities in population table
with
  braki_w_populacji as (
    select
      s.codgeo as kod,
      s.libgeo,
      p.codgeo,
      p.libgeo
    from
      salaries s
      left join population p on s.codgeo = p.codgeo
    where
      p.codgeo is null
  ) --looking for information (in companies table) about missing cities from population table
select
  *
from
  companies c
where
  c.codgeo in (
    select
      kod
    from
      braki_w_populacji
  );

--in population table 29 cities are missing, even relatively big cities
select
  *
from
  population p
where
  p.libgeo ilike 'Tourlav%';

---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
-----POPULATION TABLE------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
 
 --creating table
create table
  population (
    nivgeo VARCHAR,
    codgeo VARCHAR,
    libgeo VARCHAR,
    moco INTEGER,
    ageq80_17 INTEGER,
    sexe INTEGER,
    nb INTEGER
  );

--exploring the data
select
  count(*)
from
  population p;

--exploring the data
select
  distinct codgeo,
  length(codgeo)
from
  population p
order by
  length(codgeo) asc;

--exploring the data
select
  distinct nivgeo,
  codgeo,
  libgeo
from
  population p
where
  codgeo like '%004'
order by
  libgeo;

--exploring the data
select
  s.codgeo,
  p.codgeo
from
  salaries s
  left join population p on s.codgeo = p.codgeo
where
  s.codgeo = '2A004';

 
  ---------------------------
  ---------------------------
  ---------------------------
  ---------------------------
  ---------------------------
  ---------------------------
  -----COMPANIES TABLE-------
  ---------------------------
  ---------------------------
  ---------------------------
  ---------------------------
  ---------------------------
  ---------------------------

--creating a table
create table
  companies (
    codgeo varchar,
    libgeo varchar,
    reg integer,
    dep integer,
    e14tst integer,
    e14ts0nd integer,
    e14ts1 integer,
    e14ts6 integer,
    e14ts10 integer,
    e14ts20 integer,
    e14ts50 integer,
    e14ts100 integer,
    e14ts200 integer,
    e14ts500 integer
  );

--exploring the data
select
  *
from
  companies c;

--exploring the data
select
  count(*),
  count(distinct c.codgeo)
from
  companies c;

---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
-------GEOGRAPHY TABLE-----
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
 
--creating a table
CREATE TABLE
  geography (
    "EU_circo" varchar(50) NULL,
    code_région integer NULL,
    nom_région varchar(50) NULL,
    "chef.lieu_région" varchar(50) NULL,
    numéro_département varchar(50) NULL,
    nom_département varchar(50) NULL,
    préfecture varchar(50) NULL,
    numéro_circonscription varchar(50) NULL,
    nom_commune varchar(50) NULL,
    codes_postaux varchar(50) NULL,
    code_insee varchar(50) NULL,
    latitude varchar(50) NULL,
    longitude varchar(50) NULL,
    éloignement varchar(50) NULL
  );

--exploring the data
select
  *
from
  geography g
where
  g.nom_commune = 'Ajaccio';

--exploring the data
select
  count(*),
  count(distinct g.code_insee),
  min(length(g.code_insee)),
  max(length(g.code_insee))
from
  geography g;

--looging for cities with code that contains only 4 digits
select
  count(g.code_insee) over (),
  g.*
from
  geography g
where
  length(g.code_insee) = 4;

--fixing code for cities with code that contains only 4 digits
--adding digit '0' at the beginning of string 
--3233 udated rows
UPDATE
  geography
SET
  code_insee = concat('0', code_insee)
where
  length(code_insee) = 4;

--after update city codes have correct number of digits in their code
select
  min(length(g.code_insee)),
  max(length(g.code_insee))
from
  geography g;

--exploring city code no '61483'
--code '61022' in geographytable should be replaced by code no '61483'
select
  *
from
  salaries s
where
  s.libgeo like 'Aja%';

select
  *
from
  salaries s
where
  s.codgeo = '61483' --from salaries s where s.codgeo = '61022';
select
  *
from
  population s
where
  s.codgeo = '61483' --from population s where s.codgeo  = '61022';
select
  *
from
  companies s
where
  s.codgeo = '61483' --from population s where s.codgeo  = '61022';
select
  *
from
  geography s
where
  s.nom_commune ilike 'bagnoles%';

-- = '61483'
--updating selected code
UPDATE
  geography
SET
  code_insee = '61483'
where
  code_insee = '61022';

--exploring departament 2A
--updated needed in geography table
select
  concat(g.numéro_département, substring(code_insee, 3, 3)),
  *
from
  geography g
where
  g.numéro_département = '2A';

--updated of 124 lines
UPDATE
  geography
SET
  code_insee = concat(numéro_département, substring(code_insee, 3, 3))
where
  numéro_département = '2A';

--exploring departament 2B
--updated needed in geography table
select
  concat(g.numéro_département, substring(code_insee, 3, 3)),
  *
from
  geography g
where
  g.numéro_département = '2B';

--updated of 236 lines
UPDATE
  geography
SET
  code_insee = concat(numéro_département, substring(code_insee, 3, 3))
where
  numéro_département = '2B';

--deleting duplpicate value
DELETE FROM
  geography
WHERE
  code_insee = '97502'
  and nom_commune = 'BANDRABOUA';