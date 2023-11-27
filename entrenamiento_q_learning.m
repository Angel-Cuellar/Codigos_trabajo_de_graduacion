%% Algoritmo de entrenamiento de Q-Learning 

w = 95; % anchura de la plataforma en unidades discretas
h = 120; % altura de la plataforma en unidades discretas

epsilon = 1.0; % coeficiente de acción codiciosa para exporación

alpha = 1.0; % tasa de aprendizaje 

gamma = 1.0; % compensación de futuras recompensas debido a una accion actual

acciones = [1, 2, 3, 4, 5, 6, 7, 8];

% tenemos que las acciones son las siguientes:
% 1 = derecha  2 = izquierda  3 = arriba  4 = abajo
% 5 = d.der.su 6 = d.izq.su 7 = d.der.inf 8 = d.izq.inf 

obs = getOccupancy(map); % obtención de ocupacion del mapa generado previamente

set_obs(obs); %% define una variable obstaculos como una variable global
set_q(zeros(h,w,length(acciones))); %% definir la tabla de valores Q como global

% funcion de ejecución del algoritmo Q-learning 

episodes = 400; %% numero de episodios
rewards = zeros(1, episodes); %% variable de historico de recompensas por episodio

tic; %% inicio de conteo de tiempo para saber cuanto tarda en converger el algorimto

% fase de entrenamiento del algorimto de Reinforcemente Learning 

for i = 1:episodes
    rewards(i) = rewards(i) + q_learning(alpha,gamma,epsilon,inicio,meta,w,h);
    if i >= 350
        epsilon = -1.0; % cambio de explorar a explotar el conocimiento adquirido
    end
end

toc; %% finalización de tiempo de convergencia 

ruta = accion_q(inicio,meta,w,h); % obtención de puntos de trayectoria en forma matricial
ruta_mapeada = grid2local(map,ruta); % converción de puntos de matricial a cartesiana en el mapa
puntos = ruta_mapeada(1,:); % almacenamiento del punto de inicio mapeado en otra variable
l = (length(ruta_mapeada)-2)/4; % longitud de datos sin contar el inicio y final dividido 4
for j = 1:l 
    puntos(end+1,:) = ruta_mapeada(4*j,:); % proceso de muestreo de puntos de forma 
end                                        % (x[4n],y[4n])
puntos(end+1,:) = ruta_mapeada(end,:); % almacenamiento del punto de final mapeado en otra variable

% interpolación mediante b-splines y generando puntos cada 0.25 en x para mayor fineza
trayec = bsplinepolytraj(puntos',[0,length(puntos)-1],0:0.25:length(puntos)-1);

figure();
show(map);
hold on;     % visualización de trayectoria en mapa inflado con la trayectoria original
plot(ruta_mapeada(:,1),ruta_mapeada(:,2),'r','LineWidth', 2);
hold off;

figure();
show(map1); 
hold on;     % visualización de trayectoria en mapa normal con la trayectoria interpolada
plot(trayec(1,:),trayec(2,:),'r','LineWidth', 2);
hold off;

% mapeo de los puntos del mapa hacia la plataforma Robotat para uso de verificación
puntos = [(4/100)*trayec(1,:) - 3.8/2 ; (4/100)*trayec(2,:) - 4.8/2];
