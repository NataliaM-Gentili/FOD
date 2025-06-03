{Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.}

Program tp2e9;
Const
	valorAlto = 999999;
Type
	cliente = record
		cod: LongInt;
		nombre: String;
		apellido: String;
	end;
	venta = record
		cliente: cliente;
		anio: integer;
		mes: integer;
		dia: integer;
		monto: real;
	end;
	
	maestro = file of venta;
	
	vecMeses = array [1..12] of String;

Procedure cargarMeses (var v: vecMeses);
begin
	v[1]:= 'Enero';
	v[2]:= 'Febrero';
	v[3]:= 'Marzo';
	v[4]:= 'Abril';
	v[5]:= 'Mayo';
	v[6]:= 'Junio';
	v[7]:= 'Julio';
	v[8]:= 'Agosto';
	v[9]:= 'Septiembre';
	v[10]:= 'Octubre';
	v[11]:= 'Noviembre';
	v[12]:= 'Diciembre';
end;
Procedure crearMaestro (var mae: maestro; var datosLimpios: text);
var
	reg: venta;
begin
	assign(mae, 'maestroPnueve');
	assign(datosLimpios,'maestroPnueve.txt');
	rewrite(mae);
	rewrite(datosLimpios);

	writeln();
	writeln('CREANDO EL MAESTRO ---------------------------------\n');
	writeln('Ingrese codigo de cliente, finalice con "-1": ');
	readln(reg.cliente.cod);
	while (reg.cliente.cod <> -1) do begin
		writeln('Ingrese el año ,es y dia de la compra: ');
		readln(reg.anio);
		readln(reg.mes);
		readln(reg.dia);
		writeln('Ingrese el monto de la compra: ');
		readln(reg.monto);
		writeln('Ingrese nombre y apellido del cliente');
		readln(reg.cliente.nombre);
		readln(reg.cliente.apellido);
		write(mae, reg);
		writeln(datosLimpios,'CLIENTE: ',reg.cliente.cod,' ',reg.cliente.nombre);
		writeln(datosLimpios, 'APELLIDO: ',reg.cliente.apellido);
		writeln(datosLimpios,'FECHA DE VENTA: ',reg.anio,' ',reg.mes,' ',reg.dia);
		writeln(datosLimpios,' MONTO DE COMPRA: ',reg.monto:0:2);
		writeln();
		writeln('Ingrese codigo de cliente, finalice con "-1": ');
		readln(reg.cliente.cod);	
	end;
	writeln('ARCHIVO MAESTRO CREADO');
	close(mae);
	close(datosLimpios);
end;

Procedure leerM (var mae: maestro; var reg: venta);
begin
	if (not(eof(mae))) then
		read(mae, reg)
	else
		reg.cliente.cod := valorAlto;
end;
Procedure informarCliente (var cli: cliente);
begin
	writeln('DATOS DEL CLIENTE: ',cli.cod);
	writeln('NOMBRE COMPLETO: ',cli.nombre,' ',cli.apellido);
end;
Procedure obtenerReporte(var mae: maestro; v: vecMeses);
var
	regM: venta;
	cod_actual: LongInt;
	montoMensual, montoAnual, montoTotal: real;
	anio_actual, mes_actual: integer;
begin
	reset(mae);
	
	montoTotal:= 0;

	
	leerM(mae, regM);
	while (regM.cliente.cod <> valorAlto) do begin
	
		cod_actual:= regM.cliente.cod;
		informarCliente(regM.cliente);

		while (cod_actual = regM.cliente.cod) do begin
			anio_actual:= regM.anio;
			montoAnual:= 0;
			
			while (cod_actual = regM.cliente.cod)and(anio_actual = regM.anio) do begin
				mes_actual:= regM.mes;
				montoMensual := 0;
				
					while (cod_actual = regM.cliente.cod)and(mes_actual = regM.mes) and(anio_actual = regM.anio) do begin
						montoMensual:= montoMensual + regM.monto;
						leerM(mae, regM);	
					end;
					
					writeln('ANIO ',anio_actual,', TOTAL PARA EL MES DE ',v[mes_actual],': $',montoMensual:0:5);
					montoAnual:= montoAnual + montoMensual;
			end;
			writeln('ANIO ',anio_actual,', TOTAL ACUMULADO: $',montoAnual:0:5);
			montoTotal:= montoTotal + montoAnual;
			writeln;
		end;
	end;
	writeln('EL TOTAL DE VENTAS OBTENIDO ES: ',montoTotal:0:5);
	close(mae);
end;
Procedure menu();
var
	mae: maestro;
	vectorMeses: vecMeses;
	opt: integer;
	maeTxt: text;
Begin
	assign(mae, 'maestroPnueve');
	cargarMeses(vectorMeses);
	
	writeln('MENU DE OPCIONES: ');
	writeln('1. CREAR MAESTRO');
	writeln('2. CREAR REPORTE POR CLIENTE');
	writeln('3. SALIR');
	readln(opt);
	while (opt <> 3 ) do begin
		case(opt) of
			1: 
				crearMaestro(mae, maeTxt);
			2: 
				obtenerReporte(mae, vectorMeses);
			3:
				writeln('Saliendo del programa... Nos vemos!');
			else
				writeln('Por favor, seleccione una opcion valida');
			end;
		writeln('MENU DE OPCIONES: ');
		writeln('1. CREAR MAESTRO');
		writeln('2. CREAR REPORTE POR CLIENTE');
		writeln('3. SALIR');
		readln(opt);
	end;
end;
Begin
	menu();
End.
			
