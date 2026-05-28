{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}

program ej4;
const 
	VA = 9999;
	cantS= 4; {en el enunciado son 30} 
type
	producto = record
		cod : integer;
		nombre : string[30];
		descrip: string[30];
		stockDis : integer;
		stockMin : integer;
		precio : real;
	end;
	
	maestro = file of producto;
	
	venta = record
		cod: integer;
		cantV: integer;
	end;
	
	detalle = file of venta;
	
	v_detalles = array[1..cantS] of detalle;
	
	v_ventas = array[1..cantS] of venta;

procedure crearMaestro(var mae: maestro);
var
    p: producto;
    txt : text;
    nombreArchivo: string; 
begin
    writeln('Ingrese el nombre del archivo de carga: ');
    readln(nombreArchivo);
    assign(txt, nombreArchivo);
    assign(mae, 'maestro');
    reset(txt);
    rewrite(mae);
    while not eof(txt) do begin
		with p do begin
			readln(txt, cod, nombre, stockDis, stockMin, precio);
			readln(txt, descrip);
			write(mae, p);
		end;	
    end;
    writeln('Archivo maestro creado exitosamente.');
    close(txt);
    close(mae);
end;

procedure crearUnDetalle(var det: detalle);
var
    v: venta;
    txt: text;
    nombreArchivo: string;
begin
    writeln('Ingrese el nombre del archivo de carga para el detalle: ');
    readln(nombreArchivo);
    assign(txt, nombreArchivo);
    reset(txt);
    rewrite(det);
    while not eof(txt) do begin
		with v do begin
			readln(txt, cod, cantV);
			write(det, v);
		end;	
    end;
    writeln('Archivo detalle creado exitosamente.');
    close(txt);
    close(det);
end;

procedure crearDetalles(var vD: v_detalles);
var
	i: integer;
begin
	for i:=1 to cantS do
		crearUnDetalle(vD[i]);
end;

procedure leer(var arc: detalle; var v: venta);
begin
	if not(eof(arc)) then
		read(arc,v)
	else
		v.cod := VA;
end;

procedure minimo( var vD: v_detalles; var vV : v_ventas; var min : venta);
var
	i, pos : integer;
begin
	min.cod := VA;
	{Busco el menor código en los registros actuales}
	for i:=1 to cantS do begin
		if vV[i].cod < min.cod then begin
			min := vV[i];
			pos := i;
		end;
	end;
	{Si encontré un mínimo válido, avanzo ESE archivo detalle en particular }
	if (min.cod <> VA) then 
		leer(vD[pos], vV[pos])		
end;	

var
	mae: maestro;
	detalles: v_detalles;
	registros: v_ventas;
	informe : text;
	min: venta;
	regm : producto;
	i, total, codActual : integer;
	stringNum: string;
begin
	assign(mae, 'maestro.dat');
	reset(mae);
	
	assign(informe, 'reporte.txt');
	rewrite(informe);
	read(mae, regm);
	
	for i:=1 to cantS do begin
		str(i, stringNum);
		assign(detalles[i], 'detalle' + stringNum + '.dat');
		reset(detalles[i]);
		leer(detalles[i], registros[i]);
	end;
	minimo(detalles,registros,min);
	while min.cod <> VA do begin
		codActual := min.cod;
		total := 0;
		{Acumulo las ventas del mismo código}
		while (codActual = min.cod ) do begin
			total := total + min.cantV;
			{Llamamos al módulo para que busque el siguiente y avance}
			minimo(detalles, registros,min);
		end;
		
		while(regm.cod <> codActual) do
			read(mae, regm);
			
		regm.stockDis := regm.stockDis - total;
		seek(mae, filePos(mae)-1);
        write(mae, regm);
        
        if(regm.stockDis < regm.stockMin) then 
			writeln(informe, 'Nombre: ', regm.nombre, ' | Desc: ', regm.descrip, ' | Stock: ', regm.stockDis, ' | Precio: $', regm.precio:0:2);
	end;
	close(mae);
	close(informe);
	for i:=1 to CantS do
		close(detalles[i]);
end.	 
