{Realizar un algoritmo, que utilizando el archivo de n�meros enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de n�meros menores a 1500 y el
promedio de los n�meros ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una �nica vez. Adem�s, el algoritmo deber� listar el
contenido del archivo en pantalla.}

program ejercicio2;
type
   archivo = file of integer;

procedure mostrarPantalla(var arch_num : archivo; var cantM,cant : integer; var prom: real);
var
   num : integer;
begin
   reset(arch_num);
   while (not eof(arch_num)) do begin
      cant := cant + 1;
      read(arch_num,num);
      prom := prom + num;
      if (num < 1500) then
         cantM := cantM + 1;
      writeln(num);
   end;
   close(arch_num);
end;

var
   arch_num : archivo;
   nombre_fisico : string[50];
   cant, cantM : integer;
   promedio : real;
begin
   cant := 0;
   cantM := 0;
   promedio := 0;
   write('Ingrese el nombre del archivo: ');
   read(nombre_fisico);
   assign(arch_num, nombre_fisico);
   mostrarPantalla(arch_num, cantM,cant,promedio);
   writeln('Cantidad de numeros menores a 1500: ', cantM);
   writeln('Promedio de los numeros ingresados: ', promedio/cant:0:2);
end.
