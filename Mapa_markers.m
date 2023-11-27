%robotat = robotat_connect('192.168.50.200');

% lectura de markers del Robotat
vert1 = robotat_get_pose(robotat, 11, 'eulzyx');
vert2 = robotat_get_pose(robotat, 12, 'eulzyx');
vert3 = robotat_get_pose(robotat, 13, 'eulzyx');
vert4 = robotat_get_pose(robotat, 14, 'eulzyx');
vert5 = robotat_get_pose(robotat, 15, 'eulzyx');
vert6 = robotat_get_pose(robotat, 16, 'eulzyx');
vert7 = robotat_get_pose(robotat, 17, 'eulzyx');
vert8 = robotat_get_pose(robotat, 18, 'eulzyx');
ini = robotat_get_pose(robotat, 6, 'eulzyx');
met = robotat_get_pose(robotat, 19, 'eulzyx');

%coordenadas de los vertices de mi poligono1
vertx1 = [vert1(1),vert2(1),vert3(1),vert4(1),vert5(1),vert6(1),vert7(1),vert8(1)];  
verty1 = [vert1(2),vert2(2),vert3(2),vert4(2),vert5(2),vert6(2),vert7(2),vert8(2)];

% mapeo de vertices de pologono1 al mapa de 4x4 cm2 
vertx1 = (1/4)*round(100*vertx1 + 380/2);
verty1 = (1/4)*round(100*verty1 + 480/2);

%coordenadas de los vertices de mi poligono2
%vertx2 = [vert4(1),vert5(1),vert6(1),vert7(1)];  
%verty2 = [vert4(2),vert5(2),vert6(2),vert7(2)];

% mapeo de vertices de pologono2 al mapa de 4x4 cm2 
%vertx2 = (1/4)*round(100*vertx2 + 380/2);
%verty2 = (1/4)*round(100*verty2 + 480/2);

pgon1 = poly2mask(vertx1,verty1,120,95); %% genero el poligono1 con los vertices
%pgon2 = poly2mask(vertx2,verty2,120,95); %% genero el poligono2 con los vertices

obs1 = flip(double(pgon1)); %+ flip(double(pgon2)); % laberinto con los poligonos

map = binaryOccupancyMap(95,120,1);
map1 = binaryOccupancyMap(95,120,1); % genero el mapa en blanco

setOccupancy(map,obs1); % cargado la nueva configuracion de obstaculos
setOccupancy(map1,obs1); % cargado la nueva configuracion de obstaculos

% mapeo del inicio y meta al mapa de 4x4 cm2 
inicio = (1/4)*[100*ini(1)+380/2,100*ini(2)+480/2];
meta = (1/4)*[100*met(1)+380/2,100*met(2)+480/2];

inicio = local2grid(map,inicio);
meta = local2grid(map,meta);

figure();

%inflate(map1,1.5); %% solo para verificacion 5

show(map1); %% muestro el mapa generado

inflate(map,3.5); % hago un inflado de obstaculos

figure(); % muestro mapa

show(map);

%robotat_disconnect(robotat);

