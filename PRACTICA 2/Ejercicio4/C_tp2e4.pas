//pedir correccion de todo

{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}
Program tp2e4;
const
	DF = 3; //30
	valorAlto = 9999;
Type
	subrango = 1..DF;
	producto = record
		cod: integer;
		nombre: String;
		desc: string;
		stock: integer;
		stock_min: integer;
		precio: real;
	end;
	
	sucursales = record
		cod: integer;
		cantidad: integer;
	end;
	
	maestro = file of producto;
	detalle = file of sucursales;
	
	vecDetalles = array [subrango] of detalle;
	vecMin = array [subrango] of sucursales;
Procedure leerM (var mae: maestro; var reg: producto);
begin
		if (not(eof(mae))) then
			read(mae, reg)
		else
			reg.cod := 9999;
end;
Procedure leer (var det:detalle; var reg: sucursales);
begin
		if (not(eof(det))) then
			read(det, reg)
		else
			reg.cod := 9999;
end;
Procedure crearDetalles(var v: vecDetalles);
var
	i: integer;
	s: sucursales;
	name: String;
begin

	for i:= 1 to DF do begin
		writeln('HOLA');
		readln();
		write('Inserte nombre para el archivo binario detalle: '); read(name);
		assign(v[i], name);
		rewrite(v[i]);
		writeln('Ingrese cod y cantidad vendida. COD 0 para terminar el detalle');
		read(s.cod);
		while (s.cod <> 0) do begin
			read(s.cantidad);
			write(v[i], s);
			writeln('Ingrese cod y cantidad vendida. COD 0 para terminar el detalle');
			read(s.cod);
		end;
	end;
	writeln('Archivos detalle guardados!');
	for i:= 1 to DF do begin
		close(v[i]);
	end;
end;
procedure crearMaestro(var mae: maestro);
var
	p: producto;
	name: string;
begin
	write('Inserte nombre para el archivo binario MAESTRO: '); 
	readln(name);
	assign(mae, name);
	rewrite(mae);
	writeln('Ingrese cod. COD 0 para terminar el detalle');
	read(p.cod);
	while (p.cod <> 0) do begin
		writeln('stock: ');
		readln(p.stock);
		writeln('stock min: '); 
		readln(p.stock_min);
		writeln('precio: '); 
		readln(p.precio);
		writeln('desc: '); 
		readln(p.desc);
		writeln('nombre: '); 
		readln(p.nombre);
		write(mae, p);
		writeln('Ingrese cod. COD 0 para terminar el detalle');
		read(p.cod);
	end;
end;
//PREGUNTAR COMENTARIO ENTRE LLAVES
Procedure buscoMinimo(var v: vecMIn; var min: sucursales; vec: vecDetalles);
var
	i, pos: integer;
	reg: sucursales;
begin
	pos:=0;
	min.cod:=valoralto;
	for i:= 1 to DF do begin
		if (v[i].cod < min.cod) then begin
			min:= v[i];
			pos:= i;
		end;
	end;
	if (min.cod <> valoralto) then begin
		leer(vec[pos], reg);
		v[pos] := reg; 
	end;
end;
Procedure actualizarMaestro (var mae: maestro; var vec: vecDetalles; var minimos: vecMin);
var
	datos: producto;
	reg: sucursales;
	i, total, cod_actual: integer;
begin
	reset(mae);
	for i:= 1 to DF do  begin
		reset(vec[i]);
		leer(vec[i], reg);
		minimos[i] := reg;
	end;
	writeln('LLego 1');
	buscoMinimo(minimos, reg, vec);
	while (reg.cod <> valorAlto) do begin
		total := 0;
		cod_actual := reg.cod;
		writeln('COD ACTUAL: ',cod_actual);
		while (cod_actual = reg.cod) do begin
			total:= total + reg.cantidad;
			writeln('TOTAL: ',total);
			buscoMinimo(minimos, reg, vec);
			writeln('COD MIN: ',reg.cod);
		end;
		read(mae, datos);
		writeln('Primer cod mae: ', datos.cod, ' actual: ',cod_actual);
		while (cod_actual <> datos.cod) do begin
			read(mae, datos);
			writeln('Primer cod mae: ', datos.cod, ' actual: ',cod_actual);
		end;
		seek(mae, filepos(mae)-1);
		datos.stock:= datos.stock - total;
		write(mae, datos);
		seek(mae, filepos(mae)-1);
		leerM(mae, datos);
	end;
	
	writeln('Archivo maestro actualizado!');
	close(mae);
	for i:= 1 to DF do 
		close(vec[i]);
end;
Procedure verStock (var mae:maestro; var txt: text);
var
	name: string;
	datos:producto;
begin
	write('Ingrese nombre para el archivo TXT: ');
	read(name);
	assign(txt, name);
	rewrite(txt);
	reset(mae);
	leerM(mae, datos);
	while (datos.cod <> 9999) do begin
		writeln('CODIGO: ',datos.cod);
		writeln('STOCK ACT: ', datos.stock);
		writeln('STOCK MIN: ',datos.stock_min);
		if (datos.stock < datos.stock_min) then begin
			writeln (txt, datos.nombre);
			writeln(txt, datos.desc);
			writeln(txt, datos.stock, datos.precio);
		end;
		leerM(mae, datos);
	end;
	writeln('Archivo TXT con los stock creado!');
	close(mae);
	close(txt);
end;
Procedure menu();
var
	mae: maestro;
	vecD : vecDetalles;
	v: vecMin;
	texto: text;
	opt: integer;
begin
	writeln('Elija una opcion');
	writeln('1. Crear detalles');
	writeln('2. Crear maestro');
	writeln('3. actualizar el stock del maestro');
	writeln('4. crear un TXT del stock actual menor al minimo');
	writeln('5. Salir');
	readln(opt);
	assign(mae,'maestroPcuatro');
	assign(vecD[1],'detalle1');
	assign(vecD[2],'detalle2');
	assign(vecD[3],'detalle3');
	while (opt <> 5) do begin
		case opt of
			1: 
				crearDetalles(vecD);
			2:
				crearMaestro(mae);
			3:
				actualizarMaestro(mae, vecD, v);
			4:
				verStock(mae, texto);
			5:
				writeln('Saliendo del programa');
			else
				writeln('Opcion no valida');
			end;
		writeln('Elija una opcion');
		writeln('1. Crear maestro y detalles');
		writeln('2. Crear maestro');
		writeln('3. actualizar el stock del maestro');
		writeln('4. crear un TXT del stock actual menor al minimo');
		writeln('5. Salir');
		readln(opt);
	end;
end;
Begin
	menu();
End.
