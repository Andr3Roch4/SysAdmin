-- INSERT
INSERT INTO person(name, address_number, address_street_name) 
VALUES ('Jon Doe', 1, 'Last St');

-- UPDATE
UPDATE person
SET ssn=123456789
WHERE name='Jon Doe';

-- DELETE
DELETE FROM person
WHERE name='Jon Doe';



-- SOLUÇÃO DO CRIME

-- Relatório de crime:

SELECT *
FROM crime_scene_report
WHERE date='20180115' AND city='SQL City' AND type='murder';

-- Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

-- Testemunhas:

SELECT id, name, address_street_name, address_number
FROM person
WHERE address_street_name='Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;

-- 14887 Morty Schapiro

SELECT id, name, address_street_name, address_number
FROM person
WHERE address_street_name='Franklin Ave' AND name LIKE 'Annabel%';

-- 16371 Annabel Miller

-- Entrevistas:

SELECT person.id, name, transcript
FROM interview
JOIN person ON interview.person_id=person.id
WHERE person.id IN (14887, 16371);

-- I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
-- I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

-- Querry de solução com dados das entrevistas:

SELECT p.name AS Assassino
FROM get_fit_now_member g
JOIN person p ON person_id=p.id
JOIN drivers_license d ON p.license_id=d.id
JOIN get_fit_now_check_in gc ON g.id=gc.membership_id
WHERE membership_status='gold' AND g.id LIKE '48Z%' AND gc.check_in_date='20180109' AND d.plate_number LIKE '%H42W%';

-- Jeremy Bowers

-- Verificar se solução está correta:

INSERT INTO solution VALUES (1, 'Jeremy Bowers');

SELECT value FROM solution;