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
        nombre_provincia = SUPER_PROVINCIA
    ) FROM gd_esquema.Maestra UNION 
SELECT DISTINCT SUCURSAL_LOCALIDAD, (SELECT id_provincia FROM Provincia WHERE nombre_provincia = SUCURSAL_PROVINCIA) FROM gd_esquema.Maestra UNION 
SELECT DISTINCT CLIENTE_LOCALIDAD, (SELECT id_provincia FROM Provincia WHERE nombre_provincia = CLIENTE_PROVINCIA) FROM gd_esquema.Maestra;

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
        nombre_localidad = SUPER_LOCALIDAD
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
	codigo_promo,
    id_promocion_prod, 
    codigo_producto, 
    descripcion_promo, 
    fecha_inicio_promo, 
    fecha_fin_promo
)

SELECT DISTINCT 
    PROMO_CODIGO, 
    (SELECT 
        codigo_producto 
    FROM 
        Producto 
    WHERE 
        prod_nombre = PRODUCTO_NOMBRE AND
		prod_desc = PRODUCTO_DESCRIPCION AND
		precio_unitario_producto = PRODUCTO_PRECIO AND
		--id_categoria = (SELECT id_categoria from Categoria WHERE nombre_categoria = PRODUCTO_CATEGORIA AND nombre_sub_categoria = PRODUCTO_SUB_CATEGORIA) AND
		id_prod_marca = (SELECT id_prod_marca from Marca_Producto WHERE nombre_prod_marca = PRODUCTO_MARCA)
    ),
    PROMOCION_DESCRIPCION, 
    PROMOCION_FECHA_INICIO, 
    PROMOCION_FECHA_FIN
FROM gd_esquema.Maestra
WHERE PROMO_CODIGO IS NOT NULL;

SELECT * FROM Producto

SELECT * FROM gd_esquema.Maestra WHERE PROMO_CODIGO IS NOT NULL

--SELECT PRODUCTO_NOMBRE FROM gd_esquema.Maestra;
--------------------------------------------------------------------------------------------

/*INSERT INTO Producto (id_categoria, prod_nombre, prod_desc, precio_unitario_producto, id_prod_marca)
SELECT DISTINCT  
                (SELECT id_categoria FROM Categoria WHERE nombre_categoria = PRODUCTO_CATEGORIA AND nombre_sub_categoria = PRODUCTO_SUB_CATEGORIA), 
                PRODUCTO_NOMBRE, 
                PRODUCTO_DESCRIPCION, 
                PRODUCTO_PRECIO,
                (SELECT id_prod_marca FROM Marca_Producto WHERE nombre_prod_marca = PRODUCTO_MARCA)
FROM gd_esquema.Maestra;*/

--SELECT distinct prod_nombre, precio_unitario_producto from Producto

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