-- Active: 1708459228299@@172.18.241.131@5432@carrent

CREATE TABLE Client (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    address VARCHAR(200),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Branch (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(200),
    phone VARCHAR(20),
    working_hours VARCHAR(100)
);

CREATE TABLE Body_type (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255)
);
CREATE TABLE CarModel (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(100),
    model VARCHAR(100),
    year INT,
    body_type_id INT,
    seats INT,
    FOREIGN KEY (body_type_id) REFERENCES Body_type(id)
);

CREATE TABLE Status (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255)
);

CREATE TABLE Car (
    id SERIAL PRIMARY KEY,
    model_id INT,
    branch_id INT,
    status_id INT(20),
    year INT,
    mileage INT,
    FOREIGN KEY (status_id) REFERENCES Status(id),
    FOREIGN KEY (model_id) REFERENCES CarModel(id),
    FOREIGN KEY (branch_id) REFERENCES Branch(id)
);

CREATE TABLE Rental (
    id SERIAL PRIMARY KEY,
    car_id INT,
    client_id INT,
    start_date DATE,
    end_date DATE,
    cost NUMERIC(10, 2),
    FOREIGN KEY (car_id) REFERENCES Car(id),
    FOREIGN KEY (client_id) REFERENCES Client(id)
);


-- Добавление данных в таблицу Client
INSERT INTO Client (name, surname, address, phone, email) VALUES
('Иван', 'Иванов', 'ул. Пушкина, 10', '123-456-7890', 'ivanov@example.com'),
('Петр', 'Петров', 'пр. Ленина, 25', '987-654-3210', 'petrov@example.com'),
('Анна', 'Сидорова', 'ул. Гагарина, 5', '456-789-0123', 'sidorova@example.com'),
('Елена', 'Николаева', 'ул. Строителей, 15', '789-012-3456', 'nikolaeva@example.com'),
('Максим', 'Максимов', 'пр. Мира, 30', '321-654-9870', 'maksimov@example.com');

-- Добавление данных в таблицу Branch
INSERT INTO Branch (name, address, phone, working_hours) VALUES
('Автоцентр', 'ул. Ленина, 5', '123-456-7890', 'Пн-Пт 9:00-18:00'),
('РентКар', 'пр. Победы, 15', '987-654-3210', 'Пн-Сб 8:00-20:00');

INSERT INTO Body_type (title) VALUES
('седан'),
('хэтчбек');

INSERT INTO CarModel (brand, model, year, body_type_id, seats) VALUES
('Toyota', 'Corolla', 2019, 1, 5),
('Honda', 'Civic', 2018, 1, 5),
('Ford', 'Focus', 2020, 2, 5),
('Chevrolet', 'Cruze', 2017, 1, 5),
('Nissan', 'Altima', 2019, 1, 5);

INSERT INTO Status (title) VALUES
('доступен'),
('арендован');

-- Добавление данных в таблицу Car
INSERT INTO Car (model_id, branch_id, year, mileage, status_id) VALUES
(1, 1, 2019, 50000, 1),
(2, 2, 2018, 60000, 2),
(3, 1, 2020, 40000, 1),
(2, 2, 2020, 70000, 1),
(4, 2, 2019, 55000, 2);

-- Добавление данных в таблицу Rental
INSERT INTO Rental (car_id, client_id, start_date, end_date, cost) VALUES
(11, 1, '2024-02-01', '2024-02-10', 5000),
(12, 2, '2024-01-15', '2024-02-25', 30000),
(13, 3, '2024-02-05', '2024-02-15', 6000),
(14, 4, '2024-01-20', '2024-01-25', 4000),
(15, 5, '2024-02-10', '2024-02-20', 5500);

ALTER TABLE rrental
rename to rental;



COMMENT ON TABLE public.rental IS 'событие аренды';
ALTER TABLE public.rental ALTER COLUMN "car_id" SET NOT NULL;
ALTER TABLE public.rental DROP CONSTRAINT rental_car_id_fkey;
ALTER TABLE public.rental ADD CONSTRAINT rental_car_id_fkey FOREIGN KEY (car_id) REFERENCES public.car(id) ON DELETE CASCADE ON UPDATE CASCADE;
COMMENT ON COLUMN public.rental.car_id IS 'арендуемая машина';
ALTER TABLE public.rental ALTER COLUMN "client_id" SET NOT NULL;
ALTER TABLE public.rental DROP CONSTRAINT rental_car_id_fkey;
ALTER TABLE public.rental ADD CONSTRAINT rental_car_id_fkey FOREIGN KEY (car_id) REFERENCES public.car(id) ON DELETE CASCADE ON UPDATE CASCADE;
COMMENT ON COLUMN public.rental.client_id IS 'клиент арендатор';
ALTER TABLE public.rental ALTER COLUMN "start_date" SET NOT NULL;
COMMENT ON COLUMN public.rental.start_date IS 'начало аренды';
ALTER TABLE public.rental ALTER COLUMN "end_date" SET NOT NULL;
COMMENT ON COLUMN public.rental.end_date IS 'конец аренды';
ALTER TABLE public.rental ALTER COLUMN "cost" SET NOT NULL;
COMMENT ON COLUMN public.rental.cost IS 'цена аренды';

COMMENT ON TABLE public.client IS 'клиент';
ALTER TABLE public.client ALTER COLUMN "name" SET NOT NULL;
COMMENT ON COLUMN public.client.name IS 'имя клиента';
ALTER TABLE public.client ALTER COLUMN "surname" SET NOT NULL;
COMMENT ON COLUMN public.client.surname IS 'фамилия';
COMMENT ON COLUMN public.client.address IS 'адресс';
COMMENT ON COLUMN public.client.phone IS 'номер телефона для связи';
COMMENT ON COLUMN public.client.email IS 'почта для связи';

COMMENT ON TABLE public.car IS 'машина';
ALTER TABLE public.car ALTER COLUMN "model_id" SET NOT NULL;
ALTER TABLE public.car DROP CONSTRAINT car_model_id_fkey;
ALTER TABLE public.car ADD CONSTRAINT car_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.car_model(id) ON DELETE CASCADE ON UPDATE CASCADE;
COMMENT ON COLUMN public.car.model_id IS 'ссылка на таблицу с моделями машин';
ALTER TABLE public.car DROP CONSTRAINT car_branch_id_fkey;
ALTER TABLE public.car ADD CONSTRAINT car_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branch(id) ON DELETE SET NULL ON UPDATE SET NULL;
COMMENT ON COLUMN public.car.branch_id IS 'ссылка на филиал которому машина пренадлежит';
ALTER TABLE public.car ALTER COLUMN "status_id" SET NOT NULL;
ALTER TABLE public.car DROP CONSTRAINT car_status_id_fkey;
ALTER TABLE public.car ADD CONSTRAINT car_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.status(id) ON DELETE CASCADE ON UPDATE CASCADE;
COMMENT ON COLUMN public.car.status_id IS 'ссылка на перечисление статуса';
ALTER TABLE public.car ALTER COLUMN status_id SET DEFAULT 1;
ALTER TABLE public.car ALTER COLUMN "year" SET NOT NULL;
COMMENT ON COLUMN public.car.year IS 'год покупки машины';
ALTER TABLE public.car ALTER COLUMN "mileage" SET NOT NULL;
COMMENT ON COLUMN public.car.mileage IS 'пробег машины';
ALTER TABLE public.car ALTER COLUMN mileage SET DEFAULT 0;

COMMENT ON TABLE public.branch IS 'филиал';
ALTER TABLE public.branch ALTER COLUMN "name" SET NOT NULL;
COMMENT ON COLUMN public.branch.name IS 'название филиала';
COMMENT ON COLUMN public.branch.address IS 'адресс филиала';
COMMENT ON COLUMN public.branch.phone IS 'телефонный номер филиала для связи';
COMMENT ON COLUMN public.branch.working_hours IS 'рабочие часы филиала';
ALTER TABLE public.branch ALTER COLUMN working_hours SET DEFAULT '24 / 7';

COMMENT ON TABLE public.status IS 'перечисление возможных статусов для машины';
ALTER TABLE public.status ALTER COLUMN "title" SET NOT NULL;
COMMENT ON COLUMN public.status.title IS 'статус';

COMMENT ON TABLE public.car_model IS 'модель машины';
ALTER TABLE public.car_model ALTER COLUMN "brand" SET NOT NULL;
COMMENT ON COLUMN public.car_model.brand IS 'марка машины';
ALTER TABLE public.car_model ALTER COLUMN "model" SET NOT NULL;
COMMENT ON COLUMN public.car_model.model IS 'модель машины';
ALTER TABLE public.car_model ALTER COLUMN "year" SET NOT NULL;
COMMENT ON COLUMN public.car_model.year IS 'год начала производства модели';
ALTER TABLE public.car_model ALTER COLUMN "body_type_id" SET NOT NULL;
ALTER TABLE public.car_model DROP CONSTRAINT carmodel_body_type_id_fkey;
ALTER TABLE public.car_model ADD CONSTRAINT carmodel_body_type_id_fkey FOREIGN KEY (body_type_id) REFERENCES public.body_type(id) ON DELETE CASCADE ON UPDATE CASCADE;
COMMENT ON COLUMN public.car_model.body_type_id IS 'ссылка на перечисление типа кузова';
ALTER TABLE public.car_model ALTER COLUMN "seats" SET NOT NULL;
COMMENT ON COLUMN public.car_model.seats IS 'количество седений машины';

COMMENT ON TABLE public.body_type IS 'тип кузова';
ALTER TABLE public.body_type ALTER COLUMN "title" SET NOT NULL;
COMMENT ON COLUMN public.body_type.title IS 'название типа кузова';
