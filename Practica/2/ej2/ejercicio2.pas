{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock 
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los 
productos que comercializa. De cada producto se maneja la siguiente información: código de 
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se 
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De 
cada  venta  se  registran:  código  de  producto  y  cantidad  de  unidades  vendidas.  Se  pide 
realizar un programa con opciones para: 
a.  Actualizar el archivo maestro con el archivo detalle, sabiendo que: 
●  Ambos archivos están ordenados por código de producto. 
●  Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del 
archivo detalle. 
●  El archivo detalle sólo contiene registros que están en el archivo maestro. 
b.  Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo 
stock actual esté por debajo del stock mínimo permitido.}

program ej2;
const
    VA= 9999;
type
    producto = record
        codigo: integer;
        nombre: string[30];
        precio: real;
        stockA: integer;
        stockMin: integer;
    end;

    maestro = file of producto;

    venta = record
        codigo : integer;
        cantUvendidas: integer;
    end;

    detalle = file of venta;

procedure leer(var det: detalle; var v: venta);                
begin
    if not eof(det) then
        read(det, v)
    else
        v.codigo := VA;    
end;

procedure actualizarMaestro(var mae: maestro; var det: detalle);
var
    p: producto;
    v: venta;
    aux,total : integer;
begin
    reset(mae);
    reset(det);
    read(mae, p);
    leer(det,v);
    while(v.codigo <> VA) do begin
        aux := v.codigo;
        total := 0;
        while (v.codigo <> VA) and(aux = v.codigo) do begin
            total := total + v.cantUvendidas;
            leer(det, v);
        end;
        while (p.codigo <> aux) do
            read (mae, p);
        p.stockA := p.stockA - total;
        seek(mae, filePos(mae)-1);
        write(mae, p);
        if (not(EOF(mae))) then
            read(mae, p);
    end;
    close(mae);
    close(det);    
end;

procedure exportarMinStockTxt(var mae: maestro);
var
    txt: text;
    p: producto;
begin
    assign(txt, 'stock_minimo.txt');
    reset(mae);
    rewrite(txt);
    while (not eof(mae)) do begin
        read(mae, p);
        if (p.stockA < p.stockMin) then
            writeln(txt, p.codigo, ' ', p.nombre, ' ', p.precio, ' ', p.stockA, ' ', p.stockMin);
    end;
    close(mae);
    close(txt);
end;    

procedure crearMaestro(var mae: maestro);
var
    p: producto;
    carga: text;
begin
    assign(carga, 'maestro.txt');
    assign(mae, 'archivoMaestro');
    reset(carga);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            readln(carga, p.codigo, p.nombre, p.precio, p.stockA, p.stockMin);  
            write(mae, p);
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;

procedure crearDetalle(var det: detalle);
var
    v: venta;
    carga: text;
begin
    assign(carga, 'detalle.txt');
    assign(det, 'archivoDetalle');
    reset(carga);
    rewrite(det);
    while(not eof(carga)) do begin
        readln(carga, v.codigo, v.cantUvendidas);
        write(det, v);
    end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;

procedure imprimirMaestro(var mae: maestro);
var
    p: producto;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, p);
            with p do
                writeln('Codigo=', codigo, ' Precio=', precio:0:2, ' StockActual=', stockA, ' StockMin=', stockMin, ' Nombre=', nombre);
        end;
    close(mae);
end;

procedure menu(var mae: maestro; var det: detalle);
var
    opcion: char;
begin
    repeat 
        writeln('MENU DE OPCIONES');
        writeln('1. Generar archivos binarios maestro y detalle de txt');
        writeln('2. Actualizar el archivo maestro con el archivo detalle');
        writeln('3. Listar en un archivo de texto llamado stock_minimo.txt aquellos productos cuyo stock actual esta por debajo del stock minimo permitido');
        writeln('4. Salir del menu de opciones');
        writeln('Ingrese el numero de opcion');
        readln(opcion);
        case opcion of
            '1': begin
                crearMaestro(mae);
                crearDetalle(det);
            end;
            '2': begin
                actualizarMaestro(mae,det);
                writeln('Actualizacion de maestro realizada');
                imprimirMaestro(mae);
            end;    
            '3': exportarMinStockTxt(mae);
        end;    
    until (opcion = '4');  
end;    

var
    mae: maestro;
    det: detalle;
begin
    menu(mae,det);
end.    