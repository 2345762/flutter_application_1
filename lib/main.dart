
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' if (dart.library.io) 'dart:io';

// =============================================================
// SECCIÓN DE DATOS: AQUÍ ES DONDE AGREGAS TUS PREGUNTAS
// =============================================================


final List<Map<String, Object>> poolAerodinamica = [
   {
    'texto': '1.- Si el ángulo de ataque constante y la velocidad sube al doble, la sustentación será:',
    'explicacion': r"La sustentación varía con el cuadrado de la velocidad; si la velocidad se duplica y se mantienen constantes densidad, superficie y CL, la sustentación se cuadruplica. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    'respuestas': [
      {'texto': 'La misma', 'puntos': 0},
      {'texto': 'Dos veces mayor', 'puntos': 0},
      {'texto': 'Cuatro veces mayor', 'puntos': 1},
    ],
  },
  {
    'texto': '2.- ¿Qué velocidad aérea verdadera y ángulo de ataque debiera usarse para generar la misma cantidad de sustentación a medida que aumenta la altitud?',
    'explicacion': r"Al aumentar la altitud disminuye la densidad; para mantener la misma sustentación a igual ángulo de ataque se requiere mayor velocidad aérea verdadera. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'La misma velocidad aérea verdadera y ángulo de ataque', 'puntos': 0},
     {'texto': 'Una velocidad aérea verdadera mayor para cualquier ángulo de ataque dado', 'puntos': 1},
     {'texto': 'Una velocidad aérea verdadera menor y un ángulo de ataque mayor.', 'puntos': 0},
      ]  
  },
  {
    'texto': '3.- ¿Qué factores afectan a la velocidad indicada de pérdida de sustentación, (stall)?',
    'explicacion': r"La alternativa marcada no responde técnicamente a la pregunta: la velocidad indicada de stall depende principalmente de peso, factor de carga y potencia/configuración. Revisar clave de respuesta. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Peso, factor de carga y potencia. ', 'puntos': 0},
     {'texto': 'Una velocidad aérea verdadera mayor para cualquier ángulo de ataque dado', 'puntos': 1},
     {'texto': 'Una velocidad aérea verdadera menor y un ángulo de ataque mayor.', 'puntos': 0},
      ]  
  },
  {
    'texto': '4.- ¿Qué factores afectan a la velocidad indicada de pérdida de sustentación, (stall)?',
    'explicacion': r"Bajo la velocidad de mejor L/D se requiere mayor ángulo de ataque para sostener el avión, lo que incrementa la resistencia inducida y la resistencia total. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- La resistencia aumenta debido al incremento de la resistencia inducida', 'puntos': 1},
     {'texto': 'B.- La resistencia aumenta debido al incremento de la resistencia parásita.', 'puntos': 0},
     {'texto': 'C.- La resistencia disminuye debido a una resistencia inducida menor.', 'puntos': 0},
      ]  
  },
  {
    'texto': '5.- ¿Cuál es la relación entre resistencia inducida y resistencia parásita cuando se aumenta el peso?',
    'explicacion': r"Al aumentar el peso, el ala debe generar más sustentación; esto eleva el coeficiente de sustentación requerido y aumenta principalmente la resistencia inducida. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- La resistencia parásita aumenta más que la resistencia inducida','puntos': 0},
     {'texto': 'B.- La resistencia inducida aumenta más que la resistencia parásita,','puntos': 1},
     {'texto': 'C.- Ambas resistencias aumentan igual.','puntos': 0},
     ]         
  },
  {
    'texto': '6.- Cambiando el ángulo de ataque, el piloto puede controlar:',
    'explicacion': r"El ángulo de ataque determina la sustentación y también modifica la resistencia; al variar estas fuerzas, el piloto afecta la velocidad resultante de la aeronave. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Sustentación, peso y resistencia. ','puntos': 0},
     {'texto': 'B.- Sustentación, velocidad y resistencia. ,','puntos': 1},
     {'texto': 'C.- Sustentación y velocidad pero no la resistencia. ','puntos': 0},
     ]         
  },
{
    'texto': '7.- ¿Cómo puede un avión producir la misma sustentación estando con efecto de suelo que estando sin efecto de suelo?',
    'explicacion': r"En efecto suelo disminuye la resistencia inducida y mejora la eficiencia del ala; por eso puede obtenerse igual sustentación con menor ángulo de ataque. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Con el mismo ángulo de ataque. ','puntos': 0},
     {'texto': 'B.- Con un ángulo de ataque menor. ,','puntos': 1},
     {'texto': 'C.- Con un ángulo de ataque mayor.  ','puntos': 0},
     ]         
  },
{
    'texto': '8.- ¿Qué condición de vuelo debería esperarse cuando el avión sale del efecto de tierra o de suelo?',
    'explicacion': r"Al salir del efecto suelo aumenta la resistencia inducida y se requiere mayor ángulo de ataque para sostener la misma sustentación. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Un aumento de la resistencia inducida al requerir un mayor ángulo de ataque.  ','puntos': 1},
     {'texto': 'B.- Una disminución de la resistencia parásita que permite un ángulo de ataque menor. ,','puntos': 0},
     {'texto': 'C.- Un aumento de la estabilidad dinámica.  ','puntos': 0},
     ]         
  },
  {
    'texto': '9.- ¿Qué procedimiento se recomienda para una aproximación y aterrizaje con un motor detenido?',
    'explicacion': r'Con un motor detenido, la aproximación debe mantenerse estabilizada y lo más similar posible a una normal, respetando velocidades y configuración del manual de la aeronave. Fuente: FAA, Airplane Flying Handbook, FAA-H-8083-3C, cap. 13.',
    
    'respuestas': [
     {'texto': 'A.- La trayectoria de vuelo y los procedimientos deben ser casi idénticos a los de una aproximación y aterrizaje normales.  ','puntos': 1},
     {'texto': 'B.- La altitud y velocidad deben ser considerablemente mayores que las normales a lo largo de la aproximación. ,','puntos': 0},
     {'texto': 'C.- Una aproximación normal, excepto no extender el tren de aterrizaje o flaps hasta estar sobre el umbral de la pista.   ','puntos': 0},
     ]         
  },
  {
    'texto': '10.- ¿Cuál es el motor “crítico” en un avión bimotor?',
    'explicacion': r'El motor crítico es aquel cuya falla produce el efecto más adverso en el control y performance; en bimotores convencionales suele ser el motor con menor brazo efectivo de empuje respecto del eje longitudinal. Fuente: FAA, Airplane Flying Handbook, FAA-H-8083-3C, cap. 13.',
    
    'respuestas': [
     {'texto': 'A.- Aquél con el eje de empuje o tracción más cercano al eje longitudinal del avión.','puntos': 1},
     {'texto': 'B.- La altitud y velocidad deben ser considerablemente mayores que las normales a lo largo de la aproximación. ,','puntos': 0},
     {'texto': 'C.- Aquél con el eje de empuje o tracción más alejado del eje longitudinal del avión.','puntos': 0},
     ]         
  },
  {
    'texto': '11.- ¿Bajo qué condición nunca debería practicarse “stalls” en un avión bimotor?',
    'explicacion': r'No se deben practicar stalls con un motor inoperativo porque se combinan pérdida de sustentación y empuje asimétrico, aumentando el riesgo de pérdida de control. Fuente: FAA, Airplane Flying Handbook, FAA-H-8083-3C, cap. 13.',
    
    'respuestas': [
     {'texto': 'A.- Con un motor inoperativo.','puntos': 1},
     {'texto': 'B.- Con potencia de ascenso.','puntos': 0},
     {'texto': 'C.- Con full flaps y tren de aterrizaje extendido.','puntos': 0},
     ]         
  },
  {
    'texto': '12.- ¿Qué es el factor de carga?',
    'explicacion': r"El factor de carga expresa cuántas veces el peso de la aeronave está siendo soportado por la estructura; se calcula dividiendo sustentación por peso. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Sustentación multiplicada por peso total.','puntos': 0},
     {'texto': 'B.- Sustentación restada al peso total.','puntos': 0},
     {'texto': 'C.- Sustentación dividida por peso total.','puntos': 1},
     ]         
  },
{
    'texto': '13.- Si un avión con un peso de 2.000 libras es sometido en vuelo a una carga total de 6.000 libras, su factor de carga será:',
    'explicacion': r"El factor de carga se calcula dividiendo la carga total por el peso: 6.000/2.000 = 3, por lo tanto la aeronave soporta 3 G. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- 2 G.','puntos': 0},
     {'texto': 'B.- 3 G.','puntos': 1},
     {'texto': 'C.- 9 G.','puntos': 0},
     ]         
  },
  {
    'texto': '14.- ¿De qué factor depende la carga alar durante un viraje nivelado, coordinado y en aire calmo?',
    'explicacion': r"En un viraje nivelado y coordinado, el factor de carga depende del ángulo de banqueo: a mayor banqueo, mayor sustentación requerida para mantener altitud. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Razón de viraje.','puntos': 0},
     {'texto': 'B.- Ángulo de banqueo (inclinación alar).','puntos': 1},
     {'texto': 'C.- Velocidad aérea verdadera.','puntos': 0},
     ]         
  },
{
    'texto': '15.- ¿Cuál es la relación entre la razón de viraje y el radio de viraje en un viraje con ángulo de banqueo constante pero con aumento de la velocidad?',
    'explicacion': r"Con ángulo de banqueo constante, al aumentar la velocidad el radio de viraje aumenta y la razón de viraje disminuye. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- La razón disminuye y el radio aumenta.','puntos': 1},
     {'texto': 'B.- La razón aumenta y el radio disminuye.','puntos': 0},
     {'texto': 'C.- La razón y el radio aumentan.','puntos': 0},
     ]         
  },
{
    'texto': '16.- ¿Cuál es una característica de la inestabilidad longitudinal?',
    'explicacion': r"La inestabilidad longitudinal dinámica se evidencia cuando las oscilaciones de cabeceo aumentan en vez de amortiguarse tras una perturbación. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Oscilaciones de cabeceo que crecen progresivamente.','puntos': 1},
     {'texto': 'B.- Oscilaciones de alabeo que crecen progresivamente.','puntos': 0},
     {'texto': 'C.- El avión trata constantemente de bajar la nariz (to pitch down).','puntos': 0},
     ]         
  },
{
    'texto': '17.- ¿Qué es estabilidad longitudinal dinámica?',
    'explicacion': r"La estabilidad longitudinal corresponde al comportamiento en cabeceo alrededor del eje lateral; su componente dinámica describe cómo evoluciona la respuesta en el tiempo. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Estabilidad alrededor del eje longitudinal.','puntos': 0},
     {'texto': 'B.- Estabilidad alrededor del eje lateral.','puntos': 1},
     {'texto': 'C.- Estabilidad alrededor del eje vertical.','puntos': 0},
     ]         
  },
{
    'texto': '18.- ¿Qué reacción debiera esperarse si un avión es cargado de tal manera que su C.G. quede muy cerca del máximo rango trasero permitido?',
    'explicacion': r"Un CG cercano al límite trasero reduce la estabilidad longitudinal, generando mayor tendencia a inestabilidad en cabeceo alrededor del eje lateral. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Lentitud de reacción del control de alerones.','puntos': 0},
     {'texto': 'B.- Lentitud de reacción del control de timón de dirección.','puntos': 0},
     {'texto': 'C.- Inestabilidad alrededor del eje lateral.','puntos': 1},
     ]         
  },
{
    'texto': '19.- ¿Cuáles son algunas de las características de un avión cargado con el C.G. al límite trasero?',
    'explicacion': r"La clave marcada debe revisarse: un CG trasero normalmente reduce estabilidad y puede aumentar velocidad de crucero, pero tiende a disminuir la velocidad de stall, no aumentarla. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Menor velocidad de pérdida de sustentación (stall), mayor velocidad de crucero y menor estabilidad.','puntos': 0},
     {'texto': 'B.- Mayor velocidad de pérdida de sustentación (stall), mayor velocidad de crucero y menor estabilidad.','puntos': 1},
     {'texto': 'C.- Menor velocidad de pérdida de sustentación (stall), menor velocidad de crucero y mayor estabilidad.','puntos': 0},
     ]         
  },
{
    'texto': '20.- ¿En qué rango de MACH ocurren generalmente los regímenes de vuelo subsónicos?',
    'explicacion': r"El régimen subsónico corresponde a velocidades menores que Mach 1; en clasificación básica, se considera subsónico bajo aproximadamente Mach 0,75. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Bajo .75 Mach.','puntos': 1},
     {'texto': 'B.- De .75 a 1.20 Mach.','puntos': 0},
     {'texto': 'C.- De 1.20 a 2.50 Mach.','puntos': 0},
     ]         
  },
{
    'texto': '21.- ¿Cuál es el número Mach de la corriente libre que produce la primera evidencia de flujo sónico local?',
    'explicacion': r"El Mach crítico es el Mach de corriente libre al cual aparece por primera vez flujo local sónico sobre alguna zona de la aeronave. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Número Mach Supersónico.','puntos': 0},
     {'texto': 'B.- Número Mach Transónico.','puntos': 0},
     {'texto': 'C.- Número Mach Crítico.','puntos': 1},
     ]         
  },
{
    'texto': '22.- ¿Cuál de los siguientes es considerado control auxiliar de vuelo?',
    'explicacion': r"Los flaps de borde de ataque son controles secundarios o auxiliares porque modifican la sustentación y la separación del flujo, pero no controlan directamente los ejes principales. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Timón-elevador.','puntos': 0},
     {'texto': 'B.- Timón de dirección superior.','puntos': 0},
     {'texto': 'C.- Flaps de borde de ataque.','puntos': 1},
     ]         
  },
{
    'texto': '23.- ¿Cuál de los siguientes es considerado control primario de vuelo?',
    'explicacion': r"Los alerones son controles primarios porque producen y controlan el alabeo alrededor del eje longitudinal. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Tabs.','puntos': 0},
     {'texto': 'B.- Flaps.','puntos': 0},
     {'texto': 'C.- Alerones exteriores.','puntos': 1},
     ]         
  },
{
    'texto': '24.- ¿Cuándo se usan normalmente los alerones interiores?',
    'explicacion': r"Los alerones interiores pueden operar a baja y alta velocidad porque entregan control lateral con menor torsión de punta alar que los exteriores. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Solamente en vuelo a baja velocidad.','puntos': 0},
     {'texto': 'B.- Solamente en vuelo a alta velocidad.','puntos': 0},
     {'texto': 'C.- Tanto en vuelo de baja como de alta velocidad.','puntos': 1},
     ]         
  },
{
    'texto': '25.- ¿Por qué algunos aviones equipados con alerones interiores y exteriores sólo para vuelo a baja velocidad?',
    'explicacion': r"A alta velocidad, las cargas en alerones exteriores pueden torcer la punta del ala; por eso algunos diseños limitan su uso y emplean alerones interiores. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- El incremento del área de la superficie proporciona mayor control al bajar los flap.','puntos': 0},
     {'texto': 'B.- Las cargas aerodinámicas en los alerones exteriores tienden a torcer la punta de las alas a altas velocidades.','puntos': 1},
     {'texto': 'C.- Trabar los alerones exteriores en vuelos a alta velocidad proporciona sensibilidad variable en los controles de vuelo.','puntos': 0},
     ]         
  },
{
    'texto': '26.- ¿Cuál es el propósito de los Spoilers?',
    'explicacion': r"Los spoilers interrumpen el flujo sobre el ala, reduciendo sustentación sin necesidad de aumentar la velocidad. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Aumentar la combadura (camber) del ala.','puntos': 0},
     {'texto': 'B.- Reducir la sustentación sin aumentar la velocidad.','puntos': 1},
     {'texto': 'C.- Dirigir el flujo sobre la parte superior del ala a grandes ángulos de ataque.','puntos': 0},
     ]         
  },
{
    'texto': '27.- ¿Cuál es el propósito de los ground spoilers?',
    'explicacion': r"Los ground spoilers reducen la sustentación después del toque, transfiriendo peso a las ruedas y mejorando la eficacia del frenado. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Reducir la sustentación de las alas durante el aterrizaje.','puntos': 1},
     {'texto': 'B.- Ayudar a inclinar las alas al iniciar un viraje.','puntos': 0},
     {'texto': 'C.- Aumentar la razón de descenso sin aumentar la velocidad.','puntos': 0},
     ]         
  },
{
    'texto': '28.- ¿Cuál es el propósito de los generadores de vortices instalados en las alas?',
    'explicacion': r"Los generadores de vórtices energizan la capa límite y pueden retrasar la separación asociada al flujo transónico, reduciendo efectos adversos como buffet o aumento de resistencia. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Reducir la resistencia causada por el flujo supersónico sobre porciones del ala.','puntos': 1},
     {'texto': 'B.- Incrementar el inicio de la resistencia divergente y ayudar a la efectividad de alerones a alta velocidad.','puntos': 0},
     {'texto': 'C.- Romper el flujo sobre el ala de manera que el stall progrese desde la raíz del ala hacia las puntas.','puntos': 0},
     ]         
  },
{
    'texto': '29.- ¿En qué dirección, respecto de la superficie de control primario, se mueve el compensador ajustable (trim tab) del elevador cuando la superficie de control es movida?',
    'explicacion': r"El trim tab ajustable queda fijado en la posición seleccionada; no se mueve automáticamente con cada deflexión de la superficie primaria. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- En la misma dirección.','puntos': 0},
     {'texto': 'B.- En dirección contraria.','puntos': 0},
     {'texto': 'C.- Permanece fijo para todas las posiciones.','puntos': 1},
     ]         
  },
{
    'texto': '30.- ¿Cuál es el propósito del compensador ajustable (trim tab) del elevador?',
    'explicacion': r"El trim del elevador ajusta la carga aerodinámica de la cola para compensar distintas velocidades y eliminar presión sostenida en los controles. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Proporcionar equilibrio horizontal mientras aumenta la velocidad para permitir volar sin tener que tomar los controles.','puntos': 0},
     {'texto': 'B.- Ajustar las cargas por velocidad en la cola para diferentes velocidades permitiendo fuerzas neutrales sobre los controles.','puntos': 0},
     {'texto': 'C.- Modificar la carga hacia abajo sobre la cola (downward tail load), para varias velocidades en vuelo, eliminando presiones en los controles.','puntos': 1},
     ]         
  },
{
    'texto': '31.- ¿En qué dirección, respecto de la superficie de control primario, se mueve el “anti-servo tab”?',
    'explicacion': r"El anti-servo tab se mueve en la misma dirección que la superficie primaria, aumentando la fuerza de mando y evitando sobrecontrol. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- En la misma dirección.','puntos': 1},
     {'texto': 'B.- En dirección contraria.','puntos': 0},
     {'texto': 'C.- Permanece fijo para todas las posiciones.','puntos': 0},
     ]         
  },
{
    'texto': '32.- ¿Cuál es la función primaria de los flaps de borde de ataque, en configuración de aterrizaje durante la sentada (flare) previa a tocar la pista?',
    'explicacion': r"Los dispositivos de borde de ataque retrasan la separación del flujo a altos ángulos de ataque, función clave durante fases lentas como el flare. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Impedir la separación del flujo.','puntos': 1},
     {'texto': 'B.- Disminuir la razón de descenso.','puntos': 0},
     {'texto': 'C.- Aumentar la resistencia de perfil.','puntos': 0},
     ]         
  },
{
    'texto': '33.- ¿Cuál es el propósito de los “slats” de borde de ataque en alas de alta performance?',
    'explicacion': r"Los slats canalizan aire de alta presión desde el intradós hacia el extradós, manteniendo el flujo adherido y retrasando el stall. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Disminuir la sustentación a velocidades relativamente bajas.','puntos': 0},
     {'texto': 'B.- Mejorar el control de alerones a bajos ángulos de ataque.','puntos': 0},
     {'texto': 'C.- Dirigir el aire desde el área de alta presión bajo el borde de ataque hacia la parte superior del ala.','puntos': 1},
     ]         
  },
{
    'texto': '34.- ¿Qué efecto tienen los “slots” de borde de ataque del ala en la performance del avión?',
    'explicacion': r"Los slots retrasan la separación del flujo y permiten alcanzar un ángulo de ataque de stall más alto. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Disminuye la resistencia del perfil.','puntos': 0},
     {'texto': 'B.- Cambia el ángulo de ataque de “stall” a un ángulo más alto.','puntos': 1},
     {'texto': 'C.- Desacelera la capa límite de extradós.','puntos': 0},
     ]         
  },
{
    'texto': '35.- La resistencia parásita:',
    'explicacion': r"La resistencia parásita aumenta con la velocidad porque depende de fricción, forma e interferencia del flujo alrededor de la aeronave. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Aumenta con la velocidad.','puntos': 1},
     {'texto': 'B.- Disminuye con la velocidad.','puntos': 0},
     {'texto': 'C.- No es afectada por la velocidad.','puntos': 0},
     ]         
  },
{
    'texto': '36.- La resistencia inducida es:',
    'explicacion': r"La resistencia inducida se produce al generar sustentación; es mayor a bajas velocidades y disminuye al aumentar la velocidad. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5",
    
    'respuestas': [
     {'texto': 'A.- Directamente proporcional a la velocidad.','puntos': 0},
     {'texto': 'B.- Constante.','puntos': 0},
     {'texto': 'C.- Inversamente proporcional a la velocidad.','puntos': 1},
     ]         
  },
{
    'texto': '37.- Altitud de presión es:',
    'explicacion': r"La altitud de presión es la altitud indicada cuando el altímetro se ajusta a 29,92 inHg o 1013,25 hPa. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- La indicación que marca un altímetro cuando se ha ajustado a la presión del campo.','puntos': 0},
     {'texto': 'B.- La altitud real de acuerdo a ISA.','puntos': 0},
     {'texto': 'C.- La indicación que marca un altímetro cuando se ha ajustado a 29.92 pulgadas.','puntos': 1},
     ]         
  },
{
    'texto': '38.- La sustentación producida por un perfil alar es:',
    'explicacion': r"La sustentación es la componente de la fuerza aerodinámica que actúa perpendicular a la corriente libre relativa. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- La componente de la fuerza paralela a la corriente libre de aire.','puntos': 0},
     {'texto': 'B.- La componente de la fuerza perpendicular a la corriente libre de aire.','puntos': 1},
     {'texto': 'C.- La componente de la fuerza perpendicular a la cuerda del ala.','puntos': 0},
     ]         
  },
{
    'texto': '39.- El techo de sustentación es la altitud a la que se alcanza el llamado “coffin corner” y es función de:',
    'explicacion': r"El coffin corner depende del peso porque este eleva la velocidad de stall y reduce el margen disponible frente al límite de alta velocidad/Mach. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- El ángulo de ataque del avión.','puntos': 0},
     {'texto': 'B.- El peso del avión.','puntos': 1},
     {'texto': 'C.- El empuje del avión.','puntos': 0},
     ]         
  },
{
    'texto': '40.- La velocidad del sonido:',
    'explicacion': r"La velocidad del sonido depende de la temperatura; al aumentar la altitud en la troposfera normalmente baja la temperatura y disminuye dicha velocidad. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Permanece inalterable con la altura.','puntos': 0},
     {'texto': 'B.- Disminuye con el aumento de la altura.','puntos': 1},
     {'texto': 'C.- Aumenta con el aumento de la altura.','puntos': 0},
     ]         
  },
{
    'texto': '41.- Ángulo de ataque es:',
    'explicacion': r"El ángulo de ataque es el ángulo entre la cuerda del ala y la corriente libre relativa. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- El formado por la línea de curvatura media y la cuerda del ala.','puntos': 0},
     {'texto': 'B.- El formado por la dirección de la corriente libre de aire y la línea de curvatura media.','puntos': 0},
     {'texto': 'C.- El que existe entre la cuerda del ala y la dirección de la corriente libre de aire.','puntos': 1},
     ]         
  },
{
    'texto': '42.- El efecto suelo:',
    'explicacion': r"El efecto suelo reduce la resistencia inducida cerca de la superficie, aumentando la eficiencia del ala y la sustentación efectiva. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- No afecta las características aerodinámicas del avión.','puntos': 0},
     {'texto': 'B.- Aumenta la resistencia al avance.','puntos': 0},
     {'texto': 'C.- Aumenta la sustentación.','puntos': 1},
     ]         
  },
{
    'texto': '43.- El hidroplaneo se produce cuando la pista esta mojada o contaminada. Uno de los aspectos que más influye es:',
    'explicacion': r"El hidroplaneo dinámico depende de la película de agua que separa neumático y pista; un mayor espesor aumenta el riesgo de pérdida de contacto. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- Grado de rugosidad de la pista.','puntos': 0},
     {'texto': 'B.- Espesor de la capa de agua.','puntos': 1},
     {'texto': 'C.- Ancho de los neumáticos.','puntos': 0},
     ]         
  },
{
    'texto': '44.- Las cargas a que está sometida un ala, además de las fuerzas aerodinámicas que se desarrollan en ella, dependen de:',
    'explicacion': r"Las cargas alares dependen no solo de fuerzas aerodinámicas, sino también del peso del ala, fuselaje, combustible y su distribución estructural. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- El peso propio del ala y el peso del fuselaje.','puntos': 0},
     {'texto': 'B.- El peso del ala, el peso del fuselaje (estructura y contenido), el peso del combustible y la distribución de éste.','puntos': 1},
     {'texto': 'C.- Solamente las fuerzas aerodinámicas y no los pesos estructurales.','puntos': 0},
     ]         
  },
{
    'texto': '45.- El fenómeno conocido como Dutch-Roll:',
    'explicacion': r"El Dutch Roll ocurre cuando la estabilidad lateral es alta en relación con la estabilidad direccional, produciendo oscilación combinada de guiñada y alabeo. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Se produce cuando el avión tiene una estabilidad lateral pequeña comparada con la estabilidad direccional.','puntos': 0},
     {'texto': 'B.- Se produce cuando el avión tiene una estabilidad lateral grande comparada con la estabilidad direccional.','puntos': 1},
     {'texto': 'C.- Afecta en menor proporción a los aviones con alas de ángulo flecha.','puntos': 0},
     ]         
  },
{
    'texto': '46.- El agua es un fluido:',
    'explicacion': r'El agua se trata como prácticamente incompresible en aplicaciones aeronáuticas e hidráulicas porque su volumen varía muy poco bajo presión. Fuente: FAA, Aviation Maintenance Technician Handbook—General, FAA-H-8083-30, cap. 12.',
    
    'respuestas': [
     {'texto': 'A.- Más compresible que el aire.','puntos': 0},
     {'texto': 'B.- Menos compresible que el aire.','puntos': 0},
     {'texto': 'C.- Incompresible.','puntos': 1},
     ]         
  },
  {
    'texto': '47.- La extensión de flaps:',
    'explicacion': r"Al extender flaps aumenta el CL disponible; para una misma sustentación y velocidad, puede requerirse menor ángulo de ataque. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Aumenta considerablemente ángulo de planeo.','puntos': 0},
     {'texto': 'B.- Disminuye el ángulo de ataque.','puntos': 1},
     {'texto': 'C.- Aumenta considerablemente el CL max.','puntos': 0},
     ]         
  },
{
    'texto': '48.- La altitud de presión que marca un altímetro cuando se ha reglado a nivel del mar con 29.92 pulgadas de Hg o 1013 hPa:',
    'explicacion': r"Con reglaje estándar, el altímetro indica altitud de presión, que rara vez coincide con la altitud real salvo condiciones atmosféricas estándar. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- Será igual a la altitud real.','puntos': 0},
     {'texto': 'B.- Será distinta a la altitud real.','puntos': 0},
     {'texto': 'C.- Rara vez coincidirá con la altitud real.','puntos': 1},
     ]         
  },
{
    'texto': '49.- Si a una altitud dada, la temperatura es superior a la estándar, la densidad será:',
    'explicacion': r"A temperatura superior a la estándar, el aire es menos denso; por eso la densidad real queda por debajo de la densidad tipo. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- Inferior a la Densidad Tipo.','puntos': 1},
     {'texto': 'B.- Superior a la Densidad Tipo.','puntos': 0},
     {'texto': 'C.- La Densidad Tipo no será afectada.','puntos': 0},
     ]         
  },
{
    'texto': '50.- Si a una altitud dada, con el altímetro ajustado a 29.92, la temperatura de la atmósfera es menor que la de la Atmósfera Tipo, el altímetro indicará:',
    'explicacion': r"En aire más frío que estándar, las superficies de presión están más juntas; el altímetro puede indicar más altura que la real. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- Una altitud mayor que la real.','puntos': 1},
     {'texto': 'B.- Una altitud inferior a la real.','puntos': 0},
     {'texto': 'C.- La temperatura no afecta al altímetro.','puntos': 0},
     ]         
  },
{
    'texto': '51.- La velocidad del sonido:',
    'explicacion': r"La velocidad del sonido depende directamente de la temperatura absoluta; si la temperatura disminuye, también disminuye la velocidad del sonido. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Disminuye si la temperatura disminuye.','puntos': 1},
     {'texto': 'B.- Disminuye si la temperatura aumenta.','puntos': 0},
     {'texto': 'C.- La temperatura no afecta a la velocidad del sonido.','puntos': 0},
     ]         
  },
{
    'texto': '52.- La resistencia parásita se puede definir como aquella parte dela resistencia que:',
    'explicacion': r"La resistencia parásita es la parte de la resistencia total que no participa en producir sustentación; incluye forma, fricción e interferencia. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- No está relacionada con la resistencia estructural.','puntos': 0},
     {'texto': 'B.- Contribuye a originar sustentación.','puntos': 0},
     {'texto': 'C.- No contribuye a originar sustentación.','puntos': 1},
     ]         
  },
{
    'texto': '53.- Con un aumento del ángulo de ataque, el centro de presiones:',
    'explicacion': r"En perfiles convencionales, al aumentar el ángulo de ataque el centro de presión tiende a desplazarse hacia adelante. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Se moverá hacia atrás.','puntos': 0},
     {'texto': 'B.- No se moverá.','puntos': 0},
     {'texto': 'C.- Se moverá hacia delante.','puntos': 1},
     ]         
  },
{
    'texto': '54.- La velocidad a la que comienza a ocurrir el hidroplaneo depende de:',
    'explicacion': r"La velocidad de hidroplaneo dinámico depende principalmente de la presión de inflado del neumático, según la fórmula aproximada 9√P. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- Peso del avión.','puntos': 0},
     {'texto': 'B.- Presión de los neumáticos.','puntos': 1},
     {'texto': 'C.- Velocidad de aterrizaje.','puntos': 0},
     ]         
  },
{
    'texto': '55.- El método más efectivo para detener un avión afectado por hidroplaneo es:',
    'explicacion': r'Durante hidroplaneo el frenado pierde eficacia; el reverso de empuje ayuda a desacelerar porque no depende del contacto neumático-pista. Fuente: FAA, Airplane Flying Handbook, FAA-H-8083-3C, cap. 9.',
    
    'respuestas': [
     {'texto': 'A.- Aplicar full frenado.','puntos': 0},
     {'texto': 'B.- Uso de reversos.','puntos': 1},
     {'texto': 'C.- Sólo usar spoilers.','puntos': 0},
     ]         
  },
{
    'texto': '56.- La fórmula para calcular la resistencia total es:',
    'explicacion': r"La resistencia total se calcula como D = CD · q · S, donde q es la presión dinámica y S la superficie de referencia. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- D = CL * ½ ???V2 * S','puntos': 0},
     {'texto': 'B.- D = CL * q * S','puntos': 0},
     {'texto': 'C.- D = CD * q * S','puntos': 1},
     ]         
  },
{
    'texto': '57.- La resistencia de fricción es producida por:',
    'explicacion': r"La resistencia de fricción surge del rozamiento viscoso dentro de la capa límite entre el aire y la superficie de la aeronave. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- La corriente de aire que se produce en la punta del ala desde el intradós al extradós.','puntos': 0},
     {'texto': 'B.- La fuerza de rozamiento que se produce entre las diferentes capas que conforman la capa límite.','puntos': 1},
     {'texto': 'C.- El impacto de la corriente libre en el borde de ataque del ala.','puntos': 0},
     ]         
  },
{
    'texto': '58.- La altitud de densidad:',
    'explicacion': r"La altitud de densidad es la altitud ISA equivalente para la densidad existente; en atmósfera estándar coincide con la altitud real. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- Es igual a la altitud real cuando la atmósfera sea la tipo (estándar).','puntos': 1},
     {'texto': 'B.- Es mayor a menor temperatura.','puntos': 0},
     {'texto': 'C.- No depende de la temperatura; sólo de la humedad atmosférica.','puntos': 0},
     ]         
  },
{
    'texto': '59.- El número Mach es:',
    'explicacion': r"El número Mach es la razón entre la velocidad de la corriente libre o aeronave y la velocidad local del sonido. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Igual a la velocidad del sonido dividida por la velocidad de la corriente libre de aire.','puntos': 0},
     {'texto': 'B.- Igual a la velocidad de la corriente libre de aire dividida por la velocidad del sonido.','puntos': 1},
     {'texto': 'C.- Igual a la velocidad del sonido dividida por la temperatura del aire al nivel de vuelo.','puntos': 0},
     ]         
  },
{
    'texto': '60.- El punto donde efectivamente está aplicada la sustentación en un ala, se denomina:',
    'explicacion': r"El centro de presión es el punto donde se considera aplicada la resultante aerodinámica, incluida la sustentación, sobre el perfil. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Centro efectivo de la sustentación.','puntos': 0},
     {'texto': 'B.- Centro aerodinámico.','puntos': 0},
     {'texto': 'C.- Centro de presión.','puntos': 1},
     ]         
  },
{
    'texto': '61.- Cuerda media es....',
    'explicacion': r"La cuerda media indicada corresponde a la distancia entre borde de ataque y borde de fuga medida en la mitad del ala, según la definición usada en la pregunta. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 3.",
    
    'respuestas': [
     {'texto': 'A.- aquella que multiplicada por la envergadura da como resultado la superficie del ala.','puntos': 0},
     {'texto': 'B.- la distancia entre el borde de ataque y el borde de fuga, medida en la mitad del ala.','puntos': 1},
     {'texto': 'C.- la distancia del espesor máximo de un perfil de ala.','puntos': 0},
     ]         
  },
{
    'texto': '62.- La resistencia inducida.....',
    'explicacion': r"La resistencia inducida depende de la sustentación; por ello se relaciona directamente con el coeficiente de sustentación del ala. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- está relacionada con el coeficiente de sustentación de un ala.','puntos': 1},
     {'texto': 'B.- está relacionada con el coeficiente de fricción de un ala.','puntos': 0},
     {'texto': 'C.- es producto de la placa plana equivalente o coeficiente de resistencia al avance de una aeronave.','puntos': 0},
     ]         
  },
{
    'texto': '63.- El Dutch Roll, o balanceo del holandés, se origina cuando:',
    'explicacion': r"El Dutch Roll se origina por acoplamiento de guiñada y alabeo, favorecido por gran efecto diedro y estabilidad direccional relativamente baja. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Existe en el avión un gran efecto del diedro (mucha estabilidad lateral) junto con poco plano vertical de cola.','puntos': 1},
     {'texto': 'B.- Existe en el avión pequeño efecto diedro junto con poco plano vertical de cola.','puntos': 0},
     {'texto': 'C.- Existe en el avión mucho ángulo flecha y mucho plano vertical de cola.','puntos': 0},
     ]         
  },
{
    'texto': '64.- El sistema creado, entre otros, para evitar el Dutch Roll (balanceo del holandés) se conoce como:',
    'explicacion': r"El yaw damper amortigua oscilaciones de guiñada y ayuda a suprimir el Dutch Roll. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 7.",
    
    'respuestas': [
     {'texto': 'A.- Spoilers.','puntos': 0},
     {'texto': 'B.- Buffet Dumper.','puntos': 0},
     {'texto': 'C.- Yaw Damper.','puntos': 1},
     ]         
  },
{
    'texto': '65.- Se estima que un avión ha alcanzado su “techo de servicio” cuando su máxima razón de ascenso no es mayor de:',
    'explicacion': r"El techo de servicio se define comúnmente como la altitud donde la razón máxima de ascenso disponible cae a 100 ft/min. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- 300 pies por minuto.','puntos': 0},
     {'texto': 'B.- 200 pies por minuto.','puntos': 0},
     {'texto': 'C.- 100 pies por minuto.','puntos': 1},
     ]         
  },
{
    'texto': '66.- La mínima velocidad a que un avión es capaz de despegar las ruedas del suelo y seguir volando, y que es algo mayor que la velocidad de pérdida, se conoce por la abreviatura:',
    'explicacion': r'VMU es la Minimum Unstick Speed: la menor velocidad a la que el avión puede despegar las ruedas del suelo y continuar el despegue. Fuente: 14 CFR §25.107.',
    
    'respuestas': [
     {'texto': 'A.- V2','puntos': 0},
     {'texto': 'B.- VMU','puntos': 1},
     {'texto': 'C.- VR','puntos': 0},
     ]         
  },
{
    'texto': '67.- La velocidad segura de despegue y ascenso inicial, y que se debe alcanzar antes de los 35 pies sobre la pista, se identifica por la abreviatura:',
    'explicacion': r'V2 es la velocidad de seguridad de despegue, que debe alcanzarse para asegurar el ascenso inicial y cumplir los márgenes de performance. Fuente: 14 CFR §25.107.',
    
    'respuestas': [
     {'texto': 'A.- V2','puntos': 1},
     {'texto': 'B.- VMU','puntos': 0},
     {'texto': 'C.- VR','puntos': 0},
     ]         
  },
{
    'texto': '68.- El aviso de pérdida (stall) conocido como “stick shaker”, ocurre aproximadamente:',
    'explicacion': r'El stick shaker entrega advertencia antes del stall para permitir recuperación; el margen aproximado indicado en la pregunta corresponde a 7% sobre la velocidad de pérdida. Fuente: FAA, Airplane Flying Handbook, FAA-H-8083-3C, cap. 5.',
    
    'respuestas': [
     {'texto': 'A.- Un 7% sobre la velocidad de stall.','puntos': 1},
     {'texto': 'B.- Un 15% sobre la velocidad de stall.','puntos': 0},
     {'texto': 'C.- Un 30 % sobre la velocidad de stall.','puntos': 0},
     ]         
  },
{
    'texto': '69.- Existen varios tipos de hidroplaneo y en este fenómeno intervienen diversos parámetros, pero la velocidad a que comienza a producirse el hidroplaneo depende de:',
    'explicacion': r"La velocidad de inicio del hidroplaneo dinámico depende principalmente de la presión de inflado del neumático; se estima con 9√P. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 11.",
    
    'respuestas': [
     {'texto': 'A.- La presión de inflado del neumático.','puntos': 1},
     {'texto': 'B.- La velocidad de rotación del neumático.','puntos': 0},
     {'texto': 'C.- La raíz cuadrada del espesor de la película de agua sobre la cual se produce el hidroplaneo medida en milímetros.','puntos': 0},
     ]         
  },
];

final List<Map<String, Object>> poolperformanceymotores = [
 {
        'texto': '1.- Marque cuáles son, en la debida secuencia, las fases termodinámicas de un motor turborreactor:',
        'explicacion': 'Concepto teórico: el motor turborreactor trabaja bajo el ciclo Brayton abierto. La ruta del aire y energía es admisión, compresión, combustión, expansión en turbina y escape por la tobera; por eso la secuencia correcta es Admisión, compresión, combustión, expansión y escape.',
        'respuestas': [
            {'texto': 'A.- Difusión, expansión, compresión, combustión, escape.', 'puntos': 0},
            {'texto': 'B.- Admisión, compresión, combustión, expansión, escape.', 'puntos': 1},
            {'texto': 'C.- Aspiración, compresión, combustión, expansión, escape.', 'puntos': 0},
        ],
    },
    {
        'texto': '2.- ¿Qué parte de un motor turborreactor está sujeta a las más altas temperaturas?',
        'explicacion': 'Concepto teórico: la zona de mayor temperatura se encuentra a la entrada de la turbina, inmediatamente después de la cámara de combustión. Allí los gases alcanzan la TIT y comienzan a entregar energía a los álabes de turbina, por lo que la respuesta correcta es Entrada de la turbina.',
        'respuestas': [
            {'texto': 'A.- Descarga del compresor', 'puntos': 0},
            {'texto': 'B.- Toberas de atomización (inyección) del combustible.', 'puntos': 0},
            {'texto': 'C.- Entrada de la turbina (TIT / Turbine Inlet Temperature).', 'puntos': 1},
        ],
    },
    {
        'texto': '3.- ¿Qué efecto tiene una alta temperatura ambiente en el empuje en un motor de turbina?',
        'explicacion': 'Concepto teórico: al aumentar la temperatura ambiente disminuye la densidad del aire. Con menor densidad entra menos masa de aire al compresor por unidad de tiempo y el motor puede producir menos empuje; por eso el empuje se reduce.',
        'respuestas': [
            {'texto': 'A.- El empuje se reducirá debido a la disminución de la densidad del aire.', 'puntos': 1},
            {'texto': 'B.- El empuje permanecerá igual, pero la temperatura de la turbina será más alta.', 'puntos': 0},
            {'texto': 'C.- El empuje será mayor porque más energía calórica será extractada del aire más caliente.', 'puntos': 0},
        ],
    },
    {
        'texto': '4.- ¿Qué efecto tiene una alta humedad relativa en la potencia máxima de los motores de las aeronaves modernas?',
        'explicacion': 'Concepto teórico: en motores modernos el efecto de la humedad sobre la potencia o empuje máximo es secundario frente a temperatura, presión-altitud y densidad. En este ítem la alternativa aceptada indica que ni turborreactores ni recíprocos son afectados de forma determinante para el cálculo solicitado.',
        'respuestas': [
            {'texto': 'A.- Ni los motores turborreactores ni los motores recíprocos son afectados.', 'puntos': 1},
            {'texto': 'B.- Los motores recíprocos experimentarán una mayor pérdida de BHP que los de turbinas.', 'puntos': 0},
            {'texto': 'C.- Los motores turborreactores experimentarán una significativa pérdida de empuje.', 'puntos': 0},
        ],
    },
    {
        'texto': '5.- Indique qué partes de un motor turborreactor están sometidas a las más altas temperaturas y a cambios rápidos de estas temperaturas:',
        'explicacion': 'Concepto teórico: los álabes de turbina reciben gases calientes directamente desde la cámara de combustión y además sufren variaciones rápidas de temperatura durante cambios de régimen. Por eso son los componentes más exigidos térmicamente.',
        'respuestas': [
            {'texto': 'A.- Los alabes de las turbinas.', 'puntos': 1},
            {'texto': 'B.- Los alabes de los compresores.', 'puntos': 0},
            {'texto': 'C.- La tobera de escape.', 'puntos': 0},
        ],
    },
    {
        'texto': '6.- Los motores turborreactores provistos de compresores axiales dobles emplean indicadores de N1 y N2. Indique cuál de estos instrumentos corresponde al compresor de baja relación de compresión:',
        'explicacion': 'Concepto teórico: en un turborreactor de doble eje, N1 representa el conjunto de baja presión, asociado al fan o compresor de baja. Por eso el instrumento correspondiente al compresor de baja relación de compresión es N1.',
        'respuestas': [
            {'texto': 'A.- N1', 'puntos': 1},
            {'texto': 'B.- N2', 'puntos': 0},
            {'texto': 'C.- N1, y el instrumento marca el número de revoluciones por minuto a que gira el compresor.', 'puntos': 0},
        ],
    },
    {
        'texto': '7.- Los motores turborreactores provistos de compresores axiales dobles emplean indicadores de N1 y N2. Indique cuál de estos instrumentos corresponde al compresor de alta relación de compresión:',
        'explicacion': 'Concepto teórico: en un motor de doble eje, N2 corresponde al conjunto de alta presión, asociado al compresor de alta y su turbina. Por eso el indicador del compresor de alta relación de compresión es N2.',
        'respuestas': [
            {'texto': 'A.- N1', 'puntos': 0},
            {'texto': 'B.- N2', 'puntos': 1},
            {'texto': 'C.- N1, y el instrumento marca el número de revoluciones por minuto a que gira el compresor.', 'puntos': 0},
        ],
    },
    {
        'texto': '8.- Los indicadores de N1 y N2 de los motores del tipo turbinas reciben la indicación desde el motor mediante...',
        'explicacion': 'Concepto teórico: las indicaciones N1 y N2 se obtienen mediante sensores o generadores de impulsos electromagnéticos que detectan la velocidad de giro del eje correspondiente. No se transmiten por varillas ni cables mecánicos.',
        'respuestas': [
            {'texto': 'A.- Sistemas de engranajes y varillas transmisoras provenientes de los compresores del motor.', 'puntos': 0},
            {'texto': 'B.- Generadores de impulsos electromagnéticos.', 'puntos': 1},
            {'texto': 'C.- Cables cuyo núcleo gira y mueve la aguja del instrumento.', 'puntos': 0},
        ],
    },
    {
        'texto': '9.- Las aeronaves de última generación utilizan EICAS que dan la información de funcionamiento al piloto mediante:',
        'explicacion': 'Concepto teórico: el EICAS integra parámetros de motor y alertas en pantallas electrónicas de cabina. En la terminología clásica del material, estas pantallas se describen como tubos catódicos, por eso esa es la alternativa correcta.',
        'respuestas': [
            {'texto': 'A.- Pantallas de tubos catódicos.', 'puntos': 1},
            {'texto': 'B.- Información digital con base de funcionamiento electro-mecánica.', 'puntos': 0},
            {'texto': 'C.- Instrumentos eléctricos convencionales digitales.', 'puntos': 0},
        ],
    },
    {
        'texto': '10.- Marque la aseveración correcta con relación a los motores turborreactores:',
        'explicacion': 'Concepto teórico: la humedad afecta menos al turborreactor que al motor alternativo, porque el empuje del turborreactor depende principalmente del flujo másico de aire, compresión y temperatura límite. La densidad y temperatura siguen siendo factores relevantes.',
        'respuestas': [
            {'texto': 'A.- Son afectados por la humedad atmosférica en menor proporción que los motores alternos de explosión.', 'puntos': 1},
            {'texto': 'B.- Casi no son afectados por la mayor altura de densidad.', 'puntos': 0},
            {'texto': 'C.- Se caracterizan por el alto consumo específico de combustible a altas RPM del motor.', 'puntos': 0},
        ],
    },
    {
        'texto': '11.- Indique cuál es el área que corresponde al compresor de baja de un motor turborreactor de doble flujo.',
        'explicacion': 'Ruta visual: 1. Abre las Figuras 126 y 127 del Material de Apoyo, donde aparece el esquema numerado del motor de doble flujo. 2. Sigue el flujo de aire desde la entrada hacia el primer conjunto compresor de baja presión. 3. Identifica el número marcado sobre esa zona. El área correspondiente al compresor de baja es 1.',
        "imagenes": ["assets/figura126yfigura127.jpg"],
        'respuestas': [
            {'texto': 'A.- 1', 'puntos': 1},
            {'texto': 'B.- 2', 'puntos': 0},
            {'texto': 'C.- 3', 'puntos': 0},
        ],
    },
    {
        'texto': '12.- Indique cuál es el área que corresponde al compresor de alta de un motor turborreactor de doble flujo.',
        'explicacion': 'Ruta visual: 1. En las Figuras 126 y 127 ubica el esquema del motor de doble flujo. 2. Avanza desde el compresor de baja hacia el núcleo del motor, donde el aire ya comprimido entra al compresor de alta. 3. Lee el número asignado a esa sección. El área del compresor de alta es 3.',
        "imagenes": ["assets/figura126yfigura127.jpg"],
        'respuestas': [
            {'texto': 'A.- 1', 'puntos': 0},
            {'texto': 'B.- 3', 'puntos': 1},
            {'texto': 'C.- 6', 'puntos': 0},
        ],
    },
    {
        'texto': '13.- Indique cuál es el área que corresponde a la turbina de alta de un motor turborreactor de doble flujo.',
        'explicacion': 'Ruta visual: 1. En las Figuras 126 y 127 localiza la cámara de combustión y luego observa el primer conjunto de turbina inmediatamente posterior. 2. Esa turbina extrae energía para mover el compresor de alta. 3. El número marcado para la turbina de alta es 4.',
        "imagenes": ["assets/figura126yfigura127.jpg"],
        'respuestas': [
            {'texto': 'A.- 3', 'puntos': 0},
            {'texto': 'B.- 4', 'puntos': 1},
            {'texto': 'C.- 5', 'puntos': 0},
        ],
    },
    {
        'texto': '14.- La VMCG es función general de:',
        'explicacion': 'Concepto teórico: la VMCG depende de la capacidad direccional en tierra ante falla del motor crítico. Por eso varía con temperatura, presión-altitud, configuración de flaps y viento cruzado, factores que modifican empuje, control direccional y aceleración.',
        'respuestas': [
            {'texto': 'A.- La temperatura, presión-altitud, flaps, y viento cruzado.', 'puntos': 1},
            {'texto': 'B.- El peso del avión, la temperatura, presión atmosférica y flaps.', 'puntos': 0},
            {'texto': 'C.- Número de motores, densidad, peso y viento cruzado.', 'puntos': 0},
        ],
    },
    {
        'texto': '15.- La velocidad de decisión de abortar o continuar un despegue, se denomina:',
        'explicacion': 'Concepto teórico: V1 es la velocidad de decisión. Hasta V1 se puede abortar dentro de la distancia calculada; después de V1 se continúa el despegue salvo condiciones muy críticas. Por eso la respuesta correcta es V1.',
        'respuestas': [
            {'texto': 'A.- V1', 'puntos': 1},
            {'texto': 'B.- V2', 'puntos': 0},
            {'texto': 'C.- VR', 'puntos': 0},
        ],
    },
    {
        'texto': '16.- La velocidad V1 debe ser:',
        'explicacion': 'Concepto teórico: V1 no puede ser menor que VMCG, porque si falla el motor crítico bajo VMCG la aeronave no tendría control direccional suficiente en tierra. Por eso V1 debe ser igual o mayor que VMCG.',
        'respuestas': [
            {'texto': 'A.- Igual o menor que VMCG', 'puntos': 0},
            {'texto': 'B.- Mayor que VMU', 'puntos': 0},
            {'texto': 'C.- Igual o mayor que VMCG', 'puntos': 1},
        ],
    },
    {
        'texto': '17.- Cuando la distancia para alcanzar V1 y la necesaria para continuar tras falla de motor hasta 35 pies son iguales, se opera con pista...',
        'explicacion': 'Concepto teórico: se habla de pista compensada cuando la distancia para acelerar y detenerse hasta V1 es igual a la distancia para continuar el despegue con falla de motor y alcanzar 35 ft. Esa igualdad define el criterio balanceado o compensado.',
        'respuestas': [
            {'texto': 'A.- compensada.', 'puntos': 1},
            {'texto': 'B.- equivalente.', 'puntos': 0},
            {'texto': 'C.- crítica.', 'puntos': 0},
        ],
    },
    {
        'texto': '18.- La distancia necesaria para acelerar hasta V1 y, ante falla del motor crítico, continuar y alcanzar 35 pies a V2, se llama:',
        'explicacion': 'Concepto teórico: esta distancia corresponde al caso de falla del motor crítico en V1 y continuación del despegue hasta 35 ft a V2. En performance se denomina distancia de despegue con un motor inoperativo.',
        'respuestas': [
            {'texto': 'A.- Recorrido de despegue mínimo.', 'puntos': 0},
            {'texto': 'B.- Distancia de despegue con un motor inoperativo.', 'puntos': 1},
            {'texto': 'C.- Solamente, distancia de despegue.', 'puntos': 0},
        ],
    },
    {
        'texto': '19.- ¿Cuál es el nombre de un plano al final de pista, sin obstrucciones, considerado para performances de despegue?',
        'explicacion': 'Concepto teórico: el Clearway es un área libre de obstáculos situada después del extremo de pista y utilizable para cumplir la trayectoria de despegue. No sirve para detener el avión, sino para considerar ascenso libre de obstáculos.',
        'respuestas': [
            {'texto': 'A.- Clearway (Zona Libre de Obstáculos).', 'puntos': 1},
            {'texto': 'B.- Stopway (Zona de Parada).', 'puntos': 0},
            {'texto': 'C.- Obstruction Clearence Plane (Plano Libre de Obstáculos).', 'puntos': 0},
        ],
    },
    {
        'texto': '20.- ¿Qué es un área identificada por el término "Stopway" (Zona de Parada)?',
        'explicacion': 'Concepto teórico: Stopway es un área en la prolongación de la pista, al menos tan ancha como ella, preparada para soportar la desaceleración de un despegue abortado sin daño estructural. Por eso se asocia al accelerate-stop.',
        'respuestas': [
            {'texto': 'A.- Un área, al menos del mismo ancho de la pista, con capacidad para soportar una aeronave durante un despegue normal.', 'puntos': 0},
            {'texto': 'B.- Un área, en la prolongación de la pista y al menos tan ancha como ésta, designada para desaceleración de un despegue abortado.', 'puntos': 1},
            {'texto': 'C.- Un área, no necesariamente tan ancha como la pista, con capacidad para soportar un despegue abortado.', 'puntos': 0},
        ],
    },
    {
        'texto': '21.- Indique a qué segmento de despegue corresponde la siguiente condición: potencia de despegue, tren de aterrizaje extendido, flaps de despegue y V2:',
        'explicacion': 'Concepto teórico: el primer segmento comienza al despegar y se extiende hasta que el tren queda retraído. En este tramo se mantiene potencia de despegue, tren extendido inicialmente, flaps de despegue y velocidad V2.',
        'respuestas': [
            {'texto': 'A.- 1° segmento.', 'puntos': 1},
            {'texto': 'B.- 2° segmento.', 'puntos': 0},
            {'texto': 'C.- 3° segmento.', 'puntos': 0},
        ],
    },
    {
        'texto': '22.- Indique a qué segmento de despegue corresponde la siguiente condición: potencia de despegue, tren de aterrizaje arriba (replegado), flaps de despegue y V2:',
        'explicacion': 'Concepto teórico: el segundo segmento inicia con el tren arriba y continúa con flaps de despegue y V2. Es crítico porque la aeronave debe cumplir gradiente con un motor inoperativo y alta resistencia por configuración.',
        'respuestas': [
            {'texto': 'A.- 1° segmento.', 'puntos': 0},
            {'texto': 'B.- 2° segmento.', 'puntos': 1},
            {'texto': 'C.- 3° segmento.', 'puntos': 0},
        ],
    },
    {
        'texto': '23.- Los requisitos que se deben cumplir durante los segmentos de despegue, consideran...',
        'explicacion': 'Concepto teórico: los requisitos de segmentos de despegue certifican la trayectoria con falla de motor crítico en V1 o después de V1. Por eso se evalúa la capacidad de continuar el despegue con un motor inoperativo.',
        'respuestas': [
            {'texto': 'A.- Que todos los motores estén operando a potencia de despegue.', 'puntos': 0},
            {'texto': 'B.- La falla de un motor a o después de V1.', 'puntos': 1},
            {'texto': 'C.- La falla de un motor a o después de VR.', 'puntos': 0},
        ],
    },
    {
        'texto': '24.- Considerando los requisitos de pendiente de ascenso tras falla de motor, el segmento más exigente (% de pendiente) es:',
        'explicacion': 'Concepto teórico: el segundo segmento es normalmente el más exigente porque exige cumplir el gradiente mínimo con tren arriba, flaps de despegue y un motor inoperativo. Es el punto crítico de performance de ascenso inicial.',
        'respuestas': [
            {'texto': 'A.- El primer segmento.', 'puntos': 0},
            {'texto': 'B.- El segundo segmento.', 'puntos': 1},
            {'texto': 'C.- El tercer segmento.', 'puntos': 0},
        ],
    },
    {
        'texto': '25.- El cálculo de la distancia de aterrizaje considera que el avión pasa sobre el umbral de la pista a una altura de:',
        'explicacion': 'Concepto teórico: para el cálculo de distancia de aterrizaje certificada, la aeronave cruza el umbral a 50 ft sobre la pista. Desde esa altura se considera la transición, contacto y frenado hasta detenerse.',
        'respuestas': [
            {'texto': 'A.- 15 pies.', 'puntos': 0},
            {'texto': 'B.- 35 pies.', 'puntos': 0},
            {'texto': 'C.- 50 pies.', 'puntos': 1},
        ],
    },
    {
        'texto': '26.- ¿Qué se entiende por "Drift Down"?',
        'explicacion': 'Concepto teórico: Drift Down es el perfil de descenso que sigue una aeronave después de la falla de un motor, manteniendo potencia máxima continua en los motores restantes hasta alcanzar una altitud sostenible.',
        'respuestas': [
            {'texto': 'A.- Descenso en caso de falla de motor con el resto de los motores a potencia de ralentí.', 'puntos': 0},
            {'texto': 'B.- Descenso en caso de falla de motor con la potencia de crucero.', 'puntos': 0},
            {'texto': 'C.- Descenso en caso de falla de motor con potencia máxima continua en el o los motores restantes.', 'puntos': 1},
        ],
    },
    {
        'texto': '27.- Normalmente la velocidad mínima de aterrizaje debe ser:',
        'explicacion': 'Concepto teórico: la velocidad mínima de aterrizaje se basa normalmente en VREF, que se aproxima a 1,30 veces la velocidad de pérdida en configuración de aterrizaje. Ese margen asegura control y protección contra stall.',
        'respuestas': [
            {'texto': 'A.- 1.15 Vs.', 'puntos': 0},
            {'texto': 'B.- 1.30 Vs', 'puntos': 1},
            {'texto': 'C.- 1.45 Vs.', 'puntos': 0},
        ],
    },
    {
        'texto': '28.- ¿Cuáles son las velocidades V1, VR y V2 para las condiciones de operación G-3? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'Ruta visual: 1. En la Figura 81 identifica las condiciones de operación G-3. 2. Con esos datos entra a la Figura 82 para obtener las velocidades de despegue. 3. Verifica la configuración en la Figura 83. La lectura final entrega V1 134 kt, VR 139 kt y V2 145 kt.',
        "imagenes": ["assets/figura81.jpg", "assets/figura82.jpg", "assets/figura83.jpg"],
        'respuestas': [
            {'texto': 'A.- 134, 134 y 145 Nudos.', 'puntos': 0},
            {'texto': 'B.- 134, 139 y 145 Nudos.', 'puntos': 1},
            {'texto': 'C.- 132, 132 y 145 Nudos.', 'puntos': 0},
        ],
    },
    {
        'texto': '29.- ¿Cuáles son las velocidades V1 y V2 para las condiciones de operación G-4? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'Ruta visual: 1. Busca la condición G-4 en la Figura 81. 2. Lleva el peso, configuración y datos de operación a la tabla o gráfico de velocidades de la Figura 82. 3. Comprueba el ajuste asociado en la Figura 83. El resultado correcto es V1 132 kt y V2 146 kt.',
        "imagenes": ["assets/figura81.jpg", "assets/figura82.jpg", "assets/figura83.jpg"],
        'respuestas': [
            {'texto': 'A.- 133 y 145 Nudos.', 'puntos': 0},
            {'texto': 'B.- 127 y 141 Nudos.', 'puntos': 0},
            {'texto': 'C.- 132 y 146 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '30.- ¿Cuál es la velocidad segura de despegue para las condiciones de operación R-1? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Ruta visual: 1. En la Figura 53 ubica la condición de operación R-1. 2. Con los datos de peso, pista y configuración, entra a la Figura 54 de velocidades. 3. Usa la Figura 55 para confirmar el ajuste asociado. La velocidad segura de despegue V2 es 133 kt.',
        "imagenes": ["assets/figura53.jpg", "assets/figura54.jpg", "assets/figura55.jpg"],
        'respuestas': [
            {'texto': 'A.- 128 Nudos.', 'puntos': 0},
            {'texto': 'B.- 121 Nudos.', 'puntos': 0},
            {'texto': 'C.- 133 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '31.- ¿Cuál es la velocidad de rotación para las condiciones de operación R-2? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Ruta visual: 1. Ubica la condición R-2 en la Figura 53. 2. Cruza los datos de esa condición en la Figura 54, donde se obtienen las velocidades de despegue. 3. Selecciona la columna o curva de VR. La velocidad de rotación resultante es 147 kt.',
        "imagenes": ["assets/figura53.jpg", "assets/figura54.jpg", "assets/figura55.jpg"],
        'respuestas': [
            {'texto': 'A.- 146 Nudos.', 'puntos': 0},
            {'texto': 'B.- 147 Nudos.', 'puntos': 1},
            {'texto': 'C.- 152 Nudos.', 'puntos': 0},
        ],
    },
    {
        'texto': '32.- ¿Cuál es V1, VR y V2 para las condiciones de operación R-3? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Ruta visual: 1. Busca R-3 en la Figura 53 y toma los datos de operación. 2. En la Figura 54 lee las velocidades V1, VR y V2 para esa condición. 3. Verifica consistencia con la Figura 55. El resultado es V1 136 kt, VR 138 kt y V2 143 kt.',
        "imagenes": ["assets/figura53.jpg", "assets/figura54.jpg", "assets/figura55.jpg"],
        'respuestas': [
            {'texto': 'A.- 143, 143 y 147 Nudos.', 'puntos': 0},
            {'texto': 'B.- 138, 138 y 142 Nudos.', 'puntos': 0},
            {'texto': 'C.- 136, 138 y 143 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '33.- ¿Cuál es la velocidad de rotación y V2 para las condiciones de operación R-5? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Ruta visual: 1. Identifica la condición R-5 en la Figura 53. 2. Entra a la Figura 54 y lee las velocidades de rotación y seguridad de despegue para esa condición. 3. Confirma con la Figura 55. El resultado es VR 134 kt y V2 141 kt.',
        "imagenes": ["assets/figura53.jpg", "assets/figura54.jpg", "assets/figura55.jpg"],
        'respuestas': [
            {'texto': 'A.- 138 y 143 Nudos.', 'puntos': 0},
            {'texto': 'B.- 136 y 138 Nudos.', 'puntos': 0},
            {'texto': 'C.- 134 y 141 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '34.- ¿Cuáles son V1 y VR para las condiciones de operación A-1? (Ref. Fig. 45, 46 y 47).',
        'explicacion': 'Ruta visual: 1. En la Figura 45 ubica la condición A-1. 2. Lleva los datos de operación a la Figura 46, donde se leen las velocidades de despegue. 3. Usa la Figura 47 para confirmar la configuración. La lectura correcta es V1 122.3 kt y VR 124.1 kt.',
        "imagenes": ["assets/figura44yfigura45.jpg", "assets/figura46.jpg", "assets/figura47.jpg"],
        'respuestas': [
            {'texto': 'A.- V1 123.1 Nudos; VR 125.2 Nudos.', 'puntos': 0},
            {'texto': 'B.- V1 120.5 Nudos; VR 123.5 Nudos.', 'puntos': 0},
            {'texto': 'C.- V1 122.3 Nudos; VR 124.1 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '35.- ¿Cuáles son V1 y VR para las condiciones de operación A-2? (Ref. Fig. 45, 46 y 47).',
        'explicacion': 'Ruta visual: 1. Ubica la condición A-2 en la Figura 45. 2. Con sus datos de peso, configuración y pista, entra a la Figura 46. 3. Lee las columnas o curvas de V1 y VR y verifica en la Figura 47. El resultado es V1 127.4 kt y VR 133.6 kt.',
        "imagenes": ["assets/figura44yfigura45.jpg", "assets/figura46.jpg", "assets/figura47.jpg"],
        'respuestas': [
            {'texto': 'A.- V1 129.7 Nudos; VR 134.0 Nudos.', 'puntos': 0},
            {'texto': 'B.- V1 127.2 Nudos; VR 133.2 Nudos.', 'puntos': 0},
            {'texto': 'C.- V1 127.4 Nudos; VR 133.6 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '36.- ¿Cuál es V1 y VR para las condiciones de operación A-5? (Ref. Fig. 45, 46 y 47).',
        'explicacion': 'Ruta visual: 1. Busca A-5 en la Figura 45. 2. Traslada sus condiciones a la Figura 46 de velocidades de despegue. 3. Lee V1 y VR en la misma condición. Ambas coinciden en 106.4 kt.',
        "imagenes": ["assets/figura44yfigura45.jpg", "assets/figura46.jpg", "assets/figura47.jpg"],
        'respuestas': [
            {'texto': 'A.- V1 110.4 Nudos; VR 110.9 Nudos.', 'puntos': 0},
            {'texto': 'B.- V1 109.6 Nudos; VR 112.7 Nudos.', 'puntos': 0},
            {'texto': 'C.- V1 106.4 Nudos; VR 106.4 Nudos.', 'puntos': 1},
        ],
    },
    {
        'texto': '37.- ¿Cuál es el máximo EPR de despegue para las condiciones de operación G-1? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'Ruta visual: 1. En la Figura 81 identifica la condición G-1. 2. Usa la Figura 82 para confirmar el régimen de despegue aplicable. 3. En la Figura 83 lee el EPR máximo por motor. El resultado es motores 1 y 3 con EPR 2.22 y motor 2 con EPR 2.16.',
        "imagenes": ["assets/figura81.jpg", "assets/figura82.jpg", "assets/figura83.jpg"],
        'respuestas': [
            {'texto': 'A.- Motores 1 y 3, 2.22; motor 2, 2.16.', 'puntos': 1},
            {'texto': 'B.- Motores 1 y 3, 2.22; motor 2, 2.21.', 'puntos': 0},
            {'texto': 'C.- Motores 1 y 3, 2.15; motor 2, 2.09.', 'puntos': 0},
        ],
    },
    {
        'texto': '38.- ¿Cuál es el máximo EPR de despegue para las condiciones de operación G-3? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'Ruta visual: 1. Localiza G-3 en la Figura 81. 2. Con sus datos entra a la Figura 83, tabla o gráfico de EPR de despegue. 3. Lee el valor diferenciado por motores. El resultado es motores 1 y 3 EPR 2.14 y motor 2 EPR 2.10.',
        "imagenes": ["assets/figura81.jpg", "assets/figura82.jpg", "assets/figura83.jpg"],
        'respuestas': [
            {'texto': 'A.- Motores 1 y 3, 2.08; motor 2, 2.05.', 'puntos': 0},
            {'texto': 'B.- Motores 1 y 3, 2.14; motor 2, 2.10.', 'puntos': 1},
            {'texto': 'C.- Motores 1 y 3, 2.18; motor 2, 2.07.', 'puntos': 0},
        ],
    },
    {
        'texto': '39.- ¿Cuál es el máximo EPR de despegue para las condiciones de operación G-4? (Ref. Fig. 81, 82 y 83).',
        'explicacion': 'Ruta visual: 1. Ubica G-4 en la Figura 81. 2. Lleva esa condición a la Figura 83 para leer el EPR máximo de despegue. 3. Confirma la configuración con la Figura 82. El resultado es EPR 2.24 para motores 1, 2 y 3.',
        "imagenes": ["assets/figura81.jpg", "assets/figura82.jpg", "assets/figura83.jpg"],
        'respuestas': [
            {'texto': 'A.- Motores 1 y 3, 2.23; motor 2, 2.21.', 'puntos': 0},
            {'texto': 'B.- Motores 1 y 3, 2.26; motor 2, 2.25.', 'puntos': 0},
            {'texto': 'C.- Motores 1 y 3, 2.24; motor 2, 2.24.', 'puntos': 1},
        ],
    },
    {
        'texto': '40.- ¿Cuál es el EPR de despegue para las condiciones de operación R-1? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Ruta visual: 1. Busca la condición R-1 en la Figura 53. 2. Con la condición de temperatura, altitud y configuración, entra a la Figura 55 de ajuste EPR. 3. Lee el EPR de despegue correspondiente. El valor correcto es 2.035.',
        "imagenes": ["assets/figura53.jpg", "assets/figura54.jpg", "assets/figura55.jpg"],
        'respuestas': [
            {'texto': 'A.- 2.04', 'puntos': 0},
            {'texto': 'B.- 2.01', 'puntos': 0},
            {'texto': 'C.- 2.035.', 'puntos': 1},
        ],
    },
    {
        'texto': '41.- ¿Cuál es el EPR de despegue para las condiciones de operación R-2? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Ruta visual: 1. Ubica R-2 en la Figura 53. 2. Traslada sus datos a la Figura 55, correspondiente al EPR de despegue. 3. Intersecta la condición indicada y lee el valor final. El EPR correcto es 2.16.',
        "imagenes": ["assets/figura53.jpg", "assets/figura54.jpg", "assets/figura55.jpg"],
        'respuestas': [
            {'texto': 'A.- 2.19.', 'puntos': 0},
            {'texto': 'B.- 2.18.', 'puntos': 0},
            {'texto': 'C.- 2.16.', 'puntos': 1},
        ],
    },
    {
        'texto': '42.- ¿Cuál es el EPR de despegue para las condiciones de operación R-5? (Ref. Fig. 53, 54 y 55).',
        'explicacion': 'Ruta visual: 1. Identifica la condición R-5 en la Figura 53. 2. Entra a la Figura 55 con esa condición de operación. 3. Lee el valor de EPR de despegue asociado. El resultado correcto es 1.96.',
        "imagenes": ["assets/figura53.jpg", "assets/figura54.jpg", "assets/figura55.jpg"],
        'respuestas': [
            {'texto': 'A.- 1.98.', 'puntos': 0},
            {'texto': 'B.- 1.95.', 'puntos': 0},
            {'texto': 'C.- 1.96.', 'puntos': 1},
        ],
    },
    {
        'texto': '43.- ¿Cuál es la distancia terrestre recorrida durante el ascenso en ruta para las condiciones de operación W-2? (Ref. Fig. 48, 49 y 50).',
        'explicacion': 'Ruta visual: 1. En la Figura 48 identifica los datos de la condición W-2. 2. En la Figura 49 sigue el perfil de ascenso en ruta usando peso inicial, temperatura y altitud. 3. En la Figura 50 lee la distancia terrestre recorrida durante el ascenso. El resultado es 79.4 NM.',
        "imagenes": ["assets/figura48yfigura49.jpg", "assets/figura50.jpg"],
        'respuestas': [
            {'texto': 'A.- 85.8 Millas Náuticas.', 'puntos': 0},
            {'texto': 'B.- 87.8 Millas Náuticas.', 'puntos': 0},
            {'texto': 'C.- 79.4 Millas Náuticas.', 'puntos': 1},
        ],
    },
    {
        'texto': '44.- ¿Cuál es la distancia terrestre recorrida durante el ascenso en ruta para las condiciones de operación W-5? (Ref. Fig. 48, 49 y 50).',
        'explicacion': 'Ruta visual: 1. Ubica W-5 en la Figura 48. 2. Lleva los datos de esa condición al gráfico de ascenso en ruta de la Figura 49. 3. Proyecta la lectura hacia la escala de distancia en la Figura 50. La distancia terrestre recorrida es 66.4 NM.',
        "imagenes": ["assets/figura48yfigura49.jpg", "assets/figura50.jpg"],
        'respuestas': [
            {'texto': 'A.- 68.0 Millas Náuticas.', 'puntos': 0},
            {'texto': 'B.- 73.9 Millas Náuticas.', 'puntos': 0},
            {'texto': 'C.- 66.4 Millas Náuticas.', 'puntos': 1},
        ],
    },
    {
        'texto': '45.- ¿Cuál es el peso del avión al término del ascenso para las condiciones de operación W-2? (Ref. Fig. 48, 49 y 50).',
        'explicacion': 'Ruta visual: 1. En la Figura 48 toma el peso inicial y condiciones W-2. 2. Usa la Figura 49 para determinar el combustible consumido en el ascenso. 3. Resta ese combustible al peso inicial y verifica en la Figura 50. El peso al término del ascenso es 83.800 lb.',
        "imagenes": ["assets/figura48yfigura49.jpg", "assets/figura50.jpg"],
        'respuestas': [
            {'texto': 'A.- 82.775 Lbs', 'puntos': 0},
            {'texto': 'B.- 83.650 Lbs.', 'puntos': 0},
            {'texto': 'C.- 83.800 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '46.- ¿Cuál es el peso del avión al término del ascenso para las condiciones de operación W-3? (Referencia Figuras 48, 49 y 50).',
        'explicacion': 'Ruta visual: 1. Identifica W-3 en la Figura 48. 2. Lee en la Figura 49 el consumo de combustible correspondiente al ascenso. 3. Resta ese consumo al peso inicial de la condición y comprueba en la Figura 50. El peso final es 75.900 lb.',
        "imagenes": ["assets/figura48yfigura49.jpg", "assets/figura50.jpg"],
        'respuestas': [
            {'texto': 'A.- 75.750 Lbs.', 'puntos': 0},
            {'texto': 'B.- 75.900 Lbs.', 'puntos': 1},
            {'texto': 'C.- 76.100 Lbs.', 'puntos': 0},
        ],
    },
    {
        'texto': '47.- ¿Cuál es el peso del avión al término del ascenso para las condiciones de operación W-5? (Referencia Figuras 48, 49 y 50).',
        'explicacion': 'Ruta visual: 1. Busca la condición W-5 en la Figura 48. 2. Determina en la Figura 49 el combustible requerido durante el ascenso. 3. Descuenta ese combustible del peso inicial y confirma la lectura en la Figura 50. El peso al término del ascenso es 90.000 lb.',
        "imagenes": ["assets/figura48yfigura49.jpg", "assets/figura50.jpg"],
        'respuestas': [
            {'texto': 'A.- 89.900 Lbs.', 'puntos': 0},
            {'texto': 'B.- 90.000 Lbs', 'puntos': 1},
            {'texto': 'C.- 90.100 Lbs.', 'puntos': 0},
        ],
    },
    {
        'texto': '48.- ¿Cuál es la distancia terrestre recorrida durante el ascenso en ruta para las condiciones de operación V-5? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Ruta visual: 1. Ubica V-5 en la Figura 56. 2. Entra al gráfico de ascenso de la Figura 57 con las condiciones de peso, temperatura y altitud. 3. Proyecta hasta la escala de distancia de la Figura 58. La distancia terrestre recorrida es 61 NM.',
        "imagenes": ["assets/figura56yfigura57.jpg", "assets/figura58.jpg"],
        'respuestas': [
            {'texto': 'A.- 70 Millas Náuticas.', 'puntos': 0},
            {'texto': 'B.- 47 Millas Náuticas.', 'puntos': 0},
            {'texto': 'C.- 61 Millas Náuticas.', 'puntos': 1},
        ],
    },
    {
        'texto': '49.- ¿Cuánto combustible se consume durante el ascenso en ruta en las condiciones de operación V-1? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Ruta visual: 1. En la Figura 56 identifica la condición V-1. 2. Con esos datos entra a la Figura 57 y sigue la trayectoria de ascenso hasta la altitud de crucero. 3. Lee el combustible consumido en la escala correspondiente de la Figura 58. El consumo es 4.000 lb.',
        "imagenes": ["assets/figura56yfigura57.jpg", "assets/figura58.jpg"],
        'respuestas': [
            {'texto': 'A.- 4.100 Lbs.', 'puntos': 0},
            {'texto': 'B.- 3.600 Lbs.', 'puntos': 0},
            {'texto': 'C.- 4.000 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '50.- ¿Cuánto combustible se consume durante el ascenso en ruta en las condiciones de operación V-2? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Ruta visual: 1. Busca la condición V-2 en la Figura 56. 2. Usa la Figura 57 para seguir el perfil de ascenso con los datos de operación. 3. Lee el consumo de combustible en la Figura 58. El combustible consumido es 2.400 lb.',
        "imagenes": ["assets/figura56yfigura57.jpg", "assets/figura58.jpg"],
        'respuestas': [
            {'texto': 'A.- 2.250 Lbs.', 'puntos': 0},
            {'texto': 'B.- 2.600 Lbs.', 'puntos': 0},
            {'texto': 'C.- 2.400 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '51.- ¿Cuál es el peso del avión al término del ascenso en las condiciones de operación V-3? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Ruta visual: 1. Ubica V-3 en la Figura 56 y toma el peso inicial. 2. Determina el combustible de ascenso con las Figuras 57 y 58. 3. Resta el consumo al peso inicial. El peso al término del ascenso es 82.200 lb.',
        "imagenes": ["assets/figura56yfigura57.jpg", "assets/figura58.jpg"],
        'respuestas': [
            {'texto': 'A.- 82.100 Lbs.', 'puntos': 0},
            {'texto': 'B.- 82.500 Lbs.', 'puntos': 0},
            {'texto': 'C.- 82.200 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '52.- ¿Cuál es el peso del avión al término del ascenso en las condiciones de operación V-5? (Referencia Figuras 56, 57 y 58).',
        'explicacion': 'Ruta visual: 1. Identifica V-5 en la Figura 56. 2. Usa la Figura 57 para obtener el combustible consumido durante el ascenso. 3. Descuenta ese consumo al peso inicial y verifica en la Figura 58. El peso final es 72.800 lb.',
        "imagenes": ["assets/figura56yfigura57.jpg", "assets/figura58.jpg"],
        'respuestas': [
            {'texto': 'A.- 73.000 Lbs.', 'puntos': 0},
            {'texto': 'B.- 72.900 Lbs.', 'puntos': 0},
            {'texto': 'C.- 72.800 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '53.- ¿Cuál es el EPR máximo de ascenso para las condiciones de operación T-1? (Referencia Figuras 59 y 60).',
        'explicacion': 'Ruta visual: 1. En la Figura 59 ubica las condiciones de operación T-1. 2. Entra a la Figura 60 con temperatura, altitud y régimen de ascenso. 3. Lee el EPR máximo de ascenso en la escala correspondiente. El valor correcto es 1.96.',
        "imagenes": ["assets/figura59yfigura60.jpg"],
        'respuestas': [
            {'texto': 'A.- 1.82.', 'puntos': 0},
            {'texto': 'B.- 1.96.', 'puntos': 1},
            {'texto': 'C.- 2.04.', 'puntos': 0},
        ],
    },
    {
        'texto': '54.- ¿Cuál es el EPR máximo de ascenso para las condiciones de operación T-4? (Referencia Figuras 59 y 60).',
        'explicacion': 'Ruta visual: 1. Busca la condición T-4 en la Figura 59. 2. Traslada sus parámetros a la Figura 60 de EPR máximo de ascenso. 3. Intersecta las líneas de temperatura y altitud aplicables. La lectura final es EPR 2.06.',
        "imagenes": ["assets/figura59yfigura60.jpg"],
        'respuestas': [
            {'texto': 'A.- 2.20.', 'puntos': 0},
            {'texto': 'B.- 2.07.', 'puntos': 0},
            {'texto': 'C.- 2.06.', 'puntos': 1},
        ],
    },
    {
        'texto': '55.- ¿Qué factor debe disminuir para obtener un máximo alcance, a medida que el peso disminuye?',
        'explicacion': 'Concepto teórico: para máximo alcance en turborreactores, al disminuir el peso se requiere menos sustentación y menor empuje para mantener vuelo eficiente. Por eso la velocidad aérea óptima debe disminuir progresivamente.',
        'respuestas': [
            {'texto': 'A.- Ángulo de ataque.', 'puntos': 0},
            {'texto': 'B.- Altitud.', 'puntos': 0},
            {'texto': 'C.- Velocidad aérea.', 'puntos': 1},
        ],
    },
    {
        'texto': '56.- ¿Con qué procedimiento se obtiene la performance de máximo alcance de un avión turborreactor, a medida que el peso del avión disminuye?',
        'explicacion': 'Concepto teórico: a medida que disminuye el peso, el avión puede mantener máximo alcance subiendo a una altitud más eficiente o reduciendo la velocidad. Esto mantiene una relación sustentación-resistencia favorable para el consumo específico.',
        'respuestas': [
            {'texto': 'A.- Aumentando la velocidad o la altura.', 'puntos': 0},
            {'texto': 'B.- Aumentando la altura o disminuyendo la velocidad.', 'puntos': 1},
            {'texto': 'C.- Aumentando la velocidad o disminuyendo la altitud.', 'puntos': 0},
        ],
    },
    {
        'texto': '57.- ¿Cuál es el símbolo correcto para la velocidad de stall o la mínima velocidad de vuelo estable a que un avión es controlable.',
        'explicacion': 'Concepto teórico: VS es el símbolo general de la velocidad de pérdida o mínima velocidad de vuelo estable en la cual el avión sigue siendo controlable. VS0 y VS1 son variantes según configuración.',
        'respuestas': [
            {'texto': 'A.- VS0', 'puntos': 0},
            {'texto': 'B.- VS', 'puntos': 1},
            {'texto': 'C.- VS1', 'puntos': 0},
        ],
    },
    {
        'texto': '58.- ¿Cuál es el símbolo correcto para la velocidad mínima de vuelo estable o velocidad de pérdida en configuración de aterrizaje?',
        'explicacion': 'Concepto teórico: VS0 representa la velocidad de pérdida en configuración de aterrizaje, normalmente con tren y flaps en posición de aterrizaje. Por eso es la velocidad mínima estable en configuración landing.',
        'respuestas': [
            {'texto': 'A.- Vs', 'puntos': 0},
            {'texto': 'B.- VSi', 'puntos': 0},
            {'texto': 'C.- VS0', 'puntos': 1},
        ],
    },
    {
        'texto': '59.- ¿Qué efecto tienen en la velocidad terrestre de aterrizaje los aeropuertos de gran elevación, en comparación con similares condiciones de temperatura, viento y peso del avión?',
        'explicacion': 'Concepto teórico: a mayor elevación disminuye la densidad del aire. Para una misma velocidad indicada de aproximación, la velocidad verdadera y por lo tanto la velocidad terrestre son mayores, aumentando la carrera de aterrizaje.',
        'respuestas': [
            {'texto': 'A.- Más alta que a baja elevación.', 'puntos': 1},
            {'texto': 'B.- Más baja que a baja elevación.', 'puntos': 0},
            {'texto': 'C.- La misma que a baja elevación.', 'puntos': 0},
        ],
    },
    {
        'texto': '60.- ¿Cómo deben aplicarse los reversos en aviones turborreactores para reducir la distancia de aterrizaje?',
        'explicacion': 'Concepto teórico: el reverso es más efectivo a alta velocidad porque la energía cinética y el flujo relativo son mayores justo después del contacto. Por eso debe aplicarse inmediatamente después del touchdown.',
        'respuestas': [
            {'texto': 'A.- Inmediatamente después del contacto con la pista.', 'puntos': 1},
            {'texto': 'B.- Inmediatamente antes del aterrizaje.', 'puntos': 0},
            {'texto': 'C.- Después de aplicar máximo frenado de las ruedas.', 'puntos': 0},
        ],
    },
    {
        'texto': '61.- Indique qué definiría mejor el término Hidroplaneo Viscoso.',
        'explicacion': 'Concepto teórico: el hidroplaneo viscoso ocurre cuando una película delgada de humedad, goma, aceite u otro contaminante reduce el contacto efectivo neumático-pista. No requiere una capa profunda de agua.',
        'respuestas': [
            {'texto': 'A.- el avión se desliza sobre agua detenida.', 'puntos': 0},
            {'texto': 'B.- el avión se desliza sobre una capa de humedad que cubre las partes pintadas o con goma en la pista.', 'puntos': 1},
            {'texto': 'C.- los neumáticos del avión se deslizan sobre una mezcla de vapor y goma derretida.', 'puntos': 0},
        ],
    },
    {
        'texto': '62.- ¿Qué condición dará como resultado la distancia de aterrizaje más corta con un peso de 132.500 Lbs.? (Referencia Figuras 88 y 89).',
        'explicacion': 'Ruta visual: 1. En las Figuras 88 y 89 compara las curvas de pista seca y pista mojada para 132.500 lb. 2. Revisa las configuraciones de frenado disponibles: frenos, spoilers y reverso. 3. La curva que entrega menor distancia es pista seca usando frenos y reverso.',
        "imagenes": ["assets/figura88.jpg", "assets/figura89.jpg"],
        'respuestas': [
            {'texto': 'A.- Pista seca usando frenos y reverso.', 'puntos': 1},
            {'texto': 'B.- Pista seca usando frenos y spoilers.', 'puntos': 0},
            {'texto': 'C.- Pista mojada usando frenos spoilers y reverso.', 'puntos': 0},
        ],
    },
    {
        'texto': '63.- ¿Cuál es el peso máximo de aterrizaje que permitirá detenerse a 2000 pies del final de una pista seca de 5400 pies de largo, con reversos y spoilers inoperativos? (Referencia Figura 88).',
        'explicacion': 'Ruta visual: 1. En la Figura 88 calcula primero la distancia disponible: 5.400 ft de pista menos 2.000 ft que deben quedar libres, disponible 3.400 ft. 2. Entra al gráfico de pista seca con reversos y spoilers inoperativos. 3. Busca la intersección con 3.400 ft y proyecta hacia la escala de peso. El peso máximo es 139.500 lb.',
        "imagenes": ["assets/figura88.jpg"],
        'respuestas': [
            {'texto': 'A.- 117.500 Lbs.', 'puntos': 0},
            {'texto': 'B.- 136.900 Lbs.', 'puntos': 0},
            {'texto': 'C.- 139.500 Lbs.', 'puntos': 1},
        ],
    },
    {
        'texto': '64.- ¿Cuántos pies quedarán remanentes luego de aterrizar en una pista mojada de 6.000 pies con reversos inoperativos y 122.000 Lbs. de peso? (Referencia Figura 89).',
        'explicacion': 'Ruta visual: 1. En la Figura 89 selecciona pista mojada con reversos inoperativos. 2. Entra con el peso de aterrizaje de 122.000 lb y lee la distancia requerida de aterrizaje. 3. Resta esa distancia a los 6.000 ft disponibles. El remanente es 3.150 ft.',
        "imagenes": ["assets/figura89.jpg"],
        'respuestas': [
            {'texto': 'A.- 2200', 'puntos': 0},
            {'texto': 'B.- 2750', 'puntos': 0},
            {'texto': 'C.- 3150', 'puntos': 1},
        ],
    },
    {
        'texto': '65.- ¿Cuál es la distancia de transición al aterrizar en una pista con hielo (icy runway) y con 134.000 Lbs. de peso? (Referencia Figura 90).',
        'explicacion': 'Ruta visual: 1. En la Figura 90 selecciona la condición de pista con hielo. 2. Ingresa con el peso de aterrizaje de 134.000 lb. 3. Lee la sección de distancia de transición antes del frenado efectivo. La distancia de transición es 950 ft.',
        "imagenes": ["assets/figura90.jpg"],
        'respuestas': [
            {'texto': 'A.- 400 pies.', 'puntos': 0},
            {'texto': 'B.- 950 pies.', 'puntos': 1},
            {'texto': 'C.- 1350 pies.', 'puntos': 0},
        ],
    },
    {
        'texto': '66.- ¿Cuál es el peso máximo de aterrizaje que permitirá detener el avión 500 pies antes del final de una pista con hielo (Icy) y de 5200 pies de largo?. (Referencia Figura 90).',
        'explicacion': 'Ruta visual: 1. En la Figura 90 determina la distancia máxima utilizable: 5.200 ft de pista menos 500 ft de margen, disponible 4.700 ft. 2. Entra al gráfico de pista con hielo. 3. Proyecta desde 4.700 ft hacia la escala de peso máximo. El peso permitido es 137.000 lb.',
        "imagenes": ["assets/figura90.jpg"],
        'respuestas': [
            {'texto': 'A.- 150.000 Lbs.', 'puntos': 0},
            {'texto': 'B.- 137.000 Lbs.', 'puntos': 1},
            {'texto': 'C.- 155.000 Lbs.', 'puntos': 0},
        ],
    },
    {
        'texto': '67.- ¿Cuánto es la distancia de aterrizaje en una pista contaminada con hielo, con reversos inoperativos y con un peso de 125.000 Lbs. (Referencia Figura 90).',
        'explicacion': 'Ruta visual: 1. En la Figura 90 selecciona pista contaminada con hielo y reversos inoperativos. 2. Ingresa con peso de aterrizaje de 125.000 lb. 3. Proyecta hasta la escala de distancia total de aterrizaje. La distancia requerida es 5.800 ft.',
        "imagenes": ["assets/figura90.jpg"],
        'respuestas': [
            {'texto': 'A.- 4.500 pies', 'puntos': 0},
            {'texto': 'B.- 4.750 pies', 'puntos': 0},
            {'texto': 'C.- 5.800 pies', 'puntos': 1},
        ],
    },
    {
        'texto': '68.- ¿Cuánto se reducirá la distancia de aterrizaje usando 15º de flaps en lugar de 0º, con un peso de aterrizaje de 119.000 Lbs.? (Referencia Figura 91).',
        'explicacion': 'Ruta visual: 1. En la Figura 91 entra con peso de aterrizaje 119.000 lb. 2. Lee la distancia de aterrizaje con flaps 0 grados. 3. Lee luego la distancia con flaps 15 grados y compara ambas lecturas. La reducción obtenida es 800 ft.',
        "imagenes": ["assets/figura91.jpg"],
        'respuestas': [
            {'texto': 'A.- 500 pies', 'puntos': 0},
            {'texto': 'B.- 800 pies', 'puntos': 1},
            {'texto': 'C.- 2.700 pies', 'puntos': 0},
        ],
    },
    {
        'texto': '69.- Marque cuáles son, en la debida secuencia, las componentes fundamentales de un motor turborreactor:',
        'explicacion': 'Concepto teórico: las partes fundamentales siguen el flujo del aire y gases por el motor: difusor de entrada, compresor, cámara de combustión, turbina y tobera de escape. Esa es la arquitectura básica del turborreactor.',
        'respuestas': [
            {'texto': 'A.- Difusor, compresor, cámara de combustión, turbina (s), toberas de escape.', 'puntos': 1},
            {'texto': 'B.- Compresor, cámara de combustión, difusor, turbina (s), tobera de escape.', 'puntos': 0},
            {'texto': 'C.- Difusor, turbina (s), cámara de combustión, tobera de escape.', 'puntos': 0},
        ],
    },
    {
        'texto': '70.- En la operación de aviones turborreactores comerciales, en el despegue la V2 debe alcanzarse:',
        'explicacion': 'Concepto teórico: en despegue, V2 es la velocidad segura que debe estar alcanzada antes de cruzar la pantalla de 35 ft. Esto asegura margen de control y gradiente con falla de motor crítico.',
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
  "explicacion": "El espacio aéreo ATS chileno se clasifica operacionalmente en clases A, B, C, D, E y G, de acuerdo con la clasificación publicada para los servicios ATS. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 1.4.",
  "respuestas": [
    {"texto": "A.- Clase A, B, C y D.", "puntos": 0},
    {"texto": "B.- Clase A, B, C, D y E.", "puntos": 0},
    {"texto": "C.- Clase A, B, C, D, E y G.", "puntos": 1}
  ]
},
{
  "texto": "2.- El espacio aéreo clasificado como clase A tiene los siguientes requisitos de utilización:",
  "explicacion": "En espacio aéreo Clase A solo se admiten vuelos IFR; todos reciben servicio de control de tránsito aéreo y separación entre sí. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 1.4.",
  "respuestas": [
    {"texto": "A.- Sólo se permiten vuelos IFR, todos los vuelos están sujetos al servicio de control de tránsito aéreo y están separados unos de otros.", "puntos": 1},
    {"texto": "B.- Se permiten vuelos IFR y VFR, todos los vuelos están sujetos al servicio de control de tránsito aéreo y están separados unos de otros.", "puntos": 0},
    {"texto": "C.- Se permiten vuelos IFR y VFR y reciben servicio de información, si lo requieren.", "puntos": 0}
  ]
},
{
  "texto": "3.- El espacio aéreo clasificado como clase E tiene los siguientes requisitos de utilización:",
  "explicacion": "En Clase E se permiten vuelos IFR y VFR; los IFR están controlados y separados de otros IFR, y se entrega información de tránsito según sea factible. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 1.4.",
  "respuestas": [
    {"texto": "A.- Se permiten vuelos IFR, todos los vuelos están sujetos al servicio de control de tránsito aéreo y están separados unos de otros.", "puntos": 0},
    {"texto": "B.- Se permiten vuelos IFR y VFR; los vuelos IFR están sujetos al servicio de control de tránsito aéreo y están separados de otros vuelos IFR. Todos los vuelos reciben información de tránsito en la medida de lo factible.", "puntos": 1},
    {"texto": "C.- Se permiten sólo vuelos IFR y éstos están limitados a 250 nudos por debajo de 3.050 metros (FL 100) AMSL.", "puntos": 0}
  ]
},
{
  "texto": "4.- Las aerovías, tanto inferiores como superiores a FL 19.5, se encuentran clasificadas en el espacio aéreo ATS como:",
  "explicacion": "Las aerovías publicadas en Chile corresponden a espacio aéreo controlado Clase E, según la clasificación ATS nacional. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 1.4 y ENR 3.",
  "respuestas": [
    {"texto": "A.- Clase E.", "puntos": 1},
    {"texto": "B.- Clase A.", "puntos": 0},
    {"texto": "C.- Clase G.", "puntos": 0}
  ]
},
{
  "texto": "5.- Las zonas de control (CTR), que es el espacio aéreo controlado que se extiende hacia arriba desde la superficie terrestre hasta un límite superior especificado, se encuentran clasificadas como espacio aéreo.....",
  "explicacion": "Las CTR son espacios aéreos controlados establecidos desde la superficie y en Chile se clasifican como Clase D. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 1.4 y ENR 2.1.",
  "respuestas": [
    {"texto": "A.- Clase D.", "puntos": 1},
    {"texto": "B.- Clase G.", "puntos": 0},
    {"texto": "C.- Clase E.", "puntos": 0}
  ]
},
{
  "texto": "6.- ¿Cuáles espacios aéreos ATS, denominados alfabéticamente, tienen para su utilización limitaciones de velocidad máxima (250 nudos por debajo de 3.050 metros / 10.000 pies AMSL)?",
  "explicacion": "La restricción de 250 kt bajo 10.000 ft AMSL aplica a las clases C, D, E y G conforme a las reglas de vuelo publicadas. Fuente: DGAC Chile, DAN 91 Vol. I y AIP Chile Vol. I, ENR 1.4.",
  "respuestas": [
    {"texto": "A.- A, B, C y D.", "puntos": 0},
    {"texto": "B.- C, D, E y F.", "puntos": 0},
    {"texto": "C.- C, D, E y G.", "puntos": 1}
  ]
},
{
  "texto": "7.- En las Regiones de Información de Vuelo (FIR) que proporcionan servicio de radar, todas las aeronaves deben encender su equipo respondedor (transponder) en el modo y clave que el respectivo ACC les asigne. Cuando no se les haya asignado un modo determinado lo harán en el modo:",
  "explicacion": "Cuando no se asigna una clave específica, el código 2000 se utiliza como clave transponder estándar en espacio aéreo controlado. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 1.6.",
  "respuestas": [
    {"texto": "A.- 7500.", "puntos": 0},
    {"texto": "B.- 2100.", "puntos": 0},
    {"texto": "C.- 2000.", "puntos": 1}
  ]
},
{
  "texto": "8.- El mínimo estándar de visibilidad para el despegue para una aeronave bimotor es de:",
  "explicacion": "Para aeronaves bimotores, el mínimo estándar de visibilidad de despegue indicado por la norma operacional es 1,6 km. Fuente: DGAC Chile, normativa de operaciones aéreas y mínimos de utilización de aeródromo.",
  "respuestas": [
    {"texto": "A.- 0.8 kilómetros.", "puntos": 0},
    {"texto": "B.- 3.2 kilómetros.", "puntos": 0},
    {"texto": "C.- 1,6 kilómetros.", "puntos": 1}
  ]
},
{
  "texto": "9.- El mínimo estándar de visibilidad para el despegue de aeronaves de tres o más motores es de:",
  "explicacion": "Para aeronaves con tres o más motores, el mínimo estándar de visibilidad de despegue es 0,8 km. Fuente: DGAC Chile, normativa de operaciones aéreas y mínimos de utilización de aeródromo.",
  "respuestas": [
    {"texto": "A.- 0.8 kilómetros.", "puntos": 1},
    {"texto": "B.- 1.6 kilómetros.", "puntos": 0},
    {"texto": "C.- 3.2 kilómetros.", "puntos": 0}
  ]
},
{
  "texto": "10.- El mínimo de visibilidad estándar para el despegue de aeronaves bimotores puede ser reducido a 400 metros siempre que:",
  "explicacion": "La reducción a 400 m exige referencias visuales de pista adecuadas, alternativa de despegue a una hora con un motor inoperativo y condiciones iguales o superiores al mínimo de aterrizaje aplicable. Fuente: DGAC Chile, normativa de mínimos de utilización de aeródromo.",
  "respuestas": [
    {"texto": "A.- Se cuente con un RVR operativo, se disponga de un aeródromo de alternativa y los mínimos de techo y visibilidad en ese aeródromo sean los de alternativa.", "puntos": 0},
    {"texto": "B.- Se cuente con HIRL, RCLL, RCLM visibles al piloto durante el recorrido de despegue, se disponga de un aeródromo de alternativa, con un motor inoperativo a una hora de vuelo o menos, y el techo y la visibilidad en ese aeródromo de alternativa sea igual o superior al mínimo de aterrizaje para aproximación directa.", "puntos": 1},
    {"texto": "C.- Se cuente con RCLL, o con RCLM visibles, se disponga de un aeródromo de alternativa a dos horas o menos con un motor inoperativo y el techo y la visibilidad en el aeródromo de alternativa sean los correspondientes a los de alternativa.", "puntos": 0}
  ]
},
{
  "texto": "11.- El mínimo de visibilidad estándar para el despegue de aeronaves de tres o más motores puede ser reducido a 400 metros siempre que:",
  "explicacion": "Para tres o más motores, la reducción a 400 m permite alternativa hasta dos horas con un motor inoperativo, manteniendo iluminación visible y meteorología de alternativa. Fuente: DGAC Chile, normativa de mínimos de utilización de aeródromo.",
  "respuestas": [
    {"texto": "A.- Se cuente con un RVR operativo, se disponga de un aeródromo de alternativa y los mínimos de techo y visibilidad en ese aeródromo sean los de alternativa.", "puntos": 0},
    {"texto": "B.- Se cuente con RCLL, o con RCLM visibles, se disponga de un aeródromo de alternativa a una hora o menos con un motor inoperativo, y el techo y la visibilidad en el aeródromo de alternativa sean los publicados para alternativa.", "puntos": 0},
    {"texto": "C.- Se cuente con HIRL, o RCLL visibles al piloto durante el recorrido de despegue, se disponga de un aeródromo de alternativa, con un motor inoperativo a dos horas de vuelo o menos, y el techo y la visibilidad en ese aeródromo de alternativa sea igual o superior al mínimo meteorológicos de alternativa.", "puntos": 1}
  ]
},
{
  "texto": "12.- El mínimo de visibilidad estándar para el despegue de aeronaves bimotores se puede reducir a 175 metros siempre que:",
  "explicacion": "La reducción a 175 m exige RVR con tres transmisómetros sin lecturas inferiores a 175 m, RCLL/RCLM visibles y alternativa dentro de una hora con un motor inoperativo. Fuente: DGAC Chile, normativa de mínimos de utilización de aeródromo.",
  "respuestas": [
    {"texto": "A.- Se cuente con un sistema RVR compuesto por tres transmisómetros, ninguno con una lectura inferior a 175 metros al momento del despegue, exista RCLL y RCLM visible al piloto durante el recorrido de despegue y se disponga de un aeródromo de alternativa a no menos de una hora de vuelo con un motor inoperativo.", "puntos": 1},
    {"texto": "B.- Los mismos requisitos que A. anterior, salvo que el aeródromo de alternativa puede encontrarse a dos horas de vuelo, o menos, con un motor inoperativo.", "puntos": 0},
    {"texto": "C.- Los mismos requisitos que A. anterior, salvo que uno de los transmisómetros del sistema RVR puede tener una lectura inferior a 175 metro, pero no inferior a 150 metros.", "puntos": 0}
  ]
},
{
  "texto": "13.- El mínimo de visibilidad estándar para el despegue de aeronaves provistas de tres o más motores se puede ser reducido a 175 metros siempre que:",
  "explicacion": "Para tres o más motores, la reducción a 175 m mantiene los requisitos RVR/RCLL/RCLM y permite alternativa hasta dos horas con un motor inoperativo. Fuente: DGAC Chile, normativa de mínimos de utilización de aeródromo.",
  "respuestas": [
    {"texto": "A.- Se cuente con un sistema RVR compuesto por tres transmisómetros, ninguno con una lectura inferior a 175 metros al momento del despegue, exista RCLL y RCLM visible al piloto durante el recorrido de despegue y se disponga de un aeródromo de alternativa a no menos de una hora de vuelo con un motor inoperativo.", "puntos": 0},
    {"texto": "B.- Los mismos requisitos que A. anterior, salvo que el aeródromo de alternativa puede encontrarse a dos horas de vuelo, o menos, con un motor inoperativo.", "puntos": 1},
    {"texto": "C.- Los mismos requisitos que A. anterior, salvo que uno de los transmisómetros del sistema RVR puede tener una lectura inferior a 175 metro, pero no inferior a 150 metros.", "puntos": 0}
  ]
},
{
  "texto": "14.- Los mínimos meteorológicos de un aeródromo de alternativa para procedimientos de no precisión son:",
  "explicacion": "Para alternativa con aproximación de no precisión, el mínimo aplicable es MDH 800 ft y visibilidad 3,2 km. Fuente: DGAC Chile, normativa de planificación IFR y mínimos de alternativa.",
  "respuestas": [
    {"texto": "A.- MDH 800 pies y visibilidad 3.2 kilómetros.", "puntos": 1},
    {"texto": "B.- MDH 600 pies y visibilidad 2.2 kilómetros.", "puntos": 0},
    {"texto": "C.- MDH 400 pies y visibilidad 1.6 kilómetros.", "puntos": 0}
  ]
},
{
  "texto": "15.- Los mínimos meteorológicos de un aeródromo de alternativa para procedimientos de precisión (ILS) son:",
  "explicacion": "Para alternativa con procedimiento de precisión ILS, el mínimo indicado es MDH 600 ft y visibilidad 3,2 km. Fuente: DGAC Chile, normativa de planificación IFR y mínimos de alternativa.",
  "respuestas": [
    {"texto": "A.- MDH 800 pies y visibilidad 1.6 kilómetros.", "puntos": 0},
    {"texto": "B.- MDH 600 pies y visibilidad 3.2 kilómetros.", "puntos": 1},
    {"texto": "C.- MDH 400 pies y visibilidad 0.8 kilómetros.", "puntos": 0}
  ]
},
{
  "texto": "16.- La velocidad máxima en circuito de espera (holding) que se autorizan en Chile, entre 6.001 pies MSL y FL 140, y que está publicada en el AIP-MAP, es:",
  "explicacion": "En Chile, el AIP-MAP establece 230 KIAS como velocidad máxima de espera entre 6.001 ft MSL y FL140. Fuente: DGAC Chile, AIP Chile Vol. II MAP, procedimientos de espera.",
  "respuestas": [
    {"texto": "A.- 200 nudos indicados.", "puntos": 0},
    {"texto": "B.- 230 nudos indicados.", "puntos": 1},
    {"texto": "C.- 265 nudos indicados.", "puntos": 0}
  ]
},
{
  "texto": "17.- Para que una aproximación a una pista sea considerada como 'directa', el ángulo formado entre la prolongación del eje de la pista y la derrota de aproximación final no puede ser superior a:",
  "explicacion": "Una aproximación directa requiere que la derrota final no exceda 30° respecto de la prolongación del eje de pista. Fuente: ICAO Doc 8168, PANS-OPS, Vol. II, criterios de aproximación final.",
  "respuestas": [
    {"texto": "A.- 90 grados.", "puntos": 0},
    {"texto": "B.- 60 grados.", "puntos": 0},
    {"texto": "C.- 30 grados.", "puntos": 1}
  ]
},
{
  "texto": "18.- El aeródromo en el que podría aterrizar una aeronave si ello fuera necesario poco después del despegue y cuando no es posible utilizar para este efecto el aeródromo de salida se denomina:",
  "explicacion": "El aeródromo previsto para aterrizar tras el despegue cuando no puede usarse el de salida se denomina alternativa post-despegue. Fuente: DGAC Chile, DAN 91 Vol. I, definiciones operacionales.",
  "respuestas": [
    {"texto": "A.- Aeródromo de emergencia para regreso.", "puntos": 0},
    {"texto": "B.- Aeródromo de alternativa post-despegue.", "puntos": 1},
    {"texto": "C.- Aeródromo de alternativa para primera fase del vuelo.", "puntos": 0}
  ]
},
{
  "texto": "19.- Para efectuar el cálculo de la razón de ascenso requerida (ft/min) en una salida instrumental (SID) se debería:",
  "explicacion": "La razón de ascenso requerida se obtiene multiplicando la gradiente publicada por la velocidad terrestre, convirtiendo el resultado a ft/min. Fuente: FAA, Instrument Procedures Handbook, FAA-H-8083-16.",
  "respuestas": [
    {"texto": "A.- Multiplicar el porcentaje de la gradiente publicada en el procedimiento por la velocidad en nudos (gradient percent x ground speed kts).", "puntos": 1},
    {"texto": "B.- Dividir el porcentaje de la gradiente publicada en el procedimiento por la velocidad en nudos (gradient percent: ground speed kts):", "puntos": 0},
    {"texto": "C.- Aplicar la siguiente fórmula: VS1 x 60: ground speed (kts)", "puntos": 0}
  ]
},
{
  "texto": "20.- Conforme a lo determinado por OACI, la velocidad máxima en un circuito de espera para un avión turborreactor, a 14.000 pies MSL o menos es:",
  "explicacion": "Para aeronaves turborreactoras hasta 14.000 ft, OACI establece 230 kt como velocidad máxima de espera. Fuente: ICAO Doc 8168, PANS-OPS, Vol. I, procedimientos de espera.",
  "respuestas": [
    {"texto": "A.- 230 nudos.", "puntos": 1},
    {"texto": "B.- 240 nudos.", "puntos": 0},
    {"texto": "C.- 265 nudos.", "puntos": 0}
  ]
},
{
  "texto": "21.- Conforme a lo determinado por OACI, la velocidad máxima en un circuito de espera para un avión turborreactor, entre 14.001 pies y 20.000 pies MSL es:",
  "explicacion": "Entre 14.001 y 20.000 ft, la velocidad máxima OACI para espera de turborreactores es 240 kt. Fuente: ICAO Doc 8168, PANS-OPS, Vol. I.",
  "respuestas": [
    {"texto": "A.- 230 nudos.", "puntos": 0},
    {"texto": "B.- 240 nudos.", "puntos": 1},
    {"texto": "C.- 265 nudos.", "puntos": 0}
  ]
},
{
  "texto": "22.- Conforme a lo determinado por OACI, la velocidad máxima en un circuito de espera para un avión turborreactor, entre 20.001 pies y 34.000 pies MSL, es.",
  "explicacion": "Entre 20.001 y 34.000 ft, OACI fija 265 kt como velocidad máxima de espera para turborreactores. Fuente: ICAO Doc 8168, PANS-OPS, Vol. I.",
  "respuestas": [
    {"texto": "A.- 230 nudos.", "puntos": 0},
    {"texto": "B.- 240 nudos.", "puntos": 0},
    {"texto": "C.- 265 nudos.", "puntos": 1}
  ]
},
{
  "texto": "23.- Conforme a lo determinado por la FAA hasta 6.000 pies MSL la velocidad máxima en un circuito de espera es:",
  "explicacion": "La FAA establece 200 KIAS como velocidad máxima de espera hasta 6.000 ft MSL. Fuente: FAA, Aeronautical Information Manual, sección Holding Procedures.",
  "respuestas": [
    {"texto": "A.- 200 nudos.", "puntos": 1},
    {"texto": "B.- 210 nudos.", "puntos": 0},
    {"texto": "C.- 265 nudos.", "puntos": 0}
  ]
},
{
  "texto": "24.- Conforme a lo determinado por la FAA la velocidad máxima en un circuito de espera entre 6.000 y 14.000 pies MSL es:",
  "explicacion": "Entre más de 6.000 ft y 14.000 ft, la velocidad máxima estándar FAA para espera es 230 KIAS; la alternativa marcada refleja ese valor. Fuente: FAA, Aeronautical Information Manual, sección Holding Procedures.",
  "respuestas": [
    {"texto": "A.- 200.", "puntos": 0},
    {"texto": "B.- 230.", "puntos": 1},
    {"texto": "C.- 265.", "puntos": 0}
  ]
},
{
  "texto": "25.- Conforme a lo determinado por la FAA la velocidad máxima en un circuito de espera sobre 14.000 pies MSL es:",
  "explicacion": "Sobre 14.000 ft MSL, la FAA establece 265 KIAS como velocidad máxima de espera. Fuente: FAA, Aeronautical Information Manual, sección Holding Procedures.",
  "respuestas": [
    {"texto": "A.- 200 nudos.", "puntos": 0},
    {"texto": "B.- 210 nudos.", "puntos": 0},
    {"texto": "C.- 265.", "puntos": 1}
  ]
},
{
  "texto": "26.- ¿De quién es la responsabilidad de verificar que las cartas de navegación, adecuadas para la ruta, se encuentren a bordo de la aeronave antes de iniciar un vuelo?",
  "explicacion": "El piloto al mando conserva la responsabilidad final de verificar documentación, cartas y antecedentes necesarios antes del vuelo. Fuente: DGAC Chile, DAN 91 Vol. I; FAA, 14 CFR §91.103.",
  "respuestas": [
    {"texto": "A.- En un vuelo comercial, del Encargado de Operaciones de Vuelo.", "puntos": 0},
    {"texto": "B.- Del Primer Oficial.", "puntos": 0},
    {"texto": "C.- Del Piloto al Mando.", "puntos": 1}
  ]
},
{
  "texto": "27.- Indique la aseveración correcta con relación a las SIDS.",
  "explicacion": "Una SID es una ruta IFR publicada que enlaza el aeródromo con la estructura de ruta, estandarizando la salida. Fuente: FAA, Aeronautical Information Manual, sección Standard Instrument Departures.",
  "respuestas": [
    {"texto": "A.- Son rutas designadas de salida IFR que proporcionan transición del aeródromo a la ruta.", "puntos": 1},
    {"texto": "B.- Son vectores proporcionados como guía que los pilotos usan a su discreción.", "puntos": 0},
    {"texto": "C.- Son vectores de radar empleados por ATC para aeronaves bajo su control.", "puntos": 0}
  ]
},
{
  "texto": "28.- ¿Cuál es el propósito principal de una STAR?",
  "explicacion": "Una STAR simplifica las autorizaciones IFR y ordena la transición desde la ruta hacia el área terminal. Fuente: FAA, Aeronautical Information Manual, sección Standard Terminal Arrival Routes.",
  "respuestas": [
    {"texto": "A.- Proporcionar separación entre el tráfico IFR y el tráfico VFR.", "puntos": 0},
    {"texto": "B.- Simplificar los procedimientos de autorizaciones instrumentales.", "puntos": 1},
    {"texto": "C.- Disminuir la congestión del tráfico aéreo en ciertos aeropuertos.", "puntos": 0}
  ]
},
{
  "texto": "29.- ¿Cuándo ATC proporciona una STAR a una aeronave?",
  "explicacion": "ATC asigna una STAR cuando resulta apropiada para la gestión del tránsito y el procedimiento publicado aplicable. Fuente: FAA, Aeronautical Information Manual, sección STAR.",
  "respuestas": [
    {"texto": "A.- Sólo cuando ATC lo considera apropiado y necesario.", "puntos": 1},
    {"texto": "B.- Sólo cuando se trata de un vuelo que requiere alta prioridad.", "puntos": 0},
    {"texto": "C.- Sólo a solicitud del piloto.", "puntos": 0}
  ]
},
{
  "texto": "30.- En la carta de aproximación de un aeropuerto, entre el FAF y el MAP aparece el signo 2.91º, ¿qué significa?",
  "explicacion": "El valor en grados representa el ángulo de trayectoria vertical de la aproximación final para equipos capaces de guiar descenso vertical. Fuente: FAA, Chart Users Guide, símbolos de cartas de aproximación.",
  "respuestas": [
    {"texto": "A.- Cambio de actitud de vuelo tras el FAF.", "puntos": 0},
    {"texto": "B.- Ajuste del indicador de actitud bajo el horizonte.", "puntos": 0},
    {"texto": "C.- Es el ángulo de aproximación final para aviones con computadores de trayectoria vertical.", "puntos": 1}
  ]
},
{
  "texto": "31.- Aproximando a Concepción para una aproximación ILS, ¿con qué otras radioayudas deberá estar equipado el avión además del ILS?",
  "explicacion": "La carta referenciada exige VOR/DME y ADF como ayudas complementarias para cumplir la navegación hacia la alternativa. Fuente: DGAC Chile, AIP Chile Vol. II MAP, carta ILS Concepción.",
  "respuestas": [
    {"texto": "A.- Radar y VOR/DME.", "puntos": 0},
    {"texto": "B.- VOR/DME y ADF.", "puntos": 1},
    {"texto": "C.- LORAN o VOR/DME y ADF.", "puntos": 0}
  ]
},
{
  "texto": "32.- ¿Cómo se identifica el FAF en la aproximación VOR/DME a la pista 01 de Antofagasta?",
  "explicacion": "El FAF está definido por la intersección de 5 DME con el radial 187 del VOR FAG. Fuente: DGAC Chile, AIP Chile Vol. II MAP, carta VOR/DME RWY 01 Antofagasta.",
  "respuestas": [
    {"texto": "A.- 5 DME/Radial 007 del VOR FAG.", "puntos": 0},
    {"texto": "B.- 5 DME/Radial 187 del VOR FAG.", "puntos": 1},
    {"texto": "C.- 1.700 pies en el altímetro y 5 DME del VOR FAG.", "puntos": 0}
  ]
},
{
  "texto": "33.- ¿Cuál es el procedimiento para iniciar la aproximación frustrada en el descenso VOR a pista 17 de Puerto Montt?",
  "explicacion": "La frustrada publicada exige ascender a 3.000 ft en el curso 168 del VOR MON y regresar con viraje derecho a la espera. Fuente: DGAC Chile, AIP Chile Vol. II MAP, carta VOR Puerto Montt.",
  "respuestas": [
    {"texto": "A.- Ascender a 3000 pies en el curso 168 del VOR MON regresando con viraje a la derecha e ingresando a circuito de espera.", "puntos": 1},
    {"texto": "B.- Ascender a 3000 pies en rumbo 168 con virajes a la izquierda.", "puntos": 0},
    {"texto": "C.- Ascender a 3000 pies en rumbo 168 e ingresar a espera al sur.", "puntos": 0}
  ]
},
{
  "texto": "34.- Ud. desea considerar Iquique como alternativa para Antofagasta. ¿Qué pronóstico meteorológico mínimo debe tener Iquique?",
  "explicacion": "La alternativa debe cumplir 800 ft/3,2 km para no precisión y 600 ft/3,0 km para precisión, según mínimos publicados. Fuente: DGAC Chile, AIP Chile Vol. II MAP y criterios de alternativa IFR.",
  "respuestas": [
    {"texto": "A.- 800 pies con 3.2 Km y 700 pies con 1,6 Km.", "puntos": 0},
    {"texto": "B.- 800 pies/3.2 Km (no precisión) y 600 pies/3.0 Km (precisión).", "puntos": 1},
    {"texto": "C.- 800 pies de techo y 3.2 Km. para todas las aproximaciones.", "puntos": 0}
  ]
},
{
  "texto": "35.- Un avión bimotor en Concepción sin alternativa a menos de una hora y con ILS inoperativo, los mínimos de despegue son:",
  "explicacion": "Al no cumplir condiciones para reducir mínimos, aplica el mínimo estándar de despegue para bimotor: 1,6 km. Fuente: DGAC Chile, mínimos de utilización de aeródromo y AIP Chile Vol. II MAP.",
  "respuestas": [
    {"texto": "A.- 0.8 km. de visibilidad.", "puntos": 0},
    {"texto": "B.- 1,6 km. de visibilidad.", "puntos": 1},
    {"texto": "C.- 1.2 km. de visibilidad.", "puntos": 0}
  ]
},
{
  "texto": "36.- Para efectuar una aproximación VOR/DME en Concepción, además del equipo VOR/DME operativo, el avión deberá disponer de:",
  "explicacion": "Además de la navegación VOR/DME, la comunicación VHF es necesaria para coordinación ATS y cumplimiento del procedimiento. Fuente: DGAC Chile, AIP Chile Vol. II MAP, carta VOR/DME Concepción.",
  "respuestas": [
    {"texto": "A.- Equipo de comunicación VHF.", "puntos": 1},
    {"texto": "B.- Sistema de alerta de altitud.", "puntos": 0},
    {"texto": "C.- Un VOR/DME tipo standby y equipo de comunicaciones VHF.", "puntos": 0}
  ]
},
{
  "texto": "37.- Indique qué sistema de iluminación tiene la pista 35 del aeropuerto de Puerto Montt.",
  "explicacion": "La pista 35 dispone de HIRL, luces de identificación de umbral, PAPI y sistema de aproximación con destellos, según carta de aeródromo. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Puerto Montt.",
  "respuestas": [
    {"texto": "A.- Luces de pista de alta intensidad, PAPI y luces de aproximación.", "puntos": 0},
    {"texto": "B.- Luces de pista de alta intensidad, identificación de umbral, PAPI y aproximación con destello.", "puntos": 1},
    {"texto": "C.- Luces de pista de alta intensidad, PAPI, destello de umbral y centro de pista.", "puntos": 0}
  ]
},
{
  "texto": "38.- La altitud mínima (MDA) en el descenso VOR/DME a la pista 19 del aeropuerto de Antofagasta es:",
  "explicacion": "La MDA publicada para el procedimiento VOR/DME RWY 19 Antofagasta corresponde a 1.240 ft. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Antofagasta.",
  "respuestas": [
    {"texto": "A.- 1240 pies.", "puntos": 1},
    {"texto": "B.- 1240' (800').", "puntos": 0},
    {"texto": "C.- 785 pies.", "puntos": 0}
  ]
},
{
  "texto": "39.- La altitud mínima de recepción en la aerovía V/W 200 entre CLD y ΤΟΥ es:",
  "explicacion": "La altitud mínima de recepción publicada para ese tramo de la aerovía es FL110. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 3, rutas ATS.",
  "respuestas": [
    {"texto": "A.- FL 80", "puntos": 0},
    {"texto": "B.- FL 10", "puntos": 0},
    {"texto": "C.- FL 110", "puntos": 1}
  ]
},
{
  "texto": "40.- ¿Cuál es la distancia entre Trapén y la pista para una aproximación ILS a pista 35 en Puerto Montt?",
  "explicacion": "La carta ILS RWY 35 de Puerto Montt publica 3,9 NM entre Trapén y la pista. Fuente: DGAC Chile, AIP Chile Vol. II MAP, ILS RWY 35 Puerto Montt.",
  "respuestas": [
    {"texto": "A.- 5.7 millas náuticas.", "puntos": 0},
    {"texto": "B.- 4.5 millas náuticas.", "puntos": 0},
    {"texto": "C.- 3.9 millas náuticas.", "puntos": 1}
  ]
},
{
  "texto": "41.- Procediendo vía STAR TILGO 3 hacia La Serena, ¿cuál es la mínima altitud autorizada para cruzar BARCA?",
  "explicacion": "La STAR TILGO 3 establece 5.000 ft como altitud mínima de cruce en BARCA. Fuente: DGAC Chile, AIP Chile Vol. II MAP, STAR La Serena.",
  "respuestas": [
    {"texto": "A.- 3.000 pies.", "puntos": 0},
    {"texto": "B.- 5.000 pies.", "puntos": 1},
    {"texto": "C.- 7.000 pies.", "puntos": 0}
  ]
},
{
  "texto": "42.- ¿Cuál es el largo de pista disponible para aterrizar en la pista 07 del aeropuerto de Punta Arenas?",
  "explicacion": "La longitud disponible de aterrizaje publicada para la pista 07 es 2.790 m. Fuente: DGAC Chile, AIP Chile Vol. II MAP, AD Punta Arenas.",
  "respuestas": [
    {"texto": "A.- 3.030 metros.", "puntos": 0},
    {"texto": "B.- 3.090 metros.", "puntos": 0},
    {"texto": "C.- 2.790 metros.", "puntos": 1}
  ]
},
{
  "texto": "43.- Saliendo de Tobalaba vía SID PARKE 1, ¿cuál es la distancia a recorrer desde ese aeródromo hasta el VOR SCL?",
  "explicacion": "La SID PARKE 1 publica 11 NM desde Tobalaba hasta el VOR SCL. Fuente: DGAC Chile, AIP Chile Vol. II MAP, SID PARKE 1.",
  "respuestas": [
    {"texto": "A.- 9 millas náuticas.", "puntos": 0},
    {"texto": "B.- 11 millas náuticas.", "puntos": 1},
    {"texto": "C.- 12 millas náuticas.", "puntos": 0}
  ]
},
{
  "texto": "44.- ¿Cómo se identifica en una Carta de Área un aeródromo sin aproximación instrumental publicada?",
  "explicacion": "En la simbología de cartas de área, un aeródromo sin aproximación instrumental se identifica con símbolo verde. Fuente: DGAC Chile, AIP Chile Vol. I, GEN 2.3, símbolos cartográficos.",
  "respuestas": [
    {"texto": "A.- Símbolo del aeródromo en verde.", "puntos": 1},
    {"texto": "B.- Símbolo del aeródromo en azul.", "puntos": 0},
    {"texto": "C.- Símbolo del aeródromo en rojo.", "puntos": 0}
  ]
},
{
  "texto": "45.- En la Carta de Área de Santiago, el nivel mínimo de cruce en VISEK es:",
  "explicacion": "La carta de área de Santiago publica FL130 como nivel mínimo de cruce en VISEK. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Carta de Área Santiago.",
  "respuestas": [
    {"texto": "A.- 110", "puntos": 0},
    {"texto": "B.- 130", "puntos": 1},
    {"texto": "C.- 160 si se vuela con dirección este.", "puntos": 0}
  ]
},
{
  "texto": "46.- ¿En qué publicación aeronáutica puede encontrar la frecuencia ATIS del terminal Santiago?",
  "explicacion": "La frecuencia ATIS del aeropuerto se publica en cartas de aproximación, incluida la carta ILS del aeropuerto Arturo Merino Benítez. Fuente: DGAC Chile, AIP Chile Vol. II MAP, cartas IAC SCEL.",
  "respuestas": [
    {"texto": "A.- En las cartas de llegadas normalizadas por instrumentos.", "puntos": 0},
    {"texto": "B.- En la carta de aproximación ILS al aeropuerto Arturo Merino Benítez.", "puntos": 1},
    {"texto": "C.- En la carta del área terminal Santiago.", "puntos": 0}
  ]
},
{
  "texto": "47.- Indique cuál es el nivel mínimo en la aerovía V/G 679 entre SNO y Quintero.",
  "explicacion": "El nivel mínimo publicado para el tramo SNO–Quintero en la aerovía V/G 679 es FL60. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 3, rutas ATS.",
  "respuestas": [
    {"texto": "A.- 180", "puntos": 0},
    {"texto": "B.- 60", "puntos": 1},
    {"texto": "C.- 5,5", "puntos": 0}
  ]
},
{
  "texto": "48.- ¿Qué significa el símbolo representado por una P dentro de un círculo en una carta de aeropuerto?",
  "explicacion": "El símbolo P dentro de un círculo identifica una zona prohibida. Fuente: DGAC Chile, AIP Chile Vol. I, GEN 2.3, símbolos cartográficos.",
  "respuestas": [
    {"texto": "A.- Zona Prohibida.", "puntos": 1},
    {"texto": "B.- Zona de Espera.", "puntos": 0},
    {"texto": "C.- PAPI en uso.", "puntos": 0}
  ]
},
{
  "texto": "49.- El nivel máximo permitido en la aerovía UG-551 es:",
  "explicacion": "La aerovía UG-551 pertenece a la red superior y su nivel máximo publicado es FL450. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 3, rutas ATS.",
  "respuestas": [
    {"texto": "A.- 150", "puntos": 0},
    {"texto": "B.- 450", "puntos": 1},
    {"texto": "C.- El nivel máximo no está limitado.", "puntos": 0}
  ]
},
{
  "texto": "50.- Ud. Se encuentra volando en el sector Norte del Área Terminal Santiago, ¿cuál es la frecuencia para comunicarse con el Centro de Control?",
  "explicacion": "La frecuencia publicada para el sector Norte del área terminal Santiago es 126.3 MHz. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Carta de Área Santiago.",
  "respuestas": [
    {"texto": "A.- 128.1", "puntos": 0},
    {"texto": "B.- 126.3", "puntos": 1},
    {"texto": "C.- 127.0", "puntos": 0}
  ]
},
{
  "texto": "51.- Las frecuencias de control de Santiago Radio están divididas en sector Norte y sector Sur. Esta delimitación se encuentra ubicada en:",
  "explicacion": "La división Norte/Sur publicada para Santiago Radio se ubica en la latitud 33°23’ S. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Carta de Área Santiago.",
  "respuestas": [
    {"texto": "A.- El VOR AMB.", "puntos": 0},
    {"texto": "B.- La latitud 33º 22’ 34” S", "puntos": 0},
    {"texto": "C.- La latitud 33º 23’ S", "puntos": 1}
  ]
},
{
  "texto": "52.- En una carta de área, las zonas delimitadas con achurado y marcadas con la sigla SC-P, significa:",
  "explicacion": "En la designación nacional, la letra P identifica una zona prohibida. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 5.1 y GEN 2.3.",
  "respuestas": [
    {"texto": "A.- Zona Peligrosa.", "puntos": 0},
    {"texto": "B.- Zona Prohibida.", "puntos": 1},
    {"texto": "C.- Zona Restringida.", "puntos": 0}
  ]
},
{
  "texto": "53.- La posición RIBLA en la aerovía UA 306 del área terminal de Santiago, es:",
  "explicacion": "RIBLA está representada como punto de notificación no obligatorio en la carta de área. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Carta de Área Santiago.",
  "respuestas": [
    {"texto": "A.- Un punto de notificación cuando se está siendo dirigido por radar.", "puntos": 0},
    {"texto": "B.- Un punto de notificación obligatorio.", "puntos": 0},
    {"texto": "C.- Un punto de notificación no obligatorio.", "puntos": 1}
  ]
},
{
  "texto": "54.- Una aeronave es autorizada para efectuar la STAR DIMAR-2 al aeropuerto Diego Aracena de Iquique, instruyéndosele que reporte la posición VAROK. Esta posición está determinada por:",
  "explicacion": "VAROK se define por 38 DME y radial 190 del VOR IQQ. Fuente: DGAC Chile, AIP Chile Vol. II MAP, STAR DIMAR-2 Iquique.",
  "respuestas": [
    {"texto": "A.- 38 MN DME del VOR IQQ.", "puntos": 0},
    {"texto": "B.- 38 MN DME del VOR IQQ y radial 010 del mismo VOR.", "puntos": 0},
    {"texto": "C.- 38 MN DME y radial 190 del VOR IQQ.", "puntos": 1}
  ]
},
{
  "texto": "55.- La elevación y largo de pista del aeródromo de Los Ángeles son:",
  "explicacion": "La información publicada del aeródromo indica elevación 374 ft y pista de 1.700 m. Fuente: DGAC Chile, AIP Chile, AD Los Ángeles.",
  "respuestas": [
    {"texto": "A.- 1.700 pies y 3.740 pies respectivamente.", "puntos": 0},
    {"texto": "B.- 374 pies y 1.700 metros.", "puntos": 1},
    {"texto": "C.- 3.740 pies y 1.700 metros.", "puntos": 0}
  ]
},
{
  "texto": "56.- ¿Cuál es la razón de ascenso que debería llevar un avión cuya velocidad terrestre es de 240 nudos para cumplir con una gradiente de ascenso del 6.6%?",
  "explicacion": "La razón requerida se obtiene como 240 × 6,6 = 1.584 ft/min, redondeada a 1.600 ft/min. Fuente: FAA, Instrument Procedures Handbook, FAA-H-8083-16.",
  "respuestas": [
    {"texto": "A.- 1.400 pies por minuto.", "puntos": 0},
    {"texto": "B.- 1.600 pies por minuto.", "puntos": 1},
    {"texto": "C.- 1.800 pies por minuto.", "puntos": 0}
  ]
},
{
  "texto": "57.- ¿A cuántos pies por milla náutica asciende una aeronave que mantiene una razón de ascenso de 800 pies por minuto y una velocidad terrestre de 210 nudos?",
  "explicacion": "La clave del código marca 500 ft/NM, aunque el cálculo estándar 800 ÷ (210/60) entrega aproximadamente 229 ft/NM; conviene revisar la clave original. Fuente: FAA, Instrument Procedures Handbook, FAA-H-8083-16.",
  "respuestas": [
    {"texto": "A.- 400 pies por milla náutica.", "puntos": 0},
    {"texto": "B.- 450 pies por milla náutica.", "puntos": 0},
    {"texto": "C.- 500 pies por milla náutica.", "puntos": 1}
  ]
},
{
  "texto": "58.- El aeródromo de Pichoy tiene una pista de un largo de:",
  "explicacion": "La longitud de pista publicada para Pichoy es 2.100 m. Fuente: DGAC Chile, AIP Chile, AD Pichoy.",
  "respuestas": [
    {"texto": "A.- 590 metros.", "puntos": 0},
    {"texto": "B.- 5.900 pies.", "puntos": 0},
    {"texto": "C.- 2.100 metros.", "puntos": 1}
  ]
},
{
  "texto": "59.- El símbolo X colocado por los sobrevivientes de un accidente aéreo para que sea visto desde el aire, significa:",
  "explicacion": "En el código visual tierra-aire de búsqueda y salvamento, X significa necesidad de ayuda médica. Fuente: ICAO Annex 12, Search and Rescue, señales visuales tierra-aire.",
  "respuestas": [
    {"texto": "A.- Este es el lugar en que acamparemos.", "puntos": 0},
    {"texto": "B.- No sabemos dónde nos encontramos.", "puntos": 0},
    {"texto": "C.- Necesitamos ayuda médica.", "puntos": 1}
  ]
},
{
  "texto": "60.- ¿Cuál es la mayor elevación de terreno contenida en la carta VOR/DME a la pista 19 de Antofagasta?",
  "explicacion": "La carta VOR/DME RWY 19 de Antofagasta muestra 5.476 ft como mayor elevación del terreno representada. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Antofagasta.",
  "respuestas": [
    {"texto": "A.- 3.159 pies.", "puntos": 0},
    {"texto": "B.- 24.500 pies.", "puntos": 0},
    {"texto": "C.- 5.476 pies.", "puntos": 1}
  ]
},
{
  "texto": "61.- En la carta de aproximación VOR/DME a la pista 20 de Concepción aparece la sigla “NoVP”. ¿Qué significa?",
  "explicacion": "En la clave del examen, NoVP se interpreta como que no se requiere viraje de procedimiento para esa aproximación. Fuente: DGAC Chile, AIP Chile Vol. II MAP, carta VOR/DME Concepción.",
  "respuestas": [
    {"texto": "A.- No existe visual path.", "puntos": 0},
    {"texto": "B.- A 2.760 pies no habrá ni indicación VASI ni indicación PAPI.", "puntos": 0},
    {"texto": "C.- No se requiere viraje de procedimiento.", "puntos": 1}
  ]
},
{
  "texto": "62.- El símbolo WWW colocado en la pista 07/25 de Punta Arenas, significa...",
  "explicacion": "El símbolo WWW en la carta de aeródromo corresponde a una barrera de detención. Fuente: DGAC Chile, AIP Chile Vol. I, GEN 2.3, símbolos cartográficos.",
  "respuestas": [
    {"texto": "A.- Umbral desplazado por obstáculos.", "puntos": 0},
    {"texto": "B.- Barrera de detención.", "puntos": 1},
    {"texto": "C.- Pista utilizable sólo a partir de este punto.", "puntos": 0}
  ]
},
{
  "texto": "63.- El signo FAF en una carta de aproximación, significa....",
  "explicacion": "FAF significa Final Approach Fix, punto que marca el inicio del tramo final de aproximación. Fuente: FAA, Pilot/Controller Glossary; ICAO Doc 8168, PANS-OPS.",
  "respuestas": [
    {"texto": "A.- Altitud mínima a cruzar.", "puntos": 0},
    {"texto": "B.- Fix final de aproximación.", "puntos": 1},
    {"texto": "C.- Punto de contacto visual.", "puntos": 0}
  ]
},
{
  "texto": "64.- ¿A qué distancia “máxima” debe estar la alternativa de despegue para un avión bimotor?",
  "explicacion": "Para bimotores, la alternativa de despegue debe estar a no más de una hora de vuelo a velocidad de crucero con viento calma y un motor inoperativo. Fuente: DGAC Chile, normativa de operaciones IFR y alternativa post-despegue.",
  "respuestas": [
    {"texto": "A.- A una hora de vuelo a velocidad de crucero con viento calma y los dos motores operando.", "puntos": 0},
    {"texto": "B.- A una hora de vuelo a velocidad de crucero con viento calma y un motor operando.", "puntos": 1},
    {"texto": "C.- A dos horas de vuelo a velocidad de crucero con viento calma y un motor operando.", "puntos": 0}
  ]
},
{
  "texto": "65.- Un avión trimotor es despachado desde un aeródromo que se encuentra bajo los mínimos de aterrizaje. ¿A qué distancia “máxima” debe encontrarse su alternativa de despegue?",
  "explicacion": "Para aeronaves de tres o más motores, la alternativa de despegue puede estar hasta dos horas de vuelo con viento calma y un motor inoperativo. Fuente: DGAC Chile, normativa de operaciones IFR y alternativa post-despegue.",
  "respuestas": [
    {"texto": "A.- A no más de 2 horas de vuelo a velocidad de crucero con un motor inoperativo.", "puntos": 0},
    {"texto": "B.- A no más de 2 horas de vuelo a velocidad de crucero con viento calma y un motor inoperativo.", "puntos": 1},
    {"texto": "C.- A no más de 1 hora de vuelo a velocidad de crucero con viento calma y un motor inoperativo.", "puntos": 0}
  ]
},
{
  "texto": "66.- En una carta de aproximación NDB (ADF) o VOR Ud. observa la sigla VDP, ello significa:",
  "explicacion": "VDP significa Visual Descent Point: punto desde el cual puede iniciarse el descenso visual normal hacia la pista. Fuente: FAA, Instrument Procedures Handbook, FAA-H-8083-16.",
  "respuestas": [
    {"texto": "A.- Punto de frustrada visual.", "puntos": 0},
    {"texto": "B.- Punto de referencia visual.", "puntos": 0},
    {"texto": "C.- Punto de descenso visual.", "puntos": 1}
  ]
},
{
  "texto": "67.- ¿Qué debería hacer un piloto que recibe una autorización de ATC la que es contraria a la reglamentación vigente?",
  "explicacion": "Si una autorización parece contraria a la normativa o genera duda operacional, el piloto debe solicitar aclaración antes de cumplirla. Fuente: DGAC Chile, DAN 91 Vol. I; FAA, 14 CFR §91.123.",
  "respuestas": [
    {"texto": "A.- No cumplir lo autorizado y continuar el vuelo conforme a lo reglamentario.", "puntos": 0},
    {"texto": "B.- Solicitar una aclaración al ATC.", "puntos": 1},
    {"texto": "C.- Cumplir lo autorizado y posteriormente elevar un reporte de incidente.", "puntos": 0}
  ]
},
{
  "texto": "68.- Excepto durante una emergencia, ¿cuándo podría un piloto esperar prioridad para aterrizar?",
  "explicacion": "Fuera de emergencias, la secuencia de aterrizaje se basa normalmente en el orden de llegada y gestión ATC. Fuente: DGAC Chile, DAN 91 Vol. I, reglas generales de tránsito aéreo.",
  "respuestas": [
    {"texto": "A.- Cuando vuela con plan IFR.", "puntos": 0},
    {"texto": "B.- Cuando está al mando de una aeronave pesada y cuando transporta autoridades.", "puntos": 0},
    {"texto": "C.- La secuencia de aterrizaje opera sobre la base de quien llega primero aterriza primero.", "puntos": 1}
  ]
},
{
  "texto": "69.- ¿Cuál es la altitud mínima a que se puede interceptar el GS en el descenso ILS a la pista 35 de Puerto Montt?",
  "explicacion": "La carta ILS RWY 35 de Puerto Montt publica 2.300 ft como altitud mínima para interceptar el Glide Slope. Fuente: DGAC Chile, AIP Chile Vol. II MAP, ILS RWY 35 Puerto Montt.",
  "respuestas": [
    {"texto": "A.- 3.000 pies.", "puntos": 0},
    {"texto": "B.- 2.300 pies.", "puntos": 1},
    {"texto": "C.- 1787 pies.", "puntos": 0}
  ]
},
{
  "texto": "70.- ¿Cómo se puede desactivar (cancelar) un plan de vuelo IFR después de aterrizar en un aeródromo controlado?",
  "explicacion": "En aeródromo controlado, la torre confirma el aterrizaje y gestiona automáticamente el cierre/cancelación del plan IFR. Fuente: DGAC Chile, DAN 91 Vol. I y procedimientos ATS publicados en AIP Chile.",
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
  "imagenes": ["assets/figura76yfigura77yfigura78.jpg","assets/figura79.jpg","assets/figura80.jpg"],
  "explicacion": "Ruta visual: 1) En la figura de distribución de carga indicada para WT-1 (Figuras 76), identifica los pesos y momentos/índices de la condición. 2) Suma los índices parciales para obtener el índice total de la aeronave cargada. 3) En las Figuras 79 y 80 cruza el peso total con el índice total. 4) Desde la intersección, lee el CG expresado en porcentaje de MAC; para WT-1 el resultado correcto es 27.1% MAC.",
  "respuestas": [
    {"texto": "A.- 26.0% MAC.", "puntos": 0},
    {"texto": "B.- 27.1% МАС.", "puntos": 1},
    {"texto": "C.- 27.9% МАС.", "puntos": 0}
  ]
},
{
  "texto": "2.- ¿A cuántas pulgadas detrás del DATUM se sitúa el CG en la distribución de carga WT-2? (Referencia, Figuras 76, 79 у 80).",
  "explicacion": "Ruta visual: 1) En la Figura 76 ubica la condición WT-2 y obtiene el peso total e índice/momento total. 2) Con esos datos entra al gráfico de CG de las Figuras 79 y 80. 3) Proyecta el peso total hasta interceptar el índice/momento de la condición. 4) Lee la estación del CG en pulgadas desde el Datum; el valor resultante es 909.6 pulgadas detrás del Datum.",
  "imagenes": ["assets/figura76yfigura77yfigura78.jpg","assets/figura79.jpg","assets/figura80.jpg"],
  "respuestas": [
    {"texto": "A.- 908.8 pulgadas", "puntos": 0},
    {"texto": "B.- 909.6 pulgadas", "puntos": 1},
    {"texto": "C.- 910.7 pulgadas", "puntos": 0}
  ]
},
{
  "texto": "3.- ¿Cuál es el CG en porcentaje de MAC para la distribución de carga WT-3? (Referencia, Figuras 76, 79 y 80).",
  "explicacion": "Ruta visual: 1) En la figura de distribución de carga indicada para WT-3 (Figuras 76), identifica los pesos y momentos/índices de la condición. 2) Suma los índices parciales para obtener el índice total de la aeronave cargada. 3) En las Figuras 79 y 80 cruza el peso total con el índice total. 4) Desde la intersección, lee el CG expresado en porcentaje de MAC; para WT-3 el resultado correcto es 28.9% MAC.",
  "imagenes": ["assets/figura76yfigura77yfigura78.jpg","assets/figura79.jpg","assets/figura80.jpg"],
  "respuestas": [
    {"texto": "A.- 27.8% МАС.", "puntos": 0},
    {"texto": "B.- 28.9% MAC.", "puntos": 1},
    {"texto": "C.- 29.1% МАС.", "puntos": 0}
  ]
},
{
  "texto": "4.- ¿Cuál es el CG en porcentaje de MAC para la distribución de carga WT-7? (Referencia Figuras 77, 79 y 80).",
  "explicacion": "Ruta visual: 1) En la figura de distribución de carga indicada para WT-7 (Figuras 77), identifica los pesos y momentos/índices de la condición. 2) Suma los índices parciales para obtener el índice total de la aeronave cargada. 3) En las Figuras 79 y 80 cruza el peso total con el índice total. 4) Desde la intersección, lee el CG expresado en porcentaje de MAC; para WT-7 el resultado correcto es 24.0% MAC.",
  "imagenes": ["assets/figura76yfigura77yfigura78.jpg","assets/figura79.jpg","assets/figura80.jpg"],
  "respuestas": [
    {"texto": "A.- 21.6% MAC.", "puntos": 0},
    {"texto": "B.- 22.9% МАС.", "puntos": 0},
    {"texto": "C.- 24.0% MAC.", "puntos": 1}
  ]
},
{
  "texto": "5.- ¿Cuál es el índice del peso total para la distribución de carga WT-9? (Referencia. Figuras 77, 79 у 80).",
  "explicacion": "Ruta visual: 1) En la figura correspondiente a la distribución WT-9, toma los pesos de cada estación/compartimiento. 2) Lleva cada peso a la tabla/gráfico de momentos de las Figuras 77, 79 y 80 y obtén su índice. 3) Suma todos los índices parciales, junto con el índice básico aplicable. 4) El índice total obtenido para WT-9 corresponde a 169.755,2 de índice.",
  "imagenes": ["assets/figura76yfigura77yfigura78.jpg","assets/figura79.jpg","assets/figura80.jpg"],
  "respuestas": [
    {"texto": "A.- 169.755,2 Índice", "puntos": 1},
    {"texto": "B.- 158.797,9 Índice", "puntos": 0},
    {"texto": "C.- 186.565,5 Índice", "puntos": 0}
  ]
},
{
  "texto": "6.- ¿Cuál es el CG en porcentaje de MAC para la distribución de carga WT-11? (Referencia, Figuras 78, 79 y 80).",
  "explicacion": "Ruta visual: 1) En la figura de distribución de carga indicada para WT-11 (Figuras 78), identifica los pesos y momentos/índices de la condición. 2) Suma los índices parciales para obtener el índice total de la aeronave cargada. 3) En las Figuras 79 y 80 cruza el peso total con el índice total. 4) Desde la intersección, lee el CG expresado en porcentaje de MAC; para WT-11 el resultado correcto es 26.8% MAC.",
  "imagenes": ["assets/figura76yfigura77yfigura78.jpg","assets/figura79.jpg","assets/figura80.jpg"],
  "respuestas": [
    {"texto": "A.- 26.8% МАС.", "puntos": 1},
    {"texto": "B.- 27.5% МАС.", "puntos": 0},
    {"texto": "C.- 28.6% МАС.", "puntos": 0}
  ]
},
{
  "texto": "7.- ¿Cuál es el CG en porcentaje de MAC para la distribución de carga WT-14? (Referencia Figuras 78, 79 y 80).",
  "explicacion": "Ruta visual: 1) En la figura de distribución de carga indicada para WT-14 (Figuras 78), identifica los pesos y momentos/índices de la condición. 2) Suma los índices parciales para obtener el índice total de la aeronave cargada. 3) En las Figuras 79 y 80 cruza el peso total con el índice total. 4) Desde la intersección, lee el CG expresado en porcentaje de MAC; para WT-14 el resultado correcto es 31.5% MAC.",
  "imagenes": ["assets/figura76yfigura77yfigura78.jpg","assets/figura79.jpg","assets/figura80.jpg"],
  "respuestas": [
    {"texto": "A.- 30.1% МАС.", "puntos": 0},
    {"texto": "B.- 29.5% МАС.", "puntos": 0},
    {"texto": "C.- 31.5% МАС.", "puntos": 1}
  ]
},
{
  "texto": "8.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación A-3? (Referencia, Figuras 45, 46 y 47).",
  "explicacion": "Ruta visual: 1) Busca la condición de operación A-3 en la tabla indicada y toma los datos de peso/configuración requeridos. 2) En Figuras 45, 46 y 47, ingresa al gráfico de compensador con el peso o condición de despegue correspondiente. 3) Desplázate hasta la curva o línea del CG aplicable. 4) Proyecta hacia la escala de trim y lee el ajuste requerido; para A-3 corresponde 20% MAC.",
  "imagenes": ["assets/figura44yfigura45.jpg", "assets/figura46.jpg", "assets/figura47.jpg"],
  "respuestas": [
    {"texto": "A.- 18% MAC.", "puntos": 0},
    {"texto": "B.- 20% MAC.", "puntos": 1},
    {"texto": "C.- 22% MAC.", "puntos": 0}
  ]
},
{
  "texto": "9.- ¿Cuál es el ajuste de compensador (trim) para la condición de operación A-4? (Referencia, Figuras 45, 46 у 47).",
  "explicacion": "Ruta visual: 1) Busca la condición de operación A-4 en la tabla indicada y toma los datos de peso/configuración requeridos. 2) En Figuras 45, 46 y 47, ingresa al gráfico de compensador con el peso o condición de despegue correspondiente. 3) Desplázate hasta la curva o línea del CG aplicable. 4) Proyecta hacia la escala de trim y lee el ajuste requerido; para A-4 corresponde 22% MAC.",
  "imagenes": ["assets/figura44yfigura45.jpg", "assets/figura46.jpg", "assets/figura47.jpg"],
  "respuestas": [
    {"texto": "A.- 26% MAC.", "puntos": 0},
    {"texto": "B.- 22% MAC.", "puntos": 1},
    {"texto": "C.- 18% MAC.", "puntos": 0}
  ]
},
{
  "texto": "10.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación R-2? (Referencia, Figuras 53 y 55).",
  "explicacion": "Ruta visual: 1) Busca la condición de operación R-2 en la tabla indicada y toma los datos de peso/configuración requeridos. 2) En Figuras 53 y 55, ingresa al gráfico de compensador con el peso o condición de despegue correspondiente. 3) Desplázate hasta la curva o línea del CG aplicable. 4) Proyecta hacia la escala de trim y lee el ajuste requerido; para R-2 corresponde 6-3/4 ANU.",
  "imagenes": ["assets/figura53.jpg", "assets/figura55.jpg"],
  "respuestas": [
    {"texto": "A.- 5-3/4 ΑNU.", "puntos": 0},
    {"texto": "B.- 7 ANU.", "puntos": 0},
    {"texto": "C.- 6-3/4 ANU.", "puntos": 1}
  ]
},
{
  "texto": "11.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación R-4? (Referencia, Figuras 53 y 55).",
  "explicacion": "Ruta visual: 1) Busca la condición de operación R-4 en la tabla indicada y toma los datos de peso/configuración requeridos. 2) En Figuras 53 y 55, ingresa al gráfico de compensador con el peso o condición de despegue correspondiente. 3) Desplázate hasta la curva o línea del CG aplicable. 4) Proyecta hacia la escala de trim y lee el ajuste requerido; para R-4 corresponde 4-1/2 ANU.",
  "imagenes": ["assets/figura53.jpg", "assets/figura55.jpg"],
  "respuestas": [
    {"texto": "A.- 4-1/4 ANU.", "puntos": 0},
    {"texto": "B.- 4-1/2 ANU.", "puntos": 1},
    {"texto": "C.- 5 ANU.", "puntos": 0}
  ]
},
{
  "texto": "12.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación G-1? (Referencia, Figuras 81 у 83).",
  "explicacion": "Ruta visual: 1) Busca la condición de operación G-1 en la tabla indicada y toma los datos de peso/configuración requeridos. 2) En Figuras 81 y 83, ingresa al gráfico de compensador con el peso o condición de despegue correspondiente. 3) Desplázate hasta la curva o línea del CG aplicable. 4) Proyecta hacia la escala de trim y lee el ajuste requerido; para G-1 corresponde 4-3/4 ANU.",
  "imagenes": ["assets/figura81.jpg", "assets/figura83.jpg"],
  "respuestas": [
    {"texto": "A.- 4 ANU.", "puntos": 0},
    {"texto": "B.- 4-1/2 ΑNU.", "puntos": 0},
    {"texto": "C.- 4-3/4 ANU.", "puntos": 1}
  ]
},
{
  "texto": "13.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación G-3? (Referencia, Figuras 81 у 83).",
  "explicacion": "Ruta visual: 1) Busca la condición de operación G-3 en la tabla indicada y toma los datos de peso/configuración requeridos. 2) En Figuras 81 y 83, ingresa al gráfico de compensador con el peso o condición de despegue correspondiente. 3) Desplázate hasta la curva o línea del CG aplicable. 4) Proyecta hacia la escala de trim y lee el ajuste requerido; para G-3 corresponde 4 ANU.",
  "imagenes": ["assets/figura81.jpg", "assets/figura83.jpg"],
  "respuestas": [
    {"texto": "A.- 3-3/4 ANU.", "puntos": 0},
    {"texto": "B.- 4 ANU.", "puntos": 1},
    {"texto": "C.- 4-1/4 ANU.", "puntos": 0}
  ]
},
{
  "texto": "14.- ¿Cuál es el ajuste (setting) de compensador (trim) para la condición de operación G-4? (Referencia, figuras 81 y 83).",
  "explicacion": "Ruta visual: 1) Busca la condición de operación G-4 en la tabla indicada y toma los datos de peso/configuración requeridos. 2) En Figuras 81 y 83, ingresa al gráfico de compensador con el peso o condición de despegue correspondiente. 3) Desplázate hasta la curva o línea del CG aplicable. 4) Proyecta hacia la escala de trim y lee el ajuste requerido; para G-4 corresponde 2-3/4 ANU.",
  "imagenes": ["assets/figura81.jpg", "assets/figura83.jpg"],
  "respuestas": [
    {"texto": "A.- 2-3/4 ΑNU.", "puntos": 1},
    {"texto": "B.- 4 ANU.", "puntos": 0},
    {"texto": "C.- 2-1/2 ANU.", "puntos": 0}
  ]
},
{
  "texto": "15.- ¿Cuál es el nuevo CG si el peso del compartimiento delantero es retirado, de acuerdo a la condición de carga WS-1? (Referencia, Figura 44).",
  "explicacion": "Ruta visual: 1) En la Figura 44 ubica la condición de carga WS-1 y el CG inicial. 2) Aplica la modificación indicada: retirar peso del compartimiento delantero. 3) Usa la escala de cambio de peso/brazo de índice de la misma figura para determinar cuánto se desplaza el momento total. 4) Al proyectar el nuevo punto de balance, el CG se desplaza hacia atrás y la lectura final es 30.0% MAC.",
  "imagenes": ["assets/figura44yfigura45.jpg"],
  "respuestas": [
    {"texto": "A.- 27.1% МАС.", "puntos": 0},
    {"texto": "B.- 26.8% МАС.", "puntos": 0},
    {"texto": "C.- 30.0% MAC.", "puntos": 1}
  ]
},
{
  "texto": "16.- ¿Dónde queda el nuevo CG si el peso es agregado al compartimiento trasero de acuerdo a las condiciones de carga WS-2? (Referencia, Figura 44).",
  "explicacion": "Ruta visual: 1) En la Figura 44 ubica la condición de carga WS-2 y el CG inicial. 2) Aplica la modificación indicada: agregar peso al compartimiento trasero. 3) Usa la escala de cambio de peso/brazo de índice de la misma figura para determinar cuánto se desplaza el momento total. 4) Al proyectar el nuevo punto de balance, el CG se desplaza hacia atrás y la lectura final es +14.82 de brazo de índice.",
  "imagenes": ["assets/figura44yfigura45.jpg"],
  "respuestas": [
    {"texto": "A.- +17.06 Brazo de índice.", "puntos": 0},
    {"texto": "B.- +14.82 Brazo de índice.", "puntos": 1},
    {"texto": "C.- +12.13 Brazo de índice.", "puntos": 0}
  ]
},
{
  "texto": "17.- ¿Cuál es el nuevo CG si el peso es retirado del compartimiento delantero de acuerdo a las condiciones de carga WS-5? (Referencia, Figura 44).",
  "explicacion": "Ruta visual: 1) En la Figura 44 ubica la condición de carga WS-5 y el CG inicial. 2) Aplica la modificación indicada: retirar peso del compartimiento delantero. 3) Usa la escala de cambio de peso/brazo de índice de la misma figura para determinar cuánto se desplaza el momento total. 4) Al proyectar el nuevo punto de balance, el CG se desplaza hacia atrás y la lectura final es 35.2% MAC.",
  "imagenes": ["assets/figura44yfigura45.jpg"],
  "respuestas": [
    {"texto": "A.- 31.9% MAC.", "puntos": 0},
    {"texto": "B.- 19.1% MAC.", "puntos": 0},
    {"texto": "C.- 35.2% МАС.", "puntos": 1}
  ]
},
{
  "texto": "18.- ¿Cuál es el nuevo CG si el peso es cambiado desde el compartimiento delantero al compartimiento trasero de acuerdo a las condiciones de carga WS-1? (Referencia, Figura 44).",
  "explicacion": "Ruta visual: 1) En la Figura 44 ubica la condición de carga WS-1 y el CG inicial. 2) Aplica la modificación indicada: mover peso desde el compartimiento delantero al trasero. 3) Usa la escala de cambio de peso/brazo de índice de la misma figura para determinar cuánto se desplaza el momento total. 4) Al proyectar el nuevo punto de balance, el CG se desplaza hacia atrás y la lectura final es 30.0% MAC.",
  "imagenes": ["assets/figura44yfigura45.jpg"],
  "respuestas": [
    {"texto": "A.- 15.2% MAC", "puntos": 0},
    {"texto": "B.- 29.8% MAC", "puntos": 0},
    {"texto": "C.- 30.0% MAC", "puntos": 1}
  ]
},
{
  "texto": "19.- ¿Cuál es el nuevo CG si el peso es cambiado desde el compartimiento trasero al compartimiento delantero de acuerdo a las condiciones de carga WS-2? (Referencia, Figura 44).",
  "explicacion": "Ruta visual: 1) En la Figura 44 ubica la condición de carga WS-2 y el CG inicial. 2) Aplica la modificación indicada: mover peso desde el compartimiento trasero al delantero. 3) Usa la escala de cambio de peso/brazo de índice de la misma figura para determinar cuánto se desplaza el momento total. 4) Al proyectar el nuevo punto de balance, el CG se desplaza hacia adelante y la lectura final es 22.8% MAC.",
  "imagenes": ["assets/figura44yfigura45.jpg"],
  "respuestas": [
    {"texto": "A.- 26.1% MAC", "puntos": 0},
    {"texto": "B.- 20.5% MAC", "puntos": 0},
    {"texto": "C.- 22.8% MAC", "puntos": 1}
  ]
},
{
  "texto": "20.- ¿Cuál es el nuevo CG si el peso es cambiado desde el compartimiento trasero al compartimiento delantero de acuerdo a las condiciones de carga WS-4? (Referencia, Figura 44).",
  "explicacion": "Ruta visual: 1) En la Figura 44 ubica la condición de carga WS-4 y el CG inicial. 2) Aplica la modificación indicada: mover peso desde el compartimiento trasero al delantero. 3) Usa la escala de cambio de peso/brazo de índice de la misma figura para determinar cuánto se desplaza el momento total. 4) Al proyectar el nuevo punto de balance, el CG se desplaza hacia adelante y la lectura final es 23.5% MAC.",
  "imagenes": ["assets/figura44yfigura45.jpg"],
  "respuestas": [
    {"texto": "A.- 37.0% МАС.", "puntos": 0},
    {"texto": "B.- 23.5% МАС.", "puntos": 1},
    {"texto": "C.- 24.1% МАС.", "puntos": 0}
  ]
},
{
  "texto": "21.- ¿Cuál es el nuevo CG si el peso es cambiado desde el compartimiento delantero al compartimiento trasero de acuerdo a las condiciones de carga WS-5? (Referencia, Figura 44).",
  "explicacion": "Ruta visual: 1) En la Figura 44 ubica la condición de carga WS-5 y el CG inicial. 2) Aplica la modificación indicada: mover peso desde el compartimiento delantero al trasero. 3) Usa la escala de cambio de peso/brazo de índice de la misma figura para determinar cuánto se desplaza el momento total. 4) Al proyectar el nuevo punto de balance, el CG se desplaza hacia atrás y la lectura final es +19.15 de brazo de índice.",
  "imagenes": ["assets/figura44yfigura45.jpg"],
  "respuestas": [
    {"texto": "A.- + 19.15 Brazo de índice", "puntos": 1},
    {"texto": "B.- + 13.93 Brazo de índice", "puntos": 0},
    {"texto": "C.- 97.92 Brazo de índice", "puntos": 0}
  ]
},
{
  "texto": "22.- ¿Cuál es el peso máximo que se puede llevar en un pallet cuya dimensión es 76 x 76 pulgadas? Resistencia del piso: 186 lbs/pié2. Peso del pallet: 93 lbs., Elementos de anclaje: 39 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (76 x 76) / 144 = 40.11 ft². 2) Multiplica por la resistencia del piso: 40.11 x 186 = 7460.7 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 7460.7 - 93 - 39. 4) El peso máximo neto transportable es 7.328,7 Libras.",
  "respuestas": [
    {"texto": "A.- 7.421,3 Libras.", "puntos": 0},
    {"texto": "B.- 7.250,3 Libras.", "puntos": 0},
    {"texto": "C.- 7.328,7 Libras.", "puntos": 1}
  ]
},
{
  "texto": "23.- ¿Cuál es el peso máximo que se puede llevar en un pallet cuya dimensión es 36 x 48 pulgadas? Resistencia del piso: 169 lbs/pié2; Peso del pallet: 47 lbs.; Elementos de anclaje: 33 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (36 x 48) / 144 = 12.00 ft². 2) Multiplica por la resistencia del piso: 12.00 x 169 = 2028.0 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 2028.0 - 47 - 33. 4) El peso máximo neto transportable es 1.948,0 Libras.",
  "respuestas": [
    {"texto": "A.- 1.948,0 Libras", "puntos": 1},
    {"texto": "B.- 1.995,0 Libras", "puntos": 0},
    {"texto": "C.- 1.981,0 Libras", "puntos": 0}
  ]
},
{
  "texto": "24.- ¿Cuál es el peso máximo que se puede llevar en un pallet cuya dimensión es 76 x 74 pulgadas? Resistencia del piso: 176 lbs/pié2; Peso del pallet: 77 lbs.; Elementos de anclaje: 29 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (76 x 74) / 144 = 39.06 ft². 2) Multiplica por la resistencia del piso: 39.06 x 176 = 6873.8 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 6873.8 - 77 - 29. 4) El peso máximo neto transportable es 6.767,8 Libras.",
  "respuestas": [
    {"texto": "A.- 6.767,8 Libras.", "puntos": 1},
    {"texto": "B.- 6.873,7 Libras.", "puntos": 0},
    {"texto": "C.- 6.796,8 Libras.", "puntos": 0}
  ]
},
{
  "texto": "25.- ¿Cuál es el peso máximo que se puede llevar en un pallet cuya dimensión es 81 x 83 pulgadas? Resistencia del piso: 180 lbs/pié2; Peso del pallet: 82 lbs.; Elementos de anclaje: 31 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (81 x 83) / 144 = 46.69 ft². 2) Multiplica por la resistencia del piso: 46.69 x 180 = 8403.8 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 8403.8 - 82 - 31. 4) El peso máximo neto transportable es 8.290,8 Libras.",
  "respuestas": [
    {"texto": "A.- 8.403,7 Libras.", "puntos": 0},
    {"texto": "B.- 8.321,8 Libras.", "puntos": 0},
    {"texto": "C.- 8.290,8 Libras.", "puntos": 1}
  ]
},
{
  "texto": "26.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-1? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Ruta visual: 1) En la Figura 3 ubica la condición BE-1 y toma la distribución de pasajeros, equipaje y combustible. 2) Con las Figuras 6, 8, 9, 10 y 11 obtiene los pesos y momentos de tripulación, filas de asientos, equipaje y combustible. 3) Suma peso total y momento total. 4) Divide momento total por peso total para obtener la estación del CG desde el Datum; la lectura final es Estación 291,8.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 290,3", "puntos": 0},
    {"texto": "B.- Estación 285,8", "puntos": 0},
    {"texto": "C.- Estación 291,8", "puntos": 1}
  ]
},
{
  "texto": "27.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-2? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Ruta visual: 1) En la Figura 3 ubica la condición BE-2 y toma la distribución de pasajeros, equipaje y combustible. 2) Con las Figuras 6, 8, 9, 10 y 11 obtiene los pesos y momentos de tripulación, filas de asientos, equipaje y combustible. 3) Suma peso total y momento total. 4) Divide momento total por peso total para obtener la estación del CG desde el Datum; la lectura final es Estación 292,9.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 295,2", "puntos": 0},
    {"texto": "B.- Estación 292,9", "puntos": 1},
    {"texto": "C.- Estación 293,0", "puntos": 0}
  ]
},
{
  "texto": "28.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-3? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Ruta visual: 1) En la Figura 3 ubica la condición BE-3 y toma la distribución de pasajeros, equipaje y combustible. 2) Con las Figuras 6, 8, 9, 10 y 11 obtiene los pesos y momentos de tripulación, filas de asientos, equipaje y combustible. 3) Suma peso total y momento total. 4) Divide momento total por peso total para obtener la estación del CG desde el Datum; la lectura final es Estación 288,2.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 288,2", "puntos": 1},
    {"texto": "B.- Estación 285,8", "puntos": 0},
    {"texto": "C.- Estación 290,4", "puntos": 0}
  ]
},
{
  "texto": "29.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-4? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Ruta visual: 1) En la Figura 3 ubica la condición BE-4 y toma la distribución de pasajeros, equipaje y combustible. 2) Con las Figuras 6, 8, 9, 10 y 11 obtiene los pesos y momentos de tripulación, filas de asientos, equipaje y combustible. 3) Suma peso total y momento total. 4) Divide momento total por peso total para obtener la estación del CG desde el Datum; la lectura final es Estación 297,7.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 297,4", "puntos": 0},
    {"texto": "B.- Estación 299,6", "puntos": 0},
    {"texto": "C.- Estación 297,7", "puntos": 1}
  ]
},
{
  "texto": "30.- ¿A qué distancia en pulgadas desde el Datum se encuentra el CG bajo las condiciones de carga BE-5? (Referencia figuras 3, 6, 8, 9, 10, y 11).",
  "explicacion": "Ruta visual: 1) En la Figura 3 ubica la condición BE-5 y toma la distribución de pasajeros, equipaje y combustible. 2) Con las Figuras 6, 8, 9, 10 y 11 obtiene los pesos y momentos de tripulación, filas de asientos, equipaje y combustible. 3) Suma peso total y momento total. 4) Divide momento total por peso total para obtener la estación del CG desde el Datum; la lectura final es Estación 288,9.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 288,9", "puntos": 1},
    {"texto": "B.- Estación 290,5", "puntos": 0},
    {"texto": "C.- Estación 289,1", "puntos": 0}
  ]
},
{
  "texto": "31.- ¿Cuál es el cambio de CG si los pasajeros de la fila 1 son cambiados a asientos de la fila 9 bajo las condiciones de carga BE-1? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Ruta visual: 1) Parte del peso total y CG inicial de la condición BE-1, obtenido con las Figuras 3, 6, 8, 9, 10 y 11. 2) Identifica en la Figura 6 los brazos/momentos de las filas involucradas. 3) Calcula el cambio de momento por el movimiento indicado: pasajeros de fila 1 a fila 9. 4) Divide el cambio de momento por el peso final aplicable para obtener el desplazamiento del CG; el resultado es 6,2 pulgadas atrás.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- 1,5 Pulgadas atrás.", "puntos": 0},
    {"texto": "B.- 5,6 Pulgadas atrás.", "puntos": 0},
    {"texto": "C.- 6,2 Pulgadas atrás.", "puntos": 1}
  ]
},
{
  "texto": "32.- ¿Cuál es el cambio de CG si los pasajeros de la fila 1 son movidos a la fila 8, y los pasajeros de la fila 2 son cambiados a la fila 9 bajo las condiciones de carga BE-2? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Ruta visual: 1) Parte del peso total y CG inicial de la condición BE-2, obtenido con las Figuras 3, 6, 8, 9, 10 y 11. 2) Identifica en la Figura 6 los brazos/momentos de las filas involucradas. 3) Calcula el cambio de momento por el movimiento indicado: pasajeros de fila 1 a fila 8 y de fila 2 a fila 9. 4) Divide el cambio de momento por el peso final aplicable para obtener el desplazamiento del CG; el resultado es 7,8 pulgadas atrás.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- 9,2 Pulgadas atrás.", "puntos": 0},
    {"texto": "B.- 5,7 Pulgadas atrás", "puntos": 0},
    {"texto": "C.- 7,8 Pulgadas atrás.", "puntos": 1}
  ]
},
{
  "texto": "33.- ¿Cuál es el cambio de CG si cuatro pasajeros que pesan 170 libras son agregados: dos a los asientos de la fila 6 y dos a los asientos de la fila 7 bajo las condiciones de carga BE-3? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Ruta visual: 1) Parte del peso total y CG inicial de la condición BE-3, obtenido con las Figuras 3, 6, 8, 9, 10 y 11. 2) Identifica en la Figura 6 los brazos/momentos de las filas involucradas. 3) Calcula el cambio de momento por el movimiento indicado: cuatro pasajeros de 170 lb agregados en filas 6 y 7. 4) Divide el cambio de momento por el peso final aplicable para obtener el desplazamiento del CG; el resultado es 1,8 pulgadas atrás.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- 3,5 Pulgadas atrás.", "puntos": 0},
    {"texto": "B.- 2,2 Pulgadas atrás.", "puntos": 0},
    {"texto": "C.- 1,8 Pulgadas atrás.", "puntos": 1}
  ]
},
{
  "texto": "34.- ¿Cuál es el cambio de CG si todos los pasajeros de la fila 2 y 4 son desembarcados bajo las condiciones de carga BE-4? (Referencia figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Ruta visual: 1) Parte del peso total y CG inicial de la condición BE-4, obtenido con las Figuras 3, 6, 8, 9, 10 y 11. 2) Identifica en la Figura 6 los brazos/momentos de las filas involucradas. 3) Calcula el cambio de momento por el movimiento indicado: desembarcar todos los pasajeros de filas 2 y 4. 4) Divide el cambio de momento por el peso final aplicable para obtener el desplazamiento del CG; el resultado es 2,5 pulgadas atrás.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- 2,5 Pulgadas atrás.", "puntos": 1},
    {"texto": "B.- 2,5 Pulgadas adelante.", "puntos": 0},
    {"texto": "C.- 2.0 Pulgadas atrás.", "puntos": 0}
  ]
},
{
  "texto": "35.- ¿Cuál es el desplazamiento de CG si los pasajeros de la fila 8 son movidos a la fila 2, y los pasajeros de la fila 7 son cambiados a la fila 1 bajo las condiciones de carga BE-5? (Referencia, Figuras 3, 6, 8, 9, 10, у 11).",
  "explicacion": "Ruta visual: 1) Parte del peso total y CG inicial de la condición BE-5, obtenido con las Figuras 3, 6, 8, 9, 10 y 11. 2) Identifica en la Figura 6 los brazos/momentos de las filas involucradas. 3) Calcula el cambio de momento por el movimiento indicado: pasajeros de fila 8 a fila 2 y de fila 7 a fila 1. 4) Divide el cambio de momento por el peso final aplicable para obtener el desplazamiento del CG; el resultado es 8,9 pulgadas adelante.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura5yfigura6.jpg", "assets/figura8.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- 1,0 Pulgadas adelante.", "puntos": 0},
    {"texto": "B.- 8,9 Pulgadas adelante.", "puntos": 1},
    {"texto": "C.- 6,5 Pulgadas adelante.", "puntos": 0}
  ]
},
{
  "texto": "36.- ¿Cuál es el CG en pulgadas desde el Datum bajo las condiciones de carga BE-7? (Referencia, Figuras 4, 7, 9, 10 у 11).",
  "explicacion": "Ruta visual: 1) En la Figura 4 ubica la condición de carga BE-7. 2) Usa la Figura 7 para tomar los brazos/momentos de cada sección de carga y las Figuras 9, 10 y 11 para combustible y datos complementarios. 3) Suma todos los pesos y momentos. 4) Divide momento total por peso total para leer el CG en pulgadas desde el Datum; para BE-7 corresponde Estación 297,8.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 296,0", "puntos": 0},
    {"texto": "B.- Estación 297,8", "puntos": 1},
    {"texto": "C.- Estación 299,9", "puntos": 0}
  ]
},
{
  "texto": "37.- ¿Cuál es el CG en pulgadas desde el Datum bajo las condiciones de carga BE-8? (Referencia, Figuras 4, 7, 9, 10 у 11).",
  "explicacion": "Ruta visual: 1) En la Figura 4 ubica la condición de carga BE-8. 2) Usa la Figura 7 para tomar los brazos/momentos de cada sección de carga y las Figuras 9, 10 y 11 para combustible y datos complementarios. 3) Suma todos los pesos y momentos. 4) Divide momento total por peso total para leer el CG en pulgadas desde el Datum; para BE-8 corresponde Estación 302,0.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 297,4", "puntos": 0},
    {"texto": "B.- Estación 298,1", "puntos": 0},
    {"texto": "C.- Estación 302,0", "puntos": 1}
  ]
},
{
  "texto": "38.- ¿Cuál es el CG en pulgadas desde el Datum bajo las condiciones de carga BE-9? (Referencia figuras 4, 7, 9, 10 y 11).",
  "explicacion": "Ruta visual: 1) En la Figura 4 ubica la condición de carga BE-9. 2) Usa la Figura 7 para tomar los brazos/momentos de cada sección de carga y las Figuras 9, 10 y 11 para combustible y datos complementarios. 3) Suma todos los pesos y momentos. 4) Divide momento total por peso total para leer el CG en pulgadas desde el Datum; para BE-9 corresponde Estación 301,2.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 296,7", "puntos": 0},
    {"texto": "B.- Estación 297,1", "puntos": 0},
    {"texto": "C.- Estación 301,2", "puntos": 1}
  ]
},
{
  "texto": "39.- ¿Cuál es el cambio de CG si 300 libras de la sección A son movidas a la sección H bajo las condiciones de carga BE-6? (Referencia, Figuras 4, 7, 9, 10 у 11).",
  "explicacion": "Ruta visual: 1) Toma el peso y momento inicial de la condición BE-6 con las Figuras 4, 7, 9, 10 y 11. 2) En la Figura 7 identifica el brazo/momento de las secciones afectadas. 3) Aplica la modificación: mover 300 lb desde la sección A hacia la sección H, sumando o restando los momentos correspondientes. 4) Con el nuevo peso y momento total calcula la nueva estación de CG; el resultado correcto es 4,0 pulgadas atrás.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- 4,1 Pulgadas atrás.", "puntos": 0},
    {"texto": "B.- 3,5 Pulgadas atrás.", "puntos": 0},
    {"texto": "C.- 4,0 Pulgadas atrás.", "puntos": 1}
  ]
},
{
  "texto": "40.- ¿Cuál es el cambio de CG si la carga de la sección F es movida a la sección A, y 200 libras de carga de la sección G son agregadas a la sección B bajo las condiciones de carga BE-7? (Referencia, figuras 4, 7, 9, 10 y 11).",
  "explicacion": "Ruta visual: 1) Toma el peso y momento inicial de la condición BE-7 con las Figuras 4, 7, 9, 10 y 11. 2) En la Figura 7 identifica el brazo/momento de las secciones afectadas. 3) Aplica la modificación: mover la carga de F hacia A y agregar 200 lb de G en B, sumando o restando los momentos correspondientes. 4) Con el nuevo peso y momento total calcula la nueva estación de CG; el resultado correcto es 8,2 pulgadas adelante.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- 7,5 Pulgadas adelante.", "puntos": 0},
    {"texto": "B.- 8,0 Pulgadas adelante.", "puntos": 0},
    {"texto": "C.- 8,2 Pulgadas adelante.", "puntos": 1}
  ]
},
{
  "texto": "41.- ¿Cuál es el CG si la carga de las secciones A, B, J, K y L es retirada bajo las condiciones de carga BE-8? (Referencia, Figuras 4, 7, 9, 10 y 11).",
  "explicacion": "Ruta visual: 1) Toma el peso y momento inicial de la condición BE-8 con las Figuras 4, 7, 9, 10 y 11. 2) En la Figura 7 identifica el brazo/momento de las secciones afectadas. 3) Aplica la modificación: retirar la carga de las secciones A, B, J, K y L, sumando o restando los momentos correspondientes. 4) Con el nuevo peso y momento total calcula la nueva estación de CG; el resultado correcto es Estación 297,0.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 292,7", "puntos": 0},
    {"texto": "B.- Estación 297,0", "puntos": 1},
    {"texto": "C.- Estación 294,6", "puntos": 0}
  ]
},
{
  "texto": "42.- ¿Cuál es el CG si se carga las secciones F, G y Ha su máxima capacidad bajo las condiciones de carga BE-9? (Referencia, Figuras 4, 7, 9, 10 y 11).",
  "explicacion": "Ruta visual: 1) Toma el peso y momento inicial de la condición BE-9 con las Figuras 4, 7, 9, 10 y 11. 2) En la Figura 7 identifica el brazo/momento de las secciones afectadas. 3) Aplica la modificación: cargar las secciones F, G y H a su máxima capacidad, sumando o restando los momentos correspondientes. 4) Con el nuevo peso y momento total calcula la nueva estación de CG; el resultado correcto es Estación 307,5.",
  "imagenes": ["assets/figura3yfigura4.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "assets/figura10.jpg", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- Estación 307,5", "puntos": 1},
    {"texto": "B.- Estación 305,4", "puntos": 0},
    {"texto": "C.- Estación 303,5", "puntos": 0}
  ]
},
{
  "texto": "43.- ¿Qué límite es excedido bajo las condiciones de operación BE-11? (Referencia Figuras 5, 7, 9 y 11).",
  "explicacion": "Ruta visual: 1) En la Figura 5 toma los pesos y condiciones de operación BE-11. 2) Con las Figuras 7, 9 y 11 determina el peso, combustible y CG resultante para despegue/aterrizaje según corresponda. 3) Compara el punto obtenido con la envolvente y límites de peso publicados. 4) El límite excedido para BE-11 es: el límite trasero del CG es excedido con peso de despegue.",
  "imagenes": ["assets/figura5yfigura6.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- EI ZFW es excedido.", "puntos": 0},
    {"texto": "B.- El límite trasero del CG es excedido con peso de despegue.", "puntos": 1},
    {"texto": "C.- El límite trasero del CG es excedido con peso de aterrizaje.", "puntos": 0}
  ]
},
{
  "texto": "44.- ¿Qué límite (límites) es (son) excedido (excedidos) bajo las condiciones de operación BE-12? (Referencia Figuras 5, 7, 9 y 11).",
  "explicacion": "Ruta visual: 1) En la Figura 5 toma los pesos y condiciones de operación BE-12. 2) Con las Figuras 7, 9 y 11 determina el peso, combustible y CG resultante para despegue/aterrizaje según corresponda. 3) Compara el punto obtenido con la envolvente y límites de peso publicados. 4) El límite excedido para BE-12 es: el ZFW y el peso máximo de despegue son excedidos.",
  "imagenes": ["assets/figura5yfigura6.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- El máximo ZFW es excedido.", "puntos": 0},
    {"texto": "B.- El límite trasero del CG es excedido en el aterrizaje.", "puntos": 0},
    {"texto": "C.- EI ZFW y peso máximo de despegue son excedidos.", "puntos": 1}
  ]
},
{
  "texto": "45.- ¿Qué límite (s) es (son) excedido (s) bajo las condiciones de operación BE-15? (Referencia Figuras 5, 7, 9 y 11).",
  "explicacion": "Ruta visual: 1) En la Figura 5 toma los pesos y condiciones de operación BE-15. 2) Con las Figuras 7, 9 y 11 determina el peso, combustible y CG resultante para despegue/aterrizaje según corresponda. 3) Compara el punto obtenido con la envolvente y límites de peso publicados. 4) El límite excedido para BE-15 es: el peso máximo de despegue y el límite delantero del CG de despegue son excedidos.",
  "imagenes": ["assets/figura5yfigura6.jpg", "assets/figura7.jpg", "assets/figura9.jpg", "", "assets/figura11.jpg"],
  "respuestas": [
    {"texto": "A.- El peso máximo de despegue es excedido.", "puntos": 0},
    {"texto": "B.- El ZFW máximo y el límite delantero del CG de despegue son excedidos.", "puntos": 0},
    {"texto": "C.- El peso máximo de despegue y el límite delantero del CG de despegue son excedidos.", "puntos": 1}
  ]
},
{
  "texto": "46.- ¿Cuál es el peso máximo que se puede transportar en un pallet que mide 37 x 39 pulgadas? Límite de resistencia de piso: 115 lbs/pie2; Peso del pallet: 37 lbs.; Elementos de amarre: 21 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (37 x 39) / 144 = 10.02 ft². 2) Multiplica por la resistencia del piso: 10.02 x 115 = 1152.4 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 1152.4 - 37 - 21. 4) El peso máximo neto transportable es 1.094,3 Libras.",
  "respuestas": [
    {"texto": "A.- 1.094,3 Libras.", "puntos": 1},
    {"texto": "B.- 1.115,3 Libras", "puntos": 0},
    {"texto": "C.- 1.129,3 Libras", "puntos": 0}
  ]
},
{
  "texto": "47.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 35 x 37,5 pulgadas? Límite de resistencia de piso: 144 lbs/pie2; Peso del pallet: 34 lbs.; Elementos de amarre: 23 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (35 x 37.5) / 144 = 9.11 ft². 2) Multiplica por la resistencia del piso: 9.11 x 144 = 1312.5 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 1312.5 - 34 - 23. 4) El peso máximo neto transportable es 1.255,4 Libras.",
  "respuestas": [
    {"texto": "A.- 1.278,4 Libras.", "puntos": 0},
    {"texto": "B.- 1.289,4 Libras.", "puntos": 0},
    {"texto": "C.- 1.255,4 Libras.", "puntos": 1}
  ]
},
{
  "texto": "48.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 36,5 x 48,5 pulgadas? Límite de resistencia de piso: 112 lbs/pie2; Peso del pallet: 45 lbs.; Elementos de amarre: 29 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (36.5 x 48.5) / 144 = 12.29 ft². 2) Multiplica por la resistencia del piso: 12.29 x 112 = 1376.9 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 1376.9 - 45 - 29. 4) El peso máximo neto transportable es 1.302,8 Libras.",
  "respuestas": [
    {"texto": "A.- 1.331,8 Libras.", "puntos": 0},
    {"texto": "B.- 1.302,8 Libras.", "puntos": 1},
    {"texto": "C.- 1.347,8 Libras.", "puntos": 0}
  ]
},
{
  "texto": "49.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 42,6 x 48,7 pulgadas? Límite de resistencia de piso: 121 lbs/pie2; Peso del pallet: 47 lbs.; Elementos de amarre: 33 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (42.6 x 48.7) / 144 = 14.41 ft². 2) Multiplica por la resistencia del piso: 14.41 x 121 = 1743.3 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 1743.3 - 47 - 33. 4) El peso máximo neto transportable es 1.663,2 Libras.",
  "respuestas": [
    {"texto": "A.- 1.710,2 Libras.", "puntos": 0},
    {"texto": "B.- 1.663,2 Libras.", "puntos": 1},
    {"texto": "C.- 1.696,2 Libras.", "puntos": 0}
  ]
},
{
  "texto": "50.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 24,6 x 68,7 pulgadas? Límite de resistencia de piso: 85 lbs/pie2; Peso del pallet: 44 lbs.; Elementos de amarre: 29 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (24.6 x 68.7) / 144 = 11.74 ft². 2) Multiplica por la resistencia del piso: 11.74 x 85 = 997.6 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 997.6 - 44 - 29. 4) El peso máximo neto transportable es 924,5 Libras.",
  "respuestas": [
    {"texto": "A.- 924,5 Libras.", "puntos": 1},
    {"texto": "B.- 968,6 Libras.", "puntos": 0},
    {"texto": "C.- 953,6 Libras.", "puntos": 0}
  ]
},
{
  "texto": "51.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 33,5 x 48,5 pulgadas? Límite de resistencia de piso -66 lbs/pie2; Peso del pallet -34 lbs.; Elementos de amarre -29 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (33.5 x 48.5) / 144 = 11.28 ft². 2) Multiplica por la resistencia del piso: 11.28 x 66 = 744.7 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 744.7 - 34 - 29. 4) El peso máximo neto transportable es 681,6 Libras.",
  "respuestas": [
    {"texto": "A.- 744,6 Libras.", "puntos": 0},
    {"texto": "B.- 681,6 Libras.", "puntos": 1},
    {"texto": "C.- 663,0 Libras.", "puntos": 0}
  ]
},
{
  "texto": "52.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 36,5 x 48,5 pulgadas? Límite de resistencia de piso -107 lbs/pie2; Peso del pallet -37 lbs.; Elementos de amarre -33 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (36.5 x 48.5) / 144 = 12.29 ft². 2) Multiplica por la resistencia del piso: 12.29 x 107 = 1315.4 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 1315.4 - 37 - 33. 4) El peso máximo neto transportable es 1.245,3 Libras.",
  "respuestas": [
    {"texto": "A.- 1.295,3 Libras.", "puntos": 0},
    {"texto": "B.- 1.212,3 Libras.", "puntos": 0},
    {"texto": "C.- 1.245,3 Libras.", "puntos": 1}
  ]
},
{
  "texto": "53.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 42,6 x 48,7 pulgadas? Límite de resistencia de piso -117 lbs/pie2; Peso del pallet -43 lbs.; Elementos de amarre -31 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (42.6 x 48.7) / 144 = 14.41 ft². 2) Multiplica por la resistencia del piso: 14.41 x 117 = 1685.6 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 1685.6 - 43 - 31. 4) El peso máximo neto transportable es 1.611,6 Libras.",
  "respuestas": [
    {"texto": "A.- 1.611,6 Libras.", "puntos": 1},
    {"texto": "B.- 1.654,6 Libras.", "puntos": 0},
    {"texto": "C.- 1.601,6 Libras.", "puntos": 0}
  ]
},
{
  "texto": "54.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 96,1 x 133,3 pulgadas? Límite de resistencia de piso -249 lbs/pie2; Peso del pallet –347 lbs.; Elementos de amarre –134 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (96.1 x 133.3) / 144 = 88.96 ft². 2) Multiplica por la resistencia del piso: 88.96 x 249 = 22150.8 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 22150.8 - 347 - 134. 4) El peso máximo neto transportable es 22.120,8 Libras.",
  "respuestas": [
    {"texto": "A.- 21.669, 8 Libras.", "puntos": 0},
    {"texto": "B.- 21.803, 8 Libras.", "puntos": 0},
    {"texto": "C.- 22.120, 8 Libras.", "puntos": 1}
  ]
},
{
  "texto": "55.- ¿Cuál es el peso máximo que puede transportarse en un pallet que mide 98,7 x 78,9 pulgadas? Límite de resistencia de piso -183 lbs/pie2; Peso del pallet –161 lbs.; Elementos de amarre -54 lbs.",
  "explicacion": "Procedimiento: 1) Convierte el área del pallet a pies cuadrados: (98.7 x 78.9) / 144 = 54.08 ft². 2) Multiplica por la resistencia del piso: 54.08 x 183 = 9896.5 lb de carga bruta admisible sobre el piso. 3) Resta el peso del pallet y los elementos de amarre: 9896.5 - 161 - 54. 4) El peso máximo neto transportable es 9.735,5 Libras.",
  "respuestas": [
    {"texto": "A.- 9.896,5 Libras.", "puntos": 0},
    {"texto": "B.- 9.735,5 Libras.", "puntos": 1},
    {"texto": "C.- 9.681,5 Libras.", "puntos": 0}
  ]
},
{
  "texto": "56.- La distancia horizontal medida desde la línea de referencia (reference datum) al centro de gravedad de un peso (item), se denomina:",
  "explicacion": "El brazo (arm) es la distancia horizontal desde el Datum hasta el centro de gravedad del ítem. En peso y balance se usa para calcular el momento: peso x brazo.",
  "respuestas": [
    {"texto": "A.- MAC.", "puntos": 0},
    {"texto": "B.- Momento.", "puntos": 0},
    {"texto": "C.- Brazo.", "puntos": 1}
  ]
},
{
  "texto": "57.- El Datum (línea de referencia) es una línea imaginaria desde la cual se miden los brazos para los fines de la estiba de una aeronave. La posición del Datum para cada aeronave la determina:",
  "explicacion": "El Datum lo define el fabricante de la aeronave como referencia de diseño. Desde esa línea imaginaria se miden todos los brazos o estaciones usados en los cálculos de peso y estiba.",
  "respuestas": [
    {"texto": "A.- El fabricante de la aeronave.", "puntos": 1},
    {"texto": "B.- Cada Operador.", "puntos": 0},
    {"texto": "C.- El Piloto o el Despachador.", "puntos": 0}
  ]
},
{
  "texto": "58.- Para los efectos de peso y estiba, por carga de combustible (fuel load) se entiende:",
  "explicacion": "La carga de combustible considera el combustible consumible más el combustible no consumible que permanece en estanques y cañerías. Por eso no se toma sólo el combustible utilizable del vuelo.",
  "respuestas": [
    {"texto": "A.- El combustible consumible más el combustible no consumible que queda en los estanques y cañerías.", "puntos": 1},
    {"texto": "B.- Sólo el combustible consumible.", "puntos": 0},
    {"texto": "C.- El combustible consumible más una cantidad fija de aceite.", "puntos": 0}
  ]
},
{
  "texto": "59.- En peso y estiba se entiende por LEMAC:",
  "explicacion": "LEMAC significa Leading Edge of Mean Aerodynamic Chord: es el borde de ataque de la cuerda aerodinámica media. Se usa como referencia para expresar el CG en porcentaje de MAC.",
  "respuestas": [
    {"texto": "A.- El borde de ataque de la mayor cuerda del ala.", "puntos": 0},
    {"texto": "B.- La cuerda del ala utilizada para límites de CG.", "puntos": 0},
    {"texto": "C.- El borde de ataque de la cuerda aerodinámica media.", "puntos": 1}
  ]
},
{
  "texto": "60.- El producto del peso de un item (carga) multiplicado por su brazo desde el DATUM, se denomina:",
  "explicacion": "El momento es el producto del peso por su brazo respecto del Datum. Este valor representa el efecto de giro que ese peso produce en el balance longitudinal de la aeronave.",
  "respuestas": [
    {"texto": "A.- Momento.", "puntos": 1},
    {"texto": "B.- Momento Índice.", "puntos": 0},
    {"texto": "C.- LEMAC.", "puntos": 0}
  ]
},
{
  "texto": "61.- La distancia media entre el borde de ataque y el borde de fuga de un ala, se denomina:",
  "explicacion": "La MAC (Mean Aerodynamic Chord) es la cuerda aerodinámica media: una distancia representativa entre el borde de ataque y el borde de fuga del ala usada para expresar límites de CG.",
  "respuestas": [
    {"texto": "A.- LEMAC.", "puntos": 0},
    {"texto": "B.- MAC.", "puntos": 1},
    {"texto": "C.- DATUM.", "puntos": 0}
  ]
},
{
  "texto": "62.- En Peso y Estiba, un momento dividido por una constante (100, 1.000 o 10.000), se denomina:",
  "explicacion": "El índice es un momento dividido por una constante, normalmente 100, 1.000 o 10.000. Se usa para trabajar con números más pequeños sin cambiar la relación de balance.",
  "respuestas": [
    {"texto": "A.- Datum.", "puntos": 0},
    {"texto": "B.- Centro de gravedad (CG).", "puntos": 0},
    {"texto": "C.- Índice (Index).", "puntos": 1}
  ]
},
{
  "texto": "63.- Una ubicación en una aeronave, que se identifica por un número que representa su distancia a la línea de referencia o datum, se conoce como:",
  "explicacion": "Una estación (station) es una ubicación identificada por su distancia al Datum. Por ejemplo, una estación 300 se encuentra 300 pulgadas desde la línea de referencia definida para esa aeronave.",
  "respuestas": [
    {"texto": "A.- Estación (Station).", "puntos": 1},
    {"texto": "B.- Línea de Referencia (Datum).", "puntos": 0},
    {"texto": "C.- Brazo (Arm).", "puntos": 0}
  ]
},
{
  "texto": "64.- El peso del avión que incluye a la tripulación con todos los elementos para el vuelo, pero sin la carga de pago o combustible, se conoce como:",
  "explicacion": "El peso básico de operación incluye la aeronave lista para operar, tripulación y elementos operacionales, pero excluye carga de pago y combustible utilizable del vuelo.",
  "respuestas": [
    {"texto": "A.- Peso con combustible cero (ZFW).", "puntos": 0},
    {"texto": "B.- Peso básico de operación.", "puntos": 1},
    {"texto": "C.- Peso vacío de la aeronave.", "puntos": 0}
  ]
},
{
  "texto": "65.- El peso vacío de una aeronave incluye:",
  "explicacion": "El peso vacío incluye estructura, motores y equipos fijos, además de fluidos no drenables como hidráulico, aceite residual y combustible no utilizable. Por eso la alternativa completa es la B.",
  "respuestas": [
    {"texto": "A.- Estructura, motores y equipos fijos.", "puntos": 0},
    {"texto": "B.- Lo anterior, más líquido hidráulico, aceite y combustible no utilizable.", "puntos": 1},
    {"texto": "C.- Lo anterior, excluyendo el líquido hidráulico.", "puntos": 0}
  ]
},
{
  "texto": "66.- El peso con combustible cero (ZFW) para cada vuelo en particular, está constituido por:",
  "explicacion": "El ZFW de un vuelo se obtiene sumando el peso de operación más la carga de pago. Es el peso de la aeronave cargada antes de considerar el combustible utilizable.",
  "respuestas": [
    {"texto": "A.- El peso de operación más la carga de pago.", "puntos": 1},
    {"texto": "B.- El peso de operación más los líquidos residuales.", "puntos": 0},
    {"texto": "C.- El peso vacío de la aeronave más la carga de pago.", "puntos": 0}
  ]
},
{
  "texto": "67.- El peso máximo de despegue es:",
  "explicacion": "El peso máximo de despegue es el máximo peso permitido al inicio de la carrera de despegue. Puede estar limitado por estructura, pista, temperatura, altitud o performance.",
  "respuestas": [
    {"texto": "A.- El peso de plataforma menos el combustible de rodaje.", "puntos": 0},
    {"texto": "B.- El peso de operación menos el combustible consumido en rodaje.", "puntos": 0},
    {"texto": "C.- Es el máximo peso permitido al inicio de la carrera de despegue.", "puntos": 1}
  ]
},
{
  "texto": "68.- Marque la aseveración correcta con relación al peso y estiba de una aeronave:",
  "explicacion": "Un CG demasiado atrás y fuera de límites reduce la estabilidad longitudinal y puede dificultar la recuperación de una pérdida. Por eso es una de las condiciones más críticas de peso y balance.",
  "respuestas": [
    {"texto": "A.- Los límites los establece el Piloto para cada vuelo.", "puntos": 0},
    {"texto": "B.- Estibar un avión con el CG atrás fuera de límites afecta gravemente la estabilidad y recuperación de stall.", "puntos": 1},
    {"texto": "C.- El consumo de combustible no afecta la posición del CG.", "puntos": 0}
  ]
},
{
  "texto": "69.- Marque la(s) aseveración(es) incorrecta(s) con relación al Peso y Estiba de una aeronave:",
  "explicacion": "La aseveración incorrecta es la A, porque el operador sí debe mantener registros completos y actualizados de peso y CG. El piloto también debe comprender los cambios de carga, y tras reparaciones mayores corresponde actualizar peso vacío y CG.",
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
    'explicacion': r'La energía solar calienta desigualmente la superficie terrestre, originando gradientes de temperatura y presión que impulsan la circulación atmosférica y el tiempo meteorológico. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OMM-No. 49.',
    
    'respuestas': [
     {'texto': 'A.- Las variaciones de la energía solar en la superficie de la Tierra.','puntos': 1},
     {'texto': 'B.- Los cambios de la presión del aire sobre la superficie de la Tierra.','puntos': 0},
     {'texto': 'C.- El movimiento de las masas de aire desde las áreas húmedas hacia las áreas secas.','puntos': 0},
     ]         
  },

{
    'texto': '2.- ¿Cuál es el movimiento característico del aire en una zona de alta presión?',
    'explicacion': r'En una alta presión predomina la subsidencia: el aire desciende hacia la superficie y luego diverge horizontalmente desde el centro de la alta. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Ascender desde la alta en la superficie hacia presiones menores en las mayores altitudes.','puntos': 0},
     {'texto': 'B.- Descender hacia la superficie y luego desplazarse hacia fuera de la alta.','puntos': 1},
     {'texto': 'C.- Salir de la alta en niveles superiores y entrar en la alta en la superficie.','puntos': 0},
     ]         
  },

{
    'texto': '3.- ¿En qué ubicación la fuerza de Coriolis tiene menos efecto en la dirección del viento?',
    'explicacion': r'La fuerza de Coriolis es nula en el Ecuador y aumenta hacia los polos; por eso allí desvía menos la dirección del viento. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OMM-No. 8.',
    
    'respuestas': [
     {'texto': 'A.- En los polos.','puntos': 0},
     {'texto': 'B.- En latitudes medias (30° a 60°).','puntos': 0},
     {'texto': 'C.- En el Ecuador.','puntos': 1},
     ]         
  },

{
    'texto': '4.- La troposfera se caracteriza por:',
    'explicacion': r'La troposfera es la capa donde ocurre la mayor parte del tiempo y, en condiciones normales, la temperatura disminuye con la altitud. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OMM-No. 49.',
    
    'respuestas': [
     {'texto': 'A.- Contener toda la humedad de la atmósfera.','puntos': 0},
     {'texto': 'B.- Tener, en general, una disminución de temperatura a medida que la altura aumenta.','puntos': 1},
     {'texto': 'C.- Tener una altura promedio, en su parte más alta, de 10 kilómetros (6 millas).','puntos': 0},
     ]         
  },

{
    'texto': '5.- ¿Qué característica se asocia con la tropopausa?',
    'explicacion': r'La tropopausa marca el límite superior de la troposfera y se identifica por un cambio marcado del gradiente vertical de temperatura. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OMM-No. 49.',
    
    'respuestas': [
     {'texto': 'A.- Ausencia de viento y turbulencia.','puntos': 0},
     {'texto': 'B.- Ser el límite superior absoluto de toda formación nubosa.','puntos': 0},
     {'texto': 'C.- Cambio brusco en el gradiente vertical de temperatura.','puntos': 1},
     ]         
  },

{
    'texto': '6.- ¿Cuál de estos lugares es la ubicación común para inversiones de temperatura?',
    'explicacion': r'La estratosfera presenta estabilidad e inversión térmica relativa, porque la temperatura deja de disminuir y tiende a aumentar con la altura. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- La tropopausa.','puntos': 0},
     {'texto': 'B.- La estratosfera.','puntos': 1},
     {'texto': 'C.- La base de una nube de tipo cúmulo.','puntos': 0},
     ]         
  },

{
    'texto': '7.- Las corrientes de chorro (jetstreams) normalmente se ubican en:',
    'explicacion': r'Los jetstreams se localizan normalmente cerca de la tropopausa, donde existen fuertes gradientes horizontales de temperatura. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- La estratosfera, en regiones de presiones muy bajas.','puntos': 0},
     {'texto': 'B.- En la tropopausa, donde hay intensos gradientes de temperatura.','puntos': 1},
     {'texto': 'C.- En una sola y continua banda rodeando la Tierra, y donde se produce un quiebre entre la tropopausa ecuatorial y la tropopausa polar.','puntos': 0},
     ]         
  },

{
    'texto': '8.- Los vientos máximos asociados al jetstream generalmente ocurren en:',
    'explicacion': r'Los máximos vientos del jet se ubican cerca de los quiebres de tropopausa, especialmente hacia el lado polar del núcleo. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Las vecindades de los quiebres de la tropopausa en el lado polar del núcleo del jet.','puntos': 1},
     {'texto': 'B.- Bajo el núcleo del Jet donde se ubica una larga y recta franja del jetstream.','puntos': 0},
     {'texto': 'C.- En el lado ecuatorial del jetstream, donde la humedad ha formado nubes del tipo cirros.','puntos': 0},
     ]         
  },

{
    'texto': '9.- ¿Qué término describe la elongación de una baja presión?',
    'explicacion': r'Una vaguada o trough es la elongación de una baja presión, asociada a curvatura ciclónica e inestabilidad potencial. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OMM-No. 306.',
    
    'respuestas': [
     {'texto': 'A.- Vaguada o trough.','puntos': 1},
     {'texto': 'B.- Cuña o ridge.','puntos': 0},
     {'texto': 'C.- Huracán o tifón.','puntos': 0},
     ]         
  },

{
    'texto': '10.- ¿Qué caracteriza un frente estacionario?',
    'explicacion': r'Un frente estacionario permanece casi sin desplazamiento y suele presentar vientos de superficie casi paralelos a la zona frontal. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- La superficie del frente cálido se mueve a la mitad de la velocidad de la superficie del frente frío.','puntos': 0},
     {'texto': 'B.- El tiempo asociado es una combinación de las condiciones extremas del frente frío y del frente cálido.','puntos': 0},
     {'texto': 'C.- Los vientos de superficie tienden a soplar paralelos a la zona frontal.','puntos': 1},
     ]         
  },

{
    'texto': '11.- ¿Qué evento generalmente ocurre en el hemisferio sur después que una aeronave cruza un frente frío hacia el aire frío?',
    'explicacion': r'Detrás de un frente frío ingresa aire más denso y frío, por lo que normalmente aumenta la presión atmosférica. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- La diferencia entre la temperatura ambiente y la temperatura del punto de rocío disminuye.','puntos': 0},
     {'texto': 'B.- La dirección del viento cambia hacia la derecha.','puntos': 0},
     {'texto': 'C.- La presión atmosférica aumenta.','puntos': 1},
     ]         
  },

{
    'texto': '12.- ¿Qué tipo de cambios en el tiempo se puede esperar en una zona de frontolisis?',
    'explicacion': r'La frontolisis es el debilitamiento o disipación de un frente al disminuir el contraste entre masas de aire. Fuente: OMM-No. 306; FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- El tiempo frontal se intensificará.','puntos': 0},
     {'texto': 'B.- El frente se disipará.','puntos': 1},
     {'texto': 'C.- El frente se moverá a una velocidad mayor.','puntos': 0},
     ]         
  },

{
    'texto': '13.- ¿Qué factor atmosférico causa el movimiento rápido de los frentes en superficie?',
    'explicacion': r'Los vientos en altura que cruzan el frente favorecen su desplazamiento rápido al transferir movimiento a la zona frontal de superficie. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Vientos de altura que soplen a través del frente.','puntos': 1},
     {'texto': 'B.- Una baja en altura ubicada exactamente sobre la baja de superficie.','puntos': 0},
     {'texto': 'C.- El frente frío cuando alcanza y eleva al frente cálido.','puntos': 0},
     ]         
  },

{
    'texto': '14.- ¿Bajo qué condiciones meteorológicas se pueden formar ondas frontales y áreas de baja presión?',
    'explicacion': r'Las ondas frontales y bajas secundarias se forman con mayor facilidad en frentes fríos lentos o estacionarios. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- En frentes cálidos o frentes ocluidos.','puntos': 0},
     {'texto': 'B.- En frentes fríos de movimiento lento o frentes estacionarios.','puntos': 1},
     {'texto': 'C.- En oclusiones de frente frío.','puntos': 0},
     ]         
  },

{
    'texto': '15.- ¿Dónde está la ubicación normal de un jetstream con relación a las bajas en superficie y los frentes?',
    'explicacion': r'El jetstream suele ubicarse al norte de los sistemas frontales de superficie en el esquema sinóptico usado por el banco. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- El jetstream se ubica al Norte de los sistemas de superficie.','puntos': 1},
     {'texto': 'B.- El jetstream se ubica al Sur de la baja y frente caliente.','puntos': 0},
     {'texto': 'C.- El jetstream se ubica sobre la baja y cruza a ambos: al frente caliente y al frente frío.','puntos': 0},
     ]         
  },

{
    'texto': '16.- ¿Qué término se utiliza cuando la temperatura del aire cambia por compresión o expansión, sin que se haya agregado o quitado calor?',
    'explicacion': r'Un proceso adiabático cambia la temperatura por expansión o compresión sin intercambio de calor con el entorno. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OMM-No. 49.',
    
    'respuestas': [
     {'texto': 'A.- Katabático.','puntos': 0},
     {'texto': 'B.- Advección.','puntos': 0},
     {'texto': 'C.- Adiabático.','puntos': 1},
     ]         
  },

{
    'texto': '17.- ¿Qué proceso causa el enfriamiento adiabático?',
    'explicacion': r'El aire que asciende se expande por menor presión y se enfría adiabáticamente. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Expansión del aire a medida que éste sube.','puntos': 1},
     {'texto': 'B.- Movimiento del aire sobre una superficie más fría.','puntos': 0},
     {'texto': 'C.- La liberación de calor latente durante el proceso de vaporización.','puntos': 0},
     ]         
  },

{
    'texto': '18.- La razón aproximada de enfriamiento del aire no saturado que asciende una pendiente es:',
    'explicacion': r'El aire no saturado asciendente se enfría aproximadamente a la razón adiabática seca, cercana a 3 °C por cada 1.000 ft. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- 3° C por cada 1000 pies.','puntos': 1},
     {'texto': 'B.- 2° C por cada 1000 pies.','puntos': 0},
     {'texto': 'C.- 4° C por cada 1000 pies.','puntos': 0},
     ]         
  },

{
    'texto': '19.- ¿Qué sucede cuando el vapor de agua cambia a estado líquido al ser elevado en una tormenta?',
    'explicacion': r'Al condensarse el vapor de agua, se libera calor latente a la atmósfera, reforzando la convección de la tormenta. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- El calor latente es liberado a la atmósfera.','puntos': 1},
     {'texto': 'B.- El calor latente se transforma en pura energía.','puntos': 0},
     {'texto': 'C.- El calor latente es absorbido por las gotitas de agua del aire circundante.','puntos': 0},
     ]         
  },

{
    'texto': '20.- A una inversión de temperatura hay asociada:',
    'explicacion': r'Una inversión térmica genera una capa estable porque el aire frío queda bajo aire más cálido, inhibiendo movimientos verticales. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Una capa de aire estable.','puntos': 1},
     {'texto': 'B.- Una capa de aire inestable.','puntos': 0},
     {'texto': 'C.- Tormentas de masa de aire.','puntos': 0},
     ]         
  },

{
    'texto': '21.- En un período de 24 horas, la temperatura mínima generalmente ocurre:',
    'explicacion': r'La temperatura mínima diaria ocurre poco después del amanecer, cuando cesa el enfriamiento radiativo nocturno y comienza el calentamiento solar efectivo. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Después de la salida del sol.','puntos': 1},
     {'texto': 'B.- Alrededor de una hora antes de la salida del sol.','puntos': 0},
     {'texto': 'C.- A medianoche.','puntos': 0},
     ]         
  },

{
    'texto': '22.- Las capas de bruma son dispersadas o disipadas por:',
    'explicacion': r'La bruma se dispersa por viento o mezcla de aire, que diluye partículas y humedad cerca de la superficie. Fuente: OMM-No. 306; FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Mezcla convectiva de aire fresco nocturno.','puntos': 0},
     {'texto': 'B.- El viento o movimiento de aire.','puntos': 1},
     {'texto': 'C.- Evaporación, en un proceso similar al de disipación de la niebla.','puntos': 0},
     ]         
  },

{
    'texto': '23.- ¿Qué puede hacer que una niebla de advección sea disipada o levantada a nubes estratos?',
    'explicacion': r'Viento mayor de 15 kt aumenta la mezcla turbulenta y puede levantar la niebla de advección a estratos. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Una inversión de temperatura.','puntos': 0},
     {'texto': 'B.- Viento mayor de 15 nudos.','puntos': 1},
     {'texto': 'C.- Radiación de superficie.','puntos': 0},
     ]         
  },

{
    'texto': '24.- Las condiciones necesarias para que se forme niebla de pendiente ascendente (upslope fog) son:',
    'explicacion': r'La niebla orográfica o upslope fog requiere aire húmedo y estable forzado a ascender, enfriándose hasta saturación. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Aire estable y húmedo impulsado a ascender una pendiente.','puntos': 1},
     {'texto': 'B.- Cielo despejado, poco viento o calma, humedad relativa de 100 %.','puntos': 0},
     {'texto': 'C.- Lluvia precipitando a través de estratos con vientos de 10 a 25 nudos que impulsen la precipitación hacia arriba por la pendiente.','puntos': 0},
     ]         
  },

{
    'texto': '25.- ¿Qué espesor mínimo es de esperar de una capa nubosa cuando la precipitación reportada es ligera, o de mayor intensidad?',
    'explicacion': r'La precipitación ligera o mayor suele requerir una capa nubosa suficientemente profunda; el criterio operativo del banco usa 4.000 ft. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- 4.000 pies de espesor.','puntos': 1},
     {'texto': 'B.- 2.000 pies de espesor.','puntos': 0},
     {'texto': 'C.- Un espesor tal que permita que el tope de las nubes se encuentre más arriba que el nivel de congelamiento.','puntos': 0},
     ]         
  },

{
    'texto': '26.- ¿Qué fenómeno de tiempo señala el comienzo de la etapa de madurez de una tormenta?',
    'explicacion': r'La etapa madura de una tormenta comienza cuando la precipitación alcanza la superficie y coexisten ascendentes y descendentes. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- La aparición del yunque.','puntos': 0},
     {'texto': 'B.- El comienzo de precipitación en superficie.','puntos': 1},
     {'texto': 'C.- Cuando la razón de crecimiento de la nube está en su máximo.','puntos': 0},
     ]         
  },

{
    'texto': '27.- ¿Qué etapa del ciclo de vida de una tormenta se caracteriza predominantemente por las corrientes descendentes?',
    'explicacion': r'La etapa de disipación se caracteriza por predominio de corrientes descendentes y pérdida de alimentación cálida y húmeda. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- La etapa de cúmulo.','puntos': 0},
     {'texto': 'B.- La etapa de disipación.','puntos': 1},
     {'texto': 'C.- La etapa de madurez.','puntos': 0},
     ]         
  },

{
    'texto': '28.- ¿Qué característica está asociada con la etapa de cúmulo de una tormenta?',
    'explicacion': r'La etapa de cúmulo presenta corrientes ascendentes continuas, responsables del crecimiento vertical inicial de la nube. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Comienzo de lluvia en la superficie.','puntos': 0},
     {'texto': 'B.- Frecuentes relámpagos.','puntos': 0},
     {'texto': 'C.- Continuas corrientes ascendentes.','puntos': 1},
     ]         
  },

{
    'texto': '29.- Las líneas de turbonada (squall lines) se producen con más frecuencia en:',
    'explicacion': r'Las líneas de turbonada se forman con frecuencia delante de frentes fríos, donde el aire cálido e inestable asciende con rapidez. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Un frente ocluido.','puntos': 0},
     {'texto': 'B.- Delante de un frente frío.','puntos': 1},
     {'texto': 'C.- Detrás de un frente estacionario.','puntos': 0},
     ]         
  },

{
    'texto': '30.- El tipo de nube asociada con tornados y turbulencia violenta es:',
    'explicacion': r'El cumulonimbus mammatus se asocia a tormentas severas, turbulencia intensa y fenómenos convectivos peligrosos. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Cúmulonimbus mammatus (mamma).','puntos': 1},
     {'texto': 'B.- Lenticulares estacionarias.','puntos': 0},
     {'texto': 'C.- Estrato-cúmulos.','puntos': 0},
     ]         
  },

{
    'texto': '31.- ¿Qué condición de tiempo es un ejemplo de una banda de inestabilidad no frontal?',
    'explicacion': r'Una línea de turbonada puede ser una banda organizada de inestabilidad no frontal, con tormentas y chubascos intensos. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Línea de turbonada.','puntos': 1},
     {'texto': 'B.- Niebla advectiva.','puntos': 0},
     {'texto': 'C.- Frontogénesis.','puntos': 0},
     ]         
  },

{
    'texto': '32.- Una tormenta severa es aquella en la cual el viento en superficie es:',
    'explicacion': r'Una tormenta severa se define operativamente por vientos superficiales intensos y/o granizo significativo; el banco usa 50 kt o más y granizo ≥ 3/4 pulg. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; NOAA/NWS Severe Thunderstorm Criteria.',
    
    'respuestas': [
     {'texto': 'A.- 50 nudos o más y / o el granizo en superficie es igual o mayor a ¾ de pulgada de diámetro.','puntos': 1},
     {'texto': 'B.- 55 nudos o más y / o el granizo en superficie es igual o mayor a ½ pulgada de diámetro.','puntos': 0},
     {'texto': 'C.- 45 nudos o más y / o el granizo en superficie es igual o mayor a 1 pulgada de diámetro.','puntos': 0},
     ]         
  },
  {
    'texto': '33.- ¿Qué riesgo al vuelo instrumental constituye las nubes convectivas que penetran una capa de nubes estratiformes?',
    'explicacion': r'Las tormentas embebidas quedan ocultas dentro de nubosidad estratiforme, aumentando el riesgo IFR de ingreso inadvertido a CB. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Lluvia congelante.','puntos': 0},
     {'texto': 'B.- Turbulencia de aire claro.','puntos': 0},
     {'texto': 'C.- Nubes de tormenta (thunderstorms) ocultas por los stratus que la rodean.','puntos': 1},
     ]         
  },

{
    'texto': '34.- Durante una aproximación ILS ¿cuáles son las indicaciones “iniciales” que un piloto va a notar cuando un viento de nariz cambia rápidamente a calma?',
    'explicacion': r'Al perderse rápidamente viento de nariz, disminuyen velocidad indicada y sustentación; el avión tiende a bajar nariz y perder altura. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; FAA AC 00-54.',
    
    'respuestas': [
     {'texto': 'A.- La velocidad indicada disminuye, el avión levanta la nariz y la altura disminuye.','puntos': 0},
     {'texto': 'B.- La velocidad indicada aumenta, el avión baja la nariz y la altura se incrementa.','puntos': 0},
     {'texto': 'C.- La velocidad indicada disminuye, el avión baja la nariz y la altura disminuye.','puntos': 1},
     ]         
  },

{
    'texto': '35.- ¿Qué condición de windshear produce una mayor disminución de velocidad?',
    'explicacion': r'La mayor pérdida de velocidad ocurre al disminuir el viento de nariz y aumentar el viento de cola, reduciendo bruscamente el flujo relativo. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; FAA AC 00-54.',
    
    'respuestas': [
     {'texto': 'A.- Viento de nariz o de cola disminuyendo.','puntos': 0},
     {'texto': 'B.- Viento de nariz disminuyendo y viento de cola en aumento.','puntos': 1},
     {'texto': 'C.- Aumento en viento de nariz y disminución en viento de cola.','puntos': 0},
     ]         
  },

{
    'texto': '36.- La zona de mayor peligro causada por el windshear asociado a una tormenta, se encuentra:',
    'explicacion': r'El windshear convectivo puede rodear toda la célula y ser máximo bajo ella por descendentes, outflow y microbursts. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; FAA AC 00-54.',
    
    'respuestas': [
     {'texto': 'A.- Delante de la célula de la tormenta (lado del yunque) y en el lado sur oeste de la célula.','puntos': 0},
     {'texto': 'B.- Delante de la nube rotor y directamente bajo el yunque de la nube.','puntos': 0},
     {'texto': 'C.- En todos lados y directamente bajo la célula de la tormenta.','puntos': 1},
     ]         
  },

{
    'texto': '37.- La duración esperada de un microburst individual es:',
    'explicacion': r'Un microburst es breve e intenso; rara vez dura más de 15 minutos desde el impacto en superficie hasta su disipación. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; FAA AC 00-54.',
    
    'respuestas': [
     {'texto': 'A.- Cinco minutos, con duración de los vientos máximos de 2 a 4 minutos.','puntos': 0},
     {'texto': 'B.- Un microburst puede continuar tanto como una hora.','puntos': 0},
     {'texto': 'C.- Rara vez más de 15 minutos desde el momento que impacta el suelo hasta su disipación.','puntos': 1},
     ]         
  },

{
    'texto': '38.- Una aeronave que ingrese a un área afectada por un microburst puede encontrar descendentes de una magnitud de:',
    'explicacion': r'Los microbursts severos pueden generar descendentes cercanas a 6.000 ft/min, superando la capacidad de ascenso de muchas aeronaves. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; FAA AC 00-54.',
    
    'respuestas': [
     {'texto': 'A.- 1.500 ft/min.','puntos': 0},
     {'texto': 'B.- 4.500 ft/min.','puntos': 0},
     {'texto': 'C.- 6.000 ft/min.','puntos': 1},
     ]         
  },

{
    'texto': '39.- Durante el encuentro con un microburst, las descendentes podrían ser tan fuertes como:',
    'explicacion': r'Las descendentes de un microburst severo pueden alcanzar alrededor de 6.000 ft/min, provocando pérdida rápida de altura. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; FAA AC 00-54.',
    
    'respuestas': [
     {'texto': 'A.- 8.000 ft/min.','puntos': 0},
     {'texto': 'B.- 7.000 ft/min.','puntos': 0},
     {'texto': 'C.- 6.000 ft-min.','puntos': 1},
     ]         
  },

{
    'texto': '40.- Una aeronave que encuentra vientos de nariz de 45 nudos, dentro del microburst puede esperar una cortante total del orden de:',
    'explicacion': r'Un cambio de 45 kt de viento de nariz a un componente equivalente de cola puede producir una cortante total cercana a 90 kt. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; FAA AC 00-54.',
    
    'respuestas': [
     {'texto': 'A.- 40 nudos.','puntos': 0},
     {'texto': 'B.- 80 nudos.','puntos': 0},
     {'texto': 'C.- 90 nudos.','puntos': 1},
     ]         
  },

{
    'texto': '41.- ¿Cuál es la duración esperada de un microburst individual?',
    'explicacion': r'El ciclo de un microburst individual rara vez excede 15 minutos, aunque su fase máxima puede ser muy intensa. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; FAA AC 00-54.',
    
    'respuestas': [
     {'texto': 'A.- 2 minutos, con viento máximo que dura aproximadamente 1 minuto.','puntos': 0},
     {'texto': 'B.- Un microburst puede durar tanto como 2 a 4 horas.','puntos': 0},
     {'texto': 'C.- Rara vez más de 15 minutos desde el momento que impacta el suelo hasta su disipación.','puntos': 1},
     ]         
  },

{
    'texto': '42.- ¿Qué información se puede deducir de la siguiente transmisión desde la torre de control? UMBRAL SUR VIENTO 160° CON 25 NUDOS, UMBRAL OESTE VIENTO 240° CON 35 NUDOS.',
    'explicacion': r'Diferencias importantes de dirección e intensidad del viento entre umbrales indican posible cortante de viento cerca del aeródromo. Fuente: OACI Anexo 3; FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Una corriente descendente está localizada al centro del aeropuerto.','puntos': 0},
     {'texto': 'B.- Al oeste de la pista activa existe wake turbulence.','puntos': 0},
     {'texto': 'C.- Existe posibilidad de encontrar windshear (cortante de viento) sobre o cerca del aeropuerto.','puntos': 1},
     ]         
  },

{
    'texto': '43.- ¿Cuál es el efecto de la formación de hielo, nieve o escarcha sobre una aeronave?',
    'explicacion': r'La contaminación por hielo, nieve o escarcha degrada el perfil alar y reduce el ángulo crítico de pérdida. Fuente: FAA AC 120-58; FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Disminución de la velocidad de stall.','puntos': 0},
     {'texto': 'B.- Disminución de la tendencia a levantar la nariz (pitchup).','puntos': 0},
     {'texto': 'C.- Disminución del ángulo de ataque de stalls (pérdida).','puntos': 1},
     ]         
  },

{
    'texto': '44.- ¿Cuál es el efecto de la formación de hielo, nieve o escarcha sobre una aeronave?',
    'explicacion': r'El hielo, nieve o escarcha aumentan la resistencia y reducen la sustentación, elevando la velocidad de stall. Fuente: FAA AC 120-58; FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Aumento de la velocidad de Stall.','puntos': 1},
     {'texto': 'B.- Aumento de la tendencia a bajar la nariz.','puntos': 0},
     {'texto': 'C.- Aumento del ángulo de ataque para stalls.','puntos': 0},
     ]         
  },

{
    'texto': '45.- La nieve acumulada en el avión sobre el fluido antihielo...',
    'explicacion': r'La nieve sobre fluido antihielo debe considerarse contaminación adherida; las superficies críticas deben estar limpias antes del despegue. Fuente: FAA AC 120-58; OACI Doc 9640.',
    
    'respuestas': [
     {'texto': 'A.- no debe considerarse como adherida al avión.','puntos': 0},
     {'texto': 'B.- debe considerarse como adherida al avión.','puntos': 1},
     {'texto': 'C.- debe considerarse como adherida al avión, pero se puede realizar un despegue seguro pues ésta se desprenderá durante la carrera, antes de VR.','puntos': 0},
     ]         
  },

{
    'texto': '46.- ¿Qué característica tiene el agua sobre enfriada?',
    'explicacion': r'El agua sobreenfriada permanece líquida bajo 0 °C y se congela al impactar superficies expuestas. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Al impactar el ala, las gotas se subliman convirtiéndose en partículas de hielo.','puntos': 0},
     {'texto': 'B.- Las inestables gotas se congelan al chocar con un objeto expuesto.','puntos': 1},
     {'texto': 'C.- La temperatura de la gota permanece en 0° C hasta que impacta parte del fuselaje, para luego acumularse como hielo claro.','puntos': 0},
     ]         
  },

{
    'texto': '47.- ¿Qué condición es necesaria, entre otras, para la formación de hielo estructural en vuelo?',
    'explicacion': r'Para hielo estructural se requiere humedad visible y temperaturas favorables, permitiendo que gotas impacten y congelen en la aeronave. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Gotas de agua sobre enfriadas.','puntos': 0},
     {'texto': 'B.- Vapor de agua.','puntos': 0},
     {'texto': 'C.- Agua (humedad) visible.','puntos': 1},
     ]         
  },

{
    'texto': '48.- ¿Qué tipo de hielo está asociado con las gotas de agua más chicas, como aquellas encontradas en nubes estratos de niveles bajos?',
    'explicacion': r'El rime ice se forma por pequeñas gotas sobreenfriadas que congelan rápido, comúnmente en nubes estratiformes bajas. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Hielo claro.','puntos': 0},
     {'texto': 'B.- Escarcha (frost ice).','puntos': 0},
     {'texto': 'C.- Hielo granulado (rime ice).','puntos': 1},
     ]         
  },

{
    'texto': '49.- ¿Qué tipo de precipitación es indicativo de la presencia de gotas de agua sobre enfriadas?',
    'explicacion': r'La lluvia congelante indica gotas de agua sobreenfriada que congelan al contacto, condición crítica de engelamiento. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Nieve húmeda.','puntos': 0},
     {'texto': 'B.- Lluvia congelante.','puntos': 1},
     {'texto': 'C.- Granizos (ice pellets).','puntos': 0},
     ]         
  },

{
    'texto': '50.- ¿Qué condición existe cuando durante el vuelo se encuentra granizos (ice pellets)?',
    'explicacion': r'Los ice pellets suelen indicar lluvia congelante en niveles superiores y una estructura térmica con capas cálidas y frías. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Tormentas (thunderstorms) en niveles superiores.','puntos': 0},
     {'texto': 'B.- Lluvia congelante en niveles superiores.','puntos': 1},
     {'texto': 'C.- Nieve en niveles superiores.','puntos': 0},
     ]         
  },

{
    'texto': '51.- ¿Qué condición de temperatura debería existir si durante el vuelo se observa precipitación tipo agua nieve?',
    'explicacion': r'El agua nieve implica fusión parcial de nieve, por lo que la temperatura en el nivel de vuelo está sobre 0 °C. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- La temperatura en el nivel de vuelo es mayor que la de congelación.','puntos': 1},
     {'texto': 'B.- La temperatura en niveles superiores es mayor que la de congelación.','puntos': 0},
     {'texto': 'C.- Hay una inversión de temperatura con aire más frío por debajo.','puntos': 0},
     ]         
  },

{
    'texto': '52.- ¿Cuándo es más probable que se forme escarcha en la superficie de un avión?',
    'explicacion': r'La escarcha se forma típicamente en noches despejadas, aire estable y viento ligero por enfriamiento radiativo de la superficie. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; FAA AC 120-58.',
    
    'respuestas': [
     {'texto': 'A.- En noches despejadas con aire estable y viento ligero.','puntos': 1},
     {'texto': 'B.- En noches con cielo cubierto con precipitación tipo llovizna congelante.','puntos': 0},
     {'texto': 'C.- En noches despejadas con actividad convectiva y poca dispersión entre la temperatura ambiente y la temperatura del punto de rocío.','puntos': 0},
     ]         
  },

{
    'texto': '53.- ¿Cómo debería reportarse una turbulencia que ocasiona eventuales sacudidas suaves, rápidas y algo rítmicas sin apreciables cambios en la altitud y / o actitud del avión?',
    'explicacion': r'Sacudidas suaves, rápidas y rítmicas sin cambios apreciables de actitud o altitud corresponden a turbulencia ligera ocasional. Fuente: AIM FAA, Pilot/Controller Glossary; FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Ligera ocasional.','puntos': 1},
     {'texto': 'B.- Turbulencia moderada.','puntos': 0},
     {'texto': 'C.- Movimientos moderados.','puntos': 0},
     ]         
  },

{
    'texto': '54.- ¿Cómo debería reportarse la turbulencia cuando ocasiona cambios ligeros, erráticos y momentáneos de altitud y / o actitud, con una frecuencia de un tercio a dos tercios del tiempo?',
    'explicacion': r'Cambios ligeros, erráticos y momentáneos durante un tercio a dos tercios del tiempo corresponden a turbulencia ligera intermitente. Fuente: AIM FAA, Pilot/Controller Glossary.',
    
    'respuestas': [
     {'texto': 'A.- Movimientos ocasionales ligeros.','puntos': 0},
     {'texto': 'B.- Turbulencia moderada.','puntos': 0},
     {'texto': 'C.- Turbulencia ligera intermitente.','puntos': 1},
     ]         
  },

{
    'texto': '55.- La turbulencia encontrada sobre 15.000 pies AGL, no asociada con formaciones nubosas, se reportará como:',
    'explicacion': r'La turbulencia sobre 15.000 ft AGL, sin nubosidad asociada, se reporta como turbulencia de aire claro (CAT). Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Turbulencia convectiva.','puntos': 0},
     {'texto': 'B.- Turbulencia de niveles altos.','puntos': 0},
     {'texto': 'C.- Turbulencia de aire claro.','puntos': 1},
     ]         
  },

{
    'texto': '56.- Señale qué tipo de nubes son más indicativas de turbulencia fuerte?',
    'explicacion': r'Las nubes lenticulares estacionarias indican ondas de montaña y son señal operacional de posible turbulencia fuerte. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Nimbo estrato.','puntos': 0},
     {'texto': 'B.- Lenticulares estacionarias.','puntos': 1},
     {'texto': 'C.- Cirrocúmulo.','puntos': 0},
     ]         
  },

{
    'texto': '57.- ¿Cuál es la nube más baja del tipo estacionaria asociada con la onda de montaña?',
    'explicacion': r'La nube rotor es la nube estacionaria más baja asociada a onda de montaña y señala turbulencia intensa a sotavento. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- La nube rotor.','puntos': 1},
     {'texto': 'B.- la nube lenticular estacionaria.','puntos': 0},
     {'texto': 'C.- Los estratos bajos.','puntos': 0},
     ]         
  },

{
    'texto': '58.- La turbulencia en aire claro (CAT) asociada con la onda de montaña puede extenderse tan lejos como:',
    'explicacion': r'La opción B corresponde al criterio del banco para extensión vertical sobre la tropopausa; en el PDF figura 5000 ft. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- 1000 millas o más a sotavento de la montaña.','puntos': 0},
     {'texto': 'B.- 500 pies sobre la tropopausa.','puntos': 1},
     {'texto': 'C.- 100 millas o más a barlovento de la montaña.','puntos': 0},
     ]         
  },

{
    'texto': '59.- ¿Qué tipo de corriente de chorro (jetstream) puede causar mayor turbulencia?',
    'explicacion': r'Un jet curvo asociado a una vaguada profunda genera mayor cizalle horizontal y vertical, aumentando la turbulencia. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Un jetstream recto asociado con una cuña de alta presión.','puntos': 0},
     {'texto': 'B.- Un jetstream asociado con isotermas muy espaciadas.','puntos': 0},
     {'texto': 'C.- Un jetstream en curva asociado con una vaguada (trough) profunda de baja presión.','puntos': 1},
     ]         
  },

{
    'texto': '60.- ¿Qué acción se recomienda al encontrar turbulencia asociada al jetstream con viento directo de nariz o de cola?',
    'explicacion': r'Con viento de nariz o cola en el jet, la zona turbulenta puede ser extensa; se recomienda cambiar altitud o curso. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Aumentar la velocidad para salir lo antes posible del área.','puntos': 0},
     {'texto': 'B.- Cambiar curso para volar en el lado polar del jetstream.','puntos': 0},
     {'texto': 'C.- Cambiar de altitud o curso para evitar una posible extensa área de turbulencia.','puntos': 1},
     ]         
  },

{
    'texto': '61.- ¿Qué riesgo a las operaciones aéreas existe cuando una capa nubosa de espesor uniforme yace sobre una superficie cubierta de nieve o hielo?',
    'explicacion': r'Una capa nubosa uniforme sobre nieve o hielo puede producir whiteout, perdiéndose contraste visual de horizonte y terreno. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Niebla helada.','puntos': 0},
     {'texto': 'B.- Visión blanca.','puntos': 1},
     {'texto': 'C.- Viento de nieve.','puntos': 0},
     ]         
  },

{
    'texto': '62.- La sigla “VC” se utiliza para indicar un fenómeno que ocurre en las vecindades del aeropuerto pero no en éste. Cuando VC aparece en un TAF, cubre un área geográfica de:',
    'explicacion': r'VC indica fenómeno en las vecindades del aeródromo, operacionalmente entre 5 y 10 millas. Fuente: OACI Anexo 3; FMH-1 METAR/TAF.',
    
    'respuestas': [
     {'texto': 'A.- Un radio de 5 a 10 millas alrededor del aeropuerto.','puntos': 1},
     {'texto': 'B.- En un radio de 5 millas del centro del complejo de pistas.','puntos': 0},
     {'texto': 'C.- 10 millas medidas desde la estación que genera el pronóstico.','puntos': 0},
     ]         
  },

{
    'texto': '63.- ¿Qué condición meteorológica se predice con el término “VCTS” en un TAF?',
    'explicacion': r'VCTS significa tormentas en las vecindades: entre 5 y 10 millas del aeropuerto, no necesariamente sobre él. Fuente: OACI Anexo 3; FMH-1 METAR/TAF.',
    
    'respuestas': [
     {'texto': 'A.- Se esperan tormentas en un radio fluctuando entre 5 y 10 millas del aeropuerto, pero no en el aeropuerto mismo.','puntos': 1},
     {'texto': 'B.- Pueden esperarse chubascos sobre la estación y en un radio de 50 millas.','puntos': 0},
     {'texto': 'C.- Se esperan tormentas entre 5 y 25 millas medidas desde el centro del conjunto de pistas.','puntos': 0},
     ]         
  },

{
    'texto': '64.- ¿Cuál es el único tipo de nubosidad pronosticado en un TAF?',
    'explicacion': r'En TAF se pronostica el tipo cumulonimbus por su impacto operacional en tormentas, turbulencia, engelamiento y windshear. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Altocumulus.','puntos': 0},
     {'texto': 'B.- Cumulonimbus.','puntos': 1},
     {'texto': 'C.- Estratocumulus.','puntos': 0},
     ]         
  },

{
    'texto': '65.- En el TAF, el viento se pronostica como “calma” si se espera una velocidad de viento de:',
    'explicacion': r'En TAF, viento calma corresponde a velocidad de 3 kt o menos. Fuente: OACI Anexo 3; FMH-1 METAR/TAF.',
    
    'respuestas': [
     {'texto': 'A.- 6 nudos o menos.','puntos': 0},
     {'texto': 'B.- 3 nudos o menos.','puntos': 1},
     {'texto': 'C.- 5 nudos o menos.','puntos': 0},
     ]         
  },

{
    'texto': '66.- En un TAF, el viento de dirección variable se anota como VRB. Un viento calma (3 nudos o menor) aparecerá en TAF como...',
    'explicacion': r'El viento calma se codifica 00000KT, indicando dirección no significativa y velocidad nula o calma. Fuente: OACI Anexo 3; FMH-1 METAR/TAF.',
    
    'respuestas': [
     {'texto': 'A.- 00003KT.','puntos': 0},
     {'texto': 'B.- CALM.','puntos': 0},
     {'texto': 'C.- 00000KT.','puntos': 1},
     ]         
  },

{
    'texto': '67.- En una carta de superficie las isobaras representan líneas de igual presión:',
    'explicacion': r'Las isobaras de cartas de superficie unen puntos de igual presión reducida al nivel medio del mar. Fuente: OMM-No. 8; FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- En la superficie.','puntos': 0},
     {'texto': 'B.- Reducidas al nivel de mar.','puntos': 1},
     {'texto': 'C.- A una altitud de presión determinada.','puntos': 0},
     ]         
  },

   {
    'texto': '68.- ¿Bajo qué circunstancias es más factible encontrar turbulencia de aire claro (CAT)?',
    'explicacion': r'Isotacas de 60 kt separadas por menos de 20 NM indican fuerte cizalle, condición favorable para CAT. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Cuando en las cartas de presión constante hay isotacas de 20 nudos separadas por menos de 60 millas náuticas.','puntos': 0},
     {'texto': 'B.- Cuando en las cartas de presión constante hay isotacas de 60 nudos separadas por menos de 20 millas náuticas.','puntos': 1},
     {'texto': 'C.- Cuando una vaguada profunda se desplaza a una velocidad menor de 20 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '69.- Se puede esperar corriente de cizalle (wind shear) “fuerte”:',
    'explicacion': r'El windshear fuerte es más probable en el lado de baja presión de un jetstream intenso, especialmente sobre 110 kt. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- En el lado de baja presión del núcleo de un jet stream de más de 110 nudos.','puntos': 1},
     {'texto': 'B.- Donde las isotacas de 20 nudos están espaciadas en 100 millas náuticas o menos.','puntos': 0},
     {'texto': 'C.- Si las isotermas de 5° C están espaciadas en 100 millas náuticas o menos.','puntos': 0},
     ]         
  },

{
    'texto': '70.- Un Reporte Aeronáutico de Superficie se abrevia como:',
    'explicacion': r'METAR es el reporte meteorológico aeronáutico ordinario de superficie, basado en observaciones del aeródromo. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- TAF.','puntos': 0},
     {'texto': 'B.- METAR.','puntos': 1},
     {'texto': 'C.- SIGMET.','puntos': 0},
     ]         
  },

{
    'texto': '71.- Un Pronóstico de Terminal se abrevia como...',
    'explicacion': r'TAF es el Terminal Aerodrome Forecast, pronóstico meteorológico de aeródromo para un período definido. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- TAF.','puntos': 1},
     {'texto': 'B.- METAR.','puntos': 0},
     {'texto': 'C.- AIREP.','puntos': 0},
     ]         
  },

{
    'texto': '72.- Las Advertencias Meteorológicas en Vuelo, observadas o pronosticadas, y que informan sobre condiciones potencialmente peligrosas que pueden afectar la seguridad de las operaciones aéreas, se conocen como...',
    'explicacion': r'SIGMET informa fenómenos meteorológicos significativos observados o previstos que pueden afectar la seguridad operacional en vuelo. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- AIREP','puntos': 0},
     {'texto': 'B.- RAREP','puntos': 0},
     {'texto': 'C.- SIGMET','puntos': 1},
     ]         
  },

{
    'texto': '73.- En el Pronóstico de Área Ud. lee: ROUTE FCST SCTC SCMO VALID 1206. Ello significa ....',
    'explicacion': r'VALID 1206 indica validez desde las 12 UTC hasta las 06 UTC del día siguiente en el formato del pronóstico de área. Fuente: DGAC Chile, Manual/Guía de Meteorología Aeronáutica; OACI Anexo 3.',
    
    'respuestas': [
     {'texto': 'A.- Que se trata de un TAF válido hasta las 12:06 para el tramo indicado.','puntos': 0},
     {'texto': 'B.- Que se trata de un pronóstico válido de 12:00 a 06:00 del siguiente día.','puntos': 1},
     {'texto': 'C.- Que se trata de un pronóstico válido de 12:00 a 18:00 del mismo día.','puntos': 0},
     ]         
  },

{
    'texto': '74.- En el Pronóstico de Área Ud. lee: APG RUTA AFECTADA POR SISTEMA FRONTAL OCLUIDO. De la abreviatura “APG” Ud. deduce que se trata de:',
    'explicacion': r'APG identifica una advertencia o información significativa para una ruta específica, equivalente al SIGMET de ruta indicado por el banco. Fuente: DGAC Chile, Meteorología Aeronáutica; OACI Anexo 3.',
    
    'respuestas': [
     {'texto': 'A.- Un informe meteorológico emitido por un piloto en vuelo.','puntos': 0},
     {'texto': 'B.- Un SIGMET para una ruta en particular.','puntos': 1},
     {'texto': 'C.- Una sinopsis en que se informa sólo lo más relevante.','puntos': 0},
     ]         
  },

{
    'texto': '75.- En el Pronóstico de Área Ud. lee: COT INT 6SC200 MTS TOP 700 MTS GRADU 1819 COT INT 8 CU1300 TOP 2300 MTS. De esta parte del informe meteorológico Ud. deduce que:',
    'explicacion': r'COT e INT separan costa e interior; GRADU 1819 indica cambio gradual entre 18 y 19 UTC. Fuente: DGAC Chile, clave de pronósticos de área; OACI Anexo 3.',
    
    'respuestas': [
     {'texto': 'A.- Esta información, que puede ser continua o intermitente, se retransmitirá a las 18:00 y 19:00 horas.','puntos': 0},
     {'texto': 'B.- Esta información afecta tanto a la costa como al interior del territorio y habrá un cambio gradual de las condiciones meteorológicas entre las 18 y 19 UTC.','puntos': 1},
     {'texto': 'C.- Esta información afecta tanto a la costa como al interior del territorio y habrá un cambio gradual de las condiciones meteorológicas a las 18:19 UTC.','puntos': 0},
     ]         
  },

{
    'texto': '76.- En el Pronóstico de Área Ud. lee: 6AC3700 MTS TOP 6500 MTS 80 RASH ICE BTN 6/8 MILFT TUR MOD BTN 30/35 MILFT. De la lectura de este informe Ud., entre otras cosas, puede deducir que:',
    'explicacion': r'6AC3700 TOP6500 indica altocúmulos; RASH son chubascos de lluvia e ICE BTN 6/8 MILFT indica hielo entre 6.000 y 8.000 ft. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Habrá nubosidad del tipo alto cúmulos, chubascos de lluvia, y entre 6.000 y 8.000 pies se encontrará formación de hielo.','puntos': 1},
     {'texto': 'B.- Habrá nubosidad del tipo alto cúmulos y entre 6.000 y 8.000 pies se encontrará formación intermitente de hielo.','puntos': 0},
     {'texto': 'C.- Habrá nubosidad del tipo altos cirros, chubascos de lluvia, y que entre 6.000 y 8.000 pies se encontrará formación de hielo.','puntos': 0},
     ]         
  },

{
    'texto': '77.- En el Pronóstico de Vientos y Temperaturas en Altura (QAO QMX) Ud. lee: SCMO SCCI 05/32020/00 10/27030/59 15/29035/65 20/34035/70 25/31040/75 30/24050/90 35/30085/96 40/300100/01 ISOTERMA CERO 7000FT. De este informe se puede deducir que:',
    'explicacion': r'El grupo 10/27030/59 indica FL100, viento desde 270° a 30 kt y temperatura codificada de -9 °C. Fuente: DGAC Chile, clave QAO/QMX; OACI Anexo 3.',
    
    'respuestas': [
     {'texto': 'A.- A 10.000 pies el viento es de los 270 grados con una intensidad de 30 nudos y que la temperatura es de menos 9° C.','puntos': 1},
     {'texto': 'B.- A 10.000 pies el viento es de los 270 grados con una intensidad de 30 nudos con ráfagas de hasta 59 nudos aproximadamente.','puntos': 0},
     {'texto': 'C.- A 10.000 pies el viento es de los 270 grados con una intensidad de 30 nudos y que la temperatura exterior es de aproximadamente 59° F.','puntos': 0},
     ]         
  },

{
    'texto': '78.- En el Pronóstico de Vientos y Temperaturas en Altura (QAO QMX) Ud. lee: SCMO SCCI 05/32020/00 10/27030/59 15/29035/65 20/34035/70 25/31040/75 30/24050/90 35/30085/96 40/300100/01 ISOTERMA CERO 7000FT. De este informe se puede deducir que:',
    'explicacion': r'El grupo 15/29035/65 indica 15.000 ft, viento desde 290° a 35 kt y temperatura exterior aproximada de -15 °C. Fuente: DGAC Chile, clave QAO/QMX; OACI Anexo 3.',
    
    'respuestas': [
     {'texto': 'A.- A 15.000 pies el viento es de los 290 grados con una intensidad de 35 nudos, con ráfagas de hasta 65 nudos.','puntos': 0},
     {'texto': 'B.- A 15.000 pies el viento es de los 290 grados con una intensidad de 35 nudos y que la temperatura exterior es de menos 15° C.','puntos': 1},
     {'texto': 'C.- A 15.000 pies el viento es de los 290 grados con una intensidad de 30 nudos y que la temperatura exterior es de 65° F.','puntos': 0},
     ]         
  },

{
    'texto': '79.- En el Pronóstico de Vientos y Temperaturas en Altura (QAO QMX) Ud. lee: SCMO SCCI 05/32020/00 10/27030/59 15/29035/65 20/34035/70 25/31040/75 30/24050/90 35/30085/96 40/300100/01 ISOTERMA CERO 7000FT. De este informe se puede deducir que:',
    'explicacion': r'El grupo 25/31040/75 indica 25.000 ft, viento desde 310° a 40 kt y temperatura exterior aproximada de -25 °C. Fuente: DGAC Chile, clave QAO/QMX; OACI Anexo 3.',
    
    'respuestas': [
     {'texto': 'A.- A 25.000 pies el viento es desde los 310 grados con una intensidad de 40 nudos y que la temperatura exterior es de menos 25° C.','puntos': 1},
     {'texto': 'B.- A 25.000 pies el viento es de los 310 grados con una intensidad de 40 nudos con ráfagas de hasta 75 nudos.','puntos': 0},
     {'texto': 'C.- A 25.000 pies la dirección del viento sopla hacia los 310 grados con una intensidad de 40 nudos y que la temperatura exterior es de menos 25° C.','puntos': 0},
     ]         
  },

{
    'texto': '80.- En el Pronóstico de Vientos y Temperaturas en Altura (QAO QMX) Ud. lee: SCMO SCCI 05/32020/00 10/27030/59 15/29035/65 20/34035/70 25/31040/75 30/24050/90 35/30085/96 40/300100/01 ISOTERMA CERO 7000FT. De este informe se puede deducir que:',
    'explicacion': r'El grupo 40/300100/01 indica 40.000 ft, viento desde 300° a 100 kt y temperatura exterior aproximada de -51 °C. Fuente: DGAC Chile, clave QAO/QMX; OACI Anexo 3.',
    
    'respuestas': [
     {'texto': 'A.- A 40.000 pies el viento es desde los 300 grados con una intensidad de 100 nudos y que la temperatura exterior es de menos 51°C.','puntos': 1},
     {'texto': 'B.- A 40.000 pies el viento es desde los 300 grados con una intensidad de 100 nudos y que existe una inversión térmica.','puntos': 0},
     {'texto': 'C.- A 40.000 pies la dirección del viento es hacia los 300 grados con una intensidad de 100 nudos y que la temperatura exterior es de menos 51° C.','puntos': 0},
     ]         
  },

{
    'texto': '81.- En el Pronóstico de Terminal que Ud. debe analizar antes de iniciar un vuelo, Ud. lee lo siguiente: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'En TAF, 9999 significa visibilidad de 10 km o más; por eso SCSE tiene visibilidad superior a 10 km. Fuente: OACI Anexo 3; FMH-1 METAR/TAF.',
    
    'respuestas': [
     {'texto': 'A.- En La Serena (SCSE) el techo de nubes y la visibilidad son ilimitados.','puntos': 0},
     {'texto': 'B.- En La Serena (SCSE) hay una visibilidad superior a 10 kilómetros.','puntos': 1},
     {'texto': 'C.- En La Serena (SCSE) la visibilidad es de casi 10 kilómetros.','puntos': 0},
     ]         
  },

{
    'texto': '82.- En el Pronóstico de Terminal que Ud. debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'8ST015 indica 8 octas de stratus con base a 1.500 ft, equivalente aproximadamente a 450 m AGL. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- En La Serena (SCSE) la base de la capa de nubes stratus está a aproximadamente 450 metros AGL.','puntos': 1},
     {'texto': 'B.- En La Serena (SCSE) la base de la capa de nubes stratus está a 1.500 metros AGL.','puntos': 0},
     {'texto': 'C.- En La Serena (SCSE) la base (techo) de la capa de nubes stratus está a 150 metros.','puntos': 0},
     ]         
  },

{
    'texto': '83.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'GRADU 1415 4CU040 indica cambio gradual entre 14 y 15 UTC hacia 4 octas de cúmulos a 4.000 ft. Fuente: OACI Anexo 3; DGAC Chile, clave TAF local.',
    
    'respuestas': [
     {'texto': 'A.- En La Serena (SCSE) a las 14:45 UTC habrá un cambio gradual de la nubosidad.','puntos': 0},
     {'texto': 'B.- En La Serena (SCSE) entre las 14 y 15 horas habrá 4/8 de CU a 400 metros.','puntos': 0},
     {'texto': 'C.- En La Serena (SCSE) entre las 14 y 15 horas habrá un cambio gradual de la nubosidad.','puntos': 1},
     ]         
  },

{
    'texto': '84.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'GRADU 1617 27010KT indica cambio gradual entre 16 y 17 UTC a viento desde 270° con 10 kt. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- En La Serena (SCSE) a las 16:17 UTC el viento cambiará gradualmente a 270° con 10 nudos.','puntos': 0},
     {'texto': 'B.- En La Serena (SCSE) entre las 16 y 17 UTC el viento cambiará a 270° con 10 nudos.','puntos': 1},
     {'texto': 'C.- En La Serena (SCSE) entre las 16 y 17 UTC el viento soplará hacia los 270 con una intensidad de 10 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '85.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'2000 05HZ indica visibilidad de 2.000 m reducida por bruma; HZ corresponde a haze. Fuente: OACI Anexo 3; FMH-1 METAR/TAF.',
    
    'respuestas': [
     {'texto': 'A.- En SCEL la visibilidad está reducida a 2000 metros por humo.','puntos': 0},
     {'texto': 'B.- En SCEL la visibilidad está reducida a 2000 metros por bruma.','puntos': 1},
     {'texto': 'C.- En SCEL la visibilidad está reducida a 200 metros llovizna.','puntos': 0},
     ]         
  },

{
    'texto': '86.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'4AC150 indica 4 octas de altocúmulos con base a 15.000 ft, aproximadamente 4.600 m. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- En SCEL la base de la nubosidad del tipo altocirros se encuentra a 15.000 pies.','puntos': 0},
     {'texto': 'B.- En SCEL la base de la nubosidad del tipo altocúmulos se encuentra a 1.500 metros.','puntos': 0},
     {'texto': 'C.- En SCEL la base de la nubosidad del tipo altocúmulos se encuentra a 4.600 metros aproximadamente.','puntos': 1},
     ]         
  },

{
    'texto': '87.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'1200 RASH indica visibilidad de 1.200 m afectada por chubascos de lluvia. Fuente: OACI Anexo 3; FMH-1 METAR/TAF.',
    
    'respuestas': [
     {'texto': 'A.- En SCMO la visibilidad está reducida a 1.200 metros por chubascos de lluvia.','puntos': 1},
     {'texto': 'B.- En SCMO la visibilidad está reducida a 1.200 metros por chubascos de nieve.','puntos': 0},
     {'texto': 'C.- En SCMO la visibilidad está reducida a 1.200 pies por chubascos de lluvia.','puntos': 0},
     ]         
  },

{
    'texto': '88.- En el Pronóstico de Terminal que debe analizar antes de iniciar un vuelo, Ud. lee lo que sigue: TAF 211057 SCEMYMYX SCSE 1206 VRB05KT 9999 8ST015 GRADU 1415 4CU040 GRADU 1617 27010KT SCEL 1206 VRB08KT 2000 05HZ 8SC030 GRADU 1213 23008KT 6CU040 4AC150 SCMO 1206 35009KT 1200 80RASH 8NS003 3CB050 EMBD TOP 25/30 MILFT 7CI250 TURB MOD BTN 7/20 MILFT ICE MOD ICL BTN 5/30 MILFT SCCI 1206 08045KT 1500 RESNSH BCFG 8CU030 6AC080 3CB INC BTN 6/30 MILFT ICE MOD INC BTN 6/30 MILFT TUR MOD BTN 6/35 MILFT JTST SECTOR SCCI 40.000 FT 280130 KT. De este pronóstico se puede determinar qué:',
    'explicacion': r'SNSH/RESNSH indica chubascos de nieve y BCFG bancos de niebla; por eso se interpreta nieve reciente o presente y niebla. Fuente: OACI Anexo 3; FMH-1 METAR/TAF.',
    
    'respuestas': [
     {'texto': 'A.- En SCCI no habrá chubascos, sólo niebla y turbulencia moderada entre 6.000 pies y 30.000 pies.','puntos': 0},
     {'texto': 'B.- En SCCI habrá chubascos de nieve y después niebla.','puntos': 1},
     {'texto': 'C.- En SCCI a 1500 pies sobre el aeropuerto habrá un viento que soplará desde los 080 grados con una intensidad de 45 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '89.- Según la Información Meteorológica de la Figura 116, el aeropuerto de Arica (SCAR), se encuentra:',
    'explicacion': r'La información codificada para SCAR indica cielo despejado, temperatura 26 °C y punto de rocío 18 °C. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Despejado y con una temperatura ambiente de 26 grados y una temperatura del punto de rocío de 18 grados.','puntos': 1},
     {'texto': 'B.- Sin nubosidad, con una temperatura del punto de rocío de 26 grados y una temperatura ambiente de 18 grados. Además, el viento es de los 220 grados con 12 nudos.','puntos': 0},
     {'texto': 'C.- Con un techo de nubes y una visibilidad apropiadas para vuelo VFR. El viento es de los 220 grados con 12 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '90.- Según la Información Meteorológica de la Figura 116, Isla de Pascua (SCIP) el día 16 a las 17:00 hora Z tenía una visibilidad ....',
    'explicacion': r'La visibilidad aeronáutica se informa en metros; el rango 4.000 a 11.000 corresponde a visibilidad variable en metros. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Variable entre 4.000 y 11.000 pies.','puntos': 0},
     {'texto': 'B.- Variable entre 4.000 y 11.000 metros.','puntos': 1},
     {'texto': 'C.- Variable entre 40 y 110 metros.','puntos': 0},
     ]         
  },

{
    'texto': '91.- Según la Información Meteorológica de la Figura 116, La Serena está:',
    'explicacion': r'Cubierto corresponde a 8 octas; la base indicada equivale aproximadamente a 600 m. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Parcialmente cubierto (4/8) y las nubes tienen una base de 1.900 pies.','puntos': 0},
     {'texto': 'B.- Casi despejado y la base de la nubosidad es de aproximadamente 1900 metros.','puntos': 0},
     {'texto': 'C.- Cubierto y la base de la nubosidad es de aproximadamente 600 metros.','puntos': 1},
     ]         
  },

{
    'texto': '92.- Según la Información Meteorológica de la Figura 116, el día 16 a las 17:00 UTC el aeródromo de Tobalaba (SCTB) tenía:',
    'explicacion': r'El reporte de SCTB indica cielo despejado, visibilidad 6.000 m y viento muy débil, coherente con la opción marcada. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Nubosidad dispersa, viento de los 230 grados con una intensidad de 3 nudos y 6.000 pies de visibilidad.','puntos': 0},
     {'texto': 'B.- Cielo despejado, visibilidad de 6.000 metros y muy poco viento.','puntos': 1},
     {'texto': 'C.- Nubosidad dispersa cuya base era de 6.000 pies y viento de los 230 grados con 3 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '93.- Según la Información Meteorológica de la Figura 116, el día 16 a las 17:00 UTC, Balmaceda (SCBA) tenía:',
    'explicacion': r'La codificación muestra nubosidad dispersa a 4.000 y 20.000 ft, más viento arrachado desde 310° entre 27 y 39 kt. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Nubosidad dispersa (3/8 a 4/8) a 4.000 pies y 20.000 pies, y ráfagas de viento de 27 a 39 nudos desde los 310 grados.','puntos': 1},
     {'texto': 'B.- Cielo cubierto por dos capas de nubes, una a 4.000 pies y la otra a 20.000 pies. El viento estaba arrachado entre 27 y 39 nudos desde los 310 grados.','puntos': 0},
     {'texto': 'C.- Visibilidad ilimitada, viento de los 310 grados entre 27 y 39 nudos, nubes de tipo estratocúmulos a 400 y 2.000 pies, QNH 1008 hPa, y temperatura ambiente y punto de rocío de 18 y 11 grados respectivamente.','puntos': 0},
     ]         
  },

{
    'texto': '94.- Según la Información Meteorológica de la Figura 116, a las 17:00 UTC Punta Arenas (SCCI) tenía:',
    'explicacion': r'La lectura de SCCI indica pocas nubes cerca de 600 m y condición quebrada aproximadamente a 6.000 m. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Un viento que soplaba hacia los 270 grados con una intensidad de 26 nudos.','puntos': 0},
     {'texto': 'B.- Pocas nubes a 200 metros y quebrado a 2.000 metros, el QNH 994 y la temperatura ambiente y punto de rocío eran 14 y 6 grados respectivamente.','puntos': 0},
     {'texto': 'C.- Pocas nubes a aproximadamente 600 metros y quebrado a aproximadamente 6.000 metros.','puntos': 1},
     ]         
  },

{
    'texto': '95.- Indique qué significado tienen, respectivamente, las abreviaturas BECMG, INC y TEMPO en la Información Meteorológica de la Figura 117.',
    'explicacion': r'BECMG significa cambio gradual, INC indica dentro de nubes y TEMPO condiciones temporales. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Becoming (transformándose en ...), inconsistente y temporal.','puntos': 0},
     {'texto': 'B.- Becoming, intermitente y temporalmente.','puntos': 0},
     {'texto': 'C.- Becoming, dentro de nubes y temporalmente.','puntos': 1},
     ]         
  },

{
    'texto': '96.- El frente meteorológico identificado por una letra “O” en la Figura 120:',
    'explicacion': r'La simbología señalada por la letra O corresponde, según la figura del banco, a un frente estacionario en altura. Fuente: OMM-No. 306; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Es un frente estacionario en superficie.','puntos': 0},
     {'texto': 'B.- Es un frente ocluido en superficie.','puntos': 0},
     {'texto': 'C.- Es un frente estacionario en altura.','puntos': 1},
     ]         
  },

{
    'texto': '97.- La corriente de chorro identificada por dos letras “Z” (Figura 120), bajo la letra “V”, tiene una barra doble casi vertical. Esta barra doble significa:',
    'explicacion': r'La barra doble en la simbología del jet indica cambio significativo en la velocidad de la corriente de chorro. Fuente: OACI Doc 8896; OMM-No. 306.',
    
    'respuestas': [
     {'texto': 'A.- Un cambio significativo en el nivel de la corriente de chorro.','puntos': 0},
     {'texto': 'B.- Un cambio significativo en la velocidad de la corriente de chorro.','puntos': 1},
     {'texto': 'C.- Cizalle de la corriente de chorro al ingresar a la tropopausa.','puntos': 0},
     ]         
  },

{
    'texto': '98.- En el Pronóstico Meteorológico de la Figura 120, al sur de Chile hay una corriente de chorro identificada por una letra “Z”. Indique cuál es la velocidad del viento en esa corriente a FL 340.',
    'explicacion': r'La corriente de chorro indicada a FL340 tiene velocidad de 90 kt según la simbología de la figura. Fuente: OACI Doc 8896; OMM-No. 306.',
    
    'respuestas': [
     {'texto': 'A.- 90 nudos.','puntos': 1},
     {'texto': 'B.- 140 nudos.','puntos': 0},
     {'texto': 'C.- 70 nudos.','puntos': 0},
     ]         
  },

{
    'texto': '99.- En el Pronóstico Meteorológico de la Figura 120, inmediatamente bajo y a la derecha de la letra “X”, hay un símbolo semejante a una campana. Ello es indicativo de:',
    'explicacion': r'El símbolo tipo campana en cartas significativas representa erupción volcánica, fenómeno crítico por ceniza en ruta. Fuente: OACI Anexo 3; OACI Doc 9766.',
    
    'respuestas': [
     {'texto': 'A.- Tempestad extensa de arena o polvo.','puntos': 0},
     {'texto': 'B.- Tormentas.','puntos': 0},
     {'texto': 'C.- Erupción volcánica.','puntos': 1},
     ]         
  },

{
    'texto': '100.- Referencia Figura 121. Ud. efectuará un vuelo desde el aeropuerto “a” al aeropuerto “c” al nivel de vuelo 340. A fin de planificar este vuelo Ud. debería considerar que su avión...',
    'explicacion': r'La figura indica viento de cola aproximado de 50 kt al FL340 y temperatura exterior cercana a -44 °C. Fuente: OACI Anexo 3; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Será afectado por un viento de frente de aproximadamente 50 nudos, y a ese nivel la temperatura exterior será de menos 44° C.','puntos': 0},
     {'texto': 'B.- Será afectado por un viento de cola de aproximadamente 50 nudos, y una temperatura exterior de menos 44°C.','puntos': 1},
     {'texto': 'C.- Será afectado inicialmente por un viento de frente de 40 nudos; luego la velocidad del viento aumentará a 100 nudos. La temperatura se mantendrá en menos 44°C.','puntos': 0},
     ]         
  },

{
    'texto': '101.- ¿Dónde se encuentra la ubicación usual de una baja térmica?',
    'explicacion': r'Una baja térmica se forma por calentamiento intenso sobre superficies secas y soleadas, que reduce la presión en superficie. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Sobre la región antártica.','puntos': 0},
     {'texto': 'B.- En el ojo de un huracán.','puntos': 0},
     {'texto': 'C.- Sobre la superficie de una región seca y soleada.','puntos': 1},
     ]         
  },

{
    'texto': '102.- ¿Cómo afecta la fuerza de Coriolis a la dirección del viento en el Hemisferio Sur?',
    'explicacion': r'En el Hemisferio Sur, Coriolis desvía a la izquierda y la circulación alrededor de una baja es horaria. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OMM-No. 49.',
    
    'respuestas': [
     {'texto': 'A.- Produce rotación en el sentido del reloj alrededor de una baja.','puntos': 1},
     {'texto': 'B.- Hace que el viento salga de una baja hacia una alta.','puntos': 0},
     {'texto': 'C.- Produce exactamente el mismo efecto que en el Hemisferio Norte.','puntos': 0},
     ]         
  },

{
    'texto': '103.- ¿Qué condición meteorológica se define como “anticiclón”?',
    'explicacion': r'Un anticiclón es una zona de alta presión, asociada generalmente a subsidencia y estabilidad atmosférica. Fuente: OMM-No. 306; FAA Aviation Weather Handbook, FAA-H-8083-28.',
    
    'respuestas': [
     {'texto': 'A.- Calma.','puntos': 0},
     {'texto': 'B.- Zona de alta presión.','puntos': 1},
     {'texto': 'C.- COL.','puntos': 0},
     ]         
  },

{
    'texto': '104.- ¿Qué tipo de nubes se puede asociar a la corriente en chorro (jetstream)?',
    'explicacion': r'Los cirrus en el lado ecuatorial del jetstream son una señal frecuente de vientos fuertes en altura. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Una línea de cumulonimbos donde el jetstream cruza el frente frío.','puntos': 0},
     {'texto': 'B.- Cirrus en el lado ecuatorial del jetstream.','puntos': 1},
     {'texto': 'C.- Una banda de cirroestratos en el lado polar y bajo el jetstream.','puntos': 0},
     ]         
  },

{
    'texto': '105.- Según la Información Meteorológica de la Figura 118, en Guayaquil:',
    'explicacion': r'La lectura indica visibilidad mayor a 10 km, 3-4 octas a 2.000 ft y 5-7 octas a 9.000 ft. Fuente: OACI Anexo 3; OMM-No. 782.',
    
    'respuestas': [
     {'texto': 'A.- Habrá sobre 10 kilómetros de visibilidad, 3 a 4 octavos de cielo cubierto a 2.000 pies y 5 a 7 octavos de cielo cubierto a 9.000 pies.','puntos': 1},
     {'texto': 'B.- Habrá sobre 10 kilómetros de visibilidad, 3 a 4 octavos de cielo cubierto a 2.000 metros y 5 a 7 octavos de cielo cubierto a 9.000 metros.','puntos': 0},
     {'texto': 'C.- La visibilidad será superior a 10 kilómetros y en total habrá 8 octavos de cielo cubierto a 2.000 pies y a 9.000 pies.','puntos': 0},
     ]         
  },

{
    'texto': '106.- Si se encuentra lluvia congelante durante el ascenso, es evidencia de que:',
    'explicacion': r'La lluvia congelante en ascenso evidencia una capa cálida superior que permite fusión antes de recongelamiento o sobreenfriamiento. Fuente: FAA Aviation Weather Handbook, FAA-H-8083-28; OACI Doc 8896.',
    
    'respuestas': [
     {'texto': 'A.- Se puede ascender a mayor altitud sin encontrar más que hielo ligero.','puntos': 0},
     {'texto': 'B.- Arriba existe una capa de aire más cálido.','puntos': 1},
     {'texto': 'C.- Granizos (ice pellets) de niveles superiores han cambiado a lluvia en el aire cálido de niveles inferiores.','puntos': 0},
     ]         
  },

{
    'texto': '107.- Según la Información Meteorológica de la Figura 116, el día 16 a las 17:00 UTC el aeródromo de Concepción (SCIE) tenía:',
    'explicacion': r'La información de SCIE indica visibilidad mayor a 10 km, valor operacional codificado como visibilidad superior a 10 km. Fuente: OACI Anexo 3; OMM-No. 782.',
    
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
    'explicacion': r'La instrucción sobre oxígeno es obligatoria cuando el vuelo prevé la posibilidad de suministrarlo a pasajeros; por ello la alternativa C delimita correctamente la condición operacional. Fuente: DGAC Chile, DAN 121, requisitos de información a pasajeros y oxígeno suplementario.',
    
    'respuestas': [
     {'texto': 'A.- El vuelo se realice sobre 8.000 pies por más de 30 minutos.','puntos': 0},
     {'texto': 'B.- El vuelo se realice sobre 14.000 pies por más de 10 minutos.','puntos': 0},
     {'texto': 'C.- Se prescriba la posibilidad de suministro de oxígeno a los pasajeros durante el vuelo.','puntos': 1},
     ]         
  },

{
    'texto': '2.- ¿A quiénes comprende el término “miembro de la tripulación”?',
    'explicacion': r'La definición reglamentaria de tripulante comprende a toda persona asignada a funciones a bordo durante el vuelo, no solo a pilotos. Fuente: DGAC Chile, DAR 01, definiciones de personal aeronáutico.',
    
    'respuestas': [
     {'texto': 'A.- A los pilotos, al operador de sistemas o al navegante del avión, si corresponde.','puntos': 0},
     {'texto': 'B.- A toda persona que se le asignan funciones dentro de una aeronave en vuelo.','puntos': 1},
     {'texto': 'C.- A toda persona que se le asignan funciones dentro de una aeronave en vuelo, excepto los pilotos y el operador de sistema, si corresponde.','puntos': 0},
     ]         
  },

{
    'texto': '3.- ¿Bajo qué condiciones se requiere que un operador de sistemas (Flight Engineer) integre la tripulación de vuelo?',

    'explicacion': r'El operador de sistemas forma parte de la tripulación cuando la certificación de tipo o el manual de operaciones del avión exige ese puesto. Fuente: DGAC Chile, DAN 121, composición de tripulación de vuelo.',
    
    'respuestas': [
     {'texto': 'A.- Cuando se efectúa un vuelo de prueba mientras se transporta carga de pago.','puntos': 0},
     {'texto': 'B.- Cuando el avión es un turborreactor pesado propulsado por más de dos motores.','puntos': 0},
     {'texto': 'C.- Cuando así lo requiere la certificación del avión y/o lo especifica su manual de operaciones.','puntos': 1},
     ]         
  },

{
    'texto': '4.- ¿Cuánto es el mínimo de auxiliares de cabina requeridos en un avión con una capacidad de 333 asientos instalados para pasajeros y que transporta 296 pasajeros?',
    'explicacion': r'El mínimo de auxiliares se determina por la capacidad instalada de asientos de pasajeros; con 333 asientos corresponde una dotación mínima de siete. Fuente: DGAC Chile, DAN 121, tripulación de cabina mínima.',
    
    'respuestas': [
     {'texto': 'A.- Siete.','puntos': 1},
     {'texto': 'B.- Seis.','puntos': 0},
     {'texto': 'C.- Cinco.','puntos': 0},
     ]         
  },

{
    'texto': '5.- ¿Cuánto es el mínimo de auxiliares de cabina requeridos en un avión de transporte público que tiene instalados 188 asientos para pasajeros, pero que lleva sólo 117 pasajeros a bordo?',
    'explicacion': r'La dotación de cabina se calcula por asientos instalados y no por pasajeros transportados; 188 asientos exige cuatro auxiliares. Fuente: DGAC Chile, DAN 121, requisitos de auxiliares de cabina.',
    
    'respuestas': [
     {'texto': 'A.- Cinco.','puntos': 0},
     {'texto': 'B.- Cuatro.','puntos': 1},
     {'texto': 'C.- Tres.','puntos': 0},
     ]         
  },

{
    'texto': '6.- De acuerdo a lo prescrito en el reglamento de operación de aviones de transporte público, el concepto de “vuelos de larga distancia” es aplicable a operaciones efectuadas con aviones bimotores o más motores de capacidad de más de 30 pasajeros y cuya ruta incluya cualquier punto que con respecto a un aeródromo adecuado de aterrizaje, se encuentre a más de:',
    'explicacion': r'La operación de larga distancia se configura cuando la ruta incluye puntos a más de 60 minutos de un aeródromo adecuado. Fuente: DGAC Chile, DAN 121, operaciones de largo alcance/ETOPS.',
    
    'respuestas': [
     {'texto': 'A.- 30 minutos o más.','puntos': 0},
     {'texto': 'B.- 45 minutos o más.','puntos': 0},
     {'texto': 'C.- 60 minutos o más.','puntos': 1},
     ]         
  },

{
    'texto': '7.- Distancia de despegue disponible es la distancia que la autoridad aeronáutica ha establecido como adecuada para despegar y ascender hasta una altura de:',
    'explicacion': r'La distancia de despegue disponible considera el tramo utilizable para despegar y alcanzar 35 pies de altura reglamentaria. Fuente: DGAC Chile, DAN 14 y OACI Anexo 14, definiciones de distancias declaradas.',
    
    'respuestas': [
     {'texto': 'A.- 35 pies.','puntos': 1},
     {'texto': 'B.- 50 pies.','puntos': 0},
     {'texto': 'C.- 75 pies.','puntos': 0},
     ]         
  },

{
    'texto': '8.- El área de un aeródromo terrestre destinada al embarque, desembarque de pasajeros o carga, estacionamiento y carguío de combustible de aeronaves, se denomina:',
    'explicacion': r'La plataforma es el área destinada al embarque, desembarque, carga, estacionamiento y servicio de aeronaves. Fuente: DGAC Chile, DAR 14, definiciones de aeródromos.',
    
    'respuestas': [
     {'texto': 'A.- Losa de estacionamiento.','puntos': 0},
     {'texto': 'B.- Área de maniobras.','puntos': 0},
     {'texto': 'C.- Plataforma.','puntos': 1},
     ]         
  },

{
    'texto': '9.- El máximo período de servicio de vuelo (PSV) en 24 horas, para una tripulación compuesta por dos pilotos, y que efectúa operaciones de transporte público, es de:',
    'explicacion': r'Para una tripulación de dos pilotos en transporte público, el PSV máximo señalado es de 12 horas en 24 horas. Fuente: DGAC Chile, DAN 121, limitaciones de tiempo de servicio de vuelo.',
    
    'respuestas': [
     {'texto': 'A.- 08:00 horas.','puntos': 0},
     {'texto': 'B.- 10:00 horas.','puntos': 0},
     {'texto': 'C.- 12:00 horas.','puntos': 1},
     ]         
  },

{
    'texto': '10.- El máximo período de validez del certificado médico de una licencia de piloto de transporte de línea aérea, es de:',
    'explicacion': r'El certificado médico asociado a licencia ATPL tiene una validez máxima de seis meses según los requisitos médicos aplicables. Fuente: DGAC Chile, DAN 67/DAN 61, certificación médica aeronáutica.',
    
    'respuestas': [
     {'texto': 'A.- Seis meses.','puntos': 1},
     {'texto': 'B.- Ocho meses.','puntos': 0},
     {'texto': 'C.- Doce meses.','puntos': 0},
     ]         
  },

{
    'texto': '11.- El máximo tiempo de vuelo reglamentario en 24 horas consecutivas, en vuelos comerciales de transporte público de pasajeros, para una tripulación compuesta por tres pilotos es de:',
    'explicacion': r'Con tripulación compuesta por tres pilotos, el máximo tiempo de vuelo reglamentario en 24 horas es de 12 horas. Fuente: DGAC Chile, DAN 121, limitaciones de tiempo de vuelo.',
    
    'respuestas': [
     {'texto': 'A.- 10 horas.','puntos': 0},
     {'texto': 'B.- 12 horas.','puntos': 1},
     {'texto': 'C.- 14 horas.','puntos': 0},
     ]         
  },

{
    'texto': '12.- El propósito del ATC (Air Traffic Controller) es:',
    'explicacion': r'El ATC existe para prevenir colisiones y mantener un flujo seguro, ordenado y expedito del tránsito aéreo. Fuente: OACI Anexo 11 y DGAC Chile, DAN 11, servicios de tránsito aéreo.',
    
    'respuestas': [
     {'texto': 'A.- Notificar servicios de búsqueda y salvamento.','puntos': 0},
     {'texto': 'B.- Entregar servicios de información de vuelo.','puntos': 0},
     {'texto': 'C.- Prevenir colisiones, acelerar y mantener ordenadamente el movimiento del tránsito aéreo.','puntos': 1},
     ]         
  },

{
    'texto': '13.- El reglamento de operación de aviones de transporte público establece el número mínimo de extintores que debe llevar un avión. Esta cantidad de extintores está determinada por:',
    'explicacion': r'La cantidad mínima de extintores de cabina se determina por la capacidad de asientos de pasajeros instalada. Fuente: DGAC Chile, DAN 121, equipos de emergencia a bordo.',
    
    'respuestas': [
     {'texto': 'A.- La capacidad de asientos de pasajeros del avión.','puntos': 1},
     {'texto': 'B.- El número de pasajeros que se transporta.','puntos': 0},
     {'texto': 'C.- El volumen de la cabina de carga o pasajeros.','puntos': 0},
     ]         
  },

{
    'texto': '14.- ¿En caso de incapacitación en vuelo del operador de sistemas, quién puede desempeñar las funciones de éste?',
    'explicacion': r'Si el operador de sistemas queda incapacitado, sus funciones pueden ser asumidas por otro tripulante de vuelo capacitado para ello. Fuente: DGAC Chile, DAN 121, tripulación de vuelo y procedimientos ante incapacitación.',
    
    'respuestas': [
     {'texto': 'A.- Solamente el copiloto.','puntos': 0},
     {'texto': 'B.- Cualquier miembro de la tripulación de vuelo que esté capacitado para ello.','puntos': 1},
     {'texto': 'C.- Cualquiera de los pilotos, siempre que sean titulares de una licencia de operador de sistemas.','puntos': 0},
     ]         
  },

{
    'texto': '15.- En Chile, en todas las operaciones aeroterrestres, excepto para el despegue y el aterrizaje, la dirección del viento se proporciona:',
    'explicacion': r'En operaciones aeroterrestres la dirección del viento se entrega en grados verdaderos, salvo la información usada para despegue y aterrizaje. Fuente: DGAC Chile, DAN 91 y procedimientos ATS.',
    
    'respuestas': [
     {'texto': 'A.- En grados magnéticos.','puntos': 0},
     {'texto': 'B.- Según su derrota magnética.','puntos': 0},
     {'texto': 'C.- En grados verdaderos.','puntos': 1},
     ]         
  },

{
    'texto': '16.- En Chile, una aeronave con plan de vuelo VFR volará en una derrota magnética de 350°. Indique cuál de las siguientes altitudes es la reglamentaria a mantener.',
    'explicacion': r'Para vuelos VFR se aplican niveles semicirculares según derrota magnética; en derrota 350° corresponde una altitud VFR impar más 500 pies, como 18.500 pies. Fuente: DGAC Chile, DAN 91, reglas de vuelo visual.',
    
    'respuestas': [
     {'texto': 'A.- 18.500 pies.','puntos': 1},
     {'texto': 'B.- 19.000 pies.','puntos': 0},
     {'texto': 'C.- 19.500 pies.','puntos': 0},
     ]         
  },

{
    'texto': '17.- En Chile, una aeronave se encuentra volando en crucero (vuelo nivelado), con plan de vuelo VFR en el curso magnético 200°. Indique cuál de las siguientes altitudes es la reglamentaria a mantener.',
    'explicacion': r'Para derrota magnética 200° en crucero VFR corresponde la serie semicircular par más 500 pies; por eso 19.500 pies es la opción reglamentaria. Fuente: DGAC Chile, DAN 91, niveles de crucero VFR.',
    
    'respuestas': [
     {'texto': 'A.- 19.000 pies.','puntos': 0},
     {'texto': 'B.- 18.500 pies.','puntos': 0},
     {'texto': 'C.- 19.500 pies.','puntos': 1},
     ]         
  },

{
    'texto': '18.- En operaciones de transporte público, efectuadas con aviones turborreactores, el mínimo combustible requerido para el despacho es el necesario para volar desde el aeródromo de origen al de destino, más el combustible para volar desde la aproximación frustrada en el destino hasta la alternativa, más:',
    'explicacion': r'El combustible mínimo incluye destino, alternativa y reserva de 30 minutos a 1.500 pies sobre la alternativa, más contingencias. Fuente: DGAC Chile, DAN 121, planificación de combustible.',
    
    'respuestas': [
     {'texto': 'A.- El combustible para 30 minutos de espera a nivel de crucero, más combustible para contingencias.','puntos': 0},
     {'texto': 'B.- El combustible para 30 minutos de vuelo a 1.500 pies de altura en circuito de espera (holding) sobre el aeródromo de alternativa, más combustible para contingencias.','puntos': 1},
     {'texto': 'C.- El combustible para 45 minutos de espera sobre el aeródromo alternativa, más una cantidad de combustible adicional para contingencias.','puntos': 0},
     ]         
  },

{
    'texto': '19.- En operaciones de transporte público, el máximo tiempo de vuelo reglamentario, para una tripulación mínima, programada para efectuar un vuelo con 8 aterrizajes, es de:',
    'explicacion': r'Con ocho aterrizajes programados, la limitación reglamentaria reduce el tiempo máximo de vuelo de la tripulación mínima a 6 horas 30 minutos. Fuente: DGAC Chile, DAN 121, límites de tiempo de vuelo por número de aterrizajes.',
    
    'respuestas': [
     {'texto': 'A.- 6 horas y 30 minutos.','puntos': 1},
     {'texto': 'B.- 7 horas y 30 minutos.','puntos': 0},
     {'texto': 'C.- 8 horas.','puntos': 0},
     ]         
  },

{
    'texto': '20.- En operaciones de transporte público, el mínimo largo de pista reglamentario en el aeródromo de alternativa es el necesario para detener la aeronave en el aterrizaje, en:',
    'explicacion': r'En aeródromo de alternativa, la distancia de aterrizaje requerida no debe exceder el 70% de la distancia disponible. Fuente: DGAC Chile, DAN 121, performance de aterrizaje en alternativa.',
    
    'respuestas': [
     {'texto': 'A.- El 70% de la pista disponible.','puntos': 1},
     {'texto': 'B.- El 75% de la pista disponible.','puntos': 0},
     {'texto': 'C.- El 80% de la pista disponible.','puntos': 0},
     ]         
  },

{
    'texto': '21.- Entre la puesta y la salida del sol, todas las aeronaves que operen en el área de movimiento de un aeródromo ostentarán:',
    'explicacion': r'Entre la puesta y salida del sol, las aeronaves en el área de movimiento deben exhibir luces de navegación y anticolisión. Fuente: DGAC Chile, DAN 91, luces que deben ostentar las aeronaves.',
    
    'respuestas': [
     {'texto': 'A.- Las luces anticolisión y estroboscópicas.','puntos': 0},
     {'texto': 'B.- Las luces de navegación y anticolisión.','puntos': 1},
     ]         
  },

{
    'texto': '22.- En vuelos de transporte público siempre se debe preparar, antes del vuelo, un plan operacional de vuelo. Estos planes operacionales de vuelo se deben conservar durante un tiempo mínimo de:',
    'explicacion': r'El plan operacional de vuelo debe conservarse por al menos seis meses como registro operacional. Fuente: DGAC Chile, DAN 121, documentación y conservación de planes operacionales.',
    
    'respuestas': [
     {'texto': 'A.- Seis meses.','puntos': 1},
     {'texto': 'B.- Doce meses.','puntos': 0},
     {'texto': 'C.- Dieciocho meses.','puntos': 0},
     ]         
  },

{
    'texto': '23.- Indique cuál de los siguientes requerimientos constituye parte del requisito de experiencia reciente para un piloto al mando.',
    'explicacion': r'La experiencia reciente exige tres despegues y tres aterrizajes en el mismo tipo de avión dentro del período reglamentario indicado. Fuente: DGAC Chile, DAN 61 y DAN 121, experiencia reciente de pilotos.',
    
    'respuestas': [
     {'texto': 'A.- Haber efectuado como mínimo un aterrizaje con falla simulada del motor más crítico en los últimos 90 días.','puntos': 0},
     {'texto': 'B.- Haber efectuado como mínimo una aproximación ILS hasta la DH publicada y aterrizaje desde esta aproximación en los últimos seis meses.','puntos': 0},
     {'texto': 'C.- Haber efectuado como mínimo tres despegues y tres aterrizajes en el mismo tipo de avión en los últimos 60 días.','puntos': 1},
     ]         
  },

{
    'texto': '24.- Indique en cuál de las siguientes circunstancias un piloto al mando requiere ser titular de una habilitación de tipo:',
    'explicacion': r'La habilitación de tipo es exigible para aviones certificados para operación con más de un piloto. Fuente: DGAC Chile, DAN 61, habilitaciones de tipo.',
    
    'respuestas': [
     {'texto': 'A.- Cuando vuela un avión certificado para ser operado con más de un piloto.','puntos': 1},
     {'texto': 'B.- Cuando vuela un avión cuyo máximo peso de despegue es de más de 12.500 lbs.','puntos': 0},
     {'texto': 'C.- Cuando vuela un avión multimotor con un peso máximo de despegue de más de 6.000 lbs.','puntos': 0},
     ]         
  },

{
    'texto': '25.- Indique la aseveración correcta con relación a las operaciones ILS Categoría III.',
    'explicacion': r'En operaciones CAT III fail-passive, la altura de decisión operacional indicada es 50 pies. Fuente: DGAC Chile, normativa LVO/CAT II-III y OACI Doc 9365, operaciones todo tiempo.',
    
    'respuestas': [
     {'texto': 'A.- Las operaciones fail-passive están limitadas a ILS Categoría IIIB.','puntos': 0},
     {'texto': 'B.- Las operaciones fail-passive se llevan a cabo con una DH de 50 pies.','puntos': 1},
     {'texto': 'C.- Las operaciones ILS CAT III fail-operation están limitadas a una DH de 50 pies.','puntos': 0},
     ]         
  },

{
    'texto': '26.- Indique la aseveración correcta con relación a las operaciones ILS Categoría II y III.',
    'explicacion': r'Las operaciones ILS CAT II/III requieren autorización consignada en la licencia, vinculada al material y función autorizados. Fuente: DGAC Chile, DAN 61, habilitaciones especiales IFR CAT II/III.',
    
    'respuestas': [
     {'texto': 'A.- La habilitación IFR autoriza a su titular a efectuar operaciones ILS Categoría II y III, siempre que el avión y el aeropuerto estén equipados para ello.','puntos': 0},
     {'texto': 'B.- Para efectuar operaciones ILS Categoría II o III, el titular de la licencia debe tener consignada en su licencia esta habilitación, con indicación del tipo de material autorizado y la función correspondiente.','puntos': 1},
     {'texto': 'C.- La habilitación Categoría II o III estampada en la licencia autoriza a su titular a efectuar estas operaciones en cualquier tipo de avión equipado para ello.','puntos': 0},
     ]         
  },

{
    'texto': '27.- Indique la aseveración correcta con relación a mantener dos o más “habilitaciones de tipo de aeronave” en una licencia de vuelo.',
    'explicacion': r'Para mantener más de una habilitación de tipo, el titular debe cumplir entrenamiento periódico de cada tipo cada seis meses, sin aplicar el intervalo 4/8. Fuente: DGAC Chile, DAN 61, vigencia y entrenamiento periódico de habilitaciones de tipo.',
    
    'respuestas': [
     {'texto': 'A.- El titular debe someterse cada seis meses al entrenamiento periódico requerido para cada tipo de avión, y no le es aplicable el procedimiento de efectuar los entrenamientos a intervalos no mayores de ocho meses ni menores de cuatro meses.','puntos': 1},
     {'texto': 'B.- En Chile no se autoriza la doble habilitación de tipo.','puntos': 0},
     {'texto': 'C.- La doble habilitación de tipo sólo es posible si una habilitación es de avión y la otra de helicóptero.','puntos': 0},
     ]         
  },

{
    'texto': '28.- Indique la aseveración correcta con respecto a un espacio aéreo ATS, Clase A.',
    'explicacion': r'En espacio aéreo ATS Clase A solo se permiten vuelos IFR, todos bajo servicio de control. Fuente: DGAC Chile, DAN 11 y OACI Anexo 11, clasificación de espacios ATS.',
    
    'respuestas': [
     {'texto': 'A.- Sólo se permiten vuelos IFR.','puntos': 1},
     {'texto': 'B.- Sólo se autorizan vuelos VFR.','puntos': 0},
     {'texto': 'C.- Se permiten vuelos IFR y VFR.','puntos': 0},
     ]         
  },

{
    'texto': '29.- La abreviatura utilizada para informe meteorológico aeronáutico ordinario es:',
    'explicacion': r'METAR es la abreviatura del informe meteorológico aeronáutico ordinario de aeródromo. Fuente: OACI Anexo 3 y DGAC Chile, normativa meteorológica aeronáutica.',
    
    'respuestas': [
     {'texto': 'A.- TAF.','puntos': 0},
     {'texto': 'B.- IMO.','puntos': 0},
     {'texto': 'C.- METAR.','puntos': 1},
     ]         
  },

{
    'texto': '30.- La abreviatura utilizada para pronóstico de aeródromo es:',
    'explicacion': r'TAF es la abreviatura internacional del pronóstico meteorológico de aeródromo. Fuente: OACI Anexo 3 y DGAC Chile, codificación meteorológica aeronáutica.',
    
    'respuestas': [
     {'texto': 'A.- TAF','puntos': 1},
     {'texto': 'B.- PDA','puntos': 0},
     {'texto': 'C.- METAR','puntos': 0},
     ]         
  },

{
    'texto': '31.- La autorización para rodar hacia una pista permite también:',
    'explicacion': r'La autorización de rodaje permite usar calles asignadas y cruzar intersecciones de calles de rodaje, no ingresar o cruzar pistas sin autorización específica. Fuente: DGAC Chile, DAN 11/DAN 91, autorizaciones de control de aeródromo.',
    
    'respuestas': [
     {'texto': 'A.- Cruzar intersecciones de pista si el piloto verifica que no hay tráfico esencial.','puntos': 0},
     {'texto': 'B.- Utilizar las calles de rodaje designadas y cruzar intersecciones de otras calles de rodaje.','puntos': 1},
     {'texto': 'C.- Ingresar a la pista designada para el despegue si el control del aeródromo le transmite luz blanca fija.','puntos': 0},
     ]         
  },

{
    'texto': '32.- La competencia del titular de una habilitación IFR se debe demostrar:',
    'explicacion': r'La competencia IFR debe demostrarse dos veces cada 12 meses, con intervalos no mayores a 8 meses ni menores a 4. Fuente: DGAC Chile, DAN 61, revalidación de habilitación IFR.',
    
    'respuestas': [
     {'texto': 'A.- Dos veces cada 12 meses consecutivos, a intervalos no mayores de 8 meses ni menores de 4 meses.','puntos': 1},
     {'texto': 'B.- Si se es piloto de transporte de línea aérea, cada 4 meses.','puntos': 0},
     {'texto': 'C.- Dos veces al año, a intervalos no mayores de cinco meses.','puntos': 0},
     ]         
  },

{
    'texto': '33.- La dirección del viento, excepto para el despegue y el aterrizaje, se proporciona en:',
    'explicacion': r'La clave del banco exige referencia magnética para esta información de viento; operacionalmente se vincula a rumbos y pistas usados por la aeronave. Fuente: DGAC Chile, DAN 91 y procedimientos ATS de información de viento.',
    
    'respuestas': [
     {'texto': 'A.- Grados magnéticos.','puntos': 1},
     {'texto': 'B.- Grados verdaderos.','puntos': 0},
     {'texto': 'C.- Grados verdaderos corregidos por la variación del lugar.','puntos': 0},
     ]         
  },

{
    'texto': '34.- La distancia de aterrizaje requerida en un aeródromo de alternativa, determinada según el manual de vuelo del avión, no excederá del ____ por ciento de la distancia de aterrizaje disponible. Considere que son operaciones de transporte público.',
    'explicacion': r'En transporte público, la distancia de aterrizaje requerida en alternativa no puede exceder el 70% de la distancia disponible. Fuente: DGAC Chile, DAN 121, requisitos de performance de aterrizaje.',
    
    'respuestas': [
     {'texto': 'A.- 50','puntos': 0},
     {'texto': 'B.- 60','puntos': 0},
     {'texto': 'C.- 70','puntos': 1},
     ]         
  },

{
    'texto': '35.- La distancia de despegue disponible se abrevia o identifica como:',
    'explicacion': r'TODA corresponde a Take-Off Distance Available, distancia de despegue disponible. Fuente: OACI Anexo 14 y DGAC Chile, DAN 14, distancias declaradas.',
    
    'respuestas': [
     {'texto': 'A.- TORA.','puntos': 0},
     {'texto': 'B.- TODA.','puntos': 1},
     {'texto': 'C.- DDD.','puntos': 0},
     ]         
  },

{
    'texto': '36.- La exigencia de contar con un sistema de alerta de la proximidad del terreno (GPWS) es aplicable a las aeronaves turborreactores con capacidad superior a:',
    'explicacion': r'La exigencia de GPWS aplica a turborreactores con capacidad superior a 10 asientos de pasajeros. Fuente: DGAC Chile, DAN 121, equipamiento obligatorio GPWS/TAWS.',
    
    'respuestas': [
     {'texto': 'A.- 10 asientos de pasajeros.','puntos': 1},
     {'texto': 'B.- 19 asientos de pasajeros.','puntos': 0},
     {'texto': 'C.- 30 asientos de pasajeros.','puntos': 0},
     ]         
  },

{
    'texto': '37.- La fraseología que debe utilizar un piloto de una aeronave interceptada y que significa “he sido objeto de apoderamiento ilícito”, es:',
    'explicacion': r'HIJAK es la frase codificada para informar apoderamiento ilícito de una aeronave interceptada. Fuente: OACI Anexo 2 y DGAC Chile, DAN 91, señales de interceptación.',
    
    'respuestas': [
     {'texto': 'A.- WILCO.','puntos': 0},
     {'texto': 'B.- HIJAK.','puntos': 1},
     {'texto': 'C.- CAN NOT.','puntos': 0},
     ]         
  },

{
    'texto': '38.- La instrucción que debe cumplir un copiloto (segundo al mando) de un avión determinado para poder desempeñarse como piloto al mando de ese mismo avión, se denomina:',
    'explicacion': r'La instrucción de ascenso de material capacita al segundo al mando para desempeñarse como piloto al mando en ese avión. Fuente: DGAC Chile, DAN 121, programas de instrucción de tripulaciones.',
    
    'respuestas': [
     {'texto': 'A.- Instrucción de diferencia.','puntos': 0},
     {'texto': 'B.- Instrucción de ascenso de material.','puntos': 1},
     {'texto': 'C.- Instrucción periódica.','puntos': 0},
     ]         
  },

{
    'texto': '39.- La instrucción que debe cumplir un tripulante que no ha sido habilitado previamente, ni ha volado otro avión similar del mismo grupo, se denomina:',
    'explicacion': r'La instrucción inicial corresponde al entrenamiento del tripulante sin habilitación previa ni experiencia en avión similar del mismo grupo. Fuente: DGAC Chile, DAN 121, instrucción inicial de tripulantes.',
    
    'respuestas': [
     {'texto': 'A.- Instrucción inicial.','puntos': 1},
     {'texto': 'B.- Instrucción de transición.','puntos': 0},
     {'texto': 'C.- Instrucción de ascenso de material.','puntos': 0},
     ]         
  },

{
    'texto': '40.- La obligación de llevar a bordo chalecos salvavidas para los pasajeros es aplicable a los aviones multimotores cuando vuelan sobre el agua a una distancia de la costa de:',
    'explicacion': r'Los chalecos salvavidas son exigibles en aviones multimotores cuando vuelan sobre agua a más de 50 NM de la costa. Fuente: DGAC Chile, DAN 121, equipo de supervivencia para operaciones sobre agua.',
    
    'respuestas': [
     {'texto': 'A.- Más de 50 millas náuticas.','puntos': 1},
     {'texto': 'B.- Más de 100 millas náuticas.','puntos': 0},
     {'texto': 'C.- Más de 400 millas náuticas.','puntos': 0},
     ]         
  },

{
    'texto': '41.- La parte del aeródromo que se utiliza para el despegue, aterrizaje y rodaje de aeronaves, excluyéndose las plataformas, se denomina:',
    'explicacion': r'El área de maniobras incluye pista y calles usadas para despegue, aterrizaje y rodaje, excluyendo plataformas. Fuente: DGAC Chile, DAR 14, definiciones de aeródromo.',
    
    'respuestas': [
     {'texto': 'A.- Área de movimiento.','puntos': 0},
     {'texto': 'B.- Área de maniobras.','puntos': 1},
     {'texto': 'C.- Área de operaciones aéreas.','puntos': 0},
     ]         
  },

{
    'texto': '42.- La sanción que estipula el Código Aeronáutico para el piloto que se desempeñe en una aeronave con su licencia vencida es de:',
    'explicacion': r'Operar como piloto con licencia vencida constituye infracción sancionada con presidio o reclusión menor o multa. Fuente: Código Aeronáutico de Chile, régimen sancionatorio.',
    
    'respuestas': [
     {'texto': 'A.- Presidio o reclusión menor o multa.','puntos': 1},
     {'texto': 'B.- Presidio o reclusión mayor.','puntos': 0},
     {'texto': 'C.- Suspensión de la licencia hasta por un año.','puntos': 0},
     ]         
  },

{
    'texto': '43.- Las atribuciones y deberes del comandante de una aeronave matriculada en Chile, se regirán por la ley chilena cuando la aeronave se encuentre:',
    'explicacion': r'El comandante de una aeronave chilena se rige por ley chilena en territorio nacional o extranjero respecto de sus atribuciones y deberes. Fuente: Código Aeronáutico de Chile, normas sobre comandante de aeronave.',
    
    'respuestas': [
     {'texto': 'A.- Sobre territorio chileno.','puntos': 0},
     {'texto': 'B.- Sobre territorio y aguas jurisdiccionales chilenas.','puntos': 0},
     {'texto': 'C.- En territorio nacional o extranjero.','puntos': 1},
     ]         
  },

{
    'texto': '44.- La señal radiotelefónica que significa que una aeronave tiene que transmitir un mensaje urgentísimo relativo a la seguridad de personas, aeronaves, barcos u otros vehículos, es:',
    'explicacion': r'PAN PAN identifica una señal de urgencia relacionada con la seguridad de aeronaves, personas o vehículos, sin peligro grave e inminente. Fuente: OACI Anexo 10, Vol. II, comunicaciones aeronáuticas.',
    
    'respuestas': [
     {'texto': 'A.- PAN, PAN.','puntos': 1},
     {'texto': 'B.- MAYDAY.','puntos': 0},
     {'texto': 'C.- SOS.','puntos': 0},
     ]         
  },

{
    'texto': '45.- La visibilidad mínima para autorizar a un avión a efectuar un vuelo VFR especial es de:',
    'explicacion': r'Para autorizar VFR especial, la visibilidad mínima indicada por la reglamentación chilena es 2.000 metros. Fuente: DGAC Chile, DAN 91, vuelos VFR especiales.',
    
    'respuestas': [
     {'texto': 'A.- 1.600 metros.','puntos': 0},
     {'texto': 'B.- 2.000 metros.','puntos': 1},
     {'texto': 'C.- Una milla náutica.','puntos': 0},
     ]         
  },

{
    'texto': '46.- Los mínimos ILS Categoría IIIA son:',
    'explicacion': r'ILS CAT IIIA corresponde a DH inferior a 100 pies y RVR no inferior a 200 m/700 ft. Fuente: OACI Anexo 6 y DGAC Chile, normativa de operaciones CAT II/III.',
    
    'respuestas': [
     {'texto': 'A.- RVR 700 pies (200 mts) y DH inferior a 100 pies.','puntos': 1},
     {'texto': 'B.- RVR no inferior a 50 mts y DH 50 pies o meno.','puntos': 0},
     {'texto': 'C.- RVR 700 pies y DH no inferior a 100 pies.','puntos': 0},
     ]         
  },

{
    'texto': '47.- Los mínimos ILS Categoría II son:',
    'explicacion': r'ILS CAT II considera DH de 100 pies y RVR de 1.200 pies en la clasificación operacional indicada. Fuente: DGAC Chile, normativa CAT II/III y OACI Doc 9365.',
    
    'respuestas': [
     {'texto': 'A.- DH 100 pies y RVR 1.200 pies.','puntos': 1},
     {'texto': 'B.- DH 150 pies y RVR 1.600 pies.','puntos': 0},
     {'texto': 'C.- DH 200 pies y RVR 2.400 pies.','puntos': 0},
     ]         
  },

{
    'texto': '48.- Los mínimos meteorológicos para despegar o aterrizar en un aeródromo en condiciones VFR en Chile son:',
    'explicacion': r'Para operar VFR en aeródromo se exige techo mínimo de 450 m y visibilidad mínima de 5 km. Fuente: DGAC Chile, DAN 91, mínimos meteorológicos VFR.',
    
    'respuestas': [
     {'texto': 'A.- Techo de nubes 500 metros y visibilidad 5 kilómetros.','puntos': 0},
     {'texto': 'B.- Techo de nubes 450 metros y visibilidad 8 kilómetros.','puntos': 0},
     {'texto': 'C.- Techo de nubes 450 metros y visibilidad 5 kilómetros.','puntos': 1},
     ]         
  },

{
    'texto': '49.- Los NOTAM referidos exclusivamente a ciertos aeropuertos y a las operaciones de vuelo IFR desde y hacia esos aeropuertos, se identifican como:',
    'explicacion': r'Los NOTAM Serie A cubren información IFR y aeropuertos relevantes para operaciones desde y hacia dichos aeropuertos. Fuente: DGAC Chile, AIP Chile, sección GEN 3.1/AIS-NOTAM.',
    
    'respuestas': [
     {'texto': 'A.- NOTAM Serie A.','puntos': 1},
     {'texto': 'B.- NOTAM Serie B.','puntos': 0},
     {'texto': 'C.- NOTAM Serie C.','puntos': 0},
     ]         
  },

{
    'texto': '50.- Los NOTAM relacionados con las operaciones de vuelo de los aeródromos y aeropuertos internacionales, se identifican como:',
    'explicacion': r'Los NOTAM Serie A se emplean para información operacional de aeródromos y aeropuertos internacionales. Fuente: DGAC Chile, AIP Chile, servicio de información aeronáutica.',
    
    'respuestas': [
     {'texto': 'A.- NOTAM Serie A.','puntos': 1},
     {'texto': 'B.- NOTAM Serie B.','puntos': 0},
     {'texto': 'C.- NOTAM Serie C.','puntos': 0},
     ]         
  },

{
    'texto': '51.- Para el 1° de agosto se planifica un vuelo que requiere de piloto y copiloto. Ambos pilotos tienen certificado médico extendido el 28 de febrero. Para efectuar este vuelo:',
    'explicacion': r'Para efectuar el vuelo, ambos pilotos deben portar licencia vigente y habilitaciones apropiadas al tipo y función. Fuente: DGAC Chile, DAN 61, atribuciones y validez de licencias.',
    
    'respuestas': [
     {'texto': 'A.- El piloto al mando y el copiloto deben portar su respectiva licencia vigente con las habilitaciones apropiadas al vuelo.','puntos': 1},
     {'texto': 'B.- El piloto al mando si es piloto de transporte de línea aérea, debe obtener un nuevo certificado médico; no así el copiloto si es piloto comercial.','puntos': 0},
     {'texto': 'C.- El piloto al mando y el copiloto deben obtener nuevo certificado médico, o una extensión de este.','puntos': 0},
     ]         
  },

{
    'texto': '52.- Para revalidar la licencia de piloto de transporte de línea aérea se requiere que el piloto demuestre su competencia.',
    'explicacion': r'La revalidación de la licencia ATPL exige demostrar competencia dos veces cada 12 meses consecutivos. Fuente: DGAC Chile, DAN 61, revalidación de licencias de piloto.',
    
    'respuestas': [
     {'texto': 'A.- Una vez cada 12 meses consecutivos.','puntos': 0},
     {'texto': 'B.- Dos veces cada 12 meses consecutivos.','puntos': 1},
     {'texto': 'C.- Una vez cada 8 meses consecutivos.','puntos': 0},
     ]         
  },

{
    'texto': '53.- ¿Qué aeronaves requieren que su piloto sea titular de la correspondiente habilitación de tipo vigente?',
    'explicacion': r'La habilitación de tipo vigente se exige para aeronaves certificadas con tripulación mínima de dos pilotos. Fuente: DGAC Chile, DAN 61, habilitaciones de tipo.',
    
    'respuestas': [
     {'texto': 'A.- Todas las aeronaves certificadas para volar con una tripulación mínima de dos pilotos.','puntos': 1},
     {'texto': 'B.- Todas las aeronaves cuyo peso máximo de despegue sea de 12.500 lbs. o más.','puntos': 0},
     {'texto': 'C.- Todos los multimotores operados comercialmente.','puntos': 0},
     ]         
  },

{
    'texto': '54.- ¿Qué licencia y habilitaciones se requieren para ser piloto al mando de un avión comercial multirreactor pesado certificado para ser volado por un piloto y un copiloto?',
    'explicacion': r'Para actuar como PIC en avión comercial multirreactor pesado se requiere licencia ATPL, habilitación de tipo y habilitación/atribución de piloto al mando. Fuente: DGAC Chile, DAN 61, requisitos de piloto de transporte de línea aérea.',
    
    'respuestas': [
     {'texto': 'A.- Licencia de piloto comercial con habilitación IFR y además la habilitación para el tipo de avión en que se desempeña.','puntos': 0},
     {'texto': 'B.- Licencia de piloto de transporte de línea aérea y habilitación de multimotor.','puntos': 0},
     {'texto': 'C.- Licencia de piloto de transporte de línea aérea, habilitación de tipo del avión en que se desempeña y habilitación de PIC (piloto al mando).','puntos': 1},
     ]         
  },

{
    'texto': '55.- Según el reglamento de operación de aviones de transporte público, las aeronaves deben estar dotadas de un sistema de iluminación para las salidas de emergencia, cuando su capacidad sea:',
    'explicacion': r'El sistema de iluminación de salidas de emergencia se exige en aeronaves de transporte público con capacidad superior a 20 pasajeros. Fuente: DGAC Chile, DAN 121, equipamiento de emergencia de cabina.',
    
    'respuestas': [
     {'texto': 'A.- Superior a 15 pasajeros.','puntos': 0},
     {'texto': 'B.- Superior a 20 pasajeros.','puntos': 1},
     {'texto': 'C.- Superior a 30 pasajeros.','puntos': 0},
     ]         
  },

{
    'texto': '56.- Según la DAN 121, el límite de tiempo de vuelo mensual y anual para un piloto es de:',
    'explicacion': r'La DAN 121 fija límites de 100 horas mensuales y 1.000 horas anuales de vuelo para pilotos. Fuente: DGAC Chile, DAN 121, limitaciones de tiempo de vuelo.',
    
    'respuestas': [
     {'texto': 'A.- 90 y 900 horas respectivamente.','puntos': 0},
     {'texto': 'B.- 100 y 1000 horas respectivamente.','puntos': 1},
     {'texto': 'C.- 120 y 1200 horas respectivamente.','puntos': 0},
     ]         
  },

{
    'texto': '57.- Según la DAN 121, el máximo período de servicio de vuelo nocturno, en 24 horas consecutivas, para una tripulación compuesta por dos pilotos es de:',
    'explicacion': r'Para dos pilotos, el PSV nocturno máximo en 24 horas consecutivas es de 12 horas. Fuente: DGAC Chile, DAN 121, limitaciones de servicio nocturno.',
    
    'respuestas': [
     {'texto': 'A.- 10 horas.','puntos': 0},
     {'texto': 'B.- 12 horas.','puntos': 1},
     {'texto': 'C.- 14 horas.','puntos': 0},
     ]         
  },

{
    'texto': '58.- Según la reglamentación aeronáutica chilena, se requiere de un copiloto....',
    'explicacion': r'Se requiere copiloto cuando el manual de vuelo o certificado de aeronavegabilidad del avión así lo establece. Fuente: DGAC Chile, DAN 91/DAN 121, tripulación mínima requerida.',
    
    'respuestas': [
     {'texto': 'A.- En toda aeronave que transporta 10 pasajeros o más.','puntos': 0},
     {'texto': 'B.- Cuando así lo especifica el manual de vuelo del avión o el certificado de aeronavegabilidad del mismo.','puntos': 1},
     {'texto': 'C.- Cuando se transporta más de 9 pasajeros y el avión no dispone de un piloto automático de tres ejes.','puntos': 0},
     ]         
  },

{
    'texto': '59.- Según lo dispone el reglamento de operación de aviones transporte público, un piloto no deberá desempeñarse al mando de una aeronave en vuelos comerciales, a menos que en los noventa días precedentes haya efectuado en el mismo tipo de avión, como mínimo.',
    'explicacion': r'Para actuar como piloto al mando en vuelos comerciales se exige experiencia reciente mínima de tres despegues y tres aterrizajes en el mismo tipo de avión. Fuente: DGAC Chile, DAN 121, experiencia reciente del piloto al mando.',
    
    'respuestas': [
     {'texto': 'A.- Tres despegues y tres aterrizajes.','puntos': 1},
     {'texto': 'B.- Seis despegues y seis aterrizajes.','puntos': 0},
     {'texto': 'C.- Doce despegues y doce aterrizajes.','puntos': 0},
     ]         
  },

{
    'texto': '60.- Ud. como piloto desea planificar un vuelo no itinerante en que requiere de una exposición meteorológica verbal y/o los documentos pertinentes (cartas de superficie, pronósticos de vientos, etc.). Esto Ud. lo debería notificar a la oficina meteorológica respectiva con una anticipación mínima de:',
    'explicacion': r'Para un vuelo no itinerante que requiere exposición meteorológica, la oficina meteorológica debe ser notificada con al menos seis horas de anticipación. Fuente: DGAC Chile, normativa de servicios meteorológicos aeronáuticos y OACI Anexo 3.',
    
    'respuestas': [
     {'texto': 'A.- Una hora.','puntos': 0},
     {'texto': 'B.- Tres horas.','puntos': 0},
     {'texto': 'C.- Seis horas.','puntos': 1},
     ]         
  },

{
    'texto': '61.- Una aeronave con falla de comunicaciones está arribando a un aeródromo. En vuelo, recibe desde el control del aeródromo una serie de destellos blancos. Ello significa:',
    'explicacion': r'Una serie de destellos blancos a una aeronave en vuelo indica aterrizar en este aeródromo y dirigirse a plataforma. Fuente: DGAC Chile, DAN 91 y OACI Anexo 2, señales luminosas de aeródromo.',
    
    'respuestas': [
     {'texto': 'A.- Puede aterrizar, siempre que lo haga dentro de los 30 minutos siguientes.','puntos': 0},
     {'texto': 'B.- Debe dirigirse a su aeródromo de alternativa.','puntos': 0},
     {'texto': 'C.- Aterrice en este aeródromo y diríjase a la plataforma.','puntos': 1},
     ]         
  },

{
    'texto': '62.- Una tripulación de un vuelo comercial, integrada por un piloto y un copiloto, el máximo tiempo de vuelo reglamentario para esta tripulación es de:',
    'explicacion': r'Para una tripulación comercial de piloto y copiloto, el tiempo máximo de vuelo reglamentario indicado es 7 horas. Fuente: DGAC Chile, DAN 121, limitaciones de tiempo de vuelo.',
    
    'respuestas': [
     {'texto': 'A.- 8 horas.','puntos': 0},
     {'texto': 'B.- 7 horas.','puntos': 1},
     {'texto': 'C.- 6 horas.','puntos': 0},
     ]         
  },

{
    'texto': '63.- Un avión de transporte público con 187 asientos para pasajeros tiene 137 pasajeros a bordo. ¿Cuánto es el mínimo de auxiliares de cabina requeridos por la reglamentación?',
    'explicacion': r'Con 187 asientos instalados, la dotación mínima se calcula por capacidad instalada y corresponde a cuatro auxiliares. Fuente: DGAC Chile, DAN 121, auxiliares de cabina mínimos.',
    
    'respuestas': [
     {'texto': 'A.- Cinco.','puntos': 0},
     {'texto': 'B.- Cuatro.','puntos': 1},
     {'texto': 'C.- Tres.','puntos': 0},
     ]         
  },

{
    'texto': '64.- Un avión de transporte público tiene instalados en la cabina de pasajeros 149 asientos para pasajeros y 8 asientos para tripulantes. ¿Cuánto es el mínimo de auxiliares de cabina requeridos con 97 pasajeros a bordo?',
    'explicacion': r'Con 149 asientos de pasajeros instalados, la dotación mínima requerida es de tres auxiliares de cabina. Fuente: DGAC Chile, DAN 121, dotación mínima de cabina.',
    
    'respuestas': [
     {'texto': 'A.- Cuatro.','puntos': 0},
     {'texto': 'B.- Tres.','puntos': 1},
     {'texto': 'C.- Dos.','puntos': 0},
     ]         
  },

{
    'texto': '65.- Un avión tiene instalados 220 asientos de pasajeros. El número mínimo de extintores que debe llevar a bordo es de:',
    'explicacion': r'Para 220 asientos instalados, el requisito de extintores portátiles de cabina corresponde a cuatro unidades. Fuente: DGAC Chile, DAN 121, extintores portátiles según capacidad de pasajeros.',
    
    'respuestas': [
     {'texto': 'A.- Dos.','puntos': 0},
     {'texto': 'B.- Cuatro.','puntos': 1},
     {'texto': 'C.- Ocho.','puntos': 0},
     ]         
  },

{
    'texto': '66.- Uno de los requisitos para revalidar la licencia de encargados de operaciones de vuelo es haber desempeñado las funciones correspondientes a su licencia durante por lo menos:',
    'explicacion': r'La revalidación de licencia EOV exige haber ejercido funciones por al menos 12 meses en los últimos dos años. Fuente: DGAC Chile, DAN 65, licencia de encargado de operaciones de vuelo.',
    
    'respuestas': [
     {'texto': 'A.- 12 meses en los últimos dos años.','puntos': 1},
     {'texto': 'B.- 6 meses en los últimos dos años.','puntos': 0},
     {'texto': 'C.- 3 meses en los últimos dos años.','puntos': 0},
     ]         
  },

{
    'texto': '67.- Uno de los requisitos que establece la reglamentación para abastecer de combustible un avión con pasajeros a bordo es que:',
    'explicacion': r'El abastecimiento con pasajeros a bordo exige sistema de carguío de combustible a presión y medidas de seguridad específicas. Fuente: DGAC Chile, DAN 121, abastecimiento de combustible con pasajeros a bordo.',
    
    'respuestas': [
     {'texto': 'A.- Se disponga de un sistema a presión para el carguío de combustible.','puntos': 1},
     {'texto': 'B.- Se utilice un sistema de carguío de combustible por gravedad.','puntos': 0},
     {'texto': 'C.- Que toda la tripulación permanezca a bordo del avión y en sus puestos durante el carguío.','puntos': 0},
     ]         
  },

{
    'texto': '68.- Un operador cuyas aeronaves fueron certificadas para operaciones ILS Categoría II obtiene de la DGAC, por primera vez, autorización para este tipo de aproximaciones. Los mínimos que inicialmente se le autorizan son:',
    'explicacion': r'En la primera autorización CAT II, los mínimos iniciales aplicables son DH 150 pies y RVR 1.600 pies. Fuente: DGAC Chile, normativa de autorización ILS CAT II/III.',
    
    'respuestas': [
     {'texto': 'A.- DH 100 pies y RVR 1.200.','puntos': 0},
     {'texto': 'B.- DH 130 pies y RVR 1.400.','puntos': 0},
     {'texto': 'C.- DH 150 pies y RVR 1.600.','puntos': 1},
     ]         
  },

{
    'texto': '69.- Un operador cuyas aeronaves son nuevas y están equipadas de fábrica para efectuar aterrizajes ILS Categoría III, postula por primera vez a la obtención de la autorización para operaciones ILS CAT II. Los mínimos CAT II que se le pueden autorizar inicialmente en Chile, son:',
    'explicacion': r'Para aeronaves nuevas equipadas de fábrica para CAT III, la autorización inicial CAT II puede otorgarse con DH 100 pies y RVR 1.200 pies. Fuente: DGAC Chile, normativa de operaciones ILS CAT II/III.',
    
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
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .timeout(const Duration(seconds: 10));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String userName = prefs.getString('userName') ?? "";
    
    // --- NUEVA LÓGICA: ¿Es la primera vez que abre la app? ---
    bool esPrimeraVez = prefs.getBool('esPrimeraVez') ?? true;

    Widget pantallaInicial;
    if (esPrimeraVez) {
      pantallaInicial = const PantallaPrimeraVez();
    } else if (isLoggedIn) {
      pantallaInicial = WelcomeScreen(nombre: userName);
    } else {
      pantallaInicial = const MiPantallaLogin();
    }

    runApp(QuizApp(startWidget: pantallaInicial));
  } catch (e) {
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Error al iniciar: Verifica tu conexión")),
      ),
    ));
  }
}

class PantallaPrimeraVez extends StatefulWidget {
  const PantallaPrimeraVez({super.key});

  @override
  State<PantallaPrimeraVez> createState() => _PantallaPrimeraVezState();
}

class _PantallaPrimeraVezState extends State<PantallaPrimeraVez> {
  Future<void> _comenzar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('esPrimeraVez', false); // Marcamos que ya entró
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const MiPantallaLogin(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos MediaQuery para que la imagen sea grande pero proporcional
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // CAPA 1: La imagen (Aumenta el 0.7 para hacerla más grande)
          Positioned(
            top: -300,
            left: 0,
            right: 0,
            height: screenHeight * 1.4, 
            child: Image.asset(
              'assets/imagen_bienvenida.png',
              filterQuality: FilterQuality.high, // Mantenemos tu asset
              fit: BoxFit.contain,
            ),
          ),

          // CAPA 2: El texto y botón (Fijos abajo)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                const Text(
                  "Bienvenido a la APP EOV", // Tu frase
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Una herramienta creada para acompañarte en cada etapa de tu formación como EOV.", // Tu frase motivadora
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _comenzar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0091D5),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Comenzar", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
      home: startWidget, 
    );
  }
}

// 2. PANTALLA DE BIENVENIDA (ESTILO WINDOWS)

String formatearNombreDesdeCorreo(String correo) {
  // 1. Obtener la parte antes del primer punto o la arroba
  String partePrincipal = correo.split('.').first;
  
  // 2. Por si el correo no tiene punto (ej: usuario@gmail.com)
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
  
  Future<void> _validarYContinuar() async {
    try {
      // Buscamos al usuario en Firebase por el nombre que quedó guardado
      var query = await FirebaseFirestore.instance
          .collection("Códigos_válidos")
          .where("quien entro", isEqualTo: widget.nombre)
          .get();

      if (query.docs.isNotEmpty) {
        bool estaHabilitado = query.docs.first.data()['habilitado'] ?? true;

        // Si lo bloqueaste en Firebase, le borramos la sesión y lo expulsamos
        if (!estaHabilitado) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);
          await prefs.remove('userName');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Tu acceso ha sido revocado. Comunícate con la administración."),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MiPantallaLogin()),
            );
          }
          return; // Detenemos la función para que no avance al MainMenu
        }
      }
    } catch (e) {
      // Si no hay internet, ignoramos el error para no dejar la app pegada.
    }

    // Si está habilitado (o falló la red), lo dejamos pasar al menú principal
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()), 
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), 
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn), 
    );
    
    // Cuando termine tu animación de 3 segundos, validamos en Firebase
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _validarYContinuar();
      }
    });
    
    _controller.forward();
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
Future<void> cerrarSesion(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // 1. Obtener el ID del dispositivo actual para removerlo de Firebase
  String? deviceId = prefs.getString('device_local_id');
  String? userName = prefs.getString('userName');

  if (deviceId != null && userName != null) {
    try {
      // 2. Buscar el documento del usuario para remover el dispositivo
      var query = await FirebaseFirestore.instance
          .collection("Códigos_válidos")
          .where("quien entro", isEqualTo: userName)
          .get();

      if (query.docs.isNotEmpty) {
        var docRef = query.docs.first.reference;
        List<dynamic> dispositivos = List.from(query.docs.first.data()['dispositivos_activos'] ?? []);
        
        // 3. Remover el ID del dispositivo
        dispositivos.remove(deviceId);
        
        // 4. Actualizar Firebase
        await docRef.update({
          'dispositivos_activos': dispositivos,
          // Si ya no quedan dispositivos, puedes marcar en_uso como false
          'en_uso': dispositivos.isNotEmpty, 
        });
      }
    } catch (e) {
      print("Error al limpiar dispositivo en Firebase: $e");
    }
  }

  // 5. Limpiar localmente
  await prefs.clear();
  
  // 6. Redirigir al Login
  if (context.mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MiPantallaLogin()),
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
  
  Future<Map<String, String>> _obtenerInfoDispositivo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_local_id');
    if (deviceId == null) {
      deviceId = "disp_${DateTime.now().millisecondsSinceEpoch}";
      await prefs.setString('device_local_id', deviceId);
    }

    String deviceName = "Dispositivo Desconocido";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    
    try {
      if (kIsWeb) {
        WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
        deviceName = "Web - ${webInfo.browserName.name}"; 
      } else {
        if (defaultTargetPlatform == TargetPlatform.android) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceName = "Android - ${androidInfo.model}";
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceName = "iOS - ${iosInfo.name}";
        } else if (defaultTargetPlatform == TargetPlatform.windows) {
          WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
          deviceName = "Windows - ${windowsInfo.computerName}";
        }
      }
    } catch (e) {
      deviceName = "Dispositivo Genérico";
    }

    return {'id': deviceId, 'nombre': deviceName};
  }
  
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
    Map<String, String> infoDisp = await _obtenerInfoDispositivo();
    String miIdDispositivo = infoDisp['id']!;
    String miNombreDispositivo = infoDisp['nombre']!;

    var docSnap = await FirebaseFirestore.instance
        .collection("Códigos_válidos")
        .doc(codigo)
        .get()
        .timeout(const Duration(seconds: 10));

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;

      // --- 1. VERIFICACIÓN DE REVOCACIÓN ---
      bool estaHabilitado = data['habilitado'] ?? true;
      if (!estaHabilitado) {
        throw ("Tu acceso ha sido revocado. Comunícate con la administración.");
      }

      bool enUso = data['en_uso'] ?? false;
      String? usuarioAsignado = data['quien entro'];
      List<dynamic> dispositivosActivos = List.from(data['dispositivos_activos'] ?? []);

      if (enUso && usuarioAsignado != nombre) {
        throw ("Este código ya está vinculado a otro usuario.");
      }

      // --- 2. LÍMITE DE DISPOSITIVOS ---
      if (!dispositivosActivos.contains(miIdDispositivo)) {
        if (dispositivosActivos.length >= 2) {
          if (usuarioAsignado == nombre) {
            dispositivosActivos.removeAt(0); // Liberar espacio para el dueño
          } else {
            throw ("Has iniciado sesión en demasiados dispositivos. Límite máximo: 2.");
          }
        }
        dispositivosActivos.add(miIdDispositivo);
      }

      // --- 3. VERIFICACIÓN DE OTROS CÓDIGOS ---
      var usuarioQuery = await FirebaseFirestore.instance
          .collection("Códigos_válidos")
          .where("quien entro", isEqualTo: nombre)
          .get();

      if (usuarioQuery.docs.isNotEmpty) {
        if (usuarioQuery.docs.first.id != codigo) {
          throw ("Ya tienes un código asignado. Debes usar el código original.");
        }
      }

      // --- 4. ACTUALIZACIÓN EN FIREBASE ---
      await docSnap.reference.update({
        'en_uso': true,
        'quien entro': nombre,
        'fecha_uso': FieldValue.serverTimestamp(),
        'dispositivos_activos': dispositivosActivos,
        'ultimo_dispositivo_usado': miNombreDispositivo,
      });

      // --- 5. NAVEGACIÓN Y SESIÓN ---
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
          MaterialPageRoute(builder: (context) => WelcomeScreen(nombre: nombre)),
        );
      }
    } else {
      throw ("El código no existe.");
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  } finally {
    if (mounted) setState(() => _cargando = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1128), // Fondo azul oscuro
      body: Stack(
        children: [
          // 1. LOGO: Independiente, sin empujar al login
          Positioned(
            top: 70, // Ajusta este valor para subir/bajar el logo
            left: 0,
            right: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 2000), // 1 segundo para una entrada suave
              curve: Curves.easeOutQuad,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value, // Aparece de transparente a visible
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)), // Se desliza 20px hacia arriba mientras aparece
                    child: child,
                  ),
                );
              },
            child: Center( // Usamos Center para que el contenedor se ajuste al contenido
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25), // Bordes redondeados para el efecto
                child: BackdropFilter(
                  
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Desenfoca lo que está detrás
                  child: Container(
                    width: 360, 
                    height: 120,
                    
                    padding: const EdgeInsets.all(20), // Espacio entre el logo y el borde
                    decoration: BoxDecoration(
  
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color.fromARGB(255, 219, 178, 42).withOpacity(0.2), // Luz brillante arriba a la izquierda
                          const Color.fromARGB(255, 40, 85, 87).withOpacity(0.05), // Sombra suave abajo a la derecha
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      // 2. Borde con un poco más de fuerza para que resalte
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4), 
                        width: 1.5,
                      ),
                      // 3. EFECTO DE LUZ NOCTURNA (Glow)
                      // Esto proyecta una luz difusa detrás del logo, creando el efecto de "luz en la noche"
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3), // Color azul para esa vibra nocturna
                          blurRadius: 30, // Qué tan extendida es la luz
                          spreadRadius: 5, // Qué tan lejos llega el resplandor
                          offset: const Offset(0, 0), // Centrado para que la luz sea uniforme
                        ),
                      ],
                    ),
            child: Image.asset(
              'assets/PRECADET_LOGO.png',
              height: 100,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
                ),
                ),
                ),
                ),
                
          ),
          // 2. LOGIN: El bloque de cristal
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 50.0, end: 0.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(
                  opacity: 1 - (value / 50),
                  child: child,
                ),
              );
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- AJUSTA ESTE VALOR PARA SUBIR O BAJAR ---
                    // Un valor más bajo (ej. 200) acercará el login al logo
                    const SizedBox(height:280), 
                    
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: 400,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 30),
                              _buildTextField(
                                controller: _nombreController,
                                hint: "Tu correo institucional",
                                icon: Icons.mail_outline,
                                isEmail: true,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _codigoController,
                                hint: "Código",
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Theme(
                                    data: ThemeData(unselectedWidgetColor: Colors.white70),
                                    child: Checkbox(
                                      value: _recordarme,
                                      activeColor: const Color(0xFF0091D5),
                                      onChanged: (val) {
                                        setState(() => _recordarme = val ?? false);
                                      },
                                    ),
                                  ),
                                  const Text("Recuérdame", style: TextStyle(color: Colors.white70)),
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
                                    elevation: 10,
                                    shadowColor: const Color(0xFF0091D5).withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: _cargando
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
    bool isEmail = false,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Fondo sutil del input
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              style: const TextStyle(color: Colors.white), // Texto escrito en blanco
              keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
              textCapitalization: isEmail ? TextCapitalization.none : TextCapitalization.sentences,
              inputFormatters: isEmail 
              ? [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    return newValue.copyWith(text: newValue.text.toLowerCase());
                  }),
                ] 
              : null,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.white38),
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
    // Al estar en la carpeta 'web', la ruta es relativa a la raíz del sitio.
    // Si lo pusiste en 'web/Instructivo.pdf':
    final url = Uri.base.resolve('Instructivo.pdf'); 
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: '_blank');
    } else {
      throw 'No se pudo abrir el PDF';
    }
  } else {
      // Lógica para Móvil (Android/iOS)
      final assetPath = 'assets/Instructivo.pdf';
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/Instructivo.pdf');
      
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
      
      final result = await OpenFilex.open(file.path);
      
      if (result.type != ResultType.done) {
        throw 'No se pudo abrir el archivo: ${result.message}';
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
          onPressed: () {
            // ¡AQUÍ ESTÁ EL CAMBIO!
            // Ya no usamos launchUrl, llamamos a TU función:
            _abrirPdf(context); 
          },
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Abrir PDF"),
        ),
      ),
    );
  }
}

// 4. MENÚ PRINCIPAL 
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
              //Cuadro "Ver Instructivo" agregado arriba de las materias
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // Lógica responsiva: Si la pantalla es más ancha que 600px (PC), usa 4 columnas. Si no (Celular), usa 2.
                    crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
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
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  bool esEscritorio = constraints.maxWidth > 600;
                                  double escala = esEscritorio ? 1.0 : 1.35;
                                  return Transform.scale(
                                    scale: escala,
                                    child: Image.asset(
                                      materia["Imagen"].toString(),
                                      cacheWidth: 400,
                                      filterQuality: FilterQuality.high,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                    )
                                  );
                                }
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
      return limpio;
    }
    return "Pregunta ${indice + 1}: $limpio";
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
        respondido = false;
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
                    physics: _scrollBloqueado 
                    ? const NeverScrollableScrollPhysics() 
                    : const AlwaysScrollableScrollPhysics(),
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

  // Menú horizontal superior deslizable de números
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
                boxShadow: esActual ? [const BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))] : null,
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
  bool _scrollBloqueado = false;  
  // Renderiza el contenido específico de cada pregunta dentro del PageView
  // Renderiza el contenido específico de cada pregunta dentro del PageView
  Widget buildQuizPageContent(int index) {
    final pregunta = preguntas[index];
    final respuestas = List<Map<String, dynamic>>.from(pregunta['respuestas'] as List);
    final bool haRespondidoEstaPagina = respuestasUsuario[index] != null;
    final bool mostrarSolucion = haRespondidoEstaPagina && !widget.isTestMode;
    final int? seleccionGuardada = respuestasUsuario[index];
    
    return SingleChildScrollView(
      // ¡AQUÍ ESTÁ EL CAMBIO! Bloquea el scroll vertical (arriba/abajo) cuando el zoom está activo
      physics: _scrollBloqueado 
          ? const NeverScrollableScrollPhysics() 
          : const AlwaysScrollableScrollPhysics(),
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
            elevation: 10,
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
          const SizedBox(height: 20),
          
          // Carga de imágenes corregida con su ZoomableImage
          if (pregunta.containsKey('imagenes'))
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: (pregunta['imagenes'] as List<String>).map((ruta) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: ZoomableImage(
                      imagePath: ruta,
                      onZoomChanged: (estaHabilitado) {
                        setState(() {
                          _scrollBloqueado = estaHabilitado;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

          ...List.generate(respuestas.length, (idxRes) => buildBotonRespuesta(idxRes, respuestas[idxRes], mostrarSolucion, seleccionGuardada)),
          
          if (mostrarSolucion)
            KeyedSubtree(
              key: ValueKey("explicacion_$index"),
              child: buildExplicacion(pregunta['explicacion'] ?? ""),
            ),
        ],
      ),
    );
  }

  Widget buildBotonRespuesta(int index, Map<String, dynamic> res, bool mostrarSolucion, int? seleccionGuardada) {
    bool esCorrecta = res['puntos'] == 1;
    bool seleccionada = (seleccionGuardada == index);
    bool debeMostrarColores = mostrarSolucion;
    Color colorBorde = Colors.grey.shade200;
    Color colorFondo = Colors.white;
    Color colorTexto = Colors.black87;

    if (!widget.isTestMode && debeMostrarColores) {
      if (esCorrecta) {
        colorBorde = Colors.green;
        colorFondo = Colors.green.shade50;
        colorTexto = Colors.green.shade900;
      } else if (seleccionada) {
        colorBorde = Colors.red;
        colorFondo = Colors.red.shade50;
        colorTexto = Colors.red.shade900;
      }
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
            : (seleccionada && !widget.isTestMode && mostrarSolucion ? const Icon(Icons.cancel, color: Colors.red) : null),
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

  // INTERFAZ MODERNA Y ATRACTIVA DE NAVEGACIÓN
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
            
            // Spacer empuja los botones hacia los extremos de forma fluida
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


class ZoomableImage extends StatefulWidget {
  final String imagePath;
  final Function(bool) onZoomChanged;

  const ZoomableImage({
    super.key, 
    required this.imagePath, 
    required this.onZoomChanged
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  final TransformationController _transformationController = TransformationController();
  bool _zoomHabilitado = false;
  

  @override
  Widget build(BuildContext context) {
    // Al quitar el Container de altura fija, el Stack se adapta al tamaño de la imagen
    return Stack(
      alignment: Alignment.topRight, // Esto ancla el botón a la esquina superior derecha
      children: [
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              _zoomHabilitado = !_zoomHabilitado;
              widget.onZoomChanged(_zoomHabilitado);
              
              if (!_zoomHabilitado) {
                _transformationController.value = Matrix4.identity();
              }
            });
          },
          child: InteractiveViewer(
            transformationController: _zoomHabilitado ? _transformationController : null,
            // AQUÍ ESTÁ LA MAGIA: Solo se mueve y hace zoom si está habilitado
            panEnabled: _zoomHabilitado, 
            scaleEnabled: _zoomHabilitado,
            minScale: 1.0,
            maxScale: 3.0,
            child: Image.asset(widget.imagePath, fit: BoxFit.contain),
          ),
        ),
        
        // Etiqueta informativa pegada a la imagen
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () { 
              setState(() {
                _zoomHabilitado = false;
                widget.onZoomChanged(false);
                _transformationController.value = Matrix4.identity();
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _zoomHabilitado ? Colors.red.withOpacity(0.8) : Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _zoomHabilitado ? "Presione para desactivar" : "Doble click para zoom",
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}