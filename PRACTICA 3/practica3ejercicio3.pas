{Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a), se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de “enlace” de la lista (utilice el código de
novela como enlace), se debe especificar los números de registro
referenciados con signo negativo, . Una vez abierto el archivo, brindar
operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}

Program practica3ejercicio3;
Const
	valorAlto = 999999;
Type
	novelas = record
		codigo: LongInt;
		genero: String;
		nombre: String;
		duracion: real;
		director: String;
		precio: real;
	end;
	
	archivo = file of novelas;
Procedure leerRegistro (var reg: novelas);
begin
	with reg do begin
		readln(codigo);
		if (codigo <> 0) then begin
			readln(genero);
			readln(nombre);
			readln(duracion);
			readln(director);
			readln(precio);
		end;
	end;
end;
Procedure leerArchivo (var arc: archivo; var reg: novelas);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.codigo := valorAlto;
end; 

Procedure crearArchivo (var arc: archivo);
var
	reg, cabecera: novelas;
begin
	reset(arc);
	//cabecera
	cabecera.codigo := 0;
	write(mae, cabecera); 
	
	leerRegistro(reg);
	while (reg.codigo <> 0) do begin
		write(arc, reg);
		leerRegistro(reg);
	end;
	close(arc);
end;
Procedure darDeAlta(var arc: archivo);
var
	reg, regCabecera, auxCabecera: novelas;
	cod: LongInt;
begin
	reset(arc);
	leerRegistro(reg);
	read(arc, regCabecera);
	
	//si hay algun lugar liberado
	if (regCabecera.cod <> 0) then begin
		cod := regCabecera.cod * -1; //calculo la posicion efectiva
		seek(arc, cod);
		read(arc, regCabecera);
		seek(arc, filepos(arc)-1); //escribo el nuevo reg sobre esta posicion efectiva
		write(arc, reg);
		seek(arc, 0); //escribo en la cabecera la pos que apuntaba la 1ra baja
		//(es el enlace a la segunda baja)
		write(arc, regCabecera);
	end
	else begin
		seek(arc, filesize(mae));
		write(arc, reg);
	end;
	close(arc);
end;

Procedure modificarNovela (var arc: archivo);
var
	reg, nue: novelas;
begin
	reset(arc);
	leerRegistro(nue);
	leerArchivo(arc, reg);
	while ((reg.codigo <> valorAlto) and (reg.codigo <> nue.codigo)) do 	
		leerArchivo(arc, reg);
		
	if (reg.codigo = nue.codigo) then begin
		seek(arc, filepos(arc)-1);
		write(arc, nue);
	end;
end;
		
Procedure eliminarNovela (var arc: archivo);
var
	cabecera, reg: novelas;
	codigoBaja : LongInt;
begin
	reset(arc);
	read(arc, cabecera);
	readln(codigoBaja);
	leerArchivo(arc, reg);
	while ((reg.codigo <> valorAlto) and (reg.codigo <> codigoBaja)) do
		leerArchivo(arc, reg);
	if (reg.codigo = codigoBaja) then begin
		seek(filepos(arc) - 1);
		pos := filepos(arc) * -1;
		reg.codigo := cabecera.codigo;
		write(arc, reg);
		seek(arc, 0);
		cabecera.codigo := pos;
		write(arc, cabecera);
	end;
	else
		writeln('NO se encontro el codigo');
	close(arc);
end;

Procedure listar (var arc: archivo; var txt: text);
var
	reg: novelas;
begin
	reset(arc);
	assign(txt, 'novelas.txt');
	rewrite(txt);
	read(arc, reg); //sac0 cabecera
	
	leerArchivo(arc, reg);
	while (reg.codigo <> valorAlto) do begin
		writeln(txt, 'CODIGO: ',reg.codigo);
		{...}
	end;
	close(arc);
	close(txt);
end;
		
Procedure menu ();
Var
	opt: integer;
	arc: archivo;
	texto: text;
Begin
	writeln('----------------------- MENU DE OPCIONES -----------------');
	writeln('1. crear archivo de novelas');
	writeln('2. agregar novela');
	writeln('3. modificar novela');
	writeln('4. eliminar novela');
	writeln('5. exportar datos');
	writeln('6. salir');
	writeln('ELIJA UNA OPCION');
	readln(opt);
	
	while (opt <> 6) do begin
		case (opt) of:
			1:
				crearArchivo(arc);
			2:
				darDeAlta(arc);
			3: 
				modificarNovela(arc);
			4:
				eliminarNovela(arc);
			5:
				listar(arc, texto);
			6:
				writeln('Saliendo...');
			else
				begin
					writeln('----------------------- MENU DE OPCIONES -----------------');
					writeln('1. crear archivo de novelas');
					writeln('2. agregar novela');
					writeln('3. modificar novela');
					writeln('4. eliminar novela');
					writeln('5. exportar datos');
					writeln('6. salir');
					writeln('ELIJA UNA OPCION');
					readln(opt);
				end;
	end;
//Programa Principal	
Begin
	menu();
end.
			
