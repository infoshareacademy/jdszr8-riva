---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
-----ANALYSIS BY REGIONS---
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
---------------------------
--average earnings per region (the arithmetic average of all occurrences in the table of salaries) and therefore the average of the average
--earnings are best in Paris region, worst in Saint Denis region
--note: the table shows the earnings of those already employed, but ignores the problem of unemployment
--theoretically, there can be a case that there are high wages with high unemployment
--an interesting case is that of the Cayenne region, which, with a very small population, is in third place in terms of average earnings
--French Guiana is located in South America and the space station is located there --accounts for a large part of GDP
--the rest of the economy is agriculture, fishing, timber
--not surprisingly, the first place of the Paris region and the high place of the other two largest agglomerations: Marseilles and Lyon

--creating a view
create
or replace view v_region_distinct as (
  select
    distinct g.code_insee,
    g.code_région,
    g."chef.lieu_région"
  from
    geography g
  order by
    g.code_région,
    g.code_insee
);

--exploring the view
select
  count(*),
  count(distinct code_insee)
from
  v_region_distinct vrd;

 --creating a view
create
or replace view v_cities_distinct as (
  select
    distinct g.code_insee,
    g.nom_commune
  from
    geography g
  order by
    g.code_insee
);

--creating a view
create
or replace view v_population_per_city as (
  select
    p.codgeo,
    sum(p.nb) as nb
  from
    population p
  group by
    p.codgeo
  order by
    p.codgeo
);

--statistic box per region
select
  vrd."chef.lieu_région",
  sum(vppc.nb) populacja,
  round(sum(vcws.e14ts200_500) / (sum(vppc.nb) / 100000), 1) duze_firmy_na_100t,
  round(
    percentile_cont(0.5) within group (
      order by
        s.snhm14
    ):: numeric,
    1
  ) median_salary,
  round(
    percentile_cont(0.25) within group (
      order by
        s.snhm14
    ):: numeric,
    1
  ) kwartyl_1_salary,
  round(
    percentile_cont(0.75) within group (
      order by
        s.snhm14
    ):: numeric,
    1
  ) kwartyl_3_salary,
  round(
    percentile_cont(0.75) within group (
      order by
        s.snhm14
    ):: numeric,
    1
  ) - round(
    percentile_cont(0.25) within group (
      order by
        s.snhm14
    ):: numeric,
    1
  ) rozstep_kwartylny,
  round(avg(s.snhm14):: numeric, 1) mean_salary,
  round(min(s.snhm14):: numeric, 1) min_salary,
  round(max(s.snhm14):: numeric, 1) max_salary
from
  salaries s
  join v_companies_with_size vcws on s.codgeo = vcws.codgeo
  join v_cities_distinct vcd on s.codgeo = vcd.code_insee
  join v_region_distinct vrd on s.codgeo = vrd.code_insee
  join v_population_per_city vppc on s.codgeo = vppc.codgeo
group by
  vrd."chef.lieu_région"
order by
  round(
    percentile_cont(0.5) within group (
      order by
        s.snhm14
    ):: numeric,
    1
  ) desc;

with
  regions_for_correlation as (
    select
      vrd."chef.lieu_région",
      sum(vppc.nb) populacja,
      round(sum(vcws.e14ts200_500) / (sum(vppc.nb) / 100000), 1) duze_firmy_na_100t,
      round(
        percentile_cont(0.5) within group (
          order by
            s.snhm14
        ):: numeric,
        1
      ) median_salary,
      round(
        percentile_cont(0.25) within group (
          order by
            s.snhm14
        ):: numeric,
        1
      ) kwartyl_1_salary,
      round(
        percentile_cont(0.75) within group (
          order by
            s.snhm14
        ):: numeric,
        1
      ) kwartyl_3_salary,
      round(
        percentile_cont(0.75) within group (
          order by
            s.snhm14
        ):: numeric,
        1
      ) - round(
        percentile_cont(0.25) within group (
          order by
            s.snhm14
        ):: numeric,
        1
      ) rozstep_kwartylny,
      round(avg(s.snhm14):: numeric, 1) mean_salary,
      round(min(s.snhm14):: numeric, 1) min_salary,
      round(max(s.snhm14):: numeric, 1) max_salary
    from
      salaries s
      join v_companies_with_size vcws on s.codgeo = vcws.codgeo
      join v_cities_distinct vcd on s.codgeo = vcd.code_insee
      join v_region_distinct vrd on s.codgeo = vrd.code_insee
      join v_population_per_city vppc on s.codgeo = vppc.codgeo
    group by
      vrd."chef.lieu_région"
    order by
      round(
        percentile_cont(0.5) within group (
          order by
            s.snhm14
        ):: numeric,
        1
      ) desc
  )
select
  corr(populacja, median_salary)
from
  regions_for_correlation;

--salary in Paris region
select
  s.*
from
  salaries s
  join v_region_distinct vrd on s.codgeo = vrd.code_insee
where
  vrd."chef.lieu_région" = 'Paris'
order by
  s.snhm14 desc;

--salary in Paris
select
  s.*
from
  salaries s
  join v_region_distinct vrd on s.codgeo = vrd.code_insee
  join v_cities_distinct vcd on s.codgeo = vcd.code_insee
where
  vrd."chef.lieu_région" = 'Paris'
  and vcd.nom_commune = 'Paris'
order by
  s.snhm14 desc;

--export data to csv file // note that file location is a local path
copy (
  select
    vrd."chef.lieu_région",
    sum(vppc.nb) populacja,
    round(sum(vcws.e14ts200_500) / (sum(vppc.nb) / 100000), 1) duze_firmy_na_100t,
    round(
      percentile_cont(0.5) within group (
        order by
          s.snhm14
      ):: numeric,
      1
    ) median_salary,
    round(
      percentile_cont(0.25) within group (
        order by
          s.snhm14
      ):: numeric,
      1
    ) kwartyl_1_salary,
    round(
      percentile_cont(0.75) within group (
        order by
          s.snhm14
      ):: numeric,
      1
    ) kwartyl_3_salary,
    round(
      percentile_cont(0.75) within group (
        order by
          s.snhm14
      ):: numeric,
      1
    ) - round(
      percentile_cont(0.25) within group (
        order by
          s.snhm14
      ):: numeric,
      1
    ) rozstep_kwartylny,
    round(avg(s.snhm14):: numeric, 1) mean_salary,
    round(min(s.snhm14):: numeric, 1) min_salary,
    round(max(s.snhm14):: numeric, 1) max_salary
  from
    salaries s
    join v_companies_with_size vcws on s.codgeo = vcws.codgeo
    join v_cities_distinct vcd on s.codgeo = vcd.code_insee
    join v_region_distinct vrd on s.codgeo = vrd.code_insee
    join v_population_per_city vppc on s.codgeo = vppc.codgeo
  group by
    vrd."chef.lieu_région"
  order by
    round(
      percentile_cont(0.5) within group (
        order by
          s.snhm14
      ):: numeric,
      1
    ) desc
) to 'C:\Users\aronm\OneDrive\Pulpit\france.csv' delimiter ',' csv header;

--median for capital of region and information about population
select
  s.codgeo as city_kod,
  s.libgeo,
  sum(vppc.nb) populacja,
  avg(s.snhm14) median_salary --avergae from one record
from
  salaries s
  join v_population_per_city vppc on s.codgeo = vppc.codgeo
where
  s.codgeo in (
    select
      distinct g.code_insee as city_kod
    from
      geography g
    where
      g."chef.lieu_région" = g.nom_commune
  )
group by
  s.codgeo,
  s.libgeo
order by
  populacja desc;

--export data to csv file // note that file location is a local path
copy (
  select
    s.codgeo as city_kod,
    s.libgeo,
    sum(vppc.nb) populacja,
    avg(s.snhm14) median_salary --avergae from one record
  from
    salaries s
    join v_population_per_city vppc on s.codgeo = vppc.codgeo
  where
    s.codgeo in (
      select
        distinct g.code_insee as city_kod
      from
        geography g
      where
        g."chef.lieu_région" = g.nom_commune
    )
  group by
    s.codgeo,
    s.libgeo
  order by
    populacja desc
) to 'C:\Users\aronm\OneDrive\Pulpit\export.csv' delimiter ',' csv header;

--lack of salaries for two overseas territory 
select
  *
from
  salaries s
where
  s.codgeo in (
    select
      distinct vrd.code_insee
    from
      v_region_distinct vrd
    where
      vrd.code_région in(5, 6)
  );

--correlation between capital of region and salaries
select
  corr(populacja, median_salary)
from
  (
    select
      s.codgeo as city_kod,
      s.libgeo,
      sum(vppc.nb) populacja,
      avg(s.snhm14) median_salary --avergae from one record
    from
      salaries s
      join v_population_per_city vppc on s.codgeo = vppc.codgeo
    where
      s.codgeo in (
        select
          distinct g.code_insee as city_kod
        from
          geography g
        where
          g."chef.lieu_région" = g.nom_commune
      )
    group by
      s.codgeo,
      s.libgeo
    order by
      populacja desc
  ) numbers;

--check for diff between regions and capitals
with
  regions as (
    select
      vrd."chef.lieu_région",
      round(
        percentile_cont(0.5) within group (
          order by
            s.snhm14
        ):: numeric,
        1
      ) median_salary
    from
      salaries s
      join v_companies_with_size vcws on s.codgeo = vcws.codgeo
      join v_cities_distinct vcd on s.codgeo = vcd.code_insee
      join v_region_distinct vrd on s.codgeo = vrd.code_insee
      join v_population_per_city vppc on s.codgeo = vppc.codgeo
    group by
      vrd."chef.lieu_région"
    order by
      round(
        percentile_cont(0.5) within group (
          order by
            s.snhm14
        ):: numeric,
        1
      ) desc
  ),
  capitals as (
    select
      s.codgeo as city_kod,
      s.libgeo,
      sum(vppc.nb) populacja,
      avg(s.snhm14) median_salary --avergae from one record
    from
      salaries s
      join v_population_per_city vppc on s.codgeo = vppc.codgeo
    where
      s.codgeo in (
        select
          distinct g.code_insee as city_kod
        from
          geography g
        where
          g."chef.lieu_région" = g.nom_commune
      )
    group by
      s.codgeo,
      s.libgeo
    order by
      populacja desc
  )
select
  r."chef.lieu_région",
  r.median_salary as region_salary,
  c.median_salary as capital_salary,
  c.median_salary - r.median_salary as diff,
  round(
    (
      c.median_salary:: numeric / r.median_salary:: numeric - 1
    ) * 100,
    0
  ) as perc_diff
from
  regions r
  join capitals c on r."chef.lieu_région" = c.libgeo;