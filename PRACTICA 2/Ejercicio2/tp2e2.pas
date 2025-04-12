//preguntar si es correcto los modulos leerMaestro y leerDetalle
//procedure crearDetalle. Por que si es de tipo txt pregunto por not eof en vez de
//hacer el modulo leer
//dudas en crearDetalle IR
Program tp2e2;
Type
	producto = record
		cod: integer;
		nombre: strin;
		precio: real;
		stock_act: integer;
		stock_min: integer;
	end;
	
	venta = record
		cod: integer;
		cantidad: integer;
	end;
	
	
	maestro = file of producto;
	detalle = file of venta;

Procedure leerDetalle (var arc: detalle; var reg: venta);
begin
	if (not(eof(arc))) then
		read(arc, reg);
	else
		reg.cod = 9999;
end;
Procedure leerMaestro (var arc: maestro; var reg: producto);
begin
	if (not(eof(arc))) then
		read(arc, reg);
	else
		reg.cod = 9999;
end;
Procedure crearMaestro(var mae: maestro; var txt: text);
var
	name: string;
	datos: producto;
begin
	reset(txt);
	write('Ingrese nombre para el archivo maestro: ');
	read(name);
	assign(mae, name);
	rewrite(mae);
	while (not(txt)) do begin
		with datos do begin
			readln(txt, cod, precio, stock_act, stock_min, nombre);
			write(mae, datos);
		end;
	end;
	writeln('Archivo maestro creado!');
	close(mae);
	close(txt);
end;

//por que no es necesario hacer el modulo txt
Procedure crearDetalle(var det: detalle; var txt: text);
var
	name: string;
	datos: venta;
begin
	reset(txt);
	write('Ingrese nombre para el archivo detalle: ');
	read(name);
	assign(det, name);
	rewrite(det);
	while (not(eof(txt))) do begin
		with datos do begin
			readln(txt, cod, cantidad);
			write(det, datos);
		end; 
	end;
	writeln('Archivo detalle creado!');
	close(txt);
	close(det);
end;
	
	
Procedure actualizarMaestro(var mae: maestro; var det: detalle);
var
	regD, regM: venta;
begin
	reset(mae);
	reset(det);
	leerDetalle(det, regD);
	while (regD.cod <> 9999) do begin
		read(mae, regM);
		while (regM.cod <> regD.cod) do 
			read(mae, regM);
		regM.stock_act:= regM.stock_act - regD.cantidad;
		seek (mae, filepos(mae)-1); //el read sigue avanzando
		write(mae, regM); //actualizo el stock
		leerDetalle(det, regD);
	end;
	writeln('Stock actual actualizado!');
	close(det);
	close(mae);
end;

Procedure verStock (var mae: maestro; var det: detalle);
var
	stock: txt;
	reg: producto;
begin
	reset(det);
	reset(mae);
	assign(stock, 'stock_minimo.txt');
	rewrite(stock);
	leerMaestro(mae, reg);	
	while (reg.cod <> 9999) do begin
		with reg do begin
			if (stock_act < stock_min) then
				writeln(stock,'CODIGO: ',cod,' PRECIO: ', precio,' STOCK ACTUAL: ', stock_act,' STOCK MINIMO: ', stock_min,' NOMBRE: ', nombre);
		end;
		leerMaestro(mae, reg);
	end;
	writeln('Archivo de tipo text creado!');
	close(mae);
	close(det);
	close(stock);
end;
Procedure imprimirMaestro(mae: maestro);
begin
	reset(mae);
	leerMaestro(

Procedure menu ();
var
	mae: maestro;
	det: detalle;
	cargaM, cargaD: text;
	option: integer;
begin
	writeln('MENU DE OPCIONES');
	writeln('1. Generar archivos binarios maestro y detalle a partir de un txt');
	writeln('2. Actualizar el maestro a partir del detalle');
	writeln('3. Listar en un archivo txt los productos con stock actual menor al minimo');
	writeln('4. Salir');
	while (option <> 4) do begin
		case option of
			1: begin
				assign(cargaM, 'maestro.txt');
				assign(caraD, 'detalle.txt');
				crearMaestro(mae, cargaM);
				crearDetalle(det, cargaD);
			end;
			2: begin
					actualizarMaestro(mae, det);
					imprimirMaestro(mae);
	
Begin
