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
	else 
		if (option = 2) then begin
		writeln('Ingrese el apellido del empleado que desea buscar: ');
		readln(surname);
		leer(Fw, reg, okey);
		while (not okey) do begin
			if (surname = reg.apellido) then 
				ImprimirEmpleado(reg);
			leer(Fw, reg, okey);
		end
		else
			writeln('Opcion no valida');
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
/////////////////////// P 4 MODULO A ////////////////////
Procedure AgregarEmpleados (var Fw: file_record);
var
	reg, nuevo:empleado;
	num: integer;
	okey, encontre: boolean;
begin
	reset(Fw);
	okey:= false; encontre := false;
	//writeln'('Ingrese numero de empleado'); readln(num);
	writeln('Ingrese apellido');
	readln(nuevo.apellido);
	leerDatos(nuevo);	
	num := nuevo.nro;
	leer(Fw, reg, okey);
	while ((not okey) and (not encontre)) do begin
		if (reg.nro = num) then encontre:= true
		else leer(Fw, reg, okey);
	end;
	if (not encontre) then begin
		seek(Fw, fileSize(Fw));
		write(Fw, nuevo);
		writeln('Empleado agregado!');
	end
	else 
		writeln('El empleado ya existe!');
	close(Fw);
end;
//////////////////// P 4 MODULO B /////////////////////
Procedure modificarEdad (var Fw: file_record);
var
	reg:empleado;
	okey, listo: boolean;
	num: integer;
begin
	reset(Fw);
	okey:= false; listo:= false;
	writeln('Ingrese el nro de empleado que desee modificar su edad');
	readln(num);
	leer(Fw, reg, okey);
	while ((not okey) and (not listo)) do begin
		if (reg.nro = num) then begin
			writeln('Empleado encontrado!. Por favor ingrese la edad que desea actualizar');
			readln(reg.edad);
			seek(Fw, filePos(Fw)-1);
			write(Fw, reg);
			listo:= true;
		end
		else leer(Fw, reg, okey);
	end;
	if (not listo) then writeln('No se encontraron coincidencias');	
	close(Fw);
end;
///////////////////// P 4 MODULO C ////////////////////////
Procedure exportarEnText (var Fw: file_record);
var
	reg: empleado;
	txt: Text;
	okey:boolean;
begin
	reset (Fw);
	okey:= false;
	assign(txt, 'todos_empleados.txt');
	rewrite(txt);
	leer(Fw, reg, okey);
	while (not okey) do begin
		with reg do 
			writeln(txt,' |NRO de empleado: ',nro,' |Edad: ',edad,' |DNI: ',DNI, '|Nombre: ', nombre);
			writeln(txt, '|Apellido', apellido);
			leer(Fw, reg, okey);
	end;
	close(Fw);
	close(txt);
end;	
//////////////////// P 4 MODULO C ////////////////////////////
Procedure empleadosSinDNI (var Fw: file_record);
var
	reg: empleado;
	okey: boolean;
	txt: Text;
begin
	reset (Fw);
	assign(txt, 'faltaDNIEmpleado.txt');
	okey:= false;
	rewrite(txt);
	leer(Fw, reg, okey);
	while (not okey) do begin
		if (reg.DNI = 00) then begin
			with reg do begin
				writeln(txt,' |NRO de empleado: ',nro,' |Edad: ',edad,' |DNI: ',DNI, '|Nombre: ', nombre);
				writeln(txt, '|Apellido', apellido);
			end;
		end;
		leer(Fw, reg, okey);
	end;
	close(Fw);
	close(txt);
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
		writeln('5. Agregar empleado');
		writeln('6. Modificar edad');
		writeln('7. exportar de tipo text');
		writeln('8. Crear archivo con los empleados sin DNI');
		writeln('Por favor, elija un numero: ');
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
			5: 
				AgregarEmpleados(File_Workers);
			6:
				modificarEdad(File_Workers);
			7:
				exportarEnText(File_Workers);
			8:
				empleadosSinDNI(File_Workers);
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
