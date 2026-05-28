{Agregar al menú del programa del ejercicio 5, opciones para: 
a.  Añadir  uno  o  más  celulares  al final del archivo con sus datos ingresados por 
teclado. 
b.  Modificar el stock de un celular dado. 
c.  Exportar el contenido del archivo binario a un archivo de texto denominado: 
”SinStock.txt”, con aquellos celulares que tengan stock 0. 
 
NOTA: Las búsquedas deben realizarse por nombre de celular.}

program ej6;
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
    nombre: string;
begin
    writeln('Nombre del archivo a crear: ');
    readln(nombre);
    assign(arc, nombre);
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

procedure leerCelular(var c: celular);
begin
    writeln('Ingrese el codigo del celular');
    readln(c.cod);
    if(c.cod <> 0) then
        begin
            writeln('Ingrese el nombre del celular');
            readln(c.nombre);
            writeln('Ingrese la descripcion del celular');
            readln(c.descrip);
            writeln('Ingrese la marca del celular');
            readln(c.marca);
            writeln('Ingrese el precio del celular');
            readln(c.precio);
            writeln('Ingrese el stock minimo del celular');
            readln(c.stock_min);
            writeln('Ingrese el stock del celular');
            readln(c.stock_dis);
        end;
end;

procedure agregarCelulares(var arc: archivo);
var
    c: celular;
begin
    reset(arc);
    seek(arc,fileSize(arc));
    leerCelular(c);
    while(c.cod <> 0) do begin
        write(arc,c); 
        leerCelular(c);
    end;
    close(arc);   
end;    

procedure ModificarStock(var arc: archivo);
var
    nombre: string;
    stockNuevo : integer;
    c: celular;
    encontre : boolean;
begin
    reset(arc);
    writeln('Ingrese el nombre del celular a modificar');
    readln(nombre);
    encontre := false;
    while (not eof(arc)) and not(encontre) do begin
        read(arc, c);
        if (c.nombre = nombre) then begin
            encontre := true;
            writeln('Ingrese el nuevo stock del celular');
            readln(stockNuevo);
            c.stock_dis := stockNuevo;
            seek(arc, filePos(arc)-1);
            write(arc, c);
        end;
    end;
    if (encontre) then
        writeln('Se modificó el stock del celular llamado: ', nombre)
    else
        writeln('No se halló el celular llamado: ', nombre);
    close(arc);
end;

procedure exportarSinStock(var arc: archivo; var sinStock: text);
var
    c: celular;
begin
    reset(arc);
    rewrite(sinStock);
    while (not eof(arc)) do begin 
        read(arc, c);
        if (c.stock_dis = 0) then
            with c do
                begin
                    writeln(sinStock, cod, ' ', precio:0:2, ' ', marca);
                    writeln(sinStock, stock_dis, ' ', stock_min, ' ', descrip);
                    writeln(sinStock, nombre);
                end;
    end;
    close(arc);
    close(sinStock);    
end;

procedure menu(var arc : archivo; var arc_txt, arc_txt2,sinStock : text);
var
    opcion : char;
begin
    writeln('MENU DE OPCIONES');
    writeln('1. Crear un archivo de registros de celulares y cargarlo desde un archivo de texto denominado “celulares.txt”');
    writeln('2. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.');
	writeln('3. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.');
    writeln('4. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.');
    writeln('5: Agregar uno o mas celulares al final del archivo');
    writeln('6: Modificar el stock de un celular dado');
    writeln('7: Exportar el contenido del archivo binario a un archivo de texto denominado: SinStock.txt, con aquellos celulares que tengan stock 0');
    writeln('8: Salir del menu y terminar la ejecucion del programa');
    repeat
        writeln('Ingrese el numero de opcion: ');
        readln(opcion);
        case opcion of
            '1': crearArchivo(arc, arc_txt);   
            '2': listarMenorStockMin(arc);
            '3': ListarCelularMismaDescrip(arc);
            '4': ExportarEnTexto(arc, arc_txt2);
            '5': agregarCelulares(arc);
            '6': ModificarStock(arc);
            '7': exportarSinStock(arc, sinStock);
        end;        
    until (opcion = '8');
end;    

var
    arc: archivo;
    txt1, txt2, sinStock: text;
begin
    assign(txt1, 'celulares.txt');
    assign(txt2, 'celulares2.txt');
    assign(sinStock, 'SinStock.txt');
    menu(arc, txt1, txt2, sinStock);
end.    