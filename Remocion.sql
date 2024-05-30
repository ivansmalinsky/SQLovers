USE GD1C2024
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'SQLOVERS')
BEGIN 
	EXEC ('CREATE SCHEMA SQLOVERS')
END
GO

DROP TABLE DescuentosMedioPago_X_Pago
DROP TABLE Envio
DROP TABLE Descuento_Medio_Pago
DROP TABLE Promocion_x_ItemProducto
DROP TABLE ItemProducto
DROP TABLE Ticket
DROP TABLE Pago
DROP TABLE Medio_Pago
DROP TABLE Detalle_Pago
DROP TABLE Cliente
DROP TABLE Caja
DROP TABLE Regla
DROP TABLE Promocion_Producto
DROP TABLE Producto
DROP TABLE Empleado
DROP TABLE Sucursal
DROP TABLE Supermercado
DROP TABLE Localidad
DROP TABLE Provincia
DROP TABLE Tipo_Medio_Pago
DROP TABLE TipoCaja
DROP TABLE Marca_Producto
DROP TABLE Categoria
DROP TABLE EstadoEnvio