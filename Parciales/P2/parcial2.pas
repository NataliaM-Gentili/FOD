Program parcial2;
Const
	valorAlto = 99999;
	DF = 30;
Type
	subR = 1..DF; 
	BsAs = record
		codigo: LongInt;
		nombre: String;
		casos: integer;
	end;
	
	relevamiento = record
		codigo: LongInt;
		casos: integer;
	end;
	
	maestro = file of BsAs;
	detalle = file of relevamiento;
	
	vecDetalles = array [subR] of detalle;
	vecMinimo = array [subR] of relevamiento;
	
procedure leerDetalle (var det: detalle; var reg: relevamiento);
begin
	if (not eof(det)) then
		read(det, reg)
	else
		reg.codigo := valorAlto;
end;
procedure leerMaestro (var mae: maestro; var reg: BsAs);
begin
	if (not eof(mae)) then
		read(mae, reg)
	else
		reg.codigo := valorAlto;
end;
procedure minimos (var vecD: vecDetalles; var vecMin: vecMinimos; var min: relevamiento);
var
	i, pos: integer;
	reg: relevamiento;
begin
	pos := 0;
	min.codigo := valorAlto;
	
	for i:= 1 to DF do begin
		if (vecM[i].codigo < min.codigo) then begin
			min := vecM[i];
			pos:= i;
		end;
	end;
	if (min.codigo <> valorAlto) then begin
		leerDetalle(vecD[pos], reg);
		vecMin[pos] := reg;
	end;
end;
			
procedure actualizarMaestro (var mae: maestro; var vecD: vecDetalles; var vecMin: vecMinimo);
var
	i, casos: integer;
	regD: relevamiento;
	regM: BsAs;
	cod_actual: LongInt;
	
begin
	reset(mae);
	for i:= 1 to DF do begin
		reset(vecD[i]);
		leerDetalle(vecD[i], regD);
		vecMin[i] := regD;
	end;
	
	leerMaestro (mae, regM);
	while (regM.codigo <> valorAlto) do begin
		casos := 0;
		cod_actual := regM.codigo;
		
		minimos(vecD, vecMin, regD);
		while (regD.codigo = cod_actual) do begin
			casos := casos + regD.casos;
			minimos(vecD, vecMin, regD);
		end;
		
		regM.casos := regM.casos + casos;
		if (regM.casos > 15) then 
			writeln(regM.nombre, regM.codigo);
		
		seek(mae, filepos(mae)-1);
		write(mae, regM);
		leerMaestro(mae, regM);
	end;
	
	writeln('Archivo maestro actualizado!');
	close(mae);
	for i:= 1 to DF do 
		close(vecD[i]);
end;
var
	mae: maestro;
	vec: vecDetalles;
	v: vecMinimos;
	i: integer;
	num, name: String;
begin
	assign(mae, 'maestro');
	for i:= 1 to DF do begin
		Str(i, num);
		name := 'Detalle' + num;
		assign(vec[i], name);
	end;
	
	actualizarMaestro(mae, vec, v);
	
end.
