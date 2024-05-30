USE GD1C2024
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'SQLOVERS')
BEGIN 
	EXEC ('CREATE SCHEMA SQLOVERS')
END
GO

CREATE TABLE Provincia (
  id_provincia decimal (18, 0) IDENTITY(1,1),
  nombre_provincia nvarchar(255) NOT NULL,
  PRIMARY KEY (id_provincia)
);

-- ,[REGLA_APLICA_MISMA_MARCA]
-- ,[REGLA_APLICA_MISMO_PROD]
-- ,[REGLA_CANT_APLICA_DESCUENTO]
-- ,[REGLA_CANT_APLICABLE_REGLA]
-- ,[REGLA_CANT_MAX_PROD]
-- ,[REGLA_DESCRIPCION]
-- ,[REGLA_DESCUENTO_APLICABLE_PROD]

CREATE TABLE Regla (
  id_regla decimal (18,0) IDENTITY(1,1),
  descripcion_regla nvarchar(255),
  descuento_a_aplicar decimal(18,2),
  cantidad_aplicable_regla decimal(18,0),
  cantidad_aplicable_descuento decimal(18,0),
  cantidad_maxima decimal(18,0),
  misma_marca decimal(18,0),
  mismo_producto decimal(18,0),
  PRIMARY KEY (id_regla)
);

-- ,[EMPLEADO_NOMBRE]
-- ,[EMPLEADO_APELLIDO]
-- ,[EMPLEADO_DNI]
-- ,[EMPLEADO_FECHA_REGISTRO]
-- ,[EMPLEADO_TELEFONO]
-- ,[EMPLEADO_MAIL]
-- ,[EMPLEADO_FECHA_NACIMIENTO]

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

CREATE TABLE Localidad (
  id_localidad decimal (18, 0) IDENTITY(1,1),
  nombre_localidad nvarchar(255),
  id_provincia decimal (18, 0),
  PRIMARY KEY (id_localidad),
  FOREIGN KEY (id_provincia) REFERENCES Provincia(id_provincia)
);

-- ,[PROMOCION_DESCRIPCION]
-- ,[PROMOCION_FECHA_INICIO]
-- ,[PROMOCION_FECHA_FIN]

CREATE TABLE Promocion_Producto (
  id_promocion_prod decimal(18,0),
  codigo_producto decimal(18,0),
  descripcion_promo nvarchar(255),
  fecha_inicio_promo datetime,
  fecha_fin_promo datetime,
  id_regla decimal(18,0),
  PRIMARY KEY (id_promocion_prod),
  FOREIGN KEY (id_regla) REFERENCES Regla(id_regla),
  FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo_producto)
);

CREATE TABLE Marca_Producto (
  id_prod_marca decimal (18,0) IDENTITY(1,1),
  nombre_prod_marca nvarchar(255),
  PRIMARY KEY (id_prod_marca)
);

-- [SUPER_NOMBRE]
-- ,[SUPER_RAZON_SOC]
-- ,[SUPER_CUIT]
-- ,[SUPER_IIBB]
-- ,[SUPER_DOMICILIO]
-- ,[SUPER_FECHA_INI_ACTIVIDAD]
-- ,[SUPER_CONDICION_FISCAL]
-- ,[SUPER_LOCALIDAD]
-- ,[SUPER_PROVINCIA]

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

-- ,[SUCURSAL_NOMBRE]
-- ,[SUCURSAL_DIRECCION]
-- ,[SUCURSAL_LOCALIDAD]
-- ,[SUCURSAL_PROVINCIA]

CREATE TABLE Sucursal (
  id_sucursal decimal (18,0) IDENTITY(1,1),
  nombre_sucursal nvarchar(255),
  id_localidad nvarchar(255),
  direccion_sucursal nvarchar(255),
  id_supermercado decimal(18,0),
  PRIMARY KEY (id_sucursal),
  FOREIGN KEY (id_localidad) REFERENCES Localidad(id_localidad),
  FOREIGN KEY (id_supermercado) REFERENCES Supermercado(id_supermercado)
);

CREATE TABLE Categoria (
  id_categoria decimal (18,0) IDENTITY(1,1),
  nombre_categoria nvarchar(255),
  id_supercategoría decimal (18,0) ,
  PRIMARY KEY (id_categoria),
  FOREIGN KEY (id_supercategoría) REFERENCES Categoria(id_categoria)
);

-- ,[PRODUCTO_NOMBRE]
-- ,[PRODUCTO_DESCRIPCION]
-- ,[PRODUCTO_PRECIO]
-- ,[PRODUCTO_MARCA]
-- ,[PRODUCTO_SUB_CATEGORIA]
-- ,[PRODUCTO_CATEGORIA]

CREATE TABLE Producto (
  codigo_producto decimal (18,0) IDENTITY(1,1),
  id_categoria decimal (18,0) ,
  prod_nombre nvarchar(255),
  prod_desc decimal (18,0) ,
  precio_unitario_producto decimal (18,2) ,
  id_prod_marca decimal (18,0) ,
  PRIMARY KEY (codigo_producto),
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
  FOREIGN KEY (id_prod_marca) REFERENCES Marca_Producto(id_prod_marca)
);

-- ,[CAJA_NUMERO]
-- ,[CAJA_TIPO]

CREATE TABLE TipoCaja (
  id_tipo_caja decimal (18, 0) IDENTITY(1,1),
  nombre_tipo_caja nvarchar(255),
  PRIMARY KEY (id_tipo_caja)
);

CREATE TABLE Caja (
  caja_numero decimal (18, 0),
  id_sucursal decimal (18, 0),
  id_tipo_caja decimal (18, 0),
  PRIMARY KEY (caja_numero, id_sucursal),
  FOREIGN KEY (id_tipo_caja) REFERENCES TipoCaja(id_tipo_caja),
  FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

-- ,[TICKET_NUMERO]
-- ,[TICKET_FECHA_HORA]
-- ,[TICKET_TIPO_COMPROBANTE]
-- ,[TICKET_SUBTOTAL_PRODUCTOS]
-- ,[TICKET_TOTAL_DESCUENTO_APLICADO]
-- ,[TICKET_TOTAL_DESCUENTO_APLICADO_MP]
-- ,[TICKET_TOTAL_ENVIO]
-- ,[TICKET_TOTAL_TICKET]


-- ,[TICKET_DET_CANTIDAD]
-- ,[TICKET_DET_PRECIO]
-- ,[TICKET_DET_TOTAL]

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
  ticket_numero decimal (18,0) ,
  codigo_producto decimal(18,0),
  cantidad_producto decimal(18,0),
  precio_unitario_producto decimal(18,0),
  total_producto decimal(18,0),
  PRIMARY KEY (ticket_numero, codigo_producto),
  FOREIGN KEY (ticket_numero) REFERENCES Ticket(ticket_numero),
  FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo_producto)
);

-- ,[PROMO_APLICADA_DESCUENTO]
-- ,[PROMO_CODIGO]

CREATE TABLE Promocion_x_ItemProducto (
  id_promocion_prod decimal(18,0),
  codigo_producto decimal(18,0),
  ticket_numero decimal (18,0),
  PRIMARY KEY (id_promocion_prod, codigo_producto, ticket_numero),
  FOREIGN KEY (ticket_numero) REFERENCES ItemProducto(ticket_numero),
  FOREIGN KEY (codigo_producto) REFERENCES ItemProducto(codigo_producto),
  FOREIGN KEY (id_promocion_prod) REFERENCES Promocion_Producto(id_promocion_prod)
);



CREATE TABLE Tipo_Medio_Pago (
  id_tipo_mp decimal (18,0) IDENTITY(1,1),
  tipo_mp nvarchar(255),
  PRIMARY KEY (id_tipo_mp)
);

CREATE TABLE Medio_Pago (
  id_medio_pago decimal (18,0) IDENTITY(1,1),
  nombre_mp nvarchar(255),
  id_tipo_mp decimal (18,0),
  FOREIGN KEY (id_tipo_mp) REFERENCES Tipo_Medio_Pago(id_tipo_mp),
  PRIMARY KEY (id_medio_pago)
);

-- ,[CLIENTE_NOMBRE]
-- ,[CLIENTE_APELLIDO]
-- ,[CLIENTE_DNI]
-- ,[CLIENTE_FECHA_REGISTRO]
-- ,[CLIENTE_TELEFONO]
-- ,[CLIENTE_MAIL]
-- ,[CLIENTE_FECHA_NACIMIENTO]
-- ,[CLIENTE_DOMICILIO]
-- ,[CLIENTE_LOCALIDAD]
-- ,[CLIENTE_PROVINCIA]

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

-- ,[PAGO_FECHA]
-- ,[PAGO_IMPORTE]
-- ,[PAGO_MEDIO_PAGO]
-- ,[PAGO_TIPO_MEDIO_PAGO]
-- ,[PAGO_TARJETA_NRO]
-- ,[PAGO_TARJETA_CUOTAS]
-- ,[PAGO_TARJETA_FECHA_VENC]
-- ,[PAGO_DESCUENTO_APLICADO]

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

CREATE TABLE EstadoEnvio (
  id_estado_envio decimal (18, 0) IDENTITY(1,1),
  nombre_estado_envio nvarchar(255),
  PRIMARY KEY (id_estado_envio)
);

-- ,[DESCUENTO_CODIGO]
-- ,[DESCUENTO_DESCRIPCION]
-- ,[DESCUENTO_FECHA_INICIO]
-- ,[DESCUENTO_FECHA_FIN]
-- ,[DESCUENTO_PORCENTAJE_DESC]
-- ,[DESCUENTO_TOPE]

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

-- ,[ENVIO_COSTO]
-- ,[ENVIO_FECHA_PROGRAMADA]
-- ,[ENVIO_HORA_INICIO]
-- ,[ENVIO_HORA_FIN]
-- ,[ENVIO_FECHA_ENTREGA]
-- ,[ENVIO_ESTADO]
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

