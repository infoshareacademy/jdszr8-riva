-- EDYCJA TABELI Z DANYMI:

CREATE TABLE projekt.net_salary_per_town_categories (
	CODGEO int4 NULL,
	LIBGEO varchar(32) NULL,
	SNHM14 float4 NULL,
	SNHMC14 float4 NULL,
	SNHMP14 float4 NULL,
	SNHME14 float4 NULL,
	SNHMO14 float4 NULL,
	SNHMF14 float4 NULL,
	SNHMFC14 float4 NULL,
	SNHMFP14 float4 NULL,
	SNHMFE14 float4 NULL,
	SNHMFO14 float4 NULL,
	SNHMH14 float4 NULL,
	SNHMHC14 float4 NULL,
	SNHMHP14 float4 NULL,
	SNHMHE14 float4 NULL,
	SNHMHO14 float4 NULL,
	SNHM1814 float4 NULL,
	SNHM2614 float4 NULL,
	SNHM5014 float4 NULL,
	SNHMF1814 float4 NULL,
	SNHMF2614 float4 NULL,
	SNHMF5014 float4 NULL,
	SNHMH1814 float4 NULL,
	SNHMH2614 float4 NULL,
	SNHMH5014 float4 NULL
);

-- Do tak utworzonej tabeli zaimportowałam dane z pliku. ".." pozbyłam się w Notepad++ (można tam pracować na kolumnach, dzięki czemu przygotowanie zajmuje kilka minut),
-- tak aby nazwy kolumn nie trzeba było wpisywać w cudzysłowie;
-- Przy imporcie całkowicie automatycznym istnieje opcja rozpoznawania znaku 'quatation mark' jako "", próbowałam ją wyłączyć przy imporcie tabeli,
-- ale niestety nie pomogło.
-- 
-- Do każdej kolumny dodaję komentarz:
COMMENT ON COLUMN projekt.net_salary_per_town_categories.codgeo    IS 'unique code of the town';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.libgeo    IS 'name of the town';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHM14    IS 'mean net salary';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMC14   IS 'mean net salary per hour for executive';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMP14   IS 'mean net salary per hour for middle manager';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHME14   IS 'mean net salary per hour for employee';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMO14   IS 'mean net salary per hour for worker';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMF14   IS 'mean net salary for women';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMFC14  IS 'mean net salary per hour for feminin executive';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMFP14  IS 'mean net salary per hour for feminin middle manager';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMFE14  IS 'mean net salary per hour for feminin employee';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMFO14  IS 'mean net salary per hour for feminin worker';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMH14   IS 'mean net salary for man';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMHC14  IS 'mean net salary per hour for masculin executive';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMHP14  IS 'mean net salary per hour for masculin middle manager';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMHE14  IS 'mean net salary per hour for masculin employee';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMHO14  IS 'mean net salary per hour for masculin worker';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHM1814  IS 'mean net salary per hour for 18-25 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHM2614  IS 'mean net salary per hour for 26-50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHM5014  IS 'mean net salary per hour for >50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMF1814 IS 'mean net salary per hour for women between 18-25 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMF2614 IS 'mean net salary per hour for women between 26-50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMF5014 IS 'mean net salary per hour for women >50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMH1814 IS 'mean net salary per hour for men between 18-25 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMH2614 IS 'mean net salary per hour for men between 26-50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMH5014 IS 'mean net salary per hour for men >50 years old'; 

-- CZYSZCZENIE DANYCH:

-- Sprawdzenie, czy w tabelach znajduja się puste komórki

select *
from net_salary_per_town_categories
where codgeo		is null or
	  libgeo        is null or 
 	  SNHM14        is null or 
      SNHMC14       is null or  
      SNHMP14       is null or  
      SNHME14       is null or 
      SNHMO14       is null or 
      SNHMF14       is null or
	  SNHMFC14 		is null or
      SNHMFP14      is null or
      SNHMFE14      is null or
      SNHMFO14      is null or
      SNHMH14       is null or
      SNHMHC14      is null or
      SNHMHP14      is null or
      SNHMHE14 		is null or
      SNHMHO14      is null or
      SNHM1814      is null or
      SNHM2614      is null or
      SNHM5014      is null or
      SNHMF1814     is null or
      SNHMF2614     is null or
      SNHMF5014     is null or
      SNHMH1814     is null or
      SNHMH2614     is null or
      SNHMH5014     is null;


-- W tabeli net_salary_per_town_categories znajduje się jeden rekord (dane dla jednego miasta), w którym brakuje odpowiednich wartości średnich płac.
-- Myśle, że możnaby go po prostu usunąć z tabeli:  
     
DELETE 
FROM net_salary_per_town_categories
WHERE codgeo = 97404;
     
select * 
from net_salary_per_town_categories
where codgeo = 97404;

-- Sprawdzenie unikalności wierszy/wartości codgeo:
select 
	(select distinct 
		count(codgeo)
	from
		net_salary_per_town_categories) as number_of_unique_rows,
	count(codgeo) as number_of_codgeo_numbers,
	count(distinct codgeo) as number_of_unique_codgeo_numbers
from
	net_salary_per_town_categories;

-- W tabeli znajduje się kilka (7)  wierszy, które zawierają inną informacje dla tych samych miast (pod tą samą wartością codgeo). Poniżej staram się je znaleźć i sprawdzić, gdzie powstają różnice 
-- (czy można się pozbyć duplikatów). 

select
  codgeo,
  count(*)
from net_salary_per_town_categories nsptc 
group by
  codgeo
having count(*) > 1;

-- Informacja zawarta w wierszach:

select * from
  (select *, 
  		  count(*) over (partition by codgeo) as number_of_rows
  from net_salary_per_town_categories) duplicated_rows
  where duplicated_rows.number_of_rows > 1;


--Podobnie jak w przypadku innych tabel, źródłem blędów jest kilka miast przypisanych do codgeo =2. 
--Po jej wyłaczeniu z analizy: 
	
select 
	(select distinct 
		count(codgeo)
	from
		net_salary_per_town_categories
	where codgeo != 2) as number_of_unique_rows,
	count(codgeo) as number_of_codgeo_numbers,
	count(distinct codgeo) as number_of_unique_codgeo_numbers
from
	net_salary_per_town_categories
where codgeo != 2;	

-- Tearaz wartości są spójne. Należałoby usunąć wszystkie wiersze, dla których CODGEO = 2:

DELETE 
FROM net_salary_per_town_categories
WHERE codgeo = 2;

-- Sprawdzenie danych w tabeli libgeo (czy nazwy miast są poprawne):
select count(distinct libgeo),
count(libgeo)
from net_salary_per_town_categories nsptc 
where codgeo != 2;

-- Pojawia się kilka duplikatów:
select
  libgeo,
  count(*)
from net_salary_per_town_categories nsptc 
group by
  libgeo
having count(*) > 1;

select * from
  (select *, 
  		  count(*) over (partition by libgeo) as number_of_rows
  from net_salary_per_town_categories) duplicated_rows
where duplicated_rows.number_of_rows > 1;

-- Nazwa miasta nie jest wielkością unikalna - może byc kilka miast o takiej samej nazwie w różnych częściach kraju.
-- Aby upewnić się, że nie jest to błąd, porównuje te wartości z tabelą population, zakładając 
-- że znajdują się tu poprawne nazwy miast:

select distinct
	net_salary_per_town_categories.codgeo, 
	net_salary_per_town_categories.libgeo,
	population.codgeo,
	population.libgeo,
	case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join population
on net_salary_per_town_categories.codgeo = population.codgeo
where net_salary_per_town_categories.codgeo in  
	(select codgeo from
  		(select *, 
  		  		count(*) over (partition by libgeo) as number_of_rows
  		from net_salary_per_town_categories) duplicated_rows
		where duplicated_rows.number_of_rows > 1)
order by net_salary_per_town_categories.libgeo;

-- Część nazw się zgadza,a inne - całkowicie nie. Po porównaniu kolumn należałoby z tabeli net_salary_per_town_categories wyrzucić te, które są 
-- niejednoznaczne tj. codgeo = 49042, 66174,69068,59112,14098, 18223, 45273, 69291, 72299, 26325, 34259, 24256, 33448, 69024, 69052, 69127,69194.
--Zostawiam te, które występują w obu tabelach w takiej samej formie (mimo duplikujących się nazw miejscowości).
 
-- Dokonuje analogicznego porównania z tabelą base_etablissement_par_tranche_effectif:

select distinct
	net_salary_per_town_categories.codgeo, 
	net_salary_per_town_categories.libgeo,
	base_etablissement_par_tranche_effectif."CODGEO",
	base_etablissement_par_tranche_effectif."LIBGEO",
	case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join base_etablissement_par_tranche_effectif
on net_salary_per_town_categories.codgeo = base_etablissement_par_tranche_effectif."CODGEO"
where net_salary_per_town_categories.codgeo in  
	(select codgeo from
  		(select *, 
  		  		count(*) over (partition by libgeo) as number_of_rows
  		from net_salary_per_town_categories) duplicated_rows
		where duplicated_rows.number_of_rows > 1)
order by net_salary_per_town_categories.libgeo;


-- Brak spójności występuje dla tych samych miast. Upewniam się stosując na abu wynikach funkcję UNION:

select distinct
	net_salary_per_town_categories.codgeo, 
	net_salary_per_town_categories.libgeo,
	case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join population
on net_salary_per_town_categories.codgeo = population.codgeo
where net_salary_per_town_categories.codgeo in  
	(select codgeo from
  		(select *, 
  		  		count(*) over (partition by libgeo) as number_of_rows
  		from net_salary_per_town_categories) duplicated_rows
		where duplicated_rows.number_of_rows > 1)
union
select distinct
	net_salary_per_town_categories.codgeo, 
	net_salary_per_town_categories.libgeo,
	case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join base_etablissement_par_tranche_effectif
on net_salary_per_town_categories.codgeo = base_etablissement_par_tranche_effectif."CODGEO"
where net_salary_per_town_categories.codgeo in  
	(select codgeo from
  		(select *, 
  		  		count(*) over (partition by libgeo) as number_of_rows
  		from net_salary_per_town_categories) duplicated_rows
		where duplicated_rows.number_of_rows > 1);

-- Różnica występuje dla rekordu CODGEO = 49042, w jednej tabeli go brakuje, a w drugiej w tym miejscu znajduje się miejscowość Brain-sur-l'Authion.
-- W obu przypadkach wartość jest różna niż dla tabeli net_salary_per_town_categories.
-- Ostatecznie można usunąć te miasta z analizy: 
	
DELETE 
FROM net_salary_per_town_categories
WHERE codgeo in (49042, 66174,69068,59112,14098, 18223, 45273, 69291, 72299, 26325, 34259, 24256, 33448, 69024, 69052, 69127,69194);

-- W dalszej części sprawdzam spójność wszystkich rekordów (nie tylko zduplikowanych) dla tabel net_salary_per_town_categories i population:

select distinct
	net_salary_per_town_categories.codgeo as codgeo_nsptc, 
	net_salary_per_town_categories.libgeo as libgeo_nsptc,
	population.codgeo as codgeo_p,
	population.libgeo as libgeo_p,
	case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join population
on net_salary_per_town_categories.codgeo = population.codgeo
where (case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end) = 'diffrent'
order by net_salary_per_town_categories.libgeo;

-- Analogiczną operacje wykonuje dla tabel net_salary_per_town_categories i base_etablissement_par_tranche_effectif:

select distinct
	net_salary_per_town_categories.codgeo as codgeo_nsptc, 
	net_salary_per_town_categories.libgeo as libgeo_nsptc,
	base_etablissement_par_tranche_effectif."CODGEO" as codgeo_bepte,
	base_etablissement_par_tranche_effectif."LIBGEO" as libgeo_bepte, 
	case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join base_etablissement_par_tranche_effectif
on net_salary_per_town_categories.codgeo = base_etablissement_par_tranche_effectif."CODGEO"
where (case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end) = 'diffrent'
order by net_salary_per_town_categories.libgeo;

-- Znajduje wszystkie rekordy, dla których pojawiają się niespójności w nazwie miasta, w przypadku obu tabel:

select distinct
	net_salary_per_town_categories.codgeo as codgeo_nsptc, 
	net_salary_per_town_categories.libgeo as libgeo_nsptc,
	case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join population
on net_salary_per_town_categories.codgeo = population.codgeo
where (case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end) = 'diffrent'
union
select distinct
	net_salary_per_town_categories.codgeo as codgeo_nsptc, 
	net_salary_per_town_categories.libgeo as libgeo_nsptc,
	case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join base_etablissement_par_tranche_effectif
on net_salary_per_town_categories.codgeo = base_etablissement_par_tranche_effectif."CODGEO"
where (case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end) = 'diffrent';

-- Usuwam wszystkie powyższe rekordy z analizy:

delete 
from net_salary_per_town_categories 
where net_salary_per_town_categories.codgeo in
(
	select distinct
		net_salary_per_town_categories.codgeo as codgeo_nsptc 
	from net_salary_per_town_categories 
	left join population
	on net_salary_per_town_categories.codgeo = population.codgeo
	where (case 
			when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
			else 'diffrent'
		end) = 'diffrent'
union
	select distinct
		net_salary_per_town_categories.codgeo as codgeo_nsptc 
	from net_salary_per_town_categories 
	left join base_etablissement_par_tranche_effectif
	on net_salary_per_town_categories.codgeo = base_etablissement_par_tranche_effectif."CODGEO"
	where (case 
			when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
			else 'diffrent'
		end) = 'diffrent');

	
select count(distinct codgeo) as number_or_remaining_records
from net_salary_per_town_categories nsptc; 

-- Lącznie z tabeli usunęłam informacje o zarobkach dla 133 miast (127 numerów CODGEO). Po obróbce pozostało [%] danych :

select round(count(distinct codgeo)::numeric/(count(distinct codgeo)::numeric+133)*100) as percetage_of_remaining_data
from net_salary_per_town_categories nsptc; 
