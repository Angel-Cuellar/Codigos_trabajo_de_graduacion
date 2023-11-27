% funcion para seleccionar una acciones por medio de epsilon codicioso
function b = selec_accion(estado, epsilon)

 acciones = [1, 2, 3, 4, 5, 6, 7, 8]; % acciones a escoger
 q_value = get_q; % obtenemos el valor de la tabla Q

 if rand() <= epsilon
     b = randsample(acciones,1); % escoger una accion aleatoria
 else
     v = max(q_value(estado(1),estado(2),:)); % seleccionar la acción con el mayor valor Q
     for j = 1:8                              % para el estado ingresado. 
         if q_value(estado(1),estado(2),j) == v   
             b = j;      % devolvemos la acciones correspondiente a este mayor valor Q
             break;
         end
     end
 end
end
% la funcion retorna el numero de accion a realizar 
% tenemos que las acciones son las siguientes:
% 1 = derecha  2 = izquierda  3 = arriba  4 = abajo
% 5 = d.der.su 6 = d.izq.su 7 = d.der.inf 8 = d.izq.inf 
