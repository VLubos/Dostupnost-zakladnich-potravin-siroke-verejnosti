--Skript k otázce číslo 1:
CREATE VIEW t_Lubos_Vavruska_project_SQL_primary_final AS
SELECT 
    cp.value AS mzda,
    cpib.name AS odvetvi,
    cp.payroll_year AS rok
FROM czechia_payroll cp 
JOIN czechia_payroll_industry_branch cpib 
    ON cp.industry_branch_code = cpib.code
WHERE 
    cp.value IS NOT NULL 
    AND cpib.name IS NOT NULL 
    AND cp.value_type_code ='5958'
GROUP BY odvetvi, rok
ORDER BY odvetvi ASC, rok ASC;

--Skript k otázce číslo 2:
CREATE VIEW t_Lubos_Vavruska_project_SQL_primary_final AS
    SELECT 
        cp.payroll_year AS rok,
        AVG(cp.value) AS prumerna_mzda,
        cpc.name AS polozka,
        cp.industry_branch_code AS odvetvi,
        (cp.value/ czpr.value) AS pocet_jednotek_dostupnych_za_mzdu
    FROM czechia_payroll cp 
    JOIN czechia_price czpr
    ON cp.payroll_year = YEAR(czpr.date_from) 
JOIN czechia_price_category cpc
    ON czpr.category_code = cpc.code
WHERE 
    (cpc.name = 'Mléko polotučné pasterované' 
    OR cpc.name = 'Chléb konzumní kmínový') 
    AND cp.value IS NOT NULL 
    AND cp.payroll_year BETWEEN '2006' AND '2018' 
    AND cp.value_type_code ='5958'
GROUP BY rok;

--Skript k otázce číslo 3:
CREATE VIEW t_Lubos_Vavruska_project_SQL_primary_final AS
SELECT 
    AVG(czpr.value) AS prumerna_cena_polozky,
    YEAR(czpr.date_from) AS rok,
    MIN(czpr.value) AS minimalni_cena,
    czpr.value/MIN(czpr.value) AS narust_2018_proti_min_cene
FROM czechia_price czpr
JOIN czechia_price_category cpc
    ON czpr.category_code = cpc.code
WHERE YEAR(czpr.date_from) = '2018'
GROUP BY cpc.name
ORDER BY narust_2018_proti_min_cene ASC 
LIMIT 1;

--Skript k otázce číslo 4:
CREATE VIEW t_Lubos_Vavruska_project_SQL_primary_final AS
SELECT 
    AVG(cp.value) AS prumerna_mzda,
	  SUM(czpr.value) AS nakupni_kosik,
	  cp.payroll_year AS rok,
    SUM(czpr.value)/ AVG(cp.value) AS zmena_ceny_vs_mzdy
FROM czechia_payroll cp 
JOIN czechia_price czpr
    ON cp.payroll_year = YEAR(czpr.date_from) 
WHERE 
    cp.value IS NOT NULL 
    AND cp.payroll_year BETWEEN '2006' 
    AND '2018' 
    AND cp.value_type_code ='5958'
GROUP BY rok
ORDER BY rok ASC;

--Skript k otázce číslo 5 (pro Českou republiku):
CREATE VIEW t_Lubos_Vavruska_project_SQL_primary_final AS
SELECT 
    AVG(cp.value) AS prumerna_mzda,
    SUM(czpr.value) AS nakupni_kosik,
    cp.payroll_year AS rok,
    AVG(cp.value)/SUM(czpr.value) AS kupni_sila,
    e.GDP AS HDP    
FROM czechia_payroll cp 
JOIN czechia_price czpr
    ON cp.payroll_year = YEAR(czpr.date_from) 
JOIN economies e
    ON cp.payroll_year = e.year 
WHERE 
    cp.value IS NOT NULL 
    AND cp.payroll_year BETWEEN '2006' AND '2018' 
    AND cp.value_type_code ='5958' 
    AND e.country = 'Czech Republic'
GROUP BY rok
ORDER BY rok ASC;

--Pomocná tabulka s informacemi o evropských státech a vývoji HDP:
CREATE VIEW t_Lubos_Vavruska_project_SQL_secondary_final AS
SELECT 
    country, 
    e.year,
    GDP
FROM economies e
WHERE 
    GDP IS NOT NULL 
    AND country LIKE '%eur%'
GROUP BY 
    country,
    e.year
ORDER BY 
    e.year ASC,
    country ASC;



