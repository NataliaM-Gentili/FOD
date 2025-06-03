//ver PP, no funciona la asignacion al texto de novelas
Program p1e7;
Type
	novelas = record
		cod: integer;
		nombre: string;
		genero: string;
		precio: real;
	end;
	
	file_record = file of novelas;


Procedure leer(var Fw: file_record; var reg: novelas; var ok: boolean);
begin
	if (not eof(Fw)) then begin
		ok:= false;
		read(Fw, reg);
	end
	else ok:= true;
end;
Procedure imprimir (var Fw: file_record);
var
	reg: novelas;
	okey:boolean;
begin	
	reset(Fw);
	leer(Fw, reg, okey);
	while (not okey) do begin
		with reg do begin
			writeln('CODIGO: ',cod);
			writeln('NOMBRE: ',nombre);
			writeln('GENERO: ',genero);
			writeln('PRECIO: ',precio:0:2);
		end;
		leer(Fw, reg, okey);
	end;
	close(Fw);
end;
Procedure leerDatos(var reg:novelas);
begin
	writeln('NOMBRE: ');
	readln(reg.nombre);
	writeln('GENERO: ');
	readln(reg.genero);
	writeln('PRECIO: ');
	readln(reg.precio); 
end;

{Procedure crearArchivoTexto (var carga: text);
var
	reg:novelas;
begin
	assign (carga, 'novelas.txt');
	rewrite(carga);
	writeln('INGRESE CODIGO, FINALICE CON 0:  ');
	readln(reg.cod);
	while (reg.cod <> 0) do begin	
		leerDatos(reg);
		with reg do begin
			write(carga, cod, precio, genero);
			write(carga, nombre);
		end;
		writeln('INGRESE CODIGO, FINALICE CON 0:  ');
		readln(reg.cod);
	end;
	writeln('Archivo de tipo TXT creado!');
	close(carga);
end;}
Procedure crearArchivoBinario(var Fw: file_record; var carga: text);
var
	reg:novelas;
	nomb: string;
begin
	writeln('Ingrese nombre para el archivo binario');
	readln(nomb);
	assign (Fw, nomb);
	rewrite(Fw);
	reset(carga);
	while (not eof(carga)) do begin	
		with reg do begin
			readln(carga, cod, precio, genero);
			readln(carga, nombre);
			write(Fw, reg);
		end;
		
	end;
	writeln('Archivo de tipo BINARIO creado!');
	close(carga);
	close(Fw);
end;
Procedure agregarNovela(var Fw: file_record);
var
	reg: novelas;
begin
	reset(Fw);
	writeln('CODIGO: ');
	readln(reg.cod);
	seek(Fw, fileSize(Fw));
	while (reg.cod <> 0) do begin
		leerDatos(reg);
		write(Fw, reg);
		writeln('CODIGO: ');
		readln(reg.cod);
	end;
	close(Fw);
end;
Procedure modificarNovela(var Fw: file_record);
var
	codn:integer;
	encontre: boolean;
	reg: novelas;
begin
	reset(Fw);
	encontre:= false;
	writeln('Ingrese codigo de la novela a modificar: ');
	readln(codn);
	while ((not eof(Fw) and (not encontre))) do begin
		read(Fw, reg);
		if (reg.cod = codn) then begin
			writeln('Novela encontrada!');
			leerDatos(reg);
			seek(Fw, filePos(Fw)-1);
			write(Fw, reg);
			encontre:= true;
		end;
	end;
	close(Fw);
	if (not encontre) then 
		writeln('Novela no encontrada!');
end;
VAR
	F_binario: file_record;
	F_texto: text;
	opt:integer;
	listo: boolean;
BEGIN
	listo:= false;
	assign(F_texto, 'novelas - copia.txt');
	while (not listo) do begin

		writeln('1. Crear archivo binario basado en el texto');
		writeln('2. Imprimir datos actuales');
		writeln('3. Agregar novela');
		writeln('4. Modificar novela existente');
		
		readln(opt);
		case opt of
			1:
				{crearArchivoTexto(F_texto);}
				crearArchivoBinario(F_binario, F_texto);
			2: 
				imprimir(F_binario);
			3:
				agregarNovela(F_binario);
			4:
				modificarNovela(F_binario);
			else
				writeln('NO VALIDO');
		end;
		writeln('Desea hacer algo mas?');
		writeln('1. SI // 2. NO');
		readln(opt);
		if (opt = 2) then listo:= true; 
	end;
end.
	
