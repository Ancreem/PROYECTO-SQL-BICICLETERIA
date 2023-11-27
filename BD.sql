create database if not exists bicicleteria;

use bicicleteria;

create table if not exists preFactura(
	id int,
	tipoServicio varchar(255) not null,
	precio int not null
);

create table if not exists metodoPago(
	id int, 
	nombre varchar(255) not null,
	tipo varchar(255) not null
);

create table if not exists servicio(
	tipoServicio varchar(255),
	tipoVehiculo varchar(255) not null,
	complejidad varchar(255) not null
);

create table if not exists factura(
	id int,
	empleadoId int not null,
	clienteId int not null,
	productosId int not null,
	preFacturaId int,
	metodoPagoId int not null,
	fecha datetime not null
);

create table if not exists sucursal(
	id int,
	direccion varchar(255) not null,
	nombre varchar(255) not null
);

create table if not exists empleado(
	id int,
	nombre varchar(255) not null,
	apellido1 varchar(255) not null,
	apellido2 varchar(255) not null,
	numeroCelular varchar(255) not null,
	correo varchar(255) not null,
	rol varchar(255) not null
);

create table if not exists trabajadores(
	id int,
	sucursalId int not null,
	empleadoId int not null
);

create table if not exists servicio(
	tipoServicio varchar(255),
	tipoVehiculo varchar(255) not null,
	gama varchar(255) not null
);

create table if not exists cliente(
	id int,
	nombre varchar(255) not null,
	apellido1 varchar(255) not null,
	apellido2 varchar(255) not null,
	telefono varchar(45) not null,
	correo varchar(255) not null
);

create table if not exists productos(
	id int,
	producto varchar(255) not null,
	cantidad int not null
);

create table if not exists distribuidor(
	id int,
	nombre varchar(255) not null,
	numeroTelefono  varchar(255) not null,
	numeroCelular varchar(255) not null,
	correo varchar(255) not null
);

create table if not exists inventario(
	producto varchar(255),
	fecha datetime not null,
	distribuidorId int not null,
	cantidad int not null
);

create table if not exists producto(
	producto varchar(255),
	descripcion text not null,
	tipo varchar(255) not null,
	precio int not null,
	categoria varchar(255) not null
);

create table if not exists facturaSegundaMano(
id int,
	empleadoId int not null,
	clienteId int not null,
	productosId int not null,
	metodoPagoId int not null,
	fecha datetime not null
);

create table if not exists clienteSegundaMano(
	id int,
	nombre varchar(255) not null,
	apellido1 varchar(255) not null,
	apellido2 varchar(255) not null,
	telefono varchar(45) not null,
	correo varchar(255) not null
);

create table if not exists productosSegundaMano(
	id int,
	producto varchar(255) not null,
	cantidad int not null
);

create table if not exists distribuidorSegundaMano(
id int,
	nombre varchar(255) not null,
	numeroTelefono  varchar(255) not null,
	numeroCelular varchar(255) not null,
	correo varchar(255) not null
);

create table if not exists inventarioSegundaMano(
	producto varchar(255),
	fecha datetime not null,
	distribuidorId int not null,
	cantidad int not null
);

create table if not exists productoSegundaMano(
	producto varchar(255),
	descripcion varchar(255) not null,
	tipo varchar(255) not null,
	precio int not null,
	estado varchar(80) not null,
	categoria varchar(255) not null
);






 
