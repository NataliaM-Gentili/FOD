Program practica3ejercicio8;
Const
	valorAlto = 'ZZZ';
Type
	distribuciones = record
		anio: integer;
		nombre: String;
		nro: LongInt;
		desarrolladores: integer;
		desc: String;
	end;
	
	archivo = file of distribuciones;
	
procedure leerArchivo(var a: archivo; var reg: distribuciones);
begin
	if (not eof(a)) then
		read(a, reg)
	else
		a.nombre := valorAlto;
end;
procedure buscarDistribucion (var a: archivo; nom: String; var pos: integer);
var
	reg: distribuciones;
	
begin
	reset(a);
	pos := -1;
	
	leerArchivo(a, reg);
	while ((reg.nombre <> valorAlto) and (reg.nombre <> nom)) do 
		leerArchivo(a, reg);
	if (reg.nombre = nom) then begin
		pos := filepos(a) - 1;
	else
		writeln('Esa distribucion no existe!');
	close(a);
end;
procedure altaDistribucion (var a: archivo; nue: distribuciones);
var
	cabecera, reg: distribuciones;
	pos: integer;
begin
	// este modulo ya abre el archivo, deberia abrirlo despues?
	buscarDistribucion(a, nue.nombre, pos);
	if (pos <> -1) then begin
		reset(a);
		read(a, cabecera);
		if (cabecera.desarrolladores = 0) then begin
			seek(a, filesize(a));
			write(a, nue);
		end
		else begin
			seek(a, cabecera.desarrolladores * -1);
			read(a, cabecera);
			seek(a, filepos(a)-1);
			write(a, nue);
			seek(a, 0);
			write(a, cabecera);
		end;
		writeln('Distribucion agregada!')
	else
		writeln('Esta distribucion ya existe!');
	close(a);
end;
procedure bajaDistribucion(var a: archivo; nom: String);
var
	reg, cabecera: distribuciones;
	pos: integer;
begin

	buscarDistribucion(a, nom, pos);
	
	if (pos <> -1) then begin
		reset(a);
		read(a, cabecera);
		seek(a, pos);
		read(a, reg);
		seek(a, filepos(a)-1);
		write(a, cabecera);
		reg.desarrolladores := pos * -1;
		seek(a, 0);
		write(a, reg);
		close(a);
	end
	else
		writeln('La distribucion que se desea eliminar NO existe!');
end;
var
begin
{pp}
end.
	
		
	
	
