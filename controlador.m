%% Controlador de ejecución de trayectoria en el Robotat

%pol = robotat_3pi_connect(6); uso el 8 para mientras
%robotat_3pi_disconnect(pol);


% PID orientación
kpO = 2*5;
kiO = 0.0001; 
kdO = 0;
EO = 0;
eO_1 = 0;

% Acercamiento exponencial
v0 = 30;
alpha = 0.7;
nval = 1;
recorrido = [0,0]; %% almacenar trayectoria ejecutada hasta frena el pololu
ejecucion = [0,0]; %% almacenar los puntos necesarios para calcular ECM 
eje = true; %% sirve para frenar el exeso de lectura de puntos para calcular el ECM
rob = robotat_get_pose(robotat, 6, 'eulxyz');
%rob = robotat_get_pose(robotat, 8, 'eulxyz');
%rob = robotat_get_pose(robotat, 9, 'eulxyz');

radio = (32/2)/1000; % radio de las ruedas (en m)
distancia_centro = (94/2)/1000; % distancia a ruedas (en cm)

while 1

    rob = robotat_get_pose(robotat, 6, 'eulxyz'); %por ahora
    bearing = rob(6)-130.4583; %de pololu 6
    %bearing = rob(6)-(-169.2618);  % de pololu 8
    %bearing = rob(6)-(-99.8390);  % de pololu 9
    bearing = deg2rad(bearing);

    x = rob(1); y = rob(2); theta = bearing; 

    ref = [puntos(1,nval); puntos(2,nval)];
    %ref = robotat_get_pose(robotat, 18, 'eulxyz');
               
    e = [ref(1) - x; ref(2) - y];
    thetag = atan2(e(2), e(1));
    av =  [rob(1); rob(2)];
    eP = norm(e);
    eO = thetag - theta;
    eO = atan2(sin(eO), cos(eO))
           
    % Control de velocidad lineal "PID acercamiento exponencial"
    kP = v0 * (1-exp(-alpha*eP^2)) / eP;
    v = kP*eP;
            
    % Control de velocidad angular "PID normal"
    eO_D = eO - eO_1;
    EO = EO + eO;
    w = kpO*eO + kiO*EO + kdO*eO_D;
    eO_1 = eO;
            
    % Se combinan los controladores
    u = [v; w];

    % Cambio de punto

    if (((abs(ref(1))-abs(av(1)))<=0.1)&&((abs(ref(2))-abs(av(2)))<=0.1))
        nval = nval+1;
        recorrido(end+nval,:) = [x,y];
        if eje
            ejecucion(end+nval,:) = [x,y];
        end
        if (nval > length(puntos))
            eje = false;
            nval = length(puntos);
            if (((abs(ref(1))-abs(av(1)))<=0.05)&&((abs(ref(2))-abs(av(2)))<=0.05))
                robotat_3pi_force_stop(pol);
                break;
            end
        end
    end
    

    wr = (u(1)+distancia_centro*u(2))/radio; % velocidad rpm rueda derecha
    wl = (u(1)-distancia_centro*u(2))/radio; % velocidad rpm rueda izquierda
          
    % control de limite de velocidad de ruedas para ejecución

    if wr > 300
        wr = 300;
    end


    if wl > 300
        wl = 300;
    end


    if wr < -300
        wr = -300;
    end


    if wl < -300
        wl = -300;
    end

    robotat_3pi_set_wheel_velocities(pol, wl, wr); % envio de velocidades al pololu
end

% limpiando los valores [0,0] que no sirven. 

indices = find(recorrido(:,1) == 0);  % Ejemplo de condición
recorrido(indices, :) = [];

indices = find(ejecucion(:,1) == 0);  % Ejemplo de condición
ejecucion(indices, :) = [];

% error cuadratico medio
ECM = immse(puntos',ejecucion);

% grafico de comparacion de trayectorias
figure();
plot(puntos(1,:),puntos(2,:),'b');
hold on;
plot(recorrido(:,1),recorrido(:,2),'r');
legend('Tray. Inter.','Tray. Ejec.')
xlabel('Eje X (m)');
ylabel('Eje Y (m)');
title('Comparación de trayectorias')
hold off;

%robotat_3pi_disconnect(pol);

