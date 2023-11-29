# PROYECTO-SQL-BICICLETERIA

## Resumen de proyecto

En este proyecto, se ha creado una base de datos para simular el funcionamiento de una tienda de bicicletas ficticia. Durante este proceso, se ha llevado a cabo un modelado conceptual, lógico y físico para garantizar un alto grado de realismo. Los datos ficticios ingresados han sido cuidadosamente seleccionados para reflejar de manera verosímil la información que podría contener una base de datos de una tienda de bicicletas en la vida real.
Además, se han diseñado consultas que permiten acceder y analizar estos datos de manera eficiente. Estas consultas se han desarrollado teniendo en cuenta las necesidades típicas de gestión y análisis que podrían surgir en el contexto de una tienda de bicicletas. De esta manera, el proyecto no solo busca simular la estructura y contenido de la base de datos, sino también proporcionar herramientas prácticas para la extracción de información relevante y la toma de decisiones fundamentada en datos.

## Modelos

<details>
  <summary>Click para desplegar</summary>
   <br>
  En esta sección, se incluirán los modelos físicos adjuntos.

### Modelado conceptual

Desearía implementar una base de datos integral para la administración de mi empresa, la cual se especializa en el ámbito de la venta de productos de bicicletas. Contamos con diversas sucursales que cuentan con un promedio de 5 empleados en cada área. Mantenemos relaciones con varios distribuidores que proveen los productos para nuestras tiendas. Realizamos inventarios tanto de productos nuevos como de segunda mano.
Adicionalmente, ofrecemos servicios de mantenimiento para bicicletas y productos, brindando asistencia a los clientes que puedan requerirlo al adquirir una bicicleta o un artículo. Es importante destacar que no realizamos servicios de mantenimiento con productos de segunda mano. Los clientes tienen la flexibilidad de efectuar sus pagos de diversas maneras, y los productos de segunda mano cuentan con su propio proveedor exclusivo.
Los clientes que adquieren productos de segunda mano contarán con un inventario exclusivo y sus respectivas facturas, los cuales serán almacenados para posibles reclamaciones futuras. Esta medida se implementa con el objetivo de garantizar un registro detallado y transparente de las transacciones relacionadas con productos de segunda mano.
Además, buscamos establecer una visión clara de nuestros proveedores de segunda mano más destacados. Esto se logrará mediante un análisis cuidadoso de las transacciones, evaluando la calidad de los productos y la satisfacción de los clientes. Este enfoque nos permitirá tomar decisiones informadas y fortalecer nuestras relaciones con los proveedores que mejor se alineen con los estándares de calidad y servicio de nuestra empresa.

### Modelo logico

![imagen](https://github.com/Ancreem/PROYECTO-SQL-BICICLETERIA/assets/139159920/ad6132ab-288f-4a62-92c2-831c0e127304)


### Modelo fisico

![bicicleteria](https://github.com/Ancreem/PROYECTO-SQL-BICICLETERIA/assets/139159920/ef046f5d-a7c4-4dd2-b40e-d413c59cd9b2)

</details>

### Crud

<details>
  <summary>Click para desplegar</summary>
   <br>

</details>

## Consultas y procedimientos

<details>
  <summary><strong>Click para ver</strong></summary>
   <br>


<details>
  <summary>Tabla Sucursal</summary>
   <br>

1. Devuelva cuales servicios han dado cada sucursal

   - Consulta

   ```sql
   	select s.nombre, p.tipoServicio
   	from sucursal s
   	join trabajadores t on t.sucursalId = s.id
   	join empleado e on e.id = t.empleadoId 
   	join factura f on f.empleadoId = e.id
   	join preFactura p on p.id = f.preFacturaId;
   ```

   - Procedimiento `servicio_en_sucursal;`

   ```sql
   	DELIMITER //
   	create procedure servicio_en_sucursal()
   	begin
   		select s.nombre, p.tipoServicio
           from sucursal s
           join trabajadores t on t.sucursalId = s.id
           join empleado e on e.id = t.empleadoId 
           join factura f on f.empleadoId = e.id
           join preFactura p on p.id = f.preFacturaId;
   	end //
   	DELIMITER ;
   ```

   - Llamado `call servicio_en_sucursal();`

2. Devuelva el nombre y la dirección de las sucursales que no han realizado ventas en el último mes.

    - Consulta

    ```sql
    	select s.nombre, s.direccion
        from sucursal s
        where not exists (
            select 1
            from factura f
            join empleado e ON f.empleadoId = e.id
            join trabajadores t ON e.id = t.empleadoId
            where t.sucursalId = s.id
            and month(f.fecha) = month(curdate()) - 1
            and year(f.fecha) = year(curdate())
        );
    ```

    - Procedimiento `sucursales_no_ventas_mes`

    ```sql
    	DELIMITER //
    	create procedure sucursales_no_ventas_mes(in numeroMeses int)
    	begin
    		select s.nombre, s.direccion
            from sucursal s
            where not exists (
                select 1
                from factura f
                join empleado e ON f.empleadoId = e.id
                join trabajadores t ON e.id = t.empleadoId
                where t.sucursalId = s.id
                and month(f.fecha) = month(curdate()) - numeroMeses
                and year(f.fecha) = year(curdate())
            );
    	end //
    	DELIMITER ;
    ```

    - Llamado `call sucursales_no_ventas_mes(numeroMeses);`


3. Obtenga un de las Sucursales con mayor número de Empleados.

    - Consulta

    ```sql
    	select s.nombre as sucursal,
                (select COUNT(*) 
                from trabajadores 
                where sucursalId = s.id) as numero_empleados
        from sucursal s
        order by numero_empleados DESC
        limit 1;
    ```

    - Procedimiento `ObtenerSucursalesMayorNumeroEmpleados`

    ```sql
        DELIMITER //
        create procedure ObtenerSucursalesMayorNumeroEmpleados()
        begin
            select s.nombre as sucursal,
                (select COUNT(*) 
                from trabajadores 
                where sucursalId = s.id) as numero_empleados
            from sucursal s
            order by numero_empleados DESC
            limit 1;
        end //
        DELIMITER ;

    ```

    - Llamado `call ObtenerSucursalesMayorNumeroEmpleados();`


4. Obtenga los detalles de Empleados en la Sucursal 1.

    - Consulta

    ```sql
    	select e.*
        from empleado e
        where e.id IN (
            select empleadoId 
            from trabajadores 
            where sucursalId = 1
        );
    ```

    - Procedimiento `ObtenerDetallesEmpleadosSucursal`

    ```sql
        DELIMITER //
        create procedure ObtenerDetallesEmpleadosSucursal(IN sucursal_id INT)
        begin
            select e.*
            from empleado e
            where e.id IN (
                select empleadoId 
                from trabajadores 
                where sucursalId = sucursal_id
            );
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerDetallesEmpleadosSucursal(sucursal_id);`


5. Cuente las facturas emitidas por la sucursal 2

    - Consulta

    ```sql
    	select COUNT(*)
        from factura
        where empleadoId IN (
            select empleadoId 
            from trabajadores 
            where sucursalId = 2
        );
    ```

    - Procedimiento `ContarFacturasSucursal`

    ```sql
        DELIMITER //
        create procedure ContarFacturasSucursal(IN sucursal_id INT)
        begin
            select COUNT(*)
            from factura
            where empleadoId IN (select empleadoId from trabajadores where sucursalId = sucursal_id);
        end //
        DELIMITER ;
    ```

    - Llamado `call ContarFacturasSucursal(sucursal_id);`


</details>


<details>
  <summary>Tabla trabajadores</summary>
   <br>

1. Devuelva que trabajador no se encuentra en ninguna sucursal. Muestre su id, rol, con su nombre y apellidos.

   - Consulta

   ```sql
       select e.id, e.rol, CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) as nombre_completo
       from empleado e
       left join trabajadores t on e.id = t.empleadoId
       where t.sucursalId is NULL;
   ```

   - Procedimiento `trabajador_no_sucursal`

   ```sql
   trabajador_no_sucursal	DELIMITER //
   	create procedure trabajador_no_sucursal()
   	begin
   	    select e.id, e.rol, CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) as nombre_completo
       	from empleado e
       	left join trabajadores t on e.id = t.empleadoId
       	where t.sucursalId is NULL;
   	end //
   	DELIMITER ;
   ```

   - Llamado `call trabajador_no_sucursal() ;`


2.  Cuente cuantos empleados hay del rol "Vendedor" en especifico en la sucursal con el id 1.

    - Consulta

    ```sql
    	select COUNT(*)
        from empleado
        where id IN (
            select empleadoId 
            from trabajadores 
            where sucursalId = 1
        )
        AND rol = 'Vendedor';
    ```

    - Procedimiento `ContarEmpleadosPorRolSucursal`

    ```sql
        DELIMITER //
        create procedure ContarEmpleadosPorRolSucursal(IN sucursal_id INT, IN rol_empleado VARCHAR(255))
        begin
            select COUNT(*)
            from empleado
            where id IN (
                select empleadoId 
                from trabajadores 
                where sucursalId = sucursal_id
            )
            AND rol = rol_empleado;
        end //
        DELIMITER ;
    ```

    - Llamado `call ContarEmpleadosPorRolSucursal(sucursal_id, rol_empleado);`


4. Obtenga las sucursales con al menos un empleado de un rol especificado.
    - Consulta

    ```sql
    	select DISTINCT s.*
        from sucursal s
        where s.id IN (
        select sucursalId 
            from trabajadores 
            where empleadoId IN (
                select id 
                from empleado 
                where rol = "Vendedor"
            )
        );
    ```

    - Procedimiento `ObtenerSucursalesConRolEspecifico`

    ```sql
        DELIMITER //
        create procedure ObtenerSucursalesConRolEspecifico(IN rol_empleado VARCHAR(255))
        begin
            select DISTINCT s.*
            from sucursal s
            where s.id IN (
            select sucursalId 
            from trabajadores 
                where empleadoId IN (
                    select id 
                    from empleado 
                    where rol = rol_empleado
                )
            );
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerSucursalesConRolEspecifico(rol_empleado);`


5. Muestre los empleados que trabajan en más de una sucursal.

    - Consulta

    ```sql
    	select *
        from empleado
        where id IN (
            select empleadoId
            from trabajadores
            GROUP BY empleadoId
            HAVING COUNT(DISTINCT sucursalId) > 1
        );
    ```

    - Procedimiento `ObtenerEmpleadosEnMasDeUnaSucursal`

    ```sql
        DELIMITER //
        create procedure ObtenerEmpleadosEnMasDeUnaSucursal()
        begin
            select *
            from empleado
            where id IN (
                select empleadoId
                from trabajadores
                GROUP BY empleadoId
                HAVING COUNT(DISTINCT sucursalId) > 1
            );
        end //
        DELIMITER ;

    ```

    - Llamado `call ObtenerEmpleadosEnMasDeUnaSucursal();`

</details>


<details>
  <summary>Tabla empleado</summary>
   <br>

1. Obtener el total de ventas realizado por el empleado con el id "1", mostrando el  nombre del empleado y la suma de los montos de venta, considerando las facturas emitidas.

   - Consulta

   ```sql
   	select e.nombre as Empleado, sum(p.precio * ps.cantidad) as venta
       from factura fact
       join empleado e on fact.empleadoId = e.id
       join productos ps on fact.productosId = ps.id
       join producto p on ps.producto = p.producto
       where e.id = 1
       GROUP BY e.nombre;
   ```

   - Procedimiento `empleado_ventas`

   ```sql
   	DELIMITER //
   	create procedure empleado_ventas(in idEmpleado int)
   	begin 
           select e.nombre as Empleado, sum(p.precio * ps.cantidad) as venta
           from factura fact
           join empleado e on fact.empleadoId = e.id
           join productos ps on fact.productosId = ps.id
           join producto p on ps.producto = p.producto
           where e.id = idEmpleado
           GROUP BY e.nombre;
   	end //
   	DELIMITER ;
   ```

   - Llamado `call empleado_ventas(id);`

2. Listar los servicios que han sido utilizados por empleados con el apellido "Martínez".

    - Consulta

    ```sql
    	select distinct s.tipoServicio
        from servicio s
        join preFactura pf on s.tipoServicio = pf.tipoServicio
        join factura f on pf.id = f.preFacturaId
        join empleado e on f.empleadoId = e.id
        where e.apellido1 = 'Martínez' or e.apellido2 = 'Martínez';
    ```

    - Procedimiento `servicios_utilizados_empleado_apellido`

    ```sql
    	DELIMITER //
    	create procedure servicios_utilizados_empleado_apellido(in apellidoEmpleado varchar(200))
    	begin
    		select distinct s.tipoServicio
            from servicio s
            join preFactura pf on s.tipoServicio = pf.tipoServicio
            join factura f on pf.id = f.preFacturaId
            join empleado e on f.empleadoId = e.id
            where e.apellido1 = apellidoEmpleado or e.apellido2 = apellidoEmpleado;
    	end //
    	DELIMITER ;
    ```

    - Llamado `call servicios_utilizados_empleado_apellido(apellido);`


3. Obtenga los empleados que han hecho ventas entre "2023-10-23" hasta "2023-11-23".

    - Consulta

    ```sql
    	select *
        from empleado
        where id IN (
            select empleadoId 
            from factura 
            where fecha BETWEEN "2023-10-23" AND "2023-11-23"
        );
    ```

    - Procedimiento ``

    ```sql
        DELIMITER //
        create procedure ObtenerEmpleadosVentasRangoFechas(IN fecha_inicio DATE, IN fecha_fin DATE)
        begin
            select *
            from empleado
            where id IN (
                select empleadoId 
                from factura 
                where fecha BETWEEN fecha_inicio AND fecha_fin);
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerEmpleadosVentasRangoFechas(fecha_inicio, fecha_fin);`

4. Muestre cuales son los empleados que no estan asignados en una sucursalObtener

    - Consulta

    ```sql
    	select *
        from empleado
        where id NOT IN (
            select empleadoId 
            from trabajadores
        );
    ```

    - Procedimiento `ObtenerEmpleadosSinAsignacionSucursal`

    ```sql
        DELIMITER //
        create procedure ObtenerEmpleadosSinAsignacionSucursal()
        begin
            select *
            from empleado
            where id NOT IN (
                select empleadoId 
                from trabajadores
            );
        end //
        DELIMITER ;

    ```

    - Llamado `call ObtenerEmpleadosSinAsignacionSucursal();`

5. Haga una consulta que obtenga los empleados con mas de 1 factura emitida.

    - Consulta

    ```sql
        select *
        from empleado
        where id IN (
            select empleadoId 
            from factura GROUP BY empleadoId 
            HAVING COUNT(*) > 1
        ); 	
    ```

    - Procedimiento `ObtenerEmpleadosMasFacturasEmitidas`

    ```sql
        DELIMITER //
        create procedure ObtenerEmpleadosMasFacturasEmitidas(IN cantidad_facturas INT)
        begin
            select *
            from empleado
            where id IN (
                select empleadoId 
                from factura GROUP BY empleadoId 
                HAVING COUNT(*) > cantidad_facturas
            );
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerEmpleadosMasFacturasEmitidas(cantidad_facturas);`


</details>

<details>
  <summary>Tabla metodoPago</summary>
   <br>

1. Obtén el nombre de los clientes que hayan realizado compras con Tarjeta de crédito  y en la sucursal con dirección "Avenida B #456".

   - Consulta

   ```sql
       select id, nombre as nombre_cliente
       from cliente
       where id IN (
           select f.clienteId
           from factura f
           join metodoPago mp ON f.metodoPagoId = mp.id
           join empleado e ON f.empleadoId = e.id
           join trabajadores t ON e.id = t.empleadoId
           join sucursal s ON t.sucursalId = s.id
           where s.direccion = 'Avenida B #456' and mp.nombre = 'Tarjeta de crédito'
       );
   ```

   - Procedimiento `metoPago_en_sucursal_cliente`

   ```sql
   	DELIMITER // 
   	create procedure metoPago_en_sucursal_cliente(in direccionSucursal varchar(90), in nombreTargeta varchar(90))
   	begin 
   	 select id, nombre as nombre_cliente
       from cliente
       where id IN (
           select f.clienteId
           from factura f
           join metodoPago mp ON f.metodoPagoId = mp.id
           join empleado e ON f.empleadoId = e.id
           join trabajadores t ON e.id = t.empleadoId
           join sucursal s ON t.sucursalId = s.id
           where s.direccion = direccionSucursal and mp.nombre = nombreTargeta
       );
   	end // 
   	DELIMITER ;
   ```

   - Llamado `call metoPago_en_sucursal_cliente(direccionSucursal, nombreTargeta);`

2. Muestre los clientes que han realizado pagos con tarjeta. Tenga en cuenta que debe de imprimir el nombre del cliente y el tipo de pago que tiene el cliente.

    - Consulta

    ```sql
    	select distinct concat(c.nombre,'',c.apellido1) as cliente,
        m.tipo as tipo_pago
        from cliente c
        join factura f on c.id = f.clienteId
        join metodoPago m on f.metodoPagoId = m.id
        where m.tipo = 'Tarjeta';
    ```

    - Procedimiento `clientes_tipoPago`

    ```sql
    	DELIMITER //
    	create procedure clientes_tipoPago(in tipoPago varchar(70))
    	begin
    		select distinct concat(c.nombre,'',c.apellido1) as cliente,
            m.tipo as tipo_pago
            from cliente c
            join factura f on c.id = f.clienteId
            join metodoPago m on f.metodoPagoId = m.id
            where m.tipo = tipoPago;
    	end //
    	DELIMITER ;
    ```

    - Llamado `call clientes_tipoPago(tipoPago);`

4. Obtenga las facturas con un Método de Pago de id 1.

    - Consulta

    ```sql
    	select f.id as Id_factura, e.nombre as Nombre_Empleado, c.nombre as Nombre_Cliente, p.producto, m.nombre as MetodoPago, f.fecha
        from factura f
        JOIN empleado e ON e.id = f.empleadoId
        JOIN cliente c ON c.id = f.clienteId
        JOIN productos p ON p.id = f.productosId
        JOIN metodoPago m ON m.id = f.metodoPagoId
        where f.metodoPagoId = 1;
    ```

    - Procedimiento `ObtenerFacturasPorMetodoPago`

    ```sql
        DELIMITER //
        create procedure ObtenerFacturasPorMetodoPago(IN metodo_pago_id INT)
        begin
        		select f.id as Id_factura, e.nombre as Nombre_Empleado, c.nombre as Nombre_Cliente, p.producto, m.nombre as MetodoPago, f.fecha
            from factura f
            JOIN empleado e ON e.id = f.empleadoId
            JOIN cliente c ON c.id = f.clienteId
            JOIN productos p ON p.id = f.productosId
            JOIN metodoPago m ON m.id = f.metodoPagoId
            where f.metodoPagoId = metodo_pago_id;
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerFacturasPorMetodoPago(metodo_pago_id);`

5. Obtenga las facturas de segunda mano con un Método de Pago de id 7.

    - Consulta

    ```sql
        select f.id as Id_factura, e.nombre as Nombre_Empleado, c.nombre as Nombre_Cliente, p.producto, m.nombre as MetodoPago, f.fecha
        from facturaSegundaMano f
        JOIN empleado e ON e.id = f.empleadoId
        JOIN clienteSegundaMano c ON c.id = f.clienteId
        JOIN productosSegundaMano p ON p.id = f.productosId
        JOIN metodoPago m ON m.id = f.metodoPagoId
        where f.metodoPagoId = 7;
    ```

    - Procedimiento `ObtenerFacturasSegundaManoPorMetodoPago`

    ```sql
    	DELIMITER //
        create procedure ObtenerFacturasSegundaManoPorMetodoPago(IN metodo_pago_id INT)
        begin
        	select f.id as Id_factura, e.nombre as Nombre_Empleado, c.nombre as Nombre_Cliente, p.producto, m.nombre as MetodoPago, f.fecha
            from facturaSegundaMano f
            JOIN empleado e ON e.id = f.empleadoId
            JOIN clienteSegundaMano c ON c.id = f.clienteId
            JOIN productosSegundaMano p ON p.id = f.productosId
            JOIN metodoPago m ON m.id = f.metodoPagoId
            where f.metodoPagoId = metodo_pago_id;
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerFacturasSegundaManoPorMetodoPago(metodo_pago_id);`

</details>


 
<details>
  <summary>Tabla cliente</summary>
   <br>

1. Obtenga el nombre de los clientes que han realizado compras en todas las sucursales.

    - Consulta

    ```sql
     	select c.nombre as nombre_cliente
        from cliente c
        where not exists (
            select 1
            from sucursal s
            where not exists (
                select 1
                from factura f
                join empleado e on f.empleadoId = e.id
                join trabajadores t on e.id = t.empleadoId
                where t.sucursalId = s.id and f.clienteId = c.id
            )
        );
    ```

    - Procedimiento `clientes_todas_sucursales`

    ```sql
    	DELIMITER //
        create procedure clientes_todas_sucursales()
        begin
            select c.nombre as nombre_cliente
            from cliente c
            where not exists (
                select 1
                from sucursal s
                where not exists (
                    select 1
                    from factura f
                    join empleado e on f.empleadoId = e.id
                    join trabajadores t on e.id = t.empleadoId
                    where t.sucursalId = s.id and f.clienteId = c.id
                )
            );
        end //
        DELIMITER ;
    ```

    - Llamado `call clientes_todas_sucursales();`

2. Mostrar el nombre de los clientes que han realizado compras en más de una sucursal.

    - Consulta

    ```sql
    	select c.nombre
        from cliente c
        where (
            select count(DISTINCT t.sucursalId)
            from trabajadores t
            JOIN factura f on t.empleadoId = f.empleadoId
            where f.clienteId = c.id
        ) > 1;
    ```

    - Procedimiento `clientes_compras_mas_sucursal`

    ```sql
    	DELIMITER //
        create procedure clientes_compras_mas_sucursal(in numeroSucursales int)
        begin 
            select c.nombre
            from cliente c
            where (
                select count(DISTINCT t.sucursalId)
                from trabajadores t
                JOIN factura f on t.empleadoId = f.empleadoId
                where f.clienteId = c.id
            ) > numeroSucursales;
        end //
        DELIMITER ;
    ```

    - Llamado `call clientes_compras_mas_sucursal(numeroSucursales);`

3. Calcular el monto total de compras realizadas por clientes con más de 5 productos en una sola factura.

    - Consulta

    ```sql
        select SUM(p.precio * ps.cantidad) as monto_total
        from factura f
        join productos ps on f.productosId = ps.id
        join producto p on ps.producto = p.producto
        where ps.cantidad > 5;
    ```

    - Procedimiento `monto_compras_cliente_cant_productos`

    ```sql
    	DELIMITER //
    	create procedure monto_compras_cliente_cant_productos(in numProductos int)
    	begin
    		select SUM(p.precio * ps.cantidad) as monto_total
            from factura f
            join productos ps on f.productosId = ps.id
            join producto p on ps.producto = p.producto
            where ps.cantidad > numProductos;
    	end //
    	DELIMITER ;
    ```

    - Llamado `call monto_compras_cliente_cant_productos(cantProductos);`


4. Obtenga los clientes que han utilizado Múltiples Metodos de Pago.

    - Consulta

    ```sql
    	select *
        from cliente c
        where c.id IN (
            select clienteId
            from factura
            GROUP BY clienteId
            HAVING COUNT(DISTINCT metodoPagoId) > 1
        );
    ```

    - Procedimiento `ObtenerClientesMultiplesMetodosPago`

    ```sql
    	DELIMITER //
        create procedure ObtenerClientesMultiplesMetodosPago()
        begin
            select *
            from cliente c
            where c.id IN (
                select clienteId
                from factura
                GROUP BY clienteId
                HAVING COUNT(DISTINCT metodoPagoId) > 1
            );
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerClientesMultiplesMetodosPago();`

</details>


<details>
  <summary>Tabla factura</summary>
   <br>

1. Obtenga los detalles de Factura con el id "2"

    - Consulta

    ```sql
    	select f.*, e.nombre as empleado, c.nombre as cliente, p.producto as producto, mp.nombre as metodo_pago
        from factura f
        JOIN empleado e ON f.empleadoId = e.id
        JOIN cliente c ON f.clienteId = c.id
        JOIN productos p ON f.productosId = p.id
        JOIN metodoPago mp ON f.metodoPagoId = mp.id
        where f.id = 2;	
    ```

    - Procedimiento `ObtenerDetallesFactura`

    ```sql
        DELIMITER //
        create procedure ObtenerDetallesFactura(IN factura_id INT)
        begin
            select f.*, e.nombre as empleado, c.nombre as cliente, p.producto as producto, mp.nombre as metodo_pago
            from factura f
            JOIN empleado e ON f.empleadoId = e.id
            JOIN cliente c ON f.clienteId = c.id
            JOIN productos p ON f.productosId = p.id
            JOIN metodoPago mp ON f.metodoPagoId = mp.id
            where f.id = factura_id;
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerDetallesFactura(factura);`


</details>

<details>
  <summary>Tabla productos</summary>
   <br>

1. Encontrar los productos que no han sido vendidos en el último mes.

    - Consulta

    ```sql
    	select p.producto
        from  producto p         
        where not exists (             
            select 1             
            from factura f             
            JOIN productos ps ON f.productosId = ps.id             
            where ps.producto = p.producto AND f.fecha >= curdate() - interval 1 month
        );     
    ```

    - Procedimiento`productos_no_vendidos_mes`

    ```sql
    	DELIMITER //
        create procedure productos_no_vendidos_mes(in mes int)
        begin     		
        select p.producto             
        from  producto p             
        where not exists (                 
            select 1                 
            from factura f                 
            JOIN productos ps ON f.productosId = ps.id                 
            where ps.producto = p.producto AND f.fecha >= curdate() - interval mes month             
        );    
        end //     	
       	DELIMITER ;     
    ```

    - Llamado`call productos_no_vendidos_mes(mes);`

2. Listar los productos que han sido comprados más de 2 veces en total.

    - Consulta

    ```sql
    	select ps.producto
        from productos ps
        join factura f on ps.id = f.productosId
        group by ps.producto
        having count(f.id) > 2;
    ```

    - Procedimiento `productos_comprados_cant`

    ```sql
    	DELIMITER //
    	create procedure productos_comprados_cant(in cantidad int)
    	begin
    		select ps.producto
            from productos ps
            join factura f on ps.id = f.productosId
            group by ps.producto
            having count(f.id) > cantidad;
    	end //
    	DELIMITER ;
    ```

    - Llamado `call productos_comprados_cant(cantidad);`

</details>
 
<details>
  <summary>Tabla producto</summary>
   <br>

1. Muestre los productos que ha suministrado el distribuidor "Bicicletas del Futuro Ltda"

   - Consulta

   ```sql
   	select p.producto as nombre_producto 
       from producto p
       join inventario i on i.producto = p.producto
       join distribuidor d on i.distribuidorId = d.id
       where d.nombre like '%Bicicletas del Futuro Ltda%';
   ```

   - Procedimiento `productos_suministrados_distribuidor`

   ```sql
   	DELIMITER //
   	create procedure productos_suministrados_distribuidor(in nombreDistribuidor varchar(90))
   	begin
   		set @distribuidor = concat("%",nombreDistribuidor,"%");
   
   		select p.producto as nombre_producto 
           from producto p
           join inventario i on i.producto = p.producto
           join distribuidor d on i.distribuidorId = d.id
           where d.nombre like @distribuidor;
   
   	end //
   	DELIMITER ;
   ```

   - Llamado `call productos_suministrados_distribuidor(nombreDistribuidor);`

2. Consulte cuales son los Productos cuyo precio es mayor al promedio y muéstrelos en pantalla.

    - Consulta

    ```sql
        select distinct p.producto
        from producto p
        where p.precio > (
            select avg(precio) from producto
        );
    ```

    - Procedimiento `productos_mayor_promedio`

    ```sql
    	DELIMITER //
    	create procedure productos_mayor_promedio()
    	begin
            select distinct p.producto
            from producto p
            where p.precio > (
                select avg(precio) from producto
            );
    	end //
    	DELIMITER ; 
    ```

    - Llamado `call productos_mayor_promedio();`

3. Encuentre cuales son los productos con precio superior al promedio de su categoría. Imprima el nombre del producto y su categoría.

    - Consulta

    ```sql
    
    select distinct p.producto, p.categoria
    from producto p
    where p.precio > (
        select avg(precio)
        from producto
        where categoria = p.categoria
    );
    ```

    - Procedimiento `productos_precio_sup_categoria`

    ```sql
    	DELIMITER //
    	create procedure productos_precio_sup_categoria()
    	begin
            select distinct p.producto, p.categoria
            from producto p
            where p.precio > (
                select avg(precio)
                from producto
                where categoria = p.categoria
            );
    	end //
    	DELIMITER ;
    ```

    - Llamado `call productos_precio_sup_categoria();`

</details>

 
<details>
  <summary>Tabla inventario</summary>
   <br>

1. Listar los productos en el inventario que tengan una cantidad superior a 25 y un precio inferior a 20000.

   - Consulta

   ```sql
   	select *
   	from inventario
   	where cantidad > 25
     	and producto in (
         select producto 
         from producto 
         where precio < 20000
     	);
   ```

   - Procedimiento `producto_inventario_desde_hasta`

   ```sql
   	DELIMITER //
   	create procedure producto_inventario_desde_hasta(in desde int, in hasta int) 
   	begin
   	select *
           from inventario
           where cantidad > desde
           and producto in (
             select producto 
             from producto 
             where precio < hasta
           );
   	end // 
   	DELIMITER ;
   ```

   - Llamado `call producto_inventario_desde_hasta(desde, hasta);`

</details>


<details>
  <summary>Tabla distribuidor</summary>
   <br>

1. Encuentra el nombre y el número de teléfono de los distribuidores que han suministrado productos en el último mes.

   - Consulta

   ```sql
   	select distinct d.nombre, numeroTelefono as Telefono
   	from distribuidor d
   	join inventario i on i.distribuidorId = d.id
   	where 
   	month(i.fecha) = month(current_date())
   	and
       year(i.fecha) = year(current_date());
   ```

   - Procedimiento `distribuidores_ultimo_mes`

   ```sql
   	DELIMITER //
   	create procedure distribuidores_ultimo_mes()
   	begin 
           select distinct d.nombre, numeroTelefono as Telefono
           from distribuidor d
           join inventario i on i.distribuidorId = d.id
           where 
           month(i.fecha) = month(current_date())
           and
           year(i.fecha) = year(current_date());
   	end //
   	DELIMITER ;
   ```

   - Llamado `call distribuidores_ultimo_mes();`

2. Muestre la cantidad de productos suministrados por el distribuidor  "Bicicletas del Futuro Ltda".

    - Consulta

    ```sql
        select count(p.producto) as cantidad_de_productos
        from producto p
        join inventario i ON i.producto = p.producto
        join distribuidor d ON i.distribuidorId = d.id
        where d.nombre like '%Bicicletas del Futuro Ltda%';
    ```

    - Procedimiento `cantidad_productos_distribuidor`

    ```sql
    	DELIMITER //
    	create procedure cantidad_productos_distribuidor(in distribuidor varchar(150))
    	begin
    		set @distribuidoBuscar = concat('%', distribuidor ,'%');
    		select count(p.producto) as cantidad_de_productos
            from producto p
            join inventario i ON i.producto = p.producto
            join distribuidor d ON i.distribuidorId = d.id
            where d.nombre like @distribuidoBuscar;
    	end //
    	DELIMITER ;
    ```

    - Llamado `call cantidad_productos_distribuidor(distribuidor);`

</details>


<details>
  <summary>Tabla preFactura</summary>
   <br>

</details>


<details>
  <summary>Tabla servicio</summary>
   <br>

1. Listar los servicios ofrecidos para "Bicicletas" de complejidad "Baja" y al id de factura al que pertenecen.

   - Consulta

   ```sql
       select f.id as id_factura, pf.tipoServicio
       from factura f
       join preFactura pf on f.preFacturaId = pf.id
       where pf.tipoServicio in (
       	select tipoServicio
       	from servicio
       	where complejidad = 'Baja' and tipoVehiculo = 'Bicicleta'
       );
   ```

   - Procedimiento `servicios_complejidad`

   ```sql
   	DELIMITER //
   	create procedure servicios_complejidad(in complejidadTrabajo varchar(50), in tipoDeVehiculo varchar(150))
   	begin
           select f.id as id_factura, pf.tipoServicio
           from factura f
           join preFactura pf on f.preFacturaId = pf.id
           where pf.tipoServicio in (
               select tipoServicio
               from servicio
               where complejidad = complejidadTrabajo and tipoVehiculo = tipoDeVehiculo
           );
   	end //
   	DELIMITER ;
   ```

   - Llamado `call servicios_complejidad(complejidadTrabajo, tipoDeVehiculo);`

2. Imprima en pantalla cuales son los servicios no utilizados en ninguna factura. Muestre todas la columnas.

    - Consulta

    ```sql
        select * from servicio s
        where not exists 
        (select 1 from factura f 
        join preFactura pf on f.preFacturaId = pf.id
        where pf.tipoServicio = s.tipoServicio);
    ```

    - Procedimiento `productos_no_ulizados_factura`

    ```sql
    	DELIMITER //
    	create procedure productos_no_ulizados_factura()
    	begin
    		select * from servicio s
            where not exists 
            (select 1 from factura f 
            join preFactura pf on f.preFacturaId = pf.id
            where pf.tipoServicio = s.tipoServicio);
    	end //
    	DELIMITER ;
    ```

    - Llamado `call productos_no_ulizados_factura();`

3. Encontrar los servicios que no han sido utilizados en los últimos 3 meses.

    - Consulta

    ```sql
    	select tipoServicio
        from servicio s
        where not exists (
            select 1
            from preFactura pf
            join factura f on pf.id = f.preFacturaId
            where pf.tipoServicio = s.tipoServicio and f.fecha >= CURDATE() - interval 3 MONTH
        );
    ```

    - Procedimiento `servicios_no_utilizados_mes`

    ```sql
    	DELIMITER // 
        create procedure servicios_no_utilizados_mes(in mes int)
        begin
        	select tipoServicio
            from servicio s
            where not exists (
                select 1
                from preFactura pf
                join factura f on pf.id = f.preFacturaId
                where pf.tipoServicio = s.tipoServicio and f.fecha >= CURDATE() - interval mes MONTH
            );
        end //
        DELIMITER ;
    ```

    - Llamado `call servicios_no_utilizados_mes(mes);`

</details>



<details>
  <summary>Tabla facturaSegundaMano</summary>
   <br>

1.  Obtenga los detalles de Factura Segunda Mano con el id "1"

    - Consulta

    ```sql
    	select fs.*, e.nombre as empleado, c.nombre as cliente, p.producto as producto, mp.nombre as metodo_pago
        from facturaSegundaMano fs
        JOIN empleado e ON fs.empleadoId = e.id
        JOIN clienteSegundaMano c ON fs.clienteId = c.id
        JOIN productosSegundaMano p ON fs.productosId = p.id
        JOIN metodoPago mp ON fs.metodoPagoId = mp.id
        where fs.id = 1;	
    ```

    - Procedimiento `ObtenerDetallesFacturaSegundaMano`
    
    ```sql
    	DELIMITER //
    	create procedure ObtenerDetallesFacturaSegundaMano(IN factura_id INT)
    	begin
            select fs.*, e.nombre as empleado, c.nombre as cliente, p.producto as producto, mp.nombre as metodo_pago
            from facturaSegundaMano fs
            JOIN empleado e ON fs.empleadoId = e.id
            JOIN clienteSegundaMano c ON fs.clienteId = c.id
            JOIN productosSegundaMano p ON fs.productosId = p.id
            JOIN metodoPago mp ON fs.metodoPagoId = mp.id
            where fs.id = factura_id;
    	end //
    	DELIMITER ;
    ```
    
    - Llamado `call ObtenerDetallesFacturaSegundaMano(factura);`
    
</details>

<details>
  <summary>Tabla productosSegundaMano</summary>
   <br>

1. Obtenga el nombre de los productos de segunda mano con estado "Nuevo" y un precio mayor a 300.

   - Consulta

   ```sql
   	select ps.producto as nombre_producto 
       from productoSegundaMano ps
       where ps.estado like '%nuevo%' and ps.precio > 300;
   ```

   - Procedimiento `productosSegundaMano_estado_mayorA`

   ```sql
   	DELIMITER //
   	create procedure productosSegundaMano_estado_mayorA(in estadoProducto varchar(40), in precioProducto int)
   	begin
   		select ps.producto as nombre_producto 
           from productoSegundaMano ps
           where ps.estado like concat('%', estadoProducto, '%') and ps.precio > precioProducto;
   	end //
   	DELIMITER ;
   ```

   - Llamado `call productosSegundaMano_estado_mayorA(estadoProducto, precioProducto);`


2.   Muestre la cantidad de productos suministrados por el distribuidor  "Bicicletas del Futuro Ltda".

- Consulta

    ```sql
        select count(p.producto) as cantidad_de_productos
        from producto p
        join inventarioSegundaMano i ON i.producto = p.producto
        join distribuidorSegundaMano d ON i.distribuidorId = d.id
        where d.nombre like '%Velocidad Extrema Distribuciones%';
    ```

    - Procedimiento `cantidad_productos_distribuidorSegunda`

    ```sql
    	DELIMITER //
    	create procedure cantidad_productos_distribuidorSegunda(in distribuidorSegundaMano varchar(150))
    	begin
    		set @distribuidoBuscar = concat('%', distribuidorSegundaMano ,'%');
    		select count(p.producto) as cantidad_de_productos
            from producto p
            join inventarioSegundaMano i ON i.producto = p.producto
            join distribuidorSegundaMano d ON i.distribuidorId = d.id
            where d.nombre like @distribuidoBuscar;
    	end //
    	DELIMITER ;
    ```

    - Llamado `call cantidad_productos_distribuidorSegunda(distribuidorSegundaMano);`

3. Listar los productos de segunda mano que han sido comprados más de 1 vez en total.

    - Consulta

    ```sql
    	select ps.producto
        from productosSegundaMano ps
        join facturaSegundaMano f on ps.id = f.productosId
        group by ps.producto
        having count(f.id) > 1;
    ```

    - Procedimiento `productosSegundaMano_comprados_cant`

    ```sql
    	DELIMITER //
    	create procedure productosSegundaMano_comprados_cant(in cantidad int)
    	begin
            select ps.producto
            from productosSegundaMano ps
            join facturaSegundaMano f on ps.id = f.productosId
            group by ps.producto
            having count(f.id) > cantidad;
    	end //
    	DELIMITER ;
    ```

    - Llamado `call productosSegundaMano_comprados_cant(cantidad);`

</details>

<details>
  <summary>Tabla productoSegundaMano</summary>
   <br>

1. Calcular el monto total de compras realizadas por clientes con más de 3 productos en una sola factura. Los clientes, los productos y la factura son todas de segunda mano.

    - Consulta

    ```sql
    	select SUM(p.precio * ps.cantidad) as monto_total
        from facturaSegundaMano f
        join productosSegundaMano ps on f.productosId = ps.id
        join productoSegundaMano p on ps.producto = p.producto
        where ps.cantidad > 3;
    ```

    - Procedimiento `monto_compras_cliente_cant_productosSegundaMano`

    ```sql
    	DELIMITER //
    	create procedure monto_compras_cliente_cant_productosSegundaMano(in numProductos int)
    	begin
    		select SUM(p.precio * ps.cantidad) as monto_total
            from facturaSegundaMano f
            join productosSegundaMano ps on f.productosId = ps.id
            join productoSegundaMano p on ps.producto = p.producto
            where ps.cantidad > numProductos;
    	end //
    	DELIMITER ;
    ```

    - Llamado `call call monto_compras_cliente_cant_productosSegundaMano(numProductos);`

</details>

<details>
  <summary>Tabla inventarioSegundaMano</summary>
   <br>

1. Listar los productos de segunda mano en el inventario de segunda mano que tengan una cantidad superior a 25 y un precio inferior a 20000.

    - Consulta

    ```sql
    	select *
        from inventarioSegundaMano
        where cantidad > desde
        and producto in (
        select producto 
        from productoSegundaMano 
        where precio < hasta
    ```

    - Procedimiento `productoSegun_inventarioSegun_desde_hasta`

    ```sql
    	DELIMITER //
    	create procedure productoSegun_inventarioSegun_desde_hasta(in desde int, in hasta int) 
    	begin
    		select *
            from inventarioSegundaMano
            where cantidad > desde
            and producto in (
              select producto 
              from productoSegundaMano 
              where precio < hasta
            );
    	end // 
    	DELIMITER ;
    ```

    - Llamado `call productoSegun_inventarioSegun_desde_hasta(desde, hasta);`


</details>


<details>
  <summary>Tabla distribuidorSegundaMano</summary>
   <br>


1. Encuentra el nombre y el número de teléfono de los distribuidores de segunda mano que han suministrado productos en el último mes.

    - Consulta

    ```sql
    	select distinct d.nombre, numeroTelefono as Telefono
    	from distribuidorSegundaMano d
    	join inventarioSegundaMano i on i.distribuidorId = d.id
    	where 
    	month(i.fecha) = month(current_date())
    	and
        year(i.fecha) = year(current_date());
    ```

    - Procedimiento `distribuidoresSegundaMano_ultimo_mes`

    ```sql
    	DELIMITER //
    	create procedure distribuidoresSegundaMano_ultimo_mes()
    	begin 
            select distinct d.nombre, numeroTelefono as Telefono
            from distribuidorSegundaMano d
            join inventarioSegundaMano i on i.distribuidorId = d.id
            where 
            month(i.fecha) = month(current_date())
            and
            year(i.fecha) = year(current_date());
    	end //
    	DELIMITER ;
    ```

    - Llamado `call distribuidoresSegundaMano_ultimo_mes();`


</details>

<details>
  <summary>Tabla clienteSegundaMano</summary>
   <br>

1. Obtenga el nombre de los clientes de segunda mano que han realizado compras en todas las sucursales.

    - Consulta

    ```sql
    	select c.nombre as nombre_cliente
        from clienteSegundaMano c
        where not exists (
            select 1
            from sucursal s
            where not exists (
                select 1
                from factura f
                join empleado e on f.empleadoId = e.id
                join trabajadores t on e.id = t.empleadoId
                where t.sucursalId = s.id and f.clienteId = c.id
            )
        );
    ```

    - Procedimiento `clientesSegundaMano_todas_sucursales`

    ```sql
    	DELIMITER //
        create procedure clientesSegundaMano_todas_sucursales()
        begin
        	select c.nombre as nombre_cliente
        	from clienteSegundaMano c
        	where not exists (
            select 1
            from sucursal s
            where not exists (
                select 1
                from factura f
                join empleado e on f.empleadoId = e.id
                join trabajadores t on e.id = t.empleadoId
                where t.sucursalId = s.id and f.clienteId = c.id
            ));
        end //
    	DELIMITER ;
    ```

    - Llamado `call clientesSegundaMano_todas_sucursales();`


2. Obtenga un cliente de segunda mano con 2 compras

    - Consulta

    ```sql
        select *
        from clienteSegundaMano c
        where c.id IN (
            select clienteId 
            from facturaSegundaMano 
            GROUP BY clienteId 
            HAVING COUNT(*) > 2
        );
    ```

    - Procedimiento `ObtenerClienteSegundaManoMasCompras`

    ```sql
    	DELIMITER //
        create procedure ObtenerClienteSegundaManoMasCompras(IN cantidad_compras INT)
        begin
            select *
            from clienteSegundaMano c
            where c.id IN (
                select clienteId 
                from facturaSegundaMano 
                GROUP BY clienteId 
                HAVING COUNT(*) > cantidad_compras
            );
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerClienteSegundaManoMasCompras();`

3. Obtenga los clientes de segunda mano que han utilizado Múltiples Metodos de Pago.

    - Consulta

    ```sql
    	select *
        from clienteSegundaMano c
        where c.id IN (
            select clienteId
            from facturaSegundaMano
            GROUP BY clienteId
            HAVING COUNT(DISTINCT metodoPagoId) > 1
        );
    ```

    - Procedimiento `ObtenerClienteSegundaManoMultiplesMetodosPago`

    ```sql
    	DELIMITER //
        create procedure ObtenerClienteSegundaManoMultiplesMetodosPago()
        begin
            select *
            from clienteSegundaMano c
            where c.id IN (
                select clienteId
                from facturaSegundaMano
                GROUP BY clienteId
                HAVING COUNT(DISTINCT metodoPagoId) > 1
            );
        end //
        DELIMITER ;
    ```

    - Llamado `call ObtenerClienteSegundaManoMultiplesMetodosPago();`


</details>





