program p1e2;
type
	archivo_numeros = file of integer;
var
	num_actual, cant: integer;
	promedio: real;
	nombre_logico: archivo_numeros;
	nombre_fisico: string;
begin
	cant:= 0;
	promedio:= 0;
	
	writeln('Ingrese el nombre del archivo a procesar: ');
	readln(nombre_fisico);
	assign(nombre_logico, nombre_fisico);
	reset(nombre_logico);
	
	while (NOT(EOF(nombre_logico))) do begin
		read(nombre_logico, num_actual);
		writeln(num_actual);
		if (num_actual < 1500) then begin
			cant:= cant + 1;
			promedio:= promedio + num_actual;
		end;
	end;
	promedio := promedio / fileSize(nombre_logico);
	writeln('La cantiad de numeros menos a 1500 es ', cant);
	writeln('El promedio fue de ',promedio);
	
	close(nombre_fisico);
	close(nombre_logico);
end. 
