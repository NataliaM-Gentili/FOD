//pedir correccion actualizar maestro
//¿asumo que los archivos son binarios y que ya existen o implemento las cargas?
{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}
Program tp2e3;
Type
	provincias = record
		nombre: string;
		cantAlfabetizadas: integer;
		cantEncuestados: integer;
	end;
	
	censos = record
		nombre: string;
		cod: integer;
		cantAlfabetizados: integer;
		cantEncuestados: integer
	end;
	
	maestro = file of provincias;
	detalle = file of censos;

Procedure leer (var arc: maestro; var reg: provincias);
begin
	if (not(eof(arc))) then
		read(arc, reg);
	else
		reg.nombre = 'FIN';
end;
Procedure actualizarMaestro(var mae: maestro; var det1: detalle; var det2: detalle);
var
	reg1, reg2: censos;
	datos: provincias;
begin
	reset(det1);
	reset(det2);
	reset(mae);
	leer (mae, datos);
	while (datos.nombre <> 'FIN') do begin
		auxAlfa1:= 0; auxEnc1:= 0; auxAlfa2:= 0; auxEnc2:= 0;
		while (reg1.nombre = datos.nombre) do begin
			readln(det1, reg1,cod, reg1.cantAlfabetizados, reg1.cantEncuestados, reg1.nombre);
			datos.cantAlfabetizados:= datos.cantAlfabetizados + reg1.cantAlfabetizados;
			datos.cantEncuestados:= datos.cantEncuestados + reg1.cantAlfabetizados;
			read(det1, reg1);
		end;
		while (reg2.nombre = datos.nombre) do begin
			readln(det2, reg2,cod, reg2.cantAlfabetizados, reg2.cantEncuestados, reg2.nombre);
			datos.cantAlfabetizados:= datos.cantAlfabetizados + reg2.cantAlfabetizados;
			datos.cantEncuestados:= datos.cantEncuestados + reg2.cantAlfabetizados;
			read(det2, reg2);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, datos);
		leer(mae, datos);
	end;
	actualizarMaestro(mae, det1, det2);
	writeln('Maestro actualizado!');
	close(det1);
	close(det2);
	close(mae);
end;
