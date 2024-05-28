USE GD1C2024
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'SQLOVERS')
BEGIN 
	EXEC ('CREATE SCHEMA SQLOVERS')
END
GO

DROP TABLE DescuentosMedioPago_X_Pago

DROP TABLE Envío

DROP TABLE Descuento_Medio_Pago

DROP TABLE EstadoEnvio

DROP TABLE Pago

DROP TABLE Detalle_Pago

DROP TABLE Cliente

DROP TABLE Medio_Pago

DROP TABLE Tipo_Medio_Pago

DROP TABLE ItemProducto

DROP TABLE Ticket

DROP TABLE Caja

DROP TABLE TipoCaja

DROP TABLE Promocion_x_ItemProducto

DROP TABLE Producto

DROP TABLE Categoria

DROP TABLE Sucursal

DROP TABLE Supermercado

DROP TABLE Marca_Producto

DROP TABLE Promocion_Producto

DROP TABLE Localidad

DROP TABLE Empleado

DROP TABLE Regla

DROP TABLE Provincia

