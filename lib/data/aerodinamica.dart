// =============================================================
// QUESTION POOL: AERODINÁMICA
// Questions related to aerodynamics, flight controls, and performance
// =============================================================

final List<Map<String, Object>> poolAerodinamica = [
   {
    'texto': '1.- Si el ángulo de ataque constante y la velocidad sube al doble, la sustentación será:',
    'explicacion': r"La sustentación varía con el cuadrado de la velocidad; si la velocidad se duplica y se mantienen constantes densidad, superficie y CL, la sustentación se cuadruplica. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    'respuestas': [
      {'texto': 'A.- La misma', 'puntos': 0},
      {'texto': 'B.- Dos veces mayor', 'puntos': 0},
      {'texto': 'C.- Cuatro veces mayor', 'puntos': 1},
    ],
  },
  {
    'texto': '2.- ¿Qué velocidad aérea verdadera y ángulo de ataque debiera usarse para generar la misma cantidad de sustentación a medida que aumenta la altitud?',
    'explicacion': r"Al aumentar la altitud disminuye la densidad; para mantener la misma sustentación a igual ángulo de ataque se requiere mayor velocidad aérea verdadera. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- La misma velocidad aérea verdadera y ángulo de ataque', 'puntos': 0},
     {'texto': 'B.- Una velocidad aérea verdadera mayor para cualquier ángulo de ataque dado', 'puntos': 1},
     {'texto': 'C.- Una velocidad aérea verdadera menor y un ángulo de ataque mayor.', 'puntos': 0},
      ]  
  },
  {
    'texto': '3.- ¿Qué factores afectan a la velocidad indicada de pérdida de sustentación, (stall)?',
    'explicacion': r"La alternativa marcada no responde técnicamente a la pregunta: la velocidad indicada de stall depende principalmente de peso, factor de carga y potencia/configuración. Revisar clave de respuesta. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 5.",
    
    'respuestas': [
     {'texto': 'A.- Peso, factor de carga y potencia. ', 'puntos': 0},
     {'texto': 'B.- Una velocidad aérea verdadera mayor para cualquier ángulo de ataque dado', 'puntos': 1},
     {'texto': 'C.- Una velocidad aérea verdadera menor y un ángulo de ataque mayor.', 'puntos': 0},
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
    'texto': '10.- ¿Cuál es el motor "crítico" en un avión bimotor?',
    'explicacion': r'El motor crítico es aquel cuya falla produce el efecto más adverso en el control y performance; en bimotores convencionales suele ser el motor con menor brazo efectivo de empuje respecto del eje longitudinal. Fuente: FAA, Airplane Flying Handbook, FAA-H-8083-3C, cap. 13.',
    
    'respuestas': [
     {'texto': 'A.- Aquél con el eje de empuje o tracción más cercano al eje longitudinal del avión.','puntos': 1},
     {'texto': 'B.- La altitud y velocidad deben ser considerablemente mayores que las normales a lo largo de la aproximación. ,','puntos': 0},
     {'texto': 'C.- Aquél con el eje de empuje o tracción más alejado del eje longitudinal del avión.','puntos': 0},
     ]         
  },
  {
    'texto': '11.- ¿Bajo qué condición nunca debería practicarse "stalls" en un avión bimotor?',
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
    'texto': '31.- ¿En qué dirección, respecto de la superficie de control primario, se mueve el "anti-servo tab"?',
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
    'texto': '33.- ¿Cuál es el propósito de los "slats" de borde de ataque en alas de alta performance?',
    'explicacion': r"Los slats canalizan aire de alta presión desde el intradós hacia el extradós, manteniendo el flujo adherido y retrasando el stall. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Disminuir la sustentación a velocidades relativamente bajas.','puntos': 0},
     {'texto': 'B.- Mejorar el control de alerones a bajos ángulos de ataque.','puntos': 0},
     {'texto': 'C.- Dirigir el aire desde el área de alta presión bajo el borde de ataque hacia la parte superior del ala.','puntos': 1},
     ]         
  },
{
    'texto': '34.- ¿Qué efecto tienen los "slots" de borde de ataque del ala en la performance del avión?',
    'explicacion': r"Los slots retrasan la separación del flujo y permiten alcanzar un ángulo de ataque de stall más alto. Fuente: FAA, Pilot's Handbook of Aeronautical Knowledge, FAA-H-8083-25C, cap. 6.",
    
    'respuestas': [
     {'texto': 'A.- Disminuye la resistencia del perfil.','puntos': 0},
     {'texto': 'B.- Cambia el ángulo de ataque de "stall" a un ángulo más alto.','puntos': 1},
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
    'texto': '39.- El techo de sustentación es la altitud a la que se alcanza el llamado "coffin corner" y es función de:',
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
    'texto': '65.- Se estima que un avión ha alcanzado su "techo de servicio" cuando su máxima razón de ascenso no es mayor de:',
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
    'texto': '68.- El aviso de pérdida (stall) conocido como "stick shaker", ocurre aproximadamente:',
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
