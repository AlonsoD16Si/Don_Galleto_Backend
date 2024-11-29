-- Borramos la base de datos si ya existe
DROP DATABASE IF EXISTS Don_Galleto;

-- Creamos la base de datos
CREATE DATABASE Don_Galleto;

-- Usamos la base de datos creada
USE Don_Galleto;
-- Tabla Recetas
CREATE TABLE Recetas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL, -- Nombre de la receta
  gramaje_por_galleta DECIMAL(10, 2) NOT NULL, -- Gramaje por galleta
  galletas_por_lote INT NOT NULL, -- Galletas por lote
  costo_por_galleta DECIMAL(10, 2) NOT NULL, -- Costo de producción por galleta
  precio_venta DECIMAL(10, 2) NOT NULL -- Precio de venta al cliente
);

-- Tabla ModuloPrincipal
CREATE TABLE ModuloPrincipal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255),
  descripcion TEXT
);

-- Tabla ModuloVentas
CREATE TABLE ModuloVentas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_venta ENUM('Unidad', 'Gramaje', 'Monto') NOT NULL, 
  cantidad DECIMAL(10, 2) NOT NULL, -- Cantidad vendida
  precio_unitario DECIMAL(10, 2), -- Precio unitario (nuevo campo para especificar el precio por unidad)
  total_venta DECIMAL(10, 2) NOT NULL, -- Total calculado de la venta
  descuento_aplicado DECIMAL(10, 2) DEFAULT 0, -- Descuento aplicado (nuevo campo para registrar descuentos)
  cliente_pago DECIMAL(10, 2) NOT NULL, -- Monto pagado por el cliente
  cambio DECIMAL(10, 2), -- Cambio dado
  fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
  receta_id INT NOT NULL, -- Relación con la receta vendida
  FOREIGN KEY (receta_id) REFERENCES Recetas(id)
);


-- Modificar la tabla ModuloProduccion para agregar referencia a Recetas
CREATE TABLE ModuloProduccion (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_galleta VARCHAR(255),  -- Tipo de galleta
  cantidad_producida INT,     -- Cantidad de galletas producidas en un lote
  fecha_produccion DATE,      -- Fecha de producción
  caducidad DATE,             -- Fecha de caducidad
  merma INT,                  -- Merma producida durante la producción
  motivo_merma VARCHAR(255),  -- Motivo de la merma
  receta_id INT,              -- Relación con la receta usada
  modulo_principal_id INT,
  cantidad_disponible INT NOT NULL DEFAULT 0,
  FOREIGN KEY (receta_id) REFERENCES Recetas(id),
  FOREIGN KEY (modulo_principal_id) REFERENCES ModuloPrincipal(id)
);


-- Tabla PedidoGalletas
CREATE TABLE PedidoGalletas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_galleta VARCHAR(255),  -- Tipo de galleta
  cantidad INT,               -- Cantidad pedida
  estado VARCHAR(255),        -- Estado del pedido (ej. 'pendiente', 'completado')
  tiempo_estimado_entrega TIME, -- Tiempo estimado de entrega
  modulo_produccion_id INT,
  FOREIGN KEY (modulo_produccion_id) REFERENCES ModuloProduccion(id)
);

-- Tabla AdministracionInsumos
CREATE TABLE AdministracionInsumos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  insumo_nombre VARCHAR(255),  -- Nombre del insumo
  cantidad_existente INT,      -- Cantidad de insumo disponible
  unidad VARCHAR(20) NOT NULL, -- Unidad de medida: 'kg', 'g', 'litros', etc.
  lote_id VARCHAR(255),        -- Identificador del lote
  fecha_registro DATE,         -- Fecha de registro del insumo
  fecha_caducidad DATE         -- Fecha de caducidad
);

-- Tabla InsumosRecibidos
CREATE TABLE InsumosRecibidos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  lote_id VARCHAR(255),         -- ID del lote recibido
  fecha_recepcion DATE,         -- Fecha de recepción del lote
  fecha_caducidad DATE,         -- Fecha de caducidad del lote
  cantidad INT,                 -- Cantidad recibida
  precio_unitario DECIMAL(10, 2), -- Precio por unidad
  administracion_insumos_id INT, -- Relación con la tabla AdministracionInsumos
  FOREIGN KEY (administracion_insumos_id) REFERENCES AdministracionInsumos(id)
);

-- Tabla MermaInsumos
CREATE TABLE MermaInsumos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_insumo VARCHAR(255),    -- Tipo de insumo que sufrió merma
  cantidad_danada INT,         -- Cantidad dañada
  motivo_merma VARCHAR(255),   -- Motivo de la merma
  administracion_insumos_id INT, -- Relación con la tabla AdministracionInsumos
  FOREIGN KEY (administracion_insumos_id) REFERENCES AdministracionInsumos(id)
);

-- Tabla PedidosInsumos
CREATE TABLE PedidosInsumos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  insumo_nombre VARCHAR(255),   -- Nombre del insumo solicitado
  cantidad_sugerida INT,        -- Cantidad sugerida para pedir
  fecha_pedido DATE,            -- Fecha en la que se hizo el pedido
  administracion_insumos_id INT, -- Relación con AdministracionInsumos
  FOREIGN KEY (administracion_insumos_id) REFERENCES AdministracionInsumos(id)
);


-- Tabla IngredientesReceta
CREATE TABLE IngredientesReceta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  receta_id INT NOT NULL,        -- ID de la receta
  insumo_id INT NOT NULL,        -- ID del insumo
  cantidad_necesaria DECIMAL(10, 2) NOT NULL, -- Cantidad necesaria del insumo
  unidad VARCHAR(20) NOT NULL,   -- Unidad del insumo
  FOREIGN KEY (receta_id) REFERENCES Recetas(id),
  FOREIGN KEY (insumo_id) REFERENCES AdministracionInsumos(id)
);

-- Inserción de insumos
INSERT INTO AdministracionInsumos (insumo_nombre, cantidad_existente, unidad, lote_id, fecha_registro, fecha_caducidad)
VALUES
  ('Harina de trigo', 1000, 'kg', 'L001', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 6 MONTH)),
  ('Mantequilla', 1000, 'kg', 'L002', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 4 MONTH)),
  ('Azúcar', 1000, 'kg', 'L003', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 8 MONTH)),
  ('Nueces', 1000, 'kg', 'L004', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 5 MONTH)),
  ('Leche', 1000, 'litros', 'L005', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 MONTH)),
  ('Sal', 1000, 'kg', 'L006', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 12 MONTH)),
  ('Polvo para hornear', 1000, 'kg', 'L007', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 18 MONTH)),
  ('Esencia de vainilla', 1000, 'kg', 'L008', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 24 MONTH));


-- Inserción de recetas
INSERT INTO Recetas (nombre, gramaje_por_galleta, galletas_por_lote, costo_por_galleta, precio_venta)
VALUES
  ('Sorpresa Nuez Don Galleto', 37.00, 750, 4.50, 8.00),
  ('Chispas de Chocolate', 40.00, 700, 5.00, 9.00),
  ('Vainilla Delicada', 35.00, 800, 4.00, 7.50),
  ('Avena y Nueces', 42.00, 650, 5.50, 10.00),
  ('Coco Rallado', 38.00, 700, 4.80, 8.50),
  ('Integrales', 39.00, 750, 5.20, 9.50),
  ('Clásica', 36.00, 750, 4.70, 8.50),
  ('Galleta de Chocolate', 45.00, 650, 6.00, 11.00);
-- Ingredientes para cada receta
INSERT INTO IngredientesReceta (receta_id, insumo_id, cantidad_necesaria, unidad)
VALUES
  -- Sorpresa Nuez Don Galleto
  (1, 1, 5.00, 'kg'), -- Harina de trigo
  (1, 2, 2.50, 'kg'), -- Mantequilla
  (1, 3, 2.50, 'kg'), -- Azúcar
  (1, 4, 1.50, 'kg'), -- Nueces
  (1, 5, 1.00, 'litros'), -- Leche
  (1, 6, 0.05, 'kg'), -- Sal
  (1, 7, 0.05, 'kg'), -- Polvo para hornear
  (1, 8, 0.02, 'kg'), -- Esencia de vainilla

  -- Chispas de Chocolate
  (2, 1, 4.50, 'kg'), -- Harina de trigo
  (2, 2, 2.00, 'kg'), -- Mantequilla
  (2, 3, 2.00, 'kg'), -- Azúcar
  (2, 6, 0.05, 'kg'), -- Sal
  (2, 7, 0.05, 'kg'), -- Polvo para hornear

  -- Vainilla Delicada
  (3, 1, 5.00, 'kg'), -- Harina de trigo
  (3, 2, 2.50, 'kg'), -- Mantequilla
  (3, 3, 2.50, 'kg'), -- Azúcar
  (3, 8, 0.05, 'kg'), -- Esencia de vainilla

  -- Avena y Nueces
  (4, 1, 4.00, 'kg'), -- Harina de trigo
  (4, 4, 2.00, 'kg'), -- Nueces
  (4, 2, 1.50, 'kg'), -- Mantequilla
  (4, 3, 2.00, 'kg'), -- Azúcar

  -- Coco Rallado
  (5, 1, 4.50, 'kg'), -- Harina de trigo
  (5, 2, 2.00, 'kg'), -- Mantequilla
  (5, 3, 2.50, 'kg'), -- Azúcar
  (5, 6, 0.02, 'kg'), -- Sal

  -- Integrales
  (6, 1, 5.50, 'kg'), -- Harina de trigo
  (6, 2, 2.00, 'kg'), -- Mantequilla
  (6, 3, 2.00, 'kg'), -- Azúcar
  (6, 5, 0.80, 'litros'), -- Leche

  -- Clásica
  (7, 1, 5.00, 'kg'), -- Harina de trigo
  (7, 2, 2.50, 'kg'), -- Mantequilla
  (7, 6, 0.05, 'kg'), -- Sal

  -- Galleta de Chocolate
  (8, 1, 4.80, 'kg'), -- Harina de trigo
  (8, 2, 2.50, 'kg'), -- Mantequilla
  (8, 3, 2.50, 'kg'); -- Azúcar
-- Consulta para mostrar ModuloVentas con nombre de receta
CREATE OR REPLACE VIEW VistaModuloVentas AS
SELECT 
  mv.id AS venta_id,
  mv.tipo_venta,
  mv.cantidad,
  mv.precio_unitario,
  mv.total_venta,
  mv.descuento_aplicado,
  mv.cliente_pago,
  mv.cambio,
  mv.fecha_venta,
  r.nombre AS nombre_galleta
FROM ModuloVentas mv
JOIN Recetas r ON mv.receta_id = r.id;

-- Consulta para mostrar ModuloProduccion con nombre de receta
CREATE OR REPLACE VIEW VistaModuloProduccion AS
SELECT 
  mp.id AS produccion_id,
  mp.cantidad_producida,
  mp.fecha_produccion,
  mp.caducidad,
  mp.merma,
  mp.motivo_merma,
  r.nombre AS nombre_galleta,
  mp.cantidad_disponible
FROM ModuloProduccion mp
JOIN Recetas r ON mp.receta_id = r.id;

-- Procedimiento ActualizarInventarioParaProduccion
DROP PROCEDURE IF EXISTS ActualizarInventarioParaProduccion;

DELIMITER $$

CREATE PROCEDURE ActualizarInventarioParaProduccion(
    IN receta_id INT,
    IN lotes_producidos INT
)
BEGIN
    DECLARE cantidad_galletas INT;

    -- Obtener la cantidad de galletas por lote para la receta
    SELECT galletas_por_lote INTO cantidad_galletas
    FROM Recetas
    WHERE id = receta_id;

    -- Inicia la transacción
    START TRANSACTION;

    -- Actualiza el inventario de insumos
    UPDATE AdministracionInsumos AS ai
    JOIN IngredientesReceta AS ir ON ai.id = ir.insumo_id
    SET ai.cantidad_existente = ai.cantidad_existente - (ir.cantidad_necesaria * lotes_producidos)
    WHERE ir.receta_id = receta_id;

    -- Verificar si algún insumo quedó en negativo
    SELECT COUNT(*) INTO @error_count
    FROM AdministracionInsumos
    WHERE cantidad_existente < 0;

    IF @error_count > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente inventario para esta producción.';
    ELSE
        -- Actualizar el stock de galletas en el módulo de producción
        INSERT INTO ModuloProduccion (cantidad_producida, fecha_produccion, caducidad, merma, motivo_merma, receta_id, cantidad_disponible)
        VALUES (
            cantidad_galletas * lotes_producidos,
            CURDATE(),
            DATE_ADD(CURDATE(), INTERVAL 1 MONTH), -- Supón un mes de caducidad
            0, -- Merma inicial
            NULL, -- Sin motivo inicial
            receta_id,
            cantidad_galletas * lotes_producidos
        );

        -- Confirmar la transacción
        COMMIT;
    END IF;
END$$

DELIMITER ;

-- Procedimiento ProcesarVenta
DROP PROCEDURE IF EXISTS ProcesarVenta;

DELIMITER $$

CREATE PROCEDURE ProcesarVenta(
    IN cliente_pago DECIMAL(10, 2),
    IN tipo_venta VARCHAR(255),
    IN cantidad_solicitada DECIMAL(10, 2),
    IN receta_id INT,
    OUT total_venta DECIMAL(10, 2),
    OUT cambio_cliente DECIMAL(10, 2)
)
BEGIN
    DECLARE precio_unitario DECIMAL(10, 2);
    DECLARE cantidad_disponible INT;
    DECLARE cantidad_vendida DECIMAL(10, 2);

    -- Obtener el precio unitario y stock disponible para la receta seleccionada
    SELECT r.precio_venta, SUM(mp.cantidad_disponible)
    INTO precio_unitario, cantidad_disponible
    FROM Recetas r
    JOIN ModuloProduccion mp ON r.id = mp.receta_id
    WHERE r.id = receta_id
    GROUP BY r.precio_venta;

    IF cantidad_disponible IS NULL OR cantidad_disponible <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay stock disponible para esta receta.';
    END IF;

    -- Determinar cantidad según tipo de venta
    IF tipo_venta = 'Unidad' THEN
        SET cantidad_vendida = cantidad_solicitada;
    ELSEIF tipo_venta = 'Gramaje' THEN
        SET cantidad_vendida = CEIL(cantidad_solicitada / (SELECT gramaje_por_galleta FROM Recetas WHERE id = receta_id));
    ELSEIF tipo_venta = 'Monto' THEN
        SET cantidad_vendida = FLOOR(cliente_pago / precio_unitario);
    END IF;

    IF cantidad_vendida > cantidad_disponible THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para completar la venta.';
    END IF;

    -- Calcular total y cambio
    SET total_venta = precio_unitario * cantidad_vendida;
    SET cambio_cliente = cliente_pago - total_venta;

    -- Registrar la venta
    INSERT INTO ModuloVentas (tipo_venta, cantidad, total_venta, cliente_pago, cambio, receta_id)
    VALUES (tipo_venta, cantidad_vendida, total_venta, cliente_pago, cambio_cliente, receta_id);

    -- Reducir stock disponible en los lotes de producción
    UPDATE ModuloProduccion
    SET cantidad_disponible = cantidad_disponible - cantidad_vendida
    WHERE receta_id = receta_id;
END$$

DELIMITER ;


-- Mostrar todos los registros de la tabla Recetas
SELECT * FROM Recetas;

SELECT * FROM AdministracionInsumos;
CALL ActualizarInventarioParaProduccion(1, 1);
CALL ActualizarInventarioParaProduccion(2, 1);
CALL ActualizarInventarioParaProduccion(3, 1);
CALL ActualizarInventarioParaProduccion(4, 1);
CALL ActualizarInventarioParaProduccion(5, 1);
CALL ActualizarInventarioParaProduccion(6, 1);
CALL ActualizarInventarioParaProduccion(7, 1);
CALL ActualizarInventarioParaProduccion(8, 1);

SELECT * FROM AdministracionInsumos;


-- Venta basada en unidades
CALL ProcesarVenta(100.00, 'Unidad', 10, 1, @total_venta, @cambio_cliente);

-- Venta basada en gramaje
CALL ProcesarVenta(150.00, 'Gramaje', 370, 2, @total_venta, @cambio_cliente);

-- Venta basada en monto
CALL ProcesarVenta(500.00, 'Monto', NULL, 3, @total_venta, @cambio_cliente);

-- Consultar resultados
SELECT @total_venta AS TotalVenta, @cambio_cliente AS CambioCliente;
-- Verificar stock actualizado
-- SELECT tipo_galleta, cantidad_disponible
-- FROM ModuloProduccion
-- WHERE receta_id = 1;

-- Mostrar todos los registros de la tabla ModuloVentas
SELECT * FROM ModuloVentas;

-- Mostrar todos los registros de la tabla ModuloProduccion
SELECT * FROM ModuloProduccion;

-- Mostrar todos los registros de la tabla PedidoGalletas
SELECT * FROM PedidoGalletas;

-- Mostrar todos los registros de la tabla AdministracionInsumos
-- SELECT * FROM AdministracionInsumos;

-- Mostrar todos los registros de la tabla InsumosRecibidos
SELECT * FROM InsumosRecibidos;

-- Mostrar todos los registros de la tabla MermaInsumos
SELECT * FROM MermaInsumos;

-- Mostrar todos los registros de la tabla PedidosInsumos
SELECT * FROM PedidosInsumos;



-- SELECT tipo_galleta, cantidad_disponible
-- FROM ModuloProduccion
-- WHERE receta_id = 1;
-- Consultas de ejemplo
SELECT * FROM VistaModuloVentas;
SELECT * FROM VistaModuloProduccion;