Program parcial;
Const
	valorAlto = 9999;
Type
	profesional = record
		DNI: integer;
		nombre: String[20];
		apellido: String[20];
		sueldo: real;
	end;
	
	tArchivo = file of profesional;
	
procedure crearMaestr (var arc: tArchivo; var info: text);
var
	reg: profesional;
begin
	rewrite(arc);
	reset(info);
	reg.DNI = 0;
	
	write(arc, reg);
	while (not eof(info)) do begin
		readln(info, reg.DNI, reg.nombre);
		readln(info, reg.sueldo, reg.apellido);
		write(arc, reg);
	end;
	
	close(arc);
	close(info);
end;

procedure agregar (var arc: tArchivo; p: profesional);
var
	cabecera, reg: profesional;
begin
	reset(arc);
	read(arc, cabecera);
	if (cabecera.DNI <> 0) then begin
		seek(arc, cabecera.DNI * -1);
		read(arc, reg);
		seek(arc, filepos(arc)-1);
		write(arc, p);
		seek(arc, 0);
		write(arc, reg);
	end
	else begin
		seek(arc, filezise(arc));
		write(arc, p);
	end;
	close(arc);
end;

procedure leerMaestro (var arc: tArchivo; var reg: profesional);
begin
	if (not eof(arc)) then
		read(arc, reg);
	else
		reg.DNI = valorAlto;
end;

procedure eliminar (var arc: tArchivo; DNI: integer; var bajas: text);
var
	reg, cabecera: profesional;
begin
	reset(arc);
	read(arc, cabecera);
	leerMaestro(arc, reg);
	
	while ((reg.DNI <> valorAlto) and (reg.DNI <> DNI)) do 
		leerMaestro(arc, reg);
		
	if (reg.DNI = DNI) then begin
		reset(bajas);
		writeln(bajas, reg.DNI, reg.nombre);
		writeln(bajas, reg.sueldo, reg.apellido);
		close(bajas);
		reg.DNI := filepos(arc) -1 * -1;
		seek(arc, filepos(arc)-1);
		write(arc, cabecera);
		seek(arc, 0);
		write(arc, reg);
	end
	else
		writeln('El empleado no existe!');
	
	close(arc);
end;
