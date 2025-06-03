{13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.
a. Realice el procedimiento necesario para actualizar la información del log en un
día particular. Defina las estructuras de datos que utilice su procedimiento.
b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema. Considere la implementación de esta opción de las
siguientes maneras:
i- Como un procedimiento separado del punto a).
ii- En el mismo procedimiento de actualización del punto a). Qué cambios
se requieren en el procedimiento del punto a) para realizar el informe en
el mismo recorrido?}
Program tp2e13;
Const
	valorAlto = 999999;
Type
	logs = record
		nro: LongInt;
		nombreUsuario: String;
		nombre: String;
		apellido: String;
		emails: integer;
	end;
	
	enviados = record
		nro: LongInt;
		cuentaDestino: String;
		cuerpoMensaje: String;
	end;
	
	maestro = file of logs;
	detalle = file of enviados;
procedure crearMaestro(var mae: maestro);
var
    carga: text;
    nombre: string;
    infoMae:logs;
begin
    assign(carga, 'logmail.txt');
    reset(carga);
    writeln('Ingrese un nombre para el archivo maestro');
     nombre := 'ArchivoMaestro';
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with infoMae do
                begin
                    readln(carga, nro, emails, nombreUsuario);
                    readln(carga, nombre);
                    readln(carga, apellido);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
procedure crearDetalle(var det: detalle);
var
    carga: text;
    nombre: string;
    infoDet: enviados;
begin
    assign(carga, 'detalle.txt');
    reset(carga);
    writeln('Ingrese un nombre para el archivo detalle');
    nombre := 'ArchivoDetalle';
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with infoDet do
                begin
                    readln(carga, nro, cuentaDestino);
                    readln(carga, cuerpoMensaje);
                    write(det, infoDet);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;	
Procedure leer(var mae: maestro; var reg: logs);
begin
	if (not(eof(mae))) then
		read(mae, reg)
	else
		reg.nro:= valorAlto;
end;
Procedure leerD(var det: detalle; var reg: enviados);
begin
	if (not(eof(det))) then
		read(det, reg)
	else
		reg.nro:= valorAlto;
end;
Procedure actualizarMaestro (var mae: maestro; var det: detalle);
var
	regD: enviados;
	regM: logs;
	us_actual: LongInt;
	cant: integer;
begin
	reset(mae);
	reset(det);
	
	leer(mae, regM);
	leerD(det, regD);
	writeln('leo mae');
	while (regM.nro <> valorAlto) do begin
		us_actual := regM.nro;
		cant:= 0;
		
		while (regD.nro = us_actual) do begin
			writeln(regD.nro);
			cant := cant + 1;
			leerD(det, regD);
		end;
		regM.emails := regM.emails + cant;
		writeln('Usuario ',us_actual,' ha enviado ',regM.emails,' mensajes');
		seek(mae, filepos(mae)-1);
		write(mae, regM);
		leer(mae, regM);
		writeln('leo mae');
	end;
	writeln('Archivo maestro actualizado!');
	close(mae);
	close(det);
end;
Procedure imprimirMaestro(var mae: maestro);
var
	reg: logs;
begin
	reset(mae);
	leer(mae, reg);
	while (reg.nro <> valorAlto) do begin
		writeln('NRO: ',reg.nro,' ',reg.nombre);
		writeln('APELLIDO: ',reg.apellido);
		writeln('enviados: ',reg.emails);
		leer(mae, reg);
	end;
	close(mae);
end;
Var
	mae: maestro;
	det: detalle;
Begin
	//assign(mae, '/var/log/logmail.dat');
	assign(mae, 'ArchivoMaestro');
	assign(det, 'ArchivoDetalle');
	crearMaestro(mae);
	crearDetalle(det);
	imprimirMaestro(mae);
	writeln();
	writeln('--------------------------');
	actualizarMaestro(mae, det);
	writeln();
	writeln();
	writeln('--------------------------');
	imprimirMaestro(mae);
End.
