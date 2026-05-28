{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.}

program ejercicio3;
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
        writeln('Ingrese el DNI del empleado (ingrese 00 si no tiene)');
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

procedure menu(var arc : archivo);
var
    opcion : char;
begin
    writeln('MENU DE OPCIONES');
	writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('2. Listar en pantalla los empleados de a uno por linea.');
	writeln('3. Listar en pantalla empleados mayores de 70 anos, proximos a jubilarse.');
	writeln ('4. Salir del menu y terminar la ejecucion del programa');
	readln (opcion);
	writeln ('');
    while (opcion <> '4') do begin
	    case opcion of
	    	'1': listarNomApeDeterminado(arc);
	    	'2': listarDeAUno (arc);
	    	'3': listarMayores (arc);
	    else 
            writeln('La opción ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
	    end;
        writeln();
        writeln('MENU DE OPCIONES');
        writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
        writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
        writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
        writeln('Opcion 4: Salir del menu y terminar la ejecucion del programa');
        readln(opcion);
    end;
end;

var
    arc : archivo;
    nombre : string[30];
begin
    writeln('Ingrese un nombre para el archivo');
    readln(nombre);
    assign(arc, nombre);
    crearArchivo(arc);
    menu(arc);
end.    
