program p1e3; 
type
	empleado = record
		nro: integer;
		apellido: String;
		nombre: String;
		edad: integer;
		DNI: integer;
	end;
	file_record = file of empleado;
	
	
//////////// MODULO A ////////////////////
Procedure leerDatos (var Fw: empleado);
begin
	writeln('Ingrese el nombre: ');
	readln(Fw.nombre);
	writeln('Ingrese el nro de empleado: ');
	readln(Fw.nro);
	writeln('Ingrese la edad: ');
	readln(Fw.edad);
	writeln('Ingrese las DNI: ');
	readln(Fw.DNI);
end;
Procedure CrearArchivo (var Fw: file_record);
var
	nombre_fisico: String;
	ar: empleado;
begin
	writeln('Ingrese el nombre del archivo');
	readln(nombre_fisico);
	assign(Fw, nombre_fisico);
	rewrite (Fw);
	
	
	writeln('INGRESE FIN PARA FINALIZAR ');
	writeln('Ingrese el apellido del empleado: ');
	readln(ar.apellido);
	while (ar.apellido <> 'fin') do begin
		leerDatos(ar);
		write(Fw, ar);
		writeln('Ingrese el apellido del empleado: ');
		readln(ar.apellido);
	end;
	close(Fw);
end;


/////////////// MODULO B PARTE 1 ////////////////////
Procedure ImprimirEmpleado (reg: empleado);
begin
	writeln('Nombre: ',reg.nombre);
	writeln('Apellido: ',reg.apellido);
	writeln('Nro de empleado: ',reg.nro);
	writeln('Edad: ',reg.edad);
	writeln('DNI: ',reg.DNI);
	writeln;
	writeln;
end;

Procedure leer (var Fw: file_record; var dato:empleado; var ok:boolean);
begin
	ok:= false;
	if (not EOF(Fw)) then 
		read(Fw, dato)
	else ok:= true;
end;
Procedure Buscar (var Fw: file_record);
var
	name, surname: String;
	reg: empleado;
	okey: boolean;
	option:integer;
begin
	reset(Fw);
	okey:= false;
	writeln('SELECCIONE "1" PARA BUSCAR POR NOMBRE, Y "2" PARA SELECCIONAR POR APELLIDO');
	readln(option);
	if (option = 1)then begin
		writeln('Ingrese nombre del empleado que desea buscar: ');
		readln(name);
		leer(Fw, reg, okey);
		while (not okey) do begin
			if (reg.nombre = name) then
				ImprimirEmpleado(reg);
			leer(Fw, reg, okey);
		end;
	end
	else begin
		writeln('Ingrese el apellido del empleado que desea buscar: ');
		readln(surname);
		leer(Fw, reg, okey);
		while (not okey) do begin
			if (surname = reg.apellido) then 
				ImprimirEmpleado(reg);
			leer(Fw, reg, okey);
		end;
	end;
	if not okey then
		writeln('No hay coincidencias :(');
	close(Fw);
end;
	
///////////////// MODULO B PARTE II ///////////////////		


Procedure ListarEmpleados (var Fw: file_record);
var
	reg: empleado;
	okey:boolean;
begin
	okey:= false;
	reset(Fw);
	read(Fw, reg);
	while (not okey) do begin
		ImprimirEmpleado(reg);
		leer(Fw, reg, okey);
	end;
	close(Fw);
end;	

/////////////////////// MODULO B PARTE III //////////////////
Procedure EmpleadosMayores (var Fw: file_record);
var
	reg: empleado;
	okey:boolean;
begin
	okey:= false;
	reset(Fw);
	read(Fw, reg);
	while (not okey) do begin
		if (reg.edad > 70) then 
			ImprimirEmpleado(reg);
		leer(Fw, reg, okey);
	end;
	close(Fw);
end;
///////////////////// PROGRAMA PRINCIPAL /////////////////
Var
		File_Workers: file_record;
		option, num:integer;
		termine:boolean;
Begin
	termine:= false;
	writeln('Bienvenido al programa! Qué deseas hacer? Por favor, elige una opcion :) ');
	while (not termine) do begin
		writeln('1. Crear un archivo de registro de empleados');
		writeln('2. Buscar empleado por nombre o apellido');
		writeln('3. Ver todos los empleados');
		writeln('4. Ver los empleados mayores de 70');
		readln(option);
		writeln;
	
		case option of
			1: 
				CrearArchivo(File_Workers);
			2: 
				Buscar(File_Workers);
			3: 
				ListarEmpleados(File_Workers);
			4:
				EmpleadosMayores(File_Workers);
			else
				writeln('Por favor, mire bien el numero que elije');
		end;
		writeln('Desea realizar otra operacion?');
		writeln('1. Si / 2. No');
		readln(num);
		if (num = 2) then termine := true;
		writeln;
		writeln;
		writeln('//////////////////////////////////////////////');
		writeln;
		writeln;
	end;
	writeln;
	writeln;
	writeln('GRACIAS POR SU VISITA :D ');
end.
