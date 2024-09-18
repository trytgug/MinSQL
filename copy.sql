medium pred: SELECT singer.name, singer.song_release_year FROM singer WHERE age = ( SELECT MIN(age) FROM singer )
medium gold: SELECT song_name ,  song_release_year FROM singer ORDER BY age LIMIT 1

medium pred: SELECT singer.name, singer.song_release_year FROM singer WHERE singer.age = ( SELECT MIN(age) FROM singer )
medium gold: SELECT song_name ,  song_release_year FROM singer ORDER BY age LIMIT 1

*** 列名错

medium pred: SELECT MAX(capacity), AVG(capacity) FROM stadium;
medium gold: select max(capacity), average from stadium

*** 平均取值错

hard pred: SELECT COUNT(*) FROM student JOIN has_pet ON student.stuid = has_pet.stuid JOIN pets ON has_pet.petid = pets.petid WHERE student.sex = 'female' AND pets.pettype = 'dog';
hard gold: SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T2.petid  =  T3.petid WHERE T1.sex  =  'F' AND T3.pettype  =  'dog'

*** table内容
 
extra pred: SELECT student.fname FROM student JOIN has_pet ON student.stuid = has_pet.stuid JOIN pets ON has_pet.petid = pets.petid WHERE pets.pettype = 'dog' EXCEPT SELECT student.fname FROM student JOIN has_pet ON student.stuid = has_pet.stuid JOIN pets ON has_pet.petid = pets.petid WHERE pets.pettype = 'cat';
extra gold: SELECT T1.fname ,  T1.age FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'dog' AND T1.stuid NOT IN (SELECT T1.stuid FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat')

*** 本身有错

extra pred: SELECT model_list.model FROM cars_data INNER JOIN car_names ON cars_data.id = car_names.makeid INNER JOIN model_list ON car_names.model = model_list.model WHERE cars_data.weight < (SELECT AVG(weight) FROM cars_data);
extra gold: SELECT T1.model FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId  =  T2.Id WHERE T2.Weight  <  (SELECT avg(Weight) FROM CARS_DATA)

extra pred: SELECT model_list.model FROM cars_data JOIN car_names ON cars_data.id = car_names.makeid JOIN model_list ON car_names.model = model_list.model WHERE cars_data.weight < (SELECT AVG(weight) FROM cars_data);
extra gold: SELECT T1.model FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId  =  T2.Id WHERE T2.Weight  <  (SELECT avg(Weight) FROM CARS_DATA)

*** 语法错

extra pred: SELECT car_makers.maker FROM car_makers JOIN car_names ON car_makers.id = car_names.makeid JOIN cars_data ON car_names.makeid = cars_data.id WHERE cars_data.year = 1970;
extra gold: SELECT DISTINCT T1.Maker FROM CAR_MAKERS AS T1 JOIN MODEL_LIST AS T2 ON T1.Id  =  T2.Maker JOIN CAR_NAMES AS T3 ON T2.model  =  T3.model JOIN CARS_DATA AS T4 ON T3.MakeId  =  T4.id WHERE T4.year  =  '1970';

extra pred: SELECT car_makers.fullname FROM car_makers JOIN model_list ON car_makers.id = model_list.maker JOIN car_names ON model_list.model = car_names.model JOIN cars_data ON car_names.makeid = cars_data.id WHERE cars_data.year = 1970;
extra gold: SELECT DISTINCT T1.Maker FROM CAR_MAKERS AS T1 JOIN MODEL_LIST AS T2 ON T1.Id  =  T2.Maker JOIN CAR_NAMES AS T3 ON T2.model  =  T3.model JOIN CARS_DATA AS T4 ON T3.MakeId  =  T4.id WHERE T4.year  =  '1970';

*** 本身混淆

extra pred: SELECT car_names.make, cars_data.year FROM car_names JOIN model_list ON car_names.model = model_list.modelid JOIN cars_data ON car_names.makeid = cars_data.id WHERE cars_data.year = ( SELECT MIN(year) FROM cars_data );
extra gold: SELECT T2.Make ,  T1.Year FROM CARS_DATA AS T1 JOIN CAR_NAMES AS T2 ON T1.Id  =  T2.MakeId WHERE T1.Year  =  (SELECT min(YEAR) FROM CARS_DATA);

extra pred: SELECT car_makers.maker, MIN(cars_data.year) FROM cars_data JOIN car_names ON cars_data.id = car_names.makeid JOIN model_list ON car_names.model = model_list.model JOIN car_makers ON model_list.maker = car_makers.id GROUP BY car_makers.maker ORDER BY MIN(cars_data.year) LIMIT 1;
extra gold: SELECT T2.Make ,  T1.Year FROM CARS_DATA AS T1 JOIN CAR_NAMES AS T2 ON T1.Id  =  T2.MakeId WHERE T1.Year  =  (SELECT min(YEAR) FROM CARS_DATA);

*** 多余外键链接

medium pred: SELECT accelerate FROM cars_data INNER JOIN car_names ON cars_data.id = car_names.makeid INNER JOIN model_list ON car_names.model = model_list.model INNER JOIN car_makers ON model_list.maker = car_makers.id WHERE car_names.model = 'amc hornet sportabout (sw)';
medium gold: SELECT T1.Accelerate FROM CARS_DATA AS T1 JOIN CAR_NAMES AS T2 ON T1.Id  =  T2.MakeId WHERE T2.Make  =  'amc hornet sportabout (sw)';

*** 语法错

medium pred: SELECT COUNT(DISTINCT car_makers.maker) FROM car_makers JOIN countries ON car_makers.country = countries.countryid WHERE countries.countryname = 'France';
medium gold: SELECT count(*) FROM CAR_MAKERS AS T1 JOIN COUNTRIES AS T2 ON T1.Country  =  T2.CountryId WHERE T2.CountryName  =  'france';

*** 存疑，生成更合理

hard pred: SELECT COUNT(modelid) FROM countries JOIN car_makers ON countries.countryid = car_makers.country JOIN model_list ON car_makers.id = model_list.maker JOIN car_names ON model_list.model = car_names.model WHERE countries.countryname = 'United States';
hard gold: SELECT count(*) FROM MODEL_LIST AS T1 JOIN CAR_MAKERS AS T2 ON T1.Maker  =  T2.Id JOIN COUNTRIES AS T3 ON T2.Country  =  T3.CountryId WHERE T3.CountryName  =  'usa';

*** 语法错+表格内容

medium pred: SELECT model_list.maker, model_list.model FROM car_makers JOIN model_list ON car_makers.id = model_list.maker JOIN car_names ON model_list.model = car_names.model;
medium gold: SELECT Maker ,  Model FROM MODEL_LIST;

medium pred: SELECT model_list.maker, model_list.model FROM car_makers JOIN model_list ON car_makers.id = model_list.maker JOIN car_names ON model_list.model = car_names.model;
medium gold: SELECT Maker ,  Model FROM MODEL_LIST;

*** 多余链接

medium pred: SELECT countries.countryid, countries.countryname FROM countries INNER JOIN car_makers ON car_makers.country = countries.countryid;
medium gold: SELECT T1.CountryName ,  T1.CountryId FROM COUNTRIES AS T1 JOIN CAR_MAKERS AS T2 ON T1.CountryId  =  T2.Country GROUP BY T1.CountryId HAVING count(*)  >=  1;

*** 未知

medium pred: SELECT year, AVG(weight), AVG(year) FROM cars_data GROUP BY year;
medium gold: SELECT avg(Weight) ,  YEAR FROM CARS_DATA GROUP BY YEAR;

*** 少项，强化表达

extra pred: SELECT MAX(cars_data.horsepower), car_makers.fullname FROM cars_data JOIN car_names ON cars_data.id = car_names.makeid JOIN model_list ON car_names.model = model_list.model JOIN car_makers ON model_list.maker = car_makers.id WHERE cars_data.cylinders = 3;
extra gold: SELECT T2.horsepower ,  T1.Make FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId  =  T2.Id WHERE T2.cylinders  =  3 ORDER BY T2.horsepower DESC LIMIT 1;

extra pred: SELECT MAX(cars_data.horsepower), car_makers.fullname FROM cars_data JOIN car_names ON cars_data.id = car_names.makeid JOIN model_list ON car_names.model = model_list.model JOIN car_makers ON model_list.maker = car_makers.id WHERE cars_data.cylinders = 3
extra gold: SELECT T2.horsepower ,  T1.Make FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId  =  T2.Id WHERE T2.cylinders  =  3 ORDER BY T2.horsepower DESC LIMIT 1;

*** 混淆项

medium pred: SELECT MAX(accelerate) FROM cars_data GROUP BY cylinders;
medium gold: SELECT max(Accelerate) ,  Cylinders FROM CARS_DATA GROUP BY Cylinders;

*** 本身有错

hard pred: SELECT model FROM model_list GROUP BY model ORDER BY COUNT(DISTINCT modelid) DESC LIMIT 1;
hard gold: SELECT Model FROM CAR_NAMES GROUP BY Model ORDER BY count(*) DESC LIMIT 1;

*** 主表选错

medium pred: SELECT makers.id, makers.maker FROM car_makers AS makers JOIN model_list AS models ON makers.id = models.maker GROUP BY makers.id, makers.maker HAVING COUNT(models.modelid) > 3;
medium gold: SELECT T1.FullName ,  T1.Id FROM CAR_MAKERS AS T1 JOIN MODEL_LIST AS T2 ON T1.Id  =  T2.Maker GROUP BY T1.Id HAVING count(*)  >  3;

*** Full Name项识别错误

easy pred: SELECT DISTINCT cars_data.year FROM cars_data WHERE cars_data.weight < 4000 INTERSECT SELECT DISTINCT cars_data.year FROM cars_data WHERE cars_data.weight > 3000;
easy gold: select distinct year from cars_data where weight between 3000 and 4000;

*** 未知

extra pred: SELECT MIN(cars_data.cylinders) FROM model_list JOIN car_makers ON model_list.maker = car_makers.id JOIN car_names ON model_list.model = car_names.model JOIN cars_data ON car_names.makeid = cars_data.id WHERE model_list.model = 'volvo' ORDER BY cars_data.accelerate LIMIT 1;
extra gold: SELECT T1.cylinders FROM CARS_DATA AS T1 JOIN CAR_NAMES AS T2 ON T1.Id  =  T2.MakeId WHERE T2.Model  =  'volvo' ORDER BY T1.accelerate ASC LIMIT 1;

hard pred: SELECT COUNT(*) FROM cars_data WHERE accelerate > (SELECT MAX(horsepower) FROM cars_data)
hard gold: SELECT COUNT(*) FROM CARS_DATA WHERE Accelerate  >  ( SELECT Accelerate FROM CARS_DATA ORDER BY Horsepower DESC LIMIT 1 );

hard pred: SELECT COUNT(*) FROM cars_data WHERE accelerate > (SELECT MAX(horsepower) FROM cars_data);
hard gold: SELECT COUNT(*) FROM CARS_DATA WHERE Accelerate  >  ( SELECT Accelerate FROM CARS_DATA ORDER BY Horsepower DESC LIMIT 1 );

*** 加速度和马力项识别错误

extra pred: SELECT model FROM model_list INNER JOIN cars_data ON model_list.modelid = cars_data.id WHERE cars_data.cylinders = 4 ORDER BY cars_data.horsepower DESC LIMIT 1;
extra gold: SELECT T1.Model FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId  =  T2.Id WHERE T2.Cylinders  =  4 ORDER BY T2.horsepower DESC LIMIT 1;

extra pred: SELECT car_makers.id, car_makers.maker FROM cars_data JOIN car_names ON cars_data.id = car_names.makeid JOIN model_list ON car_names.model = model_list.modelid JOIN car_makers ON model_list.maker = car_makers.id WHERE cylinders < 4 AND horsepower > ( SELECT MIN(horsepower) FROM cars_data )
extra gold: select t2.makeid ,  t2.make from cars_data as t1 join car_names as t2 on t1.id  =  t2.makeid where t1.horsepower  >  (select min(horsepower) from cars_data) and t1.cylinders  <  4;

*** 模式链接错，maker和makeid未识别

extra pred: SELECT car_makers.id, car_makers.maker FROM car_makers JOIN model_list ON model_list.maker = car_makers.id GROUP BY car_makers.id, car_makers.maker HAVING COUNT(model_list.model) >= 2 AND COUNT(DISTINCT car_makers.id) > 3;
extra gold: select t1.id ,  t1.maker from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker group by t1.id having count(*)  >=  2 intersect select t1.id ,  t1.maker from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker join car_names as t3 on t2.model  =  t3.model group by t1.id having count(*)  >  3;

extra pred: SELECT car_makers.id, car_makers.maker FROM car_makers INNER JOIN model_list ON car_makers.id = model_list.maker INNER JOIN car_names ON model_list.model = car_names.model INNER JOIN cars_data ON car_names.makeid = cars_data.id GROUP BY car_makers.id, car_makers.maker HAVING COUNT(DISTINCT model_list.model) >= 2 AND COUNT(DISTINCT cars_data.id) > 3;
extra gold: SELECT T1.Id ,  T1.Maker FROM CAR_MAKERS AS T1 JOIN MODEL_LIST AS T2 ON T1.Id  =  T2.Maker GROUP BY T1.Id HAVING count(*)  >=  2 INTERSECT SELECT T1.Id ,  T1.Maker FROM CAR_MAKERS AS T1 JOIN MODEL_LIST AS T2 ON T1.Id  =  T2.Maker JOIN CAR_NAMES AS T3 ON T2.model  =  T3.model GROUP BY T1.Id HAVING count(*)  >  3;

*** 多重子表 识别错误

extra pred: SELECT countries.countryid, countries.countryname FROM countries WHERE countries.countryid IN ( SELECT car_makers.country FROM car_makers GROUP BY car_makers.country HAVING COUNT(*) > 3 ) OR countries.countryid IN ( SELECT car_makers.country FROM car_makers JOIN model_list ON car_makers.id = model_list.maker JOIN car_names ON model_list.model = car_names.model WHERE car_names.make = 'fiat' );
extra gold: SELECT T1.countryId ,  T1.CountryName FROM Countries AS T1 JOIN CAR_MAKERS AS T2 ON T1.CountryId  =  T2.Country GROUP BY T1.countryId HAVING count(*)  >  3 UNION SELECT T1.countryId ,  T1.CountryName FROM Countries AS T1 JOIN CAR_MAKERS AS T2 ON T1.CountryId  =  T2.Country JOIN MODEL_LIST AS T3 ON T2.Id  =  T3.Maker WHERE T3.Model  =  'fiat';

extra pred: SELECT countryid, countryname FROM countries WHERE countryid IN (SELECT country FROM car_makers GROUP BY country HAVING COUNT(*) > 3) OR countryid IN (SELECT country FROM car_makers INNER JOIN model_list ON car_makers.id = model_list.maker INNER JOIN car_names ON model_list.modelid = car_names.model WHERE car_names.make = "fiat");
extra gold: select t1.countryid ,  t1.countryname from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country group by t1.countryid having count(*)  >  3 union select t1.countryid ,  t1.countryname from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country join model_list as t3 on t2.id  =  t3.maker where t3.model  =  'fiat';
 
*** model_list识别错误

medium pred: SELECT COUNT(*) FROM flights WHERE airline = 'JetBlue Airways';
medium gold: SELECT count(*) FROM FLIGHTS AS T1 JOIN AIRLINES AS T2 ON T1.Airline  =  T2.uid WHERE T2.Airline = "JetBlue Airways"

medium pred: SELECT COUNT(*) FROM flights f JOIN airlines a ON f.airline = a.airline WHERE a.abbreviation = 'JetBlue';
medium gold: SELECT count(*) FROM FLIGHTS AS T1 JOIN AIRLINES AS T2 ON T1.Airline  =  T2.uid WHERE T2.Airline = "JetBlue Airways"

*** Arline简单考虑，需加入类型判断

extra pred: SELECT sourceairport FROM flights GROUP BY sourceairport ORDER BY COUNT(*) DESC LIMIT 1;
extra gold: SELECT T1.AirportCode FROM AIRPORTS AS T1 JOIN FLIGHTS AS T2 ON T1.AirportCode  =  T2.DestAirport OR T1.AirportCode  =  T2.SourceAirport GROUP BY T1.AirportCode ORDER BY count(*) DESC LIMIT 1

extra pred: SELECT airportcode FROM airports ORDER BY (SELECT COUNT(*) FROM flights WHERE destairport = airports.airportcode OR sourceairport = airports.airportcode) ASC LIMIT 1;
extra gold: SELECT T1.AirportCode FROM AIRPORTS AS T1 JOIN FLIGHTS AS T2 ON T1.AirportCode  =  T2.DestAirport OR T1.AirportCode  =  T2.SourceAirport GROUP BY T1.AirportCode ORDER BY count(*) LIMIT 1

*** 天生问题？

extra pred: SELECT airline FROM flights GROUP BY airline ORDER BY COUNT(*) DESC LIMIT 1;
extra gold: SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline ORDER BY count(*) DESC LIMIT 1

extra pred: SELECT flights.airline FROM flights GROUP BY flights.airline ORDER BY COUNT(*) DESC LIMIT 1;
extra gold: SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline ORDER BY count(*) DESC LIMIT 1

*** 可用附加信息解决

extra pred: SELECT abbreviation, country FROM airlines WHERE uid IN ( SELECT airline FROM flights GROUP BY airline ORDER BY COUNT(*) ASC LIMIT 1 )
extra gold: SELECT T1.Abbreviation ,  T1.Country FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline ORDER BY count(*) LIMIT 1

extra pred: SELECT abbreviation, country FROM airlines WHERE uid = ( SELECT airline FROM flights GROUP BY airline ORDER BY COUNT(*) ASC LIMIT 1 );
extra gold: SELECT T1.Abbreviation ,  T1.Country FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline ORDER BY count(*) LIMIT 1

*** group是否主键

medium pred: SELECT airline FROM airlines WHERE airline IN ( SELECT airline FROM flights GROUP BY airline HAVING COUNT(*) >= 10 );
medium gold: SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline HAVING count(*)  >  10

medium pred: SELECT airline FROM flights GROUP BY airline HAVING COUNT(*) >= 10;
medium gold: SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline HAVING count(*)  >  10

*** Airline加上类型约束

medium pred: SELECT airline FROM airlines WHERE airline IN ( SELECT airline FROM flights GROUP BY airline HAVING COUNT(*) < 200 );
medium gold: SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline HAVING count(*)  <  200

medium pred: SELECT airline FROM flights GROUP BY airline HAVING COUNT(*) < 200;
medium gold: SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline HAVING count(*)  <  200

*** Airline加上类型约束

medium pred: SELECT flightno FROM flights WHERE airline = "United Airlines";
medium gold: SELECT T1.FlightNo FROM FLIGHTS AS T1 JOIN AIRLINES AS T2 ON T2.uid  =  T1.Airline WHERE T2.Airline  =  "United Airlines"

medium pred: SELECT flightno FROM flights WHERE airline = 'United Airlines';
medium gold: SELECT T1.FlightNo FROM FLIGHTS AS T1 JOIN AIRLINES AS T2 ON T2.uid  =  T1.Airline WHERE T2.Airline  =  "United Airlines"

*** Airline加上类型约束

hard pred: SELECT airportcode, airportname, city, country FROM airports WHERE airportcode NOT IN (SELECT sourceairport FROM flights UNION SELECT destairport FROM flights);
hard gold: SELECT AirportName FROM Airports WHERE AirportCode NOT IN (SELECT SourceAirport FROM Flights UNION SELECT DestAirport FROM Flights)

*** which airport 指代名字name

medium pred: SELECT COUNT(DISTINCT documents.document_id) FROM documents JOIN templates ON documents.template_id = templates.template_id JOIN ref_template_types ON templates.template_type_code = ref_template_types.template_type_code WHERE ref_template_types.template_type_description = 'PPT';
medium gold: SELECT count(*) FROM Documents AS T1 JOIN Templates AS T2 ON T1.Template_ID  =  T2.Template_ID WHERE T2.Template_Type_Code  =  'PPT'

medium pred: SELECT templates.template_id, COUNT(documents.document_id) FROM templates LEFT JOIN documents ON templates.template_id = documents.template_id GROUP BY templates.template_id;
medium gold: SELECT template_id ,  count(*) FROM Documents GROUP BY template_id

extra pred: SELECT templates.template_id, templates.template_type_code FROM templates JOIN documents ON documents.template_id = templates.template_id GROUP BY templates.template_id, templates.template_type_code ORDER BY COUNT(documents.document_id) DESC LIMIT 1;
extra gold: SELECT T1.template_id ,  T2.Template_Type_Code FROM Documents AS T1 JOIN Templates AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_id ORDER BY count(*) DESC LIMIT 1

extra pred: SELECT templates.template_id, templates.template_type_code FROM templates JOIN documents ON templates.template_id = documents.template_id GROUP BY templates.template_id, templates.template_type_code ORDER BY COUNT(documents.document_id) DESC LIMIT 1;
extra gold: SELECT T1.template_id ,  T2.Template_Type_Code FROM Documents AS T1 JOIN Templates AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_id ORDER BY count(*) DESC LIMIT 1

*** group by多项

hard pred: SELECT ref_template_types.template_type_code FROM ref_template_types LEFT JOIN templates ON ref_template_types.template_type_code = templates.template_type_code WHERE templates.template_type_code IS NULL;
hard gold: SELECT template_type_code FROM Templates EXCEPT SELECT template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id

easy pred: SELECT ref_template_types.template_type_description FROM templates JOIN ref_template_types ON templates.template_type_code = ref_template_types.template_type_code WHERE templates.template_type_code = 'AD';
easy gold: SELECT template_type_description FROM Ref_template_types WHERE template_type_code  =  "AD"

medium pred: SELECT ref_template_types.template_type_description FROM templates JOIN documents ON documents.template_id = templates.template_id JOIN ref_template_types ON ref_template_types.template_type_code = templates.template_type_code GROUP BY ref_template_types.template_type_description;
medium gold: SELECT DISTINCT T1.template_type_description FROM Ref_template_types AS T1 JOIN Templates AS T2 ON T1.template_type_code  = T2.template_type_code JOIN Documents AS T3 ON T2.Template_ID  =  T3.template_ID

medium pred: SELECT paragraph_text, paragraph_id, document_id, other_details FROM paragraphs WHERE paragraph_text = 'Korea';
medium gold: select other_details from paragraphs where paragraph_text like 'korea'

medium pred: SELECT paragraph_text, other_details FROM paragraphs WHERE paragraph_text = 'Korea';
medium gold: select other_details from paragraphs where paragraph_text like 'korea'

*** 多余项

hard pred: SELECT documents.document_id FROM documents JOIN paragraphs ON documents.document_id = paragraphs.document_id WHERE paragraphs.paragraph_text IN ('Brazil', 'Ireland');
hard gold: SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Brazil' INTERSECT SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Ireland'

hard pred: SELECT documents.document_id FROM documents JOIN paragraphs ON paragraphs.document_id = documents.document_id WHERE paragraphs.paragraph_text IN ('Brazil', 'Ireland');
hard gold: SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Brazil' INTERSECT SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Ireland'

*** paragraph_text识别错误

easy pred: SELECT teacher.name FROM teacher WHERE teacher.hometown != 'Little Lever Urban District';
easy gold: select name from teacher where hometown != "little lever urban district"

easy pred: SELECT name FROM teacher WHERE hometown != 'Little Lever Urban District';
easy gold: select name from teacher where hometown != "little lever urban district"

*** 引用词

extra pred: SELECT visitor.id, visitor.name, visitor.level_of_membership FROM visitor JOIN visit ON visitor.id = visit.visitor_id GROUP BY visitor.id, visitor.name, visitor.level_of_membership ORDER BY SUM(visit.total_spent) DESC LIMIT 1;
extra gold: SELECT t2.visitor_id ,  t1.name ,  t1.Level_of_membership FROM visitor AS t1 JOIN visit AS t2 ON t1.id  =  t2.visitor_id GROUP BY t2.visitor_id ORDER BY sum(t2.Total_spent) DESC LIMIT 1

*** groupby多项，结果一样，column名不一样

extra pred: SELECT COUNT(DISTINCT visitor_id) FROM visit WHERE museum_id IN ( SELECT museum_id FROM museum WHERE open_year <= 2010)
extra gold: SELECT count(*) FROM visitor WHERE id NOT IN (SELECT t2.visitor_id FROM museum AS t1 JOIN visit AS t2 ON t1.Museum_ID  =  t2.Museum_ID WHERE t1.open_year  >  2010)

*** 完全错，难纠正

medium pred: SELECT players.first_name, players.birth_date FROM players WHERE players.player_id IN (SELECT player_id FROM rankings WHERE player_id IN (SELECT winner_id FROM matches WHERE winner_ioc = "USA") OR player_id IN (SELECT loser_id FROM matches WHERE winner_ioc = "USA"));
medium gold: SELECT first_name ,  birth_date FROM players WHERE country_code  =  'USA'

*** country code USA指向

easy pred: SELECT AVG(rankings.ranking) as average_rank FROM matches JOIN players ON matches.winner_id = players.player_id JOIN rankings ON players.player_id = rankings.player_id;
easy gold: SELECT avg(winner_rank) FROM matches

*** 需要让LLM了解Rank是排名，小的更好

easy pred: SELECT MAX(loser_rank) FROM matches;
easy gold:  



easy pred: SELECT MAX(loser_rank) FROM matches;
easy gold: SELECT min(loser_rank) FROM matches

hard pred: SELECT DISTINCT first_name, last_name FROM matches JOIN players ON matches.winner_id = players.player_id WHERE year = 2013 INTERSECT SELECT DISTINCT first_name, last_name FROM matches JOIN players ON matches.winner_id = players.player_id WHERE year = 2016;
hard gold: SELECT winner_name FROM matches WHERE YEAR  =  2013 INTERSECT SELECT winner_name FROM matches WHERE YEAR  =  2016


hard pred: SELECT players.first_name, players.last_name FROM matches JOIN players ON matches.winner_id = players.player_id WHERE year = 2013 INTERSECT SELECT players.first_name, players.last_name FROM matches JOIN players ON matches.winner_id = players.player_id WHERE year = 2016;
hard gold: SELECT winner_name FROM matches WHERE YEAR  =  2013 INTERSECT SELECT winner_name FROM matches WHERE YEAR  =  2016


*** 名字直接写

extra pred: SELECT players.first_name, players.country_code FROM players INNER JOIN matches ON players.player_id = matches.winner_id WHERE matches.tourney_name = 'WTA Championships' AND players.player_id IN ( SELECT winner_id FROM matches WHERE tourney_name = 'Australian Open' );
extra gold: SELECT T1.country_code ,  T1.first_name FROM players AS T1 JOIN matches AS T2 ON T1.player_id  =  T2.winner_id WHERE T2.tourney_name  =  'WTA Championships' INTERSECT SELECT T1.country_code ,  T1.first_name FROM players AS T1 JOIN matches AS T2 ON T1.player_id  =  T2.winner_id WHERE T2.tourney_name  =  'Australian Open'

medium pred: SELECT players.first_name || ' ' || players.last_name FROM players ORDER BY players.birth_date;
medium gold: SELECT first_name ,  last_name FROM players ORDER BY birth_date

medium pred: SELECT players.first_name || ' ' || players.last_name FROM players WHERE players.hand = 'Left' ORDER BY players.birth_date;
medium gold: SELECT first_name ,  last_name FROM players WHERE hand  =  'L' ORDER BY birth_date

*** ？

hard pred: SELECT players.first_name, players.country_code FROM players WHERE players.player_id = ( SELECT player_id FROM rankings GROUP BY player_id ORDER BY COUNT(tours) DESC LIMIT 1 );
hard gold: SELECT T1.country_code ,  T1.first_name FROM players AS T1 JOIN rankings AS T2 ON T1.player_id  =  T2.player_id ORDER BY T2.tours DESC LIMIT 1

hard pred: SELECT players.first_name, players.country_code FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id ORDER BY COUNT(rankings.tours) DESC LIMIT 1;
hard gold: SELECT T1.country_code ,  T1.first_name FROM players AS T1 JOIN rankings AS T2 ON T1.player_id  =  T2.player_id ORDER BY T2.tours DESC LIMIT 1

*** tours不用count

hard pred: SELECT players.first_name, players.last_name, SUM(matches.winner_rank_points) AS total_rank_points FROM matches JOIN players ON matches.winner_id = players.player_id GROUP BY players.first_name, players.last_name ORDER BY total_rank_points DESC LIMIT 1;
hard gold: SELECT winner_name ,  winner_rank_points FROM matches GROUP BY winner_name ORDER BY count(*) DESC LIMIT 1

hard pred: SELECT matches.winner_name, SUM(matches.winner_rank_points) AS total_rank_points FROM matches GROUP BY matches.winner_name ORDER BY COUNT(matches.winner_name) DESC LIMIT 1;
hard gold: SELECT winner_name ,  winner_rank_points FROM matches GROUP BY winner_name ORDER BY count(*) DESC LIMIT 1

*** rank_points不需要sum

medium pred: SELECT players.first_name, AVG(rankings.ranking) AS average_ranking FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id, players.first_name;
medium gold: SELECT avg(ranking) ,  T1.first_name FROM players AS T1 JOIN rankings AS T2 ON T1.player_id  =  T2.player_id GROUP BY T1.first_name

medium pred: SELECT players.first_name, SUM(rankings.ranking_points) as total_ranking_points FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id, players.first_name;
medium gold: SELECT sum(ranking_points) ,  T1.first_name FROM players AS T1 JOIN rankings AS T2 ON T1.player_id  =  T2.player_id GROUP BY T1.first_name

*** 本身有错？

medium pred: SELECT ranking_date, COUNT(DISTINCT tours) FROM rankings GROUP BY ranking_date;
medium gold: SELECT sum(tours) ,  ranking_date FROM rankings GROUP BY ranking_date

medium pred: SELECT ranking_date, COUNT(DISTINCT tours) AS total_tours FROM rankings GROUP BY ranking_date;
medium gold: SELECT sum(tours) ,  ranking_date FROM rankings GROUP BY ranking_date

*** num和tour的奇妙反应

medium pred: SELECT COUNT(DISTINCT matches.winner_id) FROM matches JOIN players ON matches.winner_id = players.player_id WHERE tourney_name = 'WTA Championships' AND hand = 'left';
medium gold: SELECT count(DISTINCT winner_name) FROM matches WHERE tourney_name  =  'WTA Championships' AND winner_hand  =  'L'

*** hand left，应跟winnner联系更密切

hard pred: SELECT players.first_name, players.country_code, players.birth_date FROM players INNER JOIN matches ON matches.winner_id = players.player_id WHERE matches.winner_rank_points = (SELECT MAX(winner_rank_points) FROM matches);
hard gold: SELECT T1.first_name ,  T1.country_code ,  T1.birth_date FROM players AS T1 JOIN matches AS T2 ON T1.player_id  =  T2.winner_id ORDER BY T2.winner_rank_points DESC LIMIT 1

medium pred: SELECT name, date, result FROM battle;
medium gold: SELECT name ,  date FROM battle

medium pred: SELECT death.note, death.killed FROM death JOIN ship ON death.caused_by_ship_id = ship.id WHERE ship.tonnage = 't';
medium gold: SELECT T1.killed ,  T1.injured FROM death AS T1 JOIN ship AS t2 ON T1.caused_by_ship_id  =  T2.id WHERE T2.tonnage  =  't'
 

extra pred: SELECT ship.id, ship.name FROM death JOIN ship ON death.caused_by_ship_id = ship.id GROUP BY ship.id, ship.name ORDER BY SUM(death.injured) DESC LIMIT 1;
extra gold: SELECT T2.id ,  T2.name FROM death AS T1 JOIN ship AS t2 ON T1.caused_by_ship_id  =  T2.id GROUP BY T2.id ORDER BY count(*) DESC LIMIT 1

*** "What is the ship id and name that caused most total injuries?" 本身有错，跟Injured有歧义

extra pred: SELECT battle.name, battle.date FROM battle INNER JOIN ship ON ship.lost_in_battle = battle.id WHERE ship.name IN ('Lettice', 'HMS Atalanta');
extra gold: SELECT T1.name ,  T1.date FROM battle AS T1 JOIN ship AS T2 ON T1.id  =  T2.lost_in_battle WHERE T2.name  =  'Lettice' INTERSECT SELECT T1.name ,  T1.date FROM battle AS T1 JOIN ship AS T2 ON T1.id  =  T2.lost_in_battle WHERE T2.name  =  'HMS Atalanta'

*** JOIN+IN不如INTERSECT

medium pred: SELECT course_name, course_id FROM courses WHERE course_id IN ( SELECT course_id FROM sections GROUP BY course_id HAVING COUNT(*) < 2 );
medium gold: SELECT T1.course_name ,  T1.course_id FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id  =  T2.course_id GROUP BY T1.course_id HAVING count(*)  <=  2

*** 本身错 less than就得用<

medium pred: SELECT students.student_id, students.first_name, students.middle_name, students.last_name FROM student_enrolment JOIN students ON student_enrolment.student_id = students.student_id GROUP BY students.student_id, students.first_name, students.middle_name, students.last_name HAVING COUNT(DISTINCT student_enrolment.degree_program_id) = 2 AND COUNT(DISTINCT student_enrolment.semester_id) = 1
medium gold: SELECT T1.first_name ,  T1.middle_name ,  T1.last_name ,  T1.student_id FROM Students AS T1 JOIN Student_Enrolment AS T2 ON T1.student_id  =  T2.student_id GROUP BY T1.student_id HAVING count(*)  =  2

hard pred: SELECT students.first_name, students.middle_name, students.last_name FROM students JOIN student_enrolment ON students.student_id = student_enrolment.student_id JOIN degree_programs ON student_enrolment.degree_program_id = degree_programs.degree_program_id WHERE degree_programs.degree_summary_name = 'Bachelors';
hard gold: SELECT DISTINCT T1.first_name ,  T1.middle_name ,  T1.last_name FROM Students AS T1 JOIN Student_Enrolment AS T2 ON T1.student_id  =  T2.student_id JOIN Degree_Programs AS T3 ON T2.degree_program_id  =  T3.degree_program_id WHERE T3.degree_summary_name  =  'Bachelor'

*** 不加示范没法对

extra pred: SELECT degree_program_id, degree_summary_name, degree_summary_description FROM degree_programs WHERE degree_program_id = ( SELECT degree_program_id FROM student_enrolment GROUP BY degree_program_id ORDER BY COUNT(*) DESC LIMIT 1 )
extra gold: SELECT T1.degree_program_id ,  T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id GROUP BY T1.degree_program_id ORDER BY count(*) DESC LIMIT 1

*** 不加示范没法对

extra pred: SELECT student_enrolment.student_id, students.first_name, students.middle_name, students.last_name, COUNT(student_enrolment.student_enrolment_id) as num_enrollments FROM student_enrolment JOIN students ON student_enrolment.student_id = students.student_id GROUP BY student_enrolment.student_id ORDER BY num_enrollments DESC LIMIT 1;
extra gold: SELECT T1.student_id ,  T1.first_name ,  T1.middle_name ,  T1.last_name ,  count(*) ,  T1.student_id FROM Students AS T1 JOIN Student_Enrolment AS T2 ON T1.student_id  =  T2.student_id GROUP BY T1.student_id ORDER BY count(*) DESC LIMIT 1

extra pred: SELECT students.first_name, students.middle_name, students.last_name, students.student_id, COUNT(*) AS enrollments FROM students JOIN student_enrolment ON students.student_id = student_enrolment.student_id GROUP BY students.student_id ORDER BY enrollments DESC LIMIT 1;
extra gold: SELECT T1.student_id ,  T1.first_name ,  T1.middle_name ,  T1.last_name ,  count(*) ,  T1.student_id FROM Students AS T1 JOIN Student_Enrolment AS T2 ON T1.student_id  =  T2.student_id GROUP BY T1.student_id ORDER BY count(*) DESC LIMIT 1

*** 本身是6个，不能删去语意重复项

extra pred: SELECT courses.course_name FROM courses JOIN student_enrolment_courses ON courses.course_id = student_enrolment_courses.course_id GROUP BY student_enrolment_courses.course_id ORDER BY COUNT(student_enrolment_courses.student_enrolment_id) DESC LIMIT 1;
extra gold: SELECT  T1.course_name FROM Courses AS T1 JOIN Student_Enrolment_Courses AS T2 ON T1.course_id  =  T2.course_id GROUP BY T1.course_name ORDER BY count(*) DESC LIMIT 1

*** groupby用select里面项

extra pred: SELECT students.last_name FROM students JOIN addresses ON students.current_address_id = addresses.address_id LEFT JOIN student_enrolment ON students.student_id = student_enrolment.student_id WHERE addresses.state_province_county = 'North Carolina' AND student_enrolment.student_id IS NULL;
extra gold: SELECT T1.last_name FROM Students AS T1 JOIN Addresses AS T2 ON T1.current_address_id  =  T2.address_id WHERE T2.state_province_county  =  'NorthCarolina' EXCEPT SELECT DISTINCT T3.last_name FROM Students AS T3 JOIN Student_Enrolment AS T4 ON T3.student_id  =  T4.student_id

extra pred: SELECT students.last_name FROM students JOIN addresses ON students.permanent_address_id = addresses.address_id LEFT JOIN student_enrolment ON students.student_id = student_enrolment.student_id WHERE addresses.state_province_county = 'North Carolina' AND student_enrolment.student_id IS NULL;
extra gold: SELECT T1.last_name FROM Students AS T1 JOIN Addresses AS T2 ON T1.current_address_id  =  T2.address_id WHERE T2.state_province_county  =  'NorthCarolina' EXCEPT SELECT DISTINCT T3.last_name FROM Students AS T3 JOIN Student_Enrolment AS T4 ON T3.student_id  =  T4.student_id

medium pred: SELECT transcripts.transcript_date, transcripts.transcript_id FROM transcripts WHERE transcripts.transcript_id IN (SELECT student_enrolment_courses.student_enrolment_id FROM student_enrolment_courses GROUP BY student_enrolment_courses.student_enrolment_id HAVING COUNT(*) >= 2);
medium gold: SELECT T2.transcript_date ,  T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id  =  T2.transcript_id GROUP BY T1.transcript_id HAVING count(*)  >=  2

medium pred: SELECT transcript_date, transcript_id FROM transcripts WHERE transcript_id IN ( SELECT transcript_id FROM student_enrolment_courses GROUP BY transcript_id HAVING COUNT(DISTINCT course_id) >= 2 );
medium gold: SELECT T2.transcript_date ,  T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id  =  T2.transcript_id GROUP BY T1.transcript_id HAVING count(*)  >=  2

*** groupby 或许用主键可以区分，跟student无关

medium pred: SELECT students.cell_mobile_number FROM students WHERE students.first_name = 'Timmothy' AND students.last_name = 'Ward';
medium gold: select cell_mobile_number from students where first_name  =  'timmothy' and last_name  =  'ward'

*** 关键词大小写

medium pred: SELECT students.first_name, students.middle_name, students.last_name FROM students JOIN student_enrolment ON students.student_id = student_enrolment.student_id JOIN transcripts ON student_enrolment.student_enrolment_id = transcripts.transcript_id ORDER BY transcripts.transcript_date ASC LIMIT 1;
medium gold: SELECT first_name ,  middle_name ,  last_name FROM Students ORDER BY date_left ASC LIMIT 1

extra pred: SELECT addresses.address_id, addresses.line_1, addresses.line_2, addresses.line_3 FROM addresses WHERE addresses.address_id IN ( SELECT current_address_id FROM students GROUP BY current_address_id ORDER BY COUNT(*) DESC LIMIT 1 );
extra gold: SELECT T1.address_id ,  T1.line_1 ,  T1.line_2 FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id  =  T2.current_address_id GROUP BY T1.address_id ORDER BY count(*) DESC LIMIT 1

*** line3因为是空所以不要了？？？本身有问题

hard pred: SELECT COUNT(*) as max_enrollment_count, student_enrolment_id FROM student_enrolment_courses GROUP BY student_enrolment_id ORDER BY max_enrollment_count DESC LIMIT 1;
hard gold: SELECT count(*) ,  student_course_id FROM Transcript_Contents GROUP BY student_course_id ORDER BY count(*) DESC LIMIT 1

hard pred: SELECT MAX(count_course) as max_count, course_id, student_enrolment_id FROM ( SELECT course_id, student_enrolment_id, COUNT(course_id) as count_course FROM student_enrolment_courses GROUP BY course_id, student_enrolment_id ) GROUP BY course_id ORDER BY max_count DESC LIMIT 1;
hard gold: SELECT count(*) ,  student_course_id FROM Transcript_Contents GROUP BY student_course_id ORDER BY count(*) DESC LIMIT 1

*** 涉及table太多

extra pred: SELECT semesters.semester_name FROM semesters JOIN student_enrolment ON student_enrolment.semester_id = semesters.semester_id JOIN degree_programs ON degree_programs.degree_program_id = student_enrolment.degree_program_id WHERE degree_programs.degree_summary_name = 'Bachelor' INTERSECT SELECT semesters.semester_name FROM semesters JOIN student_enrolment ON student_enrolment.semester_id = semesters.semester_id JOIN degree_programs ON degree_programs.degree_program_id = student_enrolment.degree_program_id WHERE degree_programs.degree_summary_name = 'Master';
extra gold: SELECT DISTINCT T2.semester_id FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id WHERE degree_summary_name  =  'Master' INTERSECT SELECT DISTINCT T2.semester_id FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id WHERE degree_summary_name  =  'Bachelor'

extra pred: SELECT semesters.semester_id FROM semesters JOIN student_enrolment ON semesters.semester_id = student_enrolment.semester_id JOIN degree_programs ON student_enrolment.degree_program_id = degree_programs.degree_program_id WHERE degree_programs.degree_summary_name IN ('Masters', 'Bachelors') GROUP BY semesters.semester_id HAVING COUNT(DISTINCT degree_programs.degree_summary_name) = 2;
extra gold: SELECT DISTINCT T2.semester_id FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id WHERE degree_summary_name  =  'Master' INTERSECT SELECT DISTINCT T2.semester_id FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id WHERE degree_summary_name  =  'Bachelor'

*** 涉及table太多

easy pred: SELECT DISTINCT line_1, line_2, line_3, city FROM addresses JOIN students ON students.permanent_address_id = addresses.address_id OR students.current_address_id = addresses.address_id;
easy gold: SELECT count(DISTINCT current_address_id) FROM Students

*** 题目本身错

easy pred: SELECT students.first_name, students.last_name, students.middle_name, students.student_id, students.email_address, addresses.line_1, addresses.line_2, addresses.line_3, addresses.city FROM students INNER JOIN addresses ON students.permanent_address_id = addresses.address_id ORDER BY students.last_name DESC;
easy gold: SELECT other_student_details FROM Students ORDER BY other_student_details DESC

easy pred: SELECT students.last_name, students.first_name, students.middle_name, students.other_student_details FROM students ORDER BY students.last_name DESC;
easy gold: SELECT other_student_details FROM Students ORDER BY other_student_details DESC

*** 涉及colomn太多

easy pred: SELECT section_name, section_description, section_id, course_id FROM sections WHERE section_name = 'h';
easy gold: SELECT section_description FROM Sections WHERE section_name  =  'h'

*** 涉及colomn太多

hard pred: SELECT students.first_name FROM students WHERE students.permanent_address_id IN (SELECT address_id FROM addresses WHERE country = 'Haiti') OR students.cell_mobile_number = '09700166582';
hard gold: select t1.first_name from students as t1 join addresses as t2 on t1.permanent_address_id  =  t2.address_id where t2.country  =  'haiti' or t1.cell_mobile_number  =  '09700166582'

hard pred: SELECT first_name FROM students WHERE permanent_address_id IN (SELECT address_id FROM addresses WHERE country = 'Haiti') OR cell_mobile_number = '09700166582';
hard gold: select t1.first_name from students as t1 join addresses as t2 on t1.permanent_address_id  =  t2.address_id where t2.country  =  'haiti' or t1.cell_mobile_number  =  '09700166582'

*** 大小写问题

easy pred: SELECT episode FROM tv_series ORDER BY rating DESC;
easy gold: SELECT Episode FROM TV_series ORDER BY rating

medium pred: SELECT cartoon.production_code, cartoon.channel FROM cartoon WHERE cartoon.id = (SELECT MAX(id) FROM cartoon)
medium gold: select production_code ,  channel from cartoon order by original_air_date desc limit 1

*** recent没显示(为啥只有一个是这结果？)

medium pred: SELECT tv_channel.package_option, tv_channel.series_name FROM tv_channel WHERE tv_channel.hight_definition_tv = 1;
medium gold: SELECT package_option ,  series_name FROM TV_Channel WHERE hight_definition_TV  =  "yes"

medium pred: SELECT tv_channel.package_option, tv_channel.series_name FROM tv_channel WHERE tv_channel.hight_definition_tv = 1;
medium gold: SELECT package_option ,  series_name FROM TV_Channel WHERE hight_definition_TV  =  "yes"

*** 需要示范列

hard pred: SELECT tv_channel.country FROM tv_channel WHERE tv_channel.id NOT IN ( SELECT cartoon.channel FROM cartoon WHERE cartoon.written_by = "Todd Casey" )
hard gold: SELECT country FROM TV_Channel EXCEPT SELECT T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.written_by  =  'Todd Casey'

hard pred: SELECT tv_channel.country FROM tv_channel WHERE tv_channel.id NOT IN ( SELECT cartoon.channel FROM cartoon WHERE cartoon.written_by = "Todd Casey" );
hard gold: SELECT country FROM TV_Channel EXCEPT SELECT T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.written_by  =  'Todd Casey'

*** 主题是国家

extra pred: SELECT tv_channel.series_name, tv_channel.country FROM cartoon JOIN tv_channel ON cartoon.channel = tv_channel.id WHERE cartoon.directed_by IN ('Ben Jones', 'Michael Chang');
extra gold: SELECT T1.series_name ,  T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.directed_by  =  'Michael Chang' INTERSECT SELECT T1.series_name ,  T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.directed_by  =  'Ben Jones'

extra pred: SELECT tv_channel.series_name, tv_channel.country FROM tv_channel INNER JOIN cartoon ON cartoon.channel = tv_channel.id WHERE cartoon.directed_by IN ('Ben Jones', 'Michael Chang');
extra gold: SELECT T1.series_name ,  T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.directed_by  =  'Michael Chang' INTERSECT SELECT T1.series_name ,  T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.directed_by  =  'Ben Jones'

easy pred: SELECT tv_channel.id FROM tv_channel WHERE country IN ( SELECT country FROM tv_channel GROUP BY country HAVING COUNT(DISTINCT id) > 2 )
easy gold: SELECT id FROM tv_channel GROUP BY country HAVING count(*)  >  2

easy pred: SELECT tv_channel.id FROM tv_channel GROUP BY tv_channel.id HAVING COUNT(*) > 2;
easy gold: SELECT id FROM tv_channel GROUP BY country HAVING count(*)  >  2

easy pred: SELECT SUM(surfacearea) FROM country WHERE continent = 'Caribbean';
easy gold: SELECT sum(SurfaceArea) FROM country WHERE Region  =  "Caribbean"

extra pred: SELECT language FROM countrylanguage WHERE countrycode = 'ABW' AND isofficial = 'T' AND percentage = (SELECT MAX(percentage) FROM countrylanguage WHERE countrycode = 'ABW');
extra gold: SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T1.Name  =  "Aruba" ORDER BY Percentage DESC LIMIT 1

extra pred: SELECT country.name FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode GROUP BY country.code ORDER BY COUNT(DISTINCT countrylanguage.language) DESC LIMIT 1;
extra gold: SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode GROUP BY T1.Name ORDER BY COUNT(*) DESC LIMIT 1

extra pred: SELECT country.name FROM country WHERE country.code = ( SELECT countrycode FROM countrylanguage GROUP BY countrycode ORDER BY COUNT(DISTINCT language) DESC LIMIT 1 );
extra gold: SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode GROUP BY T1.Name ORDER BY COUNT(*) DESC LIMIT 1

easy pred: SELECT COUNT(DISTINCT country.name) FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE countrylanguage.language IN ('English', 'Dutch') GROUP BY country.code HAVING COUNT(DISTINCT countrylanguage.language) = 2;
easy gold: SELECT COUNT(*) FROM (SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "English" INTERSECT SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "Dutch")

easy pred: SELECT COUNT(DISTINCT country.code) FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE countrylanguage.language IN ('English', 'Dutch');
easy gold: SELECT COUNT(*) FROM (SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "English" INTERSECT SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "Dutch")

extra pred: SELECT country.name FROM country WHERE country.code IN (SELECT countrycode FROM countrylanguage WHERE language = "English" AND isofficial = 1) AND country.code IN (SELECT countrycode FROM countrylanguage WHERE language = "French" AND isofficial = 1);
extra gold: SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "English" AND T2.IsOfficial  =  "T" INTERSECT SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "French" AND T2.IsOfficial  =  "T"

hard pred: SELECT region FROM country WHERE code IN ( SELECT countrycode FROM countrylanguage WHERE language IN ('English', 'Dutch') )
hard gold: SELECT DISTINCT T1.Region FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "English" OR T2.Language  =  "Dutch"

extra pred: SELECT country.name FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE countrylanguage.language IN ('English', 'Dutch') AND countrylanguage.isofficial = 1;
extra gold: SELECT * FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "English" AND IsOfficial  =  "T" UNION SELECT * FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "Dutch" AND IsOfficial  =  "T"

extra pred: SELECT language FROM countrylanguage WHERE countrycode IN ( SELECT code FROM country WHERE continent = 'Asia' ) ORDER BY percentage DESC LIMIT 1;
extra gold: SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T1.Continent  =  "Asia" GROUP BY T2.Language ORDER BY COUNT (*) DESC LIMIT 1

extra pred: SELECT city.name FROM city JOIN country ON city.countrycode = country.code JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE countrylanguage.language = "English" ORDER BY city.population DESC LIMIT 1;
extra gold: SELECT T1.Name ,  T1.Population FROM city AS T1 JOIN countrylanguage AS T2 ON T1.CountryCode  =  T2.CountryCode WHERE T2.Language  =  "English" ORDER BY T1.Population DESC LIMIT 1

extra pred: SELECT city.name FROM city INNER JOIN countrylanguage ON city.countrycode = countrylanguage.countrycode WHERE countrylanguage.language = 'English' ORDER BY city.population DESC LIMIT 1;
extra gold: SELECT T1.Name ,  T1.Population FROM city AS T1 JOIN countrylanguage AS T2 ON T1.CountryCode  =  T2.CountryCode WHERE T2.Language  =  "English" ORDER BY T1.Population DESC LIMIT 1

medium pred: SELECT countrylanguage.language FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE country.headofstate = 'Beatrix' AND countrylanguage.isofficial = 1;
medium gold: SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T1.HeadOfState  =  "Beatrix" AND T2.IsOfficial  =  "T"

medium pred: SELECT COUNT(DISTINCT language) FROM countrylanguage WHERE countrycode IN ( 
medium gold: SELECT count(DISTINCT T2.Language) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE  IndepYear  <  1930 AND T2.IsOfficial  =  "T"

medium pred: SELECT COUNT(DISTINCT language) FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE indepyear < 1930 AND isofficial = 1;
medium gold: SELECT count(DISTINCT T2.Language) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE  IndepYear  <  1930 AND T2.IsOfficial  =  "T"

hard pred: SELECT code, name, surfacearea FROM country WHERE surfacearea > ( SELECT MAX(surfacearea) FROM country WHERE continent = 'Europe' )
hard gold: SELECT Name FROM country WHERE SurfaceArea  >  (SELECT min(SurfaceArea) FROM country WHERE Continent  =  "Europe")

hard pred: SELECT country.name FROM country WHERE country.surfacearea > (SELECT MAX(surfacearea) FROM country WHERE continent = 'Europe')
hard gold: SELECT Name FROM country WHERE SurfaceArea  >  (SELECT min(SurfaceArea) FROM country WHERE Continent  =  "Europe")

extra pred: SELECT country.name FROM country WHERE country.continent = "Africa" AND country.population < (SELECT MIN(population) FROM country WHERE continent = "Asia");
extra gold: SELECT Name FROM country WHERE Continent  =  "Africa"  AND population  <  (SELECT max(population) FROM country WHERE Continent  =  "Asia")

extra pred: SELECT country.name FROM country WHERE country.continent = "Asia" AND country.population > ( SELECT MAX(population) FROM country WHERE continent = "Africa" );
extra gold: SELECT Name FROM country WHERE Continent  =  "Asia"  AND population  >  (SELECT min(population) FROM country WHERE Continent  =  "Africa")

hard pred: SELECT country.code FROM country WHERE country.code NOT IN (SELECT countrycode FROM countrylanguage WHERE language = 'English');
hard gold: SELECT CountryCode FROM countrylanguage EXCEPT SELECT CountryCode FROM countrylanguage WHERE LANGUAGE  =  "English"

hard pred: SELECT country.code FROM country WHERE country.code NOT IN (SELECT countrylanguage.countrycode FROM countrylanguage WHERE countrylanguage.language = "English");
hard gold: SELECT CountryCode FROM countrylanguage EXCEPT SELECT CountryCode FROM countrylanguage WHERE LANGUAGE  =  "English"

extra pred: SELECT city.name FROM city JOIN country ON city.countrycode = country.code JOIN countrylanguage ON countrylanguage.countrycode = country.code WHERE country.continent = 'Europe' AND countrylanguage.language <> 'English' AND countrylanguage.isofficial = 'N';
extra gold: SELECT DISTINCT T2.Name FROM country AS T1 JOIN city AS T2 ON T2.CountryCode  =  T1.Code WHERE T1.Continent  =  'Europe' AND T1.Name NOT IN (SELECT T3.Name FROM country AS T3 JOIN countrylanguage AS T4 ON T3.Code  =  T4.CountryCode WHERE T4.IsOfficial  =  'T' AND T4.Language  =  'English')

extra pred: SELECT city.name FROM city JOIN country ON city.countrycode = country.code JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE country.continent = 'Europe' AND countrylanguage.language != 'English' AND countrylanguage.isofficial = 'F';
extra gold: SELECT DISTINCT T2.Name FROM country AS T1 JOIN city AS T2 ON T2.CountryCode  =  T1.Code WHERE T1.Continent  =  'Europe' AND T1.Name NOT IN (SELECT T3.Name FROM country AS T3 JOIN countrylanguage AS T4 ON T3.Code  =  T4.CountryCode WHERE T4.IsOfficial  =  'T' AND T4.Language  =  'English')

hard pred: SELECT city.name FROM city JOIN country ON city.countrycode = country.code JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE country.continent = 'Asia' AND countrylanguage.language = 'Chinese' AND countrylanguage.isofficial = 'T';
hard gold: select distinct t3.name from country as t1 join countrylanguage as t2 on t1.code  =  t2.countrycode join city as t3 on t1.code  =  t3.countrycode where t2.isofficial  =  't' and t2.language  =  'chinese' and t1.continent  =  "asia"

hard pred: SELECT city.name FROM city JOIN country ON city.countrycode = country.code JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE country.continent = 'Asia' AND countrylanguage.language = 'Chinese' AND countrylanguage.isofficial = 1;
hard gold: SELECT DISTINCT T3.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode JOIN city AS T3 ON T1.Code  =  T3.CountryCode WHERE T2.IsOfficial  =  'T' AND T2.Language  =  'Chinese' AND T1.Continent  =  "Asia"

medium pred: SELECT country.name, country.indepyear, country.surfacearea FROM country WHERE country.population = (SELECT MIN(population) FROM country);
medium gold: SELECT Name ,  SurfaceArea ,  IndepYear FROM country ORDER BY Population LIMIT 1

medium pred: SELECT country.name, country.indepyear, country.surfacearea FROM country WHERE country.population = ( SELECT MIN(population) FROM country )
medium gold: SELECT Name ,  SurfaceArea ,  IndepYear FROM country ORDER BY Population LIMIT 1

medium pred: SELECT governmentform, SUM(population) AS total_population FROM country WHERE lifeexpectancy > 72 GROUP BY governmentform;
medium gold: SELECT sum(Population) ,  GovernmentForm FROM country GROUP BY GovernmentForm HAVING avg(LifeExpectancy)  >  72

medium pred: SELECT country.governmentform, SUM(country.population) AS total_population FROM country WHERE country.governmentform IN ( SELECT DISTINCT country.governmentform FROM country WHERE country.lifeexpectancy > 72 ) GROUP BY country.governmentform;
medium gold: SELECT sum(Population) ,  GovernmentForm FROM country GROUP BY GovernmentForm HAVING avg(LifeExpectancy)  >  72

hard pred: SELECT SUM(population), AVG(surfacearea) FROM country WHERE continent = 'North America' AND surfacearea > 3000;
hard gold: select sum(population) ,  avg(surfacearea) from country where continent  =  "north america" and surfacearea  >  3000

hard pred: SELECT SUM(population), AVG(surfacearea) FROM country WHERE continent = "North America" AND surfacearea > 3000;
hard gold: select sum(population) ,  avg(surfacearea) from country where continent  =  "north america" and surfacearea  >  3000

medium pred: SELECT country.name, countrylanguage.language FROM country INNER JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE countrylanguage.percentage = ( SELECT MAX(percentage) FROM countrylanguage WHERE countrylanguage.countrycode = country.code ) GROUP BY country.name;
medium gold: SELECT LANGUAGE ,  CountryCode ,  max(Percentage) FROM countrylanguage GROUP BY CountryCode

medium pred: SELECT country.code, countrylanguage.language FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode GROUP BY country.code HAVING MAX(countrylanguage.percentage) = countrylanguage.percentage;
medium gold: SELECT LANGUAGE ,  CountryCode ,  max(Percentage) FROM countrylanguage GROUP BY CountryCode

extra pred: SELECT COUNT(DISTINCT country.code) FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE countrylanguage.language = 'Spanish' GROUP BY countrylanguage.language HAVING countrylanguage.percentage = MAX(countrylanguage.percentage);
extra gold: SELECT count(*) ,   max(Percentage) FROM countrylanguage WHERE LANGUAGE  =  "Spanish" GROUP BY CountryCode

extra pred: SELECT COUNT(countrycode) FROM countrylanguage WHERE language = 'Spanish' AND isofficial = 'T' AND percentage > 50;
extra gold: SELECT count(*) ,   max(Percentage) FROM countrylanguage WHERE LANGUAGE  =  "Spanish" GROUP BY CountryCode

medium pred: SELECT countrycode FROM countrylanguage WHERE language = "Spanish" ORDER BY percentage DESC LIMIT 1;
medium gold: SELECT CountryCode ,  max(Percentage) FROM countrylanguage WHERE LANGUAGE  =  "Spanish" GROUP BY CountryCode

medium pred: SELECT country.code FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE countrylanguage.language = "Spanish" AND countrylanguage.isofficial = 1 AND countrylanguage.percentage > 50;
medium gold: SELECT CountryCode ,  max(Percentage) FROM countrylanguage WHERE LANGUAGE  =  "Spanish" GROUP BY CountryCode

extra pred: SELECT conductor.name FROM conductor JOIN orchestra ON conductor.conductor_id = orchestra.conductor_id GROUP BY conductor.name ORDER BY COUNT(DISTINCT orchestra.orchestra_id) DESC LIMIT 1;
extra gold: SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID  =  T2.Conductor_ID GROUP BY T2.Conductor_ID ORDER BY COUNT(*) DESC LIMIT 1

extra pred: SELECT conductor.name FROM conductor JOIN orchestra ON conductor.conductor_id = orchestra.conductor_id GROUP BY conductor.name ORDER BY COUNT(orchestra.orchestra_id) DESC LIMIT 1;
extra gold: SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID  =  T2.Conductor_ID GROUP BY T2.Conductor_ID ORDER BY COUNT(*) DESC LIMIT 1

medium pred: SELECT major_record_format FROM orchestra GROUP BY major_record_format ORDER BY COUNT(*) DESC;
medium gold: SELECT Major_Record_Format FROM orchestra GROUP BY Major_Record_Format ORDER BY COUNT(*) ASC

medium pred: SELECT highschooler.id, COUNT(friend.friend_id) FROM highschooler LEFT JOIN friend ON highschooler.id = friend.student_id GROUP BY highschooler.id;
medium gold: SELECT student_id ,  count(*) FROM Friend GROUP BY student_id

medium pred: SELECT highschooler.name, COUNT(friend.friend_id) AS number_of_friends FROM highschooler JOIN friend ON highschooler.id = friend.student_id GROUP BY highschooler.name;
medium gold: SELECT T2.name ,  count(*) FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id  =  T2.id GROUP BY T1.student_id

medium pred: SELECT highschooler.name, COUNT(friend.friend_id) AS num_friends FROM highschooler LEFT JOIN friend ON friend.student_id = highschooler.id GROUP BY highschooler.name;
medium gold: SELECT T2.name ,  count(*) FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id  =  T2.id GROUP BY T1.student_id

hard pred: SELECT highschooler.name FROM highschooler JOIN friend ON friend.friend_id = highschooler.id WHERE highschooler.name = "Kyle";
hard gold: SELECT T3.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id  =  T2.id JOIN Highschooler AS T3 ON T1.friend_id  =  T3.id WHERE T2.name  =  "Kyle"

hard pred: SELECT highschooler.id FROM highschooler INNER JOIN friend ON friend.student_id = highschooler.id INNER JOIN likes ON likes.student_id = highschooler.id GROUP BY highschooler.id HAVING COUNT(*) > 0;
hard gold: SELECT student_id FROM Friend INTERSECT SELECT liked_id FROM Likes

hard pred: SELECT name FROM highschooler WHERE id IN (SELECT student_id FROM friend) AND id IN (SELECT student_id FROM likes)
hard gold: SELECT T2.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id  =  T2.id INTERSECT SELECT T2.name FROM Likes AS T1 JOIN Highschooler AS T2 ON T1.liked_id  =  T2.id

medium pred: SELECT highschooler.name, COUNT(likes.student_id) FROM highschooler INNER JOIN likes ON highschooler.id = likes.student_id GROUP BY highschooler.name;
medium gold: SELECT T2.name ,  count(*) FROM Likes AS T1 JOIN Highschooler AS T2 ON T1.student_id  =  T2.id GROUP BY T1.student_id

medium pred: SELECT highschooler.name, COUNT(likes.liked_id) FROM highschooler JOIN likes ON highschooler.id = likes.student_id GROUP BY highschooler.name;
medium gold: SELECT T2.name ,  count(*) FROM Likes AS T1 JOIN Highschooler AS T2 ON T1.student_id  =  T2.id GROUP BY T1.student_id

hard pred: SELECT dogs.name FROM dogs JOIN treatments ON dogs.dog_id = treatments.dog_id GROUP BY dogs.dog_id HAVING SUM(treatments.cost_of_treatment) <= 1000;
hard gold: select name from dogs where dog_id not in ( select dog_id from treatments group by dog_id having sum(cost_of_treatment)  >  1000 )

hard pred: SELECT dogs.name FROM dogs JOIN owners ON dogs.owner_id = owners.owner_id JOIN treatments ON dogs.dog_id = treatments.dog_id WHERE owners.owner_id NOT IN ( SELECT owners.owner_id FROM owners JOIN dogs ON dogs.owner_id = owners.owner_id JOIN treatments ON dogs.dog_id = treatments.dog_id WHERE treatments.cost_of_treatment > 1000 );
hard gold: select name from dogs where dog_id not in ( select dog_id from treatments group by dog_id having sum(cost_of_treatment)  >  1000 )

extra pred: SELECT owners.owner_id, owners.last_name FROM owners JOIN dogs ON dogs.owner_id = owners.owner_id JOIN treatments ON treatments.dog_id = dogs.dog_id GROUP BY owners.owner_id ORDER BY SUM(treatments.cost_of_treatment) DESC LIMIT 1;
extra gold: SELECT T1.owner_id ,  T1.last_name FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id  =  T2.owner_id JOIN Treatments AS T3 ON T2.dog_id  =  T3.dog_id GROUP BY T1.owner_id ORDER BY count(*) DESC LIMIT 1

extra pred: SELECT first_name, last_name FROM professionals WHERE professional_id IN (SELECT professional_id FROM treatments WHERE cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM treatments));
extra gold: SELECT DISTINCT T1.first_name ,  T1.last_name FROM Professionals AS T1 JOIN Treatments AS T2 WHERE cost_of_treatment  <  ( SELECT avg(cost_of_treatment) FROM Treatments )

extra pred: SELECT professionals.first_name, professionals.last_name FROM professionals INNER JOIN treatments ON treatments.professional_id = professionals.professional_id WHERE treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM treatments);
extra gold: SELECT DISTINCT T1.first_name ,  T1.last_name FROM Professionals AS T1 JOIN Treatments AS T2 WHERE cost_of_treatment  <  ( SELECT avg(cost_of_treatment) FROM Treatments )

medium pred: SELECT owners.first_name, owners.last_name, sizes.size_description FROM owners JOIN dogs ON dogs.owner_id = owners.owner_id JOIN sizes ON dogs.size_code = sizes.size_code;
medium gold: SELECT T1.first_name ,  T1.last_name ,  T2.size_code FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id  =  T2.owner_id

medium pred: SELECT owners.first_name, owners.last_name, sizes.size_description FROM owners JOIN dogs ON owners.owner_id = dogs.owner_id JOIN sizes ON dogs.size_code = sizes.size_code;
medium gold: SELECT T1.first_name ,  T1.last_name ,  T2.size_code FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id  =  T2.owner_id

extra pred: SELECT dogs.name, treatments.date_of_treatment FROM dogs JOIN breeds ON dogs.breed_code = breeds.breed_code JOIN treatments ON treatments.dog_id = dogs.dog_id WHERE breeds.breed_name = ( SELECT breed_name FROM breeds ORDER BY breed_code LIMIT 1 ) ORDER BY treatments.date_of_treatment;
extra gold: SELECT T1.name ,  T2.date_of_treatment FROM Dogs AS T1 JOIN Treatments AS T2 ON T1.dog_id  =  T2.dog_id WHERE T1.breed_code  =  ( SELECT breed_code FROM Dogs GROUP BY breed_code ORDER BY count(*) ASC LIMIT 1 )

extra pred: SELECT dogs.name, treatments.date_of_treatment FROM dogs JOIN breeds ON dogs.breed_code = breeds.breed_code JOIN treatments ON dogs.dog_id = treatments.dog_id JOIN treatment_types ON treatments.treatment_type_code = treatment_types.treatment_type_code WHERE breeds.breed_code IN ( SELECT breed_code FROM breeds GROUP BY breed_code HAVING COUNT(*) = 1 );
extra gold: SELECT T1.name ,  T2.date_of_treatment FROM Dogs AS T1 JOIN Treatments AS T2 ON T1.dog_id  =  T2.dog_id WHERE T1.breed_code  =  ( SELECT breed_code FROM Dogs GROUP BY breed_code ORDER BY count(*) ASC LIMIT 1 )

medium pred: SELECT owners.first_name, dogs.name FROM owners JOIN dogs ON owners.owner_id = dogs.owner_id WHERE owners.street LIKE '%Virginia%'
medium gold: SELECT T1.first_name ,  T2.name FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id  =  T2.owner_id WHERE T1.state  =  'Virginia'

extra pred: SELECT owners.last_name FROM owners JOIN dogs ON owners.owner_id = dogs.owner_id WHERE dogs.age = ( SELECT MIN(age) FROM dogs )
extra gold: SELECT T1.last_name FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id  =  T2.owner_id WHERE T2.age  =  ( SELECT max(age) FROM Dogs )

extra pred: SELECT owners.last_name FROM owners JOIN dogs ON owners.owner_id = dogs.owner_id WHERE dogs.age = (SELECT MIN(age) FROM dogs);
extra gold: SELECT T1.last_name FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id  =  T2.owner_id WHERE T2.age  =  ( SELECT max(age) FROM Dogs )

medium pred: SELECT breeds.breed_name, sizes.size_description FROM breeds, sizes, dogs WHERE dogs.breed_code = breeds.breed_code AND dogs.size_code = sizes.size_code
medium gold: SELECT DISTINCT breed_code ,  size_code FROM dogs

medium pred: SELECT DISTINCT breeds.breed_name, sizes.size_description FROM dogs JOIN breeds ON dogs.breed_code = breeds.breed_code JOIN sizes ON dogs.size_code = sizes.size_code;
medium gold: SELECT DISTINCT breed_code ,  size_code FROM dogs

easy pred: SELECT name FROM singer WHERE citizenship != 'French';
easy gold: SELECT Name FROM singer WHERE Citizenship != "France"

medium pred: SELECT name FROM singer WHERE singer_id IN ( SELECT singer_id FROM song WHERE sales > 300000 );
medium gold: SELECT DISTINCT T1.Name FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID  =  T2.Singer_ID WHERE T2.Sales  >  300000

hard pred: SELECT DISTINCT citizenship FROM singer WHERE birth_year < 1945 AND birth_year > 1955;
hard gold: SELECT Citizenship FROM singer WHERE Birth_Year  <  1945 INTERSECT SELECT Citizenship FROM singer WHERE Birth_Year  >  1955

medium pred: SELECT ref_property_types.property_type_description FROM properties INNER JOIN ref_property_types ON properties.property_type_code = ref_property_types.property_type_code WHERE properties.property_type_code = "code";
medium gold: SELECT T2.property_type_description FROM Properties AS T1 JOIN Ref_Property_Types AS T2 ON T1.property_type_code  =  T2.property_type_code GROUP BY T1.property_type_code

hard pred: SELECT properties.property_name FROM properties JOIN ref_property_types ON properties.property_type_code = ref_property_types.property_type_code WHERE ref_property_types.property_type_description IN ('House', 'Apartment') AND properties.room_count > 1
hard gold: SELECT property_name FROM Properties WHERE property_type_code  =  "House" UNION SELECT property_name FROM Properties WHERE property_type_code  =  "Apartment" AND room_count  >  1

                     easy                 medium               hard                 extra                all                 
count                248                  446                  174                  166                  1034                
=====================   EXECUTION ACCURACY     =====================
execution            0.927                0.850                0.776                0.620                0.819               

====================== EXACT MATCHING ACCURACY =====================
exact match          0.802                0.435                0.356                0.181                0.469               

---------------------PARTIAL MATCHING ACCURACY----------------------
select               0.952                0.857                0.925                0.873                0.897               
select(no AGG)       0.965                0.872                0.925                0.881                0.908               
where                0.943                0.571                0.587                0.434                0.638               
where(no OP)         0.953                0.582                0.663                0.539                0.677               
group(no Having)     0.933                0.795                0.848                0.500                0.712               
group                0.400                0.636                0.788                0.426                0.568               
order                0.905                0.925                0.643                0.526                0.723               
and/or               1.000                0.971                0.970                0.942                0.973               
IUEN                 0.000                0.000                0.667                0.714                0.647               
keywords             0.965                0.797                0.754                0.714                0.808               
---------------------- PARTIAL MATCHING RECALL ----------------------
select               0.875                0.632                0.713                0.663                0.709               
select(no AGG)       0.887                0.643                0.713                0.669                0.718               
where                0.926                0.577                0.574                0.351                0.611               
where(no OP)         0.935                0.588                0.649                0.436                0.649               
group(no Having)     0.700                0.263                0.718                0.342                0.384               
group                0.300                0.211                0.667                0.291                0.306               
order                0.864                0.653                0.491                0.380                0.541               
and/or               0.996                0.991                0.953                0.936                0.977               
IUEN                 0.000                0.000                0.143                0.147                0.145               
keywords             0.913                0.571                0.580                0.542                0.627               
---------------------- PARTIAL MATCHING F1 --------------------------
select               0.912                0.728                0.805                0.753                0.792               
select(no AGG)       0.924                0.741                0.805                0.760                0.802               
where                0.935                0.574                0.581                0.388                0.624               
where(no OP)         0.944                0.585                0.656                0.482                0.662               
group(no Having)     0.800                0.395                0.778                0.406                0.499               
group                0.343                0.316                0.722                0.346                0.398               
order                0.884                0.766                0.557                0.441                0.619               
and/or               0.998                0.981                0.961                0.939                0.975               
IUEN                 1.000                1.000                0.235                0.244                0.237               
keywords             0.938                0.666                0.656                0.616                0.706               
