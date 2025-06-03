//preguntar incisoC, no toma el integer sin un espacio adelante. 
//preguntar consigna 5D
Type
	celulares= record
		cod: integer;
		nombre: String;
		desc: String;
		marca: String;
		precio: real;
		stockMin: integer;
		stockDisp: integer;
	end;
	
	file_record= file of celulares;
Procedure leer(var Fw: file_record; var reg: celulares; var ok: boolean);
begin
	ok:= false;
	if (not eof(Fw)) then read(Fw, reg)
	else ok:= true;
end;
//------------------ IMPRIMO CELULAR ---------------------------	
Procedure imprimir(var reg: celulares);
begin
	with reg do begin
		writeln('CODIGO: ',cod);
		writeln('NOMBRE: ',nombre);
		writeln('DESC: ',desc);
		writeln('MARCA: ',marca);
		writeln('PRECIO: ',precio);
		writeln('STOCK MINIMO: ',stockMin);
		writeln('STOCK DISPONIBLE: ',stockDisp);
		writeln;
	end;
end;
//-------------- LEER CAMPOS DE UN REGISTRO --------------------	
Procedure leerDatos(var reg: celulares);
begin
	with reg do begin
		writeln('CODIGO: ');
		readln(cod);
		writeln('NOMBRE: ');
		readln(nombre);
		writeln('DESCRIPCION: ');
		readln(desc);
		writeln('MARCA: ');
		readln(marca);
		writeln('PRECIO: ');
		readln(precio);
		writeln('STOCK MINIMO: ');
		readln(stockMin);
		writeln('STOCK DISPONIBLE: ');
		readln(stockDisp);
	end;
end;
// ------------------------- INCISO A ------------------------
Procedure incisoA(var Fw: file_record; var carga: text);
var
	reg: celulares;
	nombre_fisico: string;
begin
	writeln('Ingrese el nombre del archivo que desea crear');
	readln(nombre_fisico);
	assign(Fw, nombre_fisico);
	rewrite(Fw);
	reset(carga);
	while (not eof(carga)) do begin
		with reg do begin
			readln(carga, cod, precio, marca);
			readln(carga, stockDisp, stockMin, desc);
			readln(carga, nombre);
			write(Fw, reg);
		end;
	end;
	writeln('Archivo BINARIO cargado');
	close(Fw); close(carga);
end;
//------------------ INCISO B ----------------------
Procedure incisoB(var Fw: file_record);
var
	reg: celulares;
	okey: boolean;
begin
	reset(Fw);
	okey:= false;
	leer(Fw, reg, okey);
	writeln('-----------------------------------------------------------');
	writeln;
	writeln('-- CELULARES CON STOCK DISPONIBLE MENOR AL STOCK MINIMO --');
	writeln;
	writeln;
	while (not okey) do begin
		writeln(reg.stockDisp, reg.stockMin);
		if (reg.stockDisp < reg.stockMin) then begin
			writeln;
			imprimir(reg);
		end;
		leer(Fw, reg, okey);
	end;
	close(Fw);
end;
////////////// NO TOMA STRING DESC /////////////////////////
//----------------------- INCISO C --------------------------	
Procedure incisoC(var Fw: file_record);
var
	reg: celulares;
	desc: string;
	okey: boolean;
	coinc: integer;
begin
	coinc:= 0;
	reset(Fw);
	writeln('Ingrese la descripcion que desea buscar');
	readln(desc);
	desc := ' '+ desc;
	leer(Fw, reg, okey);
	while (not okey) do begin
		if (reg.desc = desc) then begin
			imprimir(reg);
			coinc:= coinc + 1 ;
		end;
		leer(Fw, reg, okey);
	end;
	writeln('COINCIDENCIAS: ',coinc);
	close(Fw);
end;
/////////////////// PREGUNTAR D //////////////////////////////
//---------------------- INCISO D ---------------------------
Procedure incisoD (var Fw: file_record);
var 
	reg: celulares;
	txt: text;
	okey:boolean;
begin
	reset(Fw);
	okey:= false;
	assign(txt, 'celulares.txt');
	rewrite(txt);
	leer(Fw, reg, okey);
	while (not okey) do begin
		with reg do begin
			writeln(txt, cod, precio:0:2, marca);
			writeln(txt, stockDisp, stockMin, desc);
			writeln(txt, nombre);
		end;
		leer(Fw, reg, okey);
	end;
	close(Fw);
	close(txt);
end;
//-------------------------- 6 A ---------------------------
Procedure incisoE (var Fw: file_record);
var
	nuevo: celulares;
	reg: celulares;
	okey, encontre: boolean;

begin
	reset(Fw);
	encontre:= false;
	leerDatos(nuevo);
	leer(Fw, reg, okey);
	while ((not okey) and (not encontre)) do begin
			if (nuevo.cod = reg.cod) then encontre:= true
			else leer(Fw, reg, okey);
	end;
	if (not encontre) then begin
		seek(Fw, fileSize(Fw));
		write(Fw, nuevo);
	end;
	close(Fw);
end;	
Procedure incisoF (var Fw: file_record);
var
	reg: celulares;
	okey, encontre:boolean;
	cod,opt, stock: integer;
begin
	reset(Fw);
	encontre:= false;
	writeln('Ingrese el codigo de celular del cual desea modificar el stock');
	readln(cod);
	leer(Fw, reg, okey);
	while ((not okey) and (not encontre)) do begin
		if (reg.cod = cod) then begin
			encontre:= true;
			writeln('Celular encontrado!');
			writeln('Seleccione "1" para SUMAR el stock, o seleccione "2" para REEMPLAZARLO');
			readln(opt);
			writeln('Ingrese el stock');
			readln(stock);
			if (opt = 1) then begin
					reg.stockDisp := reg.stockDisp + stock;
					write(Fw, reg);
					writeln('Stock sumado! Total: ',reg.stockDisp);
			end
			else begin
				reg.stockDisp := stock;
				write(Fw, reg);
				writeln('Stock reemplazado!');
			end;
		end
		else leer(Fw, reg, okey);
	end;
	if (okey) then writeln('No se encontraron celulares con ese numero');
	close(Fw);
end;
Procedure IncisoG (var FW: file_record);
begin
	writeln('Hola');
end;
//////////////// PROGRAMA PRINCIPAL ////////////////////
Var
		File_phones: file_record;
		cel : text;
		opt, num: integer;
		termine: boolean;
Begin
	termine:= false;

	writeln('Bienvenido al programa! Qué deseas hacer? Por favor, elige una opcion :) ');
	while (not termine) do begin
		writeln('1. Crear un archivo cargado con datos de celulares');
		writeln('2. Ver celulares con stock minimo menor al minimo');
		writeln('3. Ver celulares con descrpcion');
		writeln('4. Exportar los celulares en formato txt');
		writeln('5. Agregar celulares');
		writeln('6. Modificar stock');
		writeln('7. Exportar de tipo text');
		writeln('Por favor, elija un numero: ');
		readln(opt);
		writeln;
		
		case opt of
			1: begin
				assign(cel, 'celulares - copia.txt');
				incisoA(File_phones,cel);
			end;
			2:
				incisoB(File_phones);
			3:
				incisoC(File_phones);
			4: 
				incisoD(File_phones);
			5:
				incisoE(File_phones);
			6:
				incisoF(File_phones);
			7:
				incisoG(File_phones);
			else
				writeln('Por favor seleccione una opción válida');
		end;
		writeln('Desea realizar otra operacion?');
		writeln('1. Si / 2. No');
		readln(num);
		if (num = 2) then termine := true;
		writeln;
	end;
end.
