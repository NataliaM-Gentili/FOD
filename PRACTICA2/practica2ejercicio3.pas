{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

Program practica2ejercicio3;
Const
	valorAlto = 999999;
Type
	provincia = record
		nombre: String;
		alfabetizados: integer;
		encuestados: integer;
	end;
	
	censos = record
		nombre: String;
		codLocalidad: LongInt;
		alfabetizados: integer;
		encuestados: integer;
	end;
	
	maestro = file of provincia;
	detalle = file of censos;
	
Procedure leerDetalle (var det: detalle; var reg: censos);
begin
	if (not(eof(det))) then
		read(det, reg)
	else
		reg.codLocalidad := valorAlto;
end;

Procedure actualizarMaestro (var mae: maestro; var det1, det2: detalle);
var
	censo1, censo2: censos;
	prov: provincia;
	encuestados, alfabetizados : integer;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	
	leerDetalle(det1, censo1);
	leerDetalle(det2, censo2);
	
	while ((censo1.codLocalidad <> valorAlto) or (censo2.codLocalidad <> valorAlto)) do begin
		
		//no se sabe si ambos detalles contienen todas las provincias, guardo el nombre ""mas chico""
		if (censo1.nombre < censo2.nombre) then
			nombre_actual := censo1.nombre
		else
			nombre_actual := censo2.nombre;
		
		encuestados:= 0;
		alfabetizados:= 0;	
		while (censo1.nombre = nombre_actual) do begin
			encuestados := encuestados + censo1.encuestados;
			alfabetizados := alfabetizados + censo1.alfabetizados;
			leerDetalle(det1, censo1);
		end;
		while (censo2.nombre = nombre_actual) do begin
			encuestados := encuestados + censo1.encuestados;
			alfabetizados := alfabetizados + censo1.alfabetizados;
			leerDetalle(det2, censo2);
		end;
		
		read(mae, prov);
		while (prov.nombre <> nombre_actual) do
			read(mae, prov);
		
		seek(mae, filepos(mae)-1);
		prov.encuestados:= encuestados;
		prov.alfabetizados:= alfabetizados;
		write(mae, prov);
	end;
	
	close(mae);
	close(det1);
	close(det2);
end;
var
	mae: maestro;
	det1, det2: detalle;
begin
	crearDetalles(det1, det2); // se dispone
	crearMaestro(mae); // se dispone
	actualizarMaestro(mae, det1, det2);
end.
