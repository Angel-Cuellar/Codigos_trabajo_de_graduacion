% funcion de reinforcement learning mediante q_learning
function c = q_learning(alpha,gamma,epsilon,inicio,meta,w,h)

 estado = inicio; % estado inicial
 recompensa = 0;  % historico de recompensa de episodio
 q_value = get_q; % obtencion de tabla de valores Q
 
 while norm(estado - meta) ~= 0.0
     accion = selec_accion(estado, epsilon); % selecciono accion 
     decision = cambio(estado, accion, meta, w, h); % ejecuto accion y obtengo recompensa
     recompensa = recompensa + decision(3); % almaceno recompensa
     
     % ecuación de Q-learning
     q_value(estado(1),estado(2),accion) = q_value(estado(1),estado(2),accion) + ...
         alpha*(decision(3) + gamma*max(q_value(decision(1),decision(2),:)) -...
         q_value(estado(1),estado(2),accion));
     
     estado = decision(1:2); % actualizo el estado actual 
 end
 set_q(q_value); % actualizo la tabla Q al terminar episodio
 c = recompensa; % retorno el historico de recompensas adquiridas
end

