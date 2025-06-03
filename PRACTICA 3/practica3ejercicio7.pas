{Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que permita borrar especies de aves extintas. Este programa debe
disponer de dos procedimientos:
a. Un procedimiento que dada una especie de ave (su código) marque la misma
como borrada (en caso de querer borrar múltiples especies de aves, se podría
invocar este procedimiento repetidamente).
b. Un procedimiento que compacte el archivo, quitando definitivamente las
especies de aves marcadas como borradas. Para quitar los registros se deberá
copiar el último registro del archivo en la posición del registro a borrar y luego
eliminar del archivo el último registro de forma tal de evitar registros duplicados.
i. Implemente una variante de este procedimiento de compactación del
archivo (baja física) donde el archivo se trunque una sola vez.}
Program practica3ejercicio7;
Const
	valorAlto = 99999;
Type
	aves = record
		codigo: LongInt;
		especie: String;
		familia: String;
		descripcion: String;
		zona_geografica: String;
	end;
	
	archivo = file of aves;
	
procedure leerArchivo (var a: archivo; var reg: aves);
begin
	if (not eof(a)) then
		read(a, reg)
	else
		reg.codigo := valorAlto;
end;
procedure bajaLogica (var a:archivo; cod: LongInt);
var
	reg: aves;
begin
	reset(a);
	leerArchivo(a, reg);
	//  Un procedimiento que dada una especie de ave (su código) marque la misma
	// como borrada
	// Asumo que el codigo existe?
	while ((reg.codigo <> valorAlto) and (reg.codigo <> codigo)) do
		leerArchivo(a, reg);
	if (reg.codigo = codigo) then begin
		seek(a, filepos(a)-1);
		reg.codigo := reg.codigo * -1;
		write(a, reg);
	end;
	close(a);
end;
procedure compactarArchivoA (var a: archivo);
var
	reg, aux: aves;
	pos: integer;
begin
	reset(a);
	leerArchivo(a, reg);
	while (reg.codigo <> valorAlto) do begin
		if (reg.codigo < 0) then begin
			pos:= filepos(a)-1;
			seek(a, filesize(a)-1);
			read(a, aux);
			seek(a, filepos(a)-1);
			write(a, reg);
			seek(a, pos);
			write(a, aux);
			seek(a, filesize(a)-1); //me posiciono en el elemento q quiero borrar 
			truncate(a); //borro a partir de ese elemento, pero seria solo el ultimo
		end;
		leerArchivo(a, reg);
	end;
	close(a);
end;

procedure compactarArchivoB (var a: archivo);
var
	reg, aux: aves;
	pos, ultimo_valido: integer;
begin
	reset(a);
	desde:= -1;
	ultimo_valido := filesize(a) - 1;
	
	while (desde <> hasta) do begin
		leerArchivo(a, reg);
		if (reg.codigo >= 0) then 
			desde := desde + 1;
		else begin
			seek(a, hasta);
			leerArcivo(a, aux);
			while (aux.codigo < 0) do begin
				hasta := hasta - 1;
				seek(a, hasta);
				leerArchivo(a, aux);
			end;
			seek(a, desde);
			write(a, aux);
			hasta:= hasta - 1;
			desde:= desde + 1;
		end;
	end;
	truncate(a); // quedo apuntando al primero no válido
	close(a);
end;
	
