-- 1.1 Створіть схему pandemic у базі даних за допомогою SQL-команди.
CREATE DATABASE pandemic;

-- 1.2 Оберіть її як схему за замовчуванням за допомогою SQL-команди.
USE pandemic;

-- 1.3 Імпортуйте дані за допомогою Import wizard.


-- 2 Нормалізуйте таблицю infectious_cases до 3ї нормальної форми.
-- Збережіть у цій же схемі дві таблиці з нормалізованими даними.

-- 2.1 Створення таблиці країн
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    entity VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE
);

-- 2.2 Заповнення таблиці країн з таблиці infectious_cases
INSERT INTO countries (entity, code)
SELECT DISTINCT Entity, Code
FROM infectious_cases;

-- 2.3 Додавання country_id як зовнішнього ключа
ALTER TABLE infectious_cases
ADD COLUMN country_id INT,
ADD FOREIGN KEY (country_id) REFERENCES countries(country_id) ON DELETE CASCADE;

-- 2.4 Оновлення даних у infectious_cases (Заповнення country_id)
UPDATE infectious_cases ic
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
SET ic.country_id = c.country_id;

-- 2.5 Видалення стовпців Entity і Code з infectious_cases
ALTER TABLE infectious_cases
DROP COLUMN Entity,
DROP COLUMN Code;

-- 3. Проаналізуйте дані:
-- Для кожної унікальної комбінації Entity та Code або їх id порахуйте середнє,
-- мінімальне, максимальне значення та суму для атрибута Number_rabies.
-- 💡 Врахуйте, що атрибут Number_rabies може містити порожні значення ‘’ —
-- вам попередньо необхідно їх відфільтрувати.
-- Результат відсортуйте за порахованим середнім значенням у порядку спадання.
-- Оберіть тільки 10 рядків для виведення на екран.

-- 3.1 середнє значення та сума Number_rabies
SELECT ic.country_id, c.entity, c.code, AVG(ic.number_rabies) AS avg_number_rabies, SUM(ic.number_rabies) AS sum_number_rabies
FROM infectious_cases ic
JOIN countries c ON ic.country_id = c.country_id
WHERE ic.number_rabies != ''
GROUP BY ic.country_id
ORDER BY avg_number_rabies DESC
LIMIT 10;

-- 3.2 мінімальне значення та сума Number_rabies
SELECT ic.country_id, c.entity, c.code, MIN(ic.number_rabies) AS min_number_rabies, SUM(ic.number_rabies) AS sum_number_rabies
FROM infectious_cases ic
JOIN countries c ON ic.country_id = c.country_id
WHERE ic.number_rabies != ''
GROUP BY ic.country_id
ORDER BY min_number_rabies DESC
LIMIT 10;

-- 3.3 максимальне значення та сума Number_rabies
SELECT ic.country_id, c.entity, c.code, MAX(ic.number_rabies) AS max_number_rabies, SUM(ic.number_rabies) AS sum_number_rabies
FROM infectious_cases ic
JOIN countries c ON ic.country_id = c.country_id
WHERE ic.number_rabies != ''
GROUP BY ic.country_id
ORDER BY max_number_rabies DESC
LIMIT 10;

