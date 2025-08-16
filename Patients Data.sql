/*
 * SQL Server Practice Questions  https://www.sql-practice.com/
 * The data has four tables Patients, Doctors, Admissions, Province_names
 * Patients: patient details (name, gender, birth date, allergies, etc.)
 * Doctors: doctor details (name, specialty)
 * Admissions: hospital admissions (dates, diagnosis, attending doctor)
 * Province_names: province codes and full province names
 * patient_id is the primary key in patients table which is connected to admissions table
 * province_names and patients table is connected by province_id
 * doctors and admissions table is connected by doctor_id
 */


-- 1. Show first name, last name, and gender of patients whose gender is 'M'
SELECT first_name, last_name, gender FROM patients WHERE gender = 'M';

-- 2. Show first name and last name of patients who do not have allergies (null)
SELECT first_name, last_name FROM patients WHERE allergies IS NULL;

-- 3. Show first name of patients that start with the letter 'C'
SELECT first_name FROM patients WHERE first_name LIKE 'C%';

-- 4. Show first name and last name of patients that weigh between 100 and 120 (inclusive)
SELECT first_name, last_name FROM patients WHERE weight BETWEEN 100 AND 120;

-- 5. Update the allergies column: replace NULL with 'NKA'
UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL;

-- 6. Show first name and last name concatenated into one column as full name
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM patients;

-- 7. Show first name, last name, and full province name of each patient
-- Example: 'Ontario' instead of 'ON'
SELECT p.first_name, p.last_name, pn.province_name
FROM patients p
JOIN province_names pn ON p.province_id = pn.province_id;

-- 8. Show how many patients have a birth year of 2010
SELECT COUNT(*) AS patient_count FROM patients WHERE YEAR(birth_date) = 2010;

-- 9. Show first name, last name, and height of the tallest patient
SELECT first_name, last_name, height FROM patients
WHERE height = (SELECT MAX(height) FROM patients);

-- 10. Show all columns for patients with patient_ids 1, 45, 534, 879, 1000
SELECT * FROM patients WHERE patient_id IN (1, 45, 534, 879, 1000);

-- 11. Show the total number of admissions
SELECT COUNT(*) FROM admissions;

-- 12. Show all columns for admissions where admission and discharge occurred on the same day
SELECT * FROM admissions WHERE admission_date = discharge_date;

-- 13. Show patient_id and total number of admissions for patient_id 579
SELECT patient_id, COUNT(patient_id) AS total_number
FROM admissions
WHERE patient_id = 579
GROUP BY patient_id;

-- 14. Show unique cities for patients in province_id 'NS'
SELECT DISTINCT city FROM patients WHERE province_id = 'NS';

-- 15. Show first name, last name, and birth date of patients taller than 160 cm and weighing over 70 kg
SELECT first_name, last_name, birth_date FROM patients
WHERE height > 160 AND weight > 70;

-- 16. Show list of patients with allergies (not null) from the city of 'Hamilton'
SELECT first_name, last_name, allergies FROM patients
WHERE allergies IS NOT NULL AND city = 'Hamilton';

-- 17. Show unique birth years from patients ordered ascending
SELECT DISTINCT YEAR(birth_date) AS birth_year FROM patients ORDER BY birth_year ASC;

-- 18. Show unique first names occurring only once in the patients table
SELECT first_name FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;

-- 19. Show patient_id and first name where first name starts and ends with 's' and is at least 6 characters long
SELECT patient_id, first_name FROM patients
WHERE first_name LIKE 's%s' AND LEN(first_name) >= 6;

-- 20. Show patient_id, first name, last name for patients diagnosed with 'Dementia' (primary diagnosis stored in admissions)
SELECT p.patient_id, p.first_name, p.last_name
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';

-- 21. Display every patient's first name ordered by length and alphabetically
SELECT first_name FROM patients
ORDER BY LEN(first_name), first_name ASC;

-- 22. Show first name, last name, allergies for patients allergic to 'Penicillin' or 'Morphine'
-- Order by allergies, first name, last name ascending
SELECT first_name, last_name, allergies FROM patients
WHERE allergies IN ('Penicillin', 'Morphine')
ORDER BY allergies, first_name, last_name;

-- 23. Show patient_id and diagnosis for patients admitted multiple times for the same diagnosis
SELECT patient_id, diagnosis FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(diagnosis) > 1;

-- 24. Show city and total number of patients, ordered by total descending then city ascending
SELECT city, COUNT(patient_id) AS total_counts FROM patients
GROUP BY city
ORDER BY total_counts DESC, city ASC;

-- 25. Show first name, last name, and role for every person who is either a patient or doctor
SELECT first_name, last_name, 'Patient' AS role FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS role FROM doctors;

-- 26. Show all allergies ordered by popularity, excluding NULLs
SELECT allergies, COUNT(allergies) AS total_diagnosis
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC;

-- 27. Show patients born in the 1970s sorted by birth date ascending
SELECT first_name, last_name, birth_date FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;

-- 28. Show patient names with last_name uppercase, first_name lowercase, separated by comma. Order by first_name descending
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format
FROM patients
ORDER BY first_name DESC;

-- 29. Show province_id and sum of height for provinces where sum of height >= 7000
SELECT province_id, SUM(height) AS sum_height FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;

-- 30. Show the difference between largest and smallest weight for patients with last name 'Maroni'
SELECT MAX(weight) - MIN(weight) AS weight_delta FROM patients WHERE last_name = 'Maroni';

-- 31. Show days of the month (1-31) and count of admissions, ordered by admissions descending
SELECT DAY(admission_date) AS day_number, COUNT(admission_date) AS no_of_admissions
FROM admissions
GROUP BY DAY(admission_date)
ORDER BY no_of_admissions DESC;

-- 32. Show all columns for patient_id 542's most recent admission
SELECT * FROM admissions
WHERE patient_id = 542 AND admission_date = (
    SELECT MAX(admission_date) FROM admissions WHERE patient_id = 542
);

-- 33. Show first name, last name, and total number of admissions attended for each doctor
SELECT d.first_name, d.last_name, COUNT(a.patient_id) AS total_admissions
FROM admissions a
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
GROUP BY d.first_name, d.last_name;

-- 34. Show doctor_id, full name, first and last admission date attended for each doctor
SELECT d.doctor_id,
       CONCAT(d.first_name, ' ', d.last_name) AS full_name,
       MIN(a.admission_date) AS first_admission_date,
       MAX(a.admission_date) AS last_admission_date
FROM doctors d
JOIN admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;

-- 35. Show total patients per province ordered descending
SELECT pn.province_name, COUNT(p.patient_id) AS patient_count
FROM province_names pn
JOIN patients p ON pn.province_id = p.province_id
GROUP BY pn.province_name
ORDER BY patient_count DESC;

-- 36. Show patient's full name, admission diagnosis, and attending doctor's full name for every admission
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       a.diagnosis,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id;

-- 37. Show first name, last name, and number of duplicate patients based on full name
SELECT first_name, last_name, COUNT(CONCAT(first_name, ' ', last_name)) AS num_of_duplicates
FROM patients
GROUP BY first_name, last_name
HAVING COUNT(CONCAT(first_name, ' ', last_name)) > 1;

-- 38. Show patient's full name, height in feet (rounded 1 decimal), weight in pounds (rounded), birth_date, and gender (non-abbreviated)
SELECT CONCAT(first_name, ' ', last_name) AS patient_name,
       ROUND(height / 30.48, 1) AS height_in_feet,
       ROUND(weight * 2.205, 0) AS weight_in_pounds,
       birth_date,
       CASE WHEN gender = 'M' THEN 'MALE' WHEN gender = 'F' THEN 'FEMALE' END AS gender_type
FROM patients;

-- 39. Show patient_id, first name, last name for patients with no admissions records
SELECT patient_id, first_name, last_name FROM patients
WHERE patient_id NOT IN (SELECT patient_id FROM admissions);

-- 40. Show max, min, average admissions per day (average rounded to 2 decimals)
WITH cte AS (
  SELECT admission_date, COUNT(*) AS cnt FROM admissions GROUP BY admission_date
)
SELECT MAX(cnt) AS max_visits, MIN(cnt) AS min_visits, ROUND(AVG(cnt), 2) AS avg_visits FROM cte;

-- 41. Show patients grouped by weight groups (100-109 = 100 group, etc.), and total patients in each group ordered descending
SELECT COUNT(patient_id) AS patients_in_group,
       (weight / 10) * 10 AS weight_group
FROM patients
GROUP BY (weight / 10) * 10
ORDER BY weight_group DESC;

-- 42. Show patient details and attending doctor's specialty for patients diagnosed with 'Epilepsy' and doctor named 'Lisa'
SELECT p.patient_id, p.first_name, p.last_name, d.specialty
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy' AND d.first_name = 'Lisa';

-- 43. Show patient_id and temporary password generated as concatenation of patient_id, last name length, and birth year for patients with admissions
SELECT DISTINCT p.patient_id,
  CONCAT(p.patient_id, LEN(p.last_name), YEAR(p.birth_date)) AS temp_password
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id;

-- 44. Show insurance status ('Yes' for even patient_id) and total admission cost for each insurance group
WITH CTE AS (
  SELECT patient_id, CASE WHEN patient_id % 2 = 0 THEN 'Yes' ELSE 'No' END AS has_insurance
  FROM admissions
)
SELECT has_insurance,
       SUM(CASE WHEN has_insurance = 'Yes' THEN 10 ELSE 50 END) AS cost_after_insurance
FROM CTE
GROUP BY has_insurance;

-- 45. Show provinces with more male than female patients (full province name only)
WITH CTE AS (
  SELECT gender, COUNT(*) AS gender_count, pn.province_name
  FROM patients p
  JOIN province_names pn ON p.province_id = pn.province_id
  GROUP BY gender, pn.province_name
)
SELECT a.province_name
FROM CTE a
JOIN CTE b ON a.province_name = b.province_name
WHERE a.gender_count > b.gender_count AND a.gender > b.gender;

-- 46. Show all columns for female patients with first name containing 'r' after first two letters, born in Feb, May, or Dec, weighing 60-80, odd patient_id and from city 'Kingston'
SELECT * FROM patients
WHERE first_name LIKE '__r%'
  AND gender = 'F'
  AND MONTH(birth_date) IN (2, 5, 12)
  AND weight BETWEEN 60 AND 80
  AND patient_id % 2 <> 0
  AND city = 'Kingston';

-- 47. Show percentage of patients that are male (rounded to nearest hundredth percent)
SELECT CONCAT(ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM patients), 2), '%') AS percent_male
FROM patients
WHERE gender = 'M';

-- 48. Show daily admission counts and change from previous day
WITH CTE AS (
  SELECT admission_date, COUNT(*) AS admission_count FROM admissions GROUP BY admission_date
)
SELECT admission_date, admission_count,
       admission_count - LAG(admission_count) OVER(ORDER BY admission_date) AS admission_count_change
FROM CTE;

-- 49. Show province names in ascending order with 'Ontario' always on top
SELECT DISTINCT province_name
FROM province_names
ORDER BY CASE WHEN province_name = 'Ontario' THEN 0 ELSE 1 END, province_name ASC;

-- 50. Show yearly admission counts by doctor including doctor_id, full name, specialty, year, and count
SELECT d.doctor_id,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_full_name,
       d.specialty,
       YEAR(a.admission_date) AS year,
       COUNT(a.patient_id) AS total_admissions
FROM doctors d
JOIN admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialty, YEAR(a.admission_date);
