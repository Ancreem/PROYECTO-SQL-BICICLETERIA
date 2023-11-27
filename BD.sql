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


-- llaves primarias

alter table sucursal add constraint PK_sucursal_id primary key (id);
alter table trabajadores add constraint PK_trabajadores_id primary key (id);
alter table empleado add constraint PK_factura_id primary key (id);
alter table metodoPago add constraint PK_metodoPago_id primary key (id);
alter table servicio add constraint PK_servicio_tipoServicio primary key (tipoServicio);
alter table preFactura add constraint PK_preFactura_id primary key (id);
alter table factura add constraint PK_factura_id primary key(id);
alter table cliente add constraint PK_cliente_id primary key (id);
alter table productos add constraint PK_productos_id primary key (id);
alter table distribuidor add constraint PK_distribuidor_id primary key (id);
alter table inventario add constraint PK_inventario_producto primary key (producto);
alter table producto add constraint PK_producto_producto primary key (producto);
alter table facturaSegundaMano add constraint PK_facturaSegundaMano_id primary key(id);
alter table clienteSegundaMano add constraint PK_clienteSegundaMano_id primary key (id);
alter table productosSegundaMano add constraint PK_productosSegundaMano_id primary key (id);
alter table distribuidorSegundaMano add constraint PK_distribuidorSegundaMano_id primary key (id);
alter table inventarioSegundaMano add constraint PK_inventarioSegundaMano_producto primary key (producto);
alter table productoSegundaMano add constraint PK_productoSegundaMano_producto primary key (producto);

-- llaves unicas

alter table empleado add constraint UC_empleado_numeroCelular unique (numeroCelular);
alter table empleado add constraint UC_empleado_correo unique (correo); 
alter table distribuidor add constraint UC_distribuidor_numeroTelefono unique(numeroTelefono);
alter table distribuidor add constraint UC_distribuidor_numeroCelular unique(numeroCelular);
alter table distribuidor add constraint UC_distribuidor_correo unique(correo);
alter table distribuidorSegundaMano add constraint UC_distribuidorSegundaMano_numeroTelefono unique(numeroTelefono);
alter table distribuidorSegundaMano add constraint UC_distribuidorSegundaMano_numeroCelular unique(numeroCelular);
alter table distribuidorSegundaMano add constraint UC_distribuidorSegundaMano_correo unique(correo);
alter table cliente add constraint UC_cliente_telefono unique(telefono); 
alter table cliente add constraint UC_cliente_correo unique(correo);
alter table clienteSegundaMano add constraint UC_clienteSegundaMano_telefono unique(telefono); 
alter table clienteSegundaMano add constraint UC_clienteSegundaMano_correo unique(correo);

	

-- foreign key

alter table trabajadores 
add constraint FK_trabajadores_sucursalId foreign key(sucursalId) references sucursal(id),
add constraint FK_trabajadores_empleadoId foreign key(empleadoId) references empleado(id);

alter table factura
add constraint FK_factura_empleadoId foreign key (empleadoId) references empleado(id),
add constraint FK_factura_clienteId foreign key (clienteId) references cliente(id),
add constraint FK_factura_productosId foreign key (productosId) references productos(id),
add constraint FK_factura_preFacturaId foreign key (preFacturaId) references preFactura(id),
add constraint FK_factura_metodoPagoId foreign key (metodoPagoId) references metodoPago(id);

alter table preFactura
add constraint FK_preFactura_tipoServicio foreign key (tipoServicio) references servicio(tipoServicio);

alter table productos
add constraint FK_productos_producto foreign key (producto) references producto(producto);

alter table producto
add constraint FK_producto_inventario foreign key (producto) references inventario(producto);

alter table inventario 
add constraint FK_inventario_distribuidorId foreign key (distribuidorId) references distribuidor(id);

alter table facturaSegundaMano
add constraint FK_facturaSegundaMano_empleadoId foreign key (empleadoId) references empleado(id),
add constraint FK_facturaSegundaMano_clienteSegundaManoId foreign key (clienteId) references clienteSegundaMano(id),
add constraint FK_facturaSegundaMano_productosSegundaManoId foreign key (productosId) references productosSegundaMano(id),
add constraint FK_facturaSegundaMano_metodoPagoSegundaManoId foreign key (metodoPagoId) references metodoPago(id);

alter table productosSegundaMano
add constraint FK_productosSegundaMano_producto foreign key (producto) references productoSegundaMano(producto);

alter table productoSegundaMano
add constraint FK_productoSegundaMano_inventarioSegundaMano foreign key (producto) references inventarioSegundaMano(producto);

alter table inventarioSegundaMano 
add constraint FK_inventarioSegundaMano_distribuidorSegundaManoId foreign key (distribuidorId) references distribuidorSegundaMano(id);




 
