# Codigos_trabajo_de_graduacion
Esto contiene todas los scripts necesarios para utilizar el planificador desarrollado.

# IMPORTANTE....

# LOS UNICOS SCRIPTS QUE DEBEN SER UTILIZAR POR LOS USUARIOS SON:

# entrenamiento_q_learning.m
# Mapa_markers.m
# Mapa_markers_dinamicos.m
# controlador.m

# TODOS LOS DEMAS SON FUNCIONES PARA LA UTLIZACIÓN DE LOS SCRIPTS ANTERIORMENTE NOMBRADOS. NO DEBEN TOCARSE O MODIFICARSE EN LA MEDIDA DE LO POSIBLE.

_____________________________________________________________________________________________________________________________________________________

# ORDEN DE UTILIZACION DE LOS SCRIPTS

# 1) Para poder realizar los mapas con la utilización de los markers se pueden usar las siguientes scripts:
- Mapa_markers.m    % esta es para generar obstaculos por pologonos mediante la definición de sus vertices con los markers.
- Mapa_markers_dinamicos.m % esta es para generar laberintos mediante paredes virtuales mediante el uso de markers.

# 2) Para poder planificar la trayectoria en el mapa desarrollado se debe utilizar el script: entrenamiento_q_learning.m
    En este, tan solo se debe correr y el algoritmo planifica la trayectoria optima para ese mapa.

# 3) Para poder controlar al Pololu 3pi+, se debe utlizar el script: controlador.m
     En este, según el numero del Pololu a utilizar, se debe calcular el angulo de bearing el cual es diferente debido al
     marker con el mismo numero del agente robotico. Tambien modificar el numero del marker para que coincida con el Pololu.
  

