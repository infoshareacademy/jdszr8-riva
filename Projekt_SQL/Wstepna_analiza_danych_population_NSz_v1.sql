-- EDYCJA TABELI Z DANYMI:
-- Dla kolumny population wygodniej jest po prostu zmienić nazwy kolumn niż importować jeszcze raz dane:

ALTER TABLE projekt.population RENAME COLUMN "NIVGEO" TO nivgeo;
ALTER TABLE projekt.population RENAME COLUMN "CODGEO" TO codgeo;
ALTER TABLE projekt.population RENAME COLUMN "LIBGEO" TO libgeo;
ALTER TABLE projekt.population RENAME COLUMN "MOCO" TO moco;
ALTER TABLE projekt.population RENAME COLUMN "AGEQ80_17" TO ageq80_17;
ALTER TABLE projekt.population RENAME COLUMN "SEXE" TO sexe;
ALTER TABLE projekt.population RENAME COLUMN "NB" TO nb;

-- Też dodaję do niej komentarze:

COMMENT ON COLUMN projekt.population.nivgeo    IS 'geographic level (arrondissement, communes…)';
COMMENT ON COLUMN projekt.population.codgeo    IS 'unique code for the town';
COMMENT ON COLUMN projekt.population.libgeo    IS 'name of the town (might contain some utf-8 errors, this information has better quality namegeographicinformation)';
COMMENT ON COLUMN projekt.population.moco      IS 'cohabitation mode : [list and meaning available in Data description]';
COMMENT ON COLUMN projekt.population.ageq80_17 IS 'age category (slice of 5 years) | ex : 0 -> people between 0 and 4 years old';
COMMENT ON COLUMN projekt.population.sexe      IS 'sex, 1 for men | 2 for women';
COMMENT ON COLUMN projekt.population.nb        IS 'number of people in the category';

-- CZYSZCZENIE DANYCH:
-- Czyszczenie tabeli population wykonuje pod wcześniej przygotowaną tabelę net_salary_per_town_categories
-- Sprawdzenie, czy w tabeli znajdują się puste komorki
select *
from population
where nivgeo is null or 
 	  codgeo is null or 
      libgeo is null or  
      moco is null or  
      ageq80_17 is null or 
      sexe is null or 
      nb is null;

-- W tabeli population brak jakichkolwiek pustych komórek.
     
-- Sprawdzenie unikalności wierszy/wartości codgeo:
select 
	(select distinct 
		count(codgeo)
	from
		population) as number_of_unique_rows,
	count(codgeo) as number_of_codgeo_numbers,
	count(distinct codgeo) as number_of_unique_codgeo_numbers
from
	population;

-- Myśle, że w tabeli population wartość codgeo nie powinna byc unikalna. Tutaj, każdy wiersz to inna grupa:
-- (np. w jednym, danym mieście mamy ileś rodziców wychowujących dziecko samotnie, ileś bezdzietnych par, 
-- ileś ludzi w wieku > 50 lat mieszkających samotnie itd.). Ważne, że wiersze są unikalne - w ogólnym podejściu nie ma dwóch identycznych
-- (jeśli nie wynika to z literówek/błędów). 

select count(distinct codgeo)
from population;
-- Daje wynik 35 509

select count(distinct codgeo)
from net_salary_per_town_categories nsptc; 
-- Daje wynik 2187

select count(distinct "CODGEO")
from base_etablissement_par_tranche_effectif bepte;  
-- Daje wynik 36 322

-- W tabeli z kluczowymi dla analizy danymi, net_salary_per_town_categories, znajdują się informacje o zarobkach dla 2079 różnych miast
--  (po usunięciu 127 rekordów [danych dla 133 miast] na etapie czyszczenia tabeli). Tabele można pozostawić w takiej formie jakiej są: w przypadku łączenia ich z miastami
-- (wartościami CODGEO), które występują w tabeli net_salary_per_town_categories trzeba użyć funkcji LEFT JOIN. W ten sposób korzystać będziemy jedynie 
-- z wartości obecnych w obu tabelach.





