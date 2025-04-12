//funciona perfecto
//pedir correccion del TYPE
//preguntar comentario en actualizarMaestro

{Se dispone de un archivo maestro con información de los alumnos de la Facultad de
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre,
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo
maestro está ordenado por código de alumno.
Además, se tienen dos archivos detalle con información sobre el desempeño académico de
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de
cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales
contiene información sobre los exámenes finales rendidos. Cada registro incluye: código de
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia
muchas veces, así como también podría rendir el final de una materia en múltiples
ocasiones.
Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la
información de los archivos detalle. Las reglas de actualización son las siguientes:
● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas
aprobadas.
● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad
de materias con final aprobado}
Program tp2e7;
Const
	valorAlto = 999999;
Type
	alumno = record
		cod: LongInt;
		apellido: String;
		nombre: String;
		cursadasAprobadas: integer;
		finalesAprobados: integer;
	end;
	
	cursadas = record
		cod: LongInt;
		materia: LongInt;
		anio: integer;
		resultado: char;
	end;
	
	finales = record
		cod: LongInt;
		materia: LongInt;
		fecha: String;
		nota: integer;
	end;
	
	{lista_cursadas = record
		dato: cursadas;
		sig: lista_cursadas;
	end;
	
	lista_finales = record
		dato: finales;
		sig: lista_finales;
	end;}
	
	maestro = file of alumno;
	detalle1 = file of cursadas;
	detalle2 = file of finales;
	
Procedure cargarDetalleCursadas (var det: detalle1; var datosLimpios: text);
var
	reg:cursadas;
begin
	assign(det,'detalleCursadas');
	assign(datosLimpios, 'detalleCursadas.txt');
	rewrite(det);
	rewrite(datosLimpios);
	writeln('Ingrese codigo de alumno, finalice con "-1": ');
	readln(reg.cod);
	while (reg.cod <> -1) do begin
		writeln('Ingrese codigo de materia');
		readln(reg.materia);
		writeln('Ingrese año de cursada');
		readln(reg.anio);
		writeln('Ingrese A (aprobado) / D (desaprobado)');
		readln(reg.resultado);
		write(det, reg);
		writeln(datosLimpios, 'CODIGO DE ALUMNO: ',reg.cod);
		writeln(datosLimpios, 'CODIGO DE MATERIA: ',reg.materia);
		writeln(datosLimpios, 'AÑO DE CURSADA Y ESTADO DE LA MATERIA: ',reg.anio,' ',reg.resultado);
		writeln('Ingrese codigo de alumno, finalice con "-1": ');
		readln(reg.cod);	
	end;
	writeln('DETALLE DE CURSADAS CREADO!');
	close(datosLimpios);
	close(det);
end;

Procedure cargarDetalleFinales(var det: detalle2; var datosLimpios: text);
var
	reg:finales;
begin
	assign(det,'detalleFinales');
	assign(datosLimpios, 'detalleFinales.txt');
	rewrite(det);
	rewrite(datosLimpios);
	writeln('Ingrese codigo de alumno, finalice con "-1": ');
	readln(reg.cod);
	while (reg.cod <> -1) do begin
		writeln('Ingrese codigo de materia');
		readln(reg.materia);
		writeln('Ingrese fecha del final');
		readln(reg.fecha);
		writeln('Ingrese la nota obtenida');
		readln(reg.nota);
		write(det, reg);
		writeln(datosLimpios, 'CODIGO DE ALUMNO: ',reg.cod);
		writeln(datosLimpios, 'CODIGO DE MATERIA: ',reg.materia);
		writeln(datosLimpios, 'FECHA Y RESULTADO: ',reg.fecha,' ',reg.nota);
		writeln('Ingrese codigo de alumno, finalice con "-1": ');
		readln(reg.cod);	
	end;
	writeln('DETALLE DE CURSADAS CREADO!');
	close(datosLimpios);
	close(det);
end;

Procedure cargarMaestro(var mae: maestro; var datosLimpios: text);
var
	reg: alumno;
begin
	assign(mae, 'MaestroPsiete');
	rewrite(mae);
	assign(datosLimpios, 'datosMaestro.txt');
	rewrite(datosLimpios);
	writeln('Ingrese codigo de alumno, finalice con "-1": ');
	readln(reg.cod);
	while (reg.cod <> -1) do begin
		writeln('Ingrese cantidad de cursadas aprobadas');
		readln(reg.cursadasAprobadas);
		writeln('Ingrese cantidad de finales aprobados');
		readln(reg.finalesAprobados);
		writeln('Ingrese nombre');
		readln(reg.nombre);
		writeln('Ingrese apellido');
		readln(reg.apellido);
		write(mae, reg);
		writeln(datosLimpios, 'CODIGO DE ALUMNO: ',reg.cursadasAprobadas);
		writeln(datosLimpios, 'CODIGO DE MATERIA: ',reg.finalesAprobados);
		writeln(datosLimpios, 'NOMBRE: ', reg.nombre);
		writeln(datosLimpios, 'APELLIDO: ',reg.apellido);
		writeln('Ingrese codigo de alumno, finalice con "-1": ');
		readln(reg.cod);	
	end;
	writeln('MAESTRO DE ALUMNOS CREADO!');
	close(datosLimpios);
	close(mae);
end;

Procedure leerC (var det: detalle1; var reg: cursadas);
begin
	if (not(eof(det))) then
		read(det, reg)
	else
		reg.cod := valorAlto;
end;
Procedure leerF (var det: detalle2; var reg: finales);
begin
	if (not(eof(det))) then
		read(det, reg)
	else
		reg.cod := valorAlto;
end;
Procedure actualizarMaestro (var mae: maestro; var det1: detalle1; var det2: detalle2);
var
	regCursadas: cursadas;
	regFinales: finales;
	regMaestro: alumno;
	cod_actual:LongInt;
	totalCursadas, totalFinales: integer;
	tieneFinales: boolean;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	
	leerC(det1, regCursadas);
	leerF(det2, regFinales);
	//como se que concuerdan las cursadas con los finales aprobados, pregunto por uno solo
	while (regCursadas.cod <> valorAlto) do begin
		cod_actual := regCursadas.cod;
		totalCursadas:= 0;
		totalFinales:= 0;
		tieneFinales:= true;
		while (regCursadas.cod = cod_actual) do begin
			if (regFinales.cod <> cod_actual) then tieneFinales := false;
			//este while no haria falta porque por mas que tenga ordenado por codigo de materia,
			//a mi me interesa ver solo si se aprobo, no cuantas veces se curso
			{while (regCursadas.materia = materia_actual)and(regCursadas.cod = cod_actual) do begin}
			if (regCursadas.resultado = 'A') then begin
				totalCursadas := totalCursadas + 1;
				//puede darse que tenga mas cursadas que finales aprobados
				if (regFinales.nota >= 4)and(tieneFinales) then begin
					totalFinales:= totalFinales + 1;
					leerF(det2, regFinales); //preguntar si esta bien ubicado
				end;
			end;
			leerC(det1, regCursadas);		
		end;
		read(mae, regMaestro);
		while (regMaestro.cod <> cod_actual) do 
			read(mae, regMaestro);
		seek(mae, filepos(mae)-1);
		//actualizo los datos
		regMaestro.cursadasAprobadas := regMaestro.cursadasAprobadas + totalCursadas;
		regMaestro.finalesAprobados := regMaestro.finalesAprobados + totalFinales;
		write(mae, regMaestro);
	end;
	writeln('MAESTRO ACTUALIZADO');
	close(mae);
	close(det1);
	close(det2);	
end;
Procedure leerMaestro(var mae: maestro; var reg:alumno);
begin
	if (not eof(mae)) then
		read(mae, reg)
	else
		reg.cod := valorAlto;
end;
Procedure imprimirMaestro(var mae: maestro);
var
	reg: alumno;
begin
	reset(mae);
	leerMaestro(mae, reg);
	while (reg.cod <> valorAlto) do begin
		writeln();
		writeln('CODIGO DE ALUMNO: ', reg.cod);
		writeln('CANTIDAD DE CURSADAS APROBADAS: ', reg.cursadasAprobadas);
		writeln('CANTIDAD DE FINALES APROBADOS: ',reg.finalesAprobados);
		writeln('NOMBRE COMPLETO: ',reg.nombre,' ',reg.apellido);
		leerMaestro(mae, reg);
	end;
	close(mae);
end;
	
Procedure menu ();
var
	detalleC : detalle1;
	detalleF: detalle2;
	mae: maestro;
	opt: integer;
	detalleCtxt, detalleFtxt, maestrotxt: text;
begin
	//abro por defecto por si ya crearon los archivos
	assign(mae, 'MaestroPsiete');
	assign(detalleC, 'detalleCursadas');
	assign(detalleF,'detalleFinales');
	writeln('MENU DE OPCIONES');
	writeln('1. CREAR DETALLE CURSADAS');
	writeln('2. CREAR DETALLE FINALES');
	writeln('3. CREAR MAESTRO DE ALUMNOS');
	writeln('4. ACTUALIZAR DATOS DEL MAESTRO');
	writeln('5. IMPRIMIR MAESTRO');
	writeln('6. SALIR DEL PROGRAMA');
	readln(opt);
	while (opt <> 6) do begin
		case (opt) of
			1: 
				cargarDetalleCursadas(detalleC, detalleCtxt);
			2:
				cargarDetalleFinales(detalleF, detalleFtxt);
			3:
				cargarMaestro(mae, maestrotxt);
			4:
				actualizarMaestro(mae, detalleC, detalleF);
			5:
				imprimirMaestro(mae);
			6:
				writeln('Saliendo del programa')
			else
				writeln('Por favor seleccione una opcion valida');
			end;
		writeln('MENU DE OPCIONES');
		writeln('1. CREAR DETALLE CURSADAS');
		writeln('2. CREAR DETALLE FINALES');
		writeln('3. CREAR MAESTRO DE ALUMNOS');
		writeln('4. ACTUALIZAR DATOS DEL MAESTRO');
		writeln('5. IMPRIMIR MAESTRO');
		writeln('6. SALIR DEL PROGRAMA');
		readln(opt);
	end;
end;
Begin
	menu();
End.
				
