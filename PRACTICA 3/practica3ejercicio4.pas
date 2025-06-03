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
	end;
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
	
