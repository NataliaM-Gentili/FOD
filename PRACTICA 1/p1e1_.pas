program p1e1_;
type
    archivo_numeros = file of integer;
var
    numeros: archivo_numeros;
    nombre_fisico: string[12];
    num: integer;
begin
     write('Ingrese el nombre que desea colocarle al archivo: ');
     readln(nombre_fisico);
     assign(numeros, nombre_fisico);
     rewrite(numeros);

     writeln('Ingrese los numeros que desee almacenar ');
     writeln('Finalice la lectura con 30000 ');
     readln(num);
     while (num <> 30000) do begin
           write(numeros, num);
           writeln('Ingrese el siguiente numero');
           readln(num);
     end;
     close(numeros);
end.

