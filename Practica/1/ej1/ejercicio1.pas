{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.}

program ejercicio1;

type
    archivo = file of integer;

var 
    numeros : archivo;
    nombre_fisico : string[20];
    num : integer;
begin
    writeln('Ingrese el nombre del archivo: ');
    read(nombre_fisico);
    assign(numeros, nombre_fisico);
    rewrite(numeros);
    writeln('Ingrese un numero entero');
    read(num);
    while (num <> 30000) do begin
        write(numeros,num);
        writeln('Ingrese un numero entero');
        read(num);
    end;
    close(numeros);    
end.
