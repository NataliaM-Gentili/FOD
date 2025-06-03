{11. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:
Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.}
Program tp2e11;
Const
	valorAlto = '#';
	DF = 15;
Type
	empleado = record
		departamento: char;
		division: integer;
		num: LongInt;
		categoria: 1..DF;
		horas: real;
	end;
	
	archivo = file of empleado;
	
	categorias = array[1..DF] of real;
	
Procedure crearArchivo (var arc:archivo; var datosLimpios: text);
var
	reg: empleado;
begin
	assign(arc,'maestroPonce');
	rewrite(arc);
	assign(datosLimpios,'maestroPonce.txt');
	rewrite(datosLimpios);
		
	writeln();
	writeln('CREANDO EL MAESTRO ---------------------------------\n');
	writeln('Ingrese caracter de DEPARTAMENTO, finalice con "#": ');
	readln(reg.departamento);
	while (reg.departamento <> '#') do begin
		writeln('Ingrese division (numero): ');
		readln(reg.division);
		writeln('Ingrese el numero de empleado: ');
		readln(reg.num);
		writeln('Ingrese la categoria : ');
		readln(reg.categoria);
		writeln('Ingrese la cantidad de horas extras: ');
		readln(reg.horas);
		write(arc, reg);
		writeln(datosLimpios,'DEPARTAMENTO: ',reg.departamento);
		writeln(datosLimpios,'DIVISION: ',reg.division);
		writeln(datosLimpios,'EMPLEADO: ',reg.num);
		writeln(datosLimpios,'CATEGORIA: ',reg.categoria);
		writeln(datosLimpios,'CANTIDAD DE HORAS EXTRAS TRABAJADAS: ',reg.horas:0:2);
		writeln();
		writeln('Ingrese caracter de DEPARTAMENTO, finalice con "#": ');
		readln(reg.departamento);	
	end;
	writeln('ARCHIVO MAESTRO CREADO');
	close(arc);
	close(datosLimpios);
end;
Procedure leer(var arc:archivo; var reg: empleado);
begin
	if (not(eof(arc))) then
		read(arc, reg)
	else
		reg.departamento := valorAlto;
end;
Procedure imprimirDatos (var arc: archivo; vec: categorias);
var
	reg: empleado;
	montoTotalDiv, montoTotalDpto, totalHorasDpto, totalHorasDiv, precio: real;
	act_depto: char;
	act_div: integer;
begin

	reset(arc);
	
	leer(arc, reg);
	writeln('holaaa');
	while (reg.departamento <> '#') do begin
		act_depto := reg.departamento;
		totalHorasDpto:= 0;
		montoTotalDpto:= 0;
		writeln('Departamento ',reg.departamento);
		writeln();
		
		while (reg.departamento = act_depto) do begin 
			act_div := reg.division;
			totalHorasDiv:= 0;
			montoTotalDiv:= 0;
			writeln('Division ',act_div);
			writeln();
			writeln('Numero de Empleado 	Total de Hs. 	Importe a cobrar');
			
			while (reg.division = act_div)and(reg.departamento = act_depto) do begin

				precio := reg.horas * vec[reg.categoria];
				totalHorasDiv := totalHorasDiv + reg.horas;
				montoTotalDiv:= montoTotalDiv + precio;
				writeln();
				writeln(reg.num,'			',reg.horas:0:2,'			',precio:0:4);
				leer(arc, reg);
			end;
			montoTotalDpto:= montoTotalDpto + montoTotalDiv;
			totalHorasDpto:= totalHorasDpto + totalHorasDiv;
			writeln();
			writeln('Total de horas division: ',totalHorasDiv:0:2);
			writeln('Monto total por division: ',montoTotalDiv:0:4);
		end;
		writeln();
		writeln('Total de horas departamento: ',totalHorasDpto:0:2);
		writeln('Monto total por departamento: ',montoTotalDpto:0:4);
	end;
	writeln();
	writeln('-----------------------------------------------------');
	close(arc);
end;

Procedure cargarVector (var v: categorias; var t: text);
var
	num: LongInt;
	pago: real;
	i: integer;
begin
	reset(t);

	
	for i:= 1 to DF do begin
		readln(t, num, pago);
		v[num] := pago;
	end;
	writeln('AUMENTOS CARGADOS SEGUN LA CATEGORIA!');
	close(t);
end;
		
Procedure menu();
var
	arc: archivo;
	arcTxt, precios: text;
	v: categorias;
	opt: integer;
begin
	assign(arc,'maestroPonce');
	assign(arcTxt,'archivo.txt');
	assign(precios,'precios.txt');
		
	writeln('MENU DE OPCIONES');
	writeln('1. CREAR ARCHIVO');
	writeln('2. CARGAR AUMENTOS');
	writeln('3. IMPRIMIR DATOS');
	writeln('4. SALIR DEL PROGRAMA');
	readln(opt);
	
	while (opt <> 4) do begin
		case(opt) of 
			1:
				crearArchivo(arc, arcTxt);
			2:
				cargarVector(v, precios);
			3:
				imprimirDatos(arc, v);
			4:
				writeln('Saliendo del programa...');
			else
				writeln('Por favor, seleccione una opcion valida');
			end;
		writeln('MENU DE OPCIONES');
		writeln('1. CREAR ARCHIVO');
		writeln('2. CARGAR AUMENTOS');
		writeln('3. IMPRIMIR DATOS');
		writeln('4. SALIR DEL PROGRAMA');
		readln(opt);		
	end;
end;
Begin
	menu();
End.	
	
