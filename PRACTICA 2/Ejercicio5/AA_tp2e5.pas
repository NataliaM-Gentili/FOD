//hay q corregir el guardado x fecha
Program tp2e5;
Const
	valorAlto = 9999;
	DF = 5;
Type
	date = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;
	logs = record
		cod_usuario: integer;
		fecha: date;
		tiempo_sesion: real;
	end;
	
	LAN = record
		cod_usuario: integer;
		fecha: date;
		tiempo_total_de_sesiones_abiertas: real;
	end;
	
	maestro = file of LAN;
	detalle = file of logs;
	
	vecDetalles = array [1..DF] of detalle;
	vectorMinimo = array [1..DF] of logs;
	
Procedure leer(var det: detalle; var reg: logs);
begin
		if (not eof(det)) then 
			read(det, reg)
		else
			reg.cod_usuario := 9999;
end;
Procedure crearDetalles (var v: vecDetalles);
var 
	l: logs;
	name, num: string;
	i: integer;
begin
	for i:= 1 to DF do begin
		Str(i, num);
		name := 'detalle' + num;
		writeln('Se creara el detalle: ',name);
		assign(v[i], name);
		rewrite(v[i]);
		writeln('Ingrese cod de usuario, 0 para finalizar');
		readln(l.cod_usuario);
		while (l.cod_usuario <> 0) do begin
			writeln('Ingrese fecha: ANIO, MES, DiA');
			readln(l.fecha.anio);
			readln(l.fecha.mes);
			readln(l.fecha.dia);
			writeln('Ingrese tiempo en sesion (minutos): ');
			readln(l.tiempo_sesion);
			write(v[i], l);
			writeln('Ingrese cod de usuario, 0 para finalizar');
			readln(l.cod_usuario);
		end;
	end;
	writeln('Archivos detalle creados!');
	for i:= 1 to DF do
		close(v[i]);
end;
Procedure minimo (var v: vectorMinimo; var vecD: vecDetalles; var min: logs);
var
	i, pos: integer;
	reg: logs;
begin
	pos := 0;
	min.cod_usuario := valorAlto;
	for i:= 1 to Df do begin
		{if (v[i].cod_usuario < min.cod_usuario) or
		   ((v[i].cod_usuario = min.cod_usuario) and 
			(v[i].fecha.anio < min.fecha.anio)) or
		   ((v[i].cod_usuario = min.cod_usuario) and 
			(v[i].fecha.anio = min.fecha.anio) and 
			(v[i].fecha.mes < min.fecha.mes)) or
		   ((v[i].cod_usuario = min.cod_usuario) and 
			(v[i].fecha.anio = min.fecha.anio) and 
			(v[i].fecha.mes = min.fecha.mes) and 
			(v[i].fecha.dia < min.fecha.dia)) then
		begin
		  min := v[i];
		  pos := i;
		end;
	 end;}
		writeln('CODIGO: ', v[i].cod_usuario,' MINIMO: ',min.cod_usuario);
		if (v[i].cod_usuario < min.cod_usuario) then begin
			min:= v[i];
			pos:= i;
		end
		else begin 
			if (v[i].cod_usuario = min.cod_usuario) then begin
				writeln('ANIO: ',v[i].fecha.anio,' MINIMO ANIO: ',min.fecha.anio);
				if (v[i].fecha.anio < min.fecha.anio) then begin
					min:= v[i];
					pos:= i
				end
				else begin
					writeln('MES: ',v[i].fecha.mes,' MINIMO MES: ',min.fecha.mes);
					if (v[i].fecha.anio = min.fecha.anio) and (v[i].fecha.mes < min.fecha.mes) then begin
						min:= v[i];
						pos:= i
					end
					else begin
						writeln('DIA: ',v[i].fecha.dia,' MINIMO DIA: ',min.fecha.dia);
						if (v[i].fecha.mes = min.fecha.mes) and (v[i].fecha.dia < min.fecha.dia) then begin
							min:= v[i];
							pos:= i
						end;
					end;
				end;
			end;
		end;
	end;
	if (min.cod_usuario <> valorAlto) then begin
		leer(vecD[pos], reg);
		v[pos] := reg;
	end;
end;		
Procedure crearMaestro (var mae: maestro; var vecD: vecDetalles; var v:vectorMinimo);
var
	reg: logs;
	regM : LAN;
	i, cod_actual: integer;
	name: String;
	 total_ses: real;
	act_fecha: date;
begin
	write('Ingrese nombre para el archivo maestro: '); 
	read(name);
	//name := '/var/log/' + name;
	assign(mae, name);
	rewrite(mae);
	for i:= 1 to DF do begin
		reset(vecD[i]);
		leer(vecD[i], reg);
		v[i] := reg;
	end;
	minimo(v, vecD, reg);
	while (reg.cod_usuario <> valorAlto) do begin
		cod_actual:= reg.cod_usuario;
		act_fecha := reg.fecha;
		total_ses:= 0;
		while (cod_actual = reg.cod_usuario) do begin
			if (reg.fecha.dia <> act_fecha.dia)or(reg.fecha.mes <> act_fecha.mes)or(reg.fecha.anio <> act_fecha.anio) then begin
				writeln('PARA EL CODIGO: ',reg.cod_usuario);
				writeln(act_fecha.anio,'-',act_fecha.mes,'-',act_fecha.dia);
				writeln('TIEMPO ACUMULADO PARA ESTA FECHA: ', total_ses);
				regM.tiempo_total_de_sesiones_abiertas := total_ses;
				regM.cod_usuario := cod_actual;
				regM.fecha := act_fecha;
				write(mae, regM);
				total_ses:= 0;
				act_fecha:= reg.fecha;
			end;
			writeln('act: ', reg.tiempo_sesion);
			total_ses := total_ses + reg.tiempo_sesion;
			minimo(v, vecD,  reg);
		end;
		regM.tiempo_total_de_sesiones_abiertas := total_ses;
		regM.cod_usuario := cod_actual;
		regM.fecha := act_fecha;
		write(mae, regM);
	end;
	writeln('Archivo maestro creado con exito! ');
	close(mae);
	for i:= 1 to DF do
		close(vecD[i]);
end;
Procedure leerM (var mae: maestro; var reg: LAN);
begin
	if (not (eof(mae))) then 
		read(mae, reg)
	else
		reg.cod_usuario := 9999;
end;
Procedure informarMaestro(var mae: maestro);
var
	reg: LAN;
	cod_actual: integer;
begin
	reset(mae);
	writeln;
	writeln('--------------- IMPRIMO MAESTRO --------------');
	writeln;
	leerM(mae, reg);
	while (reg.cod_usuario <> valorAlto) do begin
		writeln('CODIGO DE USUARIO: ', reg.cod_usuario);
		cod_actual := reg.cod_usuario;
		while (cod_actual = reg.cod_usuario) do begin
			writeln('FECHA DE SESION: ', reg.fecha.anio,' ', reg.fecha.mes,' ', reg.fecha.dia);
			writeln('TIEMPO EN SESION: ', reg.tiempo_total_de_sesiones_abiertas);
			leerM(mae, reg);
		end;
	end;
	close(mae);
end;		
Procedure menu();
var
	mae: maestro;
	vecD : vecDetalles;
	v: vectorMinimo;
	opt: integer;
begin
	writeln('Elija una opcion');
	writeln('1. Crear detalles');
	writeln('2. Crear maestro');
	writeln('3. Informar maestro');
	writeln('4. Salir');
	readln(opt);
	assign(mae,'maestroPcinco');
	assign(vecD[1],'detalle1');
	assign(vecD[2],'detalle2');
	assign(vecD[3],'detalle3');
	assign(vecD[4],'detalle4');
	assign(vecD[5],'detalle5');
	while (opt <> 4) do begin
		case opt of
			1: 
				crearDetalles(vecD);
			2:
				crearMaestro(mae, vecD, v);
			3: 
				informarMaestro(mae);
			4:
				writeln('Saliendo del programa');
			else
				writeln('Opcion no valida');
			end;
		writeln('Elija una opcion');
		writeln('1. Crear detalles');
		writeln('2. Crear maestro');
		writeln('3. Informar maestro');
		writeln('4. Salir');
		readln(opt);
	end;
end;

Begin
	menu();
End.		
		
