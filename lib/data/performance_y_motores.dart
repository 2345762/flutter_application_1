// =============================================================
// QUESTION POOL: PERFORMANCE Y MOTORES
// Questions related to aircraft performance and engines
// =============================================================

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
        'explicacion': 'El vapor de agua es más liviano (menos denso) que el aire seco. Por lo tanto, a mayor humedad relativa, menor es la densidad del aire. Esto significa que hay menos moléculas de oxígeno disponibles por cada volumen de aire que ingresa al motor.',
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
