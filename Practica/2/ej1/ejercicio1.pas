{Una  empresa  posee un archivo con información de los ingresos percibidos por diferentes 
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado, 
nombre  y  monto  de  la  comisión.  La  información  del  archivo  se  encuentra  ordenada  por 
código  de  empleado  y  cada  empleado puede aparecer más de una vez en el archivo de 
comisiones.  
Realice  un  procedimiento  que  reciba  el archivo anteriormente descrito y lo compacte. En 
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una 
única vez con el valor total de sus comisiones. 
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez}

program ej1;
const 
    VA = 9999;
type
    empleado = record
        codigo: integer;
        nombre: string;
        montoComision: real;
    end;

    archivo = file of empleado;

procedure leer(var arc: archivo; var e: empleado);
begin
    if (not eof(arc)) then 
        read(arc,e)
    else
        e.codigo := VA;         
end;

procedure cargarDetalle(var aD:archivo; var carga: text); // el detalle
var
    e: empleado;
begin
    reset(carga);
    rewrite(aD);
    while (not eof(carga)) do begin
        with e do
            begin
                readln(carga, codigo,montoComision,nombre);
                write(aD, e);
            end;
    end;    
    writeln('Archivo cargado');
    writeln('');
    close(aD);
    close(carga);
end;

procedure cargarCompacto(var aC:archivo; var aD: archivo);
var
    eDetalle, eCompacto : empleado;
    total: real;
    codigoActual: integer;
    nombreActual: string;
begin
    assign(aC, 'archivoCompacto');
    reset(aD);
    rewrite(aC);
    leer(aD, eDetalle);
    while(eDetalle.codigo <> VA) do begin
        codigoActual := eDetalle.codigo;
        nombreActual := eDetalle.nombre;
        total:= 0;
        while(eDetalle.codigo <> VA) and (eDetalle.codigo = codigoActual) do begin
            total := total + eDetalle.montoComision;
            leer(aD, eDetalle);
        end;
        eCompacto.codigo := codigoActual;
        eCompacto.nombre := nombreActual;
        eCompacto.montoComision := total;
        write(aC, eCompacto);
    end;
    close(aD);
    close(aC);        
end;     

procedure exportarTxt(var aC:archivo);
var
    e: empleado;
    txt: text;
begin
    assign(txt, 'archivoCompacto.txt');
    reset(aC);
    rewrite(txt);
    while( not eof(aC)) do begin
        read(aC, e);
        writeln(txt, 'Codigo: ', e.codigo, ' Nombre: ', e.nombre, ' Comision total: ', e.montoComision:0:2);
        writeln('Codigo: ', e.codigo, ' Nombre:', e.nombre, ' - Comision total: ', e.montoComision:0:2); // para debuggear
    end;
    close(aC);
    close(txt);    
end;

var
    aD, aC: archivo;
    carga : text;
begin
    assign(aD, 'archivoDetalle');
    assign(carga, 'empleados.txt');
    cargarDetalle(aD, carga);
    cargarCompacto(aC,aD);
    exportarTxt(aC);
end.

