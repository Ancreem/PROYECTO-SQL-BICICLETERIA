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

### Consultas

<details>
  <summary>Click para desplegar</summary>
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

2. Listar los productos en el inventario que tengan una cantidad superior a 25 y un precio inferior a 20000.

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

3. Encuentra el nombre y el número de teléfono de los distribuidores que han suministrado productos en el último mes.

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

4. Devuelva que trabajador no se encuentra en ninguna sucursal. Muestre su id, rol, con su nombre y apellidos.

   - Consulta

   ```sql
       select e.id, e.rol, CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS nombre_completo
       from empleado e
       left join trabajadores t on e.id = t.empleadoId
       where t.sucursalId is NULL;
   ```

   - Procedimiento `trabajador_no_sucursal`

   ```sql
     DELIMITER //
   	create procedure trabajador_no_sucursal()
   	begin
   	    select e.id, e.rol, CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS nombre_completo
       	from empleado e
       	left join trabajadores t on e.id = t.empleadoId
       	where t.sucursalId is NULL;
   	end //
   	DELIMITER ;
   ```

   - Llamado `call trabajador_no_sucursal() ;`

5. Obtén el nombre de los clientes que hayan realizado compras con Tarjeta de crédito  y en la sucursal con dirección "Avenida B #456".

   - Consulta

   ```sql
       select id, nombre AS nombre_cliente
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
   	 select id, nombre AS nombre_cliente
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

6. Listar los servicios ofrecidos para "Bicicletas" de complejidad "Baja" y al id de factura al que pertenecen.

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

7. Obtenga el nombre de los productos de segunda mano con estado "Nuevo" y un precio mayor a 300.

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

8. Obtener el total de ventas realizado por el empleado con el id "1", mostrando el  nombre del empleado y la suma de los montos de venta, considerando las facturas emitidas.

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

9. Muestre los productos que ha suministrado el distribuidor "Bicicletas del Futuro Ltda"

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

10. Muestre los clientes que han realizado pagos con tarjeta. Tenga en cuenta que debe de imprimir el nombre del cliente y el tipo de pago que tiene el cliente.

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

11. Consulte cuales son los Productos cuyo precio es mayor al promedio y muéstrelos en pantalla.

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

12. Imprima en pantalla cuales son los servicios no utilizados en ninguna factura. Muestre todas la columnas.

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

13. Encuentre cuales son los productos con precio superior al promedio de su categoría. Imprima el nombre del producto y su categoría.

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

14. Muestre la cantidad de productos suministrados por el distribuidor  "Bicicletas del Futuro Ltda".

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

15. Obtenga el nombre de los clientes que han realizado compras en todas las sucursales.

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

16. Devuelva el nombre y la dirección de las sucursales que no han realizado ventas en el último mes.

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

17. Mostrar el nombre de los clientes que han realizado compras en más de una sucursal.

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

18. Encontrar los productos que no han sido vendidos en el último mes.

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

    - Procedimiento `productos_no_vendidos_mes`

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

    - Llamado `call productos_no_vendidos_mes(mes);`

19. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

20. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

21. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

22. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

23. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

24. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

25. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

26. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

27. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

28. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

29. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

30. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

31. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

32. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

33. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

34. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

35. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

36. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

37. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

38. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

39. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

40. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

41. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

42. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

43. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

44. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

45. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

46. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

47. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

48. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

49. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

50. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

51. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

52. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

53. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

54. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

55. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

56. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

57. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

58. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

59. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

60. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

61. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

62. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

63. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

64. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

65. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

66. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

67. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

68. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

69. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

70. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

71. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

72. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

73. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

74. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

75. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

76. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

77. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

78. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

79. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

80. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

81. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

82. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

83. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

84. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

85. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

86. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

87. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

88. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

89. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`

90. a

    - Consulta

    ```sql
    
    ```

    - Procedimiento ``

    ```sql
    
    ```

    - Llamado `call ;`


DELIMITER //

CREATE PROCEDURE mostrarSucursal(IN columna VARCHAR(255), in tabla VARCHAR(255))

BEGIN

SET@sql_query=CONCAT('SELECT ', columna, ' FROM', tabla,';');

    PREPARE dynamic_statement FROM@sql_query;
    
    EXECUTE dynamic_statement;
    
    DEALLOCATE PREPARE dynamic_statement;

END //

DELIMITER

  
</details>


