 % funcion para cambiar de estado en el mapa de 4x4 cm ^2 a partir del 
 % estado actual, una acción y obtener la recompensa al llegar al 
 % nuevo estado debido a la ejecución de la acción 
function a = cambio(estado, accion, meta, w, h)
 
 obstaculo = get_obs; % obtención la información de ocupación del mapa

 x = estado(1); % valor del estado actual en X
 y = estado(2); % valor del estado actual en Y
 
 switch accion
     case 1  
         siguiente = [x,min(y+1,w)];   % derecha
     case 2
         siguiente = [x,max(y-1,1)];   % izquierda
     case 3
         siguiente = [min(x+1,h),y];   % arriba
     case 4 
         siguiente = [max(x-1,1),y];   % abajo
     case 5
         siguiente = [min(x+1,h),min(y+1,w)]; % dia.sup.der
     case 6
         siguiente = [min(x+1,h),max(y-1,1)]; % dia.sup.izq
     case 7
         siguiente = [max(x-1,1),min(y+1,w)]; % dia.inf.der
     case 8
         siguiente = [max(x-1,1),max(y-1,1)]; % dia.inf.izq
 end
 
 recompensa = -1; % penalización para cualquier movimiento 
 
 if siguiente(1) <= 10 | siguiente(1) >= h-9 | siguiente(2) <= 10 | siguiente(2) >= w-9
     recompensa = -50; % penalización si se mueve cerca de los borde de la plataforma
 end                   % del sistema Robotat en un rango de 10 cuadriculas a la redonda.
 
 if obstaculo(siguiente(1),siguiente(2)) == 1
     recompensa = -50000; % penalización en el caso de estar en una cuadricula que
 end                      % representa un obstaculo.
 
 if meta == siguiente
     recompensa = 1000; % recompensa si hemos llegado a la meta.
 end
 
 a = [siguiente,recompensa]; % retorno el nuevo estado y la recompensa de llegar a 
                             % este luego de ejecutar cierta acción. 
end

