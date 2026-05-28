{Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar la edad de un empleado dado.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado}

program ejercicio4;
type 
    empleado = record
        nro : integer;
        apellido : string[20];
        nombre: string[20];
        edad : integer;
        dni : integer;
    end;
    archivo = file of empleado;

procedure leerEmpleado(var e: empleado);
begin
    writeln('Ingrese el apellido del empleado: ');
    readln(e.apellido);
    if e.apellido <> 'fin' then begin
        writeln('Ingrese el nro del empleado');
        readln(e.nro);
        writeln('Ingrese el nombre del empleado');
        readln(e.nombre);
        writeln('Ingrese la edad del empleado');
        readln(e.edad);
        writeln('Ingrese el DNI del empleado');
        readln(e.dni);
    end;
end;

procedure imprimir(e: empleado);
begin
    writeln('Numero=', e.nro, ' Apellido=', e.apellido, ' Nombre=', e.nombre, ' Edad=', e.edad, ' DNI=', e.dni);    
end;

procedure crearArchivo(var arc: archivo);
var
    e : empleado;
begin
    rewrite(arc);
    leerEmpleado(e);
    while (e.apellido <> 'fin') do begin
        write(arc, e);
        leerEmpleado(e);
    end;
    close(arc);    
end;

procedure listarNomApeDeterminado(var arc: archivo);
var
    nom_ape: string[30];
    e : empleado;
begin
    reset(arc);
    writeln('Ingrese un nombre o un apellido determinado: ');
    readln(nom_ape);
    while not eof(arc) do begin
        read(arc, e);
        if (e.apellido = nom_ape) or (e.nombre = nom_ape) then begin
            imprimir(e);
        end;
    end;
    close(arc);
end;

procedure listarDeAUno(var arc: archivo);
var
    e : empleado;
begin
    reset(arc);
    while not eof(arc) do begin
        read(arc, e);
        imprimir(e);
    end;
    close(arc);
end;

procedure listarMayores(var arc: archivo);
var
    e : empleado;
begin
    reset(arc);
    while not eof(arc) do begin
        read(arc, e);
        if (e.edad> 70) then begin
            imprimir(e);
        end;
    end;
    close(arc);        
end;

function controlUnicidad(var arc: archivo; numero: integer):boolean;
var
    e: empleado;
    repetido: boolean;
begin    
    repetido:= false;
    while (not eof(arc)) and (not repetido) do begin
        read(arc, e);
        if (e.nro = numero) then
            repetido := true;
    end;
    controlUnicidad := repetido;
end;             

procedure agregarEmpleado(var arc: archivo);
var
    e: empleado;
begin
    reset(arc);
    leerEmpleado(e);
    while(e.apellido <> 'fin') do begin
        if (not(controlUnicidad(arc,e.nro))) then begin
            seek(arc,fileSize(arc));
            write(arc,e); 
        end;
        leerEmpleado(e);
    end;
    close(arc);   
end;    

procedure modificarEdad(var arc: archivo);
var
    num, edad : integer;
    e: empleado;
    encontre : boolean;
begin
    reset(arc);
    writeln('Ingrese el numero del empleado');
    readln(num);
    encontre := false;
    while (not eof(arc)) and not(encontre) do begin
        read(arc, e);
        if (e.nro = num) then begin
            encontre := true;
            writeln('Ingrese la nueva edad del empleado');
            readln(edad);
            e.edad := edad;
            seek(arc, filePos(arc)-1);
            write(arc, e);
        end;
    end;
    if (encontre) then
        writeln('Se modificó la edad del empleado con numero: ', num)
    else
        writeln('No se halló al empleado con numero: ', num);
    close(arc);
end;

procedure exportarTodosEmpleados(var arc: archivo; var todos_emp: text);
var
    e: empleado;
begin
    reset(arc);
    rewrite(todos_emp);
    while (not eof(arc)) do begin 
        read(arc, e);
        writeln(todos_emp, '|NRO: ',e.nro:10,'|EDAD: ',e.edad:10,'|DNI: ',e.dni:10,'|APELLIDO: ',e.apellido:10,'|NOMBRE: ',e.nombre:10);
    end;
    close(arc);
    close(todos_emp);    
end;

procedure exportarEmpleadosSinDNI(var arc: archivo; var sinDni: text);
var
    e: empleado;
begin
    reset(arc);
    rewrite(sinDni);
    while (not eof(arc)) do begin 
        read(arc, e);
        if (e.dni = 00) then
            writeln(sinDni, '|NRO: ',e.nro:10,'|EDAD: ',e.edad:10,'|DNI: ',e.dni:10,'|APELLIDO: ',e.apellido:10,'|NOMBRE: ',e.nombre:10);
    end;
    close(arc);
    close(sinDni);    
end;

procedure menu(var arc : archivo; var todos_emp: text; var sinDni: text);
var
    opcion : char;
begin
    writeln('MENU DE OPCIONES');
	writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('2. Listar en pantalla los empleados de a uno por linea.');
	writeln('3. Listar en pantalla empleados mayores de 70 anos, proximos a jubilarse.');
    writeln('4. Añadir uno o más empleados al final del archivo con sus datos ingresados.');
    writeln('5. Modificar la edad de un empleado dado.'); 
    writeln('6. Exportar el contenido del archivo a un archivo de texto llamado todos_empleados.txt'); 
    writeln('7. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI');
	writeln ('8. Salir del menu y terminar la ejecucion del programa');
	writeln ('');
    repeat
        writeln('Ingrese el numero de opcion');
	    readln (opcion);
        case opcion of
	    	'1': listarNomApeDeterminado(arc);
	    	'2': listarDeAUno (arc);
	    	'3': listarMayores (arc);
            '4': agregarEmpleado(arc);
            '5': modificarEdad(arc);
            '6': exportarTodosEmpleados(arc, todos_emp);
            '7': exportarEmpleadosSinDNI(arc, sinDni);
	    else 
            writeln('La opción ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
	    end;
        writeln();
    until (opcion = 8);
end;

var
    arc : archivo;
    nombre : string[30];
    todos_emp, sinDni: text;
begin
    writeln('Ingrese un nombre para el archivo');
    readln(nombre);
    assign(arc, nombre);
    assign(todos_emp, 'todos_empleados.txt');
    assign(sinDni, 'faltaDNIEmpleado.txt');
    crearArchivo(arc);
    menu(arc, todos_emp, sinDni);
end.    
