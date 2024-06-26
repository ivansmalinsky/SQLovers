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

CREATE TABLE Regla (
  id_regla decimal (18,0) IDENTITY(1,1),
  descripcion_regla nvarchar(255),
  descuento_a_aplicar decimal(18,0),
  cantidad_aplicable_regla decimal(18,0),
  cantidad_aplicable_descuento decimal(18,0),
  cantidad_maxima decimal(18,0),
  misma_marca decimal(18,0),
  mismo_producto decimal(18,0),
  PRIMARY KEY (id_regla)
);

CREATE TABLE Empleado (
  legajo_empleado decimal(18,0),
  id_sucursal decimal(18,0),
  nombre_empleado nvarchar(255),
  apellido_empleado nvarchar(255),
  dni decimal(18,0),
  telefono_empleado decimal(18,0),
  mail_empleado nvarchar(255),
  fecha_registro datetime,
  fecha_nacimiento date,
  PRIMARY KEY (legajo_empleado)
);

CREATE TABLE Localidad (
  id_localidad decimal (18, 0) IDENTITY(1,1),
  nombre_localidad nvarchar(255),
  id_provincia decimal (18, 0),
  PRIMARY KEY (id_localidad),
  FOREIGN KEY (id_localidad) REFERENCES Provincia(id_provincia)
);

CREATE TABLE Promocion_Producto (
  id_promocion_prod decimal(18,0) IDENTITY(1,1),
  codigo_producto decimal(18,0),
  descripcion_promo nvarchar(255),
  fecha_inicio_promo datetime,
  fecha_fin_promo datetime,
  id_regla decimal(18,0),
  PRIMARY KEY (id_promocion_prod)
);

CREATE TABLE Marca_Producto (
  id_prod_marca decimal (18,0) IDENTITY(1,1),
  nombre_prod_marca nvarchar(255),
  PRIMARY KEY (id_prod_marca)
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
  id_localidad decimal (18,0) ,
  PRIMARY KEY (id_supermercado)
);

CREATE TABLE Sucursal (
  id_sucursal decimal (18,0) IDENTITY(1,1),
  nombre_sucursal nvarchar(255),
  id_localidad nvarchar(255),
  direccion_sucursal nvarchar(255),
  id_supermercado decimal(18,0),
  PRIMARY KEY (id_sucursal),
  FOREIGN KEY (id_supermercado) REFERENCES Supermercado(id_supermercado)
);

CREATE TABLE Categoria (
  id_categoria decimal (18,0) IDENTITY(1,1),
  nombre_categoria nvarchar(255),
  id_supercategoría decimal (18,0) ,
  PRIMARY KEY (id_categoria),
  FOREIGN KEY (id_supercategoría) REFERENCES Categoria(id_categoria)
);

CREATE TABLE Producto (
  codigo_producto decimal (18,0) ,
  id_categoria decimal (18,0) ,
  prod_nombre nvarchar(255),
  prod_desc decimal (18,0) ,
  id_prod_marca decimal (18,0) ,
  PRIMARY KEY (codigo_producto),
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

CREATE TABLE Promocion_x_ItemProducto (
  id_promocion_prod decimal(18,0),
  codigo_producto decimal(18,0),
  PRIMARY KEY (id_promocion_prod, codigo_producto),
  FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo_producto),
  FOREIGN KEY (id_promocion_prod) REFERENCES Promocion_Producto(id_promocion_prod)
);

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
  FOREIGN KEY (id_tipo_caja) REFERENCES TipoCaja(id_tipo_caja)
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
  FOREIGN KEY (caja_numero, id_sucursal) REFERENCES Caja(caja_numero, id_sucursal)
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

CREATE TABLE Tipo_Medio_Pago (
  id_tipo_mp decimal (18,0) IDENTITY(1,1),
  tipo_mp nvarchar(255),
  PRIMARY KEY (id_tipo_mp)
);

CREATE TABLE Medio_Pago (
  id_medio_pago decimal (18,0) IDENTITY(1,1),
  nombre_mp nvarchar(255),
  descripcion_mp nvarchar(255),
  id_tipo_mp decimal (18,0),
  entidad_emisora nvarchar(255),
  FOREIGN KEY (id_tipo_mp) REFERENCES Tipo_Medio_Pago(id_tipo_mp),
  PRIMARY KEY (id_medio_pago)
);

CREATE TABLE Cliente (
  id_cliente decimal (18,0) ,
  nombre_cliente nvarchar(255),
  direccion nvarchar(255),
  PRIMARY KEY (id_cliente)
);

CREATE TABLE Detalle_Pago (
  id_detalle_pago decimal (18,0) ,
  id_cliente decimal (18,0) ,
  nro_tarjeta nvarchar(255),
  fecha_vto_tarjeta datetime,
  cuotas decimal (18,0) ,
  PRIMARY KEY (id_detalle_pago),
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Pago (
  nro_pago decimal(18,0),
  id_detalle_pago decimal (18,0) ,
  fecha_pago datetime,
  importe decimal(18,2),
  id_medio_pago decimal (18,0) ,
  FOREIGN KEY (id_detalle_pago) REFERENCES Detalle_Pago(id_detalle_pago),
  FOREIGN KEY (id_medio_pago) REFERENCES Medio_Pago(id_medio_pago),
  PRIMARY KEY (nro_pago)
);

CREATE TABLE EstadoEnvio (
  id_estado_envio decimal (18, 0),
  nombre_estado_envio nvarchar(255),
  PRIMARY KEY (id_estado_envio)
);

CREATE TABLE Descuento_Medio_Pago (
  id_descuento decimal (18,0) ,
  id_medio_pago decimal (18,0) ,
  descripcion_descuento nvarchar(255),
  fecha_inicio_descuento datetime,
  fecha_fin_descuento datetime,
  valor_descuento decimal (18,0) ,
  tope_descuento_descuento decimal (18,0) ,
  PRIMARY KEY (id_descuento),
  FOREIGN KEY (id_medio_pago) REFERENCES Medio_Pago(id_medio_pago)
);

CREATE TABLE Envío (
  nro_envio decimal (18,0),
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

