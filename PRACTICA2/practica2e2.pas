{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido}
Program prac2e2;
Const
	valorAlto = 999999;
Type
	productos = record
		codigo: LongInt;
		nombre: String;
		precio: real;
		stock: integer;
		stockMin: integer;
	end;
	
	ventas = record
		codigo: LongInt;
		unidades: integer;
	end;
	
	maestro = file of productos;
	detalle = file of ventas;
	
Procedure leerDetalle (var det: detalle; var v: ventas);
begin
	if (not(eof(det))) then
		read(det, v)
	else
		v.codigo := valorAlto;
end;
Procedure leerMaestro (var mae: maestro; var p: productos);
begin
	if (not(eof(mae))) then
		read(mae, p);
	else
		p.codigo := valorAlto;
end;

Procedure actualizarMaestro (var mae: maestro; var det: detalle);
var
	v: ventas;
	prod: productos;
begin
	reset(mae);
	reset(det);
	
	leerDetalle(det, v);
	while (v.codigo <> valorAlto) do begin
		read(mae, prod);
		while (prod.codigo <> v.codigo) do 
			read(mae, prod);
			
		// actualizar el maestro solo una vez por cada producto, puede haber mas de un detalle de un mismo producto
		while (v.codigo = prod.codigo) do begin
			prod.stock := prod-stock - v.unidades;
			leerDetalle(det, v);
		end;
			
		seek(mae, filepos(mae)-1);
		write(mae, prod);
	end;
	close(mae);
	close(det);
end;

// DUDA: ES NECESARIO PASAR EL ARCHIVO DE TIPO TEXT POR PARÁMETRO?
Procedure crearTxt (var mae: maestro; var texto: Txt);
var
	p: productos;
begin
	assign(texto, 'stick_minimo.txt');
	rewrite(texto);
	reset(mae);
	
	leerMaestro(mae, p);
	while (p.codigo <> valorAlto) do begin
		if (p.stock < p.stockMinimo) then begin
			writeln(texto, 'CODIGO: ', p.codigo, ' NOMBRE: ', p.nombre);
			writeln(texto, 'PRECIO: ', p.precio, ' STOCK ACTUAL: ', p.sotck,' STOCK MINIMO: ', p.stockMinimo);
		end;
		leerMaestro(mae, p);
	end;
	writeln('TXT CREADO');
	close(mae);
	close(texto);
end;
var
	mae: maestro;
	det: detalle;
	archivoTexto: text;
begin
	writeln('PRACTICA 2 EJERCICIO 2');
	crearDetalle(det); //se dispone
	crearMaestro(mae); //se dispone
	actualizarMaestro(mae, det);
	crearTxt(mae, archivoTexto);

end;
		
