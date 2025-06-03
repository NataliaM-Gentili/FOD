{4. Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
{Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}

{5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
{Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);}

Program practica2ejercicio4;
Const
	valorAlto = 99999;
Type
	reg_flor = record
		nombre: String[45];
		codigo: integer;
	end;
	
	tArchFlores = file of reg_flor;
	
Procedure agregarFlor (var a: tArchFlores; nombre: String; codigo: integer);
var
	cabecera, reg, aux: reg_flor;
	cod_aux: integer;
begin
	reset(a);
	read(a, cabecera);
	reg.codigo := codigo;
	reg.nombre := nombre;
	
	if (cabecera.codigo = 0) then begin
		seek(a, filesize(a));
		write(a, reg);
	end
	else begin
		seek(a, cabecera.cod * -1);
		read(a, cabecera);
		seek(a, filepos(a)-1);
		write(a, reg);
		seek(a, 0);
		write(a, cabecera);
	end;
	close(a);Ss
end;

Procedure leerArchivo (var a: tArchFlores; var reg: reg_flores);
begin
	if (not eof(a)) then
		read(a, reg)
	else
		reg.codigo := valorAlto;
end;
Procedure listarContenido (var a: tArchFlores; var txt: text);
var
	reg: reg_flor;
begin
	reset(a);
	assign(txt, 'listado.txt');
	rewrite(txt);
	
	read(a, reg); //cabecera
	
	leerArchivo(a, reg);
	while (reg.codigo <> valorAlto) do begin
		if (reg.codigo > 0) then
				write(txt, 'CODIGO: ', reg.codigo,' | NOMBRE: ',reg.nombre);
		leerArchivo(a, reg);
	end;
	close(a);
	close(txt);
end;
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var
	reg, cabecera: reg_flor;
begin
	reset(a);
	read(a, cabecera);
	
	leerArchivo(a, reg);
	while ((reg.codigo <> valorAlto) and (reg.codigo <> flor.codigo)) do 
		leerArchivo(a, reg);
	if (reg.codigo = flor.codigo) then begin
		writeln('Flor encontrada!');
		writeln('Ejecutando proceso de eliminacion...');
		seek(a, filepos(a) - 1);
		pos := filepos(a) * -1;
		write(a, cabecera);
		seek(a, 0);
		reg.codigo := pos;
		write(a, reg);
	end
	else
		writeln('NO se encontro la flor!');
	close(a);
end;
Var
	a: tArchFlores;
	t: text:
Begin
	agregarFlor(a, 'Rosa', 12345);
	writeln('Exportando archivo.txt con el contenido actual...');
	listarContenido(a, t);
	writeln('FIN');
end.
	
