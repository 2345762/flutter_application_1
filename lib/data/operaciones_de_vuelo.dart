// =============================================================
// QUESTION POOL: OPERACIONES DE VUELO
// Questions related to flight operations and procedures
// =============================================================

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
  "imagenes": ["assets/figura31.jpeg"],
  "respuestas": [
    {"texto": "A.- Radar y VOR/DME.", "puntos": 0},
    {"texto": "B.- VOR/DME y ADF.", "puntos": 1},
    {"texto": "C.- LORAN o VOR/DME y ADF.", "puntos": 0}
  ]
},
{
  "texto": "32.- ¿Cómo se identifica el FAF en la aproximación VOR/DME a la pista 01 de Antofagasta?",
  "explicacion": "El FAF está definido por la intersección de 5 DME con el radial 187 del VOR FAG. Fuente: DGAC Chile, AIP Chile Vol. II MAP, carta VOR/DME RWY 01 Antofagasta.",
  "imagenes": ["assets/figura32.jpeg"],
  "respuestas": [
    {"texto": "A.- 5 DME/Radial 007 del VOR FAG.", "puntos": 0},
    {"texto": "B.- 5 DME/Radial 187 del VOR FAG.", "puntos": 1},
    {"texto": "C.- 1.700 pies en el altímetro y 5 DME del VOR FAG.", "puntos": 0}
  ]
},
{
  "texto": "33.- ¿Cuál es el procedimiento para iniciar la aproximación frustrada en el descenso VOR a pista 17 de Puerto Montt?",
  "explicacion": "La frustrada publicada exige ascender a 3.000 ft en el curso 168 del VOR MON y regresar con viraje derecho a la espera. Fuente: DGAC Chile, AIP Chile Vol. II MAP, carta VOR Puerto Montt.",
  "imagenes": ["assets/figura34.jpeg"],
  "respuestas": [
    {"texto": "A.- Ascender a 3000 pies en el curso 168 del VOR MON regresando con viraje a la derecha e ingresando a circuito de espera.", "puntos": 1},
    {"texto": "B.- Ascender a 3000 pies en rumbo 168 con virajes a la izquierda.", "puntos": 0},
    {"texto": "C.- Ascender a 3000 pies en rumbo 168 e ingresar a espera al sur.", "puntos": 0}
  ]
},
{
  "texto": "34.- Ud. desea considerar Iquique como alternativa para Antofagasta. ¿Qué pronóstico meteorológico mínimo debe tener Iquique?",
  "explicacion": "La alternativa debe cumplir 800 ft/3,2 km para no precisión y 600 ft/3,0 km para precisión, según mínimos publicados. Fuente: DGAC Chile, AIP Chile Vol. II MAP y criterios de alternativa IFR.",
  "imagenes": ["assets/figura35.jpeg", "assets/figura36.jpeg", "assets/figura37.png"],
  "respuestas": [
    {"texto": "A.- 800 pies con 3.2 Km y 700 pies con 1,6 Km.", "puntos": 0},
    {"texto": "B.- 800 pies/3.2 Km (no precisión) y 600 pies/3.0 Km (precisión).", "puntos": 1},
    {"texto": "C.- 800 pies de techo y 3.2 Km. para todas las aproximaciones.", "puntos": 0}
  ]
},
{
  "texto": "35.- Un avión bimotor en Concepción sin alternativa a menos de una hora y con ILS inoperativo, los mínimos de despegue son:",
  "explicacion": "Al no cumplir condiciones para reducir mínimos, aplica el mínimo estándar de despegue para bimotor: 1,6 km. Fuente: DGAC Chile, mínimos de utilización de aeródromo y AIP Chile Vol. II MAP.",
  "imagenes": ["assets/figura38.jpeg"],
  "respuestas": [
    {"texto": "A.- 0.8 km. de visibilidad.", "puntos": 0},
    {"texto": "B.- 1,6 km. de visibilidad.", "puntos": 1},
    {"texto": "C.- 1.2 km. de visibilidad.", "puntos": 0}
  ]
},
{
  "texto": "36.- Para efectuar una aproximación VOR/DME en Concepción, además del equipo VOR/DME operativo, el avión deberá disponer de:",
  "explicacion": "Además de la navegación VOR/DME, la comunicación VHF es necesaria para coordinación ATS y cumplimiento del procedimiento. Fuente: DGAC Chile, AIP Chile Vol. II MAP, carta VOR/DME Concepción.",
  "imagenes": ["assets/figura38.jpeg"],
  "respuestas": [
    {"texto": "A.- Equipo de comunicación VHF.", "puntos": 1},
    {"texto": "B.- Sistema de alerta de altitud.", "puntos": 0},
    {"texto": "C.- Un VOR/DME tipo standby y equipo de comunicaciones VHF.", "puntos": 0}
  ]
},
{
  "texto": "37.- Indique qué sistema de iluminación tiene la pista 35 del aeropuerto de Puerto Montt.",
  "explicacion": "La pista 35 dispone de HIRL, luces de identificación de umbral, PAPI y sistema de aproximación con destellos, según carta de aeródromo. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Puerto Montt.",
  "imagenes": ["assets/figura94.jpeg"],
  "respuestas": [
    {"texto": "A.- Luces de pista de alta intensidad, PAPI y luces de aproximación.", "puntos": 0},
    {"texto": "B.- Luces de pista de alta intensidad, identificación de umbral, PAPI y aproximación con destello.", "puntos": 1},
    {"texto": "C.- Luces de pista de alta intensidad, PAPI, destello de umbral y centro de pista.", "puntos": 0}
  ]
},
{
  "texto": "38.- La altitud mínima (MDA) en el descenso VOR/DME a la pista 19 del aeropuerto de Antofagasta es:",
  "explicacion": "La MDA publicada para el procedimiento VOR/DME RWY 19 Antofagasta corresponde a 1.240 ft. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Antofagasta.",
  "imagenes": ["assets/figura29.jpeg"],
  "respuestas": [
    {"texto": "A.- 1240 pies.", "puntos": 1},
    {"texto": "B.- 1240' (800').", "puntos": 0},
    {"texto": "C.- 785 pies.", "puntos": 0}
  ]
},
{
  "texto": "39.- La altitud mínima de recepción en la aerovía V/W 200 entre CLD y ΤΟΥ es:",
  "explicacion": "La altitud mínima de recepción publicada para ese tramo de la aerovía es FL110. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 3, rutas ATS.",
  "imagenes": ["assets/figura96.jpeg"],
  "respuestas": [
    {"texto": "A.- FL 80", "puntos": 0},
    {"texto": "B.- FL 10", "puntos": 0},
    {"texto": "C.- FL 110", "puntos": 1}
  ]
},
{
  "texto": "40.- ¿Cuál es la distancia entre Trapén y la pista para una aproximación ILS a pista 35 en Puerto Montt?",
  "explicacion": "La carta ILS RWY 35 de Puerto Montt publica 3,9 NM entre Trapén y la pista. Fuente: DGAC Chile, AIP Chile Vol. II MAP, ILS RWY 35 Puerto Montt.",
  "imagenes": ["assets/figura97.jpeg"],
  "respuestas": [
    {"texto": "A.- 5.7 millas náuticas.", "puntos": 0},
    {"texto": "B.- 4.5 millas náuticas.", "puntos": 0},
    {"texto": "C.- 3.9 millas náuticas.", "puntos": 1}
  ]
},
{
  "texto": "41.- Procediendo vía STAR TILGO 3 hacia La Serena, ¿cuál es la mínima altitud autorizada para cruzar BARCA?",
  "explicacion": "La STAR TILGO 3 establece 5.000 ft como altitud mínima de cruce en BARCA. Fuente: DGAC Chile, AIP Chile Vol. II MAP, STAR La Serena.",
  "imagenes": ["assets/figura98.jpeg"],
  "respuestas": [
    {"texto": "A.- 3.000 pies.", "puntos": 0},
    {"texto": "B.- 5.000 pies.", "puntos": 1},
    {"texto": "C.- 7.000 pies.", "puntos": 0}
  ]
},
{
  "texto": "42.- ¿Cuál es el largo de pista disponible para aterrizar en la pista 07 del aeropuerto de Punta Arenas?",
  "explicacion": "La longitud disponible de aterrizaje publicada para la pista 07 es 2.790 m. Fuente: DGAC Chile, AIP Chile Vol. II MAP, AD Punta Arenas.",
  "imagenes": ["assets/figura99.jpeg"],
  "respuestas": [
    {"texto": "A.- 3.030 metros.", "puntos": 0},
    {"texto": "B.- 3.090 metros.", "puntos": 0},
    {"texto": "C.- 2.790 metros.", "puntos": 1}
  ]
},
{
  "texto": "43.- Saliendo de Tobalaba vía SID PARKE 1, ¿cuál es la distancia a recorrer desde ese aeródromo hasta el VOR SCL?",
  "explicacion": "La SID PARKE 1 publica 11 NM desde Tobalaba hasta el VOR SCL. Fuente: DGAC Chile, AIP Chile Vol. II MAP, SID PARKE 1.",
  "imagenes": ["assets/figura100.jpeg"],
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
  "imagenes": ["assets/figura101.png"],
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
  "imagenes": ["assets/figura101.png"],
  "respuestas": [
    {"texto": "A.- 180", "puntos": 0},
    {"texto": "B.- 60", "puntos": 1},
    {"texto": "C.- 5,5", "puntos": 0}
  ]
},
{
  "texto": "48.- ¿Qué significa el símbolo representado por una P dentro de un círculo en una carta de aeropuerto?",
  "explicacion": "El símbolo P dentro de un círculo identifica una zona prohibida. Fuente: DGAC Chile, AIP Chile Vol. I, GEN 2.3, símbolos cartográficos.",
  "imagenes": ["assets/figura102.jpeg"],
  "respuestas": [
    {"texto": "A.- Zona Prohibida.", "puntos": 0},
    {"texto": "B.- Zona de Espera.", "puntos": 0},
    {"texto": "C.- PAPI en uso.", "puntos": 1}
  ]
},
{
  "texto": "49.- El nivel máximo permitido en la aerovía UG-551 es:",
  "explicacion": "La aerovía UG-551 pertenece a la red superior y su nivel máximo publicado es FL450. Fuente: DGAC Chile, AIP Chile Vol. I, ENR 3, rutas ATS.",
  "imagenes": ["assets/figura101.png"],
  "respuestas": [
    {"texto": "A.- 150", "puntos": 0},
    {"texto": "B.- 450", "puntos": 1},
    {"texto": "C.- El nivel máximo no está limitado.", "puntos": 0}
  ]
},
{
  "texto": "50.- Ud. Se encuentra volando en el sector Norte del Área Terminal Santiago, ¿cuál es la frecuencia para comunicarse con el Centro de Control?",
  "explicacion": "La frecuencia publicada para el sector Norte del área terminal Santiago es 126.3 MHz. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Carta de Área Santiago.",
  "imagenes": ["assets/figura101.png"],
  "respuestas": [
    {"texto": "A.- 128.1", "puntos": 0},
    {"texto": "B.- 126.3", "puntos": 1},
    {"texto": "C.- 127.0", "puntos": 0}
  ]
},
{
  "texto": "51.- Las frecuencias de control de Santiago Radio están divididas en sector Norte y sector Sur. Esta delimitación se encuentra ubicada en:",
  "explicacion": "La división Norte/Sur publicada para Santiago Radio se ubica en la latitud 33°23’ S. Fuente: DGAC Chile, AIP Chile Vol. II MAP, Carta de Área Santiago.",
  "imagenes": ["assets/figura101.png"],
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
  "imagenes": ["assets/figura101.png"],
  "respuestas": [
    {"texto": "A.- Un punto de notificación cuando se está siendo dirigido por radar.", "puntos": 0},
    {"texto": "B.- Un punto de notificación obligatorio.", "puntos": 0},
    {"texto": "C.- Un punto de notificación no obligatorio.", "puntos": 1}
  ]
},
{
  "texto": "54.- Una aeronave es autorizada para efectuar la STAR DIMAR-2 al aeropuerto Diego Aracena de Iquique, instruyéndosele que reporte la posición VAROK. Esta posición está determinada por:",
  "explicacion": "VAROK se define por 38 DME y radial 190 del VOR IQQ. Fuente: DGAC Chile, AIP Chile Vol. II MAP, STAR DIMAR-2 Iquique.",
  "imagenes": ["assets/figura104.jpeg"],
  "respuestas": [
    {"texto": "A.- 38 MN DME del VOR IQQ.", "puntos": 0},
    {"texto": "B.- 38 MN DME del VOR IQQ y radial 010 del mismo VOR.", "puntos": 0},
    {"texto": "C.- 38 MN DME y radial 190 del VOR IQQ.", "puntos": 1}
  ]
},
{
  "texto": "55.- La elevación y largo de pista del aeródromo de Los Ángeles son:",
  "explicacion": "La información publicada del aeródromo indica elevación 374 ft y pista de 1.700 m. Fuente: DGAC Chile, AIP Chile, AD Los Ángeles.",
  "imagenes": ["assets/figura108.jpeg"],
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
  "imagenes": ["assets/figura108.jpeg"],
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
  "imagenes": ["assets/figura29.jpeg"],
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
  "imagenes": ["assets/figura107.jpeg"],
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
  "imagenes": ["assets/figura110.jpeg"],
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
