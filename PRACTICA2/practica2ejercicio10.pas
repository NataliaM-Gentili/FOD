{ Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información está ordenada por código de provincia y código de localidad}
Program tp2e10;
Const
	valorAlto = 99999;
Type
	mesa = record
		provincia: LongInt;
		localidad: LongInt;
		num: LongInt;
		votos: LongInt;
	end;
	
	maestro = file of mesa;
	
Procedure crearMaestro (var mae: maestro; var datosLimpios: text);
var
	reg: mesa;
begin
	assign(mae, 'maestroPdiez');
	assign(datosLimpios,'maestroPdiez.txt');
	rewrite(mae);
	rewrite(datosLimpios);

	writeln();
	writeln('CREANDO EL MAESTRO ---------------------------------\n');
	writeln('Ingrese codigo de provincia, finalice con "-1": ');
	readln(reg.provincia);
	while (reg.provincia <> -1) do begin
		writeln('Ingrese el codigo de localidad: ');
		readln(reg.localidad);
		writeln('Ingrese el numero de mesa: ');
		readln(reg.num);
		writeln('Ingrese la cantidad de votos contados: ');
		readln(reg.votos);
		write(mae, reg);
		writeln(datosLimpios,'PROVINCIA: ',reg.provincia);
		writeln(datosLimpios, ' LOCALIDAD: ',reg.localidad);
		writeln(datosLimpios,' MESA: ',reg.num);
		writeln(datosLimpios,' CANTIDAD DE VOTOS: ',reg.votos);
		writeln();
		writeln('Ingrese codigo de provincia, finalice con "-1": ');
		readln(reg.provincia);	
	end;
	writeln('ARCHIVO MAESTRO CREADO');
	close(mae);
	close(datosLimpios);
end;

Procedure leerM (var mae:maestro; var reg: mesa);
begin
	if (not(eof(mae))) then
		read(mae, reg)
	else
		reg.provincia := valorAlto;
end;
Procedure contabilizarVotos (var mae: maestro);
var
	regM: mesa;
	conteo,  conteoProv, conteoGral: LongInt;
	provActual, locActual: LongInt;
begin
	reset(mae);
	
	conteoGral:= 0;
	leerM(mae, regM);
	while (regM.provincia <> valorAlto) do begin
		provActual:= regM.provincia;
		conteoProv:= 0;
		writeln();
		writeln('CODIGO DE PROVINCIA: ',provActual);
		writeln();
		
		while (provActual = regM.provincia) do begin
			conteo:= 0;
			locActual:= regM.localidad;
			writeln(conteo);
			
			while (locActual = regM.localidad) and (provActual = regM.provincia) do begin
				conteo := conteo + regM.votos;
				leerM(mae, regM);
			end;
			writeln('CODIGO DE LOCALIDAD: ',locActual,'		TOTAL DE VOTOS: ',conteo);
			conteoProv := conteoProv + conteo;
		end;
		writeln('TOTAL DE VOTOS PROVINCIA: ',conteoProv);
		conteoGral := conteoGral + conteoProv;
	end;
	writeln('CONTEO GENERAL DE VOTOS: ',conteoGral);
	close(mae);
end;
Procedure menu();
var
	mae: maestro;
	maeTxt, recaudarVotos: text;
	opt: integer;
begin
	assign(mae,'maestroPdiez');
	assign(maeTxt,'maestro.txt');
	assign(recaudarVotos,'votos_contados.txt');
		
	writeln('MENU DE OPCIONES');
	writeln('1. CREAR MAESTRO');
	writeln('2. RECOLECTAR VOTOS');
	writeln('3. SALIR DEL PROGRAMA');
	readln(opt);
	
	while (opt <> 3) do begin
		case(opt) of 
			1:
				crearMaestro(mae, maeTxt);
			2:
				contabilizarVotos(mae);
			3:
				writeln('Saliendo del programa...');
			else
				writeln('Por favor, seleccione una opcion valida');
			end;
		writeln('MENU DE OPCIONES');
		writeln('1. CREAR MAESTRO');
		writeln('2. RECOLECTAR VOTOS');
		writeln('3. SALIR DEL PROGRAMA');
		readln(opt);		
	end;
end;
Begin
	menu();
End.
