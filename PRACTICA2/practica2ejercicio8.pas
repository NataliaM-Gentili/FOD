
//pedir correccion actualizar maestro
//TIRA ERROR ACTUALIZAR MAESTRO

{Se quiere optimizar la gestión del consumo de yerba mate en distintas provincias de
Argentina. Para ello, se cuenta con un archivo maestro que contiene la siguiente
información: código de provincia, nombre de la provincia, cantidad de habitantes y cantidad
total de kilos de yerba consumidos históricamente.
Cada mes, se reciben 16 archivos de relevamiento con información sobre el consumo de
yerba en los distintos puntos del país. Cada archivo contiene: código de provincia y cantidad
de kilos de yerba consumidos en ese relevamiento. Un archivo de relevamiento puede
contener información de una o varias provincias, y una misma provincia puede aparecer
cero, una o más veces en distintos archivos de relevamiento.
Tanto el archivo maestro como los archivos de relevamiento están ordenados por código de
provincia.
Se desea realizar un programa que actualice el archivo maestro en base a la nueva
información de consumo de yerba. Además, se debe informar en pantalla aquellas
provincias (código y nombre) donde la cantidad total de yerba consumida supere los 10.000
kilos históricamente, junto con el promedio consumido de yerba por habitante. Es importante
tener en cuenta tanto las provincias actualizadas como las que no fueron actualizadas.
Nota: cada archivo debe recorrerse una única vez.}

Program tp2e8;
Const
	valorAlto = 999999;
	DF = 16;
Type

	provincias = record
		cod: LongInt;
		nombre: String;
		habitantes: LongInt;
		kilos: real;
	end;
	
	relevamiento = record
		cod: LongInt;
		kilos: real;
	end;
	
	maestro = file of provincias;
	detalle = file of relevamiento;
		
	vecDetalles = array [1..DF] of detalle;
	vecMinimos = array [1..DF] of relevamiento;

Procedure crearDetalles (var vec: vecDetalles; var datosLimpios: text);
var
	i: integer;
	name, num: String;
	reg: relevamiento;
begin
	assign(datosLimpios,'Detalles.txt');
	rewrite(datosLimpios);
	for i:= 1 to DF do begin
		Str(i, num);
		name := 'detalle' + num;
		writeln(datosLimpios, name);
		assign(vec[i], name);
		rewrite(vec[i]);
		writeln();
		writeln('CREANDO EL DETALLE ',i,'---------------------------------\n');
		writeln('Ingrese codigo de provincia, finalice con "-1": ');
		readln(reg.cod);
		while (reg.cod <> -1) do begin
			writeln('Ingrese kilos de yerba mate consumidos: ');
			readln(reg.kilos);
			write(vec[i], reg);
			writeln(datosLimpios,' PROVINCIA: ',reg.cod,' KILOS RELEVADOS: ',reg.kilos:0:2);
			writeln();
			writeln('Ingrese codigo de provincia, finalice con "-1": ');
			readln(reg.cod);	
		end;
	end;
	writeln('DETALLES CREADOS');
	close(datosLimpios);
	for i:= 1 to DF do
		close(vec[i]);
end;
Procedure crearMaestro(var mae: maestro; var datosLimpios:text);
var
	reg: provincias;

begin
	assign(mae, 'maestroPocho');
	rewrite(mae);
	assign(datosLimpios,'maestroOchoTxt.txt');
	rewrite(datosLimpios);

	writeln();
	writeln('CREANDO EL MAESTRO ---------------------------------\n');
	writeln('Ingrese codigo de provincia, finalice con "-1": ');
	readln(reg.cod);
	while (reg.cod <> -1) do begin
		writeln('Ingrese cantidad de habitantes: ');
		readln(reg.habitantes);
		writeln('Ingrese la cantidad de kilos de yerba consumidos historicamente');
		readln(reg.kilos);
		writeln('Ingrese nombre de la provincia');
		readln(reg.nombre);
		write(mae, reg);
		writeln(datosLimpios,'PROVINCIA: ',reg.cod,' ',reg.nombre);
		writeln(datosLimpios,'CANTIDAD DE HABITANTES: ',reg.habitantes,' KILOS TOTALES: ',reg.kilos:0:2);
		writeln();
		writeln('Ingrese codigo de provincia, finalice con "-1": ');
		readln(reg.cod);	
	end;
	
	writeln('ARCHIVO MAESTRO CREADO');
	close(mae);
	close(datosLimpios);
end;
Procedure leerDetalle(var det:detalle; var reg: relevamiento);
begin
	if (not eof(det)) then
		read(det, reg)
	else
		reg.cod := valorAlto;
end;
Procedure leerM (var mae: maestro; var reg:provincias);
begin
	if (not eof (mae)) then
		read(mae, reg)
	else
		reg.cod := valorAlto;
end;


Procedure minimos (var vec:vecDetalles; var vecM: vecMinimos; var min: relevamiento);
var
	i, pos: integer;
	reg: relevamiento;
begin
	pos:= 0;
	min.cod := valorAlto;
	
	for i:= 1 to DF do begin
		if (vecM[i].cod < min.cod) then begin
			min := vecM[i];
			pos:= i;
		end;
	end;
	if (min.cod <> valorAlto) then begin
		leerDetalle(vec[pos], reg);
		vecM[pos]:= reg;
	end;
end;

Procedure actualizarMaestro (var mae: maestro; var vec: vecDetalles; var vecM: vecMinimos);
var
	regD: relevamiento;
	cod_actual: LongInt;
	totalYerba, prom: real;
	regM: provincias;
	i: integer;
begin
	reset(mae);
	for i:= 1 to DF do begin
		reset(vec[i]);
		leerDetalle(vec[i], regD);
		vecM[i] := regD;
	end;
	
	leerM(mae, regM);
	while (regM.cod <> valorAlto) do begin
		cod_actual := regM.cod;
		totalYerba:= 0;
		
		minimos(vec, vecM, regD);
		while (cod_actual = regD.cod) do begin
			totalYerba:= totalYerba + regD.kilos;
			minimos(vec, vecM, regD);
		end;
		regM.kilos := regM.kilos + totalYerba;
		if (regM.kilos > 10000) then begin
			writeln();
			writeln('LA PROVINCIA: ',regM.nombre,' CODIGO: ',regM.cod,' TIENE UN CONSUMO HISTORICO MAYOR A 10000 KG DE YERBA MATE');
			prom := regM.kilos / regM.habitantes;
			writeln('EL PROMEDIO POR HABITANTE ES DE: ',prom:0:4);
		end; 
		seek(mae, filepos(mae)-1);
		write(mae, regM);
		leerM(mae, regM);
	end;
	writeln('ARCHIVO MAESTRO ACTUALIZADO!');
	close(mae);
	for i:= 1 to DF do 
		close(vec[i]);
end;

Procedure imprimirMaestro(var mae: maestro);
var
	reg: provincias;
begin
	reset(mae);
	leerM(mae, reg);
	while (reg.cod <> valorAlto) do begin
		writeln('PROVINCIA: ',reg.cod,' ',reg.nombre);
		writeln('HABITANTES: ',reg.habitantes);
		writeln('KG CONSUMIDOS: ',reg.kilos:0:2);
		leerM(mae, reg);
	end;
	close(mae);
end;

Procedure menu();
var
	mae: maestro;
	i, opt: integer;
	maeTxt, detTxt: text;
	vec: vecDetalles;
	vecMin: vecMinimos;

	name, num: String;
begin

	assign(mae, 'maestroPocho');
	for i:= 1 to DF do begin
		Str(i, num);
		name := 'detalle' + num;
		assign(vec[i], name);
	end;
	writeln('MENU DE OPCIONES');
	writeln('1. CREAR DETALLES');
	writeln('2. CREAR MAESTRO');
	writeln('3. IMPRIMIR MAESTRO');
	writeln('4. ACTUALIZAR MAESTRO');
	writeln('5. SALIR');
	readln(opt);
	while (opt <> 5) do begin
		case (opt) of 
			1: 
				crearDetalles(vec, detTxt);
			2:
				crearMaestro(mae, maeTxt);
			3: 
				imprimirMaestro(mae);
			4:
				actualizarMaestro(mae, vec, vecMin);
			5:
				writeln('Saliendo del programa...');
			else
				writeln('Seleccione una opcion valida');
			end;
		writeln('MENU DE OPCIONES');
		writeln('1. CREAR DETALLES');
		writeln('2. CREAR MAESTRO');
		writeln('3. IMPRIMIR MAESTRO');
		writeln('4. ACTUALIZAR MAESTRO');
		writeln('5. SALIR');
		readln(opt);	
	end;
end;
Begin
	menu();
End.
