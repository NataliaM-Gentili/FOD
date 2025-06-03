{Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.}
Program practica3ejercicio6;
Const
	valorAlto = 999999;
Type
	prenda = record
		cod_prenda : LongInt;
		descripcion: String;
		colores: String;
		tipo_prenda: String;
		stock: integer;
		precio_unitario: real;
	end;
	
	maestro = file of prenda;	
	detalle = file of LongInt;

procedure leerDetalle (var det: detalle; var cod: LongInt);
begin
	if (not eof(det)) then
		read(det, cod);
	else
		cod := valorAlto;
end;
procedure leerMaestro (var mae: maestro; var reg: prenda);
begin
	if (not eof(mae)) then
		read(mae, reg)
	else
		reg.codigo := valorAlto;
end;
procedure bajasPrendas (var mae: maestro; var det: detalle);
var
	cod: LongInt;
	reg: prenda;
begin
	reset(mae);
	reset(det);
	
	leerDetalle(det, cod);
	while (cod <> valorAlto) do begin
		leerMaestro(mae, reg);
		while (reg.cod_prenda <> cod) do 
			leerMaestro(mae, reg);
		seek (mae, filepos(mae)-1);
		reg.stock := reg.stock * -1;
		write(mae, reg);
		seek(mae, 0);
		leerDetalle(det, cod);
	end;
	close(mae);
	close(det);
end;
procedure efectivizarBajas (var mae: maestro; var arc: maestro);
var
	reg: prenda;
	
begin
	reset(mae);
	assign(arc, 'MaestroActualizado');
	rewrite(arc);
	
	leerMaestro(mae, reg);
	while (reg.cod_prenda <> valorAlto) do begin
		if (reg.stock > -1) then 
			write(arc, reg);
		leerMaestro(mae, reg);
	end;
	writeln('Bajas terminadas!');
	rename(mae, 'MaestroViejo_Respaldo');
	rename(arc, 'ArchivoMaestro');
	close(mae);
	close(arc);
end;
var
	mae, nuevo: maestro;
	det: detalle;
	
begin
	assign(mae, 'ArchivoMaestro'); //ilustrativamente para mostrar que el nuevo arc tendra el mismo nombre 
	crearMaestro(mae); //se dispone
	crearDetalle(det); //se dispone
	bajasPrendas(mae, det);
	efectivizarBajas(mae, nuevo);
	writeln('FIN');
end.
