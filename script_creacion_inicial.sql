USE GD1C2024
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'SQLOVERS')
BEGIN 
	EXEC ('CREATE SCHEMA SQLOVERS')
END
GO

CREATE TABLE Marca_Producto (
  id_prod_marca decimal (18,0) IDENTITY(1,1),
  nombre_prod_marca nvarchar(255),
  PRIMARY KEY (id_prod_marca)
);

CREATE TABLE TipoCaja (
  id_tipo_caja decimal (18, 0) IDENTITY(1,1),
  nombre_tipo_caja nvarchar(255),
  PRIMARY KEY (id_tipo_caja)
);

CREATE TABLE EstadoEnvio (
  id_estado_envio decimal (18, 0) IDENTITY(1,1),
  nombre_estado_envio nvarchar(255),
  PRIMARY KEY (id_estado_envio)
);

CREATE TABLE Provincia (
  id_provincia decimal (18, 0) IDENTITY(1,1),
  nombre_provincia nvarchar(255),
  PRIMARY KEY (id_provincia)
);

CREATE TABLE Tipo_Medio_Pago (
  id_tipo_mp decimal (18,0) IDENTITY(1,1),
  tipo_mp nvarchar(255),
  PRIMARY KEY (id_tipo_mp)
);


CREATE TABLE Categoria (
  id_categoria decimal (18,0) IDENTITY(1,1),
  nombre_categoria nvarchar(255),
  nombre_sub_categoria nvarchar(255),
  PRIMARY KEY (id_categoria)
);

CREATE TABLE Localidad (
  id_localidad decimal (18, 0) IDENTITY(1,1),
  nombre_localidad nvarchar(255),
  id_provincia decimal (18, 0),
  PRIMARY KEY (id_localidad),
  FOREIGN KEY (id_provincia) REFERENCES Provincia(id_provincia)
);

CREATE TABLE Supermercado (
  id_supermercado decimal (18,0) IDENTITY(1,1),
  nombre_super nvarchar(255),
  razon_social_super nvarchar(255),
  cuit_super nvarchar(255),
  ingresos_brutos_super nvarchar(255),
  domicilio_super nvarchar(255),
  fecha_ini_actividad_super datetime,
  condicion_fiscal_super nvarchar(255),
  id_localidad decimal (18,0),
  PRIMARY KEY (id_supermercado),
  FOREIGN KEY (id_localidad) REFERENCES Localidad(id_localidad)
);

CREATE TABLE Sucursal (
  id_sucursal decimal (18,0) IDENTITY(1,1),
  nombre_sucursal nvarchar(255),
  id_localidad decimal (18,0),
  direccion_sucursal nvarchar(255),
  id_supermercado decimal(18,0),
  PRIMARY KEY (id_sucursal),
  FOREIGN KEY (id_localidad) REFERENCES Localidad(id_localidad),
  FOREIGN KEY (id_supermercado) REFERENCES Supermercado(id_supermercado)
);

CREATE TABLE Empleado (
  legajo_empleado decimal(18,0) IDENTITY(1,1),
  id_sucursal decimal(18,0),
  nombre_empleado nvarchar(255),
  apellido_empleado nvarchar(255),
  dni decimal(18,0),
  telefono_empleado decimal(18,0),
  mail_empleado nvarchar(255),
  fecha_registro datetime,
  fecha_nacimiento date,
  PRIMARY KEY (legajo_empleado),
  FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE Producto (
  codigo_producto decimal (18,0) IDENTITY(1,1),
  id_categoria decimal (18,0) ,
  prod_nombre nvarchar(255),
  prod_desc nvarchar(255),
  precio_unitario_producto decimal (18,2) ,
  id_prod_marca decimal (18,0) ,
  PRIMARY KEY (codigo_producto),
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
  FOREIGN KEY (id_prod_marca) REFERENCES Marca_Producto(id_prod_marca)
);

CREATE TABLE Promocion_Producto (
  id_promocion_prod decimal(18,0) IDENTITY(1,1),
  codigo_promo decimal(18,0),
  codigo_producto decimal(18,0),
  descripcion_promo nvarchar(255),
  fecha_inicio_promo datetime,
  fecha_fin_promo datetime,
  PRIMARY KEY (id_promocion_prod, codigo_producto),
  FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo_producto)
);

CREATE TABLE Regla (
  id_regla decimal (18,0) IDENTITY(1,1),
  descripcion_regla nvarchar(255),
  descuento_a_aplicar decimal(18,2),
  cantidad_aplicable_regla decimal(18,0),
  cantidad_aplicable_descuento decimal(18,0),
  cantidad_maxima decimal(18,0),
  misma_marca decimal(18,0),
  mismo_producto decimal(18,0),
  id_promocion_prod decimal(18,0),
  FOREIGN KEY (id_promocion_prod) REFERENCES Promocion_Producto(id_promocion_prod),
  PRIMARY KEY (id_regla)
);

CREATE TABLE Caja (
  caja_numero decimal (18, 0),
  id_sucursal decimal (18, 0),
  id_tipo_caja decimal (18, 0),
  PRIMARY KEY (caja_numero, id_sucursal),
  FOREIGN KEY (id_tipo_caja) REFERENCES TipoCaja(id_tipo_caja),
  FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE Cliente (
  id_cliente decimal (18,0) IDENTITY(1,1),
  nombre_cliente nvarchar(255),
  apellido_cliente nvarchar(255),
  dni_cliente decimal (18,0),
  fecha_registro_cliente datetime,
  telefono_cliente decimal (18,0),
  mail_cliente nvarchar(255),
  fecha_nacimiento_cliente date,
  direccion_cliente nvarchar(255),
  id_localidad decimal (18,0),
  PRIMARY KEY (id_cliente),
  FOREIGN KEY (id_localidad) REFERENCES Localidad(id_localidad)
);

CREATE TABLE Detalle_Pago (
  id_detalle_pago decimal (18,0) IDENTITY(1,1),
  id_cliente decimal (18,0) ,
  nro_tarjeta nvarchar(255),
  fecha_vto_tarjeta datetime,
  cuotas decimal (18,0) ,
  PRIMARY KEY (id_detalle_pago),
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Medio_Pago (
  id_medio_pago decimal (18,0) IDENTITY(1,1),
  nombre_mp nvarchar(255),
  id_tipo_mp decimal (18,0),
  FOREIGN KEY (id_tipo_mp) REFERENCES Tipo_Medio_Pago(id_tipo_mp),
  PRIMARY KEY (id_medio_pago)
);

CREATE TABLE Pago (
  nro_pago decimal(18,0) IDENTITY(1,1),
  id_detalle_pago decimal (18,0) ,
  fecha_pago datetime,
  importe decimal(18,2),
  id_medio_pago decimal (18,0) ,
  FOREIGN KEY (id_detalle_pago) REFERENCES Detalle_Pago(id_detalle_pago),
  FOREIGN KEY (id_medio_pago) REFERENCES Medio_Pago(id_medio_pago),
  PRIMARY KEY (nro_pago)
);

CREATE TABLE Ticket (
  ticket_numero decimal(18,0),
  caja_numero decimal(18,0),
  id_sucursal decimal(18,0),
  fecha_hora datetime,
  legajo_empleado decimal(18,0),
  tipo_comprobante nvarchar(255),
  subtotal_ticket nvarchar(255),
  descuento_promociones nvarchar(255),
  descuento_medio_pago nvarchar(255),
  nro_pago decimal(18,0),
  total_venta decimal(18,2),
  PRIMARY KEY (ticket_numero),
  FOREIGN KEY (legajo_empleado) REFERENCES Empleado(legajo_empleado),
  FOREIGN KEY (caja_numero, id_sucursal) REFERENCES Caja(caja_numero, id_sucursal),
  FOREIGN KEY (nro_pago) REFERENCES Pago(nro_pago)
);

CREATE TABLE ItemProducto (
  ticket_numero decimal (18,0),
  codigo_producto decimal(18,0),
  cantidad_producto decimal(18,0),
  precio_unitario_producto decimal(18,0),
  total_producto decimal(18,0),
  PRIMARY KEY (ticket_numero, codigo_producto),
  FOREIGN KEY (ticket_numero) REFERENCES Ticket(ticket_numero),
  FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo_producto)
);

CREATE TABLE Promocion_x_ItemProducto (
  id_promocion_prod decimal(18,0),
  codigo_producto decimal(18,0),
  ticket_numero decimal (18,0),
  PRIMARY KEY (id_promocion_prod, codigo_producto, ticket_numero),
  FOREIGN KEY (ticket_numero,codigo_producto) REFERENCES ItemProducto(ticket_numero,codigo_producto),
  FOREIGN KEY (id_promocion_prod) REFERENCES Promocion_Producto(id_promocion_prod)
);

CREATE TABLE Descuento_Medio_Pago (
  id_descuento decimal (18,0),
  id_medio_pago decimal (18,0) ,
  descripcion_descuento nvarchar(255),
  fecha_inicio_descuento datetime,
  fecha_fin_descuento datetime,
  porcentaje_descuento decimal (18,2) ,
  tope_descuento decimal (18,2) ,
  PRIMARY KEY (id_descuento),
  FOREIGN KEY (id_medio_pago) REFERENCES Medio_Pago(id_medio_pago)
);

CREATE TABLE Envio (
  nro_envio decimal (18,0) IDENTITY(1,1),
  ticket_numero decimal (18,0),
  fecha_programada_envio datetime,
  horario_inicio_envio decimal (18,0),
  horario_fin_envio decimal (18,0),
  id_cliente decimal (18,0),
  costo_envio decimal (18,2),
  id_estado_envio decimal (18,0),
  fecha_hora_entrega_envio datetime,
  PRIMARY KEY (nro_envio),
  FOREIGN KEY (id_estado_envio) REFERENCES EstadoEnvio(id_estado_envio),
  FOREIGN KEY (ticket_numero) REFERENCES Ticket(ticket_numero),
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE DescuentosMedioPago_X_Pago (
  id_descuento decimal (18,0) ,
  nro_pago decimal (18,0) ,
  PRIMARY KEY (id_descuento, nro_pago),
  FOREIGN KEY (id_descuento) REFERENCES Descuento_Medio_Pago(id_descuento),
  FOREIGN KEY (nro_pago) REFERENCES Pago(nro_pago)
);
GO

INSERT INTO Provincia (nombre_provincia)
SELECT DISTINCT SUPER_PROVINCIA FROM gd_esquema.Maestra UNION 
SELECT DISTINCT SUCURSAL_PROVINCIA FROM gd_esquema.Maestra UNION
SELECT DISTINCT CLIENTE_PROVINCIA FROM gd_esquema.Maestra

INSERT INTO Localidad (nombre_localidad, id_provincia)
SELECT DISTINCT 
    SUPER_LOCALIDAD, 
    (SELECT TOP 1 id_provincia FROM Provincia WHERE nombre_provincia = Maestra.SUPER_PROVINCIA)
FROM 
    gd_esquema.Maestra AS Maestra
WHERE 
    SUPER_LOCALIDAD IS NOT NULL AND SUPER_PROVINCIA IS NOT NULL

UNION 
SELECT DISTINCT 
    SUCURSAL_LOCALIDAD, 
    (SELECT TOP 1 id_provincia FROM Provincia WHERE nombre_provincia = Maestra.SUCURSAL_PROVINCIA)
FROM 
    gd_esquema.Maestra AS Maestra
WHERE 
    SUCURSAL_LOCALIDAD IS NOT NULL AND SUCURSAL_PROVINCIA IS NOT NULL

UNION 
SELECT DISTINCT 
    CLIENTE_LOCALIDAD, 
    (SELECT TOP 1 id_provincia FROM Provincia WHERE nombre_provincia = Maestra.CLIENTE_PROVINCIA)
FROM 
    gd_esquema.Maestra AS Maestra
WHERE 
    CLIENTE_LOCALIDAD IS NOT NULL AND CLIENTE_PROVINCIA IS NOT NULL;

INSERT INTO Supermercado (
    nombre_super, 
    razon_social_super, 
    cuit_super, 
    ingresos_brutos_super, 
    domicilio_super, 
    fecha_ini_actividad_super, 
    condicion_fiscal_super, 
    id_localidad
)
SELECT DISTINCT 
    SUPER_NOMBRE, 
    SUPER_RAZON_SOC, 
    SUPER_CUIT, 
    SUPER_IIBB, 
    SUPER_DOMICILIO, 
    SUPER_FECHA_INI_ACTIVIDAD, 
    SUPER_CONDICION_FISCAL, 
    (SELECT TOP 1 id_localidad 
     FROM Localidad 
     WHERE nombre_localidad = Maestra.SUPER_LOCALIDAD)
FROM 
    gd_esquema.Maestra AS Maestra
WHERE 
    SUPER_NOMBRE IS NOT NULL AND 
    SUPER_RAZON_SOC IS NOT NULL AND 
    SUPER_CUIT IS NOT NULL AND 
    SUPER_IIBB IS NOT NULL AND 
    SUPER_DOMICILIO IS NOT NULL AND 
    SUPER_FECHA_INI_ACTIVIDAD IS NOT NULL AND 
    SUPER_CONDICION_FISCAL IS NOT NULL AND 
    SUPER_LOCALIDAD IS NOT NULL;

INSERT INTO Categoria (nombre_categoria, nombre_sub_categoria)
SELECT DISTINCT PRODUCTO_CATEGORIA, PRODUCTO_SUB_CATEGORIA
FROM gd_esquema.Maestra;

INSERT INTO Marca_Producto (nombre_prod_marca)
SELECT DISTINCT PRODUCTO_MARCA
FROM gd_esquema.Maestra;

INSERT INTO TipoCaja (nombre_tipo_caja)
SELECT DISTINCT CAJA_TIPO
FROM gd_esquema.Maestra;

INSERT INTO Regla (
    descripcion_regla, 
    descuento_a_aplicar, 
    cantidad_aplicable_regla, 
    cantidad_aplicable_descuento, 
    cantidad_maxima, 
    misma_marca, 
    mismo_producto,
	id_promocion_prod
)
SELECT DISTINCT 
    REGLA_DESCRIPCION,
    REGLA_DESCUENTO_APLICABLE_PROD,
    REGLA_CANT_APLICABLE_REGLA,
    REGLA_CANT_APLICA_DESCUENTO,
    REGLA_CANT_MAX_PROD,
    REGLA_APLICA_MISMA_MARCA,
    REGLA_APLICA_MISMO_PROD,
	(SELECT id_promocion_prod FROM Promocion_Producto WHERE id_promocion_prod = PROMO_CODIGO)
FROM gd_esquema.Maestra;


INSERT INTO Cliente (
    nombre_cliente, 
    apellido_cliente,
    dni_cliente,
    fecha_registro_cliente,
    telefono_cliente,
    mail_cliente,
    fecha_nacimiento_cliente,
    direccion_cliente,
    id_localidad
)
SELECT DISTINCT 
    CLIENTE_NOMBRE, 
    CLIENTE_APELLIDO,
    CLIENTE_DNI,
    CLIENTE_FECHA_REGISTRO,
    CLIENTE_TELEFONO,
    CLIENTE_MAIL,
    CLIENTE_FECHA_NACIMIENTO,
    CLIENTE_DOMICILIO,
    (SELECT id_localidad FROM Localidad WHERE nombre_localidad = CLIENTE_LOCALIDAD
	AND id_provincia = (SELECT p.id_provincia FROM Provincia p where p.nombre_provincia = CLIENTE_PROVINCIA))
FROM gd_esquema.Maestra;

INSERT INTO Tipo_Medio_Pago (tipo_mp)
SELECT DISTINCT PAGO_TIPO_MEDIO_PAGO
FROM gd_esquema.Maestra;

INSERT INTO Medio_Pago (
    nombre_mp, 
    id_tipo_mp
)
SELECT DISTINCT 
    PAGO_MEDIO_PAGO, 
    (SELECT id_tipo_mp FROM Tipo_Medio_Pago WHERE tipo_mp = PAGO_TIPO_MEDIO_PAGO)
FROM gd_esquema.Maestra;


INSERT INTO EstadoEnvio (nombre_estado_envio)
SELECT DISTINCT ENVIO_ESTADO
FROM gd_esquema.Maestra;

-- tablas con dependencias
INSERT INTO Sucursal (nombre_sucursal, id_localidad, direccion_sucursal, id_supermercado)
SELECT DISTINCT SUCURSAL_NOMBRE, 
    (SELECT id_localidad FROM Localidad WHERE nombre_localidad = SUCURSAL_LOCALIDAD
	AND id_provincia = (SELECT p.id_provincia FROM Provincia p where p.nombre_provincia = SUCURSAL_PROVINCIA)),
    SUCURSAL_DIRECCION, 
    (SELECT id_supermercado FROM Supermercado WHERE nombre_super = SUPER_NOMBRE)
FROM gd_esquema.Maestra;

INSERT INTO Producto (id_categoria, prod_nombre, prod_desc, precio_unitario_producto, id_prod_marca)
SELECT DISTINCT  
                (SELECT id_categoria FROM Categoria WHERE nombre_categoria = PRODUCTO_CATEGORIA AND nombre_sub_categoria = PRODUCTO_SUB_CATEGORIA), 
                PRODUCTO_NOMBRE, 
                PRODUCTO_DESCRIPCION, 
                PRODUCTO_PRECIO,
                (SELECT id_prod_marca FROM Marca_Producto WHERE nombre_prod_marca = PRODUCTO_MARCA)
FROM gd_esquema.Maestra;

INSERT INTO Empleado (
    id_sucursal, 
    nombre_empleado, 
    apellido_empleado, 
    dni, 
    telefono_empleado, 
    mail_empleado, 
    fecha_registro, 
    fecha_nacimiento
)
SELECT DISTINCT 
        (SELECT id_sucursal FROM Sucursal WHERE nombre_sucursal = SUCURSAL_NOMBRE), 
        EMPLEADO_NOMBRE, 
        EMPLEADO_APELLIDO, 
        EMPLEADO_DNI, 
        EMPLEADO_TELEFONO, 
        EMPLEADO_MAIL, 
        EMPLEADO_FECHA_REGISTRO, 
        EMPLEADO_FECHA_NACIMIENTO
FROM gd_esquema.Maestra;

INSERT INTO Caja (caja_numero, id_sucursal, id_tipo_caja)
SELECT DISTINCT 
    CAJA_NUMERO, 
    (SELECT 
        id_sucursal 
    FROM 
        Sucursal 
    WHERE 
        nombre_sucursal = SUCURSAL_NOMBRE
    AND
        id_supermercado = (
            SELECT 
                id_supermercado 
            FROM 
                Supermercado 
            WHERE 
            nombre_super = SUPER_NOMBRE
        )
    ), 
    (SELECT 
        id_tipo_caja 
    FROM 
        TipoCaja 
    WHERE 
        nombre_tipo_caja = CAJA_TIPO
    )
FROM gd_esquema.Maestra

WHERE CAJA_NUMERO IS NOT NULL;

INSERT INTO Promocion_Producto (
    id_promocion_prod, 
    codigo_producto, 
    descripcion_promo, 
    fecha_inicio_promo, 
    fecha_fin_promo, 
    id_regla
)
SELECT DISTINCT 
    m.PROMO_CODIGO, 
    p.codigo_producto,
    m.PROMOCION_DESCRIPCION, 
    m.PROMOCION_FECHA_INICIO, 
    m.PROMOCION_FECHA_FIN, 
    r.id_regla
FROM gd_esquema.Maestra m
LEFT JOIN Producto p ON m.PRODUCTO_NOMBRE = p.prod_nombre
LEFT JOIN Regla r ON m.REGLA_DESCRIPCION = r.descripcion_regla;

SELECT * FROM Producto

SELECT * FROM gd_esquema.Maestra WHERE PROMO_CODIGO IS NOT NULL

INSERT INTO Detalle_Pago (
    id_cliente, 
    nro_tarjeta, 
    fecha_vto_tarjeta, 
    cuotas
)
SELECT DISTINCT  
    (SELECT id_cliente FROM Cliente WHERE dni_cliente = CLIENTE_DNI), 
    PAGO_TARJETA_NRO, 
    PAGO_TARJETA_FECHA_VENC, 
    PAGO_TARJETA_CUOTAS
FROM gd_esquema.Maestra;

--tablas con 3 dependencias o más 
INSERT INTO Ticket (
    ticket_numero, 
    id_sucursal, 
	caja_numero,
    fecha_hora, 
    legajo_empleado, 
    tipo_comprobante, 
    subtotal_ticket, 
    descuento_promociones, 
    descuento_medio_pago, 
    total_venta
)
SELECT DISTINCT 
	TICKET_NUMERO, 
    (SELECT 
        id_sucursal 
    FROM 
        Sucursal 
    WHERE 
        nombre_sucursal = SUCURSAL_NOMBRE
    AND
        id_supermercado = (SELECT id_supermercado FROM Supermercado WHERE nombre_super = SUPER_NOMBRE)
    ),
	CAJA_NUMERO,
    TICKET_FECHA_HORA, 
    (SELECT 
        legajo_empleado 
    FROM 
        Empleado 
    WHERE 
        dni = EMPLEADO_DNI 
    ), 
    TICKET_TIPO_COMPROBANTE, 
    TICKET_SUBTOTAL_PRODUCTOS, 
    TICKET_TOTAL_DESCUENTO_APLICADO, 
    TICKET_TOTAL_DESCUENTO_APLICADO_MP, 
    TICKET_TOTAL_TICKET
FROM gd_esquema.Maestra;

INSERT INTO ItemProducto (
    ticket_numero, 
    codigo_producto, 
    cantidad_producto, 
    precio_unitario_producto, 
    total_producto
)
SELECT DISTINCT 
    TICKET_NUMERO, 
    (SELECT 
        codigo_producto 
    FROM 
        Producto 
    WHERE 
        prod_nombre = PRODUCTO_NOMBRE
    ),
    TICKET_DET_CANTIDAD, 
    TICKET_DET_PRECIO, 
    TICKET_DET_TOTAL
FROM gd_esquema.Maestra;

INSERT INTO Pago (
    id_detalle_pago, 
    fecha_pago, 
    importe, 
    id_medio_pago
)
SELECT DISTINCT  
    (SELECT 
        id_detalle_pago 
    FROM 
        Detalle_Pago 
    WHERE 
        nro_tarjeta = PAGO_TARJETA_NRO
    AND 
        cuotas = PAGO_TARJETA_CUOTAS
    ), 
    PAGO_FECHA, 
    PAGO_IMPORTE, 
    (SELECT 
        id_medio_pago 
    FROM 
        Medio_Pago 
    WHERE 
        nombre_mp = PAGO_MEDIO_PAGO
    )
FROM gd_esquema.Maestra;

INSERT INTO Envio (
    ticket_numero, 
    fecha_programada_envio, 
    horario_inicio_envio, 
    horario_fin_envio, 
    id_cliente, 
    costo_envio, 
    id_estado_envio, 
    fecha_hora_entrega_envio
)
SELECT DISTINCT 
    TICKET_NUMERO, 
    ENVIO_FECHA_PROGRAMADA, 
    ENVIO_HORA_INICIO, 
    ENVIO_HORA_FIN, 
    (SELECT id_cliente FROM Cliente WHERE dni_cliente = CLIENTE_DNI), 
    ENVIO_COSTO, 
    (SELECT id_estado_envio FROM EstadoEnvio WHERE nombre_estado_envio = ENVIO_ESTADO), 
    ENVIO_FECHA_ENTREGA
FROM gd_esquema.Maestra;

INSERT INTO Descuento_Medio_Pago(
    id_descuento,
    id_medio_pago,
    descripcion_descuento,
    fecha_inicio_descuento,
    fecha_fin_descuento,
    porcentaje_descuento,
    tope_descuento
)
SELECT DISTINCT
    DESCUENTO_CODIGO,
    (SELECT 
        id_medio_pago 
    FROM
        Medio_Pago
    WHERE
        nombre_mp = PAGO_MEDIO_PAGO
    ),
    DESCUENTO_DESCRIPCION,
    DESCUENTO_FECHA_INICIO,
    DESCUENTO_FECHA_FIN,
    DESCUENTO_PORCENTAJE_DESC,
    DESCUENTO_TOPE
FROM
    gd_esquema.Maestra
WHERE
	DESCUENTO_CODIGO IS NOT NULL

INSERT INTO DescuentosMedioPago_X_Pago (
    id_descuento, 
    nro_pago
)
SELECT DISTINCT
    (SELECT
        id_descuento
    FROM
        Descuento_Medio_Pago
    WHERE
        id_descuento = DESCUENTO_CODIGO
    ),
    (SELECT 
        nro_pago 
    FROM 
        Pago 
    WHERE 
        id_detalle_pago = (
            SELECT 
                id_detalle_pago 
            FROM 
                Detalle_Pago 
            WHERE 
                nro_tarjeta = PAGO_TARJETA_NRO
            AND 
                cuotas = PAGO_TARJETA_CUOTAS
        )
    )
FROM gd_esquema.Maestra;

INSERT INTO Promocion_x_ItemProducto (
    id_promocion_prod, 
    codigo_producto,
    ticket_numero
)
SELECT DISTINCT 
    PROMO_CODIGO, 
    (SELECT 
        codigo_producto 
    FROM 
        Producto 
    WHERE 
        prod_nombre = PRODUCTO_NOMBRE
    ),
    TICKET_NUMERO
FROM gd_esquema.Maestra;
GO