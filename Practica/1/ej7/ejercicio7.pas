{Realizar un programa que permita: 
a) Crear un archivo binario a partir de la información almacenada en un archivo de 
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el 
archivo de texto consiste en: código de novela, nombre, género y precio de 
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos 
líneas en el archivo de texto. La primera línea contendrá la siguiente información: 
código novela, precio y género, y la segunda línea almacenará el nombre de la 
novela. 
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder 
agregar una novela y modificar una existente. Las búsquedas se realizan por 
código de novela. 
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}

program ej7;
type 
    novela = record
        codigo: integer;
        precio: real;
        genero: string;
        nombre: string;
    end;
    archivo = file of novela;

procedure leerOtrosCampos(var nov: novela);
begin
    writeln('Ingrese un nombre de novela');
    readln(nov.nombre);
    writeln('Ingrese un genero de novela');
    readln(nov.genero);
    writeln('Ingrese un precio de novela');
    readln(nov.precio);
end;
procedure leerNovela(var nov: novela);
begin
    writeln('Ingrese un codigo de novela');
    readln(nov.codigo);
    if(nov.codigo <> 0 ) then
        begin
            leerOtrosCampos(nov);
        end;
end;

procedure crearArchivo(var arc:archivo; var carga: text);
var
    n: novela;
    nombre: string;
begin
    writeln('Nombre del archivo a crear: ');
    readln(nombre);
    assign(arc, nombre);
    reset(carga);
    rewrite(arc);
    while (not eof(carga)) do begin
        readln(carga, n.codigo, n.precio, n.genero);
        readln(carga, n.nombre);
        write(arc, n);
    end;    
    writeln('Archivo cargado');
    writeln('');
    close(arc);
    close(carga);
end;

procedure agregarNovela(var arc: archivo);
var
    n: novela;
begin
    reset(arc);
    seek(arc,fileSize(arc));
    leerNovela(n);
    while(n.codigo <> 0) do begin
        write(arc,n); 
        leerNovela(n);
    end;
    close(arc);   
end;  

procedure modificarNovela(var arc: archivo);
var
    cod: integer;
    encontre: boolean;
    n: novela;
begin
    reset(arc);
    writeln('Ingrese el codigo de la novela a modificar');
    readln(cod);
    encontre := false;
    while (not eof(arc)) and not(encontre) do begin
        read(arc, n);
        if (n.codigo = cod) then begin
            encontre := true;
            leerOtrosCampos(n);
            seek(arc, filePos(arc)-1);
            write(arc, n);
        end;
    end;
    if (encontre) then
        writeln('Se modificó la novela con codigo: ', cod)
    else
        writeln('No se halló la novela con codigo: ', cod);
    close(arc);
end;    

procedure imprimirNovela(var n: novela);
begin
    with n do begin
        writeln('Codigo: ', codigo, ' Precio: ', precio:0:2, ' Genero: ', genero);
        writeln('Nombre: ', nombre); 
    end;    
end;

procedure mostrarPantalla (var arc:archivo);
var
	n:novela;
begin
	reset (arc);
	while not eof (arc) do begin
		read (arc,n);
		imprimirNovela (n);
	end;
	close (arc);
end;


procedure menu(var arc : archivo);
var
    opcion : char;
    txt: text;
begin
    assign(txt, 'novelas.txt');
    writeln('MENU DE OPCIONES');
    writeln('1. Crear un archivo de novelas a partir de la información almacenada en un archivo de texto "novelas.txt".');
    writeln('2. Agregar una novela');
    writeln('3. Modificar una novela existente');
    writeln('4. Imprimir en pantalla el contenido del archivo');
    writeln('5: Salir del menu y terminar la ejecucion del programa');
    repeat
        writeln('Ingrese el numero de opcion: ');
        readln(opcion);
        case opcion of
            '1': crearArchivo(arc, txt);   
            '2': agregarNovela(arc);
            '3': modificarNovela(arc);
            '4': mostrarPantalla(arc);
        end;
    until(opcion = '5');
end;

var
    arc: archivo;
begin
    menu(arc);
end.    