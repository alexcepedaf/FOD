{Realizar  un  programa  para  una  tienda  de  celulares,  que  presente  un  menú  con 
opciones para: 
a.  Crear un archivo de registros no ordenados de celulares y cargarlo con datos 
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros 
correspondientes  a  los celulares deben contener: código de celular, nombre, 
descripción, marca, precio, stock mínimo y stock disponible. 
b.  Listar en pantalla los datos de aquellos celulares que tengan un stock menor al 
stock mínimo. 
c.  Listar  en  pantalla  los  celulares  del  archivo  cuya  descripción  contenga  una 
cadena de caracteres proporcionada por el usuario. 
d.  Exportar el archivo creado en el inciso a) a un archivo de texto denominado 
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado 
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que 
debería respetar el formato dado para este tipo de archivos en la NOTA 2. 
 
NOTA  1:  El  nombre  del  archivo  binario  de  celulares debe ser proporcionado por el 
usuario. 
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique 
en tres  líneas consecutivas. En la primera se especifica: código de celular,  el precio y 
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera 
nombre  en  ese  orden.  Cada  celular  se  carga  leyendo  tres  líneas  del  archivo 
“celulares.txt”.}

program ej5;
type
    celular= record
        cod: integer;
        nombre: string;
        descrip: string;
        marca : string;
        precio: real;
        stock_min: integer;
        stock_dis: integer;
    end;
    archivo = file of celular;

procedure imprimirCelular(var c: celular);
begin
    with c do
        writeln('Codigo: ', cod, ' Nombre: ', nombre, ' Descripcion: ', descrip, ' Marca: ', marca, ' Precio: ', precio, ' Stock Minimo: ', stock_min, ' Stock Disponible: ', stock_dis); 
end;

procedure crearArchivo(var arc:archivo; var carga: text);
var
    c: celular;
begin
    reset(carga);
    rewrite(arc);
    while (not eof(carga)) do begin
        readln(carga, c.cod, c.precio, c.marca);
        readln(carga, c.stock_dis, c.stock_min, c.descrip);
        readln(carga, c.nombre);
        write(arc, c);
    end;    
    writeln('Archivo cargado');
    writeln('');
    close(arc);
    close(carga);
end;

procedure listarMenorStockMin(var arc: archivo);
var
    c: celular;
begin
    reset(arc);
    while (not eof(arc)) do begin
        read(arc, c);
        if (c.stock_dis < c.stock_min) then
            imprimirCelular(c);
    end;
    close(arc);
end;

procedure ListarCelularMismaDescrip(var arc: archivo);
var
    c: celular;
    descripcion: string;
begin
    reset(arc);
    writeln('Ingrese una descripcion: ');
    readln(descripcion);
    while(not eof(arc)) do begin
        read(arc, c);
        if Pos(descripcion, c.descrip) > 0 then
            imprimirCelular(c);
    end;
    close(arc);        
end;

procedure ExportarEnTexto(var arc: archivo; var txt: text);
var
    c: celular;
begin
    reset(arc);
    rewrite(txt);    
    while (not eof(arc)) do begin
        read(arc, c);
        writeln(txt,c.cod, c.precio, c.marca);
        writeln(txt, c.stock_dis, c.stock_min, c.descrip);
        writeln(txt, c.nombre);
    end;
    writeln ('Archivo exportado con exito');
    close(arc);
    close(txt);
end;

procedure menu(var arc : archivo; var arc_txt, arc_txt2 : text);
var
    opcion : char;
    nombre: string;
begin
    writeln('MENU DE OPCIONES');
    writeln('1. Crear un archivo de registros de celulares y cargarlo desde un archivo de texto denominado “celulares.txt”');
    writeln('2. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.');
	writeln('3. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.');
    writeln('4. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.');
    writeln('5. Salir del menu y terminar ejecucion');
    repeat
        writeln('Ingrese el numero de opcion: ');
        readln(opcion);
        case opcion of
            '1': begin
                writeln('Nombre del archivo a crear: ');
                readln(nombre);
                assign(arc, nombre);
                crearArchivo(arc, arc_txt);
            end;    
            '2': listarMenorStockMin(arc);
            '3': ListarCelularMismaDescrip(arc);
            '4': ExportarEnTexto(arc, arc_txt2);
        end;        
    until (opcion = '5');
end;    

var
    arc: archivo;
    txt1, txt2: text;
begin
    assign(txt1, 'celulares.txt');
    assign(txt2, 'celulares2.txt');
    menu(arc, txt1, txt2);
end.    