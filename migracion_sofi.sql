INSERT INTO Provincia (nombre_provincia)
SELECT DISTINCT SUPER_PROVINCIA FROM gd_esquema.Maestra UNION 
SELECT DISTINCT SUCURSAL_PROVINCIA FROM gd_esquema.Maestra UNION
SELECT DISTINCT CLIENTE_PROVINCIA FROM gd_esquema.Maestra


INSERT INTO Localidad (nombre_localidad, id_provincia)
SELECT DISTINCT 
    SUPER_LOCALIDAD, 
    (SELECT 
        id_provincia 
    FROM 
        Provincia 
    WHERE 
        nombre_provincia = gd_esquema.Maestra.SUPER_PROVINCIA
    ) FROM gd_esquema.Maestra UNION 
SELECT DISTINCT SUCURSAL_LOCALIDAD, (SELECT id_provincia FROM Provincia WHERE nombre_provincia = gd_esquema.Maestra.SUCURSAL_PROVINCIA) FROM gd_esquema.Maestra UNION 
SELECT DISTINCT CLIENTE_LOCALIDAD, (SELECT id_provincia FROM Provincia WHERE nombre_provincia = gd_esquema.Maestra.CLIENTE_PROVINCIA)
FROM gd_esquema.Maestra;

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
    (SELECT 
        id_localidad 
    FROM 
        Localidad 
    WHERE 
        nombre_localidad = gd_esquema.Maestra.SUPER_LOCALIDAD
    )
FROM gd_esquema.Maestra;

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
    mismo_producto
)
SELECT DISTINCT 
    REGLA_DESCRIPCION,
    REGLA_DESCUENTO_APLICABLE_PROD,
    REGLA_CANT_APLICABLE_REGLA,
    REGLA_CANT_APLICA_DESCUENTO,
    REGLA_CANT_MAX_PROD,
    REGLA_APLICA_MISMA_MARCA,
    REGLA_APLICA_MISMO_PROD
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
    m.CLIENTE_NOMBRE, 
    m.CLIENTE_APELLIDO,
    m.CLIENTE_DNI,
    m.CLIENTE_FECHA_REGISTRO,
    m.CLIENTE_TELEFONO,
    m.CLIENTE_MAIL,
    m.CLIENTE_FECHA_NACIMIENTO,
    m.CLIENTE_DOMICILIO,
    l.id_localidad
FROM gd_esquema.Maestra m
LEFT JOIN Localidad l ON l.nombre_localidad = m.CLIENTE_LOCALIDAD;

INSERT INTO Tipo_Medio_Pago (tipo_mp)
SELECT DISTINCT PAGO_TIPO_MEDIO_PAGO
FROM gd_esquema.Maestra;

INSERT INTO Medio_Pago (
    nombre_mp, 
    id_tipo_mp
)
SELECT DISTINCT 
    m.PAGO_MEDIO_PAGO, 
    t.id_tipo_mp
FROM gd_esquema.Maestra m
LEFT JOIN Tipo_Medio_Pago t ON t.tipo_mp = m.PAGO_TIPO_MEDIO_PAGO;


INSERT INTO EstadoEnvio (nombre_estado_envio)
SELECT DISTINCT ENVIO_ESTADO
FROM gd_esquema.Maestra;

-- tablas con dependencias


INSERT INTO Sucursal (nombre_sucursal, id_localidad, direccion_sucursal, id_supermercado)
SELECT DISTINCT 
    m.SUCURSAL_NOMBRE, 
    l.id_localidad,
    m.SUCURSAL_DIRECCION, 
    s.id_supermercado
FROM gd_esquema.Maestra m
LEFT JOIN Localidad l ON l.nombre_localidad = m.SUCURSAL_LOCALIDAD
LEFT JOIN Supermercado s ON s.nombre_super = m.SUPER_NOMBRE;

INSERT INTO Producto (id_categoria, prod_nombre, prod_desc, precio_unitario_producto, id_prod_marca)
SELECT DISTINCT  
    c.id_categoria,
    m.PRODUCTO_NOMBRE, 
    m.PRODUCTO_DESCRIPCION, 
    m.PRODUCTO_PRECIO,
    mp.id_prod_marca
FROM gd_esquema.Maestra m
LEFT JOIN Categoria c ON c.nombre_categoria = m.PRODUCTO_CATEGORIA
LEFT JOIN Marca_Producto mp ON mp.nombre_prod_marca = m.PRODUCTO_MARCA;

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
    s.id_sucursal,
    m.EMPLEADO_NOMBRE, 
    m.EMPLEADO_APELLIDO, 
    m.EMPLEADO_DNI, 
    m.EMPLEADO_TELEFONO, 
    m.EMPLEADO_MAIL, 
    m.EMPLEADO_FECHA_REGISTRO, 
    m.EMPLEADO_FECHA_NACIMIENTO
FROM gd_esquema.Maestra m
LEFT JOIN Sucursal s ON s.nombre_sucursal = m.SUCURSAL_NOMBRE;



INSERT INTO Caja (caja_numero, id_sucursal, id_tipo_caja)
SELECT DISTINCT 
    m.CAJA_NUMERO, 
    s.id_sucursal,
    tc.id_tipo_caja
FROM gd_esquema.Maestra m
LEFT JOIN Sucursal s ON s.nombre_sucursal = m.SUCURSAL_NOMBRE
LEFT JOIN Supermercado sm ON sm.nombre_super = m.SUPER_NOMBRE
LEFT JOIN TipoCaja tc ON tc.nombre_tipo_caja = m.CAJA_TIPO
WHERE s.id_supermercado = sm.id_supermercado;


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

INSERT INTO Detalle_Pago (
    id_cliente, 
    nro_tarjeta, 
    fecha_vto_tarjeta, 
    cuotas
)
SELECT DISTINCT  
    c.id_cliente, 
    m.PAGO_TARJETA_NRO, 
    m.PAGO_TARJETA_FECHA_VENC, 
    m.PAGO_TARJETA_CUOTAS
FROM gd_esquema.Maestra m
LEFT JOIN Cliente c ON m.CLIENTE_DNI = c.dni_cliente;


--tablas con 3 dependencias o más 

INSERT INTO Ticket (
    ticket_numero, 
    caja_numero, 
    id_sucursal, 
    fecha_hora, 
    legajo_empleado, 
    tipo_comprobante, 
    subtotal_ticket, 
    descuento_promociones, 
    descuento_medio_pago, 
    total_venta
)
SELECT DISTINCT 
    m.TICKET_NUMERO, 
    c.caja_numero, 
    s.id_sucursal, 
    m.TICKET_FECHA_HORA, 
    e.legajo_empleado, 
    m.TICKET_TIPO_COMPROBANTE, 
    m.TICKET_SUBTOTAL_PRODUCTOS, 
    m.TICKET_TOTAL_DESCUENTO_APLICADO, 
    m.TICKET_TOTAL_DESCUENTO_APLICADO_MP, 
    m.TICKET_TOTAL_TICKET
FROM gd_esquema.Maestra m
LEFT JOIN Caja c ON m.CAJA_NUMERO = c.caja_numero
LEFT JOIN Sucursal s ON m.SUCURSAL_NOMBRE = s.nombre_sucursal
LEFT JOIN Supermercado su ON s.id_supermercado = su.id_supermercado AND su.nombre_super = m.SUPER_NOMBRE
LEFT JOIN Empleado e ON m.EMPLEADO_DNI = e.dni;



INSERT INTO ItemProducto (
    ticket_numero, 
    codigo_producto, 
    cantidad_producto, 
    precio_unitario_producto, 
    total_producto
)
SELECT DISTINCT 
    m.TICKET_NUMERO, 
    p.codigo_producto,
    m.TICKET_DET_CANTIDAD, 
    m.TICKET_DET_PRECIO, 
    m.TICKET_DET_TOTAL
FROM gd_esquema.Maestra m
LEFT JOIN Producto p ON m.PRODUCTO_NOMBRE = p.prod_nombre;


INSERT INTO Pago (
    id_detalle_pago, 
    fecha_pago, 
    importe, 
    id_medio_pago
)
SELECT DISTINCT  
    dp.id_detalle_pago,
    m.PAGO_FECHA, 
    m.PAGO_IMPORTE, 
    mp.id_medio_pago
FROM gd_esquema.Maestra m
LEFT JOIN Detalle_Pago dp ON m.PAGO_TARJETA_NRO = dp.nro_tarjeta AND m.PAGO_TARJETA_CUOTAS = dp.cuotas
LEFT JOIN Medio_Pago mp ON m.PAGO_MEDIO_PAGO = mp.nombre_mp;


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
    m.TICKET_NUMERO, 
    m.ENVIO_FECHA_PROGRAMADA, 
    m.ENVIO_HORA_INICIO, 
    m.ENVIO_HORA_FIN, 
    c.id_cliente, 
    m.ENVIO_COSTO, 
    ee.id_estado_envio, 
    m.ENVIO_FECHA_ENTREGA
FROM gd_esquema.Maestra m
LEFT JOIN Cliente c ON m.CLIENTE_DNI = c.dni_cliente
LEFT JOIN EstadoEnvio ee ON m.ENVIO_ESTADO = ee.nombre_estado_envio;


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
    m.DESCUENTO_CODIGO,
    mp.id_medio_pago,
    m.DESCUENTO_DESCRIPCION,
    m.DESCUENTO_FECHA_INICIO,
    m.DESCUENTO_FECHA_FIN,
    m.DESCUENTO_PORCENTAJE_DESC,
    m.DESCUENTO_TOPE
FROM
    gd_esquema.Maestra m
LEFT JOIN Medio_Pago mp ON m.PAGO_MEDIO_PAGO = mp.nombre_mp;


INSERT INTO DescuentosMedioPago_X_Pago (
    id_descuento, 
    nro_pago
)
SELECT 
    dmp.id_descuento,
    p.nro_pago
FROM gd_esquema.Maestra m
LEFT JOIN Descuento_Medio_Pago dmp ON m.DESCUENTO_CODIGO = dmp.id_descuento
LEFT JOIN Detalle_Pago dp ON m.PAGO_TARJETA_NRO = dp.nro_tarjeta AND m.PAGO_TARJETA_CUOTAS = dp.cuotas
LEFT JOIN Pago p ON dp.id_detalle_pago = p.id_detalle_pago;


INSERT INTO Promocion_x_ItemProducto (
    id_promocion_prod, 
    codigo_producto,
    ticket_numero
)
SELECT DISTINCT 
    m.PROMO_CODIGO, 
    p.codigo_producto,
    m.TICKET_NUMERO
FROM gd_esquema.Maestra m
LEFT JOIN Producto p ON m.PRODUCTO_NOMBRE = p.prod_nombre;