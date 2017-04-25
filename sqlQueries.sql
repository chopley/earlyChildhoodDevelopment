use charles;
DROP TEMPORARY TABLE IF EXISTS joinedData;
;
CREATE TEMPORARY TABLE joinedData (
  select * from momconnect_2month as a
  join facilities as b 
  on a.`Facility.code` = b.facilitycode
)
;
CREATE TEMPORARY TABLE joinedData_1month (
  select * from momconnect as a
  join facilities as b 
  on a.`Facility.code` = b.facilitycode
)
;
SELECT distinct(province) from joinedData 
;
SELECT province,
count(*) as total, 
SUM(CASE WHEN Language = 'eng_ZA' THEN 1 ELSE 0 END) AS English,
SUM(CASE WHEN Language = 'xho_ZA' THEN 1 ELSE 0 END) AS Xhosa,
SUM(CASE WHEN Language = 'afr_ZA' THEN 1 ELSE 0 END) AS Afrikaans
from joinedData_1month 
WHERE NOT (`ID.Number` = 'Unavailable') 
AND NOT (EDD = 'Unavailable') 
AND NOT (facilitycode = 'Unavailable') 
AND province in ('wc Western Cape Province','ec Eastern Cape Province','kz KwaZulu-Natal Province','fs Free State Province','gp Gauteng Province',
'lp Limpopo Province','mp Mpumalanga Province','nw North West Province','nc Northern Cape Province')
group by province
order by total desc
;
SELECT count(*) as total
from joinedData_1month
WHERE NOT (`ID.Number` = 'Unavailable') 
AND NOT (EDD = 'Unavailable') 
AND NOT (facilitycode = 'Unavailable') 
AND province in ('wc Western Cape Province','ec Eastern Cape Province','kz KwaZulu-Natal Province','fs Free State Province','gp Gauteng Province',
'lp Limpopo Province','mp Mpumalanga Province','nw North West Province','nc Northern Cape Province')
;
SELECT province,
count(*) as total, 
SUM(CASE WHEN EDD between '2016-02-01' and '2016-02-28' THEN 1 ELSE 0 END) AS Feb2016,
SUM(CASE WHEN EDD between '2016-03-01' and '2016-03-28' THEN 1 ELSE 0 END) AS March2016,
SUM(CASE WHEN EDD between '2016-04-01' and '2016-04-28' THEN 1 ELSE 0 END) AS April2016,
SUM(CASE WHEN EDD between '2016-05-01' and '2016-05-28' THEN 1 ELSE 0 END) AS May2016
from joinedData 
WHERE NOT (`ID.Number` = 'Unavailable') 
AND NOT (EDD = 'Unavailable') 
AND NOT (facilitycode = 'Unavailable') 
group by province
order by total desc
;



;
select max(EDD) from momconnect where not EDD='Unavailable' limit 10
;
CREATE VIEW idavailable AS (select * from momconnect where not `ID.Number` = 'Unavailable' );
;
CREATE VIEW english AS (select * from idavailable where Language = 'eng_ZA')
;
CREATE VIEW afrikaans AS (select * from idavailable where Language = 'afr_ZA')
;
CREATE VIEW xhosa AS (select * from idavailable where Language = 'xho_ZA')
;
select distinct(Language) from idavailable
;
select count(*) from idavailable group by Language
;
ALTER TABLE facilities CHANGE row_names row_names_facilities varchar(10) ;
;

 select facility, count(*) as count from joinedData group by facility order by count desc
 
;
SELECT Province,
count(*) as total, 
SUM(CASE WHEN Language = 'eng_ZA' THEN 1 ELSE 0 END) AS English,
SUM(CASE WHEN Language = 'xho_ZA' THEN 1 ELSE 0 END) AS Xhosa,
SUM(CASE WHEN Language = 'afr_ZA' THEN 1 ELSE 0 END) AS Afrikaans
from joinedData 
WHERE NOT (`ID.Number` = 'Unavailable') 
AND NOT (EDD = 'Unavailable') 
AND NOT (facilitycode = 'Unavailable') 
AND EDD between '2016-04-01' and '2016-04-28'
group by Province
;




#here we filter the table by the individual provinces that have given consent as well as language. i.e. we randomly allocate at the language level
#but across all provinces. So provinces that have larger populations will have higher representation.

;
AND province in ('wc Western Cape Province','ec Eastern Cape Province','kz KwaZulu-Natal Province','nw North West Province','nc Northern Cape Province')
;
Northern Cape, North West, Western Cape, KZN and ECape 
;
DROP TEMPORARY TABLE IF EXISTS tEng,tAfr,tXho;
CREATE TEMPORARY TABLE tEng (
  SELECT *,rand() as s
  from joinedData
  WHERE NOT (`ID.Number` = 'Unavailable') 
  AND NOT (EDD = 'Unavailable') 
  AND province in ('wc Western Cape Province','ec Eastern Cape Province','kz KwaZulu-Natal Province','nw North West Province','nc Northern Cape Province')
  AND Language = 'eng_ZA'
#count 3704 ratio = 200/3704 = 0.05399568
# 220/3704 = 0.05939525
)
;
CREATE TEMPORARY TABLE tXho (
  SELECT *,rand() as s
  from joinedData 
  WHERE NOT (`ID.Number` = 'Unavailable') 
  AND NOT (EDD = 'Unavailable') 
  AND province in ('wc Western Cape Province','ec Eastern Cape Province','kz KwaZulu-Natal Province','nw North West Province','nc Northern Cape Province')
  AND Language = 'xho_ZA'
)
#count 1786 ratio = 200/1786 = 0.1119821
#220/1786 0.123
;
CREATE TEMPORARY TABLE tAfr (
  SELECT *,rand() as s
  from joinedData 
  WHERE NOT (`ID.Number` = 'Unavailable') 
  AND NOT (EDD = 'Unavailable') 
  AND province in ('wc Western Cape Province','ec Eastern Cape Province','kz KwaZulu-Natal Province','nw North West Province','nc Northern Cape Province')
  AND Language = 'afr_ZA'
)
#count 425 - ratio = 200/425 = 0.4705882
#220/425 0.5176471
;


DROP TEMPORARY TABLE IF EXISTS rEng;
CREATE TEMPORARY TABLE rEng (
  select * from tEng
  where s <0.0593
)
;
DROP TEMPORARY TABLE IF EXISTS rXho
;
CREATE TEMPORARY TABLE rXho (
  select * from tXho
  where s <0.123
)

;
DROP TEMPORARY TABLE IF EXISTS rAfr
;
CREATE TEMPORARY TABLE rAfr (
  select * from tAfr
  where s <0.518
)
;
select count(*)from (
  select * from rEng
  UNION ALL
  select * from rXho
  UNION ALL
  select * from rAfr
  ) as a
;

CREATE TEMPORARY TABLE random_alloc (
  select * from 
  (select * from rEng
  UNION ALL
  select * from rXho
  UNION ALL
  select * from rAfr
  ) as a
)

;
select * from random_alloc limit 10
;
select * from unique_sa_clinical_facilities limit 10

;
select * from random_alloc as a
join south_africa_clinical_facilities	
on a.



;
