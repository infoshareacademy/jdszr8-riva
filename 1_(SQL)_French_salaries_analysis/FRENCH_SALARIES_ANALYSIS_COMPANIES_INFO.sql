---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
----COMPANIES IN FRANCE----
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------

--exploring data
select
  *
from
  companies c;

--exploring data
select
  count(*),
  count(distinct codgeo)
from
  companies c;

--total no of companies in France
select
  sum(c.e14tst)
from
  companies c;

--create view with grouped companies size
create view v_companies_grouped as
select
  c.codgeo,
  c.e14tst,
  c.e14ts0nd,
  e14ts1 + e14ts6 as e14ts1_6,
  e14ts10 + e14ts20 as e14ts10_20,
  e14ts50 + e14ts100 as e14ts50_100,
  e14ts200 + e14ts500 as e14ts200_500
from
  companies c
order by
  c.codgeo;

--create view with grouped companies size onyly for companies that size is known
create view v_companies_with_size as
select
  c.codgeo,
  e14ts1 + e14ts6 as e14ts1_6,
  e14ts10 + e14ts20 as e14ts10_20,
  e14ts50 + e14ts100 as e14ts50_100,
  e14ts200 + e14ts500 as e14ts200_500,
  c.e14tst - c.e14ts0nd as e14ts1_500
from
  companies c
order by
  c.codgeo;

--the vast majority of companies are of unknown size
--unknown companies 67.7%
--micro companies 26.3%
--if we assume that the unknown size of companies are micro companies, then 67.7%+26.3% = 94%
--small companies 4.9%
--medium companies 0.9%
--large companies 0.2%
select
  sum(v.e14tst) total,
  sum(v.e14ts0nd) nieznane,
  sum(v.e14ts1_6) mikro,
  sum(v.e14ts10_20) male,
  sum(v.e14ts50_100) srednie,
  sum(v.e14ts200_500) duze,
  round(sum(v.e14ts0nd) * 1.0 / sum(v.e14tst) * 100, 1) nieznane_pct,
  --iloczyn z 1.0 zamienia integera na float
  round(sum(v.e14ts1_6) * 1.0 / sum(v.e14tst) * 100, 1) mikro_pct,
  round(sum(v.e14ts10_20) * 1.0 / sum(v.e14tst) * 100, 1) male_pct,
  round(sum(v.e14ts50_100) * 1.0 / sum(v.e14tst) * 100, 1) srednie_pct,
  round(sum(v.e14ts200_500) * 1.0 / sum(v.e14tst) * 100, 1) duze_pct,
  round(sum(v.e14ts0nd) * 1.0 / sum(v.e14tst) * 100, 1) + round(sum(v.e14ts1_6) * 1.0 / sum(v.e14tst) * 100, 1) nieznane_i_mikro_pct
from
  v_companies_grouped v;

--with the omission of the unknown size, the structure is shaped as follows
--micro companies 81.5%
--small companies 15.3%
--medium companies 2.7%
--large companies 0.6%
select
  sum(v.e14tst) - sum(v.e14ts0nd) total_bez_nieznanych,
  sum(v.e14ts1_6) mikro,
  sum(v.e14ts10_20) male,
  sum(v.e14ts50_100) srednie,
  sum(v.e14ts200_500) duze,
  round(
    sum(v.e14ts1_6) * 1.0 / (sum(v.e14tst) - sum(v.e14ts0nd)) * 100,
    1
  ) mikro_pct,
  round(
    sum(v.e14ts10_20) * 1.0 / (sum(v.e14tst) - sum(v.e14ts0nd)) * 100,
    1
  ) male_pct,
  round(
    sum(v.e14ts50_100) * 1.0 / (sum(v.e14tst) - sum(v.e14ts0nd)) * 100,
    1
  ) srednie_pct,
  round(
    sum(v.e14ts200_500) * 1.0 / (sum(v.e14tst) - sum(v.e14ts0nd)) * 100,
    1
  ) duze_pct
from
  v_companies_grouped v;

--conclusion: French society is largely based on small businesses, despite a large economy and large industry
--in the data there is no information on the number of people employed in these companies
--there is only information about the number of companies
--it is impossible to show how many employees on average a company employs in france
--in cities with more than 50,000 inhabitants also dominated by small businesses
select
  p.codgeo,
  g.nom_commune as city,
  sum(p.nb) as city_population,
  round(sum(v.e14ts0nd) * 1.0 / sum(v.e14tst) * 100, 1) nieznane_pct,
  round(sum(v.e14ts1_6) * 1.0 / sum(v.e14tst) * 100, 1) mikro_pct,
  round(sum(v.e14ts10_20) * 1.0 / sum(v.e14tst) * 100, 1) male_pct,
  round(sum(v.e14ts50_100) * 1.0 / sum(v.e14tst) * 100, 1) srednie_pct,
  round(sum(v.e14ts200_500) * 1.0 / sum(v.e14tst) * 100, 1) duze_pct,
  round(sum(v.e14ts0nd) * 1.0 / sum(v.e14tst) * 100, 1) + round(sum(v.e14ts1_6) * 1.0 / sum(v.e14tst) * 100, 1) nieznane_i_mikro_pct
from
  geography g
  join population p on g.code_insee = p.codgeo
  join v_companies_grouped v on g.code_insee = v.codgeo
group by
  p.codgeo,
  g.nom_commune
having
  sum(p.nb) >= 50000
order by
  sum(p.nb) desc;


--correlation between no of medium and big companies and city size is close to zero
with
  data_for_cities_over_1k as (
    select
      p.codgeo,
      g.nom_commune as city,
      sum(p.nb) as city_population,
      round(sum(v.e14ts0nd) * 1.0 / sum(v.e14tst) * 100, 1) nieznane_pct,
      round(sum(v.e14ts1_6) * 1.0 / sum(v.e14tst) * 100, 1) mikro_pct,
      round(sum(v.e14ts10_20) * 1.0 / sum(v.e14tst) * 100, 1) male_pct,
      round(sum(v.e14ts50_100) * 1.0 / sum(v.e14tst) * 100, 1) srednie_pct,
      round(sum(v.e14ts200_500) * 1.0 / sum(v.e14tst) * 100, 1) duze_pct,
      round(sum(v.e14ts0nd) * 1.0 / sum(v.e14tst) * 100, 1) + round(sum(v.e14ts1_6) * 1.0 / sum(v.e14tst) * 100, 1) nieznane_i_mikro_pct
    from
      geography g
      join population p on g.code_insee = p.codgeo
      join v_companies_grouped v on g.code_insee = v.codgeo
    group by
      p.codgeo,
      g.nom_commune
    having
      sum(p.nb) >= 1000
    order by
      sum(p.nb) desc
  )
select
  codgeo,
  city,
  city_population,
  srednie_pct + duze_pct as srednie_i_duze,
  corr(city_population, srednie_pct + duze_pct) over () as korelacja_populacja_a_wieksze_firmy
from
  data_for_cities_over_1k d;

--general numbers for France // nubmer_of_companies
select
  (
    select
      sum(c.e14tst)
    from
      companies c
  ) as liczba_firm
from
  companies c;

--general numbers for France // nubmer_of_companies
select
  sum(c.e14tst)
from
  companies c;

--general numbers for France // population
select
  sum(p.nb) / 100000 as population_in_100k
from
  population p;

--general numbers for France // number of companies per 100k citizens
with
  mianownik as (
    select
      sum(c.e14tst) as mianownik_number
    from
      companies c
  ),
  licznik as (
    select
      sum(p.nb) / 100000 as licznik_number
    from
      population p
  )
select
  round(
    mianownik_number:: numeric / licznik_number:: numeric,
    0
  )
from
  mianownik,
  licznik;

--top10 cities
select
  vppc.codgeo sum(vppc.nb)
from
  v_population_per_city vppc
group by
  vppc.codgeo
order by
  sum(vppc.nb) desc
limit
  10;

select
  sum(c.e14tst)
from
  companies c
where
  c.codgeo in (
    select
      vppc.codgeo
    from
      v_population_per_city vppc
    group by
      vppc.codgeo
    order by
      sum(vppc.nb) desc
    limit
      10
  );

--no of companies in Paris (city code = 75056)
select
  sum(c.e14tst)
from
  companies c
where
  c.codgeo = '75056';