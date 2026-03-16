
CREATE DATABASE practicev2

CREATE TABLE clientes(
-- Se usa SERIAL como auto-i
id SERIAL PRIMARY KEY,
nombre VARCHAR(100),
email VARCHAR(100),
ciudad VARCHAR(100),
edad INT
);


INSERT INTO clientes (id,nombre,email,ciudad,edad) VALUES 
(1,'jhon','j@','lima',23);

INSERT INTO clientes(nombre,email,ciudad,edad) VALUES
('gabriel','g@','Madrid',39);
INSERT INTO clientes(nombre,email,ciudad,edad) VALUES
('gerardo','ss@','Barcelona',31),
('Jesus','fs@','Jaen',30),
('Raquel','aas@','Milan',31),
('Juan','vvs@','Barcelona',32),
('Raul','cccs@','Lima',33)

SELECT * from clientes
-- Ver todos los campos de datos de clientes
SELECT * from clientes;
-- Ver los campos nombre, email de la tabla clientes
SELECT nombre,email from clientes;
-- Ver nombre y ciudad de los clientes registradas en una ciudad
SELECT nombre, ciudad from clientes WHERE ciudad = 'Madrid';
-- Ver nombre, edad de los clientes mayores a 30 aos
SELECT nombre, edad from clientes WHERE edad > 30;
-- Ver nombre, edad de los clientes que no estan registrados en Barcelona
SELECT nombre, ciudad from clientes WHERE ciudad != 'Barcelona';
-- Ver nombre, edad de los clientes ordenados asc por edad.
SELECT nombre,edad from clientes  ORDER BY edad ASC;
-- Ver nombre, edad de los clientes ordenadors dsc por nombre
SELECT nombre from clientes ORDER BY nombre DESC;
-- Ver nombre, edad de los 5 primeros clientes ordenados asc 
SELECT nombre,edad from clientes ORDER BY edad ASC LIMIT 5;
-- Ver nombre, edad de los clientes entre 20 y 40 aos
SELECT nombre,edad from clientes WHERE edad BETWEEN 20 AND 40;
-- Ver nombre, edad de los clientes que empiecen con la letra A
SELECT nombre,edad from clientes WHERE nombre LIKE 'a%';