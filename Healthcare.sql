--To display all the information from our tables

SELECT *
FROM PersonalTutorial.dbo.Patients

SELECT *
FROM PersonalTutorial.dbo.Encounters

SELECT *
FROM PersonalTutorial.dbo.Conditions

SELECT *
FROM PersonalTutorial.dbo.Immunizations

SELECT *
FROM PersonalTutorial.dbo.Procedures

SELECT *
FROM PersonalTutorial.dbo.Observations

SELECT *
FROM PersonalTutorial.dbo.Allergies

SELECT *
FROM PersonalTutorial.dbo.Careplans

SELECT *
FROM PersonalTutorial.dbo.Medications


--Cleaning up the datasets

---Dropping irrelevant columns from the Patients dataset
ALTER TABLE PersonalTutorial.dbo.Patients
DROP COLUMN Birthdate, Deathdate, Prefix, Maiden, Marital, Address, Zip

--Dropping the Start and Stop columns
ALTER TABLE PersonalTutorial.dbo.Immunizations
DROP COLUMN Date

ALTER TABLE PersonalTutorial.dbo.Medications
DROP COLUMN Start, Stop

ALTER TABLE PersonalTutorial.dbo.Allergies
DROP COLUMN Stop

--Now to answer some questions

--Write a query that does the following:
--.Lists out number of patients per city in descending order
--.Does not include Quincy
--.Must have at least 20 patients from that city

SELECT City, COUNT(*) Patient_Count
FROM PersonalTutorial.dbo.Patients
WHERE City != 'Quincy'
GROUP BY City
HAVING COUNT(*) >=20
ORDER BY COUNT(*) DESC


--To find out the patients with the highest number of visits
SELECT DISTINCT P.Id, COUNT(E.Id) Visits, P.City 
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Encounters E
ON P.Id = E.Patient
GROUP BY P.Id, P.City
ORDER BY COUNT(E.Id) DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY

--OR

--To check the patients with the highest encounters i.e. appearances at the hospital
SELECT TOP 10 P.Id, COUNT(E.Id) Encounter, P.City 
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Encounters E
ON P.Id = E.Patient
GROUP BY P.Id, P.City
ORDER BY COUNT(E.Id) DESC


--To find out the number of times patients from each city visited the hospital
SELECT P.City, COUNT(E.Id) Visits
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Encounters E
ON P.Id = E.Patient
GROUP BY P.City
ORDER BY COUNT(E.Id) DESC
--The city with the highest number of patients visiting is Boston


--To find out the cities with at least 50 counts of emergency cases
SELECT City, COUNT(EncounterClass) emergency_count
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Encounters E
ON P.Id = E.Patient
WHERE EncounterClass = 'emergency'
GROUP BY City, EncounterClass
HAVING COUNT(EncounterClass) >= 50
ORDER BY COUNT(EncounterClass) DESC


--Write a query to find out number of patients from Boston who came in 2020 and their conditions 
SELECT Description, COUNT(*) count_condition
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Conditions C
ON P.Id = C.Patient
WHERE City = 'Boston'
AND C.Start_Date >= '2020-01-01'
GROUP BY Description
ORDER BY COUNT(*) DESC


--What are the top recurring conditions?
SELECT TOP 12 COUNT(P.Id) Recurring, Description
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Conditions C
ON P.Id = C.Patient
GROUP BY Description
ORDER BY COUNT(Description) DESC
--From a list of 129 different conditions, these are the top 12 recurring conditions


--To find out the month with the highest number of ambulatory cases since 2010.
SELECT EncounterClass, MONTH(Start_Date) months, COUNT (MONTH (Start_Date)) amb_count
FROM PersonalTutorial.dbo.Encounters
WHERE EncounterClass = 'ambulatory'
AND YEAR(Start_Date) >= '2010'
GROUP BY EncounterClass, (MONTH(Start_Date))
ORDER BY COUNT(MONTH(Start_Date)) DESC

--Since 2010, April has been the month with the most number of ambulatory cases, while February has the least.


--Doing the same for emergency cases.

--To find out the month with the highest number of emergency cases since 2010.
SELECT EncounterClass, MONTH(Start_Date) months, COUNT (MONTH (Start_Date)) eme_count
FROM PersonalTutorial.dbo.Encounters
WHERE EncounterClass = 'emergency'
AND YEAR(Start_Date) >= '2010'
GROUP BY EncounterClass, (MONTH(Start_Date))
ORDER BY COUNT(MONTH(Start_Date)) DESC

--Since 2010, December has been the month with the most number of emergency cases, while June has the least.


SELECT Race, COUNT(Race) diabetes_count
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Conditions C
ON P.Id = C.Patient
WHERE P.Race = 'black'
AND C.Description = 'Diabetes'
GROUP BY Race
UNION
SELECT Race, COUNT(Race)
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Conditions C
ON P.Id = C.Patient
WHERE P.Race = 'asian'
AND C.Description = 'Diabetes'
GROUP BY Race
UNION
SELECT Race, COUNT(Race)
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Conditions C
ON P.Id = C.Patient
WHERE P.Race = 'white'
AND C.Description = 'Diabetes'
GROUP BY Race


--To find out the years with the highest immunization count
SELECT YEAR(Date_N) years, COUNT (YEAR (Date_N)) imm_count
FROM PersonalTutorial.dbo.Immunizations
GROUP BY (YEAR(Date_N))
ORDER BY COUNT(YEAR(Date_N)) DESC
OFFSET 0 ROWS
FETCH NEXT 15 ROWS ONLY


--To find out the number of patients that got the IPV in 2020
SELECT COUNT(*) IPV_2020
FROM PersonalTutorial.dbo.Patients P
JOIN PersonalTutorial.dbo.Immunizations I
ON P.Id = I.Patient
WHERE Description = 'IPV'
AND Date_N >= '2020-01-01'


--To get the number of times each medical procedure was carried out
SELECT Description, COUNT(Description) desc_count
FROM PersonalTutorial.dbo.Procedures
GROUP BY Description
ORDER BY COUNT(Description) DESC


SELECT TOP 15 Description, Code, COUNT(Description) desc_count
FROM PersonalTutorial.dbo.Observations
GROUP BY Description, Code
ORDER BY COUNT(Description) DESC


SELECT Description, Code, COUNT(Description) desc_count
FROM PersonalTutorial.dbo.Observations
GROUP BY Description, Code
ORDER BY COUNT(Description) DESC
OFFSET 19 ROWS
FETCH NEXT 10 ROWS ONLY


SELECT Description, Code, COUNT(Description) allergy_count
FROM PersonalTutorial.dbo.Allergies
GROUP BY Description, Code
ORDER BY COUNT(Description)DESC


SELECT Description, Code, COUNT(Description) cps_count
FROM PersonalTutorial.dbo.Careplans
GROUP BY Description, Code
ORDER BY COUNT(Description)DESC


SELECT ReasonDescription, ReasonCode, COUNT(ReasonDescription) med_count
FROM PersonalTutorial.dbo.Medications
GROUP BY ReasonDescription, ReasonCode
ORDER BY COUNT(ReasonDescription)DESC
