use charles;

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
DROP TEMPORARY TABLE IF EXISTS joinedData;
;
CREATE TEMPORARY TABLE joinedData (
  select * from momconnect_2month as a
  join facilities as b 
  on a.`Facility.code` = b.facilitycode
)
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
SELECT province,
count(*) as total, 
SUM(CASE WHEN Language = 'eng_ZA' THEN 1 ELSE 0 END) AS English,
SUM(CASE WHEN Language = 'xho_ZA' THEN 1 ELSE 0 END) AS Xhosa,
SUM(CASE WHEN Language = 'afr_ZA' THEN 1 ELSE 0 END) AS Afrikaans
from joinedData 
WHERE NOT (`ID.Number` = 'Unavailable') 
AND NOT (EDD = 'Unavailable') 
AND NOT (facilitycode = 'Unavailable') 
AND province in ('wc Western Cape Province','ec Eastern Cape Province','kz KwaZulu-Natal Province')
group by province
order by total desc
;

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

#here we filter the table by the individual provinces that have given consent as well as language. i.e. we randomly allocate at the language level
#but across all provinces. So provinces that have larger populations will have higher representation.
;
DROP TEMPORARY TABLE IF EXISTS tEng,tAfr,tXho;
CREATE TEMPORARY TABLE tEng (
  SELECT *,rand() as s
  from joinedData 
  WHERE NOT (`ID.Number` = 'Unavailable') 
  AND NOT (EDD = 'Unavailable') 
  AND province in ('gp Gauteng Province','ec Eastern Cape Province','kz KwaZulu-Natal Province')
  AND Language = 'eng_ZA'
)
;
CREATE TEMPORARY TABLE tXho (
  SELECT *,rand() as s
  from joinedData 
  WHERE NOT (`ID.Number` = 'Unavailable') 
  AND NOT (EDD = 'Unavailable') 
  AND province in ('gp Gauteng Province','ec Eastern Cape Province','kz KwaZulu-Natal Province')
  AND Language = 'xho_ZA'
)
;
CREATE TEMPORARY TABLE tAfr (
  SELECT *,rand() as s
  from joinedData 
  WHERE NOT (`ID.Number` = 'Unavailable') 
  AND NOT (EDD = 'Unavailable') 
  AND province in ('gp Gauteng Province','ec Eastern Cape Province','kz KwaZulu-Natal Province')
  AND Language = 'afr_ZA'
)
;
select * from (
  select * from tEng
  UNION ALL
  select * from tXho
  UNION ALL
  select * from tAfr
  ) as a
  where a.s < 0.1
;




  SUM(CASE WHEN p.prod_name = 'Pants' THEN s.quantity ELSE 0 END) AS Pants,
  SUM(CASE WHEN p.prod_name = 'Shirt' THEN s.quantity ELSE 0 END) AS Shirt
