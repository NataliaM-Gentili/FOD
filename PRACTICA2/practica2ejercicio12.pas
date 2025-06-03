{La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
Mes:-- 1
día:-- 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
--------
idUsuario N Tiempo total de acceso en el dia 1 mes 1
Tiempo total acceso dia 1 mes 1
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 1
--------
idUsuario N Tiempo total de acceso en el dia N mes 1
Tiempo total acceso dia N mes 1
Total tiempo de acceso mes 1
------
Mes 12
día 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
--------
idUsuario N Tiempo total de acceso en el dia 1 mes 12
Tiempo total acceso dia 1 mes 12
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 12
--------
idUsuario N Tiempo total de acceso en el dia N mes 12
Tiempo total acceso dia N mes 12
Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}
Program tp2e12;
Const
	valorAlto = 2050;
Type
	accesos = record
		anio: integer;
		mes: 1..12;
		dia: 1..31;
		idUsuario: String;
		acceso: real;
	end;
	
	archivo = file of accesos;

Procedure leer (var arc: archivo; var reg: accesos);	
begin
	if (not eof (arc)) then
		read(arc, reg)
	else
		reg.anio:= valorAlto;
end;
Procedure informarEnPantalla(var arc: archivo);
var
	reg: accesos;
	totalUsuario, totalDia, totalMes, totalAnio: real;
	usuario_act : String;
	dia_act, mes_act, anio_act: integer;
begin

	reset(arc);
	writeln('INGRESE EL ANIO PARA FILTRAR DATOS');
	readln(anio_act);
	
	leer(arc, reg);
	
	while (reg.anio <> anio_act) do 
		leer(arc, reg);

	writeln('Anio: ',reg.anio); 
	totalAnio:= 0;
	while (reg.anio = anio_act) do begin
		mes_act := reg.mes;
		totalMes:= 0;
		writeln('Mes: ',reg.mes); 	
		while(reg.mes = mes_act) and (reg.anio = anio_act) do begin
			dia_act := reg.dia;	
			writeln('Dias: ',reg.dia); 
			totalDia:= 0;
			
			while(reg.dia = dia_act) and (reg.mes = mes_act) and (reg.anio = anio_act) do begin	
				usuario_act := reg.idUsuario;
				totalUsuario:= 0;
				while (usuario_act = reg.idUsuario) and (reg.dia = dia_act) and (reg.mes = mes_act) and (reg.anio = anio_act) do begin	
					totalUsuario:= totalUsuario + reg.acceso;
					leer(arc, reg);
				end;
				writeln(reg.idUsuario,' tiempo total de acceso en el dia ',dia_act,' mes ',mes_act,':');
				writeln(totalUsuario);
				totalDia := totalDia + totalUsuario;
			end;
			writeln('Tiempo total de acceso en el dia ',dia_act,' mes ',mes_act);
			writeln(totalDia);
			totalMes := totalMes + totalDia;
		end;
		writeln('Tiempo total de acceso en el mes ',mes_act);
		writeln(totalMes);
		totalAnio:= totalAnio + totalMes;
	end;
	writeln('Tiempo total de acceso en el ANIO ',anio_act);
	writeln(totalAnio);
	close(arc);
end;
Var
	arc: archivo;
Begin
	informarEnPantalla(arc);
End.
