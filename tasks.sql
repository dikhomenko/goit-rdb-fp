-- Створення схеми (бази даних)
CREATE DATABASE pandemic;

-- Вибір схеми як схеми за замовчуванням
USE pandemic;

-- Створення таблиці країн
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    entity VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE
);

-- Заповнення таблиці країн з таблиці infectious_cases
INSERT INTO countries (entity, code)
SELECT DISTINCT Entity, Code
FROM infectious_cases;

-- Вибірка всіх країн - для перевірки
SELECT * FROM countries;

-- Вибірка всіх випадків інфекційних хвороб - для перевірки
SELECT * FROM infectious_cases;

-- Видалення стовпців Entity і Code з infectious_cases
ALTER TABLE infectious_cases
DROP COLUMN Entity,
DROP COLUMN Code;

-- Додавання country_id як зовнішнього ключа
ALTER TABLE infectious_cases
ADD COLUMN country_id INT,
ADD FOREIGN KEY (country_id) REFERENCES countries(country_id) ON DELETE CASCADE;

-- Оновлення даних у infectious_cases (Заповнення country_id)
UPDATE infectious_cases ic
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
SET ic.country_id = c.country_id;

-- Перевірка результату
SELECT ic.case_id, c.entity, c.code, ic.year, ic.number_yaws, ic.polio_cases
FROM infectious_cases ic
JOIN countries c ON ic.country_id = c.country_id;

