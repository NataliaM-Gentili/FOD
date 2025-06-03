//Con lista se refiere a listado (archivo TXT)
//pedir correccion del recorrido
//es correcto el procedure minimos?
{14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.}
Program tp2e14;
Const
	valorAlto
Type
	vuelos = record
		destino: String;
		fecha: String;
		hora: String;
		asientos: integer;
	end;
	
	unVuelo = record
		destino: String;
		fecha: String;
		salida: real;
		comprados: integer;
	end;
		
	maestro = file of vuelos;
	detalle = file of unVuelo;
	
Procedure leer (var det: detalle; var reg: unVuelo);
begin
		if (not(eof(det))) then
			read(det, reg)
		else
			reg.destino = 'ZZFIN';
end;

Procedure minimo(var det1, det2: detalle; var minimo: unVuelo);
var
	reg1,reg2: unVuelo;
begin
	leer(det1, reg1);
	leer(det2, reg2);
	if (reg1.destino > reg2.destino) then minimo:= reg1
	else minimo:= reg2;
end;

Procedure guardarListado (var t: text; var reg: vuelos);
begin
	if (regMaestro.asientos < cantidadDisponibles) then begin
		writeln(txt,' DESTINO: regMaestro.destino);
		writeln(txt,' FECHA: ', regMaestro.fecha);
		writeln(txt,' HORA: ', regMaestro.hora);
	end;
end;

Procedure actualizarMaestro (var mae: maestro; var det1,det2: detalle; var txt: text);
var
	min: unVuelo;
	regMaestro: vuelos;
	destino_act, fecha_act: String;
	total, cantidadDisponibles: integer;
	hora_act: real;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	assign(txt, 'listado');
	rewrite(txt);
	
	writeln('Elija la cantidad de asientos disponibles que se debe cumplir');
	readln(cantidadDisponibles);
	
	minimo(det1, det2, min);
	while (min.destino <> 'ZZFIN') do begin
		destino_act := min.destino;
		
		while (destino_act = min.destino) do begin
			fecha_act := min.fecha;
			
			while (fecha_act = min.fecha) and (destino_act = min.destino) do begin
				hora_act:= min.hora;
				total:= 0;
				
				while (fecha_act = min.fecha) and (destino_act = min.destino) and (hora_act = min.hora) do begin
					total:= total + min.comprados;
					minimo(det1, det2, min);
				end;
				read(mae, regMaestro);
				while (regMaestro.destino <> destino_act) do begin
					guardarListado(txt, regMaestro);
					read(mae, regMaestro);
				end;
				regMaestro.asientos:= regMaestro.asientos - total;
				if (regMaestro.asientos < cantidadDisponibles) then guardarListado(txt, regMaestro);
				seek(mae, filepos(mae)-1);
				write(mae, regMaestro);
			end;
		end;
	end;
	writeln('ARCHIVO MAESTRO ACTUALIZADO!');
	close(mae);
	close(det1);
	close(det2);
end;

Procedure menu();
Var
	mae: maestro;
	det1, det2: detalle;
	L: lista;
Begin
	writeln('MENU DE OPCIONES');
	writeln('1. actualizar maestro');
	writeln('2. ver los vuelos con una cantidad menor a X de asientos disponibles');
	writeln('3. salir del programa');
	readln(opt);
	
	while (opt <> 3) do begin
		case (opt) of
			1: 
				actualizarMaestro(mae, det1, det2, L);
			2:
				//imprimirLista(L);
			3:
				writeln('Saliendo... Nos vemos!');
			else:
				writeln('Por favor, seleccione una opcion valida');
			end;
			writeln('MENU DE OPCIONES');
		writeln('1. actualizar maestro');
		writeln('2. ver los vuelos con una cantidad menor a X de asientos disponibles');
		writeln('3. salir del programa');
		readln(opt);
	end;
end;
Begin
	menu();
End.
			
