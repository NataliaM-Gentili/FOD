Program tp2e6;
Const
	DF = 3;
	valorAlto = 999999;
Type
	municipios = record
		cod: LongInt;
		cepa: LongInt;
		activos: integer;
		nuevos: integer;
		recuperados: integer;
		fallecidos: integer;
	end;
	
	localidad = record
		cod: LongInt;
		cepa: LongInt;
		nombre: String;
		nombreCepa: String;
		activos: integer;
		nuevos: integer;
		recuperados: integer;
		fallecidos: integer;
	end;
	
	maestro = file of localidad;
	detalle = file of municipios;
	
	vecDetalles = array [1..DF] of detalle;
	vecMinimo = array [1..DF] of municipios;
	
Procedure crearDetalles (var vec: vecDetalles);
var
	num, name: String;
	m: municipios;
	i: integer;
begin
	for i:= 1 to DF do begin
		Str(i, num);
		name := 'detalle' + num;
		writeln('Creando el archivo ',name, '----------------------------');
		assign(vec[i], name);
		rewrite(vec[i]);
		writeln();
		writeln('Ingrese codigo de localidad, finalice con -1');
		readln(m.cod);
		while (m.cod <> -1) do begin
			writeln('Ingrese codigo de cepa');
			readln(m.cepa);
			writeln('Ingrese casos activos');
			readln(m.activos);
			writeln('Ingrese casos nuevos');
			readln(m.nuevos);
			writeln('Ingrese cant de recuperados');
			readln(m.recuperados);
			writeln('Ingrese cant de fallecidos');
			readln(m.fallecidos);
			write(vec[i], m);
			writeln();
			writeln('Ingrese codigo de localidad, finalice con -1');
			readln(m.cod);
		end;
	end;
	for i:= 1 to DF do
		close(vec[i]);
end;
Procedure crearMaestro(var mae: maestro);
var
	m: localidad;
begin
	assign(mae, 'MaestroPseis');
	rewrite(mae);
	writeln();
	writeln('Ingrese codigo de localidad, finalice con -1');
	readln(m.cod);		
	while (m.cod <> -1) do begin
			writeln('Ingrese codigo de cepa');
			readln(m.cepa);
			writeln('Ingrese casos activos');
			readln(m.activos);
			writeln('Ingrese casos nuevos');
			readln(m.nuevos);
			writeln('Ingrese cant de recuperados');
			readln(m.recuperados);
			writeln('Ingrese cant de fallecidos');
			readln(m.fallecidos);
			writeln('Ingrese nombre de CEPA');
			readln(m.nombreCepa);
			writeln('Ingrese nombbre de la LOCALIDAD');
			readln(m.nombre);
			write(mae, m);
			writeln();
			writeln('Ingrese codigo de localidad, finalice con -1');
			readln(m.cod);
	end;
	close(mae);
end;
Procedure leerD (var det: detalle; var reg: municipios);
begin
	if (not eof(det)) then
		read(det, reg)
	else
		reg.cod := valorAlto;
end;
Procedure minimo(var vec:vecDetalles; var v:vecMinimo; var min: municipios);
var
	i, pos: integer;
	reg: municipios;
begin
	pos:= 0;
	min.cod:= valorAlto;
	min.cepa:= valorAlto;
	for i:= 1 to DF do begin
		if (v[i].cod < min.cod) then begin
			min := v[i];
			pos:= i;
		end
		else begin
			if (v[i].cod = min.cod) and (v[i].cepa < min.cepa) then begin
				min:= v[i];
				pos:= i;
			end;
		end;
	end;
	if (min.cod <> valorAlto) then begin
			leerD(vec[i], reg);
			v[pos]:= reg;
	end;
end;
Procedure actualizarMaestro(var mae:maestro; var vec:vecDetalles; var v:vecMinimo; var cantidad: integer);
var
	i, totalFallecidos, totalRecuperados: integer;
	reg: municipios;
	cod_actual, cepa_actual : LongInt;
	regM: localidad;
	auxLoc: integer;
begin
	reset(mae);
	for i:= 1 to DF do begin
		reset(vec[i]);
		leerD(vec[i], reg);
		v[i]:= reg;
	end;

	auxLoc:= 0;
	minimo(vec, v, reg);
	while (reg.cod <> valorAlto) do begin
		cod_actual := reg.cod;
		read(mae, regM);	
		writeln(cod_actual);
		if (auxLoc > 50) then cantidad:= cantidad + 1;
		auxLoc:= 0;
		while (reg.cod = cod_actual) do begin
			cepa_actual := reg.cepa;
			totalFallecidos:= 0;
			totalRecuperados:= 0;
			while (reg.cod = cod_actual) and (reg.cepa = cepa_actual) do begin
				totalFallecidos:= totalFallecidos + reg.fallecidos;
				totalRecuperados:= totalRecuperados + reg.recuperados;
				regM.activos := regM.activos + reg.activos;
				regM.nuevos := regM.nuevos + reg.nuevos;
				minimo(vec, v, reg);
			end;
			
			while (cod_actual <> regM.cod) do begin
				if (regM.activos > 50) then cantidad:= cantidad + 1;
				read(mae, regM);
			end;
			seek(mae, filepos(mae)-1);
			auxLoc:= auxLoc + regM.activos;
			regM.fallecidos:= totalFallecidos;
			regM.recuperados:= totalRecuperados;
			write(mae, regM);
			writeln();
		end;
	end;
	for i:= 1 to DF do
		close(vec[i]);
	close(mae);
end;
Procedure leerM (var mae: maestro; var reg: localidad);
begin
	if (not eof(mae)) then 
		read(mae, reg)
	else
		reg.cod:= valorAlto;
end;
Procedure imprimirMaestro(var mae: maestro);
var
	reg: localidad;
	cod_actual: LongInt;
begin
	reset(mae);
	writeln;
	writeln('--------------- IMPRIMO MAESTRO --------------');
	writeln;
	leerM(mae, reg);
	while (reg.cod <> valorAlto) do begin
		writeln('LOCALIDAD: ',reg.nombre,' ', reg.cod);
		cod_actual := reg.cod;
		while (cod_actual = reg.cod) do begin
			writeln('CEPA: ',reg.nombreCepa,' ',reg.cepa);
			writeln('CASOS ACTIVOS: ',reg.activos);
			writeln('CASOS NUEVOS: ',reg.nuevos);
			writeln('TOTAL DE FALLECIDOS: ',reg.fallecidos);
			writeln('TOTAL DE RECUPERADOS : ',reg.recuperados);
			leerM(mae, reg);
		end;
	end;
	close(mae);
end;		
Procedure menu();
var
	mae: maestro;
	vecD : vecDetalles;
	v: vecMinimo;
	opt, cantidad: integer;
begin
	writeln('Elija una opcion');
	writeln('1. Crear detalles');
	writeln('2. Crear maestro');
	writeln('3. Actualizar maestro');
	writeln('4. Informar la cantidad de cepas con mas de 50 casos activos');
	writeln('5. Imprimir maestro');
	writeln('6. Salir');
	readln(opt);
	assign(mae,'maestroPseis');
	assign(vecD[1],'detalle1');
	assign(vecD[2],'detalle2');
	assign(vecD[3],'detalle3');
	while (opt <> 6) do begin
		case opt of
			1: 
				crearDetalles(vecD);
			2:
				crearMaestro(mae);
			3:
				actualizarMaestro(mae, vecD, v, cantidad);
			4:
				writeln('El total de localidades con mas de 50 casos activos es: ',cantidad);
			5:
				imprimirMaestro(mae);
			6:
				writeln('Saliendo del programa');
			else
				writeln('Opcion no valida');
			end;
		writeln('Elija una opcion');
		writeln('1. Crear detalles');
		writeln('2. Crear maestro');
		writeln('3. Actualizar maestro');
		writeln('4. Informar la cantidad de cepas con mas de 50 casos activos');
		writeln('5. Imprimir maestro');
		writeln('6. Salir');
		readln(opt);
	end;
end;
Begin
	menu();
End.
