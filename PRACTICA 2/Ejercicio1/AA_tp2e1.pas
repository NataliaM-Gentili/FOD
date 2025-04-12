//inciso imprimirMaestro preguntar si es correcto utilizar el proceso Leer
//preguntar si es correcto usar dos archivos binarios

{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}
Program tp2e1;
Type
	ingresos = record
		cod : integer;
		nombre : string;
		monto : real;
	end;

archivo = file of ingresos;

Procedure leer (var arc: archivo; var reg: ingresos);
begin
	if (not(eof(arc))) then
		read(arc, reg)
	else
		dato.codigo := 9999;
end;

//creo un archivo con los datos en limpio
Procedure crearArchivo (var arc: archivo; var carga: text);
var
	name : string;
	datos : ingresos;
begin
	writeln;
	writeln('--------------- CREO ARCHIVO --------------'
	writeln;
	reset (carga);
	write('Ingrese nombre para el archivo: ');
	read(name);
	assign(arc, name);
	rewrite(arc);
	while (not(eof(carga))) do begin
		with ingresos do begin
			readln(carga, cod, monto, nombre);
			write(arc, ingresos);
		end;
	end;
	writeln('Archivo binario creado');
	close(arc);
	close(carga);
end;

Procedure crearMaestro(var arc: archivo; var mae: archivo);
var
	name: string;
	datos: ingresos;
	monto_total : real;
	aux_code : integer;
begin
	writeln;
	writeln('--------------- CREO MAESTRO --------------'
	writeln;
	reset(arc);
	write('Ingrese nombre para el archivo compacto: ');
	read(name);
	assign(mae, name);
	rewrite(mae);
	
	leer(arc, datos);
	while (datos.cod <> 9999) do begin
		aux_code := ingresos.cod;
		monto_total := 0;
		while (aux_code = datos.cod) do begin
			monto_total := monto_total + datos.monto;
			leer(arc, ingresos);
		end;
		writeln(mae, datos.cod, datos.monto_total, datos.nombre);
	end;
	writeln('Archivo compacto creado! ');
	close(arc);
	close(mae);
end;
	
Procedure imprimirMaestro (var mae: archivo);
var	
	emp: ingresos;
begin
	writeln;
	writeln('--------------- IMPRIMO MAESTRO --------------'
	writeln;
	reset(mae);
	leer(mae, emp)
	while (emp.cod <> 9999) do begin
		with emp do 
			writeln('Codigo: ',cod,', monto total: ',monto,', nombre: ',nombre);
		leer(mae, emp);
	end;
	close(mae);
end;
var
	arc, maestro : archivo;
	texto: text;
	
begin
	assign(texto, 'empleados.txt');
	crearArchivo(arc, texto);
	crearMaestro(arc, maestro);
	imprimirMaestro(mae);
	writeln('Fin');
end.
	
