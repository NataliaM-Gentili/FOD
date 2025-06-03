Program ejercicioParcial;
Const
	valorAlto = 99999;
Type
	productos = record
		codigo: LongInt;
		nombre: String;
		desc: String;
		compra: real;
		venta: real;
		ubicacion: String;
	end;
	
	archivo = file of productos;
	
procedure leerProducto(var reg: productos);
begin
	with reg do begin
		readln(codigo);
		readln(nombre);
		readln(desc);
		readln(compra);
		readln(venta);
		readln(ubicacion);
	end;
end;
procedure agregarProducto (var a: archivo);
var
	reg: productos;
	
begin
	reset(a);
	leerProducto(reg); //asumo que la funcion no abre el archivo
	if (not (existeProducto(a, reg)) then begin
		read(a, cabecera);
		if (cabecera.cod = 0) then begin
			seek(a, filesize(a));
			write(a, reg);	
		end
		else begin
			seek(a, cabecera.cod * -1);
			read(a, cabecera);
			seek(a, filepos(a)-1);
			write(a, reg);
			seek(a, 0);
			write(a, cabecera); //siguiente liberado
		end;
	else
		writeln('El producto ya existe!');
	close(a);
end;
procedure quitarProducto(var a: archivo);
var
	reg, cabecera: productos;
	cod: LongInt;
begin
	reset(a);
	writeln('Ingrese codigo a eliminar');
	readln(cod);
	read(a, cabecera);
	reg.codigo:= cod;
	if (existeProducto(a, reg)) then begin
		//no seria necesario hacer el leerArchivo
		read(a, reg);
		while (reg.codigo <> cod)) do 
			read(a, reg);
		seek(a, filepos(a)-1);
		pos := filepos(a) * -1;
		write(a, cabecera);
		reg.codigo := pos;
		seek(a, 0);
		write(a, reg);
	end;
	else
		writeln('El producto no existe!');
	close(a);
end;
var
	a: archivo;
begin
	agregarProducto(a);
	quitarProducto(a);
end.
	
