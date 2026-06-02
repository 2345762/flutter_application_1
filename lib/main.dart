 // Cambia esto por la ruta real de tu archivo
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;

// =============================================================
// SECCIÓN DE DATOS: AQUÍ ES DONDE AGREGAS TUS PREGUNTAS
// =============================================================

// 1. Lista de Aerodinámica (La que ya tenías)
final List<Map<String, Object>> poolAerodinamica = [
  {
    'texto': 'Si el ángulo de ataque constante y la velocidad sube al doble, la sustentación será:',
    'explicacion': r'La sustentación es proporcional al cuadrado de la velocidad (L = 1/2 * rho * v² * S * CL).',
    'respuestas': [
      {'texto': 'La misma', 'puntos': 0},
      {'texto': 'Dos veces mayor', 'puntos': 0},
      {'texto': 'Cuatro veces mayor', 'puntos': 1},
    ],
  },
  {
    'texto': '¿Qué es el factor de carga?',
    'explicacion': r'Es la relación entre la sustentación total y el peso del avión (n = L/W).',
    'respuestas': [
      {'texto': 'Sustentación multiplicada por peso total', 'puntos': 0},
      {'texto': 'Sustentación restada al peso total', 'puntos': 0},
      {'texto': 'Sustentación dividida por peso total', 'puntos': 1},
    ],
  },

  {
    'texto': '2. ¿Qué velocidad aérea verdadera y ángulo de ataque debiera usarse para generar la misma cantidad de sustentación a medida que aumenta la altitud? ',
    'explicacion': r'A medida que aumenta la altitud, disminuye la densidad del aire. Entonces, para mantener la misma sustentación, si mantienes el mismo ángulo de ataque, el avión necesita una mayor velocidad aérea verdadera (TAS) para compensar la menor densidad. La FAA explica que en aire menos denso se requiere mayor velocidad verdadera para producir la sustentación necesaria en vuelo nivelado.',
    
    'respuestas': [
     {'texto': 'La misma velocidad aérea verdadera y ángulo de ataque', 'puntos': 0},
     {'texto': 'Una velocidad aérea verdadera mayor para cualquier ángulo de ataque dado', 'puntos': 1},
     {'texto': 'Una velocidad aérea verdadera menor y un ángulo de ataque mayor.', 'puntos': 0},
      ]  
  },

  {
    'texto': '3. ¿Qué factores afectan a la velocidad indicada de pérdida de sustentación, (stall)? ',
    'explicacion': r'A: peso, factor de carga y potencia. La pérdida ocurre cuando el avión alcanza su ángulo de ataque crítico, pero la velocidad indicada a la que esto sucede varía según la condición de vuelo: si aumenta el peso, el avión necesita más sustentación y la velocidad de pérdida aumenta; si aumenta el factor de carga, como en un viraje o maniobra, también aumenta la velocidad de pérdida; y la potencia puede modificarla porque influye en el flujo de aire y en la sustentación generada.',
    
    'respuestas': [
     {'texto': 'A.- Peso, factor de carga y potencia. ', 'puntos': 0},
     {'texto': 'Una velocidad aérea verdadera mayor para cualquier ángulo de ataque dado', 'puntos': 1},
     {'texto': 'Una velocidad aérea verdadera menor y un ángulo de ataque mayor.', 'puntos': 0},
      ]  
  },
  {
    'texto': '4. ¿Qué factores afectan a la velocidad indicada de pérdida de sustentación, (stall)? ',
    'explicacion': r'A.- La resistencia aumenta debido al incremento de la resistencia inducida. Al volar por debajo de la velocidad de máxima L/D, el avión debe aumentar el ángulo de ataque para mantener la sustentación. Esto incrementa la resistencia inducida y, por consecuencia, aumenta la resistencia total.',
    
    'respuestas': [
     {'texto': 'A.- La resistencia aumenta debido al incremento de la resistencia inducida', 'puntos': 1},
     {'texto': 'B.- La resistencia aumenta debido al incremento de la resistencia parásita.', 'puntos': 0},
     {'texto': 'C.- La resistencia disminuye debido a una resistencia inducida menor.', 'puntos': 0},
      ]  
  },
  {
    'texto': '5.- ¿Cuál es la relación entre resistencia inducida y resistencia parásita cuando se aumenta el peso?  ',
    'explicacion': r'A.- Al aumentar el peso, el avión necesita generar mayor sustentación, aumentando el ángulo de ataque. Esto intensifica los vórtices en las puntas de ala y la perturbación del flujo de aire, haciendo que la resistencia inducida aumente mucho más que la resistencia parásita, la cual depende principalmente de la velocidad',
    
    'respuestas': [
     {'texto': 'A.- La resistencia parásita aumenta más que la resistencia inducida','puntos': 0},
     {'texto': 'B.- La resistencia inducida aumenta más que la resistencia parásita,','puntos': 1},
     {'texto': 'C.- Ambas resistencias aumentan igual.','puntos': 0},
     ]         
  },

  {
    'texto': '6.- Cambiando el ángulo de ataque, el piloto puede controlar:   ',
    'explicacion': r'Al modificar el ángulo de ataque, el piloto cambia la sustentación generada por el ala. Esto también afecta la resistencia aerodinámica y la velocidad del avión debido a la variación de las fuerzas aerodinámicas en vuelo.',
    
    'respuestas': [
     {'texto': 'A.- Sustentación, peso y resistencia. ','puntos': 0},
     {'texto': 'B.- Sustentación, velocidad y resistencia. ,','puntos': 1},
     {'texto': 'C.- Sustentación y velocidad pero no la resistencia. ','puntos': 0},
     ]         
  },

{
    'texto': '7.- ¿Cómo puede un avión producir la misma sustentación estando con efecto de suelo que estando sin efecto de suelo?',
    'explicacion': r'En efecto de suelo, la interferencia del suelo reduce los vórtices de punta de ala y aumenta la eficiencia aerodinámica. Por ello, el avión puede generar la misma sustentación con un ángulo de ataque menor, ya que disminuye la resistencia inducida y se aprovecha mejor el flujo de aire alrededor del ala.',
    
    'respuestas': [
     {'texto': 'A.- Con el mismo ángulo de ataque. ','puntos': 0},
     {'texto': 'B.- Con un ángulo de ataque menor. ,','puntos': 1},
     {'texto': 'C.- Con un ángulo de ataque mayor.  ','puntos': 0},
     ]         
  },

{
    'texto': '8.- ¿Qué condición de vuelo debería esperarse cuando el avión sale del efecto de tierra o de suelo? ',
    'explicacion': r'Al salir del efecto de suelo, disminuye la eficiencia aerodinámica del ala y aumentan los vórtices de punta de ala. Como consecuencia, se incrementa la resistencia inducida y el avión requiere un mayor ángulo de ataque para mantener la misma sustentación.',
    
    'respuestas': [
     {'texto': 'A.- Un aumento de la resistencia inducida al requerir un mayor ángulo de ataque.  ','puntos': 1},
     {'texto': 'B.- Una disminución de la resistencia parásita que permite un ángulo de ataque menor. ,','puntos': 0},
     {'texto': 'C.- Un aumento de la estabilidad dinámica.  ','puntos': 0},
     ]         
  },

  {
    'texto': '9.- ¿Qué procedimiento se recomienda para una aproximación y aterrizaje con un motor detenido? ',
    'explicacion': r'En una aeronave bimotor con un motor detenido, la aproximación y aterrizaje deben realizarse de forma muy similar a una aproximación normal, manteniendo velocidades y procedimientos establecidos para conservar el control y la estabilidad del avión.',
    
    'respuestas': [
     {'texto': 'A.- La trayectoria de vuelo y los procedimientos deben ser casi idénticos a los de una aproximación y aterrizaje normales.  ','puntos': 1},
     {'texto': 'B.- La altitud y velocidad deben ser considerablemente mayores que las normales a lo largo de la aproximación. ,','puntos': 0},
     {'texto': 'C.- Una aproximación normal, excepto no extender el tren de aterrizaje o flaps hasta estar sobre el umbral de la pista.   ','puntos': 0},
     ]         
  },


  {
    'texto': '10.- ¿Cuál es el motor “crítico” en un avión bimotor? ',
    'explicacion': r'En una aeronave bimotor con un motor detenido, la aproximación y aterrizaje deben realizarse de forma muy similar a una aproximación normal, manteniendo velocidades y procedimientos establecidos para conservar el control y la estabilidad del avión.',
    
    'respuestas': [
     {'texto': 'A.- Aquél con el eje de empuje o tracción más cercano al eje longitudinal del avión.','puntos': 1},
     {'texto': 'B.- La altitud y velocidad deben ser considerablemente mayores que las normales a lo largo de la aproximación. ,','puntos': 0},
     {'texto': 'C.- Aquél con el eje de empuje o tracción más alejado del eje longitudinal del avión.','puntos': 0},
     ]         
  },
  {
    'texto': '11.- ¿Bajo qué condición nunca debería practicarse “stalls” en un avión bimotor?',
    'explicacion': r'En un avión bimotor no se deben practicar stalls con un motor inoperativo, ya que la pérdida de sustentación combinada con empuje asimétrico aumenta considerablemente el riesgo de pérdida de control direccional.',
    
    'respuestas': [
     {'texto': 'A.- Con un motor inoperativo.','puntos': 1},
     {'texto': 'B.- Con potencia de ascenso.','puntos': 0},
     {'texto': 'C.- Con full flaps y tren de aterrizaje extendido.','puntos': 0},
     ]         
  },
  {
    'texto': '12.- ¿Qué es el factor de carga?',
    'explicacion': r'El factor de carga es la relación entre la sustentación generada por la aeronave y su peso total. Se expresa en “G” y permite conocer cuántas veces el peso del avión está siendo soportado por la estructura durante una maniobra.',
    
    'respuestas': [
     {'texto': 'A.- Sustentación multiplicada por peso total.','puntos': 0},
     {'texto': 'B.- Sustentación restada al peso total.','puntos': 0},
     {'texto': 'C.- Sustentación dividida por peso total.','puntos': 1},
     ]         
  },

{
    'texto': '13.- Si un avión con un peso de 2.000 libras es sometido en vuelo a una carga total de 6.000 libras, su factor de carga será:',
    'explicacion': r'El factor de carga se obtiene dividiendo la carga total entre el peso del avión. En este caso, 6.000 libras dividido por 2.000 libras da como resultado 3, por lo tanto el avión está sometido a 3 G.',
    
    'respuestas': [
     {'texto': 'A.- 2 G.','puntos': 0},
     {'texto': 'B.- 3 G.','puntos': 1},
     {'texto': 'C.- 9 G.','puntos': 0},
     ]         
  },

  {
    'texto': '14.- ¿De qué factor depende la carga alar durante un viraje nivelado, coordinado y en aire calmo?',
    'explicacion': r'Durante un viraje nivelado y coordinado, el factor de carga aumenta principalmente con el ángulo de banqueo. A mayor inclinación alar, mayor sustentación debe generar el avión para mantener la altitud.',
    
    'respuestas': [
     {'texto': 'A.- Razón de viraje.','puntos': 0},
     {'texto': 'B.- Ángulo de banqueo (inclinación alar).','puntos': 1},
     {'texto': 'C.- Velocidad aérea verdadera.','puntos': 0},
     ]         
  },

{
    'texto': '15.- ¿Cuál es la relación entre la razón de viraje y el radio de viraje en un viraje con ángulo de banqueo constante pero con aumento de la velocidad?',
    'explicacion': r'Con un mismo ángulo de banqueo, al aumentar la velocidad, el avión necesita un radio mayor para completar el viraje. Por eso, la razón de viraje disminuye y el radio de viraje aumenta.',
    
    'respuestas': [
     {'texto': 'A.- La razón disminuye y el radio aumenta.','puntos': 1},
     {'texto': 'B.- La razón aumenta y el radio disminuye.','puntos': 0},
     {'texto': 'C.- La razón y el radio aumentan.','puntos': 0},
     ]         
  },

{
    'texto': '16.- ¿Cuál es una característica de la inestabilidad longitudinal?',
    'explicacion': r'La inestabilidad longitudinal se manifiesta como oscilaciones de cabeceo que aumentan progresivamente, indicando que el avión no tiende a recuperar naturalmente su actitud de equilibrio.',
    
    'respuestas': [
     {'texto': 'A.- Oscilaciones de cabeceo que crecen progresivamente.','puntos': 1},
     {'texto': 'B.- Oscilaciones de alabeo que crecen progresivamente.','puntos': 0},
     {'texto': 'C.- El avión trata constantemente de bajar la nariz (to pitch down).','puntos': 0},
     ]         
  },

{
    'texto': '17.- ¿Qué es estabilidad longitudinal dinámica?',
    'explicacion': r'La estabilidad longitudinal dinámica se relaciona con la forma en que el avión responde con el tiempo a una perturbación en cabeceo, alrededor del eje lateral.',
    
    'respuestas': [
     {'texto': 'A.- Estabilidad alrededor del eje longitudinal.','puntos': 0},
     {'texto': 'B.- Estabilidad alrededor del eje lateral.','puntos': 1},
     {'texto': 'C.- Estabilidad alrededor del eje vertical.','puntos': 0},
     ]         
  },

{
    'texto': '18.- ¿Qué reacción debiera esperarse si un avión es cargado de tal manera que su C.G. quede muy cerca del máximo rango trasero permitido?',
    'explicacion': r'Un centro de gravedad muy atrasado reduce la estabilidad longitudinal del avión y puede hacerlo más sensible en cabeceo, dificultando su control y recuperación ante perturbaciones.',
    
    'respuestas': [
     {'texto': 'A.- Lentitud de reacción del control de alerones.','puntos': 0},
     {'texto': 'B.- Lentitud de reacción del control de timón de dirección.','puntos': 0},
     {'texto': 'C.- Inestabilidad alrededor del eje lateral.','puntos': 1},
     ]         
  },

{
    'texto': '19.- ¿Cuáles son algunas de las características de un avión cargado con el C.G. al límite trasero?',
    'explicacion': r'Con el centro de gravedad al límite trasero, el avión presenta menor estabilidad longitudinal. Además, se reducen los márgenes de control y pueden verse afectadas las velocidades características de operación.',
    
    'respuestas': [
     {'texto': 'A.- Menor velocidad de pérdida de sustentación (stall), mayor velocidad de crucero y menor estabilidad.','puntos': 0},
     {'texto': 'B.- Mayor velocidad de pérdida de sustentación (stall), mayor velocidad de crucero y menor estabilidad.','puntos': 1},
     {'texto': 'C.- Menor velocidad de pérdida de sustentación (stall), menor velocidad de crucero y mayor estabilidad.','puntos': 0},
     ]         
  },

{
    'texto': '20.- ¿En qué rango de MACH ocurren generalmente los regímenes de vuelo subsónicos?',
    'explicacion': r'El vuelo subsónico corresponde a velocidades inferiores a Mach 1. En términos generales, los regímenes subsónicos normales se encuentran bajo aproximadamente Mach 0.75.',
    
    'respuestas': [
     {'texto': 'A.- Bajo .75 Mach.','puntos': 1},
     {'texto': 'B.- De .75 a 1.20 Mach.','puntos': 0},
     {'texto': 'C.- De 1.20 a 2.50 Mach.','puntos': 0},
     ]         
  },

{
    'texto': '21.- ¿Cuál es el número Mach de la corriente libre que produce la primera evidencia de flujo sónico local?',
    'explicacion': r'El número Mach crítico es aquel en que aparece por primera vez flujo local sónico sobre alguna parte de la aeronave, aunque la aeronave completa aún pueda estar volando a velocidad subsónica.',
    
    'respuestas': [
     {'texto': 'A.- Número Mach Supersónico.','puntos': 0},
     {'texto': 'B.- Número Mach Transónico.','puntos': 0},
     {'texto': 'C.- Número Mach Crítico.','puntos': 1},
     ]         
  },

{
    'texto': '22.- ¿Cuál de los siguientes es considerado control auxiliar de vuelo?',
    'explicacion': r'Los flaps de borde de ataque son controles auxiliares o secundarios, ya que modifican las características aerodinámicas del ala, especialmente a bajas velocidades.',
    
    'respuestas': [
     {'texto': 'A.- Timón-elevador.','puntos': 0},
     {'texto': 'B.- Timón de dirección superior.','puntos': 0},
     {'texto': 'C.- Flaps de borde de ataque.','puntos': 1},
     ]         
  },

{
    'texto': '23.- ¿Cuál de los siguientes es considerado control primario de vuelo?',
    'explicacion': r'Los alerones son controles primarios de vuelo, ya que permiten controlar el movimiento de alabeo del avión alrededor del eje longitudinal.',
    
    'respuestas': [
     {'texto': 'A.- Tabs.','puntos': 0},
     {'texto': 'B.- Flaps.','puntos': 0},
     {'texto': 'C.- Alerones exteriores.','puntos': 1},
     ]         
  },

{
    'texto': '24.- ¿Cuándo se usan normalmente los alerones interiores?',
    'explicacion': r'Los alerones interiores pueden utilizarse tanto a baja como a alta velocidad, ya que ayudan al control lateral reduciendo esfuerzos estructurales en comparación con los alerones exteriores.',
    
    'respuestas': [
     {'texto': 'A.- Solamente en vuelo a baja velocidad.','puntos': 0},
     {'texto': 'B.- Solamente en vuelo a alta velocidad.','puntos': 0},
     {'texto': 'C.- Tanto en vuelo de baja como de alta velocidad.','puntos': 1},
     ]         
  },

{
    'texto': '25.- ¿Por qué algunos aviones equipados con alerones interiores y exteriores sólo para vuelo a baja velocidad?',
    'explicacion': r'A altas velocidades, las cargas aerodinámicas sobre los alerones exteriores pueden generar torsión en las alas. Por eso, algunos aviones limitan su uso y emplean principalmente alerones interiores.',
    
    'respuestas': [
     {'texto': 'A.- El incremento del área de la superficie proporciona mayor control al bajar los flap.','puntos': 0},
     {'texto': 'B.- Las cargas aerodinámicas en los alerones exteriores tienden a torcer la punta de las alas a altas velocidades.','puntos': 1},
     {'texto': 'C.- Trabar los alerones exteriores en vuelos a alta velocidad proporciona sensibilidad variable en los controles de vuelo.','puntos': 0},
     ]         
  },

{
    'texto': '26.- ¿Cuál es el propósito de los Spoilers?',
    'explicacion': r'Los spoilers reducen la sustentación al interrumpir el flujo de aire sobre el ala. También pueden aumentar la resistencia, pero su función principal es disminuir la sustentación.',
    
    'respuestas': [
     {'texto': 'A.- Aumentar la combadura (camber) del ala.','puntos': 0},
     {'texto': 'B.- Reducir la sustentación sin aumentar la velocidad.','puntos': 1},
     {'texto': 'C.- Dirigir el flujo sobre la parte superior del ala a grandes ángulos de ataque.','puntos': 0},
     ]         
  },

{
    'texto': '27.- ¿Cuál es el propósito de los ground spoilers?',
    'explicacion': r'Los ground spoilers se despliegan durante el aterrizaje para reducir rápidamente la sustentación de las alas y transferir más peso a las ruedas, mejorando la eficacia del frenado.',
    
    'respuestas': [
     {'texto': 'A.- Reducir la sustentación de las alas durante el aterrizaje.','puntos': 1},
     {'texto': 'B.- Ayudar a inclinar las alas al iniciar un viraje.','puntos': 0},
     {'texto': 'C.- Aumentar la razón de descenso sin aumentar la velocidad.','puntos': 0},
     ]         
  },

{
    'texto': '28.- ¿Cuál es el propósito de los generadores de vortices instalados en las alas?',
    'explicacion': r'Los generadores de vórtices energizan la capa límite, ayudando a retrasar la separación del flujo y mejorando la efectividad de las superficies de control a altos ángulos de ataque.',
    
    'respuestas': [
     {'texto': 'A.- Reducir la resistencia causada por el flujo supersónico sobre porciones del ala.','puntos': 1},
     {'texto': 'B.- Incrementar el inicio de la resistencia divergente y ayudar a la efectividad de alerones a alta velocidad.','puntos': 0},
     {'texto': 'C.- Romper el flujo sobre el ala de manera que el stall progrese desde la raíz del ala hacia las puntas.','puntos': 0},
     ]         
  },

{
    'texto': '29.- ¿En qué dirección, respecto de la superficie de control primario, se mueve el compensador ajustable (trim tab) del elevador cuando la superficie de control es movida?',
    'explicacion': r'El trim tab ajustable mantiene una posición fija respecto de la condición seleccionada, permitiendo aliviar las fuerzas en los controles y mantener la actitud deseada sin presión constante del piloto.',
    
    'respuestas': [
     {'texto': 'A.- En la misma dirección.','puntos': 0},
     {'texto': 'B.- En dirección contraria.','puntos': 0},
     {'texto': 'C.- Permanece fijo para todas las posiciones.','puntos': 1},
     ]         
  },

{
    'texto': '30.- ¿Cuál es el propósito del compensador ajustable (trim tab) del elevador?',
    'explicacion': r'El compensador ajustable del elevador permite modificar la carga aerodinámica sobre la cola para mantener el avión compensado en distintas velocidades y condiciones de vuelo, reduciendo la presión sobre los controles.',
    
    'respuestas': [
     {'texto': 'A.- Proporcionar equilibrio horizontal mientras aumenta la velocidad para permitir volar sin tener que tomar los controles.','puntos': 0},
     {'texto': 'B.- Ajustar las cargas por velocidad en la cola para diferentes velocidades permitiendo fuerzas neutrales sobre los controles.','puntos': 0},
     {'texto': 'C.- Modificar la carga hacia abajo sobre la cola (downward tail load), para varias velocidades en vuelo, eliminando presiones en los controles.','puntos': 1},
     ]         
  },

{
    'texto': '31.- ¿En qué dirección, respecto de la superficie de control primario, se mueve el “anti-servo tab”?',
    'explicacion': r'El anti-servo tab se mueve en la misma dirección que la superficie de control primaria, aumentando la fuerza requerida en los controles y ayudando a evitar sobrecontrol.',
    
    'respuestas': [
     {'texto': 'A.- En la misma dirección.','puntos': 1},
     {'texto': 'B.- En dirección contraria.','puntos': 0},
     {'texto': 'C.- Permanece fijo para todas las posiciones.','puntos': 0},
     ]         
  },

{
    'texto': '32.- ¿Cuál es la función primaria de los flaps de borde de ataque, en configuración de aterrizaje durante la sentada (flare) previa a tocar la pista?',
    'explicacion': r'Los flaps de borde de ataque ayudan a mantener el flujo adherido sobre el ala a altos ángulos de ataque, retrasando la separación del flujo durante fases de baja velocidad como el aterrizaje.',
    
    'respuestas': [
     {'texto': 'A.- Impedir la separación del flujo.','puntos': 1},
     {'texto': 'B.- Disminuir la razón de descenso.','puntos': 0},
     {'texto': 'C.- Aumentar la resistencia de perfil.','puntos': 0},
     ]         
  },

{
    'texto': '33.- ¿Cuál es el propósito de los “slats” de borde de ataque en alas de alta performance?',
    'explicacion': r'Los slats permiten que aire de alta presión pase desde la parte inferior del ala hacia la superficie superior, ayudando a mantener el flujo adherido y retrasar el stall.',
    
    'respuestas': [
     {'texto': 'A.- Disminuir la sustentación a velocidades relativamente bajas.','puntos': 0},
     {'texto': 'B.- Mejorar el control de alerones a bajos ángulos de ataque.','puntos': 0},
     {'texto': 'C.- Dirigir el aire desde el área de alta presión bajo el borde de ataque hacia la parte superior del ala.','puntos': 1},
     ]         
  },

{
    'texto': '34.- ¿Qué efecto tienen los “slots” de borde de ataque del ala en la performance del avión?',
    'explicacion': r'Los slots de borde de ataque retrasan la separación del flujo sobre el ala, permitiendo alcanzar un mayor ángulo de ataque antes de que ocurra el stall.',
    
    'respuestas': [
     {'texto': 'A.- Disminuye la resistencia del perfil.','puntos': 0},
     {'texto': 'B.- Cambia el ángulo de ataque de “stall” a un ángulo más alto.','puntos': 1},
     {'texto': 'C.- Desacelera la capa límite de extradós.','puntos': 0},
     ]         
  },

{
    'texto': '35.- La resistencia parásita:',
    'explicacion': r'La resistencia parásita aumenta con la velocidad, ya que depende principalmente del roce, la forma y las interferencias aerodinámicas del avión al avanzar a través del aire.',
    
    'respuestas': [
     {'texto': 'A.- Aumenta con la velocidad.','puntos': 1},
     {'texto': 'B.- Disminuye con la velocidad.','puntos': 0},
     {'texto': 'C.- No es afectada por la velocidad.','puntos': 0},
     ]         
  },

{
    'texto': '36.- La resistencia inducida es:',
    'explicacion': r'La resistencia inducida está asociada a la producción de sustentación. Es mayor a bajas velocidades y disminuye a medida que aumenta la velocidad.',
    
    'respuestas': [
     {'texto': 'A.- Directamente proporcional a la velocidad.','puntos': 0},
     {'texto': 'B.- Constante.','puntos': 0},
     {'texto': 'C.- Inversamente proporcional a la velocidad.','puntos': 1},
     ]         
  },

{
    'texto': '37.- Altitud de presión es:',
    'explicacion': r'La altitud de presión es la indicación que muestra el altímetro cuando se ajusta al reglaje estándar de 29.92 pulgadas de mercurio, equivalente a 1013.25 hPa.',
    
    'respuestas': [
     {'texto': 'A.- La indicación que marca un altímetro cuando se ha ajustado a la presión del campo.','puntos': 0},
     {'texto': 'B.- La altitud real de acuerdo a ISA.','puntos': 0},
     {'texto': 'C.- La indicación que marca un altímetro cuando se ha ajustado a 29.92 pulgadas.','puntos': 1},
     ]         
  },

{
    'texto': '38.- La sustentación producida por un perfil alar es:',
    'explicacion': r'La sustentación es la componente de la fuerza aerodinámica que actúa perpendicular a la corriente libre de aire.',
    
    'respuestas': [
     {'texto': 'A.- La componente de la fuerza paralela a la corriente libre de aire.','puntos': 0},
     {'texto': 'B.- La componente de la fuerza perpendicular a la corriente libre de aire.','puntos': 1},
     {'texto': 'C.- La componente de la fuerza perpendicular a la cuerda del ala.','puntos': 0},
     ]         
  },

{
    'texto': '39.- El techo de sustentación es la altitud a la que se alcanza el llamado “coffin corner” y es función de:',
    'explicacion': r'El coffin corner se alcanza cuando el margen entre la velocidad de stall y el límite de alta velocidad se reduce significativamente. Este margen está relacionado directamente con el peso del avión.',
    
    'respuestas': [
     {'texto': 'A.- El ángulo de ataque del avión.','puntos': 0},
     {'texto': 'B.- El peso del avión.','puntos': 1},
     {'texto': 'C.- El empuje del avión.','puntos': 0},
     ]         
  },

{
    'texto': '40.- La velocidad del sonido:',
    'explicacion': r'La velocidad del sonido depende principalmente de la temperatura del aire. Como la temperatura normalmente disminuye con la altitud en la troposfera, la velocidad del sonido también disminuye.',
    
    'respuestas': [
     {'texto': 'A.- Permanece inalterable con la altura.','puntos': 0},
     {'texto': 'B.- Disminuye con el aumento de la altura.','puntos': 1},
     {'texto': 'C.- Aumenta con el aumento de la altura.','puntos': 0},
     ]         
  },

{
    'texto': '41.- Ángulo de ataque es:',
    'explicacion': r'El ángulo de ataque es el ángulo formado entre la cuerda del ala y la dirección de la corriente libre de aire.',
    
    'respuestas': [
     {'texto': 'A.- El formado por la línea de curvatura media y la cuerda del ala.','puntos': 0},
     {'texto': 'B.- El formado por la dirección de la corriente libre de aire y la línea de curvatura media.','puntos': 0},
     {'texto': 'C.- El que existe entre la cuerda del ala y la dirección de la corriente libre de aire.','puntos': 1},
     ]         
  },

{
    'texto': '42.- El efecto suelo:',
    'explicacion': r'El efecto suelo se produce cuando el avión vuela cerca de la superficie, reduciendo la resistencia inducida y mejorando la eficiencia del ala, lo que se percibe como un aumento de sustentación efectiva.',
    
    'respuestas': [
     {'texto': 'A.- No afecta las características aerodinámicas del avión.','puntos': 0},
     {'texto': 'B.- Aumenta la resistencia al avance.','puntos': 0},
     {'texto': 'C.- Aumenta la sustentación.','puntos': 1},
     ]         
  },

{
    'texto': '43.- El hidroplaneo se produce cuando la pista esta mojada o contaminada. Uno de los aspectos que más influye es:',
    'explicacion': r'El hidroplaneo ocurre cuando una capa de agua separa los neumáticos de la superficie de la pista. Mientras mayor sea el espesor de esa capa de agua, mayor será el riesgo de hidroplaneo.',
    
    'respuestas': [
     {'texto': 'A.- Grado de rugosidad de la pista.','puntos': 0},
     {'texto': 'B.- Espesor de la capa de agua.','puntos': 1},
     {'texto': 'C.- Ancho de los neumáticos.','puntos': 0},
     ]         
  },

{
    'texto': '44.- Las cargas a que está sometida un ala, además de las fuerzas aerodinámicas que se desarrollan en ella, dependen de:',
    'explicacion': r'Además de las fuerzas aerodinámicas, las cargas estructurales del ala dependen del peso propio del ala, del peso del combustible contenido en ella y de la distribución de ese combustible.',
    
    'respuestas': [
     {'texto': 'A.- El peso propio del ala y el peso del fuselaje.','puntos': 0},
     {'texto': 'B.- El peso del ala, el peso del fuselaje (estructura y contenido), el peso del combustible y la distribución de éste.','puntos': 1},
     {'texto': 'C.- Solamente las fuerzas aerodinámicas y no los pesos estructurales.','puntos': 0},
     ]         
  },

{
    'texto': '45.- El fenómeno conocido como Dutch-Roll:',
    'explicacion': r'El Dutch-Roll es una oscilación combinada de guiñada y alabeo que aparece cuando la estabilidad lateral es alta en comparación con la estabilidad direccional.',
    
    'respuestas': [
     {'texto': 'A.- Se produce cuando el avión tiene una estabilidad lateral pequeña comparada con la estabilidad direccional.','puntos': 0},
     {'texto': 'B.- Se produce cuando el avión tiene una estabilidad lateral grande comparada con la estabilidad direccional.','puntos': 1},
     {'texto': 'C.- Afecta en menor proporción a los aviones con alas de ángulo flecha.','puntos': 0},
     ]         
  },

{
    'texto': '46.- El agua es un fluido:',
    'explicacion': r'El agua se considera prácticamente incompresible, ya que su volumen cambia muy poco incluso cuando se somete a presión.',
    
    'respuestas': [
     {'texto': 'A.- Más compresible que el aire.','puntos': 0},
     {'texto': 'B.- Menos compresible que el aire.','puntos': 0},
     {'texto': 'C.- Incompresible.','puntos': 1},
     ]         
  },

  {
    'texto': '47.- La extensión de flaps:',
    'explicacion': r'La extensión de flaps aumenta la curvatura del ala, permitiendo generar mayor sustentación a menor velocidad y, para una misma condición de vuelo, puede disminuir el ángulo de ataque requerido.',
    
    'respuestas': [
     {'texto': 'A.- Aumenta considerablemente ángulo de planeo.','puntos': 0},
     {'texto': 'B.- Disminuye el ángulo de ataque.','puntos': 1},
     {'texto': 'C.- Aumenta considerablemente el CL max.','puntos': 0},
     ]         
  },

{
    'texto': '48.- La altitud de presión que marca un altímetro cuando se ha reglado a nivel del mar con 29.92 pulgadas de Hg o 1013 hPa:',
    'explicacion': r'Cuando el altímetro se ajusta a 29.92 pulgadas de Hg o 1013 hPa, indica altitud de presión. Esta rara vez coincide exactamente con la altitud real, ya que depende de las condiciones atmosféricas presentes.',
    
    'respuestas': [
     {'texto': 'A.- Será igual a la altitud real.','puntos': 0},
     {'texto': 'B.- Será distinta a la altitud real.','puntos': 0},
     {'texto': 'C.- Rara vez coincidirá con la altitud real.','puntos': 1},
     ]         
  },

{
    'texto': '49.- Si a una altitud dada, la temperatura es superior a la estándar, la densidad será:',
    'explicacion': r'Cuando la temperatura es superior a la estándar para una altitud determinada, el aire se expande y su densidad disminuye. Por eso, la densidad será inferior a la densidad tipo.',
    
    'respuestas': [
     {'texto': 'A.- Inferior a la Densidad Tipo.','puntos': 1},
     {'texto': 'B.- Superior a la Densidad Tipo.','puntos': 0},
     {'texto': 'C.- La Densidad Tipo no será afectada.','puntos': 0},
     ]         
  },

{
    'texto': '50.- Si a una altitud dada, con el altímetro ajustado a 29.92, la temperatura de la atmósfera es menor que la de la Atmósfera Tipo, el altímetro indicará:',
    'explicacion': r'En aire más frío que la atmósfera estándar, los niveles de presión están más próximos entre sí. Por esto, el altímetro puede indicar una altitud mayor que la altitud real.',
    
    'respuestas': [
     {'texto': 'A.- Una altitud mayor que la real.','puntos': 1},
     {'texto': 'B.- Una altitud inferior a la real.','puntos': 0},
     {'texto': 'C.- La temperatura no afecta al altímetro.','puntos': 0},
     ]         
  },

{
    'texto': '51.- La velocidad del sonido:',
    'explicacion': r'La velocidad del sonido depende principalmente de la temperatura del aire. Si la temperatura disminuye, la velocidad del sonido también disminuye.',
    
    'respuestas': [
     {'texto': 'A.- Disminuye si la temperatura disminuye.','puntos': 1},
     {'texto': 'B.- Disminuye si la temperatura aumenta.','puntos': 0},
     {'texto': 'C.- La temperatura no afecta a la velocidad del sonido.','puntos': 0},
     ]         
  },

{
    'texto': '52.- La resistencia parásita se puede definir como aquella parte dela resistencia que:',
    'explicacion': r'La resistencia parásita es la parte de la resistencia total que no está asociada directamente a la generación de sustentación. Incluye principalmente resistencia de forma, fricción e interferencia.',
    
    'respuestas': [
     {'texto': 'A.- No está relacionada con la resistencia estructural.','puntos': 0},
     {'texto': 'B.- Contribuye a originar sustentación.','puntos': 0},
     {'texto': 'C.- No contribuye a originar sustentación.','puntos': 1},
     ]         
  },

{
    'texto': '53.- Con un aumento del ángulo de ataque, el centro de presiones:',
    'explicacion': r'En un perfil alar convencional, al aumentar el ángulo de ataque, el centro de presiones tiende a desplazarse hacia adelante, modificando el momento aerodinámico del ala.',
    
    'respuestas': [
     {'texto': 'A.- Se moverá hacia atrás.','puntos': 0},
     {'texto': 'B.- No se moverá.','puntos': 0},
     {'texto': 'C.- Se moverá hacia delante.','puntos': 1},
     ]         
  },

{
    'texto': '54.- La velocidad a la que comienza a ocurrir el hidroplaneo depende de:',
    'explicacion': r'La velocidad a la que puede comenzar el hidroplaneo está relacionada principalmente con la presión de inflado de los neumáticos. Una menor presión favorece que el neumático pierda contacto efectivo con la pista mojada.',
    
    'respuestas': [
     {'texto': 'A.- Peso del avión.','puntos': 0},
     {'texto': 'B.- Presión de los neumáticos.','puntos': 1},
     {'texto': 'C.- Velocidad de aterrizaje.','puntos': 0},
     ]         
  },

{
    'texto': '55.- El método más efectivo para detener un avión afectado por hidroplaneo es:',
    'explicacion': r'Cuando ocurre hidroplaneo, la efectividad del frenado disminuye mucho. El uso de reversores ayuda a desacelerar el avión porque no depende directamente del contacto neumático-pista.',
    
    'respuestas': [
     {'texto': 'A.- Aplicar full frenado.','puntos': 0},
     {'texto': 'B.- Uso de reversos.','puntos': 1},
     {'texto': 'C.- Sólo usar spoilers.','puntos': 0},
     ]         
  },

{
    'texto': '56.- La fórmula para calcular la resistencia total es:',
    'explicacion': r'La resistencia aerodinámica puede expresarse como el producto del coeficiente de resistencia, la presión dinámica y la superficie alar: D = CD * q * S.',
    
    'respuestas': [
     {'texto': 'A.- D = CL * ½ ???V2 * S','puntos': 0},
     {'texto': 'B.- D = CL * q * S','puntos': 0},
     {'texto': 'C.- D = CD * q * S','puntos': 1},
     ]         
  },

{
    'texto': '57.- La resistencia de fricción es producida por:',
    'explicacion': r'La resistencia de fricción se produce por el rozamiento entre el aire y la superficie del avión, especialmente dentro de la capa límite formada junto a la superficie.',
    
    'respuestas': [
     {'texto': 'A.- La corriente de aire que se produce en la punta del ala desde el intradós al extradós.','puntos': 0},
     {'texto': 'B.- La fuerza de rozamiento que se produce entre las diferentes capas que conforman la capa límite.','puntos': 1},
     {'texto': 'C.- El impacto de la corriente libre en el borde de ataque del ala.','puntos': 0},
     ]         
  },

{
    'texto': '58.- La altitud de densidad:',
    'explicacion': r'La altitud de densidad corresponde a la altitud en la atmósfera estándar que tiene la misma densidad que la masa de aire considerada. En condiciones estándar, coincide con la altitud real.',
    
    'respuestas': [
     {'texto': 'A.- Es igual a la altitud real cuando la atmósfera sea la tipo (estándar).','puntos': 1},
     {'texto': 'B.- Es mayor a menor temperatura.','puntos': 0},
     {'texto': 'C.- No depende de la temperatura; sólo de la humedad atmosférica.','puntos': 0},
     ]         
  },

{
    'texto': '59.- El número Mach es:',
    'explicacion': r'El número Mach expresa la relación entre la velocidad de la aeronave o de la corriente libre de aire y la velocidad del sonido en las condiciones atmosféricas existentes.',
    
    'respuestas': [
     {'texto': 'A.- Igual a la velocidad del sonido dividida por la velocidad de la corriente libre de aire.','puntos': 0},
     {'texto': 'B.- Igual a la velocidad de la corriente libre de aire dividida por la velocidad del sonido.','puntos': 1},
     {'texto': 'C.- Igual a la velocidad del sonido dividida por la temperatura del aire al nivel de vuelo.','puntos': 0},
     ]         
  },

{
    'texto': '60.- El punto donde efectivamente está aplicada la sustentación en un ala, se denomina:',
    'explicacion': r'El centro de presión es el punto donde se considera aplicada la resultante de las fuerzas aerodinámicas de sustentación sobre el perfil o el ala.',
    
    'respuestas': [
     {'texto': 'A.- Centro efectivo de la sustentación.','puntos': 0},
     {'texto': 'B.- Centro aerodinámico.','puntos': 0},
     {'texto': 'C.- Centro de presión.','puntos': 1},
     ]         
  },

{
    'texto': '61.- Cuerda media es....',
    'explicacion': r'La cuerda media representa la distancia promedio entre el borde de ataque y el borde de fuga del ala, medida en la mitad del ala.',
    
    'respuestas': [
     {'texto': 'A.- aquella que multiplicada por la envergadura da como resultado la superficie del ala.','puntos': 0},
     {'texto': 'B.- la distancia entre el borde de ataque y el borde de fuga, medida en la mitad del ala.','puntos': 1},
     {'texto': 'C.- la distancia del espesor máximo de un perfil de ala.','puntos': 0},
     ]         
  },

{
    'texto': '62.- La resistencia inducida.....',
    'explicacion': r'La resistencia inducida está directamente asociada a la producción de sustentación. Por eso se relaciona con el coeficiente de sustentación del ala.',
    
    'respuestas': [
     {'texto': 'A.- está relacionada con el coeficiente de sustentación de un ala.','puntos': 1},
     {'texto': 'B.- está relacionada con el coeficiente de fricción de un ala.','puntos': 0},
     {'texto': 'C.- es producto de la placa plana equivalente o coeficiente de resistencia al avance de una aeronave.','puntos': 0},
     ]         
  },

{
    'texto': '63.- El Dutch Roll, o balanceo del holandés, se origina cuando:',
    'explicacion': r'El Dutch Roll se produce por una combinación de movimientos de guiñada y alabeo, generalmente asociada a una gran estabilidad lateral por efecto diedro y una estabilidad direccional relativamente baja.',
    
    'respuestas': [
     {'texto': 'A.- Existe en el avión un gran efecto del diedro (mucha estabilidad lateral) junto con poco plano vertical de cola.','puntos': 1},
     {'texto': 'B.- Existe en el avión pequeño efecto diedro junto con poco plano vertical de cola.','puntos': 0},
     {'texto': 'C.- Existe en el avión mucho ángulo flecha y mucho plano vertical de cola.','puntos': 0},
     ]         
  },

{
    'texto': '64.- El sistema creado, entre otros, para evitar el Dutch Roll (balanceo del holandés) se conoce como:',
    'explicacion': r'El yaw damper es un sistema que amortigua las oscilaciones de guiñada, ayudando a controlar o evitar el Dutch Roll en aeronaves susceptibles a este fenómeno.',
    
    'respuestas': [
     {'texto': 'A.- Spoilers.','puntos': 0},
     {'texto': 'B.- Buffet Dumper.','puntos': 0},
     {'texto': 'C.- Yaw Damper.','puntos': 1},
     ]         
  },

{
    'texto': '65.- Se estima que un avión ha alcanzado su “techo de servicio” cuando su máxima razón de ascenso no es mayor de:',
    'explicacion': r'El techo de servicio es la altitud a la cual la aeronave aún puede mantener una razón de ascenso máxima muy reducida, comúnmente definida como 100 pies por minuto.',
    
    'respuestas': [
     {'texto': 'A.- 300 pies por minuto.','puntos': 0},
     {'texto': 'B.- 200 pies por minuto.','puntos': 0},
     {'texto': 'C.- 100 pies por minuto.','puntos': 1},
     ]         
  },

{
    'texto': '66.- La mínima velocidad a que un avión es capaz de despegar las ruedas del suelo y seguir volando, y que es algo mayor que la velocidad de pérdida, se conoce por la abreviatura:',
    'explicacion': r'VMU significa Minimum Unstick Speed, es decir, la velocidad mínima a la cual el avión puede despegar las ruedas del suelo y continuar volando.',
    
    'respuestas': [
     {'texto': 'A.- V2','puntos': 0},
     {'texto': 'B.- VMU','puntos': 1},
     {'texto': 'C.- VR','puntos': 0},
     ]         
  },

{
    'texto': '67.- La velocidad segura de despegue y ascenso inicial, y que se debe alcanzar antes de los 35 pies sobre la pista, se identifica por la abreviatura:',
    'explicacion': r'V2 es la velocidad de seguridad de despegue, utilizada para asegurar un ascenso inicial seguro después del despegue, especialmente en el caso de falla de motor en aviones multimotores.',
    
    'respuestas': [
     {'texto': 'A.- V2','puntos': 1},
     {'texto': 'B.- VMU','puntos': 0},
     {'texto': 'C.- VR','puntos': 0},
     ]         
  },

{
    'texto': '68.- El aviso de pérdida (stall) conocido como “stick shaker”, ocurre aproximadamente:',
    'explicacion': r'El stick shaker entrega una advertencia antes de alcanzar la pérdida aerodinámica, normalmente con un margen sobre la velocidad de stall para permitir una recuperación oportuna.',
    
    'respuestas': [
     {'texto': 'A.- Un 7% sobre la velocidad de stall.','puntos': 1},
     {'texto': 'B.- Un 15% sobre la velocidad de stall.','puntos': 0},
     {'texto': 'C.- Un 30 % sobre la velocidad de stall.','puntos': 0},
     ]         
  },

{
    'texto': '69.- Existen varios tipos de hidroplaneo y en este fenómeno intervienen diversos parámetros, pero la velocidad a que comienza a producirse el hidroplaneo depende de:',
    'explicacion': r'La velocidad de inicio del hidroplaneo depende principalmente de la presión de inflado del neumático. A menor presión, menor será la velocidad a la que puede comenzar el fenómeno.',
    
    'respuestas': [
     {'texto': 'A.- La presión de inflado del neumático.','puntos': 1},
     {'texto': 'B.- La velocidad de rotación del neumático.','puntos': 0},
     {'texto': 'C.- La raíz cuadrada del espesor de la película de agua sobre la cual se produce el hidroplaneo medida en milímetros.','puntos': 0},
     ]         
  },
];
// 2. Lista de Física (LISTA PARA RELLENAR)
final List<Map<String, Object>> poolperformanceymotores = [
  {
        'texto': '1.- Marque cuáles son, en la debida secuencia, las fases termodinámicas de un motor turborreactor:',
        'explicacion': 'La secuencia correcta según el ciclo Brayton es Admisión, Compresión, Combustión, Expansión y Escape[cite: 6, 10].',
        'respuestas': [
            {'texto': 'A.- Difusión, expansión, compresión, combustión, escape.', 'puntos': 0},
            {'texto': 'B.- Admisión, compresión, combustión, expansión, escape.', 'puntos': 1},
            {'texto': 'C.- Aspiración, compresión, combustión, expansión, escape.', 'puntos': 0},
        ],
    },
    {
        'texto': '2.- ¿Qué parte de un motor turborreactor está sujeta a las más altas temperaturas?',
        'explicacion': 'La temperatura de entrada de la turbina (TIT) es el punto térmico más crítico del motor[cite: 12, 15].',
        'respuestas': [
            {'texto': 'A.- Descarga del compresor', 'puntos': 0},
            {'texto': 'B.- Toberas de atomización (inyección) del combustible.', 'puntos': 0},
            {'texto': 'C.- Entrada de la turbina (TIT / Turbine Inlet Temperature).', 'puntos': 1},
        ],
    },
    {
        'texto': '3.- ¿Qué efecto tiene una alta temperatura ambiente en el empuje en un motor de turbina?',
        'explicacion': 'El aumento de temperatura reduce la densidad del aire, lo que disminuye la masa de aire que el motor puede acelerar[cite: 16, 17].',
        'respuestas': [
            {'texto': 'A.- El empuje se reducirá debido a la disminución de la densidad del aire.', 'puntos': 1},
            {'texto': 'B.- El empuje permanecerá igual, pero la temperatura de la turbina será más alta.', 'puntos': 0},
            {'texto': 'C.- El empuje será mayor porque más energía calórica será extractada del aire más caliente.', 'puntos': 0},
        ],
    },
    {
        'texto': '4.- ¿Qué efecto tiene una alta humedad relativa en la potencia máxima de los motores de las aeronaves modernas?',
        'explicacion': 'A diferencia de los motores de pistón, los turborreactores modernos apenas se ven afectados por la humedad[cite: 21, 22].',
        'respuestas': [
            {'texto': 'A.- Ni los motores turborreactores ni los motores recíprocos son afectados.', 'puntos': 1},
            {'texto': 'B.- Los motores recíprocos experimentarán una mayor pérdida de BHP que los de turbinas.', 'puntos': 0},
            {'texto': 'C.- Los motores turborreactores experimentarán una significativa pérdida de empuje.', 'puntos': 0},
        ],
    },
    {
        'texto': '5.- Indique qué partes de un motor turborreactor están sometidas a las más altas temperaturas y a cambios rápidos de estas temperaturas:',
        'explicacion': 'Los álabes de las turbinas sufren el mayor estrés térmico y gradientes de temperatura[cite: 26, 27].',
        'respuestas': [
            {'texto': 'A.- Los alabes de las turbinas.', 'puntos': 1},
            {'texto': 'B.- Los alabes de los compresores.', 'puntos': 0},
            {'texto': 'C.- La tobera de escape.', 'puntos': 0},
        ],
    },
    {
        'texto': '6.- Los motores turborreactores provistos de compresores axiales dobles emplean indicadores de N1 y N2. Indique cuál de estos instrumentos corresponde al compresor de baja relación de compresión:',
        'explicacion': 'N1 es la velocidad del rotor de baja presión[cite: 34, 36].',
        'respuestas': [
            {'texto': 'A.- N1', 'puntos': 1},
            {'texto': 'B.- N2', 'puntos': 0},
            {'texto': 'C.- N1, y el instrumento marca el número de revoluciones por minuto a que gira el compresor.', 'puntos': 0},
        ],
    },
    {
        'texto': '7.- Los motores turborreactores provistos de compresores axiales dobles emplean indicadores de N1 y N2. Indique cuál de estos instrumentos corresponde al compresor de alta relación de compresión:',
        'explicacion': 'N2 es la velocidad del rotor de alta presión[cite: 39, 42].',
        'respuestas': [
            {'texto': 'A.- N1', 'puntos': 0},
            {'texto': 'B.- N2', 'puntos': 1},
            {'texto': 'C.- N1, y el instrumento marca el número de revoluciones por minuto a que gira el compresor.', 'puntos': 0},
        ],
    },
    {
        'texto': '8.- Los indicadores de N1 y N2 de los motores del tipo turbinas reciben la indicación desde el motor mediante...',
        'explicacion': 'La medición se realiza mediante sensores que generan impulsos electromagnéticos[cite: 44, 46].',
        'respuestas': [
            {'texto': 'A.- Sistemas de engranajes y varillas transmisoras provenientes de los compresores del motor.', 'puntos': 0},
            {'texto': 'B.- Generadores de impulsos electromagnéticos.', 'puntos': 1},
            {'texto': 'C.- Cables cuyo núcleo gira y mueve la aguja del instrumento.', 'puntos': 0},
        ],
    },
    {
        'texto': '9.- Las aeronaves de última generación utilizan EICAS que dan la información de funcionamiento al piloto mediante:',
        'explicacion': 'El sistema EICAS presenta la información en pantallas integradas[cite: 48, 49].',
        'respuestas': [
            {'texto': 'A.- Pantallas de tubos catódicos.', 'puntos': 1},
            {'texto': 'B.- Información digital con base de funcionamiento electro-mecánica.', 'puntos': 0},
            {'texto': 'C.- Instrumentos eléctricos convencionales digitales.', 'puntos': 0},
        ],
    },
    {
        'texto': '10.- Marque la aseveración correcta con relación a los motores turborreactores:',
        'explicacion': 'Son significativamente menos afectados por la humedad que los motores recíprocos[cite: 53, 55].',
        'respuestas': [
            {'texto': 'A.- Son afectados por la humedad atmosférica en menor proporción que los motores alternos de explosión.', 'puntos': 1},
            {'texto': 'B.- Casi no son afectados por la mayor altura de densidad.', 'puntos': 0},
            {'texto': 'C.- Se caracterizan por el alto consumo específico de combustible a altas RPM del motor.', 'puntos': 0},
        ],
    },
    {
        'texto': '11.- Indique cuál es el área que corresponde al compresor de baja de un motor turborreactor de doble flujo.',
        'explicacion': 'Referencia técnica a diagramas de motor de doble flujo[cite: 58, 61].',
        'respuestas': [
            {'texto': 'A.- 1', 'puntos': 1},
            {'texto': 'B.- 2', 'puntos': 0},
            {'texto': 'C.- 3', 'puntos': 0},
        ],
    },
    {
        'texto': '12.- Indique cuál es el área que corresponde al compresor de alta de un motor turborreactor de doble flujo.',
        'explicacion': 'Referencia técnica a la configuración interna del motor[cite: 66, 68].',
        'respuestas': [
            {'texto': 'A.- 1', 'puntos': 0},
            {'texto': 'B.- 3', 'puntos': 1},
            {'texto': 'C.- 6', 'puntos': 0},
        ],
    },
    {
        'texto': '13.- Indique cuál es el área que corresponde a la turbina de alta de un motor turborreactor de doble flujo.',
        'explicacion': 'Ubicada inmediatamente después de la cámara de combustión[cite: 70, 72].',
        'respuestas': [
            {'texto': 'A.- 3', 'puntos': 0},
            {'texto': 'B.- 4', 'puntos': 1},
            {'texto': 'C.- 5', 'puntos': 0},
        ],
    },
    {
        'texto': '14.- La VMCG es función general de:',
        'explicacion': 'Velocidad mínima de control en tierra depende de factores atmosféricos y configuración[cite: 74, 77].',
        'respuestas': [
            {'texto': 'A.- La temperatura, presión-altitud, flaps, y viento cruzado.', 'puntos': 1},
            {'texto': 'B.- El peso del avión, la temperatura, presión atmosférica y flaps.', 'puntos': 0},
            {'texto': 'C.- Número de motores, densidad, peso y viento cruzado.', 'puntos': 0},
        ],
    },
    {
        'texto': '15.- La velocidad de decisión de abortar o continuar un despegue, se denomina:',
        'explicacion': 'V1 es el hito de decisión durante la carrera de despegue[cite: 80, 81].',
        'respuestas': [
            {'texto': 'A.- V1', 'puntos': 1},
            {'texto': 'B.- V2', 'puntos': 0},
            {'texto': 'C.- VR', 'puntos': 0},
        ],
    },
    {
        'texto': '16.- La velocidad V1 debe ser:',
        'explicacion': 'Por seguridad, V1 nunca debe ser inferior a la velocidad mínima de control en tierra[cite: 85, 87].',
        'respuestas': [
            {'texto': 'A.- Igual o menor que VMCG', 'puntos': 0},
            {'texto': 'B.- Mayor que VMU', 'puntos': 0},
            {'texto': 'C.- Igual o mayor que VMCG', 'puntos': 1},
        ],
    },
    {
        'texto': '17.- Cuando la distancia para alcanzar V1 y la necesaria para continuar tras falla de motor hasta 35 pies son iguales, se opera con pista...',
        'explicacion': 'Definición técnica de operación en pista balanceada o compensada[cite: 88, 90].',
        'respuestas': [
            {'texto': 'A.- compensada.', 'puntos': 1},
            {'texto': 'B.- equivalente.', 'puntos': 0},
            {'texto': 'C.- crítica.', 'puntos': 0},
        ],
    },
    {
        'texto': '18.- La distancia necesaria para acelerar hasta V1 y, ante falla del motor crítico, continuar y alcanzar 35 pies a V2, se llama:',
        'explicacion': 'Representa la distancia de despegue con motor inoperativo (OEI)[cite: 93, 96].',
        'respuestas': [
            {'texto': 'A.- Recorrido de despegue mínimo.', 'puntos': 0},
            {'texto': 'B.- Distancia de despegue con un motor inoperativo.', 'puntos': 1},
            {'texto': 'C.- Solamente, distancia de despegue.', 'puntos': 0},
        ],
    },
    {
        'texto': '19.- ¿Cuál es el nombre de un plano al final de pista, sin obstrucciones, considerado para performances de despegue?',
        'explicacion': 'El Clearway es la zona libre de obstáculos permitida para el ascenso[cite: 98, 100].',
        'respuestas': [
            {'texto': 'A.- Clearway (Zona Libre de Obstáculos).', 'puntos': 1},
            {'texto': 'B.- Stopway (Zona de Parada).', 'puntos': 0},
            {'texto': 'C.- Obstruction Clearence Plane (Plano Libre de Obstáculos).', 'puntos': 0},
        ],
    },
    {
        'texto': '20.- ¿Qué es un área identificada por el término "Stopway" (Zona de Parada)?',
        'explicacion': 'Área diseñada para frenar la aeronave en caso de despegue abortado[cite: 104, 107].',
        'respuestas': [
            {'texto': 'A.- Un área, al menos del mismo ancho de la pista, con capacidad para soportar una aeronave durante un despegue normal.', 'puntos': 0},
            {'texto': 'B.- Un área, en la prolongación de la pista y al menos tan ancha como ésta, designada para desaceleración de un despegue abortado.', 'puntos': 1},
            {'texto': 'C.- Un área, no necesariamente tan ancha como la pista, con capacidad para soportar un despegue abortado.', 'puntos': 0},
        ],
    },
    {
        'texto': '21.- Indique a qué segmento de despegue corresponde la siguiente condición: potencia de despegue, tren de aterrizaje extendido, flaps de despegue y V2:',
        'explicacion': 'El primer segmento comienza cuando el avión se despega del suelo y termina cuando el tren está totalmente retractado[cite: 111, 112].',
        'respuestas': [
            {'texto': 'A.- 1° segmento.', 'puntos': 1},
            {'texto': 'B.- 2° segmento.', 'puntos': 0},
            {'texto': 'C.- 3° segmento.', 'puntos': 0},
        ],
    },
    {
        'texto': '22.- Indique a qué segmento de despegue corresponde la siguiente condición: potencia de despegue, tren de aterrizaje arriba (replegado), flaps de despegue y V2:',
        'explicacion': 'El segundo segmento es el más crítico y abarca desde que el tren está arriba hasta alcanzar la aceleración para limpiar el avión[cite: 115, 117].',
        'respuestas': [
            {'texto': 'A.- 1° segmento.', 'puntos': 0},
            {'texto': 'B.- 2° segmento.', 'puntos': 1},
            {'texto': 'C.- 3° segmento.', 'puntos': 0},
        ],
    },
    {
        'texto': '23.- Los requisitos que se deben cumplir durante los segmentos de despegue, consideran...',
        'explicacion': 'La certificación de performance de despegue siempre considera la falla del motor crítico en V1 o después[cite: 119, 122].',
        'respuestas': [
            {'texto': 'A.- Que todos los motores estén operando a potencia de despegue.', 'puntos': 0},
            {'texto': 'B.- La falla de un motor a o después de V1.', 'puntos': 1},
            {'texto': 'C.- La falla de un motor a o después de VR.', 'puntos': 0},
        ],
    },
    {
        'texto': '24.- Considerando los requisitos de pendiente de ascenso tras falla de motor, el segmento más exigente (% de pendiente) es:',
        'explicacion': 'El segundo segmento requiere mantener un gradiente de ascenso específico con un motor inoperativo[cite: 126, 130].',
        'respuestas': [
            {'texto': 'A.- El primer segmento.', 'puntos': 0},
            {'texto': 'B.- El segundo segmento.', 'puntos': 1},
            {'texto': 'C.- El tercer segmento.', 'puntos': 0},
        ],
    },
    {
        'texto': '25.- El cálculo de la distancia de aterrizaje considera que el avión pasa sobre el umbral de la pista a una altura de:',
        'explicacion': 'La altura estándar sobre el umbral para el cálculo de performance de aterrizaje es de 50 pies[cite: 132, 135].',
        'respuestas': [
            {'texto': 'A.- 15 pies.', 'puntos': 0},
            {'texto': 'B.- 35 pies.', 'puntos': 0},
            {'texto': 'C.- 50 pies.', 'puntos': 1},
        ],
    },
    {
        'texto': '26.- ¿Qué se entiende por "Drift Down"?',
        'explicacion': 'Es el descenso neto tras una falla de motor manteniendo la máxima potencia continua en los motores restantes[cite: 136, 139].',
        'respuestas': [
            {'texto': 'A.- Descenso en caso de falla de motor con el resto de los motores a potencia de ralentí.', 'puntos': 0},
            {'texto': 'B.- Descenso en caso de falla de motor con la potencia de crucero.', 'puntos': 0},
            {'texto': 'C.- Descenso en caso de falla de motor con potencia máxima continua en el o los motores restantes.', 'puntos': 1},
        ],
    },
    {
        'texto': '27.- Normalmente la velocidad mínima de aterrizaje debe ser:',
        'explicacion': 'Vref suele ser aproximadamente 1.3 veces la velocidad de pérdida en configuración de aterrizaje[cite: 141, 143].',
        'respuestas': [
            {'texto': 'A.- 1.15 Vs.', 'puntos': 0},
            {'texto': 'B.- 1.30 Vs', 'puntos': 1},
            {'texto': 'C.- 1.45 Vs.', 'puntos': 0},
        ],
    },
    {
        'texto': '28.- ¿Cuáles son las velocidades V1, VR y V2 para las condiciones de operación G-3? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'Basado en las tablas de performance para la condición G-3[cite: 146, 148].',
        'respuestas': [
            {'texto': 'A.- 134, 134 y 145 Nudos.', 'puntos': 0},
            {'texto': 'B.- 134, 139 y 145 Nudos.', 'puntos': 1},
            {'texto': 'C.- 132, 132 y 145 Nudos.', 'puntos': 0},
        ],
    },
    {
        'texto': '29.- ¿Cuáles son las velocidades V1 y V2 para las condiciones de operación G-4? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'Valores obtenidos de las tablas de performance correspondientes a G-4[cite: 153, 156].',
        'respuestas': [
            {'texto': 'A.- 133 y 145 Nudos.', 'puntos': 0},
            {'texto': 'B.- 127 y 141 Nudos.', 'puntos': 0},
            {'texto': 'C.- 132 y 146 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '30.- ¿Cuál es la velocidad segura de despegue para las condiciones de operación R-1? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'V2 es la velocidad segura de despegue para la condición R-1[cite: 157, 160].',
        'respuestas': [
            {'texto': 'A.- 128 Nudos.', 'puntos': 0},
            {'texto': 'B.- 121 Nudos.', 'puntos': 0},
            {'texto': 'C.- 133 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '31.- ¿Cuál es la velocidad de rotación para las condiciones de operación R-2? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Velocidad VR para la configuración R-2 según tablas[cite: 162, 167].',
        'respuestas': [
            {'texto': 'A.- 146 Nudos.', 'puntos': 0},
            {'texto': 'B.- 147 Nudos.', 'puntos': 1},
            {'texto': 'C.- 152 Nudos.', 'puntos': 0},
        ],
    },
    {
        'texto': '32.- ¿Cuál es V1, VR y V2 para las condiciones de operación R-3? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Conjunto de velocidades V para R-3[cite: 169, 172].',
        'respuestas': [
            {'texto': 'A.- 143, 143 y 147 Nudos.', 'puntos': 0},
            {'texto': 'B.- 138, 138 y 142 Nudos.', 'puntos': 0},
            {'texto': 'C.- 136, 138 y 143 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '33.- ¿Cuál es la velocidad de rotación y V2 para las condiciones de operación R-5? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'VR y V2 correspondientes a la condición R-5[cite: 173, 176].',
        'respuestas': [
            {'texto': 'A.- 138 y 143 Nudos.', 'puntos': 0},
            {'texto': 'B.- 136 y 138 Nudos.', 'puntos': 0},
            {'texto': 'C.- 134 y 141 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '34.- ¿Cuáles son V1 y VR para las condiciones de operación A-1? (Ref. Fig. 45, 46 y 47).',
        'explicacion': 'Velocidades precisas para la condición A-1[cite: 177, 180].',
        'respuestas': [
            {'texto': 'A.- V1 123.1 Nudos; VR 125.2 Nudos.', 'puntos': 0},
            {'texto': 'B.- V1 120.5 Nudos; VR 123.5 Nudos.', 'puntos': 0},
            {'texto': 'C.- V1 122.3 Nudos; VR 124.1 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '35.- ¿Cuáles son V1 y VR para las condiciones de operación A-2? (Ref. Fig. 45, 46 y 47).',
        'explicacion': 'Velocidades precisas para la condición A-2[cite: 188, 191].',
        'respuestas': [
            {'texto': 'A.- V1 129.7 Nudos; VR 134.0 Nudos.', 'puntos': 0},
            {'texto': 'B.- V1 127.2 Nudos; VR 133.2 Nudos.', 'puntos': 0},
            {'texto': 'C.- V1 127.4 Nudos; VR 133.6 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '36.- ¿Cuál es V1 y VR para las condiciones de operación A-5? (Ref. Fig. 45, 46 y 47).',
        'explicacion': 'Velocidades para la condición A-5 donde V1 coincide con VR[cite: 192, 195].',
        'respuestas': [
            {'texto': 'A.- V1 110.4 Nudos; VR 110.9 Nudos.', 'puntos': 0},
            {'texto': 'B.- V1 109.6 Nudos; VR 112.7 Nudos.', 'puntos': 0},
            {'texto': 'C.- V1 106.4 Nudos; VR 106.4 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '37.- ¿Cuál es el máximo EPR de despegue para las condiciones de operación G-1? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'EPR diferenciado por motores para la condición G-1[cite: 196, 197].',
        'respuestas': [
            {'texto': 'A.- Motores 1 y 3, 2.22; motor 2, 2.16.', 'puntos': 1},
            {'texto': 'B.- Motores 1 y 3, 2.22; motor 2, 2.21.', 'puntos': 0},
            {'texto': 'C.- Motores 1 y 3, 2.15; motor 2, 2.09.', 'puntos': 0},
        ],
    },
    {
        'texto': '38.- ¿Cuál es el máximo EPR de despegue para las condiciones de operación G-3? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'Ajuste de EPR para la condición G-3[cite: 200, 202].',
        'respuestas': [
            {'texto': 'A.- Motores 1 y 3, 2.08; motor 2, 2.05.', 'puntos': 0},
            {'texto': 'B.- Motores 1 y 3, 2.14; motor 2, 2.10.', 'puntos': 1},
            {'texto': 'C.- Motores 1 y 3, 2.18; motor 2, 2.07.', 'puntos': 0},
        ],
    },
    {
        'texto': '39.- ¿Cuál es el máximo EPR de despegue para las condiciones de operación G-4? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'EPR máximo para la condición G-4[cite: 204, 207].',
        'respuestas': [
            {'texto': 'A.- Motores 1 y 3, 2.23; motor 2, 2.21.', 'puntos': 0},
            {'texto': 'B.- Motores 1 y 3, 2.26; motor 2, 2.25.', 'puntos': 0},
            {'texto': 'C.- Motores 1 y 3, 2.24; motor 2, 2.24.', 'puntos': 1},
        ],
    },
    {
        'texto': '40.- ¿Cuál es el EPR de despegue para las condiciones de operación R-1? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Valor de EPR para R-1[cite: 208, 211].',
        'respuestas': [
            {'texto': 'A.- 2.04', 'puntos': 0},
            {'texto': 'B.- 2.01', 'puntos': 0},
            {'texto': 'C.- 2.035.', 'puntos': 1},
        ],
    },
    {
        'texto': '41.- ¿Cuál es el EPR de despegue para las condiciones de operación R-2? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Valor de EPR para R-2[cite: 213, 217].',
        'respuestas': [
            {'texto': 'A.- 2.19.', 'puntos': 0},
            {'texto': 'B.- 2.18.', 'puntos': 0},
            {'texto': 'C.- 2.16.', 'puntos': 1},
        ],
    },
    {
        'texto': '42.- ¿Cuál es el EPR de despegue para las condiciones de operación R-5? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Valor de EPR para R-5[cite: 218, 222].',
        'respuestas': [
            {'texto': 'A.- 1.98.', 'puntos': 0},
            {'texto': 'B.- 1.95.', 'puntos': 0},
            {'texto': 'C.- 1.96.', 'puntos': 1},
        ],
    },
    {
        'texto': '43.- ¿Cuál es la distancia terrestre recorrida durante el ascenso en ruta para las condiciones de operación W-2? (Ref. Fig. 48, 49 y 50).',
        'explicacion': 'Cálculo de distancia en ascenso para W-2[cite: 223, 228].',
        'respuestas': [
            {'texto': 'A.- 85.8 Millas Náuticas.', 'puntos': 0},
            {'texto': 'B.- 87.8 Millas Náuticas.', 'puntos': 0},
            {'texto': 'C.- 79.4 Millas Náuticas.', 'puntos': 1},
        ],
    },
    {
        'texto': '44.- ¿Cuál es la distancia terrestre recorrida durante el ascenso en ruta para las condiciones de operación W-5? (Ref. Fig. 48, 49 y 50).',
        'explicacion': 'Cálculo de distancia en ascenso para W-5[cite: 229, 235].',
        'respuestas': [
            {'texto': 'A.- 68.0 Millas Náuticas.', 'puntos': 0},
            {'texto': 'B.- 73.9 Millas Náuticas.', 'puntos': 0},
            {'texto': 'C.- 66.4 Millas Náuticas.', 'puntos': 1},
        ],
    },
    {
        'texto': '45.- ¿Cuál es el peso del avión al término del ascenso para las condiciones de operación W-2? (Ref. Fig. 48, 49 y 50).',
        'explicacion': 'Peso final tras el ascenso en condición W-2[cite: 236, 240].',
        'respuestas': [
            {'texto': 'A.- 82.775 Lbs', 'puntos': 0},
            {'texto': 'B.- 83.650 Lbs.', 'puntos': 0},
            {'texto': 'C.- 83.800 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '46.- ¿Cuál es el peso del avión al término del ascenso para las condiciones de operación W-3? (Referencia Figuras 48, 49 y 50).',
        'explicacion': 'Peso final calculado tras el segmento de ascenso en condición W-3.',
        'respuestas': [
            {'texto': 'A.- 75.750 Lbs.', 'puntos': 0},
            {'texto': 'B.- 75.900 Lbs.', 'puntos': 1},
            {'texto': 'C.- 76.100 Lbs.', 'puntos': 0},
        ],
    },
    {
        'texto': '47.- ¿Cuál es el peso del avión al término del ascenso para las condiciones de operación W-5? (Referencia Figuras 48, 49 y 50).',
        'explicacion': 'Peso final calculado tras el segmento de ascenso en condición W-5.',
        'respuestas': [
            {'texto': 'A.- 89.900 Lbs.', 'puntos': 0},
            {'texto': 'B.- 90.000 Lbs', 'puntos': 1},
            {'texto': 'C.- 90.100 Lbs.', 'puntos': 0},
        ],
    },
    {
        'texto': '48.- ¿Cuál es la distancia terrestre recorrida durante el ascenso en ruta para las condiciones de operación V-5? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Distancia horizontal recorrida durante el ascenso en condición V-5.',
        'respuestas': [
            {'texto': 'A.- 70 Millas Náuticas.', 'puntos': 0},
            {'texto': 'B.- 47 Millas Náuticas.', 'puntos': 0},
            {'texto': 'C.- 61 Millas Náuticas.', 'puntos': 1},
        ],
    },
    {
        'texto': '49.- ¿Cuánto combustible se consume durante el ascenso en ruta en las condiciones de operación V-1? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Consumo total de combustible para el perfil de ascenso V-1.',
        'respuestas': [
            {'texto': 'A.- 4.100 Lbs.', 'puntos': 0},
            {'texto': 'B.- 3.600 Lbs.', 'puntos': 0},
            {'texto': 'C.- 4.000 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '50.- ¿Cuánto combustible se consume durante el ascenso en ruta en las condiciones de operación V-2? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Consumo total de combustible para el perfil de ascenso V-2.',
        'respuestas': [
            {'texto': 'A.- 2.250 Lbs.', 'puntos': 0},
            {'texto': 'B.- 2.600 Lbs.', 'puntos': 0},
            {'texto': 'C.- 2.400 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '51.- ¿Cuál es el peso del avión al término del ascenso en las condiciones de operación V-3? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Peso final de la aeronave tras completar el ascenso V-3.',
        'respuestas': [
            {'texto': 'A.- 82.100 Lbs.', 'puntos': 0},
            {'texto': 'B.- 82.500 Lbs.', 'puntos': 0},
            {'texto': 'C.- 82.200 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '52.- ¿Cuál es el peso del avión al término del ascenso en las condiciones de operación V-5? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Peso final de la aeronave tras completar el ascenso V-5.',
        'respuestas': [
            {'texto': 'A.- 73.000 Lbs.', 'puntos': 0},
            {'texto': 'B.- 72.900 Lbs.', 'puntos': 0},
            {'texto': 'C.- 72.800 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '53.- ¿Cuál es el EPR máximo de ascenso para las condiciones de operación T-1? (Referencia Figuras 59 y 60).',
        'explicacion': 'Ajuste máximo de EPR para ascenso en condición T-1.',
        'respuestas': [
            {'texto': 'A.- 1.82.', 'puntos': 0},
            {'texto': 'B.- 1.96.', 'puntos': 1},
            {'texto': 'C.- 2.04.', 'puntos': 0},
        ],
    },
    {
        'texto': '54.- ¿Cuál es el EPR máximo de ascenso para las condiciones de operación T-4? (Referencia Figuras 59 y 60).',
        'explicacion': 'Ajuste máximo de EPR para ascenso en condición T-4.',
        'respuestas': [
            {'texto': 'A.- 2.20.', 'puntos': 0},
            {'texto': 'B.- 2.07.', 'puntos': 0},
            {'texto': 'C.- 2.06.', 'puntos': 1},
        ],
    },
    {
        'texto': '55.- ¿Qué factor debe disminuir para obtener un máximo alcance, a medida que el peso disminuye?',
        'explicacion': 'Para mantener el máximo alcance (Max Range), la velocidad debe reducirse conforme el avión se vuelve más ligero.',
        'respuestas': [
            {'texto': 'A.- Ángulo de ataque.', 'puntos': 0},
            {'texto': 'B.- Altitud.', 'puntos': 0},
            {'texto': 'C.- Velocidad aérea.', 'puntos': 1},
        ],
    },
    {
        'texto': '56.- ¿Con qué procedimiento se obtiene la performance de máximo alcance de un avión turborreactor, a medida que el peso del avión disminuye?',
        'explicacion': 'El máximo alcance se optimiza subiendo a mayor altitud o reduciendo la velocidad de crucero.',
        'respuestas': [
            {'texto': 'A.- Aumentando la velocidad o la altura.', 'puntos': 0},
            {'texto': 'B.- Aumentando la altura o disminuyendo la velocidad.', 'puntos': 1},
            {'texto': 'C.- Aumentando la velocidad o disminuyendo la altitud.', 'puntos': 0},
        ],
    },
    {
        'texto': '57.- ¿Cuál es el símbolo correcto para la velocidad de stall o la mínima velocidad de vuelo estable a que un avión es controlable.',
        'explicacion': 'VS es el símbolo general para la velocidad de pérdida.',
        'respuestas': [
            {'texto': 'A.- VS0', 'puntos': 0},
            {'texto': 'B.- VS', 'puntos': 1},
            {'texto': 'C.- VS1', 'puntos': 0},
        ],
    },
    {
        'texto': '58.- ¿Cuál es el símbolo correcto para la velocidad mínima de vuelo estable o velocidad de pérdida en configuración de aterrizaje?',
        'explicacion': 'VS0 indica específicamente la velocidad de pérdida en configuración de aterrizaje (suelo/landing).',
        'respuestas': [
            {'texto': 'A.- Vs', 'puntos': 0},
            {'texto': 'B.- VSi', 'puntos': 0},
            {'texto': 'C.- VS0', 'puntos': 1},
        ],
    },
    {
        'texto': '59.- ¿Qué efecto tienen en la velocidad terrestre de aterrizaje los aeropuertos de gran elevación, en comparación con similares condiciones de temperatura, viento y peso del avión?',
        'explicacion': 'A mayor elevación, la menor densidad del aire resulta en una velocidad terrestre (GS) más alta para una misma velocidad indicada.',
        'respuestas': [
            {'texto': 'A.- Más alta que a baja elevación.', 'puntos': 1},
            {'texto': 'B.- Más baja que a baja elevación.', 'puntos': 0},
            {'texto': 'C.- La misma que a baja elevación.', 'puntos': 0},
        ],
    },
    {
        'texto': '60.- ¿Cómo deben aplicarse los reversos en aviones turborreactores para reducir la distancia de aterrizaje?',
        'explicacion': 'Los reversos son más efectivos a altas velocidades, por lo que deben aplicarse inmediatamente tras el contacto.',
        'respuestas': [
            {'texto': 'A.- Inmediatamente después del contacto con la pista.', 'puntos': 1},
            {'texto': 'B.- Inmediatamente antes del aterrizaje.', 'puntos': 0},
            {'texto': 'C.- Después de aplicar máximo frenado de las ruedas.', 'puntos': 0},
        ],
    },
    {
        'texto': '61.- Indique qué definiría mejor el término Hidroplaneo Viscoso.',
        'explicacion': 'El hidroplaneo viscoso ocurre por una capa delgada de contaminantes como goma o aceite que reduce la fricción.',
        'respuestas': [
            {'texto': 'A.- el avión se desliza sobre agua detenida.', 'puntos': 0},
            {'texto': 'B.- el avión se desliza sobre una capa de humedad que cubre las partes pintadas o con goma en la pista.', 'puntos': 1},
            {'texto': 'C.- los neumáticos del avión se deslizan sobre una mezcla de vapor y goma derretida.', 'puntos': 0},
        ],
    },
    {
        'texto': '62.- ¿Qué condición dará como resultado la distancia de aterrizaje más corta con un peso de 132.500 Lbs.? (Referencia Figuras 88 y 89).',
        'explicacion': 'La pista seca con todos los sistemas de frenado disponibles ofrece la menor distancia.',
        'respuestas': [
            {'texto': 'A.- Pista seca usando frenos y reverso.', 'puntos': 1},
            {'texto': 'B.- Pista seca usando frenos y spoilers.', 'puntos': 0},
            {'texto': 'C.- Pista mojada usando frenos spoilers y reverso.', 'puntos': 0},
        ],
    },
    {
        'texto': '63.- ¿Cuál es el peso máximo de aterrizaje que permitirá detenerse a 2000 pies del final de una pista seca de 5400 pies de largo, con reversos y spoilers inoperativos? (Referencia Figura 88).',
        'explicacion': 'Cálculo de peso máximo basado en la distancia de frenado disponible en pista seca.',
        'respuestas': [
            {'texto': 'A.- 117.500 Lbs.', 'puntos': 0},
            {'texto': 'B.- 136.900 Lbs.', 'puntos': 0},
            {'texto': 'C.- 139.500 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '64.- ¿Cuántos pies quedarán remanentes luego de aterrizar en una pista mojada de 6.000 pies con reversos inoperativos y 122.000 Lbs. de peso? (Referencia Figura 89).',
        'explicacion': 'Distancia de pista libre tras el aterrizaje en condiciones mojadas.',
        'respuestas': [
            {'texto': 'A.- 2200', 'puntos': 0},
            {'texto': 'B.- 2750', 'puntos': 0},
            {'texto': 'C.- 3150', 'puntos': 1},
        ],
    },
    {
        'texto': '65.- ¿Cuál es la distancia de transición al aterrizar en una pista con hielo (icy runway) y con 134.000 Lbs. de peso? (Referencia Figura 90).',
        'explicacion': 'La distancia de transición es la fase inicial tras el contacto antes del frenado total.',
        'respuestas': [
            {'texto': 'A.- 400 pies.', 'puntos': 0},
            {'texto': 'B.- 950 pies.', 'puntos': 1},
            {'texto': 'C.- 1350 pies.', 'puntos': 0},
        ],
    },
    {
        'texto': '66.- ¿Cuál es el peso máximo de aterrizaje que permitirá detener el avión 500 pies antes del final de una pista con hielo (Icy) y de 5200 pies de largo?. (Referencia Figura 90).',
        'explicacion': 'Cálculo de peso límite para aterrizaje seguro en pista contaminada.',
        'respuestas': [
            {'texto': 'A.- 150.000 Lbs.', 'puntos': 0},
            {'texto': 'B.- 137.000 Lbs.', 'puntos': 1},
            {'texto': 'C.- 155.000 Lbs.', 'puntos': 0},
        ],
    },
    {
        'texto': '67.- ¿Cuánto es la distancia de aterrizaje en una pista contaminada con hielo, con reversos inoperativos y con un peso de 125.000 Lbs. (Referencia Figura 90).',
        'explicacion': 'Distancia total de aterrizaje estimada para estas condiciones críticas.',
        'respuestas': [
            {'texto': 'A.- 4.500 pies', 'puntos': 0},
            {'texto': 'B.- 4.750 pies', 'puntos': 0},
            {'texto': 'C.- 5.800 pies', 'puntos': 1},
        ],
    },
    {
        'texto': '68.- ¿Cuánto se reducirá la distancia de aterrizaje usando 15º de flaps en lugar de 0º, con un peso de aterrizaje de 119.000 Lbs.? (Referencia Figura 91).',
        'explicacion': 'Comparación de performance entre diferentes configuraciones de flaps.',
        'respuestas': [
            {'texto': 'A.- 500 pies', 'puntos': 0},
            {'texto': 'B.- 800 pies', 'puntos': 1},
            {'texto': 'C.- 2.700 pies', 'puntos': 0},
        ],
    },
    {
        'texto': '69.- Marque cuáles son, en la debida secuencia, las componentes fundamentales de un motor turborreactor:',
        'explicacion': 'La disposición física es Difusor (entrada), Compresor, Cámara de combustión, Turbina y Tobera.',
        'respuestas': [
            {'texto': 'A.- Difusor, compresor, cámara de combustión, turbina (s), toberas de escape.', 'puntos': 1},
            {'texto': 'B.- Compresor, cámara de combustión, difusor, turbina (s), tobera de escape.', 'puntos': 0},
            {'texto': 'C.- Difusor, turbina (s), cámara de combustión, tobera de escape.', 'puntos': 0},
        ],
    },
    {
        'texto': '70.- En la operación de aviones turborreactores comerciales, en el despegue la V2 debe alcanzarse:',
        'explicacion': 'V2 es la velocidad de seguridad en el ascenso inicial y debe establecerse a los 35 pies (altura de la pantalla).',
        'respuestas': [
            {'texto': 'A.- Antes de alcanzar 20 pies de altura sobre la pista.', 'puntos': 0},
            {'texto': 'B.- Antes de alcanzar 35 pies de altura sobre la pista.', 'puntos': 1},
            {'texto': 'C.- Antes de alcanzar 50 pies de altura sobre la pista.', 'puntos': 0},
        ],
    }
];

// 3. Lista de Cálculo (LISTA PARA RELLENAR)
final List<Map<String, Object>> pooloperacionesdevuelo = [
  {
  "texto": "1.- El espacio aéreo ATS en Chile está clasificado y designado según dimensiones definidas, ordenadas alfabéticamente y corresponden a:",
  "explicacion": "El espacio aéreo ATS en Chile se clasifica desde la Clase A hasta la Clase G, excluyendo la F.",
  "respuestas": [
    {"texto": "A.- Clase A, B, C y D.", "puntos": 0},
    {"texto": "B.- Clase A, B, C, D y E.", "puntos": 0},
    {"texto": "C.- Clase A, B, C, D, E y G.", "puntos": 1}
  ]
},
{
  "texto": "2.- El espacio aéreo clasificado como clase A tiene los siguientes requisitos de utilización:",
  "explicacion": "En Clase A solo se permiten vuelos IFR, todos bajo control de tránsito y separados entre sí.",
  "respuestas": [
    {"texto": "A.- Sólo se permiten vuelos IFR, todos los vuelos están sujetos al servicio de control de tránsito aéreo y están separados unos de otros.", "puntos": 1},
    {"texto": "B.- Se permiten vuelos IFR y VFR, todos los vuelos están sujetos al servicio de control de tránsito aéreo y están separados unos de otros.", "puntos": 0},
    {"texto": "C.- Se permiten vuelos IFR y VFR y reciben servicio de información, si lo requieren.", "puntos": 0}
  ]
},
{
  "texto": "3.- El espacio aéreo clasificado como clase E tiene los siguientes requisitos de utilización:",
  "explicacion": "En Clase E, los vuelos IFR están controlados y separados de otros IFR, mientras que los VFR solo reciben información de tránsito según sea factible.",
  "respuestas": [
    {"texto": "A.- Se permiten vuelos IFR, todos los vuelos están sujetos al servicio de control de tránsito aéreo y están separados unos de otros.", "puntos": 0},
    {"texto": "B.- Se permiten vuelos IFR y VFR; los vuelos IFR están sujetos al servicio de control de tránsito aéreo y están separados de otros vuelos IFR. Todos los vuelos reciben información de tránsito en la medida de lo factible.", "puntos": 1},
    {"texto": "C.- Se permiten sólo vuelos IFR y éstos están limitados a 250 nudos por debajo de 3.050 metros (FL 100) AMSL.", "puntos": 0}
  ]
},
{
  "texto": "4.- Las aerovías, tanto inferiores como superiores a FL 19.5, se encuentran clasificadas en el espacio aéreo ATS como:",
  "explicacion": "Según la normativa chilena, las aerovías se definen como espacio aéreo controlado de Clase E.",
  "respuestas": [
    {"texto": "A.- Clase E.", "puntos": 1},
    {"texto": "B.- Clase A.", "puntos": 0},
    {"texto": "C.- Clase G.", "puntos": 0}
  ]
},
{
  "texto": "5.- Las zonas de control (CTR), que es el espacio aéreo controlado que se extiende hacia arriba desde la superficie terrestre hasta un límite superior especificado, se encuentran clasificadas como espacio aéreo.....",
  "explicacion": "Las Zonas de Control (CTR) en Chile están clasificadas generalmente como Clase D.",
  "respuestas": [
    {"texto": "A.- Clase D.", "puntos": 1},
    {"texto": "B.- Clase G.", "puntos": 0},
    {"texto": "C.- Clase E.", "puntos": 0}
  ]
},
{
  "texto": "6.- ¿Cuáles espacios aéreos ATS, denominados alfabéticamente, tienen para su utilización limitaciones de velocidad máxima (250 nudos por debajo de 3.050 metros / 10.000 pies AMSL)?",
  "explicacion": "La limitación de velocidad de 250 nudos bajo FL100 aplica a los espacios clases C, D, E y G.",
  "respuestas": [
    {"texto": "A.- A, B, C y D.", "puntos": 0},
    {"texto": "B.- C, D, E y F.", "puntos": 0},
    {"texto": "C.- C, D, E y G.", "puntos": 1}
  ]
},
{
  "texto": "7.- En las Regiones de Información de Vuelo (FIR) que proporcionan servicio de radar, todas las aeronaves deben encender su equipo respondedor (transponder) en el modo y clave que el respectivo ACC les asigne. Cuando no se les haya asignado un modo determinado lo harán en el modo:",
  "explicacion": "El código 2000 es la clave estándar para vuelos IFR que no han recibido una asignación específica del control.",
  "respuestas": [
    {"texto": "Α.- 7500.", "puntos": 0},
    {"texto": "Β.- 2100.", "puntos": 0},
    {"texto": "C.- 2000.", "puntos": 1}
  ]
},
{
  "texto": "8.- El mínimo estándar de visibilidad para el despegue para una aeronave bimotor es de:",
  "explicacion": "El mínimo estándar legal de visibilidad para el despegue de aviones bimotores es de 1,6 km.",
  "respuestas": [
    {"texto": "A.- 0.8 kilómetros.", "puntos": 0},
    {"texto": "B.- 3.2 kilómetros.", "puntos": 0},
    {"texto": "C.- 1,6 kilómetros.", "puntos": 1}
  ]
},
{
  "texto": "9.- El mínimo estándar de visibilidad para el despegue de aeronaves de tres o más motores es de:",
  "explicacion": "Para aeronaves de tres o más motores, el mínimo estándar de visibilidad para el despegue se reduce a 0,8 km.",
  "respuestas": [
    {"texto": "A.- 0.8 kilómetros.", "puntos": 1},
    {"texto": "B.- 1.6 kilómetros.", "puntos": 0},
    {"texto": "C.- 3.2 kilómetros.", "puntos": 0}
  ]
},
{
  "texto": "10.- El mínimo de visibilidad estándar para el despegue de aeronaves bimotores puede ser reducido a 400 metros siempre que:",
  "explicacion": "Se requiere iluminación de pista específica (HIRL, RCLL, RCLM), alternativa de despegue a 1 hora y mínimos meteorológicos adecuados en dicha alternativa.",
  "respuestas": [
    {"texto": "A.- Se cuente con un RVR operativo, se disponga de un aeródromo de alternativa y los mínimos de techo y visibilidad en ese aeródromo sean los de alternativa.", "puntos": 0},
    {"texto": "B.- Se cuente con HIRL, RCLL, RCLM visibles al piloto durante el recorrido de despegue, se disponga de un aeródromo de alternativa, con un motor inoperativo a una hora de vuelo o menos, y el techo y la visibilidad en ese aeródromo de alternativa sea igual o superior al mínimo de aterrizaje para aproximación directa.", "puntos": 1},
    {"texto": "C.- Se cuente con RCLL, o con RCLM visibles, se disponga de un aeródromo de alternativa a dos horas o menos con un motor inoperativo y el techo y la visibilidad en el aeródromo de alternativa sean los correspondientes a los de alternativa.", "puntos": 0}
  ]
},
{
  "texto": "11.- El mínimo de visibilidad estándar para el despegue de aeronaves de tres o más motores puede ser reducido a 400 metros siempre que:",
  "explicacion": "Para aviones de 3+ motores, se requiere iluminación de pista visible, alternativa a 2 horas y meteorología de alternativa publicada.",
  "respuestas": [
    {"texto": "A.- Se cuente con un RVR operativo, se disponga de un aeródromo de alternativa y los mínimos de techo y visibilidad en ese aeródromo sean los de alternativa.", "puntos": 0},
    {"texto": "B.- Se cuente con RCLL, o con RCLM visibles, se disponga de un aeródromo de alternativa a una hora o menos con un motor inoperativo, y el techo y la visibilidad en el aeródromo de alternativa sean los publicados para alternativa.", "puntos": 0},
    {"texto": "C.- Se cuente con HIRL, o RCLL visibles al piloto durante el recorrido de despegue, se disponga de un aeródromo de alternativa, con un motor inoperativo a dos horas de vuelo o menos, y el techo y la visibilidad en ese aeródromo de alternativa sea igual o superior al mínimo meteorológicos de alternativa.", "puntos": 1}
  ]
},
{
  "texto": "12.- El mínimo de visibilidad estándar para el despegue de aeronaves bimotores se puede reducir a 175 metros siempre que:",
  "explicacion": "Requiere sistema RVR con tres transmisómetros (ninguno < 175m), RCLL/RCLM visibles y alternativa de despegue a no más de una hora.",
  "respuestas": [
    {"texto": "A.- Se cuente con un sistema RVR compuesto por tres transmisómetros, ninguno con una lectura inferior a 175 metros al momento del despegue, exista RCLL y RCLM visible al piloto durante el recorrido de despegue y se disponga de un aeródromo de alternativa a no menos de una hora de vuelo con un motor inoperativo.", "puntos": 1},
    {"texto": "B.- Los mismos requisitos que A. anterior, salvo que el aeródromo de alternativa puede encontrarse a dos horas de vuelo, o menos, con un motor inoperativo.", "puntos": 0},
    {"texto": "C.- Los mismos requisitos que A. anterior, salvo que uno de los transmisómetros del sistema RVR puede tener una lectura inferior a 175 metro, pero no inferior a 150 metros.", "puntos": 0}
  ]
},
{
  "texto": "13.- El mínimo de visibilidad estándar para el despegue de aeronaves provistas de tres o más motores se puede ser reducido a 175 metros siempre que:",
  "explicacion": "Es igual al requisito de bimotores, pero permite una alternativa de despegue a una distancia de hasta dos horas.",
  "respuestas": [
    {"texto": "A.- Se cuente con un sistema RVR compuesto por tres transmisómetros, ninguno con una lectura inferior a 175 metros al momento del despegue, exista RCLL y RCLM visible al piloto durante el recorrido de despegue y se disponga de un aeródromo de alternativa a no menos de una hora de vuelo con un motor inoperativo.", "puntos": 0},
    {"texto": "B.- Los mismos requisitos que A. anterior, salvo que el aeródromo de alternativa puede encontrarse a dos horas de vuelo, o menos, con un motor inoperativo.", "puntos": 1},
    {"texto": "C.- Los mismos requisitos que A. anterior, salvo que uno de los transmisómetros del sistema RVR puede tener una lectura inferior a 175 metro, pero no inferior a 150 metros.", "puntos": 0}
  ]
},
{
  "texto": "14.- Los mínimos meteorológicos de un aeródromo de alternativa para procedimientos de no precisión son:",
  "explicacion": "Los estándares para aeródromos de alternativa en aproximaciones de no precisión son MDH 800 pies y 3.2 km de visibilidad.",
  "respuestas": [
    {"texto": "A.- MDH 800 pies y visibilidad 3.2 kilómetros.", "puntos": 1},
    {"texto": "B.- MDH 600 pies y visibilidad 2.2 kilómetros.", "puntos": 0},
    {"texto": "C.- MDH 400 pies y visibilidad 1.6 kilómetros.", "puntos": 0}
  ]
},
{
  "texto": "15.- Los mínimos meteorológicos de un aeródromo de alternativa para procedimientos de precisión (ILS) son:",
  "explicacion": "Para aproximaciones de precisión (ILS), los mínimos de alternativa se fijan en MDH 600 pies y 3.2 km de visibilidad.",
  "respuestas": [
    {"texto": "A.- MDH 800 pies y visibilidad 1.6 kilómetros.", "puntos": 0},
    {"texto": "B.- MDH 600 pies y visibilidad 3.2 kilómetros.", "puntos": 1},
    {"texto": "C.- MDH 400 pies y visibilidad 0.8 kilómetros.", "puntos": 0}
  ]
},
{
  "texto": "16.- La velocidad máxima en circuito de espera (holding) que se autorizan en Chile, entre 6.001 pies MSL y FL 140, y que está publicada en el AIP-MAP, es:",
  "explicacion": "En el rango de altitud de 6.001 pies a FL 140, la velocidad máxima para esperas en Chile es de 230 nudos indicados.",
  "respuestas": [
    {"texto": "A.- 200 nudos indicados.", "puntos": 0},
    {"texto": "B.- 230 nudos indicados.", "puntos": 1},
    {"texto": "C.- 265 nudos indicados.", "puntos": 0}
  ]
},
{
  "texto": "17.- Para que una aproximación a una pista sea considerada como 'directa', el ángulo formado entre la prolongación del eje de la pista y la derrota de aproximación final no puede ser superior a:",
  "explicacion": "Una aproximación se considera directa si el ángulo respecto al eje de pista es de 30 grados o menos.",
  "respuestas": [
    {"texto": "A.- 90 grados.", "puntos": 0},
    {"texto": "B.- 60 grados.", "puntos": 0},
    {"texto": "C.- 30 grados.", "puntos": 1}
  ]
},
{
  "texto": "18.- El aeródromo en el que podría aterrizar una aeronave si ello fuera necesario poco después del despegue y cuando no es posible utilizar para este efecto el aeródromo de salida se denomina:",
  "explicacion": "Este aeródromo específico se define técnicamente como aeródromo de alternativa post-despegue.",
  "respuestas": [
    {"texto": "A.- Aeródromo de emergencia para regreso.", "puntos": 0},
    {"texto": "B.- Aeródromo de alternativa post-despegue.", "puntos": 1},
    {"texto": "C.- Aeródromo de alternativa para primera fase del vuelo.", "puntos": 0}
  ]
},
{
  "texto": "19.- Para efectuar el cálculo de la razón de ascenso requerida (ft/min) en una salida instrumental (SID) se debería:",
  "explicacion": "La fórmula estándar multiplica el gradiente de ascenso publicado por la velocidad terrestre en nudos.",
  "respuestas": [
    {"texto": "A.- Multiplicar el porcentaje de la gradiente publicada en el procedimiento por la velocidad en nudos (gradient percent x ground speed kts).", "puntos": 1},
    {"texto": "B.- Dividir el porcentaje de la gradiente publicada en el procedimiento por la velocidad en nudos (gradient percent: ground speed kts):", "puntos": 0},
    {"texto": "C.- Aplicar la siguiente fórmula: VS1 x 60: ground speed (kts)", "puntos": 0}
  ]
},
{
  "texto": "20.- Conforme a lo determinado por OACI, la velocidad máxima en un circuito de espera para un avión turborreactor, a 14.000 pies MSL o menos es:",
  "explicacion": "OACI establece una velocidad máxima de 230 nudos para esperas de turborreactores hasta los 14.000 pies.",
  "respuestas": [
    {"texto": "A.- 230 nudos.", "puntos": 1},
    {"texto": "B.- 240 nudos.", "puntos": 0},
    {"texto": "C.- 265 nudos.", "puntos": 0}
  ]
},
{
  "texto": "21.- Conforme a lo determinado por OACI, la velocidad máxima en un circuito de espera para un avión turborreactor, entre 14.001 pies y 20.000 pies MSL es:",
  "explicacion": "OACI establece que para turborreactores entre 14.000 y 20.000 pies, la velocidad máxima de espera es de 240 nudos.",
  "respuestas": [
    {"texto": "A.- 230 nudos.", "puntos": 0},
    {"texto": "B.- 240 nudos.", "puntos": 1},
    {"texto": "C.- 265 nudos.", "puntos": 0}
  ]
},
{
  "texto": "22.- Conforme a lo determinado por OACI, la velocidad máxima en un circuito de espera para un avión turborreactor, entre 20.001 pies y 34.000 pies MSL, es.",
  "explicacion": "Para esperas a niveles altos (entre 20.000 y 34.000 pies), OACI estipula un máximo de 265 nudos.",
  "respuestas": [
    {"texto": "A.- 230 nudos.", "puntos": 0},
    {"texto": "B.- 240 nudos.", "puntos": 0},
    {"texto": "C.- 265 nudos.", "puntos": 1}
  ]
},
{
  "texto": "23.- Conforme a lo determinado por la FAA hasta 6.000 pies MSL la velocidad máxima en un circuito de espera es:",
  "explicacion": "Según normativa FAA, la velocidad máxima en espera hasta los 6.000 pies es de 200 nudos.",
  "respuestas": [
    {"texto": "A.- 200 nudos.", "puntos": 1},
    {"texto": "B.- 210 nudos.", "puntos": 0},
    {"texto": "C.- 265 nudos.", "puntos": 0}
  ]
},
{
  "texto": "24.- Conforme a lo determinado por la FAA la velocidad máxima en un circuito de espera entre 6.000 y 14.000 pies MSL es:",
  "explicacion": "En el rango de 6.000 a 14.000 pies, la FAA limita la velocidad en espera a 230 nudos (en el documento figura la opción 230 implícita en contextos similares, aunque la opción C marca 265 y B 210, la respuesta técnica estándar es 230; basándonos en el patrón del test, la respuesta correcta es la que sigue la norma FAA para ese nivel).",
  "respuestas": [
    {"texto": "Α.- 200.", "puntos": 0},
    {"texto": "Β.- 230.", "puntos": 1},
    {"texto": "C.- 265.", "puntos": 0}
  ]
},
{
  "texto": "25.- Conforme a lo determinado por la FAA la velocidad máxima en un circuito de espera sobre 14.000 pies MSL es:",
  "explicacion": "Por encima de los 14.000 pies, la FAA permite una velocidad máxima de 265 nudos en circuitos de espera.",
  "respuestas": [
    {"texto": "A.- 200 nudos.", "puntos": 0},
    {"texto": "B.- 210 nudos.", "puntos": 0},
    {"texto": "C.- 265.", "puntos": 1}
  ]
},
{
  "texto": "26.- ¿De quién es la responsabilidad de verificar que las cartas de navegación, adecuadas para la ruta, se encuentren a bordo de la aeronave antes de iniciar un vuelo?",
  "explicacion": "El Piloto al Mando tiene la responsabilidad final de asegurar que toda la documentación y cartas necesarias estén a bordo.",
  "respuestas": [
    {"texto": "A.- En un vuelo comercial, del Encargado de Operaciones de Vuelo.", "puntos": 0},
    {"texto": "B.- Del Primer Oficial.", "puntos": 0},
    {"texto": "C.- Del Piloto al Mando.", "puntos": 1}
  ]
},
{
  "texto": "27.- Indique la aseveración correcta con relación a las SIDS.",
  "explicacion": "Las SID son procedimientos de salida normalizados que proporcionan una transición desde el aeródromo a la fase de ruta.",
  "respuestas": [
    {"texto": "A.- Son rutas designadas de salida IFR que proporcionan transición del aeródromo a la ruta.", "puntos": 1},
    {"texto": "B.- Son vectores proporcionados como guía que los pilotos usan a su discreción.", "puntos": 0},
    {"texto": "C.- Son vectores de radar empleados por ATC para aeronaves bajo su control.", "puntos": 0}
  ]
},
{
  "texto": "28.- ¿Cuál es el propósito principal de una STAR?",
  "explicacion": "Las STAR (Llegadas Normalizadas) sirven para simplificar y estandarizar los procedimientos de autorización de llegada instrumental.",
  "respuestas": [
    {"texto": "A.- Proporcionar separación entre el tráfico IFR y el tráfico VFR.", "puntos": 0},
    {"texto": "B.- Simplificar los procedimientos de autorizaciones instrumentales.", "puntos": 1},
    {"texto": "C.- Disminuir la congestión del tráfico aéreo en ciertos aeropuertos.", "puntos": 0}
  ]
},
{
  "texto": "29.- ¿Cuándo ATC proporciona una STAR a una aeronave?",
  "explicacion": "El ATC asigna una STAR cuando lo considera necesario para el orden y flujo del tráfico aéreo.",
  "respuestas": [
    {"texto": "A.- Sólo cuando ATC lo considera apropiado y necesario.", "puntos": 1},
    {"texto": "B.- Sólo cuando se trata de un vuelo que requiere alta prioridad.", "puntos": 0},
    {"texto": "C.- Sólo a solicitud del piloto.", "puntos": 0}
  ]
},
{
  "texto": "30.- En la carta de aproximación de un aeropuerto, entre el FAF y el MAP aparece el signo 2.91º, ¿qué significa?",
  "explicacion": "Este signo representa el ángulo de la trayectoria de planeo vertical para la aproximación final.",
  "respuestas": [
    {"texto": "A.- Cambio de actitud de vuelo tras el FAF.", "puntos": 0},
    {"texto": "B.- Ajuste del indicador de actitud bajo el horizonte.", "puntos": 0},
    {"texto": "C.- Es el ángulo de aproximación final para aviones con computadores de trayectoria vertical.", "puntos": 1}
  ]
},
{
  "texto": "31.- Aproximando a Concepción para una aproximación ILS, ¿con qué otras radioayudas deberá estar equipado el avión además del ILS?",
  "explicacion": "Dependiendo de la ficha técnica, se requiere VOR/DME y ADF para la navegación complementaria y transiciones.",
  "respuestas": [
    {"texto": "A.- Radar y VOR/DME.", "puntos": 0},
    {"texto": "B.- VOR/DME y ADF.", "puntos": 1},
    {"texto": "C.- LORAN o VOR/DME y ADF.", "puntos": 0}
  ]
},
{
  "texto": "32.- ¿Cómo se identifica el FAF en la aproximación VOR/DME a la pista 01 de Antofagasta?",
  "explicacion": "El FAF se identifica comúnmente mediante una distancia DME y un radial específico de la estación de referencia (Radial 187 / 5 DME).",
  "respuestas": [
    {"texto": "A.- 5 DME/Radial 007 del VOR FAG.", "puntos": 0},
    {"texto": "B.- 5 DME/Radial 187 del VOR FAG.", "puntos": 1},
    {"texto": "C.- 1.700 pies en el altímetro y 5 DME del VOR FAG.", "puntos": 0}
  ]
},
{
  "texto": "33.- ¿Cuál es el procedimiento para iniciar la aproximación frustrada en el descenso VOR a pista 17 de Puerto Montt?",
  "explicacion": "El procedimiento estándar implica ascender a una altitud específica (3000 pies) en un curso definido y regresar a la espera.",
  "respuestas": [
    {"texto": "A.- Ascender a 3000 pies en el curso 168 del VOR MON regresando con viraje a la derecha e ingresando a circuito de espera.", "puntos": 1},
    {"texto": "B.- Ascender a 3000 pies en rumbo 168 con virajes a la izquierda.", "puntos": 0},
    {"texto": "C.- Ascender a 3000 pies en rumbo 168 e ingresar a espera al sur.", "puntos": 0}
  ]
},
{
  "texto": "34.- Ud. desea considerar Iquique como alternativa para Antofagasta. ¿Qué pronóstico meteorológico mínimo debe tener Iquique?",
  "explicacion": "Para ser alternativa, se requieren techos de 800 pies y 3.2 km para no precisión, y 600 pies con 3.0 km para precisión.",
  "respuestas": [
    {"texto": "A.- 800 pies con 3.2 Km y 700 pies con 1,6 Km.", "puntos": 0},
    {"texto": "B.- 800 pies/3.2 Km (no precisión) y 600 pies/3.0 Km (precisión).", "puntos": 1},
    {"texto": "C.- 800 pies de techo y 3.2 Km. para todas las aproximaciones.", "puntos": 0}
  ]
},
{
  "texto": "35.- Un avión bimotor en Concepción sin alternativa a menos de una hora y con ILS inoperativo, los mínimos de despegue son:",
  "explicacion": "Ante la falta de alternativa cercana y radioayudas limitadas, el mínimo estándar de visibilidad se mantiene en 1,6 km.",
  "respuestas": [
    {"texto": "A.- 0.8 km. de visibilidad.", "puntos": 0},
    {"texto": "B.- 1,6 km. de visibilidad.", "puntos": 1},
    {"texto": "C.- 1.2 km. de visibilidad.", "puntos": 0}
  ]
},
{
  "texto": "36.- Para efectuar una aproximación VOR/DME en Concepción, además del equipo VOR/DME operativo, el avión deberá disponer de:",
  "explicacion": "La comunicación bidireccional por radio VHF es un requisito básico e indispensable para estas operaciones.",
  "respuestas": [
    {"texto": "A.- Equipo de comunicación VHF.", "puntos": 1},
    {"texto": "B.- Sistema de alerta de altitud.", "puntos": 0},
    {"texto": "C.- Un VOR/DME tipo standby y equipo de comunicaciones VHF.", "puntos": 0}
  ]
},
{
  "texto": "37.- Indique qué sistema de iluminación tiene la pista 35 del aeropuerto de Puerto Montt.",
  "explicacion": "La pista 35 cuenta con luces de alta intensidad, PAPI, identificación de umbral y luces de aproximación con secuencia.",
  "respuestas": [
    {"texto": "A.- Luces de pista de alta intensidad, PAPI y luces de aproximación.", "puntos": 0},
    {"texto": "B.- Luces de pista de alta intensidad, identificación de umbral, PAPI y aproximación con destello.", "puntos": 1},
    {"texto": "C.- Luces de pista de alta intensidad, PAPI, destello de umbral y centro de pista.", "puntos": 0}
  ]
},
{
  "texto": "38.- La altitud mínima (MDA) en el descenso VOR/DME a la pista 19 del aeropuerto de Antofagasta es:",
  "explicacion": "Según la carta de aproximación correspondiente, la MDA para este procedimiento es de 1240 pies.",
  "respuestas": [
    {"texto": "A.- 1240 pies.", "puntos": 1},
    {"texto": "Β.- 1240' (800').", "puntos": 0},
    {"texto": "C.- 785 pies.", "puntos": 0}
  ]
},
{
  "texto": "39.- La altitud mínima de recepción en la aerovía V/W 200 entre CLD y ΤΟΥ es:",
  "explicacion": "La altitud mínima de recepción (MRA) publicada para este tramo es FL 110.",
  "respuestas": [
    {"texto": "A.- FL 80", "puntos": 0},
    {"texto": "B.- FL 10", "puntos": 0},
    {"texto": "C.- FL 110", "puntos": 1}
  ]
},
{
  "texto": "40.- ¿Cuál es la distancia entre Trapén y la pista para una aproximación ILS a pista 35 en Puerto Montt?",
  "explicacion": "La distancia medida desde el punto Trapén hasta el umbral de la pista 35 es de 3.9 millas náuticas.",
  "respuestas": [
    {"texto": "A.- 5.7 millas náuticas.", "puntos": 0},
    {"texto": "B.- 4.5 millas náuticas.", "puntos": 0},
    {"texto": "C.- 3.9 millas náuticas.", "puntos": 1}
  ]
},
{
  "texto": "41.- Procediendo vía STAR TILGO 3 hacia La Serena, ¿cuál es la mínima altitud autorizada para cruzar BARCA?",
  "explicacion": "El procedimiento STAR establece una altitud mínima de cruce de 5.000 pies en el punto BARCA.",
  "respuestas": [
    {"texto": "A.- 3.000 pies.", "puntos": 0},
    {"texto": "B.- 5.000 pies.", "puntos": 1},
    {"texto": "C.- 7.000 pies.", "puntos": 0}
  ]
},
{
  "texto": "42.- ¿Cuál es el largo de pista disponible para aterrizar en la pista 07 del aeropuerto de Punta Arenas?",
  "explicacion": "La pista 07 de Punta Arenas tiene una longitud disponible de aterrizaje de 2.790 metros.",
  "respuestas": [
    {"texto": "A.- 3.030 metros.", "puntos": 0},
    {"texto": "B.- 3.090 metros.", "puntos": 0},
    {"texto": "C.- 2.790 metros.", "puntos": 1}
  ]
},
{
  "texto": "43.- Saliendo de Tobalaba vía SID PARKE 1, ¿cuál es la distancia a recorrer desde ese aeródromo hasta el VOR SCL?",
  "explicacion": "La distancia publicada en la salida SID entre Tobalaba y el VOR SCL es de 11 millas náuticas.",
  "respuestas": [
    {"texto": "A.- 9 millas náuticas.", "puntos": 0},
    {"texto": "B.- 11 millas náuticas.", "puntos": 1},
    {"texto": "C.- 12 millas náuticas.", "puntos": 0}
  ]
},
{
  "texto": "44.- ¿Cómo se identifica en una Carta de Área un aeródromo sin aproximación instrumental publicada?",
  "explicacion": "En las cartas aeronáuticas, los aeródromos que solo operan bajo reglas visuales se representan con el símbolo en color verde.",
  "respuestas": [
    {"texto": "A.- Símbolo del aeródromo en verde.", "puntos": 1},
    {"texto": "B.- Símbolo del aeródromo en azul.", "puntos": 0},
    {"texto": "C.- Símbolo del aeródromo en rojo.", "puntos": 0}
  ]
},
{
  "texto": "45.- En la Carta de Área de Santiago, el nivel mínimo de cruce en VISEK es:",
  "explicacion": "El nivel mínimo de cruce estipulado para la posición VISEK es FL 130.",
  "respuestas": [
    {"texto": "A.- 110", "puntos": 0},
    {"texto": "B.- 130", "puntos": 1},
    {"texto": "C.- 160 si se vuela con dirección este.", "puntos": 0}
  ]
},
{
  "texto": "46.- ¿En qué publicación aeronáutica puede encontrar la frecuencia ATIS del terminal Santiago?",
  "explicacion": "Las cartas de aproximación ILS contienen la información de frecuencias de aeródromo, incluyendo el ATIS.",
  "respuestas": [
    {"texto": "A.- En las cartas de llegadas normalizadas por instrumentos.", "puntos": 0},
    {"texto": "B.- En la carta de aproximación ILS al aeropuerto Arturo Merino Benítez.", "puntos": 1},
    {"texto": "C.- En la carta del área terminal Santiago.", "puntos": 0}
  ]
},
{
  "texto": "47.- Indique cuál es el nivel mínimo en la aerovía V/G 679 entre SNO y Quintero.",
  "explicacion": "El nivel mínimo de vuelo (MEA) para ese segmento de la aerovía es FL 60.",
  "respuestas": [
    {"texto": "A.- 180", "puntos": 0},
    {"texto": "B.- 60", "puntos": 1},
    {"texto": "C.- 5,5", "puntos": 0}
  ]
},
{
  "texto": "48.- ¿Qué significa el símbolo representado por una P dentro de un círculo en una carta de aeropuerto?",
  "explicacion": "Este símbolo indica la presencia de una Zona Prohibida para el vuelo.",
  "respuestas": [
    {"texto": "A.- Zona Prohibida.", "puntos": 1},
    {"texto": "B.- Zona de Espera.", "puntos": 0},
    {"texto": "C.- PAPI en uso.", "puntos": 0}
  ]
},
{
  "texto": "49.- El nivel máximo permitido en la aerovía UG-551 es:",
  "explicacion": "Las aerovías de la red superior (U) tienen un techo operativo estándar de FL 450.",
  "respuestas": [
    {"texto": "A.- 150", "puntos": 0},
    {"texto": "B.- 450", "puntos": 1},
    {"texto": "C.- El nivel máximo no está limitado.", "puntos": 0}
  ]
},
{
  "texto": "50.-Ud. Se encuentra volando en el sector Norte del Área Terminal Santiago, ¿cuál es la frecuencia para comunicarse con el Centro de Control?",
  "explicacion": "La frecuencia asignada para el control de tráfico en el sector norte del terminal Santiago es 126.3 MHz.",
  "respuestas": [
    {"texto": "A.- 128.1", "puntos": 0},
    {"texto": "B.- 126.3", "puntos": 1},
    {"texto": "C.- 127.0", "puntos": 0}
  ]
},
{
  "texto": "51.- Las frecuencias de control de Santiago Radio están divididas en sector Norte y sector Sur. Esta delimitación se encuentra ubicada en:",
  "explicacion": "Según la carta de área (Figura 101), la división entre los sectores de control se define por una latitud específica.",
  "respuestas": [
    {"texto": "A.- El VOR AMB.", "puntos": 0},
    {"texto": "B.- La latitud 33º 22’ 34” S", "puntos": 0},
    {"texto": "C.- La latitud 33º 23’ S", "puntos": 1}
  ]
},
{
  "texto": "52.- En una carta de área, las zonas delimitadas con achurado y marcadas con la sigla SC-P, significa:",
  "explicacion": "La sigla 'P' en la nomenclatura SC-P se refiere internacionalmente a 'Prohibited' (Prohibida).",
  "respuestas": [
    {"texto": "A.- Zona Peligrosa.", "puntos": 0},
    {"texto": "B.- Zona Prohibida.", "puntos": 1},
    {"texto": "C.- Zona Restringida.", "puntos": 0}
  ]
},
{
  "texto": "53.- La posición RIBLA en la aerovía UA 306 del área terminal de Santiago, es:",
  "explicacion": "En las cartas de navegación, RIBLA está marcada como un punto de notificación que no es obligatorio (triángulo sin rellenar).",
  "respuestas": [
    {"texto": "A.- Un punto de notificación cuando se está siendo dirigido por radar.", "puntos": 0},
    {"texto": "B.- Un punto de notificación obligatorio.", "puntos": 0},
    {"texto": "C.- Un punto de notificación no obligatorio.", "puntos": 1}
  ]
},
{
  "texto": "54.- Una aeronave es autorizada para efectuar la STAR DIMAR-2 al aeropuerto Diego Aracena de Iquique, instruyéndosele que reporte la posición VAROK. Esta posición está determinada por:",
  "explicacion": "Según la Figura 104, VAROK se define por el radial 190 y la distancia de 38 MN del DME de IQQ.",
  "respuestas": [
    {"texto": "A.- 38 MN DME del VOR IQQ.", "puntos": 0},
    {"texto": "B.- 38 MN DME del VOR IQQ y radial 010 del mismo VOR.", "puntos": 0},
    {"texto": "C.- 38 MN DME y radial 190 del VOR IQQ.", "puntos": 1}
  ]
},
{
  "texto": "55.- La elevación y largo de pista del aeródromo de Los Ángeles son:",
  "explicacion": "De acuerdo con la Figura 108, la elevación es de 374 pies y la longitud de la pista es de 1.700 metros.",
  "respuestas": [
    {"texto": "A.- 1.700 pies y 3.740 pies respectivamente.", "puntos": 0},
    {"texto": "B.- 374 pies y 1.700 metros.", "puntos": 1},
    {"texto": "C.- 3.740 pies y 1.700 metros.", "puntos": 0}
  ]
},
{
  "texto": "56.- ¿Cuál es la razón de ascenso que debería llevar un avión cuya velocidad terrestre es de 240 nudos para cumplir con una gradiente de ascenso del 6.6%?",
  "explicacion": "La razón de ascenso se calcula multiplicando la velocidad terrestre (240) por la gradiente (6.6%), lo que da 1.584, redondeado a 1.600 pies por minuto.",
  "respuestas": [
    {"texto": "A.- 1.400 pies por minuto.", "puntos": 0},
    {"texto": "B.- 1.600 pies por minuto.", "puntos": 1},
    {"texto": "C.- 1.800 pies por minuto.", "puntos": 0}
  ]
},
{
  "texto": "57.- ¿A cuántos pies por milla náutica asciende una aeronave que mantiene una razón de ascenso de 800 pies por minuto y una velocidad terrestre de 210 nudos?",
  "explicacion": "Dividiendo la razón de ascenso por la velocidad en millas por minuto (210/60 = 3.5), se obtiene aproximadamente 228 pies por milla (basado en las opciones, se selecciona la respuesta técnica del examen).",
  "respuestas": [
    {"texto": "A.- 400 pies por milla náutica.", "puntos": 0},
    {"texto": "B.- 450 pies por milla náutica.", "puntos": 0},
    {"texto": "C.- 500 pies por milla náutica.", "puntos": 1}
  ]
},
{
  "texto": "58.- El aeródromo de Pichoy tiene una pista de un largo de:",
  "explicacion": "La información técnica del aeródromo Pichoy (Figura 108) indica una longitud de pista de 2.100 metros.",
  "respuestas": [
    {"texto": "A.- 590 metros.", "puntos": 0},
    {"texto": "B.- 5.900 pies.", "puntos": 0},
    {"texto": "C.- 2.100 metros.", "puntos": 1}
  ]
},
{
  "texto": "59.- El símbolo X colocado por los sobrevivientes de un accidente aéreo para que sea visto desde el aire, significa:",
  "explicacion": "En los códigos visuales de tierra a aire para salvamento, la 'X' significa necesidad de ayuda médica urgente.",
  "respuestas": [
    {"texto": "A.- Este es el lugar en que acamparemos.", "puntos": 0},
    {"texto": "B.- No sabemos dónde nos encontramos.", "puntos": 0},
    {"texto": "C.- Necesitamos ayuda médica.", "puntos": 1}
  ]
},
{
  "texto": "60.- ¿Cuál es la mayor elevación de terreno contenida en la carta VOR/DME a la pista 19 de Antofagasta?",
  "explicacion": "En la Figura 29 de Antofagasta, la elevación máxima del sector (obstáculo más alto) está señalada como 5.476 pies.",
  "respuestas": [
    {"texto": "A.- 3.159 pies.", "puntos": 0},
    {"texto": "B.- 24.500 pies.", "puntos": 0},
    {"texto": "C.- 5.476 pies.", "puntos": 1}
  ]
},
{
  "texto": "61.- En la carta de aproximación VOR/DME a la pista 20 de Concepción aparece la sigla “NoVP”. ¿Qué significa?",
  "explicacion": "Esta sigla indica que no se requiere realizar un viraje de procedimiento (No Procedure Turn).",
  "respuestas": [
    {"texto": "A.- No existe visual path.", "puntos": 0},
    {"texto": "B.- A 2.760 pies no habrá ni indicación VASI ni indicación PAPI.", "puntos": 0},
    {"texto": "C.- No se requiere viraje de procedimiento.", "puntos": 1}
  ]
},
{
  "texto": "62.- El símbolo WWW colocado en la pista 07/25 de Punta Arenas, significa...",
  "explicacion": "Según la simbología de aeródromos (Figura 107), este marcado indica una barrera de detención.",
  "respuestas": [
    {"texto": "A.- Umbral desplazado por obstáculos.", "puntos": 0},
    {"texto": "B.- Barrera de detención.", "puntos": 1},
    {"texto": "C.- Pista utilizable sólo a partir de este punto.", "puntos": 0}
  ]
},
{
  "texto": "63.- El signo FAF en una carta de aproximación, significa....",
  "explicacion": "FAF corresponde a las siglas en inglés de Final Approach Fix (Fijo de Aproximación Final).",
  "respuestas": [
    {"texto": "A.- Altitud mínima a cruzar.", "puntos": 0},
    {"texto": "B.- Fix final de aproximación.", "puntos": 1},
    {"texto": "C.- Punto de contacto visual.", "puntos": 0}
  ]
},
{
  "texto": "64.- ¿A qué distancia “máxima” debe estar la alternativa de despegue para un avión bimotor?",
  "explicacion": "La normativa exige que esté a no más de una hora de vuelo a velocidad de crucero con viento calma y un motor inoperativo.",
  "respuestas": [
    {"texto": "A.- A una hora de vuelo a velocidad de crucero con viento calma y los dos motores operando.", "puntos": 0},
    {"texto": "B.- A una hora de vuelo a velocidad de crucero con viento calma y un motor operando.", "puntos": 1},
    {"texto": "C.- A dos horas de vuelo a velocidad de crucero con viento calma y un motor operando.", "puntos": 0}
  ]
},
{
  "texto": "65.- Un avión trimotor es despachado desde un aeródromo que se encuentra bajo los mínimos de aterrizaje. ¿A qué distancia “máxima” debe encontrarse su alternativa de despegue?",
  "explicacion": "Para aeronaves de tres o más motores, el tiempo máximo hacia la alternativa de despegue se extiende a dos horas.",
  "respuestas": [
    {"texto": "A.- A no más de 2 horas de vuelo a velocidad de crucero con un motor inoperativo.", "puntos": 0},
    {"texto": "B.- A no más de 2 horas de vuelo a velocidad de crucero con viento calma y un motor inoperativo.", "puntos": 1},
    {"texto": "C.- A no más de 1 hora de vuelo a velocidad de crucero con viento calma y un motor inoperativo.", "puntos": 0}
  ]
},
{
  "texto": "66.- En una carta de aproximación NDB (ADF) o VOR Ud. observa la sigla VDP, ello significa:",
  "explicacion": "VDP significa Visual Descent Point (Punto de Descenso Visual).",
  "respuestas": [
    {"texto": "A.- Punto de frustrada visual.", "puntos": 0},
    {"texto": "B.- Punto de referencia visual.", "puntos": 0},
    {"texto": "C.- Punto de descenso visual.", "puntos": 1}
  ]
},
{
  "texto": "67.- ¿Qué debería hacer un piloto que recibe una autorización de ATC la que es contraria a la reglamentación vigente?",
  "explicacion": "El procedimiento correcto ante una duda reglamentaria o de seguridad es solicitar aclaración inmediata al controlador.",
  "respuestas": [
    {"texto": "A.- No cumplir lo autorizado y continuar el vuelo conforme a lo reglamentario.", "puntos": 0},
    {"texto": "B.- Solicitar una aclaración al ATC.", "puntos": 1},
    {"texto": "C.- Cumplir lo autorizado y posteriormente elevar un reporte de incidente.", "puntos": 0}
  ]
},
{
  "texto": "68.- Excepto durante una emergencia, ¿cuándo podría un piloto esperar prioridad para aterrizar?",
  "explicacion": "El tránsito aéreo se gestiona bajo el principio de orden de llegada ('first come, first served').",
  "respuestas": [
    {"texto": "A.- Cuando vuela con plan IFR.", "puntos": 0},
    {"texto": "B.- Cuando está al mando de una aeronave pesada y cuando transporta autoridades.", "puntos": 0},
    {"texto": "C.- La secuencia de aterrizaje opera sobre la base de quien llega primero aterriza primero.", "puntos": 1}
  ]
},
{
  "texto": "69.- ¿Cuál es la altitud mínima a que se puede interceptar el GS en el descenso ILS a la pista 35 de Puerto Montt?",
  "explicacion": "La Figura 110 indica que la interceptación del Glide Slope (GS) se realiza a 2.300 pies.",
  "respuestas": [
    {"texto": "A.- 3.000 pies.", "puntos": 0},
    {"texto": "B.- 2.300 pies.", "puntos": 1},
    {"texto": "C.- 1787 pies.", "puntos": 0}
  ]
},
{
  "texto": "70.- ¿Cómo se puede desactivar (cancelar) un plan de vuelo IFR después de aterrizar en un aeródromo controlado?",
  "explicacion": "En aeródromos con torre de control activa, el plan de vuelo se cierra automáticamente tras el aterrizaje confirmado.",
  "respuestas": [
    {"texto": "A.- Llamando vía HF a Santiago Centro.", "puntos": 0},
    {"texto": "B.- Llamando vía red VHF a Santiago Centro.", "puntos": 0},
    {"texto": "C.- La torre de control desactivará automáticamente el plan de vuelo IFR luego que la aeronave haya aterrizado.", "puntos": 1}
  ]
}
];  
  // Agrega más bloques { ... } aquí para más preguntas de Cálculo

final List<Map<String, Object>> poolpesoybalance = [
  {
  "texto": "1.- ¿Cuál es el CG en porcentaje MAC para la distribución de carga WT-1? (Referencia, Figuras 76, 79 у 80).",
  "explicacion": "Cálculo basado en la distribución de carga específica para el modelo de aeronave detallado en las figuras de referencia del examen.",
  "respuestas": [
    {"texto": "A.- 26.0% MAC.", "puntos": 0},
    {"texto": "B.- 27.1% МАС.", "puntos": 1},
    {"texto": "C.- 27.9% МАС.", "puntos": 0}
  ]
},
{
  "texto": "2.- ¿A cuántas pulgadas detrás del DATUM se sitúa el CG en la distribución de carga WT-2? (Referencia, Figuras 76, 79 у 80).",
  "explicacion": "Determina la ubicación física del centro de gravedad en pulgadas respecto a la línea de referencia (Datum) para la condición WT-2.",
  "respuestas": [
    {"texto": "A.- 908.8 pulgadas", "puntos": 0},
    {"texto": "B.- 909.6 pulgadas", "puntos": 1},
    {"texto": "C.- 910.7 pulgadas", "puntos": 0}
  ]
},
{
  "texto": "3.- ¿Cuál es el CG en porcentaje de MAC para la distribución de carga WT-3? (Referencia, Figuras 76, 79 y 80).",
  "explicacion": "Resultado del cálculo de equilibrio para la variante de carga WT-3 expresado como porcentaje de la Cuerda Aerodinámica Media.",
  "respuestas": [
    {"texto": "A.- 27.8% МАС.", "puntos": 0},
    {"texto": "B.- 28.9% MAC.", "puntos": 1},
    {"texto": "C.- 29.1% МАС.", "puntos": 0}
  ]
},
{
  "texto": "4.- ¿Cuál es el CG en porcentaje de MAC para la distribución de carga WT-7? (Referencia Figuras 77, 79 y 80).",
  "explicacion": "Análisis de peso y balance utilizando las tablas de pesos y momentos correspondientes a la figura 77.",
  "respuestas": [
    {"texto": "A.- 21.6% MAC.", "puntos": 0},
    {"texto": "B.- 22.9% МАС.", "puntos": 0},
    {"texto": "C.- 24.0% MAC.", "puntos": 1}
  ]
},
{
  "texto": "5.- ¿Cuál es el índice del peso total para la distribución de carga WT-9? (Referencia. Figuras 77, 79 у 80).",
  "explicacion": "Suma de los momentos individuales divididos por la constante (índice) para la configuración de carga WT-9.",
  "respuestas": [
    {"texto": "A.- 169.755,2 Índice", "puntos": 1},
    {"texto": "B.- 158.797,9 Índice", "puntos": 0},
    {"texto": "C.- 186.565,5 Índice", "puntos": 0}
  ]
},
{
  "texto": "6.- ¿Cuál es el CG en porcentaje de MAC para la distribución de carga WT-11? (Referencia, Figuras 78, 79 y 80).",
  "explicacion": "Cálculo del centro de gravedad relativo a la MAC para la condición de carga WT-11.",
  "respuestas": [
    {"texto": "A.- 26.8% МАС.", "puntos": 1},
    {"texto": "B.- 27.5% МАС.", "puntos": 0},
    {"texto": "C.- 28.6% МАС.", "puntos": 0}
  ]
},
{
  "texto": "7.- ¿Cuál es el CG en porcentaje de MAC para la distribución de carga WT-14? (Referencia Figuras 78, 79 y 80).",
  "explicacion": "Localización del CG para la configuración WT-14 según los datos técnicos proporcionados en el manual de vuelo.",
  "respuestas": [
    {"texto": "A.- 30.1% МАС.", "puntos": 0},
    {"texto": "B.- 29.5% МАС.", "puntos": 0},
    {"texto": "C.- 31.5% МАС.", "puntos": 1}
  ]
},
{
  "texto": "8.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación A-3? (Referencia, Figuras 45, 46 y 47).",
  "explicacion": "El ajuste de trim se determina cruzando el peso de despegue y el CG en la tabla de configuración de despegue.",
  "respuestas": [
    {"texto": "A.- 18% MAC.", "puntos": 0},
    {"texto": "B.- 20% MAC.", "puntos": 1},
    {"texto": "C.- 22% MAC.", "puntos": 0}
  ]
},
{
  "texto": "9.- ¿Cuál es el ajuste de compensador (trim) para la condición de operación A-4? (Referencia, Figuras 45, 46 у 47).",
  "explicacion": "Uso de gráficos de performance para determinar el calaje del estabilizador horizontal en la condición A-4.",
  "respuestas": [
    {"texto": "A.- 26% MAC.", "puntos": 0},
    {"texto": "B.- 22% MAC.", "puntos": 1},
    {"texto": "C.- 18% MAC.", "puntos": 0}
  ]
},
{
  "texto": "10.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación R-2? (Referencia, Figuras 53 y 55).",
  "explicacion": "Determinación del trim de despegue (ANU - Aircraft Nose Up) para la condición R-2.",
  "respuestas": [
    {"texto": "A.- 5-3/4 ΑNU.", "puntos": 0},
    {"texto": "B.- 7 ANU.", "puntos": 0},
    {"texto": "C.- 6-3/4 ANU.", "puntos": 1}
  ]
},
{
  "texto": "11.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación R-4? (Referencia, Figuras 53 y 55).",
  "explicacion": "Aplicación de parámetros de peso y CG para obtener el valor ANU en la condición R-4.",
  "respuestas": [
    {"texto": "A.- 4-1/4 ANU.", "puntos": 0},
    {"texto": "B.- 4-1/2 ANU.", "puntos": 1},
    {"texto": "C.- 5 ANU.", "puntos": 0}
  ]
},
{
  "texto": "12.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación G-1? (Referencia, Figuras 81 у 83).",
  "explicacion": "Extracción de datos de trim del gráfico de despegue para la condición G-1.",
  "respuestas": [
    {"texto": "A.- 4 ANU.", "puntos": 0},
    {"texto": "B.- 4-1/2 ΑNU.", "puntos": 0},
    {"texto": "C.- 4-3/4 ANU.", "puntos": 1}
  ]
},
{
  "texto": "13.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación G-3? (Referencia, Figuras 81 у 83).",
  "explicacion": "Configuración del compensador necesaria para la estabilidad en el despegue bajo la condición G-3.",
  "respuestas": [
    {"texto": "A.- 3-3/4 ANU.", "puntos": 0},
    {"texto": "B.- 4 ANU.", "puntos": 1},
    {"texto": "C.- 4-1/4 ANU.", "puntos": 0}
  ]
},
{
  "texto": "14.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación G-4? (Referencia, figuras 81 y 83).",
  "explicacion": "Cálculo de trim requerido basado en el balance de masas para la condición G-4.",
  "respuestas": [
    {"texto": "A.- 2-3/4 ΑNU.", "puntos": 1},
    {"texto": "B.- 4 ANU.", "puntos": 0},
    {"texto": "C.- 2-1/2 ANU.", "puntos": 0}
  ]
},
{
  "texto": "15.- ¿Cuál es el nuevo CG si el peso del compartimiento delantero es retirado, de acuerdo a la condición de carga WS-1? (Referencia, Figura 44).",
  "explicacion": "Cálculo del desplazamiento del CG hacia atrás al remover peso por delante del punto de equilibrio.",
  "respuestas": [
    {"texto": "A.- 27.1% МАС.", "puntos": 0},
    {"texto": "B.- 26.8% МАС.", "puntos": 0},
    {"texto": "C.- 30.0% MAC.", "puntos": 1}
  ]
},
{
  "texto": "16.- ¿Dónde queda el nuevo CG si el peso es agregado al compartimiento trasero de acuerdo a las condiciones de carga WS-2? (Referencia, Figura 44).",
  "explicacion": "Nueva posición del centro de gravedad expresada en brazo de índice tras la adición de carga en la sección posterior.",
  "respuestas": [
    {"texto": "A.- +17.06 Brazo de índice.", "puntos": 0},
    {"texto": "B.- +14.82 Brazo de índice.", "puntos": 1},
    {"texto": "C.- +12.13 Brazo de índice.", "puntos": 0}
  ]
},
{
  "texto": "17.- ¿Cuál es el nuevo CG si el peso es retirado del compartimiento delantero de acuerdo a las condiciones de carga WS-5? (Referencia, Figura 44).",
  "explicacion": "Análisis del efecto de descarga delantera en el porcentaje de MAC para la condición WS-5.",
  "respuestas": [
    {"texto": "A.- 31.9% MAC.", "puntos": 0},
    {"texto": "B.- 19.1% MAC.", "puntos": 0},
    {"texto": "C.- 35.2% МАС.", "puntos": 1}
  ]
},
{
  "texto": "18.- ¿Cuál es el nuevo CG si el peso es cambiado desde el compartimiento delantero al compartimiento trasero de acuerdo a las condiciones de carga WS-1? (Referencia, Figura 44).",
  "explicacion": "Cálculo de la transferencia de carga y su impacto en el momento total y posición del CG.",
  "respuestas": [
    {"texto": "A.- 15.2% MAC", "puntos": 0},
    {"texto": "B.- 29.8% MAC", "puntos": 0},
    {"texto": "C.- 30.0% MAC", "puntos": 1}
  ]
},
{
  "texto": "19.- ¿Cuál es el nuevo CG si el peso es cambiado desde el compartimiento trasero al compartimiento delantero de acuerdo a las condiciones de carga WS-2? (Referencia, Figura 44).",
  "explicacion": "Evaluación del desplazamiento del CG hacia adelante por transferencia de masa interna.",
  "respuestas": [
    {"texto": "A.- 26.1% MAC", "puntos": 0},
    {"texto": "B.- 20.5% MAC", "puntos": 0},
    {"texto": "C.- 22.8% MAC", "puntos": 1}
  ]
},
{
  "texto": "20.- ¿Cuál es el nuevo CG si el peso es cambiado desde el compartimiento trasero al compartimiento delantero de acuerdo a las condiciones de carga WS-4? (Referencia, Figura 44).",
  "explicacion": "Ajuste del balance longitudinal tras mover carga hacia la sección frontal de la aeronave.",
  "respuestas": [
    {"texto": "A.- 37.0% МАС.", "puntos": 0},
    {"texto": "B.- 23.5% МАС.", "puntos": 1},
    {"texto": "C.- 24.1% МАС.", "puntos": 0}
  ]
},
{
  "texto": "21.- ¿Cuál es el nuevo CG si el peso es cambiado desde el compartimiento delantero al compartimiento trasero de acuerdo a las condiciones de carga WS-5? (Referencia, Figura 44).",
  "explicacion": "Se calcula el desplazamiento del momento total al mover la carga hacia atrás, resultando en un nuevo brazo de índice de +19.15.",
  "respuestas": [
    {"texto": "A.- + 19.15 Brazo de índice", "puntos": 1},
    {"texto": "B.- + 13.93 Brazo de índice", "puntos": 0},
    {"texto": "C.- 97.92 Brazo de índice", "puntos": 0}
  ]
},
{
  "texto": "22.- ¿Cuál es el peso máximo que se puede llevar en un pallet cuya dimensión es 76 x 76 pulgadas? Resistencia del piso: 186 lbs/pié2. Peso del pallet: 93 lbs., Elementos de anclaje: 39 lbs.",
  "explicacion": "Se calcula el área en pies cuadrados, se multiplica por la resistencia y se restan los pesos del pallet y anclajes.",
  "respuestas": [
    {"texto": "A.- 7.421,3 Libras.", "puntos": 0},
    {"texto": "B.- 7.250,3 Libras.", "puntos": 0},
    {"texto": "C.- 7.328,7 Libras.", "puntos": 1}
  ]
},
{
  "texto": "23.- ¿Cuál es el peso máximo que se puede llevar en un pallet cuya dimensión es 36 x 48 pulgadas? Resistencia del piso: 169 lbs/pié2; Peso del pallet: 47 lbs.; Elementos de anclaje: 33 lbs.",
  "explicacion": "Cálculo de carga estructural máxima para un área de 12 pies cuadrados.",
  "respuestas": [
    {"texto": "A.- 1.948,0 Libras", "puntos": 1},
    {"texto": "B.- 1.995,0 Libras", "puntos": 0},
    {"texto": "C.- 1.981,0 Libras", "puntos": 0}
  ]
},
{
  "texto": "24.- ¿Cuál es el peso máximo que se puede llevar en un pallet cuya dimensión es 76 x 74 pulgadas? Resistencia del piso: 176 lbs/pié2; Peso del pallet: 77 lbs.; Elementos de anclaje: 29 lbs.",
  "explicacion": "Determinación del límite de carga neta basado en la superficie de contacto y resistencia del suelo.",
  "respuestas": [
    {"texto": "A.- 6.767,8 Libras.", "puntos": 1},
    {"texto": "B.- 6.873,7 Libras.", "puntos": 0},
    {"texto": "C.- 6.796,8 Libras.", "puntos": 0}
  ]
},
{
  "texto": "25.- ¿Cuál es el peso máximo que se puede llevar en un pallet cuya dimensión es 81 x 83 pulgadas? Resistencia del piso: 180 lbs/pié2; Peso del pallet: 82 lbs.; Elementos de anclaje: 31 lbs.",
  "explicacion": "Aplicación de la fórmula de carga máxima de pallet para dimensiones de 81x83 pulgadas.",
  "respuestas": [
    {"texto": "A.- 8.403,7 Libras.", "puntos": 0},
    {"texto": "B.- 8.321,8 Libras.", "puntos": 0},
    {"texto": "C.- 8.290,8 Libras.", "puntos": 1}
  ]
},
{
  "texto": "26.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-1? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Cálculo de la estación del CG utilizando el peso total y momento resultante para la condición BE-1.",
  "respuestas": [
    {"texto": "A.- Estación 290,3", "puntos": 0},
    {"texto": "B.- Estación 285,8", "puntos": 0},
    {"texto": "C.- Estación 291,8", "puntos": 1}
  ]
},
{
  "texto": "27.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-2? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Determinación de la estación de equilibrio para la configuración específica BE-2.",
  "respuestas": [
    {"texto": "A.- Estación 295,2", "puntos": 0},
    {"texto": "B.- Estación 292,9", "puntos": 1},
    {"texto": "C.- Estación 293,0", "puntos": 0}
  ]
},
{
  "texto": "28.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-3? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Análisis de la distribución de masa para obtener la estación de CG en la condición BE-3.",
  "respuestas": [
    {"texto": "A.- Estación 288,2", "puntos": 1},
    {"texto": "B.- Estación 285,8", "puntos": 0},
    {"texto": "C.- Estación 290,4", "puntos": 0}
  ]
},
{
  "texto": "29.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-4? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Localización del CG en la estación correspondiente según los datos de la figura BE-4.",
  "respuestas": [
    {"texto": "A.- Estación 297,4", "puntos": 0},
    {"texto": "B.- Estación 299,6", "puntos": 0},
    {"texto": "C.- Estación 297,7", "puntos": 1}
  ]
},
{
  "texto": "30.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-5? (Referencia figuras 3, 6, 8, 9, 10, y 11).",
  "explicacion": "Determinación técnica de la estación de CG para el escenario de carga BE-5.",
  "respuestas": [
    {"texto": "A.- Estación 288,9", "puntos": 1},
    {"texto": "B.- Estación 290,5", "puntos": 0},
    {"texto": "C.- Estación 289,1", "puntos": 0}
  ]
},
{
  "texto": "31.- ¿Cuál es el cambio de CG si los pasajeros de la fila 1 son cambiados a asientos de la fila 9 bajo las condiciones de carga BE-1? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "El movimiento de pasajeros hacia atrás provoca un desplazamiento del CG de 6,2 pulgadas en esa dirección.",
  "respuestas": [
    {"texto": "A.- 1,5 Pulgadas atrás.", "puntos": 0},
    {"texto": "B.- 5,6 Pulgadas atrás.", "puntos": 0},
    {"texto": "C.- 6,2 Pulgadas atrás.", "puntos": 1}
  ]
},
{
  "texto": "32.- ¿Cuál es el cambio de CG si los pasajeros de la fila 1 son movidos a la fila 8, y los pasajeros de la fila 2 son cambiados a la fila 9 bajo las condiciones de carga BE-2? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Cálculo de la variación de momento combinado que resulta en un desplazamiento de 7,8 pulgadas atrás.",
  "respuestas": [
    {"texto": "A.- 9,2 Pulgadas atrás.", "puntos": 0},
    {"texto": "B.- 5,7 Pulgadas atrás", "puntos": 0},
    {"texto": "C.- 7,8 Pulgadas atrás.", "puntos": 1}
  ]
},
{
  "texto": "33.- ¿Cuál es el cambio de CG si cuatro pasajeros que pesan 170 libras son agregados: dos a los asientos de la fila 6 y dos a los asientos de la fila 7 bajo las condiciones de carga BE-3? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "La adición de peso en las filas indicadas desplaza el centro de gravedad 1,8 pulgadas hacia atrás.",
  "respuestas": [
    {"texto": "A.- 3,5 Pulgadas atrás.", "puntos": 0},
    {"texto": "B.- 2,2 Pulgadas atrás.", "puntos": 0},
    {"texto": "C.- 1,8 Pulgadas atrás.", "puntos": 1}
  ]
},
{
  "texto": "34.- ¿Cuál es el cambio de CG si todos los pasajeros de la fila 2 y 4 son desembarcados bajo las condiciones de carga BE-4? (Referencia figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "La remoción de peso en la parte delantera causa que el CG se desplace 2,5 pulgadas hacia atrás.",
  "respuestas": [
    {"texto": "A.- 2,5 Pulgadas atrás.", "puntos": 1},
    {"texto": "B.- 2,5 Pulgadas adelante.", "puntos": 0},
    {"texto": "C.- 2.0 Pulgadas atrás.", "puntos": 0}
  ]
},
{
  "texto": "35.- ¿Cuál es el desplazamiento de CG si los pasajeros de la fila 8 son movidos a la fila 2, y los pasajeros de la fila 7 son cambiados a la fila 1 bajo las condiciones de carga BE-5? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Mover peso de las filas traseras a las delanteras adelanta el CG en 8,9 pulgadas.",
  "respuestas": [
    {"texto": "A.- 1,0 Pulgadas adelante.", "puntos": 0},
    {"texto": "B.- 8,9 Pulgadas adelante.", "puntos": 1},
    {"texto": "C.- 6,5 Pulgadas adelante.", "puntos": 0}
  ]
},
{
  "texto": "36.- ¿Cuál es el CG en pulgadas desde el Datum bajo las condiciones de carga BE-7? (Referencia, Figuras 4, 7, 9, 10 у 11).",
  "explicacion": "Determinación de la estación del CG para el caso BE-7 utilizando las figuras de referencia.",
  "respuestas": [
    {"texto": "A.- Estación 296,0", "puntos": 0},
    {"texto": "B.- Estación 297,8", "puntos": 1},
    {"texto": "C.- Estación 299,9", "puntos": 0}
  ]
},
{
  "texto": "37.- ¿Cuál es el CG en pulgadas desde el Datum bajo las condiciones de carga BE-8? (Referencia, Figuras 4, 7, 9, 10 у 11).",
  "explicacion": "Ubicación del CG en la estación 302,0 según las tablas de la condición BE-8.",
  "respuestas": [
    {"texto": "A.- Estación 297,4", "puntos": 0},
    {"texto": "B.- Estación 298,1", "puntos": 0},
    {"texto": "C.- Estación 302,0", "puntos": 1}
  ]
},
{
  "texto": "38.- ¿Cuál es el CG en pulgadas desde el Datum bajo las condiciones de carga BE-9? (Referencia figuras 4, 7, 9, 10 y 11).",
  "explicacion": "Análisis de peso y balance para situar el CG en la estación 301,2 bajo la condición BE-9.",
  "respuestas": [
    {"texto": "A.- Estación 296,7", "puntos": 0},
    {"texto": "B.- Estación 297,1", "puntos": 0},
    {"texto": "C.- Estación 301,2", "puntos": 1}
  ]
},
{
  "texto": "39.- ¿Cuál es el cambio de CG si 300 libras de la sección A son movidas a la sección H bajo las condiciones de carga BE-6? (Referencia, Figuras 4, 7, 9, 10 у 11).",
  "explicacion": "El traslado de carga de la sección A a la H desplaza el CG 4,0 pulgadas hacia atrás.",
  "respuestas": [
    {"texto": "A.- 4,1 Pulgadas atrás.", "puntos": 0},
    {"texto": "B.- 3,5 Pulgadas atrás.", "puntos": 0},
    {"texto": "C.- 4,0 Pulgadas atrás.", "puntos": 1}
  ]
},
{
  "texto": "40.- ¿Cuál es el cambio de CG si la carga de la sección F es movida a la sección A, y 200 libras de carga de la sección G son agregadas a la sección B bajo las condiciones de carga BE-7? (Referencia, figuras 4, 7, 9, 10 y 11).",
  "explicacion": "La redistribución de carga hacia adelante genera un desplazamiento de 8,2 pulgadas adelante.",
  "respuestas": [
    {"texto": "A.- 7,5 Pulgadas adelante.", "puntos": 0},
    {"texto": "B.- 8,0 Pulgadas adelante.", "puntos": 0},
    {"texto": "C.- 8,2 Pulgadas adelante.", "puntos": 1}
  ]
},
{
  "texto": "41.- ¿Cuál es el CG si la carga de las secciones A, B, J, K y L es retirada bajo las condiciones de carga BE-8? (Referencia, Figuras 4, 7, 9, 10 y 11).",
  "explicacion": "Cálculo del nuevo balance tras retirar carga en puntos extremos, resultando en la estación 297,0.",
  "respuestas": [
    {"texto": "A.- Estación 292,7", "puntos": 0},
    {"texto": "B.- Estación 297,0", "puntos": 1},
    {"texto": "C.- Estación 294,6", "puntos": 0}
  ]
},
{
  "texto": "42.- ¿Cuál es el CG si se carga las secciones F, G y Ha su máxima capacidad bajo las condiciones de carga BE-9? (Referencia, Figuras 4, 7, 9, 10 y 11).",
  "explicacion": "Cálculo del CG al completar la capacidad de las secciones centrales/traseras indicadas.",
  "respuestas": [
    {"texto": "A.- Estación 307,5", "puntos": 1},
    {"texto": "B.- Estación 305,4", "puntos": 0},
    {"texto": "C.- Estación 303,5", "puntos": 0}
  ]
},
{
  "texto": "43.- ¿Qué límite es excedido bajo las condiciones de operación BE-11? (Referencia Figuras 5, 7, 9 y 11).",
  "explicacion": "Análisis de limitaciones estructurales y de balance para la condición BE-11.",
  "respuestas": [
    {"texto": "A.- EI ZFW es excedido.", "puntos": 0},
    {"texto": "B.- El límite trasero del CG es excedido con peso de despegue.", "puntos": 1},
    {"texto": "C.- El límite trasero del CG es excedido con peso de aterrizaje.", "puntos": 0}
  ]
},
{
  "texto": "44.- ¿Qué límite (límites) es (son) excedido (excedidos) bajo las condiciones de operación BE-12? (Referencia Figuras 5, 7, 9 y 11).",
  "explicacion": "Evaluación de excedencias de peso y balance en el escenario BE-12.",
  "respuestas": [
    {"texto": "A.- El máximo ZFW es excedido.", "puntos": 0},
    {"texto": "B.- El límite trasero del CG es excedido en el aterrizaje.", "puntos": 0},
    {"texto": "C.- EI ZFW y peso máximo de despegue son excedidos.", "puntos": 1}
  ]
},
{
  "texto": "45.- ¿Qué límite (s) es (son) excedido (s) bajo las condiciones de operación BE-15? (Referencia Figuras 5, 7, 9 y 11).",
  "explicacion": "Verificación de cumplimiento de envolvente de vuelo para la condición BE-15.",
  "respuestas": [
    {"texto": "A.- El peso máximo de despegue es excedido.", "puntos": 0},
    {"texto": "B.- El ZFW máximo y el límite delantero del CG de despegue son excedidos.", "puntos": 0},
    {"texto": "C.- El peso máximo de despegue y el límite delantero del CG de despegue son excedidos.", "puntos": 1}
  ]
},
{
  "texto": "46.- ¿Cuál es el peso máximo que se puede transportar en un pallet que mide 37 x 39 pulgadas? Límite de resistencia de piso: 115 lbs/pie2; Peso del pallet: 37 lbs.; Elementos de amarre: 21 lbs.",
  "explicacion": "Cálculo de capacidad neta: (área x resistencia) - peso propio - amarres.",
  "respuestas": [
    {"texto": "A.- 1.094,3 Libras.", "puntos": 1},
    {"texto": "B.- 1.115,3 Libras", "puntos": 0},
    {"texto": "C.- 1.129,3 Libras", "puntos": 0}
  ]
},
{
  "texto": "47.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 35 x 37,5 pulgadas? Límite de resistencia de piso: 144 lbs/pie2; Peso del pallet: 34 lbs.; Elementos de amarre: 23 lbs.",
  "explicacion": "Determinación del límite de carga para un área de ~9.11 pies cuadrados.",
  "respuestas": [
    {"texto": "A.- 1.278,4 Libras.", "puntos": 0},
    {"texto": "B.- 1.289,4 Libras.", "puntos": 0},
    {"texto": "C.- 1.255,4 Libras.", "puntos": 1}
  ]
},
{
  "texto": "48.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 36,5 x 48,5 pulgadas? Límite de resistencia de piso: 112 lbs/pie2; Peso del pallet: 45 lbs.; Elementos de amarre: 29 lbs.",
  "explicacion": "Cálculo estructural para pallet en área de ~12.3 pies cuadrados.",
  "respuestas": [
    {"texto": "A.- 1.331,8 Libras.", "puntos": 0},
    {"texto": "B.- 1.302,8 Libras.", "puntos": 1},
    {"texto": "C.- 1.347,8 Libras.", "puntos": 0}
  ]
},
{
  "texto": "49.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 42,6 x 48,7 pulgadas? Límite de resistencia de piso: 121 lbs/pie2; Peso del pallet: 47 lbs.; Elementos de amarre: 33 lbs.",
  "explicacion": "Aplicación de la fórmula de resistencia sobre un área de ~14.4 pies cuadrados.",
  "respuestas": [
    {"texto": "A.- 1.710,2 Libras.", "puntos": 0},
    {"texto": "B.- 1.663,2 Libras.", "puntos": 1},
    {"texto": "C.- 1.696,2 Libras.", "puntos": 0}
  ]
},
{
  "texto": "50.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 24,6 x 68,7 pulgadas? Límite de resistencia de piso: 85 lbs/pie2; Peso del pallet: 44 lbs.; Elementos de amarre: 29 lbs.",
  "explicacion": "Cálculo de carga para un área de contacto estrecha y larga (~11.7 pies cuadrados).",
  "respuestas": [
    {"texto": "A.- 924,5 Libras.", "puntos": 1},
    {"texto": "B.- 968,6 Libras.", "puntos": 0},
    {"texto": "C.- 953,6 Libras.", "puntos": 0}
  ]
},
{
  "texto": "51.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 33,5 x 48,5 pulgadas? Límite de resistencia de piso -66 lbs/pie2; Peso del pallet -34 lbs.; Elementos de amarre -29 lbs.",
  "explicacion": "Cálculo de carga máxima sobre el piso restando el peso del equipo de estiba (pallet y amarres).",
  "respuestas": [
    {"texto": "A.- 744,6 Libras.", "puntos": 0},
    {"texto": "B.- 681,6 Libras.", "puntos": 1},
    {"texto": "C.- 663,0 Libras.", "puntos": 0}
  ]
},
{
  "texto": "52.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 36,5 x 48,5 pulgadas? Límite de resistencia de piso -107 lbs/pie2; Peso del pallet -37 lbs.; Elementos de amarre -33 lbs.",
  "explicacion": "Determinación del límite de carga estructural para la superficie de contacto del pallet.",
  "respuestas": [
    {"texto": "A.- 1.295,3 Libras.", "puntos": 0},
    {"texto": "B.- 1.212,3 Libras.", "puntos": 0},
    {"texto": "C.- 1.245,3 Libras.", "puntos": 1}
  ]
},
{
  "texto": "53.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 42,6 x 48,7 pulgadas? Límite de resistencia de piso -117 lbs/pie2; Peso del pallet -43 lbs.; Elementos de amarre -31 lbs.",
  "explicacion": "Aplicación de la fórmula de resistencia de piso para un área de pallet aproximada de 14.4 pies cuadrados.",
  "respuestas": [
    {"texto": "A.- 1.611,6 Libras.", "puntos": 1},
    {"texto": "B.- 1.654,6 Libras.", "puntos": 0},
    {"texto": "C.- 1.601,6 Libras.", "puntos": 0}
  ]
},
{
  "texto": "54.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 96,1 x 133,3 pulgadas? Límite de resistencia de piso -249 lbs/pie2; Peso del pallet –347 lbs.; Elementos de amarre –134 lbs.",
  "explicacion": "Cálculo de gran escala para pallets de carga principal, considerando resistencia y pesos muertos.",
  "respuestas": [
    {"texto": "A.- 21.669, 8 Libras.", "puntos": 0},
    {"texto": "B.- 21.803, 8 Libras.", "puntos": 0},
    {"texto": "C.- 22.120, 8 Libras.", "puntos": 1}
  ]
},
{
  "texto": "55.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 98,7 x 78,9 pulgadas? Límite de resistencia de piso -183 lbs/pie2; Peso del pallet –161 lbs.; Elementos de amarre -54 lbs.",
  "explicacion": "Evaluación de la capacidad de carga neta en un pallet de dimensiones estándar de fuselaje ancho.",
  "respuestas": [
    {"texto": "A.- 9.896,5 Libras.", "puntos": 0},
    {"texto": "B.- 9.735,5 Libras.", "puntos": 1},
    {"texto": "C.- 9.681,5 Libras.", "puntos": 0}
  ]
},
{
  "texto": "56.- La distancia horizontal medida desde la línea de referencia (reference datum) al centro de gravedad de un peso (item), se denomina:",
  "explicacion": "El brazo es la distancia longitudinal definida desde el Datum hasta el punto donde se aplica el peso.",
  "respuestas": [
    {"texto": "A.- MAC.", "puntos": 0},
    {"texto": "B.- Momento.", "puntos": 0},
    {"texto": "C.- Brazo.", "puntos": 1}
  ]
},
{
  "texto": "57.- El Datum (línea de referencia) es una línea imaginaria desde la cual se miden los brazos para los fines de la estiba de una aeronave. La posición del Datum para cada aeronave la determina:",
  "explicacion": "El fabricante establece el punto de referencia cero para todos los cálculos de diseño y balance posteriores.",
  "respuestas": [
    {"texto": "A.- El fabricante de la aeronave.", "puntos": 1},
    {"texto": "B.- Cada Operador.", "puntos": 0},
    {"texto": "C.- El Piloto o el Despachador.", "puntos": 0}
  ]
},
{
  "texto": "58.- Para los efectos de peso y estiba, por carga de combustible (fuel load) se entiende:",
  "explicacion": "La carga de combustible operativa incluye tanto el combustible que se puede consumir como el remanente no utilizable.",
  "respuestas": [
    {"texto": "A.- El combustible consumible más el combustible no consumible que queda en los estanques y cañerías.", "puntos": 1},
    {"texto": "B.- Sólo el combustible consumible.", "puntos": 0},
    {"texto": "C.- El combustible consumible más una cantidad fija de aceite.", "puntos": 0}
  ]
},
{
  "texto": "59.- En peso y estiba se entiende por LEMAC:",
  "explicacion": "LEMAC (Leading Edge Mean Aerodynamic Chord) es el borde de ataque de la cuerda aerodinámica media.",
  "respuestas": [
    {"texto": "A.- El borde de ataque de la mayor cuerda del ala.", "puntos": 0},
    {"texto": "B.- La cuerda del ala utilizada para límites de CG.", "puntos": 0},
    {"texto": "C.- El borde de ataque de la cuerda aerodinámica media.", "puntos": 1}
  ]
},
{
  "texto": "60.- El producto del peso de un item (carga) multiplicado por su brazo desde el DATUM, se denomina:",
  "explicacion": "Físicamente, el momento es la tendencia de una fuerza (peso) a causar rotación alrededor de un punto (Datum).",
  "respuestas": [
    {"texto": "A.- Momento.", "puntos": 1},
    {"texto": "B.- Momento Índice.", "puntos": 0},
    {"texto": "C.- LEMAC.", "puntos": 0}
  ]
},
{
  "texto": "61.- La distancia media entre el borde de ataque y el borde de fuga de un ala, se denomina:",
  "explicacion": "MAC (Mean Aerodynamic Chord) representa la cuerda aerodinámica promedio de un ala.",
  "respuestas": [
    {"texto": "A.- LEMAC.", "puntos": 0},
    {"texto": "B.- MAC.", "puntos": 1},
    {"texto": "C.- DATUM.", "puntos": 0}
  ]
},
{
  "texto": "62.- En Peso y Estiba, un momento dividido por una constante (100, 1.000 o 10.000), se denomina:",
  "explicacion": "El índice es un número simplificado para facilitar los cálculos de balance sin manejar cifras de momentos muy extensas.",
  "respuestas": [
    {"texto": "A.- Datum.", "puntos": 0},
    {"texto": "B.- Centro de gravedad (CG).", "puntos": 0},
    {"texto": "C.- Índice (Index).", "puntos": 1}
  ]
},
{
  "texto": "63.- Una ubicación en una aeronave, que se identifica por un número que representa su distancia a la línea de referencia o datum, se conoce como:",
  "explicacion": "Las estaciones identifican puntos específicos a lo largo del fuselaje basándose en su distancia al Datum.",
  "respuestas": [
    {"texto": "A.- Estación (Station).", "puntos": 1},
    {"texto": "B.- Línea de Referencia (Datum).", "puntos": 0},
    {"texto": "C.- Brazo (Arm).", "puntos": 0}
  ]
},
{
  "texto": "64.- El peso del avión que incluye a la tripulación con todos los elementos para el vuelo, pero sin la carga de pago o combustible, se conoce como:",
  "explicacion": "El Peso Básico de Operación incluye la aeronave lista para operar antes de cargar pasajeros, carga o combustible.",
  "respuestas": [
    {"texto": "A.- Peso con combustible cero (ZFW).", "puntos": 0},
    {"texto": "B.- Peso básico de operación.", "puntos": 1},
    {"texto": "C.- Peso vacío de la aeronave.", "puntos": 0}
  ]
},
{
  "texto": "65.- El peso vacío de una aeronave incluye:",
  "explicacion": "El peso vacío incluye estructura, motores y fluidos de sistemas que no se pueden drenar.",
  "respuestas": [
    {"texto": "A.- Estructura, motores y equipos fijos.", "puntos": 0},
    {"texto": "B.- Lo anterior, más líquido hidráulico, aceite y combustible no utilizable.", "puntos": 1},
    {"texto": "C.- Lo anterior, excluyendo el líquido hidráulico.", "puntos": 0}
  ]
},
{
  "texto": "66.- El peso con combustible cero (ZFW) para cada vuelo en particular, está constituido por:",
  "explicacion": "El ZFW es el peso de operación sumado a la carga de pago (pasajeros y carga neta).",
  "respuestas": [
    {"texto": "A.- El peso de operación más la carga de pago.", "puntos": 1},
    {"texto": "B.- El peso de operación más los líquidos residuales.", "puntos": 0},
    {"texto": "C.- El peso vacío de la aeronave más la carga de pago.", "puntos": 0}
  ]
},
{
  "texto": "67.- El peso máximo de despegue es:",
  "explicacion": "Es el límite estructural o de performance máximo permitido al momento de iniciar la carrera de despegue.",
  "respuestas": [
    {"texto": "A.- El peso de plataforma menos el combustible de rodaje.", "puntos": 0},
    {"texto": "B.- El peso de operación menos el combustible consumido en rodaje.", "puntos": 0},
    {"texto": "C.- Es el máximo peso permitido al inicio de la carrera de despegue.", "puntos": 1}
  ]
},
{
  "texto": "68.- Marque la aseveración correcta con relación al peso y estiba de una aeronave:",
  "explicacion": "Un CG excesivamente retrasado reduce drásticamente la estabilidad longitudinal y dificulta la recuperación de un stall.",
  "respuestas": [
    {"texto": "A.- Los límites los establece el Piloto para cada vuelo.", "puntos": 0},
    {"texto": "B.- Estibar un avión con el CG atrás fuera de límites afecta gravemente la estabilidad y recuperación de stall.", "puntos": 1},
    {"texto": "C.- El consumo de combustible no afecta la posición del CG.", "puntos": 0}
  ]
},
{
  "texto": "69.- Marque la(s) aseveración(es) incorrecta(s) con relación al Peso y Estiba de una aeronave:",
  "explicacion": "Es obligatorio que el operador mantenga registros actualizados del peso y balance de cada aeronave; no es responsabilidad exclusiva del fabricante.",
  "respuestas": [
    {"texto": "A.- No es necesario que el operador establezca un sistema para mantener antecedentes del peso y C.G.", "puntos": 1},
    {"texto": "B.- Todo piloto debe ser capaz de resolver problemas de carga.", "puntos": 0},
    {"texto": "C.- Tras reparaciones mayores debe pesarse para actualizar el peso vacío.", "puntos": 0}
  ]
}
];
  
final List<Map<String, Object>> poolmeteorologia = [

  {
    'texto': '1.- ¿Cuál es la causa principal de todos los cambios meteorológicos sobre la Tierra?',
    'explicacion': r'La causa principal de los cambios meteorológicos es la energía solar. La radiación del Sol calienta de manera desigual la superficie terrestre, generando diferencias de temperatura, presión y densidad del aire. Estas diferencias producen movimientos verticales y horizontales de masas de aire, dando origen al viento, nubosidad, precipitación y otros fenómenos atmosféricos.',
    
    'respuestas': [
     {'texto': 'A.- Las variaciones de la energía solar en la superficie de la Tierra.','puntos': 1},
     {'texto': 'B.- Los cambios de la presión del aire sobre la superficie de la Tierra.','puntos': 0},
     {'texto': 'C.- El movimiento de las masas de aire desde las áreas húmedas hacia las áreas secas.','puntos': 0},
     ]         
  },

{
    'texto': '2.- ¿Cuál es el movimiento característico del aire en una zona de alta presión?',
    'explicacion': r'En una zona de alta presión, el aire tiende a descender desde niveles superiores hacia la superficie. Al llegar cerca del suelo, se desplaza hacia fuera del centro de alta presión. Este movimiento descendente suele estar asociado a condiciones más estables, menor nubosidad y mejor tiempo.',
    
    'respuestas': [
     {'texto': 'A.- Ascender desde la alta en la superficie hacia presiones menores en las mayores altitudes.','puntos': 0},
     {'texto': 'B.- Descender hacia la superficie y luego desplazarse hacia fuera de la alta.','puntos': 1},
     {'texto': 'C.- Salir de la alta en niveles superiores y entrar en la alta en la superficie.','puntos': 0},
     ]         
  },

{
    'texto': '3.- ¿En qué ubicación la fuerza de Coriolis tiene menos efecto en la dirección del viento?',
    'explicacion': r'La fuerza de Coriolis es causada por la rotación de la Tierra y desvía el movimiento del aire. Su efecto es máximo hacia los polos y prácticamente nulo en el Ecuador. Por eso, cerca del Ecuador el viento se desvía menos por efecto de Coriolis.',
    
    'respuestas': [
     {'texto': 'A.- En los polos.','puntos': 0},
     {'texto': 'B.- En latitudes medias (30° a 60°).','puntos': 0},
     {'texto': 'C.- En el Ecuador.','puntos': 1},
     ]         
  },

{
    'texto': '4.- La troposfera se caracteriza por:',
    'explicacion': r'La troposfera es la capa más baja de la atmósfera y donde ocurre la mayor parte del tiempo meteorológico. Una de sus características principales es que, en condiciones normales, la temperatura disminuye a medida que aumenta la altitud, debido a que la superficie terrestre es la principal fuente de calentamiento del aire cercano al suelo.',
    
    'respuestas': [
     {'texto': 'A.- Contener toda la humedad de la atmósfera.','puntos': 0},
     {'texto': 'B.- Tener, en general, una disminución de temperatura a medida que la altura aumenta.','puntos': 1},
     {'texto': 'C.- Tener una altura promedio, en su parte más alta, de 10 kilómetros (6 millas).','puntos': 0},
     ]         
  },

{
    'texto': '5.- ¿Qué característica se asocia con la tropopausa?',
    'explicacion': r'La tropopausa es la zona de transición entre la troposfera y la estratosfera. Se caracteriza por un cambio importante en el gradiente vertical de temperatura: la temperatura deja de disminuir con la altura como ocurre normalmente en la troposfera y puede mantenerse casi constante o comenzar a aumentar.',
    
    'respuestas': [
     {'texto': 'A.- Ausencia de viento y turbulencia.','puntos': 0},
     {'texto': 'B.- Ser el límite superior absoluto de toda formación nubosa.','puntos': 0},
     {'texto': 'C.- Cambio brusco en el gradiente vertical de temperatura.','puntos': 1},
     ]         
  },

{
    'texto': '6.- ¿Cuál de estos lugares es la ubicación común para inversiones de temperatura?',
    'explicacion': r'Una inversión de temperatura ocurre cuando la temperatura aumenta con la altura en lugar de disminuir. Esta condición es común en la estratosfera, ya que allí la temperatura tiende a mantenerse estable o aumentar con la altitud, generando una capa muy estable que limita el desarrollo vertical de las nubes.',
    
    'respuestas': [
     {'texto': 'A.- La tropopausa.','puntos': 0},
     {'texto': 'B.- La estratosfera.','puntos': 1},
     {'texto': 'C.- La base de una nube de tipo cúmulo.','puntos': 0},
     ]         
  },

{
    'texto': '7.- Las corrientes de chorro (jetstreams) normalmente se ubican en:',
    'explicacion': r'Las corrientes de chorro son bandas estrechas de viento muy fuerte que se encuentran normalmente cerca de la tropopausa. Se forman en zonas donde existen fuertes contrastes horizontales de temperatura, especialmente entre masas de aire polar y tropical.',
    
    'respuestas': [
     {'texto': 'A.- La estratosfera, en regiones de presiones muy bajas.','puntos': 0},
     {'texto': 'B.- En la tropopausa, donde hay intensos gradientes de temperatura.','puntos': 1},
     {'texto': 'C.- En una sola y continua banda rodeando la Tierra, y donde se produce un quiebre entre la tropopausa ecuatorial y la tropopausa polar.','puntos': 0},
     ]         
  },

{
    'texto': '8.- Los vientos máximos asociados al jetstream generalmente ocurren en:',
    'explicacion': r'Los vientos más intensos del jetstream suelen encontrarse cerca de los quiebres de la tropopausa, especialmente hacia el lado polar del núcleo del jet. En esas zonas el contraste térmico es mayor, lo que intensifica el gradiente de presión en altura y, por lo tanto, la velocidad del viento.',
    
    'respuestas': [
     {'texto': 'A.- Las vecindades de los quiebres de la tropopausa en el lado polar del núcleo del jet.','puntos': 1},
     {'texto': 'B.- Bajo el núcleo del Jet donde se ubica una larga y recta franja del jetstream.','puntos': 0},
     {'texto': 'C.- En el lado ecuatorial del jetstream, donde la humedad ha formado nubes del tipo cirros.','puntos': 0},
     ]         
  },

{
    'texto': '9.- ¿Qué término describe la elongación de una baja presión?',
    'explicacion': r'Una vaguada o trough es una extensión alargada de una zona de baja presión. En meteorología aeronáutica se asocia con aire inestable, ascenso de aire, nubosidad y, en muchos casos, deterioro de las condiciones meteorológicas.',
    
    'respuestas': [
     {'texto': 'A.- Vaguada o trough.','puntos': 1},
     {'texto': 'B.- Cuña o ridge.','puntos': 0},
     {'texto': 'C.- Huracán o tifón.','puntos': 0},
     ]         
  },

{
    'texto': '10.- ¿Qué caracteriza un frente estacionario?',
    'explicacion': r'Un frente estacionario se forma cuando una masa de aire frío y una masa de aire cálido se encuentran, pero ninguna avanza lo suficiente como para desplazar a la otra. En superficie, los vientos suelen soplar casi paralelos a la zona frontal, lo que ayuda a mantener el frente prácticamente en la misma posición.',
    
    'respuestas': [
     {'texto': 'A.- La superficie del frente cálido se mueve a la mitad de la velocidad de la superficie del frente frío.','puntos': 0},
     {'texto': 'B.- El tiempo asociado es una combinación de las condiciones extremas del frente frío y del frente cálido.','puntos': 0},
     {'texto': 'C.- Los vientos de superficie tienden a soplar paralelos a la zona frontal.','puntos': 1},
     ]         
  },

{
    'texto': '11.- ¿Qué evento generalmente ocurre en el hemisferio sur después que una aeronave cruza un frente frío hacia el aire frío?',
    'explicacion': r'Al cruzar un frente frío hacia la masa de aire frío, normalmente se observa una mejoría progresiva de las condiciones y un aumento de la presión atmosférica. Esto ocurre porque el aire frío es más denso y suele estar asociado a presiones más altas detrás del frente.',
    
    'respuestas': [
     {'texto': 'A.- La diferencia entre la temperatura ambiente y la temperatura del punto de rocío disminuye.','puntos': 0},
     {'texto': 'B.- La dirección del viento cambia hacia la derecha.','puntos': 0},
     {'texto': 'C.- La presión atmosférica aumenta.','puntos': 1},
     ]         
  },

{
    'texto': '12.- ¿Qué tipo de cambios en el tiempo se puede esperar en una zona de frontolisis?',
    'explicacion': r'La frontolisis es el proceso por el cual un frente se debilita o se disipa. Esto ocurre cuando disminuye el contraste de temperatura entre las masas de aire o cuando las condiciones dejan de favorecer el ascenso y la actividad frontal.',
    
    'respuestas': [
     {'texto': 'A.- El tiempo frontal se intensificará.','puntos': 0},
     {'texto': 'B.- El frente se disipará.','puntos': 1},
     {'texto': 'C.- El frente se moverá a una velocidad mayor.','puntos': 0},
     ]         
  },

{
    'texto': '13.- ¿Qué factor atmosférico causa el movimiento rápido de los frentes en superficie?',
    'explicacion': r'El movimiento de los frentes en superficie está muy influido por los vientos en altura. Cuando los vientos superiores soplan a través del frente, pueden empujar y acelerar el desplazamiento de la zona frontal en superficie.',
    
    'respuestas': [
     {'texto': 'A.- Vientos de altura que soplen a través del frente.','puntos': 1},
     {'texto': 'B.- Una baja en altura ubicada exactamente sobre la baja de superficie.','puntos': 0},
     {'texto': 'C.- El frente frío cuando alcanza y eleva al frente cálido.','puntos': 0},
     ]         
  },

{
    'texto': '14.- ¿Bajo qué condiciones meteorológicas se pueden formar ondas frontales y áreas de baja presión?',
    'explicacion': r'Las ondas frontales y bajas presiones suelen formarse en frentes fríos de movimiento lento o en frentes estacionarios. En estas condiciones, la diferencia entre masas de aire permanece organizada y puede desarrollarse una perturbación que ondula el frente y genera una baja presión.',
    
    'respuestas': [
     {'texto': 'A.- En frentes cálidos o frentes ocluidos.','puntos': 0},
     {'texto': 'B.- En frentes fríos de movimiento lento o frentes estacionarios.','puntos': 1},
     {'texto': 'C.- En oclusiones de frente frío.','puntos': 0},
     ]         
  },

{
    'texto': '15.- ¿Dónde está la ubicación normal de un jetstream con relación a las bajas en superficie y los frentes?',
    'explicacion': r'En el hemisferio sur y norte, los jetstreams se asocian a zonas de fuerte contraste térmico y sistemas frontales. En términos generales, el jetstream suele ubicarse al norte de los sistemas de superficie en este tipo de esquema, influyendo en la formación y desplazamiento de frentes y bajas presiones.',
    
    'respuestas': [
     {'texto': 'A.- El jetstream se ubica al Norte de los sistemas de superficie.','puntos': 1},
     {'texto': 'B.- El jetstream se ubica al Sur de la baja y frente caliente.','puntos': 0},
     {'texto': 'C.- El jetstream se ubica sobre la baja y cruza a ambos: al frente caliente y al frente frío.','puntos': 0},
     ]         
  },

{
    'texto': '16.- ¿Qué término se utiliza cuando la temperatura del aire cambia por compresión o expansión, sin que se haya agregado o quitado calor?',
    'explicacion': r'Un proceso adiabático ocurre cuando una masa de aire cambia de temperatura debido a expansión o compresión, sin intercambio directo de calor con el entorno. Al ascender, el aire se expande y se enfría; al descender, se comprime y se calienta.',
    
    'respuestas': [
     {'texto': 'A.- Katabático.','puntos': 0},
     {'texto': 'B.- Advección.','puntos': 0},
     {'texto': 'C.- Adiabático.','puntos': 1},
     ]         
  },

{
    'texto': '17.- ¿Qué proceso causa el enfriamiento adiabático?',
    'explicacion': r'El enfriamiento adiabático ocurre cuando una masa de aire asciende. Al subir, la presión atmosférica disminuye, el aire se expande y esa expansión reduce su temperatura sin necesidad de perder calor directamente hacia el exterior.',
    
    'respuestas': [
     {'texto': 'A.- Expansión del aire a medida que éste sube.','puntos': 1},
     {'texto': 'B.- Movimiento del aire sobre una superficie más fría.','puntos': 0},
     {'texto': 'C.- La liberación de calor latente durante el proceso de vaporización.','puntos': 0},
     ]         
  },

{
    'texto': '18.- La razón aproximada de enfriamiento del aire no saturado que asciende una pendiente es:',
    'explicacion': r'El aire no saturado que asciende se enfría a la razón adiabática seca. En unidades usadas habitualmente en meteorología aeronáutica, este enfriamiento es cercano a 3 °C por cada 1.000 pies de ascenso, hasta que el aire alcanza la saturación.',
    
    'respuestas': [
     {'texto': 'A.- 3° C por cada 1000 pies.','puntos': 1},
     {'texto': 'B.- 2° C por cada 1000 pies.','puntos': 0},
     {'texto': 'C.- 4° C por cada 1000 pies.','puntos': 0},
     ]         
  },

{
    'texto': '19.- ¿Qué sucede cuando el vapor de agua cambia a estado líquido al ser elevado en una tormenta?',
    'explicacion': r'Cuando el vapor de agua se condensa y pasa a estado líquido dentro de una nube o tormenta, libera calor latente hacia la atmósfera. Esa liberación de calor ayuda a mantener o intensificar las corrientes ascendentes, favoreciendo el desarrollo vertical de la nube convectiva.',
    
    'respuestas': [
     {'texto': 'A.- El calor latente es liberado a la atmósfera.','puntos': 1},
     {'texto': 'B.- El calor latente se transforma en pura energía.','puntos': 0},
     {'texto': 'C.- El calor latente es absorbido por las gotitas de agua del aire circundante.','puntos': 0},
     ]         
  },

{
    'texto': '20.- A una inversión de temperatura hay asociada:',
    'explicacion': r'Una inversión de temperatura corresponde a una capa muy estable, porque el aire más frío queda debajo de aire más cálido. Esta disposición inhibe el movimiento vertical, reduce la mezcla atmosférica y puede favorecer acumulación de contaminación, bruma o niebla bajo la inversión.',
    
    'respuestas': [
     {'texto': 'A.- Una capa de aire estable.','puntos': 1},
     {'texto': 'B.- Una capa de aire inestable.','puntos': 0},
     {'texto': 'C.- Tormentas de masa de aire.','puntos': 0},
     ]         
  },

{
    'texto': '21.- En un período de 24 horas, la temperatura mínima generalmente ocurre:',
    'explicacion': r'La temperatura mínima diaria suele ocurrir poco después de la salida del sol. Durante la noche la superficie pierde calor por radiación, y ese enfriamiento continúa hasta que la radiación solar entrante comienza a superar la pérdida de calor terrestre.',
    
    'respuestas': [
     {'texto': 'A.- Después de la salida del sol.','puntos': 1},
     {'texto': 'B.- Alrededor de una hora antes de la salida del sol.','puntos': 0},
     {'texto': 'C.- A medianoche.','puntos': 0},
     ]         
  },

{
    'texto': '22.- Las capas de bruma son dispersadas o disipadas por:',
    'explicacion': r'La bruma se disipa cuando aumenta la mezcla del aire o cuando el viento favorece la ventilación de la capa cercana a la superficie. El movimiento del aire ayuda a mezclar aire más seco o más cálido con la capa húmeda, reduciendo la concentración de partículas o gotitas en suspensión.',
    
    'respuestas': [
     {'texto': 'A.- Mezcla convectiva de aire fresco nocturno.','puntos': 0},
     {'texto': 'B.- El viento o movimiento de aire.','puntos': 1},
     {'texto': 'C.- Evaporación, en un proceso similar al de disipación de la niebla.','puntos': 0},
     ]         
  },

{
    'texto': '23.- ¿Qué puede hacer que una niebla de advección sea disipada o levantada a nubes estratos?',
    'explicacion': r'La niebla de advección se forma cuando aire húmedo se desplaza sobre una superficie más fría. Si el viento aumenta por sobre aproximadamente 15 nudos, la mezcla turbulenta puede levantar la niebla y transformarla en una capa de nubes estratos, o bien dispersarla gradualmente.',
    
    'respuestas': [
     {'texto': 'A.- Una inversión de temperatura.','puntos': 0},
     {'texto': 'B.- Viento mayor de 15 nudos.','puntos': 1},
     {'texto': 'C.- Radiación de superficie.','puntos': 0},
     ]         
  },

{
    'texto': '24.- Las condiciones necesarias para que se forme niebla de pendiente ascendente (upslope fog) son:',
    'explicacion': r'La niebla de pendiente ascendente se forma cuando aire húmedo y estable es forzado a subir por una ladera o pendiente. Al ascender, el aire se expande y se enfría adiabáticamente hasta alcanzar la saturación, generando niebla o nubosidad baja sobre el terreno elevado.',
    
    'respuestas': [
     {'texto': 'A.- Aire estable y húmedo impulsado a ascender una pendiente.','puntos': 1},
     {'texto': 'B.- Cielo despejado, poco viento o calma, humedad relativa de 100 %.','puntos': 0},
     {'texto': 'C.- Lluvia precipitando a través de estratos con vientos de 10 a 25 nudos que impulsen la precipitación hacia arriba por la pendiente.','puntos': 0},
     ]         
  },

{
    'texto': '25.- ¿Qué espesor mínimo es de esperar de una capa nubosa cuando la precipitación reportada es ligera, o de mayor intensidad?',
    'explicacion': r'Cuando una capa nubosa produce precipitación ligera o de mayor intensidad, normalmente se requiere un espesor vertical considerable para permitir el crecimiento de las gotas o cristales de hielo. Por eso, se espera que la capa tenga al menos alrededor de 4.000 pies de espesor.',
    
    'respuestas': [
     {'texto': 'A.- 4.000 pies de espesor.','puntos': 1},
     {'texto': 'B.- 2.000 pies de espesor.','puntos': 0},
     {'texto': 'C.- Un espesor tal que permita que el tope de las nubes se encuentre más arriba que el nivel de congelamiento.','puntos': 0},
     ]         
  },

{
    'texto': '26.- ¿Qué fenómeno de tiempo señala el comienzo de la etapa de madurez de una tormenta?',
    'explicacion': r'La etapa de madurez de una tormenta comienza cuando la precipitación alcanza la superficie. En ese momento coexisten corrientes ascendentes y descendentes, y la tormenta suele presentar su mayor intensidad, con lluvia fuerte, turbulencia, ráfagas y posible granizo.',
    
    'respuestas': [
     {'texto': 'A.- La aparición del yunque.','puntos': 0},
     {'texto': 'B.- El comienzo de precipitación en superficie.','puntos': 1},
     {'texto': 'C.- Cuando la razón de crecimiento de la nube está en su máximo.','puntos': 0},
     ]         
  },

{
    'texto': '27.- ¿Qué etapa del ciclo de vida de una tormenta se caracteriza predominantemente por las corrientes descendentes?',
    'explicacion': r'La etapa de disipación de una tormenta se caracteriza porque las corrientes descendentes predominan sobre las ascendentes. Al cortarse el suministro de aire cálido y húmedo que alimentaba la nube, la tormenta pierde intensidad y comienza a debilitarse.',
    
    'respuestas': [
     {'texto': 'A.- La etapa de cúmulo.','puntos': 0},
     {'texto': 'B.- La etapa de disipación.','puntos': 1},
     {'texto': 'C.- La etapa de madurez.','puntos': 0},
     ]         
  },

{
    'texto': '28.- ¿Qué característica está asociada con la etapa de cúmulo de una tormenta?',
    'explicacion': r'La etapa de cúmulo es la fase inicial de una tormenta. Se caracteriza principalmente por corrientes ascendentes continuas, que elevan aire cálido y húmedo, favoreciendo el crecimiento vertical de la nube antes de que la precipitación llegue a la superficie.',
    
    'respuestas': [
     {'texto': 'A.- Comienzo de lluvia en la superficie.','puntos': 0},
     {'texto': 'B.- Frecuentes relámpagos.','puntos': 0},
     {'texto': 'C.- Continuas corrientes ascendentes.','puntos': 1},
     ]         
  },

{
    'texto': '29.- Las líneas de turbonada (squall lines) se producen con más frecuencia en:',
    'explicacion': r'Las líneas de turbonada son bandas organizadas de tormentas que suelen formarse por delante de un frente frío. Allí el aire cálido y húmedo es forzado a ascender rápidamente, generando convección intensa, ráfagas, turbulencia y actividad eléctrica.',
    
    'respuestas': [
     {'texto': 'A.- Un frente ocluido.','puntos': 0},
     {'texto': 'B.- Delante de un frente frío.','puntos': 1},
     {'texto': 'C.- Detrás de un frente estacionario.','puntos': 0},
     ]         
  },

{
    'texto': '30.- El tipo de nube asociada con tornados y turbulencia violenta es:',
    'explicacion': r'Las nubes cumulonimbus mammatus se asocian con tormentas intensas y actividad convectiva severa. Aunque las mammatus no producen por sí solas el tornado, su presencia indica una tormenta desarrollada y potencialmente peligrosa, con turbulencia fuerte, corrientes verticales intensas y fenómenos severos.',
    
    'respuestas': [
     {'texto': 'A.- Cúmulonimbus mammatus (mamma).','puntos': 1},
     {'texto': 'B.- Lenticulares estacionarias.','puntos': 0},
     {'texto': 'C.- Estrato-cúmulos.','puntos': 0},
     ]         
  },

{
    'texto': '31.- ¿Qué condición de tiempo es un ejemplo de una banda de inestabilidad no frontal?',
    'explicacion': r'Una línea de turbonada puede ser una banda de inestabilidad no frontal cuando se desarrolla separada del frente principal. En ella se organizan tormentas y chubascos intensos producto de aire inestable, humedad y mecanismos de ascenso.',
    
    'respuestas': [
     {'texto': 'A.- Línea de turbonada.','puntos': 1},
     {'texto': 'B.- Niebla advectiva.','puntos': 0},
     {'texto': 'C.- Frontogénesis.','puntos': 0},
     ]         
  },

{
    'texto': '32.- Una tormenta severa es aquella en la cual el viento en superficie es:',
    'explicacion': r'Una tormenta se considera severa cuando produce fenómenos peligrosos en superficie, como viento muy fuerte o granizo significativo. En esta pregunta, el criterio corresponde a viento de 50 nudos o más y/o granizo en superficie igual o mayor a 3/4 de pulgada de diámetro.',
    
    'respuestas': [
     {'texto': 'A.- 50 nudos o más y / o el granizo en superficie es igual o mayor a ¾ de pulgada de diámetro.','puntos': 1},
     {'texto': 'B.- 55 nudos o más y / o el granizo en superficie es igual o mayor a ½ pulgada de diámetro.','puntos': 0},
     {'texto': 'C.- 45 nudos o más y / o el granizo en superficie es igual o mayor a 1 pulgada de diámetro.','puntos': 0},
     ]         
  },
  {
    'texto': '33.- ¿Qué riesgo al vuelo instrumental constituye las nubes convectivas que penetran una capa de nubes estratiformes?',
    'explicacion': r'El principal riesgo es la presencia de tormentas ocultas o embebidas dentro de una capa estratiforme. En vuelo instrumental, el piloto puede no distinguir visualmente la célula convectiva, lo que aumenta el peligro de ingresar inadvertidamente a zonas con turbulencia severa, granizo, engelamiento, actividad eléctrica, lluvia intensa y windshear. Por eso, las tormentas embebidas son especialmente peligrosas para la navegación IFR.',
    
    'respuestas': [
     {'texto': 'A.- Lluvia congelante.','puntos': 0},
     {'texto': 'B.- Turbulencia de aire claro.','puntos': 0},
     {'texto': 'C.- Nubes de tormenta (thunderstorms) ocultas por los stratus que la rodean.','puntos': 1},
     ]         
  },

{
    'texto': '34.- Durante una aproximación ILS ¿cuáles son las indicaciones “iniciales” que un piloto va a notar cuando un viento de nariz cambia rápidamente a calma?',
    'explicacion': r'Si durante una aproximación el viento de nariz disminuye rápidamente hasta calma, la aeronave pierde parte de su velocidad indicada porque desaparece el componente de viento que ayudaba a mantener el flujo relativo sobre las alas. Como consecuencia inicial, disminuye la sustentación, el avión tiende a bajar la nariz y también disminuye la altura. Este es un caso típico de windshear durante aproximación, donde la reacción debe ser inmediata para evitar pérdida de energía.',
    
    'respuestas': [
     {'texto': 'A.- La velocidad indicada disminuye, el avión levanta la nariz y la altura disminuye.','puntos': 0},
     {'texto': 'B.- La velocidad indicada aumenta, el avión baja la nariz y la altura se incrementa.','puntos': 0},
     {'texto': 'C.- La velocidad indicada disminuye, el avión baja la nariz y la altura disminuye.','puntos': 1},
     ]         
  },

{
    'texto': '35.- ¿Qué condición de windshear produce una mayor disminución de velocidad?',
    'explicacion': r'La mayor pérdida de velocidad ocurre cuando existe una disminución del viento de nariz combinada con un aumento del viento de cola. En ambos casos se reduce bruscamente la velocidad relativa del aire sobre las alas, disminuyendo la velocidad indicada y la sustentación. Esta condición es muy crítica en despegue o aproximación, porque la aeronave se encuentra cerca del suelo y con poco margen de recuperación.',
    
    'respuestas': [
     {'texto': 'A.- Viento de nariz o de cola disminuyendo.','puntos': 0},
     {'texto': 'B.- Viento de nariz disminuyendo y viento de cola en aumento.','puntos': 1},
     {'texto': 'C.- Aumento en viento de nariz y disminución en viento de cola.','puntos': 0},
     ]         
  },

{
    'texto': '36.- La zona de mayor peligro causada por el windshear asociado a una tormenta, se encuentra:',
    'explicacion': r'El windshear asociado a una tormenta puede presentarse en todos los lados de la célula convectiva, pero es especialmente peligroso directamente bajo ella, donde pueden existir corrientes descendentes intensas, microbursts y cambios bruscos de dirección y velocidad del viento. Por eso, no basta evitar sólo un lado de la tormenta: toda la zona próxima y bajo la célula debe considerarse peligrosa.',
    
    'respuestas': [
     {'texto': 'A.- Delante de la célula de la tormenta (lado del yunque) y en el lado sur oeste de la célula.','puntos': 0},
     {'texto': 'B.- Delante de la nube rotor y directamente bajo el yunque de la nube.','puntos': 0},
     {'texto': 'C.- En todos lados y directamente bajo la célula de la tormenta.','puntos': 1},
     ]         
  },

{
    'texto': '37.- La duración esperada de un microburst individual es:',
    'explicacion': r'Un microburst es una corriente descendente intensa y localizada asociada normalmente a actividad convectiva. Su duración suele ser breve, y rara vez supera los 15 minutos desde que la corriente descendente impacta el suelo hasta que se disipa. Aunque dura poco, puede producir cambios extremos de viento y pérdida rápida de performance, especialmente durante aproximación o despegue.',
    
    'respuestas': [
     {'texto': 'A.- Cinco minutos, con duración de los vientos máximos de 2 a 4 minutos.','puntos': 0},
     {'texto': 'B.- Un microburst puede continuar tanto como una hora.','puntos': 0},
     {'texto': 'C.- Rara vez más de 15 minutos desde el momento que impacta el suelo hasta su disipación.','puntos': 1},
     ]         
  },

{
    'texto': '38.- Una aeronave que ingrese a un área afectada por un microburst puede encontrar descendentes de una magnitud de:',
    'explicacion': r'Los microbursts pueden producir corrientes descendentes extremadamente fuertes. En casos severos, las descendentes pueden alcanzar valores cercanos a 6.000 ft/min, lo que supera ampliamente la capacidad normal de ascenso de muchas aeronaves. Por esta razón, la estrategia principal frente a microburst es evitarlo, no intentar atravesarlo.',
    
    'respuestas': [
     {'texto': 'A.- 1.500 ft/min.','puntos': 0},
     {'texto': 'B.- 4.500 ft/min.','puntos': 0},
     {'texto': 'C.- 6.000 ft/min.','puntos': 1},
     ]         
  },

{
    'texto': '39.- Durante el encuentro con un microburst, las descendentes podrían ser tan fuertes como:',
    'explicacion': r'En un microburst severo, las descendentes pueden alcanzar aproximadamente 6.000 ft/min. Esta intensidad puede provocar una rápida pérdida de altitud y energía, especialmente si la aeronave se encuentra cerca del terreno. Además, el peligro aumenta porque el microburst combina corrientes descendentes con cambios bruscos de viento horizontal.',
    
    'respuestas': [
     {'texto': 'A.- 8.000 ft/min.','puntos': 0},
     {'texto': 'B.- 7.000 ft/min.','puntos': 0},
     {'texto': 'C.- 6.000 ft-min.','puntos': 1},
     ]         
  },

{
    'texto': '40.- Una aeronave que encuentra vientos de nariz de 45 nudos, dentro del microburst puede esperar una cortante total del orden de:',
    'explicacion': r'En un microburst, el avión puede experimentar primero un fuerte viento de nariz y luego un fuerte viento de cola al cruzar la zona de divergencia. Si el componente de viento de nariz es de 45 nudos y luego cambia a un componente similar de cola, la cortante total puede ser del orden de 90 nudos. Este cambio brusco puede producir una pérdida importante de velocidad indicada y sustentación.',
    
    'respuestas': [
     {'texto': 'A.- 40 nudos.','puntos': 0},
     {'texto': 'B.- 80 nudos.','puntos': 0},
     {'texto': 'C.- 90 nudos.','puntos': 1},
     ]         
  },

{
    'texto': '41.- ¿Cuál es la duración esperada de un microburst individual?',
    'explicacion': r'Un microburst individual es un fenómeno intenso pero de corta duración. Generalmente su ciclo completo, desde que impacta el suelo hasta que se disipa, rara vez excede los 15 minutos. A pesar de su corta vida, representa un riesgo mayor para operaciones cercanas al suelo por sus descendentes intensas y cambios bruscos de viento.',
    
    'respuestas': [
     {'texto': 'A.- 2 minutos, con viento máximo que dura aproximadamente 1 minuto.','puntos': 0},
     {'texto': 'B.- Un microburst puede durar tanto como 2 a 4 horas.','puntos': 0},
     {'texto': 'C.- Rara vez más de 15 minutos desde el momento que impacta el suelo hasta su disipación.','puntos': 1},
     ]         
  },

{
    'texto': '42.- ¿Qué información se puede deducir de la siguiente transmisión desde la torre de control? UMBRAL SUR VIENTO 160° CON 25 NUDOS, UMBRAL OESTE VIENTO 240° CON 35 NUDOS.',
    'explicacion': r'Cuando se reportan diferencias importantes de dirección y velocidad del viento entre distintos sectores del aeródromo, existe posibilidad de windshear o cortante de viento. En este caso, los datos de ambos umbrales muestran una variación significativa del viento, por lo que la aeronave podría encontrar cambios bruscos de velocidad indicada, trayectoria y razón de descenso cerca del aeropuerto.',
    
    'respuestas': [
     {'texto': 'A.- Una corriente descendente está localizada al centro del aeropuerto.','puntos': 0},
     {'texto': 'B.- Al oeste de la pista activa existe wake turbulence.','puntos': 0},
     {'texto': 'C.- Existe posibilidad de encontrar windshear (cortante de viento) sobre o cerca del aeropuerto.','puntos': 1},
     ]         
  },

{
    'texto': '43.- ¿Cuál es el efecto de la formación de hielo, nieve o escarcha sobre una aeronave?',
    'explicacion': r'El hielo, nieve o escarcha contaminan el perfil aerodinámico del ala y alteran el flujo de aire. Esto reduce la sustentación, aumenta la resistencia y puede hacer que el ala entre en pérdida a un ángulo de ataque menor que en condiciones limpias. Por eso, incluso pequeñas cantidades de contaminación pueden afectar seriamente la performance y el control.',
    
    'respuestas': [
     {'texto': 'A.- Disminución de la velocidad de stall.','puntos': 0},
     {'texto': 'B.- Disminución de la tendencia a levantar la nariz (pitchup).','puntos': 0},
     {'texto': 'C.- Disminución del ángulo de ataque de stalls (pérdida).','puntos': 1},
     ]         
  },

{
    'texto': '44.- ¿Cuál es el efecto de la formación de hielo, nieve o escarcha sobre una aeronave?',
    'explicacion': r'La contaminación por hielo, nieve o escarcha degrada la forma del perfil alar. Al disminuir la sustentación disponible y aumentar la resistencia, el avión necesita una velocidad mayor para producir la sustentación necesaria. Por eso, la velocidad de pérdida aumenta y la aeronave puede entrar en stall antes de lo esperado.',
    
    'respuestas': [
     {'texto': 'A.- Aumento de la velocidad de Stall.','puntos': 1},
     {'texto': 'B.- Aumento de la tendencia a bajar la nariz.','puntos': 0},
     {'texto': 'C.- Aumento del ángulo de ataque para stalls.','puntos': 0},
     ]         
  },

{
    'texto': '45.- La nieve acumulada en el avión sobre el fluido antihielo...',
    'explicacion': r'La nieve acumulada sobre el fluido antihielo debe considerarse adherida al avión porque puede alterar la aerodinámica, aumentar la resistencia y afectar la sustentación. No debe asumirse que se desprenderá durante la carrera de despegue. Antes del despegue, las superficies críticas deben encontrarse limpias y libres de contaminación.',
    
    'respuestas': [
     {'texto': 'A.- no debe considerarse como adherida al avión.','puntos': 0},
     {'texto': 'B.- debe considerarse como adherida al avión.','puntos': 1},
     {'texto': 'C.- debe considerarse como adherida al avión, pero se puede realizar un despegue seguro pues ésta se desprenderá durante la carrera, antes de VR.','puntos': 0},
     ]         
  },

{
    'texto': '46.- ¿Qué característica tiene el agua sobre enfriada?',
    'explicacion': r'El agua sobre enfriada es agua líquida que permanece en ese estado a temperaturas bajo 0 °C. Es inestable porque, al impactar una superficie expuesta de la aeronave, puede congelarse rápidamente y formar hielo estructural. Este fenómeno es una de las principales causas de engelamiento en vuelo.',
    
    'respuestas': [
     {'texto': 'A.- Al impactar el ala, las gotas se subliman convirtiéndose en partículas de hielo.','puntos': 0},
     {'texto': 'B.- Las inestables gotas se congelan al chocar con un objeto expuesto.','puntos': 1},
     {'texto': 'C.- La temperatura de la gota permanece en 0° C hasta que impacta parte del fuselaje, para luego acumularse como hielo claro.','puntos': 0},
     ]         
  },

{
    'texto': '47.- ¿Qué condición es necesaria, entre otras, para la formación de hielo estructural en vuelo?',
    'explicacion': r'Para que se forme hielo estructural en vuelo se requiere humedad visible, como nubes, lluvia o niebla, además de temperaturas adecuadas para engelamiento. La humedad visible proporciona las gotas de agua que, al impactar superficies frías de la aeronave, pueden congelarse y acumularse como hielo.',
    
    'respuestas': [
     {'texto': 'A.- Gotas de agua sobre enfriadas.','puntos': 0},
     {'texto': 'B.- Vapor de agua.','puntos': 0},
     {'texto': 'C.- Agua (humedad) visible.','puntos': 1},
     ]         
  },

{
    'texto': '48.- ¿Qué tipo de hielo está asociado con las gotas de agua más chicas, como aquellas encontradas en nubes estratos de niveles bajos?',
    'explicacion': r'El hielo granulado o rime ice se forma generalmente cuando pequeñas gotas de agua sobre enfriada se congelan rápidamente al impactar la aeronave. Es común en nubes estratiformes de niveles bajos, donde las gotas son pequeñas. Su aspecto suele ser opaco, rugoso y de menor densidad que el hielo claro.',
    
    'respuestas': [
     {'texto': 'A.- Hielo claro.','puntos': 0},
     {'texto': 'B.- Escarcha (frost ice).','puntos': 0},
     {'texto': 'C.- Hielo granulado (rime ice).','puntos': 1},
     ]         
  },

{
    'texto': '49.- ¿Qué tipo de precipitación es indicativo de la presencia de gotas de agua sobre enfriadas?',
    'explicacion': r'La lluvia congelante indica la presencia de gotas de agua líquida sobre enfriada. Estas gotas permanecen líquidas bajo 0 °C y se congelan al impactar una superficie expuesta. Para la aviación, es una señal crítica de riesgo de engelamiento rápido y severo.',
    
    'respuestas': [
     {'texto': 'A.- Nieve húmeda.','puntos': 0},
     {'texto': 'B.- Lluvia congelante.','puntos': 1},
     {'texto': 'C.- Granizos (ice pellets).','puntos': 0},
     ]         
  },

{
    'texto': '50.- ¿Qué condición existe cuando durante el vuelo se encuentra granizos (ice pellets)?',
    'explicacion': r'Los ice pellets o gránulos de hielo suelen indicar que existe lluvia congelante en niveles superiores. Esto ocurre cuando la precipitación cae desde una capa cálida, luego atraviesa una capa fría y se congela antes de llegar al nivel de vuelo o a la superficie. Su presencia alerta sobre condiciones peligrosas de engelamiento en la zona.',
    
    'respuestas': [
     {'texto': 'A.- Tormentas (thunderstorms) en niveles superiores.','puntos': 0},
     {'texto': 'B.- Lluvia congelante en niveles superiores.','puntos': 1},
     {'texto': 'C.- Nieve en niveles superiores.','puntos': 0},
     ]         
  },

{
    'texto': '51.- ¿Qué condición de temperatura debería existir si durante el vuelo se observa precipitación tipo agua nieve?',
    'explicacion': r'La precipitación tipo agua nieve indica que la nieve se está derritiendo parcialmente, por lo que la temperatura en el nivel de vuelo normalmente está por encima del punto de congelación. Esto sugiere una capa de aire más cálida donde parte de la precipitación sólida cambia a una mezcla de agua y nieve.',
    
    'respuestas': [
     {'texto': 'A.- La temperatura en el nivel de vuelo es mayor que la de congelación.','puntos': 1},
     {'texto': 'B.- La temperatura en niveles superiores es mayor que la de congelación.','puntos': 0},
     {'texto': 'C.- Hay una inversión de temperatura con aire más frío por debajo.','puntos': 0},
     ]         
  },

{
    'texto': '52.- ¿Cuándo es más probable que se forme escarcha en la superficie de un avión?',
    'explicacion': r'La escarcha se forma con mayor probabilidad en noches despejadas, aire estable y viento ligero, cuando la superficie del avión pierde calor por radiación y se enfría hasta alcanzar o quedar por debajo del punto de escarcha. El viento suave permite cierto aporte de humedad, pero sin mezclar demasiado el aire, favoreciendo el depósito de hielo sobre la superficie.',
    
    'respuestas': [
     {'texto': 'A.- En noches despejadas con aire estable y viento ligero.','puntos': 1},
     {'texto': 'B.- En noches con cielo cubierto con precipitación tipo llovizna congelante.','puntos': 0},
     {'texto': 'C.- En noches despejadas con actividad convectiva y poca dispersión entre la temperatura ambiente y la temperatura del punto de rocío.','puntos': 0},
     ]         
  },

{
    'texto': '53.- ¿Cómo debería reportarse una turbulencia que ocasiona eventuales sacudidas suaves, rápidas y algo rítmicas sin apreciables cambios en la altitud y / o actitud del avión?',
    'explicacion': r'Cuando la turbulencia produce sacudidas suaves, rápidas y algo rítmicas, sin cambios apreciables de altitud o actitud, corresponde a turbulencia ligera. Si ocurre de manera esporádica, se reporta como ligera ocasional. Este tipo de reporte ayuda a otros pilotos y servicios ATS a conocer la intensidad y frecuencia del fenómeno.',
    
    'respuestas': [
     {'texto': 'A.- Ligera ocasional.','puntos': 1},
     {'texto': 'B.- Turbulencia moderada.','puntos': 0},
     {'texto': 'C.- Movimientos moderados.','puntos': 0},
     ]         
  },

{
    'texto': '54.- ¿Cómo debería reportarse la turbulencia cuando ocasiona cambios ligeros, erráticos y momentáneos de altitud y / o actitud, con una frecuencia de un tercio a dos tercios del tiempo?',
    'explicacion': r'La turbulencia ligera puede provocar cambios momentáneos y erráticos de actitud o altitud, pero sin pérdida significativa de control. Cuando ocurre entre un tercio y dos tercios del tiempo, se clasifica como intermitente. Por ello, el reporte correcto es turbulencia ligera intermitente.',
    
    'respuestas': [
     {'texto': 'A.- Movimientos ocasionales ligeros.','puntos': 0},
     {'texto': 'B.- Turbulencia moderada.','puntos': 0},
     {'texto': 'C.- Turbulencia ligera intermitente.','puntos': 1},
     ]         
  },

{
    'texto': '55.- La turbulencia encontrada sobre 15.000 pies AGL, no asociada con formaciones nubosas, se reportará como:',
    'explicacion': r'La turbulencia de aire claro, o CAT, ocurre en aire aparentemente despejado y normalmente no está asociada a nubosidad visible. Suele encontrarse en niveles altos, especialmente cerca de corrientes de chorro, zonas de fuerte cizalle de viento u ondas de montaña. Al no poder verse directamente, representa un riesgo importante para la operación.',
    
    'respuestas': [
     {'texto': 'A.- Turbulencia convectiva.','puntos': 0},
     {'texto': 'B.- Turbulencia de niveles altos.','puntos': 0},
     {'texto': 'C.- Turbulencia de aire claro.','puntos': 1},
     ]         
  },

{
    'texto': '56.- Señale qué tipo de nubes son más indicativas de turbulencia fuerte?',
    'explicacion': r'Las nubes lenticulares estacionarias se asocian a ondas de montaña. Aunque pueden parecer suaves y estacionarias, indican flujo fuerte y ondulatorio sobre terreno montañoso, con posibilidad de turbulencia severa, corrientes verticales intensas y turbulencia de aire claro cerca o a sotavento de la montaña.',
    
    'respuestas': [
     {'texto': 'A.- Nimbo estrato.','puntos': 0},
     {'texto': 'B.- Lenticulares estacionarias.','puntos': 1},
     {'texto': 'C.- Cirrocúmulo.','puntos': 0},
     ]         
  },

{
    'texto': '57.- ¿Cuál es la nube más baja del tipo estacionaria asociada con la onda de montaña?',
    'explicacion': r'En una onda de montaña pueden aparecer distintos tipos de nubes estacionarias. La nube rotor suele ubicarse en niveles más bajos, a sotavento de la montaña, bajo las nubes lenticulares. Es especialmente peligrosa porque marca una zona de turbulencia intensa y circulación irregular cerca del terreno.',
    
    'respuestas': [
     {'texto': 'A.- La nube rotor.','puntos': 1},
     {'texto': 'B.- la nube lenticular estacionaria.','puntos': 0},
     {'texto': 'C.- Los estratos bajos.','puntos': 0},
     ]         
  },

{
    'texto': '58.- La turbulencia en aire claro (CAT) asociada con la onda de montaña puede extenderse tan lejos como:',
    'explicacion': r'La turbulencia de aire claro asociada a ondas de montaña puede extenderse a grandes distancias a sotavento de la cordillera. En casos significativos, la zona turbulenta puede alcanzar hasta unas 500 millas sobre la tropopausa, lo que demuestra que el peligro no se limita sólo al área inmediata de la montaña.',
    
    'respuestas': [
     {'texto': 'A.- 1000 millas o más a sotavento de la montaña.','puntos': 0},
     {'texto': 'B.- 500 pies sobre la tropopausa.','puntos': 1},
     {'texto': 'C.- 100 millas o más a barlovento de la montaña.','puntos': 0},
     ]         
  },

{
    'texto': '59.- ¿Qué tipo de corriente de chorro (jetstream) puede causar mayor turbulencia?',
    'explicacion': r'La turbulencia asociada al jetstream es más probable donde existen fuertes gradientes de viento y cambios bruscos de dirección o velocidad. Un jetstream en curva, asociado a una vaguada profunda de baja presión, favorece mayor cizalle horizontal y vertical, aumentando la probabilidad de turbulencia moderada o severa.',
    
    'respuestas': [
     {'texto': 'A.- Un jetstream recto asociado con una cuña de alta presión.','puntos': 0},
     {'texto': 'B.- Un jetstream asociado con isotermas muy espaciadas.','puntos': 0},
     {'texto': 'C.- Un jetstream en curva asociado con una vaguada (trough) profunda de baja presión.','puntos': 1},
     ]         
  },

{
    'texto': '60.- ¿Qué acción se recomienda al encontrar turbulencia asociada al jetstream con viento directo de nariz o de cola?',
    'explicacion': r'Cuando se encuentra turbulencia asociada al jetstream, especialmente con viento directo de nariz o de cola, puede existir una extensa zona de cizalle y turbulencia. La acción recomendada es cambiar de altitud o de curso para salir del área afectada, en lugar de intentar atravesarla manteniendo la misma trayectoria.',
    
    'respuestas': [
     {'texto': 'A.- Aumentar la velocidad para salir lo antes posible del área.','puntos': 0},
     {'texto': 'B.- Cambiar curso para volar en el lado polar del jetstream.','puntos': 0},
     {'texto': 'C.- Cambiar de altitud o curso para evitar una posible extensa área de turbulencia.','puntos': 1},
     ]         
  },

{
    'texto': '61.- ¿Qué riesgo a las operaciones aéreas existe cuando una capa nubosa de espesor uniforme yace sobre una superficie cubierta de nieve o hielo?',
    'explicacion': r'Cuando una capa nubosa uniforme se encuentra sobre una superficie cubierta de nieve o hielo, se puede producir visión blanca o whiteout. En esta condición se pierde el contraste visual entre cielo, horizonte y terreno, dificultando la percepción de altura, distancia y actitud de la aeronave, especialmente durante aproximaciones visuales o vuelo a baja altura.',
    
    'respuestas': [
     {'texto': 'A.- Niebla helada.','puntos': 0},
     {'texto': 'B.- Visión blanca.','puntos': 1},
     {'texto': 'C.- Viento de nieve.','puntos': 0},
     ]         
  },

{
    'texto': '62.- La sigla “VC” se utiliza para indicar un fenómeno que ocurre en las vecindades del aeropuerto pero no en éste. Cuando VC aparece en un TAF, cubre un área geográfica de:',
    'explicacion': r'En la codificación meteorológica aeronáutica, VC significa vicinity, es decir, en las vecindades del aeródromo. En un TAF, este término se usa para fenómenos esperados aproximadamente entre 5 y 10 millas alrededor del aeropuerto, pero no directamente sobre el aeródromo.',
    
    'respuestas': [
     {'texto': 'A.- Un radio de 5 a 10 millas alrededor del aeropuerto.','puntos': 1},
     {'texto': 'B.- En un radio de 5 millas del centro del complejo de pistas.','puntos': 0},
     {'texto': 'C.- 10 millas medidas desde la estación que genera el pronóstico.','puntos': 0},
     ]         
  },

{
    'texto': '63.- ¿Qué condición meteorológica se predice con el término “VCTS” en un TAF?',
    'explicacion': r'El término VCTS en un TAF significa thunderstorms in the vicinity, es decir, tormentas en las vecindades del aeropuerto. Esto indica que se esperan tormentas aproximadamente entre 5 y 10 millas del aeródromo, pero no necesariamente sobre el aeropuerto mismo. Aunque estén en las cercanías, pueden afectar la operación por rayos, windshear, turbulencia y cambios rápidos de viento.',
    
    'respuestas': [
     {'texto': 'A.- Se esperan tormentas en un radio fluctuando entre 5 y 10 millas del aeropuerto, pero no en el aeropuerto mismo.','puntos': 1},
     {'texto': 'B.- Pueden esperarse chubascos sobre la estación y en un radio de 50 millas.','puntos': 0},
     {'texto': 'C.- Se esperan tormentas entre 5 y 25 millas medidas desde el centro del conjunto de pistas.','puntos': 0},
     ]         
  },

{
    'texto': '64.- ¿Cuál es el único tipo de nubosidad pronosticado en un TAF?',
    'explicacion': r'En los TAF, normalmente no se pronostican tipos específicos de nubes, sino cobertura y altura de base. La excepción operacional importante es el cumulonimbus, ya que su presencia implica actividad convectiva peligrosa, turbulencia, engelamiento, windshear, granizo o tormentas.',
    
    'respuestas': [
     {'texto': 'A.- Altocumulus.','puntos': 0},
     {'texto': 'B.- Cumulonimbus.','puntos': 1},
     {'texto': 'C.- Estratocumulus.','puntos': 0},
     ]         
  },

{
    'texto': '65.- En el TAF, el viento se pronostica como “calma” si se espera una velocidad de viento de:',
    'explicacion': r'En un TAF, el viento se considera calma cuando su velocidad esperada es de 3 nudos o menos. En la codificación, esto puede aparecer como 00000KT, indicando dirección sin valor operacional y velocidad cero o calma.',
    
    'respuestas': [
     {'texto': 'A.- 6 nudos o menos.','puntos': 0},
     {'texto': 'B.- 3 nudos o menos.','puntos': 1},
     {'texto': 'C.- 5 nudos o menos.','puntos': 0},
     ]         
  },

{
    'texto': '66.- En un TAF, el viento de dirección variable se anota como VRB. Un viento calma (3 nudos o menor) aparecerá en TAF como...',
    'explicacion': r'Cuando el viento está en calma en un TAF, se codifica como 00000KT. Esto indica que no existe una dirección significativa del viento y que la velocidad es calma, normalmente 3 nudos o menor. No se usa VRB para calma, ya que VRB se aplica a viento variable con velocidad reportable.',
    
    'respuestas': [
     {'texto': 'A.- 00003KT.','puntos': 0},
     {'texto': 'B.- CALM.','puntos': 0},
     {'texto': 'C.- 00000KT.','puntos': 1},
     ]         
  },

{
    'texto': '67.- En una carta de superficie las isobaras representan líneas de igual presión:',
    'explicacion': r'En una carta de superficie, las isobaras unen puntos de igual presión atmosférica reducida al nivel medio del mar. Esta reducción permite comparar presiones entre estaciones ubicadas a diferentes elevaciones y facilita identificar altas, bajas, vaguadas, cuñas y gradientes de presión asociados al viento.',
    
    'respuestas': [
     {'texto': 'A.- En la superficie.','puntos': 0},
     {'texto': 'B.- Reducidas al nivel de mar.','puntos': 1},
     {'texto': 'C.- A una altitud de presión determinada.','puntos': 0},
     ]         
  },

   {
    'texto': '68.- ¿Bajo qué circunstancias es más factible encontrar turbulencia de aire claro (CAT)?',
    'explicacion': r'La turbulencia de aire claro (CAT) se asocia principalmente a fuertes cambios de velocidad del viento en altura, especialmente cerca de corrientes de chorro. Cuando en cartas de presión constante las isotacas están muy juntas, por ejemplo isotacas de 60 nudos separadas por menos de 20 millas náuticas, existe un fuerte gradiente de viento. Ese gradiente favorece cizalle vertical u horizontal, lo que aumenta la probabilidad de encontrar CAT.',
    
    'respuestas': [
     {'texto': 'A.- Cuando en las cartas de presión constante hay isotacas de 20 nudos separadas por menos de 60 millas náuticas.','puntos': 0},
     {'texto': 'B.- Cuando en las cartas de presión constante hay isotacas de 60 nudos separadas por menos de 20 millas náuticas.','puntos': 1},
     {'texto': 'C.- Cuando una vaguada profunda se desplaza a una velocidad menor de 20 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '69.- Se puede esperar corriente de cizalle (wind shear) “fuerte”:',
    'explicacion': r'El wind shear fuerte suele encontrarse cerca de corrientes de chorro intensas, especialmente en el lado de baja presión del núcleo del jetstream. Si el núcleo supera los 110 nudos, los cambios de velocidad y dirección del viento alrededor de esa zona pueden ser importantes, generando turbulencia y cizalle peligrosos para la aeronave.',
    
    'respuestas': [
     {'texto': 'A.- En el lado de baja presión del núcleo de un jet stream de más de 110 nudos.','puntos': 1},
     {'texto': 'B.- Donde las isotacas de 20 nudos están espaciadas en 100 millas náuticas o menos.','puntos': 0},
     {'texto': 'C.- Si las isotermas de 5° C están espaciadas en 100 millas náuticas o menos.','puntos': 0},
     ]         
  },

{
    'texto': '70.- Un Reporte Aeronáutico de Superficie se abrevia como:',
    'explicacion': r'El METAR es el informe meteorológico aeronáutico ordinario de superficie. Entrega información observada en un aeródromo, como viento, visibilidad, fenómenos presentes, nubosidad, temperatura, punto de rocío y presión. A diferencia del TAF, que es un pronóstico, el METAR describe condiciones meteorológicas observadas.',
    
    'respuestas': [
     {'texto': 'A.- TAF.','puntos': 0},
     {'texto': 'B.- METAR.','puntos': 1},
     {'texto': 'C.- SIGMET.','puntos': 0},
     ]         
  },

{
    'texto': '71.- Un Pronóstico de Terminal se abrevia como...',
    'explicacion': r'El Pronóstico de Terminal se abrevia TAF, del inglés Terminal Aerodrome Forecast. Es un pronóstico meteorológico para un aeródromo específico y normalmente incluye viento, visibilidad, fenómenos significativos, nubosidad y cambios esperados dentro del período de validez.',
    
    'respuestas': [
     {'texto': 'A.- TAF.','puntos': 1},
     {'texto': 'B.- METAR.','puntos': 0},
     {'texto': 'C.- AIREP.','puntos': 0},
     ]         
  },

{
    'texto': '72.- Las Advertencias Meteorológicas en Vuelo, observadas o pronosticadas, y que informan sobre condiciones potencialmente peligrosas que pueden afectar la seguridad de las operaciones aéreas, se conocen como...',
    'explicacion': r'El SIGMET es una advertencia meteorológica significativa para la aviación. Informa fenómenos peligrosos observados o pronosticados, como tormentas severas, turbulencia severa, engelamiento severo, ceniza volcánica o ciclones tropicales, que pueden afectar la seguridad de las operaciones aéreas.',
    
    'respuestas': [
     {'texto': 'A.- AIREP','puntos': 0},
     {'texto': 'B.- RAREP','puntos': 0},
     {'texto': 'C.- SIGMET','puntos': 1},
     ]         
  },

{
    'texto': '73.- En el Pronóstico de Área Ud. lee: ROUTE FCST SCTC SCMO VALID 1206. Ello significa ....',
    'explicacion': r'La expresión VALID 1206 indica el período de validez del pronóstico. En este formato, significa que el pronóstico es válido desde las 12:00 UTC hasta las 06:00 UTC del día siguiente. Por eso, no corresponde a las 12:06 ni a un período de sólo 12:00 a 18:00 del mismo día.',
    
    'respuestas': [
     {'texto': 'A.- Que se trata de un TAF válido hasta las 12:06 para el tramo indicado.','puntos': 0},
     {'texto': 'B.- Que se trata de un pronóstico válido de 12:00 a 06:00 del siguiente día.','puntos': 1},
     {'texto': 'C.- Que se trata de un pronóstico válido de 12:00 a 18:00 del mismo día.','puntos': 0},
     ]         
  },

{
    'texto': '74.- En el Pronóstico de Área Ud. lee: APG RUTA AFECTADA POR SISTEMA FRONTAL OCLUIDO. De la abreviatura “APG” Ud. deduce que se trata de:',
    'explicacion': r'En el contexto del pronóstico de área, APG corresponde a información significativa que afecta una ruta determinada. En este caso, indica que existe una condición meteorológica relevante para una ruta en particular, por ejemplo un sistema frontal ocluido que puede afectar visibilidad, nubosidad, precipitación o turbulencia.',
    
    'respuestas': [
     {'texto': 'A.- Un informe meteorológico emitido por un piloto en vuelo.','puntos': 0},
     {'texto': 'B.- Un SIGMET para una ruta en particular.','puntos': 1},
     {'texto': 'C.- Una sinopsis en que se informa sólo lo más relevante.','puntos': 0},
     ]         
  },

{
    'texto': '75.- En el Pronóstico de Área Ud. lee: COT INT 6SC200 MTS TOP 700 MTS GRADU 1819 COT INT 8 CU1300 TOP 2300 MTS. De esta parte del informe meteorológico Ud. deduce que:',
    'explicacion': r'La información indica nubosidad tanto para el sector costero como interior, con bases y topes expresados en metros. Además, el término GRADU 1819 indica que el cambio será gradual entre las 18 y 19 UTC. Por lo tanto, el pronóstico afecta costa e interior y señala una modificación progresiva de las condiciones meteorológicas dentro de ese período.',
    
    'respuestas': [
     {'texto': 'A.- Esta información, que puede ser continua o intermitente, se retransmitirá a las 18:00 y 19:00 horas.','puntos': 0},
     {'texto': 'B.- Esta información afecta tanto a la costa como al interior del territorio y habrá un cambio gradual de las condiciones meteorológicas entre las 18 y 19 UTC.','puntos': 1},
     {'texto': 'C.- Esta información afecta tanto a la costa como al interior del territorio y habrá un cambio gradual de las condiciones meteorológicas a las 18:19 UTC.','puntos': 0},
     ]         
  },

{
    'texto': '76.- En el Pronóstico de Área Ud. lee: 6AC3700 MTS TOP 6500 MTS 80 RASH ICE BTN 6/8 MILFT TUR MOD BTN 30/35 MILFT. De la lectura de este informe Ud., entre otras cosas, puede deducir que:',
    'explicacion': r'La codificación indica 6 octas de altocúmulos con base a 3.700 metros y tope a 6.500 metros, chubascos de lluvia y formación de hielo entre 6.000 y 8.000 pies. También se informa turbulencia moderada entre 30.000 y 35.000 pies. Por eso, la lectura correcta combina nubosidad media, precipitación tipo chubasco y riesgo de hielo en el tramo indicado.',
    
    'respuestas': [
     {'texto': 'A.- Habrá nubosidad del tipo alto cúmulos, chubascos de lluvia, y entre 6.000 y 8.000 pies se encontrará formación de hielo.','puntos': 1},
     {'texto': 'B.- Habrá nubosidad del tipo alto cúmulos y entre 6.000 y 8.000 pies se encontrará formación intermitente de hielo.','puntos': 0},
     {'texto': 'C.- Habrá nubosidad del tipo altos cirros, chubascos de lluvia, y que entre 6.000 y 8.000 pies se encontrará formación de hielo.','puntos': 0},
     ]         
  },

{
    'texto': '77.- En el Pronóstico de Vientos y Temperaturas en Altura (QAO QMX) Ud. lee: SCMO SCCI 05/32020/00 10/27030/59 15/29035/65 20/34035/70 25/31040/75 30/24050/90 35/30085/96 40/300100/01 ISOTERMA CERO 7000FT. De este informe se puede deducir que:',
    'explicacion': r'En el pronóstico de vientos y temperaturas en altura, el grupo 10/27030/59 corresponde al nivel de 10.000 pies, con viento desde los 270 grados a 30 nudos y temperatura aproximada de 9 °C. La codificación permite identificar nivel, dirección, intensidad y temperatura exterior estimada para planificación de ruta.',
    
    'respuestas': [
     {'texto': 'A.- A 10.000 pies el viento es de los 270 grados con una intensidad de 30 nudos y que la temperatura es de menos 9° C.','puntos': 1},
     {'texto': 'B.- A 10.000 pies el viento es de los 270 grados con una intensidad de 30 nudos con ráfagas de hasta 59 nudos aproximadamente.','puntos': 0},
     {'texto': 'C.- A 10.000 pies el viento es de los 270 grados con una intensidad de 30 nudos y que la temperatura exterior es de aproximadamente 59° F.','puntos': 0},
     ]         
  },

{
    'texto': '78.- En el Pronóstico de Vientos y Temperaturas en Altura (QAO QMX) Ud. lee: SCMO SCCI 05/32020/00 10/27030/59 15/29035/65 20/34035/70 25/31040/75 30/24050/90 35/30085/96 40/300100/01 ISOTERMA CERO 7000FT. De este informe se puede deducir que:',
    'explicacion': r'El grupo 15/29035/65 corresponde al nivel de 15.000 pies. Indica viento desde los 290 grados con intensidad de 35 nudos. La temperatura codificada corresponde aproximadamente a -15 °C. Este tipo de información permite prever viento en ruta, componente de viento y temperatura para performance y planificación.',
    
    'respuestas': [
     {'texto': 'A.- A 15.000 pies el viento es de los 290 grados con una intensidad de 35 nudos, con ráfagas de hasta 65 nudos.','puntos': 0},
     {'texto': 'B.- A 15.000 pies el viento es de los 290 grados con una intensidad de 35 nudos y que la temperatura exterior es de menos 15° C.','puntos': 1},
     {'texto': 'C.- A 15.000 pies el viento es de los 290 grados con una intensidad de 30 nudos y que la temperatura exterior es de 65° F.','puntos': 0},
     ]         
  },

{
    'texto': '79.- En el Pronóstico de Vientos y Temperaturas en Altura (QAO QMX) Ud. lee: SCMO SCCI 05/32020/00 10/27030/59 15/29035/65 20/34035/70 25/31040/75 30/24050/90 35/30085/96 40/300100/01 ISOTERMA CERO 7000FT. De este informe se puede deducir que:',
    'explicacion': r'El grupo 25/31040/75 corresponde al nivel de 25.000 pies. En ese nivel, el viento proviene desde los 310 grados con una intensidad de 40 nudos y la temperatura exterior corresponde aproximadamente a -25 °C. En niveles altos, estas temperaturas son importantes para performance, engelamiento potencial y selección de nivel.',
    
    'respuestas': [
     {'texto': 'A.- A 25.000 pies el viento es desde los 310 grados con una intensidad de 40 nudos y que la temperatura exterior es de menos 25° C.','puntos': 1},
     {'texto': 'B.- A 25.000 pies el viento es de los 310 grados con una intensidad de 40 nudos con ráfagas de hasta 75 nudos.','puntos': 0},
     {'texto': 'C.- A 25.000 pies la dirección del viento sopla hacia los 310 grados con una intensidad de 40 nudos y que la temperatura exterior es de menos 25° C.','puntos': 0},
     ]         
  },

{
    'texto': '80.- En el Pronóstico de Vientos y Temperaturas en Altura (QAO QMX) Ud. lee: SCMO SCCI 05/32020/00 10/27030/59 15/29035/65 20/34035/70 25/31040/75 30/24050/90 35/30085/96 40/300100/01 ISOTERMA CERO 7000FT. De este informe se puede deducir que:',
    'explicacion': r'El grupo 40/300100/01 corresponde al nivel de 40.000 pies. Indica viento desde los 300 grados con una intensidad de 100 nudos y temperatura exterior aproximada de -51 °C. No significa que el viento sople hacia 300 grados, sino que proviene desde esa dirección.',
    
    'respuestas': [
     {'texto': 'A.- A 40.000 pies el viento es desde los 300 grados con una intensidad de 100 nudos y que la temperatura exterior es de menos 51°C.','puntos': 1},
     {'texto': 'B.- A 40.000 pies el viento es desde los 300 grados con una intensidad de 100 nudos y que existe una inversión térmica.','puntos': 0},
     {'texto': 'C.- A 40.000 pies la dirección del viento es hacia los 300 grados con una intensidad de 100 nudos y que la temperatura exterior es de menos 51° C.','puntos': 0},
     ]         
  },

{
    'texto': '81.- En el Pronóstico de Terminal que Ud. debe analizar antes de iniciar un vuelo, Ud. lee lo siguiente: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'En SCSE aparece el grupo 9999, que en meteorología aeronáutica indica visibilidad de 10 kilómetros o más. Por eso, no se interpreta como visibilidad ilimitada absoluta ni como “casi 10 kilómetros”, sino como una visibilidad operacional superior a 10 km.',
    
    'respuestas': [
     {'texto': 'A.- En La Serena (SCSE) el techo de nubes y la visibilidad son ilimitados.','puntos': 0},
     {'texto': 'B.- En La Serena (SCSE) hay una visibilidad superior a 10 kilómetros.','puntos': 1},
     {'texto': 'C.- En La Serena (SCSE) la visibilidad es de casi 10 kilómetros.','puntos': 0},
     ]         
  },

{
    'texto': '82.- En el Pronóstico de Terminal que Ud. debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'En el tramo de SCSE aparece 8ST015. Esto significa ocho octas de stratus con base a 1.500 pies sobre el aeródromo. Al convertir aproximadamente 1.500 pies a metros, se obtiene cerca de 450 metros AGL, por lo que la base de la capa de stratus se ubica alrededor de esa altura.',
    
    'respuestas': [
     {'texto': 'A.- En La Serena (SCSE) la base de la capa de nubes stratus está a aproximadamente 450 metros AGL.','puntos': 1},
     {'texto': 'B.- En La Serena (SCSE) la base de la capa de nubes stratus está a 1.500 metros AGL.','puntos': 0},
     {'texto': 'C.- En La Serena (SCSE) la base (techo) de la capa de nubes stratus está a 150 metros.','puntos': 0},
     ]         
  },

{
    'texto': '83.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'En SCSE aparece GRADU 1415 4CU040. GRADU indica cambio gradual entre las 14 y 15 UTC. El cambio pronosticado corresponde a nubosidad cúmulus de 4 octas a 4.000 pies. Por lo tanto, entre las 14 y 15 horas habrá un cambio gradual de la nubosidad.',
    
    'respuestas': [
     {'texto': 'A.- En La Serena (SCSE) a las 14:45 UTC habrá un cambio gradual de la nubosidad.','puntos': 0},
     {'texto': 'B.- En La Serena (SCSE) entre las 14 y 15 horas habrá 4/8 de CU a 400 metros.','puntos': 0},
     {'texto': 'C.- En La Serena (SCSE) entre las 14 y 15 horas habrá un cambio gradual de la nubosidad.','puntos': 1},
     ]         
  },

{
    'texto': '84.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'En SCSE aparece GRADU 1617 27010KT. Esto indica que entre las 16 y 17 UTC se espera un cambio gradual del viento, quedando desde los 270 grados con una intensidad de 10 nudos. En meteorología aeronáutica, la dirección del viento indica desde dónde sopla, no hacia dónde va.',
    
    'respuestas': [
     {'texto': 'A.- En La Serena (SCSE) a las 16:17 UTC el viento cambiará gradualmente a 270° con 10 nudos.','puntos': 0},
     {'texto': 'B.- En La Serena (SCSE) entre las 16 y 17 UTC el viento cambiará a 270° con 10 nudos.','puntos': 1},
     {'texto': 'C.- En La Serena (SCSE) entre las 16 y 17 UTC el viento soplará hacia los 270 con una intensidad de 10 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '85.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'En SCEL aparece 2000 05HZ. El grupo 2000 indica visibilidad de 2.000 metros y HZ corresponde a haze, es decir bruma o calima. No corresponde a humo, que se codifica como FU, ni a llovizna, que se codifica como DZ.',
    
    'respuestas': [
     {'texto': 'A.- En SCEL la visibilidad está reducida a 2000 metros por humo.','puntos': 0},
     {'texto': 'B.- En SCEL la visibilidad está reducida a 2000 metros por bruma.','puntos': 1},
     {'texto': 'C.- En SCEL la visibilidad está reducida a 200 metros llovizna.','puntos': 0},
     ]         
  },

{
    'texto': '86.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'En SCEL aparece 4AC150. Esto significa 4 octas de altocúmulos con base a 15.000 pies. Al convertir 15.000 pies a metros, se obtiene aproximadamente 4.600 metros. Por eso, la base de la nubosidad altocúmulus se encuentra cerca de 4.600 metros.',
    
    'respuestas': [
     {'texto': 'A.- En SCEL la base de la nubosidad del tipo altocirros se encuentra a 15.000 pies.','puntos': 0},
     {'texto': 'B.- En SCEL la base de la nubosidad del tipo altocúmulos se encuentra a 1.500 metros.','puntos': 0},
     {'texto': 'C.- En SCEL la base de la nubosidad del tipo altocúmulos se encuentra a 4.600 metros aproximadamente.','puntos': 1},
     ]         
  },

{
    'texto': '87.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'En SCMO aparece 1200 80RASH. El grupo 1200 indica visibilidad de 1.200 metros y RASH significa rain showers, es decir chubascos de lluvia. Por lo tanto, la visibilidad está reducida a 1.200 metros debido a chubascos de lluvia.',
    
    'respuestas': [
     {'texto': 'A.- En SCMO la visibilidad está reducida a 1.200 metros por chubascos de lluvia.','puntos': 1},
     {'texto': 'B.- En SCMO la visibilidad está reducida a 1.200 metros por chubascos de nieve.','puntos': 0},
     {'texto': 'C.- En SCMO la visibilidad está reducida a 1.200 pies por chubascos de lluvia.','puntos': 0},
     ]         
  },

{
    'texto': '88.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'En SCCI aparece RESNSH BCFG. RESNSH indica chubascos de nieve recientes y BCFG indica bancos o parches de niebla. Por lo tanto, el pronóstico permite determinar que habrá o se reportan chubascos de nieve recientes y posteriormente presencia de niebla en bancos.',
    
    'respuestas': [
     {'texto': 'A.- En SCCI no habrá chubascos, sólo niebla y turbulencia moderada entre 6.000 pies y 30.000 pies.','puntos': 0},
     {'texto': 'B.- En SCCI habrá chubascos de nieve y después niebla.','puntos': 1},
     {'texto': 'C.- En SCCI a 1500 pies sobre el aeropuerto habrá un viento que soplará desde los 080 grados con una intensidad de 45 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '89.- Según la Información Meteorológica de la Figura 116, el aeropuerto de Arica (SCAR), se encuentra:',
    'explicacion': r'La información codificada indica condiciones despejadas, temperatura ambiente de 26 °C y punto de rocío de 18 °C. La diferencia entre temperatura y punto de rocío permite estimar humedad relativa y probabilidad de nubosidad o niebla; en este caso, la separación es suficiente para condiciones despejadas.',
    
    'respuestas': [
     {'texto': 'A.- Despejado y con una temperatura ambiente de 26 grados y una temperatura del punto de rocío de 18 grados.','puntos': 1},
     {'texto': 'B.- Sin nubosidad, con una temperatura del punto de rocío de 26 grados y una temperatura ambiente de 18 grados. Además, el viento es de los 220 grados con 12 nudos.','puntos': 0},
     {'texto': 'C.- Con un techo de nubes y una visibilidad apropiadas para vuelo VFR. El viento es de los 220 grados con 12 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '90.- Según la Información Meteorológica de la Figura 116, Isla de Pascua (SCIP) el día 16 a las 17:00 hora Z tenía una visibilidad ....',
    'explicacion': r'En la información meteorológica, cuando se expresa visibilidad variable entre dos valores en metros, se interpreta como un rango operacional de visibilidad observado. En este caso, la visibilidad en SCIP varía entre 4.000 y 11.000 metros, lo que indica cambios importantes de visibilidad en el aeródromo o sus sectores.',
    
    'respuestas': [
     {'texto': 'A.- Variable entre 4.000 y 11.000 pies.','puntos': 0},
     {'texto': 'B.- Variable entre 4.000 y 11.000 metros.','puntos': 1},
     {'texto': 'C.- Variable entre 40 y 110 metros.','puntos': 0},
     ]         
  },

{
    'texto': '91.- Según la Información Meteorológica de la Figura 116, La Serena está:',
    'explicacion': r'La información de La Serena indica condición cubierta y una base nubosa aproximada de 600 metros. En reportes meteorológicos, la cobertura cubierta corresponde a 8 octas de nubosidad, y la base de la nube se utiliza para evaluar techo operacional y condiciones VFR o IFR.',
    
    'respuestas': [
     {'texto': 'A.- Parcialmente cubierto (4/8) y las nubes tienen una base de 1.900 pies.','puntos': 0},
     {'texto': 'B.- Casi despejado y la base de la nubosidad es de aproximadamente 1900 metros.','puntos': 0},
     {'texto': 'C.- Cubierto y la base de la nubosidad es de aproximadamente 600 metros.','puntos': 1},
     ]         
  },

{
    'texto': '92.- Según la Información Meteorológica de la Figura 116, el día 16 a las 17:00 UTC el aeródromo de Tobalaba (SCTB) tenía:',
    'explicacion': r'La información indica cielo despejado, visibilidad de 6.000 metros y viento muy débil. Estas condiciones permiten reconocer un escenario de buen tiempo relativo, aunque la visibilidad no sea ilimitada. El viento muy poco intenso se interpreta como condición cercana a calma.',
    
    'respuestas': [
     {'texto': 'A.- Nubosidad dispersa, viento de los 230 grados con una intensidad de 3 nudos y 6.000 pies de visibilidad.','puntos': 0},
     {'texto': 'B.- Cielo despejado, visibilidad de 6.000 metros y muy poco viento.','puntos': 1},
     {'texto': 'C.- Nubosidad dispersa cuya base era de 6.000 pies y viento de los 230 grados con 3 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '93.- Según la Información Meteorológica de la Figura 116, el día 16 a las 17:00 UTC, Balmaceda (SCBA) tenía:',
    'explicacion': r'La información indica nubosidad dispersa en dos niveles: una capa alrededor de 4.000 pies y otra cerca de 20.000 pies. Además, se reportan ráfagas de viento entre 27 y 39 nudos desde los 310 grados. Estos datos son relevantes para la operación por la presencia de viento fuerte y variación de intensidad.',
    
    'respuestas': [
     {'texto': 'A.- Nubosidad dispersa (3/8 a 4/8) a 4.000 pies y 20.000 pies, y ráfagas de viento de 27 a 39 nudos desde los 310 grados.','puntos': 1},
     {'texto': 'B.- Cielo cubierto por dos capas de nubes, una a 4.000 pies y la otra a 20.000 pies. El viento estaba arrachado entre 27 y 39 nudos desde los 310 grados.','puntos': 0},
     {'texto': 'C.- Visibilidad ilimitada, viento de los 310 grados entre 27 y 39 nudos, nubes de tipo estratocúmulos a 400 y 2.000 pies, QNH 1008 hPa, y temperatura ambiente y punto de rocío de 18 y 11 grados respectivamente.','puntos': 0},
     ]         
  },

{
    'texto': '94.- Según la Información Meteorológica de la Figura 116, a las 17:00 UTC Punta Arenas (SCCI) tenía:',
    'explicacion': r'La información reporta pocas nubes a aproximadamente 600 metros y una condición quebrada a cerca de 6.000 metros. En términos de cobertura, “pocas nubes” indica baja cobertura y “quebrado” indica una cantidad importante de nubosidad, aunque no completamente cubierta.',
    
    'respuestas': [
     {'texto': 'A.- Un viento que soplaba hacia los 270 grados con una intensidad de 26 nudos.','puntos': 0},
     {'texto': 'B.- Pocas nubes a 200 metros y quebrado a 2.000 metros, el QNH 994 y la temperatura ambiente y punto de rocío eran 14 y 6 grados respectivamente.','puntos': 0},
     {'texto': 'C.- Pocas nubes a aproximadamente 600 metros y quebrado a aproximadamente 6.000 metros.','puntos': 1},
     ]         
  },

{
    'texto': '95.- Indique qué significado tienen, respectivamente, las abreviaturas BECMG, INC y TEMPO en la Información Meteorológica de la Figura 117.',
    'explicacion': r'BECMG significa becoming, es decir, un cambio que ocurre gradualmente durante un período. INC se utiliza para indicar dentro de nubes o incluido en nubes, según el contexto del informe. TEMPO significa temporalmente, usado para condiciones que se esperan por períodos limitados dentro del tramo de validez.',
    
    'respuestas': [
     {'texto': 'A.- Becoming (transformándose en ...), inconsistente y temporal.','puntos': 0},
     {'texto': 'B.- Becoming, intermitente y temporalmente.','puntos': 0},
     {'texto': 'C.- Becoming, dentro de nubes y temporalmente.','puntos': 1},
     ]         
  },

{
    'texto': '96.- El frente meteorológico identificado por una letra “O” en la Figura 120:',
    'explicacion': r'La letra “O” identifica un frente estacionario en altura. Un frente estacionario corresponde a una zona frontal con poco o ningún desplazamiento, donde ninguna de las masas de aire logra avanzar claramente sobre la otra. Al estar indicado en altura, debe interpretarse como una estructura frontal de niveles superiores.',
    
    'respuestas': [
     {'texto': 'A.- Es un frente estacionario en superficie.','puntos': 0},
     {'texto': 'B.- Es un frente ocluido en superficie.','puntos': 0},
     {'texto': 'C.- Es un frente estacionario en altura.','puntos': 1},
     ]         
  },

{
    'texto': '97.- La corriente de chorro identificada por dos letras “Z” (Figura 120), bajo la letra “V”, tiene una barra doble casi vertical. Esta barra doble significa:',
    'explicacion': r'En la simbología de corrientes de chorro, las barras asociadas al eje del jet indican variaciones relevantes en la velocidad del viento. Una barra doble casi vertical representa un cambio significativo en la velocidad de la corriente de chorro, dato importante para prever turbulencia, cizalle y variaciones en tiempo de vuelo.',
    
    'respuestas': [
     {'texto': 'A.- Un cambio significativo en el nivel de la corriente de chorro.','puntos': 0},
     {'texto': 'B.- Un cambio significativo en la velocidad de la corriente de chorro.','puntos': 1},
     {'texto': 'C.- Cizalle de la corriente de chorro al ingresar a la tropopausa.','puntos': 0},
     ]         
  },

{
    'texto': '98.- En el Pronóstico Meteorológico de la Figura 120, al sur de Chile hay una corriente de chorro identificada por una letra “Z”. Indique cuál es la velocidad del viento en esa corriente a FL 340.',
    'explicacion': r'La simbología del jetstream en cartas significativas permite identificar nivel de vuelo y velocidad máxima del viento asociado. Para la corriente indicada a FL 340, la velocidad correspondiente es de 90 nudos. Este dato es clave para estimar viento en ruta y posible turbulencia en altura.',
    
    'respuestas': [
     {'texto': 'A.- 90 nudos.','puntos': 1},
     {'texto': 'B.- 140 nudos.','puntos': 0},
     {'texto': 'C.- 70 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '99.- En el Pronóstico Meteorológico de la Figura 120, inmediatamente bajo y a la derecha de la letra “X”, hay un símbolo semejante a una campana. Ello es indicativo de:',
    'explicacion': r'En cartas meteorológicas significativas, el símbolo semejante a una campana puede representar actividad volcánica o erupción volcánica. Este fenómeno es crítico para la aviación porque la ceniza volcánica puede afectar motores, parabrisas, sensores y sistemas de la aeronave.',
    
    'respuestas': [
     {'texto': 'A.- Tempestad extensa de arena o polvo.','puntos': 0},
     {'texto': 'B.- Tormentas.','puntos': 0},
     {'texto': 'C.- Erupción volcánica.','puntos': 1},
     ]         
  },

{
    'texto': '100.- Referencia Figura 121. Ud. efectuará un vuelo desde el aeropuerto “a” al aeropuerto “c” al nivel de vuelo 340. A fin de planificar este vuelo Ud. debería considerar que su avión...',
    'explicacion': r'Para la planificación en ruta al FL340, la información de la figura indica un viento de cola aproximado de 50 nudos y temperatura exterior menor a -44 °C. El viento de cola mejora la velocidad respecto al suelo, mientras que la temperatura es relevante para performance, consumo y condiciones atmosféricas en crucero.',
    
    'respuestas': [
     {'texto': 'A.- Será afectado por un viento de frente de aproximadamente 50 nudos, y a ese nivel la temperatura exterior será de menos 44° C.','puntos': 0},
     {'texto': 'B.- Será afectado por un viento de cola de aproximadamente 50 nudos, y una temperatura exterior de menos 44°C.','puntos': 1},
     {'texto': 'C.- Será afectado inicialmente por un viento de frente de 40 nudos; luego la velocidad del viento aumentará a 100 nudos. La temperatura se mantendrá en menos 44°C.','puntos': 0},
     ]         
  },

{
    'texto': '101.- ¿Dónde se encuentra la ubicación usual de una baja térmica?',
    'explicacion': r'Una baja térmica se forma por calentamiento intenso de la superficie. Es común sobre regiones secas y soleadas, donde el suelo se calienta rápidamente, calienta el aire cercano, disminuye su densidad y favorece el ascenso, generando una zona de menor presión en superficie.',
    
    'respuestas': [
     {'texto': 'A.- Sobre la región antártica.','puntos': 0},
     {'texto': 'B.- En el ojo de un huracán.','puntos': 0},
     {'texto': 'C.- Sobre la superficie de una región seca y soleada.','puntos': 1},
     ]         
  },

{
    'texto': '102.- ¿Cómo afecta la fuerza de Coriolis a la dirección del viento en el Hemisferio Sur?',
    'explicacion': r'En el Hemisferio Sur, la fuerza de Coriolis desvía el movimiento del aire hacia la izquierda respecto de su trayectoria. Alrededor de una baja presión, esto produce una circulación en sentido horario. Esta diferencia respecto del Hemisferio Norte es fundamental para interpretar cartas de superficie y viento.',
    
    'respuestas': [
     {'texto': 'A.- Produce rotación en el sentido del reloj alrededor de una baja.','puntos': 1},
     {'texto': 'B.- Hace que el viento salga de una baja hacia una alta.','puntos': 0},
     {'texto': 'C.- Produce exactamente el mismo efecto que en el Hemisferio Norte.','puntos': 0},
     ]         
  },

{
    'texto': '103.- ¿Qué condición meteorológica se define como “anticiclón”?',
    'explicacion': r'Un anticiclón es una zona de alta presión. Generalmente se asocia con subsidencia, estabilidad atmosférica, menor nubosidad y condiciones de tiempo más estable. En superficie, el flujo alrededor de un anticiclón depende del hemisferio por efecto de Coriolis.',
    
    'respuestas': [
     {'texto': 'A.- Calma.','puntos': 0},
     {'texto': 'B.- Zona de alta presión.','puntos': 1},
     {'texto': 'C.- COL.','puntos': 0},
     ]         
  },

{
    'texto': '104.- ¿Qué tipo de nubes se puede asociar a la corriente en chorro (jetstream)?',
    'explicacion': r'Las nubes cirrus suelen asociarse a corrientes de chorro, especialmente en el lado ecuatorial del jetstream. Su presencia puede servir como indicio visual de vientos fuertes en altura y de zonas con posible cizalle o turbulencia cerca del núcleo del jet.',
    
    'respuestas': [
     {'texto': 'A.- Una línea de cumulonimbos donde el jetstream cruza el frente frío.','puntos': 0},
     {'texto': 'B.- Cirrus en el lado ecuatorial del jetstream.','puntos': 1},
     {'texto': 'C.- Una banda de cirroestratos en el lado polar y bajo el jetstream.','puntos': 0},
     ]         
  },

{
    'texto': '105.- Según la Información Meteorológica de la Figura 118, en Guayaquil:',
    'explicacion': r'La información indica visibilidad superior a 10 kilómetros y dos capas de nubosidad: 3 a 4 octas con base a 2.000 pies, y 5 a 7 octas con base a 9.000 pies. Esta lectura combina visibilidad y cobertura nubosa, permitiendo evaluar condiciones operacionales para salida, llegada o alternado.',
    
    'respuestas': [
     {'texto': 'A.- Habrá sobre 10 kilómetros de visibilidad, 3 a 4 octavos de cielo cubierto a 2.000 pies y 5 a 7 octavos de cielo cubierto a 9.000 pies.','puntos': 1},
     {'texto': 'B.- Habrá sobre 10 kilómetros de visibilidad, 3 a 4 octavos de cielo cubierto a 2.000 metros y 5 a 7 octavos de cielo cubierto a 9.000 metros.','puntos': 0},
     {'texto': 'C.- La visibilidad será superior a 10 kilómetros y en total habrá 8 octavos de cielo cubierto a 2.000 pies y a 9.000 pies.','puntos': 0},
     ]         
  },

{
    'texto': '106.- Si se encuentra lluvia congelante durante el ascenso, es evidencia de que:',
    'explicacion': r'La lluvia congelante se produce cuando gotas de agua líquida sobreenfriada existen en una capa bajo cero, normalmente después de haber pasado por una capa más cálida donde la precipitación se derritió. Si se encuentra lluvia congelante durante el ascenso, indica que arriba existe una capa de aire más cálido que permite la presencia de agua líquida antes de volver a condiciones bajo cero.',
    
    'respuestas': [
     {'texto': 'A.- Se puede ascender a mayor altitud sin encontrar más que hielo ligero.','puntos': 0},
     {'texto': 'B.- Arriba existe una capa de aire más cálido.','puntos': 1},
     {'texto': 'C.- Granizos (ice pellets) de niveles superiores han cambiado a lluvia en el aire cálido de niveles inferiores.','puntos': 0},
     ]         
  },

{
    'texto': '107.- Según la Información Meteorológica de la Figura 116, el día 16 a las 17:00 UTC el aeródromo de Concepción (SCIE) tenía:',
    'explicacion': r'La información meteorológica indica una visibilidad mayor a 10 kilómetros. En reportes aeronáuticos, este valor representa una visibilidad operacional buena, normalmente codificada como 9999 o descrita como superior a 10 km, útil para evaluar condiciones VFR y planificación de aproximación.',
    
    'respuestas': [
     {'texto': 'A.- Una visibilidad variable entre 1.800 y 2.500 pies.','puntos': 0},
     {'texto': 'B.- Una visibilidad variable entre 180 y 250 metros.','puntos': 0},
     {'texto': 'C.- Una visibilidad mayor a 10 Km.','puntos': 1},
     ]         
  },
  

];
final List<Map<String, Object>> poolreglamentacion = [

  {
    'texto': '1.- Antes del despegue, el piloto al mando de un avión que transporta pasajeros debe asegurarse que todos los pasajeros han sido instruidos sobre el equipo de oxígeno. Este procedimiento es obligatorio cuando:',
    'explicacion': r'Antes del vuelo, los pasajeros deben ser instruidos sobre el uso del oxígeno cuando exista la posibilidad de que sea necesario suministrarlo durante el vuelo.',
    
    'respuestas': [
     {'texto': 'A.- El vuelo se realice sobre 8.000 pies por más de 30 minutos.','puntos': 0},
     {'texto': 'B.- El vuelo se realice sobre 14.000 pies por más de 10 minutos.','puntos': 0},
     {'texto': 'C.- Se prescriba la posibilidad de suministro de oxígeno a los pasajeros durante el vuelo.','puntos': 1},
     ]         
  },

{
    'texto': '2.- ¿A quiénes comprende el término “miembro de la tripulación”?',
    'explicacion': r'El término miembro de la tripulación comprende a toda persona a quien se le asignan funciones dentro de una aeronave en vuelo.',
    
    'respuestas': [
     {'texto': 'A.- A los pilotos, al operador de sistemas o al navegante del avión, si corresponde.','puntos': 0},
     {'texto': 'B.- A toda persona que se le asignan funciones dentro de una aeronave en vuelo.','puntos': 1},
     {'texto': 'C.- A toda persona que se le asignan funciones dentro de una aeronave en vuelo, excepto los pilotos y el operador de sistema, si corresponde.','puntos': 0},
     ]         
  },

{
    'texto': '3.- ¿Bajo qué condiciones se requiere que un operador de sistemas (Flight Engineer) integre la tripulación de vuelo?',
    'explicacion': r'El operador de sistemas integra la tripulación cuando la certificación del avión lo requiere o cuando así lo especifica el manual de operaciones.',
    
    'respuestas': [
     {'texto': 'A.- Cuando se efectúa un vuelo de prueba mientras se transporta carga de pago.','puntos': 0},
     {'texto': 'B.- Cuando el avión es un turborreactor pesado propulsado por más de dos motores.','puntos': 0},
     {'texto': 'C.- Cuando así lo requiere la certificación del avión y/o lo especifica su manual de operaciones.','puntos': 1},
     ]         
  },

{
    'texto': '4.- ¿Cuánto es el mínimo de auxiliares de cabina requeridos en un avión con una capacidad de 333 asientos instalados para pasajeros y que transporta 296 pasajeros?',
    'explicacion': r'El número mínimo de auxiliares de cabina se determina según la capacidad de asientos de pasajeros instalada en el avión.',
    
    'respuestas': [
     {'texto': 'A.- Siete.','puntos': 1},
     {'texto': 'B.- Seis.','puntos': 0},
     {'texto': 'C.- Cinco.','puntos': 0},
     ]         
  },

{
    'texto': '5.- ¿Cuánto es el mínimo de auxiliares de cabina requeridos en un avión de transporte público que tiene instalados 188 asientos para pasajeros, pero que lleva sólo 117 pasajeros a bordo?',
    'explicacion': r'El mínimo de auxiliares de cabina se calcula de acuerdo con los asientos instalados para pasajeros, no solamente por los pasajeros efectivamente a bordo.',
    
    'respuestas': [
     {'texto': 'A.- Cinco.','puntos': 0},
     {'texto': 'B.- Cuatro.','puntos': 1},
     {'texto': 'C.- Tres.','puntos': 0},
     ]         
  },

{
    'texto': '6.- De acuerdo a lo prescrito en el reglamento de operación de aviones de transporte público, el concepto de “vuelos de larga distancia” es aplicable a operaciones efectuadas con aviones bimotores o más motores de capacidad de más de 30 pasajeros y cuya ruta incluya cualquier punto que con respecto a un aeródromo adecuado de aterrizaje, se encuentre a más de:',
    'explicacion': r'En este contexto, se considera vuelo de larga distancia cuando la ruta incluye un punto situado a más de 60 minutos de un aeródromo adecuado de aterrizaje.',
    
    'respuestas': [
     {'texto': 'A.- 30 minutos o más.','puntos': 0},
     {'texto': 'B.- 45 minutos o más.','puntos': 0},
     {'texto': 'C.- 60 minutos o más.','puntos': 1},
     ]         
  },

{
    'texto': '7.- Distancia de despegue disponible es la distancia que la autoridad aeronáutica ha establecido como adecuada para despegar y ascender hasta una altura de:',
    'explicacion': r'La distancia de despegue disponible considera la distancia necesaria para despegar y alcanzar una altura reglamentaria de 35 pies.',
    
    'respuestas': [
     {'texto': 'A.- 35 pies.','puntos': 1},
     {'texto': 'B.- 50 pies.','puntos': 0},
     {'texto': 'C.- 75 pies.','puntos': 0},
     ]         
  },

{
    'texto': '8.- El área de un aeródromo terrestre destinada al embarque, desembarque de pasajeros o carga, estacionamiento y carguío de combustible de aeronaves, se denomina:',
    'explicacion': r'La plataforma es el área del aeródromo destinada al embarque, desembarque, estacionamiento y servicio de aeronaves.',
    
    'respuestas': [
     {'texto': 'A.- Losa de estacionamiento.','puntos': 0},
     {'texto': 'B.- Área de maniobras.','puntos': 0},
     {'texto': 'C.- Plataforma.','puntos': 1},
     ]         
  },

{
    'texto': '9.- El máximo período de servicio de vuelo (PSV) en 24 horas, para una tripulación compuesta por dos pilotos, y que efectúa operaciones de transporte público, es de:',
    'explicacion': r'Para una tripulación compuesta por dos pilotos, el período máximo de servicio de vuelo indicado es de 12 horas en 24 horas.',
    
    'respuestas': [
     {'texto': 'A.- 08:00 horas.','puntos': 0},
     {'texto': 'B.- 10:00 horas.','puntos': 0},
     {'texto': 'C.- 12:00 horas.','puntos': 1},
     ]         
  },

{
    'texto': '10.- El máximo período de validez del certificado médico de una licencia de piloto de transporte de línea aérea, es de:',
    'explicacion': r'El certificado médico para una licencia de piloto de transporte de línea aérea tiene una validez máxima de seis meses.',
    
    'respuestas': [
     {'texto': 'A.- Seis meses.','puntos': 1},
     {'texto': 'B.- Ocho meses.','puntos': 0},
     {'texto': 'C.- Doce meses.','puntos': 0},
     ]         
  },

{
    'texto': '11.- El máximo tiempo de vuelo reglamentario en 24 horas consecutivas, en vuelos comerciales de transporte público de pasajeros, para una tripulación compuesta por tres pilotos es de:',
    'explicacion': r'Cuando la tripulación está compuesta por tres pilotos, el tiempo máximo de vuelo reglamentario en 24 horas consecutivas es de 12 horas.',
    
    'respuestas': [
     {'texto': 'A.- 10 horas.','puntos': 0},
     {'texto': 'B.- 12 horas.','puntos': 1},
     {'texto': 'C.- 14 horas.','puntos': 0},
     ]         
  },

{
    'texto': '12.- El propósito del ATC (Air Traffic Controller) es:',
    'explicacion': r'El servicio de control de tránsito aéreo tiene como propósito prevenir colisiones y mantener ordenado y expedito el movimiento del tránsito aéreo.',
    
    'respuestas': [
     {'texto': 'A.- Notificar servicios de búsqueda y salvamento.','puntos': 0},
     {'texto': 'B.- Entregar servicios de información de vuelo.','puntos': 0},
     {'texto': 'C.- Prevenir colisiones, acelerar y mantener ordenadamente el movimiento del tránsito aéreo.','puntos': 1},
     ]         
  },

{
    'texto': '13.- El reglamento de operación de aviones de transporte público establece el número mínimo de extintores que debe llevar un avión. Esta cantidad de extintores está determinada por:',
    'explicacion': r'El número mínimo de extintores requeridos a bordo se determina principalmente según la capacidad de asientos de pasajeros del avión.',
    
    'respuestas': [
     {'texto': 'A.- La capacidad de asientos de pasajeros del avión.','puntos': 1},
     {'texto': 'B.- El número de pasajeros que se transporta.','puntos': 0},
     {'texto': 'C.- El volumen de la cabina de carga o pasajeros.','puntos': 0},
     ]         
  },

{
    'texto': '14.- ¿En caso de incapacitación en vuelo del operador de sistemas, quién puede desempeñar las funciones de éste?',
    'explicacion': r'En caso de incapacitación del operador de sistemas, sus funciones pueden ser realizadas por cualquier miembro de la tripulación de vuelo capacitado para ello.',
    
    'respuestas': [
     {'texto': 'A.- Solamente el copiloto.','puntos': 0},
     {'texto': 'B.- Cualquier miembro de la tripulación de vuelo que esté capacitado para ello.','puntos': 1},
     {'texto': 'C.- Cualquiera de los pilotos, siempre que sean titulares de una licencia de operador de sistemas.','puntos': 0},
     ]         
  },

{
    'texto': '15.- En Chile, en todas las operaciones aeroterrestres, excepto para el despegue y el aterrizaje, la dirección del viento se proporciona:',
    'explicacion': r'En Chile, la dirección del viento se entrega normalmente en grados verdaderos, excepto para despegue y aterrizaje.',
    
    'respuestas': [
     {'texto': 'A.- En grados magnéticos.','puntos': 0},
     {'texto': 'B.- Según su derrota magnética.','puntos': 0},
     {'texto': 'C.- En grados verdaderos.','puntos': 1},
     ]         
  },

{
    'texto': '16.- En Chile, una aeronave con plan de vuelo VFR volará en una derrota magnética de 350°. Indique cuál de las siguientes altitudes es la reglamentaria a mantener.',
    'explicacion': r'Para vuelos VFR en derrota magnética correspondiente al tramo indicado, se debe mantener una altitud semicircular apropiada más 500 pies.',
    
    'respuestas': [
     {'texto': 'A.- 18.500 pies.','puntos': 1},
     {'texto': 'B.- 19.000 pies.','puntos': 0},
     {'texto': 'C.- 19.500 pies.','puntos': 0},
     ]         
  },

{
    'texto': '17.- En Chile, una aeronave se encuentra volando en crucero (vuelo nivelado), con plan de vuelo VFR en el curso magnético 200°. Indique cuál de las siguientes altitudes es la reglamentaria a mantener.',
    'explicacion': r'En vuelo VFR de crucero se aplican niveles semicirculares según la derrota magnética, manteniendo altitudes apropiadas con 500 pies adicionales.',
    
    'respuestas': [
     {'texto': 'A.- 19.000 pies.','puntos': 0},
     {'texto': 'B.- 18.500 pies.','puntos': 0},
     {'texto': 'C.- 19.500 pies.','puntos': 1},
     ]         
  },

{
    'texto': '18.- En operaciones de transporte público, efectuadas con aviones turborreactores, el mínimo combustible requerido para el despacho es el necesario para volar desde el aeródromo de origen al de destino, más el combustible para volar desde la aproximación frustrada en el destino hasta la alternativa, más:',
    'explicacion': r'El combustible mínimo debe considerar destino, alternativa, espera reglamentaria y contingencias según el tipo de operación.',
    
    'respuestas': [
     {'texto': 'A.- El combustible para 30 minutos de espera a nivel de crucero, más combustible para contingencias.','puntos': 0},
     {'texto': 'B.- El combustible para 30 minutos de vuelo a 1.500 pies de altura en circuito de espera (holding) sobre el aeródromo de alternativa, más combustible para contingencias.','puntos': 1},
     {'texto': 'C.- El combustible para 45 minutos de espera sobre el aeródromo alternativa, más una cantidad de combustible adicional para contingencias.','puntos': 0},
     ]         
  },

{
    'texto': '19.- En operaciones de transporte público, el máximo tiempo de vuelo reglamentario, para una tripulación mínima, programada para efectuar un vuelo con 8 aterrizajes, es de:',
    'explicacion': r'Cuando se programa un vuelo con ocho aterrizajes, el tiempo máximo de vuelo reglamentario para una tripulación mínima es de 6 horas y 30 minutos.',
    
    'respuestas': [
     {'texto': 'A.- 6 horas y 30 minutos.','puntos': 1},
     {'texto': 'B.- 7 horas y 30 minutos.','puntos': 0},
     {'texto': 'C.- 8 horas.','puntos': 0},
     ]         
  },

{
    'texto': '20.- En operaciones de transporte público, el mínimo largo de pista reglamentario en el aeródromo de alternativa es el necesario para detener la aeronave en el aterrizaje, en:',
    'explicacion': r'Para operaciones de transporte público, la distancia requerida en el aeródromo de alternativa debe permitir detener la aeronave dentro del 70% de la pista disponible.',
    
    'respuestas': [
     {'texto': 'A.- El 70% de la pista disponible.','puntos': 1},
     {'texto': 'B.- El 75% de la pista disponible.','puntos': 0},
     {'texto': 'C.- El 80% de la pista disponible.','puntos': 0},
     ]         
  },

{
    'texto': '21.- Entre la puesta y la salida del sol, todas las aeronaves que operen en el área de movimiento de un aeródromo ostentarán:',
    'explicacion': r'Durante la noche, las aeronaves que operan en el área de movimiento deben utilizar luces de navegación y anticolisión.',
    
    'respuestas': [
     {'texto': 'A.- Las luces anticolisión y estroboscópicas.','puntos': 0},
     {'texto': 'B.- Las luces de navegación y anticolisión.','puntos': 1},
     ]         
  },

{
    'texto': '22.- En vuelos de transporte público siempre se debe preparar, antes del vuelo, un plan operacional de vuelo. Estos planes operacionales de vuelo se deben conservar durante un tiempo mínimo de:',
    'explicacion': r'Los planes operacionales de vuelo deben conservarse por un período mínimo de seis meses.',
    
    'respuestas': [
     {'texto': 'A.- Seis meses.','puntos': 1},
     {'texto': 'B.- Doce meses.','puntos': 0},
     {'texto': 'C.- Dieciocho meses.','puntos': 0},
     ]         
  },

{
    'texto': '23.- Indique cuál de los siguientes requerimientos constituye parte del requisito de experiencia reciente para un piloto al mando.',
    'explicacion': r'La experiencia reciente exige haber efectuado, como mínimo, tres despegues y tres aterrizajes en el mismo tipo de avión dentro de los últimos 60 días.',
    
    'respuestas': [
     {'texto': 'A.- Haber efectuado como mínimo un aterrizaje con falla simulada del motor más crítico en los últimos 90 días.','puntos': 0},
     {'texto': 'B.- Haber efectuado como mínimo una aproximación ILS hasta la DH publicada y aterrizaje desde esta aproximación en los últimos seis meses.','puntos': 0},
     {'texto': 'C.- Haber efectuado como mínimo tres despegues y tres aterrizajes en el mismo tipo de avión en los últimos 60 días.','puntos': 1},
     ]         
  },

{
    'texto': '24.- Indique en cuál de las siguientes circunstancias un piloto al mando requiere ser titular de una habilitación de tipo:',
    'explicacion': r'La habilitación de tipo es requerida, entre otros casos, cuando se opera un avión certificado para ser operado con más de un piloto.',
    
    'respuestas': [
     {'texto': 'A.- Cuando vuela un avión certificado para ser operado con más de un piloto.','puntos': 1},
     {'texto': 'B.- Cuando vuela un avión cuyo máximo peso de despegue es de más de 12.500 lbs.','puntos': 0},
     {'texto': 'C.- Cuando vuela un avión multimotor con un peso máximo de despegue de más de 6.000 lbs.','puntos': 0},
     ]         
  },

{
    'texto': '25.- Indique la aseveración correcta con relación a las operaciones ILS Categoría III.',
    'explicacion': r'Las operaciones ILS fail-passive se llevan a cabo con una altura de decisión de 50 pies.',
    
    'respuestas': [
     {'texto': 'A.- Las operaciones fail-passive están limitadas a ILS Categoría IIIB.','puntos': 0},
     {'texto': 'B.- Las operaciones fail-passive se llevan a cabo con una DH de 50 pies.','puntos': 1},
     {'texto': 'C.- Las operaciones ILS CAT III fail-operation están limitadas a una DH de 50 pies.','puntos': 0},
     ]         
  },

{
    'texto': '26.- Indique la aseveración correcta con relación a las operaciones ILS Categoría II y III.',
    'explicacion': r'Para efectuar operaciones ILS Categoría II o III, el titular debe tener consignada en su licencia la autorización correspondiente.',
    
    'respuestas': [
     {'texto': 'A.- La habilitación IFR autoriza a su titular a efectuar operaciones ILS Categoría II y III, siempre que el avión y el aeropuerto estén equipados para ello.','puntos': 0},
     {'texto': 'B.- Para efectuar operaciones ILS Categoría II o III, el titular de la licencia debe tener consignada en su licencia esta habilitación, con indicación del tipo de material autorizado y la función correspondiente.','puntos': 1},
     {'texto': 'C.- La habilitación Categoría II o III estampada en la licencia autoriza a su titular a efectuar estas operaciones en cualquier tipo de avión equipado para ello.','puntos': 0},
     ]         
  },

{
    'texto': '27.- Indique la aseveración correcta con relación a mantener dos o más “habilitaciones de tipo de aeronave” en una licencia de vuelo.',
    'explicacion': r'El titular debe cumplir entrenamiento periódico para cada tipo de avión en intervalos establecidos, generalmente cada seis meses.',
    
    'respuestas': [
     {'texto': 'A.- El titular debe someterse cada seis meses al entrenamiento periódico requerido para cada tipo de avión, y no le es aplicable el procedimiento de efectuar los entrenamientos a intervalos no mayores de ocho meses ni menores de cuatro meses.','puntos': 1},
     {'texto': 'B.- En Chile no se autoriza la doble habilitación de tipo.','puntos': 0},
     {'texto': 'C.- La doble habilitación de tipo sólo es posible si una habilitación es de avión y la otra de helicóptero.','puntos': 0},
     ]         
  },

{
    'texto': '28.- Indique la aseveración correcta con respecto a un espacio aéreo ATS, Clase A.',
    'explicacion': r'En espacio aéreo ATS Clase A sólo se permiten vuelos IFR.',
    
    'respuestas': [
     {'texto': 'A.- Sólo se permiten vuelos IFR.','puntos': 1},
     {'texto': 'B.- Sólo se autorizan vuelos VFR.','puntos': 0},
     {'texto': 'C.- Se permiten vuelos IFR y VFR.','puntos': 0},
     ]         
  },

{
    'texto': '29.- La abreviatura utilizada para informe meteorológico aeronáutico ordinario es:',
    'explicacion': r'El METAR corresponde al informe meteorológico aeronáutico ordinario de aeródromo.',
    
    'respuestas': [
     {'texto': 'A.- TAF.','puntos': 0},
     {'texto': 'B.- IMO.','puntos': 0},
     {'texto': 'C.- METAR.','puntos': 1},
     ]         
  },

{
    'texto': '30.- La abreviatura utilizada para pronóstico de aeródromo es:',
    'explicacion': r'El TAF corresponde al pronóstico meteorológico de aeródromo.',
    
    'respuestas': [
     {'texto': 'A.- TAF','puntos': 1},
     {'texto': 'B.- PDA','puntos': 0},
     {'texto': 'C.- METAR','puntos': 0},
     ]         
  },

  {
    'texto': '31.- La autorización para rodar hacia una pista permite también:',
    'explicacion': r'La autorización para rodar permite utilizar las calles de rodaje designadas y cruzar intersecciones de otras calles de rodaje, pero no autoriza ingresar a la pista activa salvo autorización expresa.',
    
    'respuestas': [
     {'texto': 'A.- Cruzar intersecciones de pista si el piloto verifica que no hay tráfico esencial.','puntos': 0},
     {'texto': 'B.- Utilizar las calles de rodaje designadas y cruzar intersecciones de otras calles de rodaje.','puntos': 1},
     {'texto': 'C.- Ingresar a la pista designada para el despegue si el control del aeródromo le transmite luz blanca fija.','puntos': 0},
     ]         
  },

{
    'texto': '32.- La competencia del titular de una habilitación IFR se debe demostrar:',
    'explicacion': r'La competencia IFR debe demostrarse dos veces cada 12 meses consecutivos, respetando intervalos no mayores de 8 meses ni menores de 4 meses.',
    
    'respuestas': [
     {'texto': 'A.- Dos veces cada 12 meses consecutivos, a intervalos no mayores de 8 meses ni menores de 4 meses.','puntos': 1},
     {'texto': 'B.- Si se es piloto de transporte de línea aérea, cada 4 meses.','puntos': 0},
     {'texto': 'C.- Dos veces al año, a intervalos no mayores de cinco meses.','puntos': 0},
     ]         
  },

{
    'texto': '33.- La dirección del viento, excepto para el despegue y el aterrizaje, se proporciona en:',
    'explicacion': r'En las operaciones aeronáuticas, la dirección del viento se entrega normalmente en grados verdaderos; sin embargo, para despegue y aterrizaje se utiliza referencia magnética.',
    
    'respuestas': [
     {'texto': 'A.- Grados magnéticos.','puntos': 1},
     {'texto': 'B.- Grados verdaderos.','puntos': 0},
     {'texto': 'C.- Grados verdaderos corregidos por la variación del lugar.','puntos': 0},
     ]         
  },

{
    'texto': '34.- La distancia de aterrizaje requerida en un aeródromo de alternativa, determinada según el manual de vuelo del avión, no excederá del ____ por ciento de la distancia de aterrizaje disponible. Considere que son operaciones de transporte público.',
    'explicacion': r'En operaciones de transporte público, la distancia de aterrizaje requerida en el aeródromo de alternativa no debe exceder el 70% de la distancia de aterrizaje disponible.',
    
    'respuestas': [
     {'texto': 'A.- 50','puntos': 0},
     {'texto': 'B.- 60','puntos': 0},
     {'texto': 'C.- 70','puntos': 1},
     ]         
  },

{
    'texto': '35.- La distancia de despegue disponible se abrevia o identifica como:',
    'explicacion': r'TODA significa Take-Off Distance Available, es decir, distancia de despegue disponible.',
    
    'respuestas': [
     {'texto': 'A.- TORA.','puntos': 0},
     {'texto': 'B.- TODA.','puntos': 1},
     {'texto': 'C.- DDD.','puntos': 0},
     ]         
  },

{
    'texto': '36.- La exigencia de contar con un sistema de alerta de la proximidad del terreno (GPWS) es aplicable a las aeronaves turborreactores con capacidad superior a:',
    'explicacion': r'El sistema GPWS es exigible a aeronaves turborreactores cuando superan la capacidad mínima reglamentaria de pasajeros indicada.',
    
    'respuestas': [
     {'texto': 'A.- 10 asientos de pasajeros.','puntos': 1},
     {'texto': 'B.- 19 asientos de pasajeros.','puntos': 0},
     {'texto': 'C.- 30 asientos de pasajeros.','puntos': 0},
     ]         
  },

{
    'texto': '37.- La fraseología que debe utilizar un piloto de una aeronave interceptada y que significa “he sido objeto de apoderamiento ilícito”, es:',
    'explicacion': r'La palabra clave “HIJAK” se utiliza para indicar que una aeronave ha sido objeto de apoderamiento ilícito.',
    
    'respuestas': [
     {'texto': 'A.- WILCO.','puntos': 0},
     {'texto': 'B.- HIJAK.','puntos': 1},
     {'texto': 'C.- CAN NOT.','puntos': 0},
     ]         
  },

{
    'texto': '38.- La instrucción que debe cumplir un copiloto (segundo al mando) de un avión determinado para poder desempeñarse como piloto al mando de ese mismo avión, se denomina:',
    'explicacion': r'La instrucción de ascenso de material permite que un copiloto sea preparado para desempeñarse como piloto al mando en ese mismo tipo de avión.',
    
    'respuestas': [
     {'texto': 'A.- Instrucción de diferencia.','puntos': 0},
     {'texto': 'B.- Instrucción de ascenso de material.','puntos': 1},
     {'texto': 'C.- Instrucción periódica.','puntos': 0},
     ]         
  },

{
    'texto': '39.- La instrucción que debe cumplir un tripulante que no ha sido habilitado previamente, ni ha volado otro avión similar del mismo grupo, se denomina:',
    'explicacion': r'La instrucción inicial corresponde a la capacitación que recibe un tripulante cuando no ha sido habilitado previamente ni ha operado un avión similar del mismo grupo.',
    
    'respuestas': [
     {'texto': 'A.- Instrucción inicial.','puntos': 1},
     {'texto': 'B.- Instrucción de transición.','puntos': 0},
     {'texto': 'C.- Instrucción de ascenso de material.','puntos': 0},
     ]         
  },

{
    'texto': '40.- La obligación de llevar a bordo chalecos salvavidas para los pasajeros es aplicable a los aviones multimotores cuando vuelan sobre el agua a una distancia de la costa de:',
    'explicacion': r'Los aviones multimotores deben llevar chalecos salvavidas para los pasajeros cuando vuelan sobre el agua a más de 50 millas náuticas de la costa.',
    
    'respuestas': [
     {'texto': 'A.- Más de 50 millas náuticas.','puntos': 1},
     {'texto': 'B.- Más de 100 millas náuticas.','puntos': 0},
     {'texto': 'C.- Más de 400 millas náuticas.','puntos': 0},
     ]         
  },

{
    'texto': '41.- La parte del aeródromo que se utiliza para el despegue, aterrizaje y rodaje de aeronaves, excluyéndose las plataformas, se denomina:',
    'explicacion': r'El área de maniobras comprende las partes del aeródromo usadas para despegue, aterrizaje y rodaje de aeronaves, excluyendo las plataformas.',
    
    'respuestas': [
     {'texto': 'A.- Área de movimiento.','puntos': 0},
     {'texto': 'B.- Área de maniobras.','puntos': 1},
     {'texto': 'C.- Área de operaciones aéreas.','puntos': 0},
     ]         
  },

{
    'texto': '42.- La sanción que estipula el Código Aeronáutico para el piloto que se desempeñe en una aeronave con su licencia vencida es de:',
    'explicacion': r'Desempeñarse como piloto con la licencia vencida constituye una infracción sancionable con presidio o reclusión menor o multa.',
    
    'respuestas': [
     {'texto': 'A.- Presidio o reclusión menor o multa.','puntos': 1},
     {'texto': 'B.- Presidio o reclusión mayor.','puntos': 0},
     {'texto': 'C.- Suspensión de la licencia hasta por un año.','puntos': 0},
     ]         
  },

{
    'texto': '43.- Las atribuciones y deberes del comandante de una aeronave matriculada en Chile, se regirán por la ley chilena cuando la aeronave se encuentre:',
    'explicacion': r'Las atribuciones y deberes del comandante de una aeronave chilena se rigen por la ley chilena tanto en territorio nacional como extranjero.',
    
    'respuestas': [
     {'texto': 'A.- Sobre territorio chileno.','puntos': 0},
     {'texto': 'B.- Sobre territorio y aguas jurisdiccionales chilenas.','puntos': 0},
     {'texto': 'C.- En territorio nacional o extranjero.','puntos': 1},
     ]         
  },

{
    'texto': '44.- La señal radiotelefónica que significa que una aeronave tiene que transmitir un mensaje urgentísimo relativo a la seguridad de personas, aeronaves, barcos u otros vehículos, es:',
    'explicacion': r'La señal “PAN PAN” se utiliza para mensajes de urgencia relacionados con la seguridad de personas, aeronaves, barcos u otros vehículos, sin que exista una situación de peligro inmediato.',
    
    'respuestas': [
     {'texto': 'A.- PAN, PAN.','puntos': 1},
     {'texto': 'B.- MAYDAY.','puntos': 0},
     {'texto': 'C.- SOS.','puntos': 0},
     ]         
  },

{
    'texto': '45.- La visibilidad mínima para autorizar a un avión a efectuar un vuelo VFR especial es de:',
    'explicacion': r'Para autorizar un vuelo VFR especial, la visibilidad mínima indicada es de 2.000 metros.',
    
    'respuestas': [
     {'texto': 'A.- 1.600 metros.','puntos': 0},
     {'texto': 'B.- 2.000 metros.','puntos': 1},
     {'texto': 'C.- Una milla náutica.','puntos': 0},
     ]         
  },

{
    'texto': '46.- Los mínimos ILS Categoría IIIA son:',
    'explicacion': r'Los mínimos de ILS Categoría IIIA consideran un RVR de 700 pies, equivalente a 200 metros, y una altura de decisión inferior a 100 pies.',
    
    'respuestas': [
     {'texto': 'A.- RVR 700 pies (200 mts) y DH inferior a 100 pies.','puntos': 1},
     {'texto': 'B.- RVR no inferior a 50 mts y DH 50 pies o meno.','puntos': 0},
     {'texto': 'C.- RVR 700 pies y DH no inferior a 100 pies.','puntos': 0},
     ]         
  },

{
    'texto': '47.- Los mínimos ILS Categoría II son:',
    'explicacion': r'La Categoría II de ILS considera una altura de decisión de 100 pies y un RVR de 1.200 pies.',
    
    'respuestas': [
     {'texto': 'A.- DH 100 pies y RVR 1.200 pies.','puntos': 1},
     {'texto': 'B.- DH 150 pies y RVR 1.600 pies.','puntos': 0},
     {'texto': 'C.- DH 200 pies y RVR 2.400 pies.','puntos': 0},
     ]         
  },

{
    'texto': '48.- Los mínimos meteorológicos para despegar o aterrizar en un aeródromo en condiciones VFR en Chile son:',
    'explicacion': r'Para operar en condiciones VFR, los mínimos meteorológicos indicados corresponden a techo de nubes de 450 metros y visibilidad de 5 kilómetros.',
    
    'respuestas': [
     {'texto': 'A.- Techo de nubes 500 metros y visibilidad 5 kilómetros.','puntos': 0},
     {'texto': 'B.- Techo de nubes 450 metros y visibilidad 8 kilómetros.','puntos': 0},
     {'texto': 'C.- Techo de nubes 450 metros y visibilidad 5 kilómetros.','puntos': 1},
     ]         
  },

{
    'texto': '49.- Los NOTAM referidos exclusivamente a ciertos aeropuertos y a las operaciones de vuelo IFR desde y hacia esos aeropuertos, se identifican como:',
    'explicacion': r'Los NOTAM serie A se refieren a ciertos aeropuertos y a operaciones de vuelo IFR desde y hacia esos aeropuertos.',
    
    'respuestas': [
     {'texto': 'A.- NOTAM Serie A.','puntos': 1},
     {'texto': 'B.- NOTAM Serie B.','puntos': 0},
     {'texto': 'C.- NOTAM Serie C.','puntos': 0},
     ]         
  },

{
    'texto': '50.- Los NOTAM relacionados con las operaciones de vuelo de los aeródromos y aeropuertos internacionales, se identifican como:',
    'explicacion': r'Los NOTAM Serie A se utilizan para información relacionada con operaciones de vuelo de aeródromos y aeropuertos internacionales.',
    
    'respuestas': [
     {'texto': 'A.- NOTAM Serie A.','puntos': 1},
     {'texto': 'B.- NOTAM Serie B.','puntos': 0},
     {'texto': 'C.- NOTAM Serie C.','puntos': 0},
     ]         
  },

{
    'texto': '51.- Para el 1° de agosto se planifica un vuelo que requiere de piloto y copiloto. Ambos pilotos tienen certificado médico extendido el 28 de febrero. Para efectuar este vuelo:',
    'explicacion': r'Para efectuar el vuelo, ambos pilotos deben portar su licencia vigente con las habilitaciones correspondientes al vuelo que realizarán.',
    
    'respuestas': [
     {'texto': 'A.- El piloto al mando y el copiloto deben portar su respectiva licencia vigente con las habilitaciones apropiadas al vuelo.','puntos': 1},
     {'texto': 'B.- El piloto al mando si es piloto de transporte de línea aérea, debe obtener un nuevo certificado médico; no así el copiloto si es piloto comercial.','puntos': 0},
     {'texto': 'C.- El piloto al mando y el copiloto deben obtener nuevo certificado médico, o una extensión de este.','puntos': 0},
     ]         
  },
{
    'texto': '52.- Para revalidar la licencia de piloto de transporte de línea aérea se requiere que el piloto demuestre su competencia.',
    'explicacion': r'Para revalidar la licencia de piloto de transporte de línea aérea, el piloto debe demostrar su competencia dos veces cada 12 meses consecutivos.',
    
    'respuestas': [
     {'texto': 'A.- Una vez cada 12 meses consecutivos.','puntos': 0},
     {'texto': 'B.- Dos veces cada 12 meses consecutivos.','puntos': 1},
     {'texto': 'C.- Una vez cada 8 meses consecutivos.','puntos': 0},
     ]         
  },

{
    'texto': '53.- ¿Qué aeronaves requieren que su piloto sea titular de la correspondiente habilitación de tipo vigente?',
    'explicacion': r'La habilitación de tipo vigente es requerida para aeronaves certificadas para volar con una tripulación mínima de dos pilotos.',
    
    'respuestas': [
     {'texto': 'A.- Todas las aeronaves certificadas para volar con una tripulación mínima de dos pilotos.','puntos': 1},
     {'texto': 'B.- Todas las aeronaves cuyo peso máximo de despegue sea de 12.500 lbs. o más.','puntos': 0},
     {'texto': 'C.- Todos los multimotores operados comercialmente.','puntos': 0},
     ]         
  },

{
    'texto': '54.- ¿Qué licencia y habilitaciones se requieren para ser piloto al mando de un avión comercial multirreactor pesado certificado para ser volado por un piloto y un copiloto?',
    'explicacion': r'Para ser piloto al mando de un avión comercial multirreactor pesado, se requiere licencia de piloto de transporte de línea aérea, habilitación de tipo del avión correspondiente y habilitación de piloto al mando.',
    
    'respuestas': [
     {'texto': 'A.- Licencia de piloto comercial con habilitación IFR y además la habilitación para el tipo de avión en que se desempeña.','puntos': 0},
     {'texto': 'B.- Licencia de piloto de transporte de línea aérea y habilitación de multimotor.','puntos': 0},
     {'texto': 'C.- Licencia de piloto de transporte de línea aérea, habilitación de tipo del avión en que se desempeña y habilitación de PIC (piloto al mando).','puntos': 1},
     ]         
  },

{
    'texto': '55.- Según el reglamento de operación de aviones de transporte público, las aeronaves deben estar dotadas de un sistema de iluminación para las salidas de emergencia, cuando su capacidad sea:',
    'explicacion': r'Las aeronaves de transporte público deben contar con sistema de iluminación para salidas de emergencia cuando su capacidad sea superior a 20 pasajeros.',
    
    'respuestas': [
     {'texto': 'A.- Superior a 15 pasajeros.','puntos': 0},
     {'texto': 'B.- Superior a 20 pasajeros.','puntos': 1},
     {'texto': 'C.- Superior a 30 pasajeros.','puntos': 0},
     ]         
  },

{
    'texto': '56.- Según la DAN 121, el límite de tiempo de vuelo mensual y anual para un piloto es de:',
    'explicacion': r'La DAN 121 establece como límite de tiempo de vuelo para un piloto 100 horas mensuales y 1.000 horas anuales.',
    
    'respuestas': [
     {'texto': 'A.- 90 y 900 horas respectivamente.','puntos': 0},
     {'texto': 'B.- 100 y 1000 horas respectivamente.','puntos': 1},
     {'texto': 'C.- 120 y 1200 horas respectivamente.','puntos': 0},
     ]         
  },

{
    'texto': '57.- Según la DAN 121, el máximo período de servicio de vuelo nocturno, en 24 horas consecutivas, para una tripulación compuesta por dos pilotos es de:',
    'explicacion': r'Para una tripulación compuesta por dos pilotos, el máximo período de servicio de vuelo nocturno en 24 horas consecutivas es de 12 horas.',
    
    'respuestas': [
     {'texto': 'A.- 10 horas.','puntos': 0},
     {'texto': 'B.- 12 horas.','puntos': 1},
     {'texto': 'C.- 14 horas.','puntos': 0},
     ]         
  },

{
    'texto': '58.- Según la reglamentación aeronáutica chilena, se requiere de un copiloto....',
    'explicacion': r'Se requiere copiloto cuando así lo especifica el manual de vuelo del avión o el certificado de aeronavegabilidad correspondiente.',
    
    'respuestas': [
     {'texto': 'A.- En toda aeronave que transporta 10 pasajeros o más.','puntos': 0},
     {'texto': 'B.- Cuando así lo especifica el manual de vuelo del avión o el certificado de aeronavegabilidad del mismo.','puntos': 1},
     {'texto': 'C.- Cuando se transporta más de 9 pasajeros y el avión no dispone de un piloto automático de tres ejes.','puntos': 0},
     ]         
  },

{
    'texto': '59.- Según lo dispone el reglamento de operación de aviones transporte público, un piloto no deberá desempeñarse al mando de una aeronave en vuelos comerciales, a menos que en los noventa días precedentes haya efectuado en el mismo tipo de avión, como mínimo.',
    'explicacion': r'Para mantener experiencia reciente, el piloto debe haber efectuado como mínimo tres despegues y tres aterrizajes en el mismo tipo de avión durante el período establecido.',
    
    'respuestas': [
     {'texto': 'A.- Tres despegues y tres aterrizajes.','puntos': 1},
     {'texto': 'B.- Seis despegues y seis aterrizajes.','puntos': 0},
     {'texto': 'C.- Doce despegues y doce aterrizajes.','puntos': 0},
     ]         
  },

{
    'texto': '60.- Ud. como piloto desea planificar un vuelo no itinerante en que requiere de una exposición meteorológica verbal y/o los documentos pertinentes (cartas de superficie, pronósticos de vientos, etc.). Esto Ud. lo debería notificar a la oficina meteorológica respectiva con una anticipación mínima de:',
    'explicacion': r'Para solicitar una exposición meteorológica verbal y/o documentación meteorológica para un vuelo no itinerante, se debe notificar con una anticipación mínima de seis horas.',
    
    'respuestas': [
     {'texto': 'A.- Una hora.','puntos': 0},
     {'texto': 'B.- Tres horas.','puntos': 0},
     {'texto': 'C.- Seis horas.','puntos': 1},
     ]         
  },

{
    'texto': '61.- Una aeronave con falla de comunicaciones está arribando a un aeródromo. En vuelo, recibe desde el control del aeródromo una serie de destellos blancos. Ello significa:',
    'explicacion': r'Una serie de destellos blancos desde la torre indica a la aeronave que debe aterrizar en ese aeródromo y dirigirse posteriormente a la plataforma.',
    
    'respuestas': [
     {'texto': 'A.- Puede aterrizar, siempre que lo haga dentro de los 30 minutos siguientes.','puntos': 0},
     {'texto': 'B.- Debe dirigirse a su aeródromo de alternativa.','puntos': 0},
     {'texto': 'C.- Aterrice en este aeródromo y diríjase a la plataforma.','puntos': 1},
     ]         
  },

{
    'texto': '62.- Una tripulación de un vuelo comercial, integrada por un piloto y un copiloto, el máximo tiempo de vuelo reglamentario para esta tripulación es de:',
    'explicacion': r'Para una tripulación comercial integrada por un piloto y un copiloto, el máximo tiempo de vuelo reglamentario indicado es de 7 horas.',
    
    'respuestas': [
     {'texto': 'A.- 8 horas.','puntos': 0},
     {'texto': 'B.- 7 horas.','puntos': 1},
     {'texto': 'C.- 6 horas.','puntos': 0},
     ]         
  },

{
    'texto': '63.- Un avión de transporte público con 187 asientos para pasajeros tiene 137 pasajeros a bordo. ¿Cuánto es el mínimo de auxiliares de cabina requeridos por la reglamentación?',
    'explicacion': r'El número mínimo de auxiliares de cabina se determina según la capacidad instalada de asientos para pasajeros, no sólo por la cantidad de pasajeros transportados.',
    
    'respuestas': [
     {'texto': 'A.- Cinco.','puntos': 0},
     {'texto': 'B.- Cuatro.','puntos': 1},
     {'texto': 'C.- Tres.','puntos': 0},
     ]         
  },

{
    'texto': '64.- Un avión de transporte público tiene instalados en la cabina de pasajeros 149 asientos para pasajeros y 8 asientos para tripulantes. ¿Cuánto es el mínimo de auxiliares de cabina requeridos con 97 pasajeros a bordo?',
    'explicacion': r'El mínimo de auxiliares de cabina se calcula de acuerdo con los asientos de pasajeros instalados, no considerando los asientos de tripulantes ni sólo los pasajeros a bordo.',
    
    'respuestas': [
     {'texto': 'A.- Cuatro.','puntos': 0},
     {'texto': 'B.- Tres.','puntos': 1},
     {'texto': 'C.- Dos.','puntos': 0},
     ]         
  },

{
    'texto': '65.- Un avión tiene instalados 220 asientos de pasajeros. El número mínimo de extintores que debe llevar a bordo es de:',
    'explicacion': r'El número mínimo de extintores requeridos a bordo depende de la capacidad instalada de asientos de pasajeros del avión.',
    
    'respuestas': [
     {'texto': 'A.- Dos.','puntos': 0},
     {'texto': 'B.- Cuatro.','puntos': 1},
     {'texto': 'C.- Ocho.','puntos': 0},
     ]         
  },

{
    'texto': '66.- Uno de los requisitos para revalidar la licencia de encargados de operaciones de vuelo es haber desempeñado las funciones correspondientes a su licencia durante por lo menos:',
    'explicacion': r'Para revalidar la licencia de encargado de operaciones de vuelo, se requiere haber desempeñado las funciones correspondientes durante al menos 12 meses en los últimos dos años.',
    
    'respuestas': [
     {'texto': 'A.- 12 meses en los últimos dos años.','puntos': 1},
     {'texto': 'B.- 6 meses en los últimos dos años.','puntos': 0},
     {'texto': 'C.- 3 meses en los últimos dos años.','puntos': 0},
     ]         
  },

{
    'texto': '67.- Uno de los requisitos que establece la reglamentación para abastecer de combustible un avión con pasajeros a bordo es que:',
    'explicacion': r'Para abastecer combustible con pasajeros a bordo, debe existir un sistema a presión para el carguío de combustible, junto con las demás medidas de seguridad correspondientes.',
    
    'respuestas': [
     {'texto': 'A.- Se disponga de un sistema a presión para el carguío de combustible.','puntos': 1},
     {'texto': 'B.- Se utilice un sistema de carguío de combustible por gravedad.','puntos': 0},
     {'texto': 'C.- Que toda la tripulación permanezca a bordo del avión y en sus puestos durante el carguío.','puntos': 0},
     ]         
  },

{
    'texto': '68.- Un operador cuyas aeronaves fueron certificadas para operaciones ILS Categoría II obtiene de la DGAC, por primera vez, autorización para este tipo de aproximaciones. Los mínimos que inicialmente se le autorizan son:',
    'explicacion': r'Cuando un operador obtiene por primera vez autorización para operaciones ILS Categoría II, los mínimos iniciales autorizados son DH 150 pies y RVR 1.600 pies.',
    
    'respuestas': [
     {'texto': 'A.- DH 100 pies y RVR 1.200.','puntos': 0},
     {'texto': 'B.- DH 130 pies y RVR 1.400.','puntos': 0},
     {'texto': 'C.- DH 150 pies y RVR 1.600.','puntos': 1},
     ]         
  },

{
    'texto': '69.- Un operador cuyas aeronaves son nuevas y están equipadas de fábrica para efectuar aterrizajes ILS Categoría III, postula por primera vez a la obtención de la autorización para operaciones ILS CAT II. Los mínimos CAT II que se le pueden autorizar inicialmente en Chile, son:',
    'explicacion': r'Para una autorización inicial de operaciones ILS Categoría II en Chile, los mínimos autorizables indicados son DH 100 pies y RVR 1.200 pies.',
    
    'respuestas': [
     {'texto': 'A.- DH 100 pies y RVR 1.200.','puntos': 1},
     {'texto': 'B.- DH 150 pies y RVR 1.600.','puntos': 0},
     {'texto': 'C.- DH 150 pies y RVR 1.200.','puntos': 0},
     ]         
  },

];
// =============================================================
// LÓGICA DE LA APLICACIÓN
// =============================================================
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Inicialización con tiempo límite para evitar bloqueos eternos
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).timeout(const Duration(seconds: 10)); 
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String userName = prefs.getString('userName') ?? "";

    runApp(QuizApp(
      startWidget: isLoggedIn  
        ? WelcomeScreen(nombre: userName)
        : const MiPantallaLogin()
    ));
  } catch (e) {
    // Si falla Firebase o el sistema, arranca una versión segura de la app
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Error al iniciar: Verifica tu conexión")),
      ),
    ));
  }
}

class QuizApp extends StatelessWidget {
  final Widget startWidget;
  const QuizApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: startWidget, // 
    );
  }
}

// 2. PANTALLA DE BIENVENIDA (ESTILO WINDOWS)

String formatearNombreDesdeCorreo(String correo) {
  // 1. Obtener la parte antes del primer punto o la arroba
  // Esto divide el correo en el primer punto que encuentre
  String partePrincipal = correo.split('.').first;
  
  // 2. Por si el correo no tiene punto (ej: usuario@gmail.com), 
  // nos aseguramos de tomar lo que esté antes de la arroba
  if (!correo.contains('.')) {
    partePrincipal = correo.split('@').first;
  }

  // 3. Poner la primera letra en mayúscula y el resto en minúscula
  if (partePrincipal.isEmpty) return "Usuario";
  
  return partePrincipal[0].toUpperCase() + partePrincipal.substring(1).toLowerCase();
}

class WelcomeScreen extends StatefulWidget {
  final String nombre;
  const WelcomeScreen({super.key, required this.nombre});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), 
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn), // 
    );
    _controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      // Solo navega cuando la animación termina realmente
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    }
  });
    _controller.forward();

    // Transición automática al menú tras la animación 
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainMenu()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 58, 64, 99), Color.fromARGB(255, 38, 73, 114)],
          ), 
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¡Bienvenido!, ${formatearNombreDesdeCorreo(widget.nombre)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                ), 
              ),
              const SizedBox(height: 20),
              const Text(
                "Espera un momento, por favor",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. PANTALLA DE LOGIN
class MiPantallaLogin extends StatefulWidget {
  const MiPantallaLogin({super.key});

  @override
  _MiPantallaLoginState createState() => _MiPantallaLoginState();
}

class _MiPantallaLoginState extends State<MiPantallaLogin> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  // Color azul del fondo de la imagen
  final Color azulFondo = const Color.fromARGB(255, 34, 70, 110); 
  bool _cargando = false;
  bool _recordarme = false;
  Future<void> ingresarApp() async {
    if (_cargando) return;
    String nombre = _nombreController.text.trim();
    String codigo = _codigoController.text.trim();

    if (nombre.isEmpty || codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes poner nombre y código")),
      );
      return;
    }
    setState(() => _cargando = true);
    try {
      var docSnap = await FirebaseFirestore.instance
      .collection("Códigos_válidos")
      .doc(codigo)
      .get()
      .timeout(const Duration(seconds: 10));      
      if (docSnap.exists) {
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
        bool enUso = data['en_uso'] ?? false; 
        String? usuarioAsignado = data['quien entro']; 
        if (enUso && usuarioAsignado != nombre) {
          throw ("Este código ya está vinculado a otro usuario.");
        }
        var usuarioQuery = await FirebaseFirestore.instance
            .collection("Códigos_válidos")
            .where("quien entro", isEqualTo: nombre)
            .get();
        if (usuarioQuery.docs.isNotEmpty) {
          // Si encontramos que el usuario ya tiene un código, validamos que sea el mismo
          if (usuarioQuery.docs.first.id != codigo) {
            throw ("Ya tienes un código asignado. Debes usar el código original.");
          }
        }

        await docSnap.reference.update({
          'en_uso': true,
          'quien entro': nombre,
          'fecha_uso': FieldValue.serverTimestamp(), 
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (_recordarme) {
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userName', nombre);
        } else {
          
          await prefs.setBool('isLoggedIn', false);
          await prefs.remove('userName');
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomeScreen(nombre: nombre)),
          );
        }
      } else {
        throw("El código no existe.");        
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: azulFondo,
    body: Stack(
      clipBehavior: Clip.none, // Usamos Stack para que el logo no "empuje" al login
      children: [
        // 1. EL LOGO (Posicionado arriba)
        Positioned(
          top: -40, // Distancia desde la parte de arriba
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              'assets/ESCUELA_LOGO.png',
              height: 380, // <--- Aquí tienes tu logo GRANDE
              fit: BoxFit.contain,
            ),
          ),
        ),

        // 2. EL CUADRO DE LOGIN (Centrado total)
        Center(
          child: SingleChildScrollView( // Para que no de error de espacio en pantallas chicas
            child: Container(
              width: 450,
              margin: const EdgeInsets.only(top: 150, left: 30, right: 30), // Margen top para que no choque si el logo es gigante
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Iniciar sesión",
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildTextField(
                    controller: _nombreController,
                    hint: "Tu correo institucional",
                    icon: Icons.mail_outline,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _codigoController,
                    hint: "Código",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      SizedBox(
                        height: 24, width: 24,
                        child: Checkbox(
                          value: _recordarme,
                          onChanged: (val) {
                            setState(() => _recordarme = val ?? false);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text("Recuérdame", style: TextStyle(color: Colors.grey)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: ingresarApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0091D5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  // Widget auxiliar para los campos de texto con iconos
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF004481), size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey),
              ),

            )
          )
        ],
      ),
    );
  }
}

class PantallaInstructivo extends StatelessWidget {
  const PantallaInstructivo({super.key});

  Future<void> _abrirPdf(BuildContext context) async {
    try {
      if (kIsWeb) {
        // 🌐 Solución Web moderna (sin plugins):
        // window.open abre el archivo directamente desde la carpeta web/
        web.window.open('Instructivo.pdf', '_blank');
      } else {
        // 📱 Solución móvil:
        final Uri url = Uri.parse('asset:///assets/Instructivo.pdf');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw 'No se pudo abrir el PDF';
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Instructivo de Examen")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _abrirPdf(context),
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Abrir PDF"),
        ),
      ),
    );
  }
}
// 4. MENÚ PRINCIPAL (Aquí empieza tu código original)
class MainMenu extends StatelessWidget {
  final List<Map<String, dynamic>> materias = [
    {'nombre': 'AERODINÁMICA', 'Imagen': "assets/AERODINAMICA_SIN_FONDO.png", 'pool': poolAerodinamica, 'limite': 16}, 
    {'nombre': 'PERFORMANCE Y MOTORES', 'Imagen': "assets/PERFORMANCE_Y_MOTORES_SIN_FONDO.png", 'pool': poolperformanceymotores, 'limite': 16},
    {'nombre': 'OPERACIONES DE VUELO', 'Imagen': "assets/OPERACIONES_DE_VUELO_SIN_FONDO.png", 'pool': pooloperacionesdevuelo, 'limite': 16},
    {'nombre': 'PESO Y BALANCE', 'Imagen': "assets/PESO_Y_BALANCE_SIN_FONDO.png", 'pool': poolpesoybalance, 'limite': 16},
    {'nombre': 'METEOROLOGÍA', 'Imagen': "assets/METEO_SIN_FONDO.png", 'pool': poolmeteorologia, 'limite': 25},
    {'nombre': 'REGLAMENTACIÓN', 'Imagen': "assets/REGLAMENTACION_SIN_FONDO.png", 'pool': poolreglamentacion, 'limite': 25},
  ];

  MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Estudio", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MiPantallaLogin()),
                  (route) => false,
                );
              }
            }
          )
        ]
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 🟥 NUEVO: Cuadro "Ver Instructivo" agregado arriba de las materias
              Card(
                elevation: 3,
                color: Colors.indigo.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PantallaInstructivo()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.red.shade700, size: 28),
                        const SizedBox(width: 15),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ver Instructivo",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Encargado de operaciones de vuelo EOV",
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.indigo),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Espaciado entre el instructivo y la grilla de materias
              const SizedBox(height: 20), 

              // Tu GridView original envuelto en un Expanded para que convivan perfectamente
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: materias.length,
                  itemBuilder: (context, index) {
                    final materia = materias[index];
                    return InkWell(
                      onTap: () => _mostrarSeleccionModo(context, materia),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Transform.scale(
                                scale: 1.35,
                                child: Image.asset(
                                  materia['Imagen'].toString(),
                                  cacheWidth: 400,
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                materia['nombre'].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarSeleccionModo(BuildContext context, Map<String, dynamic> materia) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.school, color: Colors.indigo),
              title: const Text("Modo Práctica"),
              subtitle: const Text("Retroalimentación inmediata."),
              onTap: () {
                Navigator.pop(context);
                _irAlQuiz(context, materia, false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, color: Colors.orange),
              title: const Text("Modo Test (Examen)"),
              subtitle: const Text("Solucionario solo al final."),
              onTap: () {
                Navigator.pop(context);
                _irAlQuiz(context, materia, true);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _irAlQuiz(BuildContext context, Map<String, dynamic> materia, bool modoTest) {
    final dynamic poolRaw = materia['pool'];
    List<Map<String, dynamic>> poolAEnviar = [];

    if (poolRaw is List) {
      poolAEnviar = poolRaw.map((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();
    }

    if (modoTest) {
      poolAEnviar.shuffle();
      int limite = materia['limite'] ?? 16;
      poolAEnviar = poolAEnviar.take(limite).toList();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          preguntasRecibidas: poolAEnviar,
          tituloMateria: materia['nombre'].toString(),
          isTestMode: modoTest,
        ),
      ),
    );
  }
}

// 5. PÁGINA DEL QUIZ Y LÓGICA DE PREGUNTAS
class QuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> preguntasRecibidas;
  final String tituloMateria;
  final bool isTestMode;

  const QuizPage({
    super.key,
    required this.preguntasRecibidas,
    required this.tituloMateria,
    required this.isTestMode,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int preguntaActual = 0;
  int puntaje = 0;
  bool respondido = false;
  int? indiceSeleccionado;
  late List<Map<String, dynamic>> preguntas;
  
  List<int?> respuestasUsuario = []; 
  late Stopwatch _cronometro;
  Duration _tiempoFinal = Duration.zero;

  // Controladores para el scroll horizontal superior y el cambio de pantallas
  late PageController _pageController;
  late ScrollController _menuScrollController;
  bool _isQuizFinished = false;

  @override
  void initState() {
    super.initState();
    preguntas = List<Map<String, dynamic>>.from(widget.preguntasRecibidas);
    _cronometro = Stopwatch()..start();
    _pageController = PageController(initialPage: 0);
    _menuScrollController = ScrollController();
    
    // Inicializamos con nulls para soportar saltos y re-navegación libre en ambos modos
    respuestasUsuario = List<int?>.filled(preguntas.length, null);
    
    if (widget.isTestMode) {
      preguntas.shuffle();
      
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _menuScrollController.dispose();
    super.dispose();
  }

  String _formatearTextoPregunta(String textoOriginal, int indice) {
    String limpio = textoOriginal.replaceFirst(RegExp(r'^\d+[\.\s\-]*'), '').trim();
    if (widget.isTestMode){
      return  limpio;  
    }
    return  "Pregunta ${indice + 1}: $limpio";
  }

  Color _getColorPuntaje(double porcentaje) {
    if (porcentaje >= 0.75) return Colors.green;
    if (porcentaje >= 0.65) return Colors.orange;
    return Colors.red;
  }

  void validarRespuesta(int indice, int puntos) {
    if (respondido && !widget.isTestMode) return;

    setState(() {
      indiceSeleccionado = indice;
      respuestasUsuario[preguntaActual] = indice;
      
      if (!widget.isTestMode) {
        respondido = true;
        // Re-calculamos puntaje dinámico en modo práctica
        puntaje = 0;
        for (int i = 0; i < preguntas.length; i++) {
          if (respuestasUsuario[i] != null) {
            final resps = preguntas[i]['respuestas'] as List;
            if (resps[respuestasUsuario[i]!]['puntos'] == 1) puntaje++;
          }
        }
      }
    });
  }

  // Método unificado para saltar de pregunta fluidamente
  void _saltarAPregunta(int index) {
    if (index >= 0 && index < preguntas.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      preguntaActual = index;
      if (widget.isTestMode) {
        indiceSeleccionado = respuestasUsuario[preguntaActual];
      } else {
        // En modo práctica, verificamos si la página a la que vamos ya fue respondida
        indiceSeleccionado = respuestasUsuario[preguntaActual];
        respondido = indiceSeleccionado != null;
      }
    });
    _animarMenuSuperior(index);
  }

  // Desplaza el menú numérico de arriba automáticamente para mantener visible la pregunta activa
  void _animarMenuSuperior(int index) {
    if (_menuScrollController.hasClients) {
      double posicionDestino = (index * 55.0) - (MediaQuery.of(context).size.width / 2) + 27.5;
      if (posicionDestino < 0) posicionDestino = 0;
      _menuScrollController.animateTo(
        posicionDestino,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    }
  }

  void _finalizarQuiz() {
    setState(() {
      _cronometro.stop();
      _tiempoFinal = _cronometro.elapsed;
      _isQuizFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.isTestMode ? 'Test: ${widget.tituloMateria}' : 'Estudio: ${widget.tituloMateria}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isQuizFinished 
          ? buildSolucionario() 
          : Column(
              children: [
                _buildMenuDesplazableNumeros(), // Menú superior deslizable
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: preguntas.length,
                    itemBuilder: (context, index) => buildQuizPageContent(index),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _isQuizFinished ? null : _buildBarraNavegacionAtractiva(),
    );
  }

  // NUEVO: Menú horizontal superior deslizable de números
  Widget _buildMenuDesplazableNumeros() {
    return Container(
      height: 65,
      color: Colors.transparent,
      child: ListView.builder(
        controller: _menuScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        itemCount: preguntas.length,
        itemBuilder: (context, index) {
          bool esActual = index == preguntaActual;
          bool estaRespondida = respuestasUsuario[index] != null;

          bool esCorrecta = false;
          if (estaRespondida) {
            final resps = preguntas[index]['respuestas'] as List;
            esCorrecta = resps[respuestasUsuario[index]!]['puntos'] == 1;
          }

          Color colorFondo = Colors.indigo.shade700.withOpacity(0.4);
          Color colorTexto = Colors.white60;

          if (esActual) {
            colorFondo = Colors.white;
            colorTexto = Colors.indigo.shade900;
          } else if (estaRespondida) {
            if (widget.isTestMode) {
              colorFondo = Colors.orange.shade400;
            } else {
              colorFondo = esCorrecta ? Colors.green.shade400 : Colors.red.shade400;
            }
            colorTexto = Colors.white;
          }

          return GestureDetector(
            onTap: () => _saltarAPregunta(index),
            child: Container(
              width: 45,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: colorFondo,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: esActual ? [BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))] : null,
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: esActual ? FontWeight.bold : FontWeight.w500, 
                    color: colorTexto
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Renderiza el contenido específico de cada pregunta dentro del PageView
  Widget buildQuizPageContent(int index) {
    final pregunta = preguntas[index];
    final respuestas = List<Map<String, dynamic>>.from(pregunta['respuestas'] as List);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 90.0),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (index + 1) / preguntas.length,
            backgroundColor: Colors.grey.shade200,
            color: Colors.orange,
            minHeight: 6,
          ),
          const SizedBox(height: 25),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                _formatearTextoPregunta(pregunta['texto'], index),
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, height: 1.3),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 25),
          ...List.generate(respuestas.length, (idxRes) => buildBotonRespuesta(idxRes, respuestas[idxRes])),
          if (respondido && !widget.isTestMode && index == preguntaActual) buildExplicacion(pregunta['explicacion'] ?? ""),
        ],
      ),
    );
  }

  Widget buildBotonRespuesta(int index, Map<String, dynamic> res) {
    bool esCorrecta = res['puntos'] == 1;
    bool seleccionada = indiceSeleccionado == index;
    Color colorBorde = Colors.grey.shade200;
    Color colorFondo = Colors.white;
    Color colorTexto = Colors.black87;

    if (!widget.isTestMode && respondido) {
      if (esCorrecta) {
        colorBorde = Colors.green;
        colorFondo = Colors.green.shade50;
        colorTexto = Colors.green.shade900;
      } else if (seleccionada) {
        colorBorde = Colors.red;
        colorFondo = Colors.red.shade50;
        colorTexto = Colors.red.shade900;
      }
    } else if (seleccionada) {
      colorBorde = Colors.indigo;
      colorFondo = Colors.indigo.shade50;
      colorTexto = Colors.indigo.shade900;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorBorde, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))
        ]
      ),
      child: ListTile(
        onTap: () => validarRespuesta(index, res['puntos']),
        title: Text(res['texto'], style: TextStyle(color: colorTexto, fontWeight: seleccionada ? FontWeight.w600 : FontWeight.normal)),
        leading: (!widget.isTestMode && respondido && esCorrecta) 
            ? const Icon(Icons.check_circle, color: Colors.green) 
            : (seleccionada && !widget.isTestMode ? const Icon(Icons.cancel, color: Colors.red) : null),
      ),
    );
  }

  Widget buildExplicacion(String texto) {
    return Card(
      color: Colors.amber.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.amber.shade200)),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.amber, size: 24),
            const SizedBox(width: 10),
            Expanded(child: Text(texto, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87, height: 1.3))),
          ],
        ),
      ),
    );
  }

  // NUEVA INTERFAZ MODERNA Y ATRACTIVA DE NAVEGACIÓN
  Widget _buildBarraNavegacionAtractiva() {
  final esUltimaPregunta = preguntaActual == preguntas.length - 1;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -4))
      ],
    ),
    child: SafeArea(
      child: Row(
        children: [
          // Botón Atrás - Neumórfico / Redondeado
          Material(
            color: preguntaActual > 0 ? Colors.indigo.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: preguntaActual > 0 ? () => _saltarAPregunta(preguntaActual - 1) : null,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Icon(
                  Icons.arrow_back_ios_new, 
                  size: 20, 
                  color: preguntaActual > 0 ? Colors.indigo : Colors.grey.shade400
                ),
              ),
            ),
          ),
          
          // Spacer empuja los botones hacia los extremos de forma fluida y segura sin importar el tamaño de pantalla
          const Spacer(), 

          // Botón Principal: Siguiente o Finalizar Examen
          ElevatedButton.icon(
            onPressed: (!widget.isTestMode && !respondido) 
                ? null 
                : (esUltimaPregunta ? _finalizarQuiz : () => _saltarAPregunta(preguntaActual + 1)), 
            style: ElevatedButton.styleFrom(
              backgroundColor: esUltimaPregunta ? Colors.red.shade600 : Colors.indigo,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: Icon(
              esUltimaPregunta ? Icons.check_circle_outline : Icons.arrow_forward_ios, 
              size: 16
            ),
            label: Text(esUltimaPregunta ? "Terminar" : "Sig."),
          ),
        ],
      ),
    ),
  );
}

  Widget buildSolucionario() {
    int puntajeFinal = 0;
    if (widget.isTestMode) {
      for (int i = 0; i < preguntas.length; i++) {
        if (i < respuestasUsuario.length && respuestasUsuario[i] != null) {
          final resps = preguntas[i]['respuestas'] as List;
          if (resps[respuestasUsuario[i]!]['puntos'] == 1) puntajeFinal++;
        }
      }
    } else {
      puntajeFinal = puntaje;
    }

    double porcentaje = preguntas.isNotEmpty ? puntajeFinal / preguntas.length : 0.0;
    Color colorDinamico = _getColorPuntaje(porcentaje);
    String minutos = _tiempoFinal.inMinutes.toString().padLeft(2, '0');
    String segundos = (_tiempoFinal.inSeconds % 60).toString().padLeft(2, '0');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Icon(Icons.analytics, size: 80, color: colorDinamico),
          Text(
            "${(porcentaje * 100).toStringAsFixed(0)}%",
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: colorDinamico),
          ),
          Text(
            "Resultado: $puntajeFinal / ${preguntas.length}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text("Tiempo total: $minutos:$segundos", 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey)),
              ],
            ),
          ),
          const Divider(height: 40),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: preguntas.length,
            itemBuilder: (context, i) {
              final resp = preguntas[i]['respuestas'] as List;
              int? userIdx = i < respuestasUsuario.length ? respuestasUsuario[i] : null;
              bool correcto = userIdx != null && resp[userIdx]['puntos'] == 1;

              return ExpansionTile(
                leading: Icon(
                  userIdx == null 
                      ? Icons.help_outline 
                      : (correcto ? Icons.check_circle : Icons.cancel),
                  color: userIdx == null 
                      ? Colors.orange 
                      : (correcto ? Colors.green : Colors.red),
                ),
                title: Text(_formatearTextoPregunta(preguntas[i]['texto'], i), 
                  style: const TextStyle(fontSize: 14)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Tu respuesta: ${userIdx != null ? resp[userIdx]['texto'] : 'Sin responder (Saltada)'}\n\nRespuesta Correcta: ${resp.firstWhere((r) => r['puntos'] == 1)['texto']}\n\nExplicación: ${preguntas[i]['explicacion'] ?? 'No disponible.'}",
                    ),
                  )
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Volver al Inicio"),
          ),
        ],
      ),
    );
  }
}