CREATE DATABASE practicev3;

CREATE TABLE empleados(
-- Se usa SERIAL como auto-i
id SERIAL PRIMARY KEY,
nombre VARCHAR(100),
email VARCHAR(100),
salario INT,
areas_id INT,
FOREIGN KEY (areas_id) REFERENCES areas(id)
);

CREATE TABLE areas(
id SERIAL PRIMARY KEY,
nombre VARCHAR(100),
ciudad VARCHAR(100)
)
INSERT INTO empleados(nombre,email,salario,areas_id) VALUES
('gerardo','ss@',3100,1),
('Jesus','fs@',3000,2),
('Raquel','aas@',3100,1),
('Juan','vvs@',3200,1),
('Raul','cccs@',3300,2)
INSERT INTO empleados(nombre,email,salario,areas_id) VALUES
('Jeremias','sas@',5100,1),
('Ruben','fas@',3000,2)
SELECT * from empleados
INSERT INTO areas(nombre,ciudad) VALUES
('Recursos Humanos','Lima'),
('Ventas','Callao')

--SUBCONSULTAS--
-- SIRVE PARA 
--Obtener un valor calculado dinámicamente
--Filtrar resultados usando datos de otra consulta
--Obtener una tabla dinamica temporal
--Comparar contra conjuntos de datos
--   Esta subconsulta se lee de adentro hacia afuera
--   Busca el id de los areas que se encuentran en Lima
--   Y ademas mostrar el nombre de empleados que sus id_areas esten IN Lima
SELECT nombre from empleados WHERE areas_id IN(
	SELECT id from areas WHERE ciudad = 'Lima'
);
--   Busca el promedio del salario, luego muestra los empleados que superen este
SELECT nombre,salario from empleados WHERE salario>(
	SELECT AVG(salario) from empleados
);
--   Busca el promedio de salario de empleados agrupados por areas
--   Y Muestra el grupo del area que sobrepase el sario de 3149
SELECT area,promedio FROM (
	SELECT areas_id AS area,
			AVG(salario) AS promedio
	FROM empleados GROUP BY areas_id		
)AS tabla_promedios WHERE promedio >3140;

-- SUBCONSULTA RELACIONADA
--  Puede leerse en relacion no siempre de adentro hacia afuera
--  El alias es opcional (AS)
--  Muéstra los empleados que ganan más que el promedio de su propia área
SELECT e1.nombre,e1.salario,e1.areas_id
FROM empleados e1
WHERE salario > (
    SELECT AVG(e2.salario)
	-- OPCIONAL (AS)
    FROM empleados AS e2
    WHERE e2.areas_id = e1.areas_id
);







	