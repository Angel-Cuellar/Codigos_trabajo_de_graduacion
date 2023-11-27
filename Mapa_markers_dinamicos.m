%% Rutina para realización de mapas mediante paredes virtuales utilizando 
%% Los markers del Robotat permitiendo rotarlas según el angulo de Z de estos.
%robotat = robotat_connect('192.168.50.200');

% Generación de variables y lectura de punto de inicio y meta con markers.

map = binaryOccupancyMap(95,120,1);
map1 = binaryOccupancyMap(95,120,1);
obs = zeros(45,2);
mark1 = 0;
mark = 0;
ini = robotat_get_pose(robotat, 6, 'eulzyx'); %por ahora 
met = robotat_get_pose(robotat, 18, 'eulzyx');

while true
    for j = 1:7 % para tomar markers del 11 al 17
        if not(j == 1 | j == 7) % esto sirve para excluir el marker 11 y 17
            % desplazandome del marker 11 al 17 del Robotat
            mark = robotat_get_pose(robotat, j+10, 'eulzyx');
            % mapeo el punto (x,y) del marker al mapa de ocupacion de 4x4 cm^2
            x_1 = (1/4)*round(100*mark(1)+380/2);
            y_1 = (1/4)*round(100* mark(2)+480/2); 
            obs(1,:) = [x_1,y_1];
            mark1 = [x_1,y_1]; % almaceno el punto mapeado
            
        % genero un segmento de recta con una longitud de 45 puntos la cual
        % contenga el punto (x,y) del marker mapeado y el angulo en Z del mismo.
            for i = 2:45
                x1 = X(x_1,mark(4));
                y1 = Y(x1,y_1,mark1(1),mark1(2),mark(4));
                obs(i,:) = [x1,y1]; % almaceno los valores para generar mapa
                x_1 = x1; 
                y_1 = y1;
            end
            setOccupancy(map,obs,ones(45,1));
            setOccupancy(map1,obs,ones(45,1)); % seteo la ocupaciones de la paredes
            show(map);
        end     
    end
    % mapeo de los markes inicio y meta en la mapa de ocupacion de 4x4 cm^2
    inicio = (1/4)*[100*ini(1)+380/2,100*ini(2)+480/2];
    meta = (1/4)*[100*met(1)+380/2,100*met(2)+480/2];
    inicio = local2grid(map,inicio);
    meta = local2grid(map,meta);
    % inflo obstaculos en solo 1 de los mapas, el otro se queda 
    % con el tamaño de los obstaculos normales
    inflate(map,2);
    show(map1); % muestro el mapa sin inflar obstaculos
    pause(10); % hago una pausa para visualizar el mapa
    map = binaryOccupancyMap(95,120,1); % limpio los mapas para volver a 
    map1 = binaryOccupancyMap(95,120,1); % graficar las paredes de nuevo
end

% funcion para generar valores en "y" de una pared del laberinto usando un
% marker 
function v = Y(x_1,y_1,x_mark,y_mark,theta) 

    if theta == 90   % si angulo respecto a Z es 90°, genero una recta vertical creciente
        y = y_1 + 1;
    elseif theta == 270 % si angulo respecto a Z es 270°, genero una recta vertical decreciente
        y = y_1 - 1;
    else
        y = (x_1-x_mark)*tand(theta)+y_mark; %calculo "y" con la ecuacion 
    end    % de una recta de la forma: y = m(x-x0)+y0 para que contenga al punto del marker
    
    if y == 0
        v = y_1; % si "y" calculado en la ecuacion anterior es 0, dejo estatico el valor de "y"
    else
        v = max(min(y,120),0); % limitar el valor de "y" de la forma
    end                          % 0<= y <= 120
    
end


% funcion para generar valores en "x" de una pared del laberinto usando un
% marker
function u = X(x_1,theta)

    if and(theta > 270,theta <= 360) | and(theta >= 0,theta < 90) %si el angulo respecto a Z 
        u = min(x_1 + 1,95); % esta entre 1er y 4to cuadrante incremento "x" en un valor de 1
    elseif and(theta > 90,theta < 270)
        u = max(x_1 - 1 ,0); % esta entre 2er y 3to cuadrante decremento "x" en un valor de 1
    else
        u = x_1; % si el angulo respecto Z es 90° o 270°, dejo estatico el valor de "x"
    end
    
end







