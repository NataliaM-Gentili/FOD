Program parcial;
Const
	valorAlto = 2026;
Type
	
	equipos = record;
		codigo: LongInt;
		nombre: String;
		anio: integer;
		cod_torneo: LongInt;
		cod_rival: LongInt;
		a_favor: integer;
		en_contra: integer;
		puntos: integer;
	end;
	
	archivo = file of equipos;
	
	regAux = record;
		a_favor: integer;
		en_contra: integer;
		gana: integer;
		pierde: integer;
		empate: integer;
	end;
	
procedure inicializar (var r: regAux);
begin
	with r do begin
		a_favor := 0;
		en_contra := 0;
		gana := 0;
		empate := 0;
		pierde := 0;
	end;
end;

procedure leerArchivo (var a: archivo; var reg: equipos);
begin
	if (not eof(a)) then
		read(a, reg)
	else
		a.anio := valorAlto;
end;

procedure informar (var arc: archivo);
var
	reg: equipos;
	aux: regAux;
	
begin
	reset(arc);
	leerArchivo(arc, reg);
	
	while (reg.anio <> valorAlto) do begin
		act_anio := reg.anio;
		writeln('Año ',act_anio);
		
		while (reg.anio = act_anio) do begin
			act_torneo := reg.cod_torneo;
			writeln('Torneo ', reg.cod_torneo);
			
			while ((reg.anio = act_anio) and (reg.cod_torneo = act_torneo)) do begin
				act_equipo := reg.codigo;
				max := minValue;
				auxNom := reg.nombre;
				writeln('Equipo ',reg.codigo, reg.nombre);
				
				inicializar(aux);
				while((reg.codigo = act_equipo) and (reg.anio = act_anio) and (reg.cod_torneo = act_torneo)) do begin
					with aux do begin
						a_favor := a_favor + reg.a_favor;
						en_contra := en_contra + reg.en_contra;
						if (reg.a_favor > reg.en_contra) then 
							gana := gana + 1;
						else begin
							if (reg.a_favor < reg.en_contra) then
								pierde := pierde + 1
							else
								empate := empate + 1;
						end;
					end;
					
					leerArchivo(arc, reg);
				end;
				with aux do begin
					writeln('A favor ', a_favor);
					writeln(en_contra);
					writeln('Diferencia ', (a_favor - en_contra));
					writeln(ganados);
					writeln(perdidos);
					writeln(empate);
					
					total := (ganados * 3) + empate;
					if (total > max) then begin
						max := total;
						maxNom:= auxNom;
					end;
				end;
			end;
			writeln('Ganador del torneo ', maxNom, act_torneo, act_anio);
		end;
	end;
	
	close(arc);
end;
