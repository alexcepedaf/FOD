{A  partir  de  información  sobre  la  alfabetización  en  la  Argentina, se necesita actualizar un 
archivo  que  contiene  los  siguientes  datos:  nombre  de  provincia,  cantidad  de  personas 
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos 
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de 
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos 
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle. 
NOTA:  Los  archivos  están  ordenados  por  nombre  de  provincia  y  en  los archivos detalle      
pueden venir 0, 1 ó más registros por cada provincia}

program ej3;

const
    VA = 'ZZZZ';
type
    provincia = record
        nombre_prov: string[30];
        cant_alf: integer;
        cant_enc: integer;
    end;

    maestro = file of provincia;

    censo = record
        nombre_prov: string[30];
        codigoLocalidad: integer;
        cant_alf: integer;
        cant_enc: integer;
    end;

    detalle = file of censo;

procedure leer(var det: detalle; var c: censo);
begin
    if not eof(det) then
        read(det, c)
    else
        c.nombre_prov := VA; 
end;

procedure minimo(var r1,r2,min: censo; var det1, det2: detalle);
begin
    if (r1.nombre_prov < r2.nombre_prov) then begin
        min := r1;
        leer(det1,r1);
    end
    else begin
        min := r2;
        leer(det2,r2);
    end;    
end;

procedure actualizarMaestro(var mae: maestro; var det1, det2: detalle);
var
    p: provincia;
    provActual: string[30];
    c1,c2,min: censo;
    alfabetizados, encuestados: integer;
begin
    writeln('Actualizando el archivo maestro...');
    reset(mae);
    reset(det1);
    reset(det2);
    read(mae, p);
    leer(det1, c1);
    leer(det2, c2);
    minimo(c1, c2, min,det1, det2);
    while (min.nombre_prov <> VA) do begin
        provActual := min.nombre_prov;
        alfabetizados := 0;
        encuestados := 0;
        while (min.nombre_prov <> VA) and (provActual = min.nombre_prov) do begin
            alfabetizados:= alfabetizados + min.cant_alf;
            encuestados := encuestados + min.cant_enc;
            minimo(c1, c2, min, det1,det2);
        end;
        while (p.nombre_prov <> provActual ) do
           read(mae, p);
        p.cant_alf := p.cant_alf + alfabetizados;
        p.cant_enc := p.cant_enc + encuestados; 
        seek(mae, filePos(mae)-1);
        write(mae, p);
        if (not(EOF(mae))) then
            read(mae, p);   
    end;
    close(mae);
    close(det1);
    close(det2);
end;

procedure CrearMaestro(var mae: maestro);
var
    p: provincia;
    carga : text;
    nombreArchivo: string; 
begin
    writeln('Ingrese el nombre del archivo de carga: ');
    readln(nombreArchivo);
    assign(carga, nombreArchivo);
    assign(mae, 'maestro');
    reset(carga);
    rewrite(mae);
    while not eof(carga) do begin
        readln(carga, p.cant_alf, p.cant_enc, p.nombre_prov);
        write(mae, p);
    end;
    writeln('Archivo maestro creado exitosamente.');
    close(carga);
    close(mae);
end;

procedure CrearDetalle(var det: detalle; numero: integer);
var
    c: censo;
    carga: text;
    nombreArchivo: string;
begin
    writeln('Ingrese el nombre del archivo de carga para el detalle ', numero, ': ');
    readln(nombreArchivo);
    assign(carga, nombreArchivo);
    reset(carga);
    rewrite(det);
    while not eof(carga) do begin
        readln(carga, c.codigoLocalidad, c.cant_alf, c.cant_enc,c.nombre_prov);
        write(det, c);
    end;
    writeln('Archivo detalle ', numero, ' creado exitosamente.');
    close(carga);
    close(det);
end;

procedure informarMaestro(var mae: maestro);
var
    p: provincia;
begin
    reset(mae);
    while(not eof(mae)) do begin
        read(mae, p);
        writeln('Provincia: ', p.nombre_prov, ' Cantidad de alfabetizados: ', p.cant_alf, ' Total de encuestados: ', p.cant_enc);
    end;
    close(mae);
end;

var
    mae: maestro;
    d1, d2: detalle;
begin
    assign(d1, 'detalle1');
    assign(d2, 'detalle2');
    CrearDetalle(d1,1);
    CrearDetalle(d2,2);
    CrearMaestro(mae);
    actualizarMaestro(mae, d1, d2);
    writeln('Actualización del archivo maestro completada.');
    informarMaestro(mae);
end.    
