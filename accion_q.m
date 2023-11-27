% funcion para seleccionar una accion mediante el uso de q_table
function ruta = accion_q(inicio,meta,w,h)

 q_value = get_q; % obstengo tabla de valor Q
 estado = inicio; % estado inicial
 pasos = zeros(1,2); 
 pasos(end,:) = inicio; % alaceno el incio con la variables de puntos de
                        % de la trayectoria optima
 
 while norm(estado-meta) ~= 0
     v = max(q_value(estado(1),estado(2),:)); % obtengo el mayor valor Q del estado actual.
     for j = 1:8                              
        if q_value(estado(1),estado(2),j) == v % obtengo la acción asociada al mayor
        b = j;                                 % valor Q encontrado para el estado actual. 
        end                                    
     end
     
     x = estado(1); % guardo las coordenadas del valor actual
     y = estado(2);
     
     switch b % según la acción encontrada ejecuto la acción de movimiento
        case 1  
            estado = [x,min(y+1,w)];   % derecha
        case 2
            estado = [x,max(y-1,1)];   % izquierda
        case 3
            estado = [min(x+1,h),y];   % arriba
        case 4 
            estado = [max(x-1,1),y];   % abajo
        case 5
            estado = [min(x+1,h),min(y+1,w)]; % dia.sup.der
        case 6
            estado = [min(x+1,h),max(y-1,1)]; % dia.sup.izq
        case 7
            estado = [max(x-1,1),min(y+1,w)]; % dia.inf.der
        case 8
            estado = [max(x-1,1),max(y-1,1)]; % dia.inf.izq
    end 
     
     pasos(end+1,:) = estado; % guardo el nuevo valor actual para la trayectoria
                              % optima que obtuvo el algoritmo.
 end
 ruta = pasos; % retornamos la trayectoria optima dentro del mapa de ocupacion 
end            % de 4x4 cm^2


