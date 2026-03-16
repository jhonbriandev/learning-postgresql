CREATE DATABASE practicev4;

CREATE TABLE producto(
id SERIAL PRIMARY KEY,
nombre VARCHAR(100),
descripcion VARCHAR(200),
precio FLOAT(20),
stock INT,
fecha_expiracion VARCHAR(10),
categoria_id INT,
FOREIGN KEY(categoria_id) REFERENCES categoria(id)
);
CREATE TABLE categoria(
id SERIAL PRIMARY KEY,
nombre VARCHAR(100)
);
CREATE TABLE usuario(
id SERIAL PRIMARY KEY,
nombre VARCHAR(100),
email VARCHAR(100),
ciudad VARCHAR(100),
fecha_registro VARCHAR(10)
);
CREATE TABLE pedido(
id SERIAL PRIMARY KEY,
usuario_id INT,
fecha_pedido VARCHAR(10),
total FLOAT(20),
FOREIGN KEY(usuario_id) REFERENCES usuario(id)
);
CREATE TABLE detalle_pedido(
id SERIAL PRIMARY KEY,
pedido_id INT,
producto_id INT,
cantidad INT,
subtotal FLOAT(20),
FOREIGN KEY(pedido_id) REFERENCES pedido(id),
FOREIGN KEY(producto_id) REFERENCES producto(id)
);

INSERT INTO usuario (nombre,email,ciudad,fecha_registro) 
VALUES('Jael','jea@','Lima','12-12-2009'),
('Raul','dasq@','Puno','13-07-2009'),
('Saul','fdasq@','Jauja','17-07-2009'),
('Juan','wdasq@','Trujillo','11-07-2009');
INSERT INTO categoria (nombre) 
VALUES('aseo'),
('piel'),
('lavanderia');
INSERT INTO producto (nombre,descripcion,precio,stock,fecha_expiracion,categoria_id) 
VALUES('jabon','',1.20,'100','12-12-2026',1),
('derma','',3.20,'100','15-12-2026',2),
('detergente','',5.20,'100','19-12-2026',3),
('shampoo','',2.40,'100','12-12-2026',1),
('pan','',1.0,'10','00-00-0000',''); -- producto creado sin categoria para probar los INNER
INSERT INTO pedido(usuario_id,fecha_pedido,total) 
VALUES(1,'12-02-2026',0),
(2,'13-02-2026',0);
---  Calculo del total --
INSERT INTO detalle_pedido(pedido_id,producto_id,cantidad,subtotal)
VALUES(1,3,10,0),
(1,1,9,0),
(2,2,11,0),
(2,1,15,0);
--- JOIN ---
-- INNER JOIN --
-- Devuelve solo los registros que coinciden en ambas tablas.

SELECT p.nombre, c.nombre AS nombre_categorias
FROM producto AS p
INNER JOIN categoria AS c
ON p.categoria_id = c.id;

-- LEFT JOIN --
-- Todos los registros de la tabla izquierda
-- Solo los coincidentes de la derecha
-- Si no hay coincidencia → NULL
-- Si un producto no tiene categoria asignado,
-- igual aparecerá, pero la categoria será NULL.

SELECT p.nombre, c.nombre AS nombre_categorias
FROM producto AS p
LEFT JOIN categoria AS c
ON p.categoria_id = c.id;

-- RIGHT JOIN ..
-- Es similar pero al reves 

SELECT p.nombre, c.nombre AS nombre_categorias
FROM producto AS p
RIGHT JOIN categoria AS c
ON p.categoria_id = c.id;
-----------------------------------
-- Buscando el subtotal de los productos por detalle_pedido
-- Recordemos que uno o muchos detalles de pedidos ingresaran
-- a un solo pedido.
SELECT pro.nombre,det.id AS numero_detalle_pedido,det.pedido_id 
	AS pertence_pedido,
	ROUND((pro.precio *det.cantidad)::numeric, 2) AS subtotal
FROM producto AS pro
INNER JOIN detalle_pedido AS det
ON pro.id = det.producto_id;

--Entonces modifiquemos
UPDATE detalle_pedido
SET subtotal = 52 WHERE id = 1;
UPDATE detalle_pedido
SET subtotal = 10.80 WHERE id = 2;
UPDATE detalle_pedido
SET subtotal = 35.20 WHERE id = 3;
UPDATE detalle_pedido
SET subtotal = 18 WHERE id = 4;
-- Valida--
SELECT * from detalle_pedido
---------------------------------------------------------------------------
-- TRIGGERS --
-- Primero creas el trigger, luego debes asociarlo y despues insertas.
--- Actualizaremos el subtotal
	-- Crea el trigger
	CREATE OR REPLACE FUNCTION calculate_subtotal()
	RETURNS TRIGGER AS $$
	DECLARE
	    precio_producto NUMERIC;
	BEGIN
	    SELECT precio
	    INTO precio_producto
	    FROM producto
		--el valor que viene de la fila que estás 
		--insertando en detalle_pedido
	    WHERE id = NEW.producto_id;
	
	    IF precio_producto IS NULL THEN
	        RAISE EXCEPTION 'El producto % no existe', NEW.producto_id;
	    END IF;
	
	    NEW.subtotal := precio_producto * NEW.cantidad;
	
	    RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	--Asocia el trigger
	
		CREATE TRIGGER trigger_calculate_subtotal
		BEFORE INSERT OR UPDATE
		ON detalle_pedido
		FOR EACH ROW
		EXECUTE FUNCTION calculate_subtotal();
	-- Validar, creemos un detalle_ped sin poner el subtotal correcto--
		INSERT INTO detalle_pedido(pedido_id,producto_id,cantidad,subtotal)
		VALUES(1,4,10,0);	
		
		SELECT * from detalle_pedido;

--- Actualizaremos el total
	-- Crear el trigger
	CREATE OR REPLACE FUNCTION update_total()
	RETURNS TRIGGER AS $$
	BEGIN
		UPDATE pedido
		SET total = (
				SELECT SUM(subtotal)
				FROM detalle_pedido
				WHERE pedido_id = NEW.pedido_id
	)
	WHERE pedido_id= NEW.pedido_id;
	    RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Asocia el trigger
	CREATE TRIGGER trigger_update_total
	AFTER INSERT OR UPDATE OR DELETE
	ON detalle_pedido
	FOR EACH ROW
	EXECUTE FUNCTION update_total();
	-- Validar--
	-- Primero actualizamos los detalles_pedidos ya existentes
	UPDATE pedido AS ped
	SET total = (
	    SELECT COALESCE(SUM(subtotal), 0)
	    FROM detalle_pedido det
	    WHERE det.pedido_id = ped.id
	);
	-- Ahora lo mostramos todo en pedido
	SELECT * from pedido;
	SELECT current_database();
