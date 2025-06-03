{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

Program tp3e2;
Const
	valorAlto = 999999;
Type
	asistente = record
		nro: LongInt;
		nombre: String;
		email: String;
		telefono: LongInt;
		DNI: LongInt;
	end;
	archivo = file of asistente;
	
Procedure crearArchivo(var arc: archivo);
var
	a:asistente;
begin
	assign(arc, 'asistentes');
	rewrite(arc);
	
	writeln('Ingrese nro, finalice con 999999');
	readln(a.nro);
	while (a.nro <> valorAlto) do begin
		writeln('nombre completo');
		readln(a.nombre);
		writeln('email');
		readln(a.email);
		writeln('telefono');
		readln(a.telefono);
		writeln('DNI');
		readln(a.DNI);
		write(arc, a);
		writeln('Ingrese nro, finalice con 999999');
		readln(a.nro);
	end;
	
	close(arc);
end;
procedure imprimirAsistente(a: asistente);
begin
    writeln('Numero=', a.nro, ' Nombre=', a.nombre, ' DNI=', a.DNI);
end;
Procedure leerArchivo (var arc: archivo; var a:asistente);
begin
	if (not eof(arc)) then
		read(arc, a)
	else
		a.nro := valorAlto;
end;
procedure imprimirArchivo(var arc: archivo);
var
    a: asistente;
begin
    reset(arc);
    leerArchivo(arc, a);
    while(a.nro <> valorAlto) do begin
		imprimirAsistente(a);
		leerArchivo(arc, a);
    end;
    close(arc);
end;
procedure bajaLogica (var arc: archivo);
var
	a: asistente;
begin
	reset(arc);
	leerArchivo(arc,a);
	while (a.nro <> valorAlto) do begin
		if (a.DNI < 1000) then begin
			a.nombre := '@' + a.nombre;
			seek(arc, filepos(arc)-1);
			write(arc, a);
		end;
	end;
	close(arc);
end;
var
	arc: archivo;
begin
	//crearArchivo(arc);
	assign(arc, 'asistentes');
	writeln('Archivo original:');
    imprimirArchivo(arc);
    bajaLogica(arc);
    writeln('Archivo baja logica:');
    imprimirArchivo(arc);
end.
	
	
		
