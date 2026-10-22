import '../models/word_entry.dart';

/// Diccionario local de jergas peruanas de 5 letras.
///
/// La lista es estática y local (sin backend): el mismo orden para todos los
/// usuarios garantiza que la *palabra del día* sea idéntica en cada
/// dispositivo (índice = días transcurridos % longitud de la lista).
///
/// Los términos proceden del uso real limeño (jerga juvenil, peruanos
/// registrados por la Academia Peruana de la Lengua en DiPerú y el
/// diccionario de Gino Bosio). **Todas tienen exactamente 5 letras**.
///
/// Para extender el juego basta con añadir entradas al final de la lista
/// (manteniendo 5 letras) y subir la versión del diccionario.
///
/// Nota: incluye algunos términos de registro vulgar, propios del habla
/// callejera limeña.
const List<WordEntry> peruvianWords = <WordEntry>[
  // --- Jerga general limeña ---
  WordEntry(
    word: 'CAUSA',
    definition:
        'Amigo. «¡Mi causa!» es el vocativo más usado en Lima. También es '
        'la comida ayahuchana de papa y ají amarillo.',
  ),
  WordEntry(
    word: 'CHELA',
    definition:
        'Cerveza light. Por extensión, el candado de una puerta.',
  ),
  WordEntry(
    word: 'PALTA',
    definition:
        'Aguacate. En el «paltear» se golpea a alguien con una palta.',
  ),
  WordEntry(
    word: 'MONSE',
    definition:
        'Aburrido, fome, tarado. «¡Qué monse!» = qué aburrimiento.',
  ),
  WordEntry(
    word: 'LANCE',
    definition:
        'A la primera, de una sola vez. «Dale con el lance».',
  ),
  WordEntry(
    word: 'MACHA',
    definition:
        'Valiente, con coraje y con garra. «¡Qué macha!» = qué valentón.',
  ),
  WordEntry(
    word: 'MACHO',
    definition:
        '«Muy macho»: cuando alguien se planta con valentía o se hace el '
        'valiente.',
  ),
  WordEntry(
    word: 'TARDE',
    definition:
        'Saludo informal: «¡Tarde!». Como adjetivo, malo o fuera de lugar.',
  ),
  WordEntry(
    word: 'FIACA',
    definition:
        'Aburrimiento, desgano, pereza. «¡Qué fiaca, no salgo!»',
  ),
  WordEntry(
    word: 'PLANO',
    definition:
        'Sin plata o sin recursos. «Estoy plano» = no tengo un centavo.',
  ),
  WordEntry(
    word: 'ARENA',
    definition:
        'Expresión «no te cures la arena»: no te creas ese cuento.',
  ),
  WordEntry(
    word: 'COLLA',
    definition:
        '«Ir a la colla»: ir al campo o mercado a vender lo que produces.',
  ),
  WordEntry(
    word: 'MORRO',
    definition:
        'Charleta, conversación larga y placentera. «Dame morro» = cuéntame '
        'todo.',
  ),
  WordEntry(
    word: 'PAPAS',
    definition:
        'Padres. «Mis papas» es la forma cariñosa de llamarlos.',
  ),
  WordEntry(
    word: 'TRIGO',
    definition:
        '«Dar trigo»: equivocarse o fallar en algo.',
  ),
  WordEntry(
    word: 'POLLO',
    definition:
        '«A la pollera»: al revés. Todo lo que va «a la pollera» sale mal.',
  ),
  WordEntry(
    word: 'BRUJA',
    definition:
        '«Tener bruja»: tener maña o experiencia para salir del apuro.',
  ),
  WordEntry(
    word: 'GORDO',
    definition:
        '«Estar gordo»: estar muy bien, en su mejor momento.',
  ),
  WordEntry(
    word: 'TOLDO',
    definition:
        'Sombrero, en especial el grande de paja que usan en la costa.',
  ),
  WordEntry(
    word: 'MANSO',
    definition:
        'Blanducho, cobarde. «¡No seas manso!» es un consejo clásico.',
  ),
  WordEntry(
    word: 'CHAPO',
    definition:
        '«¡Chapo!»: te atrapé, te pesqué. Como sustantivo, un muchacho.',
  ),
  WordEntry(
    word: 'COBRA',
    definition:
        'Tacaño, que no suelta ni un centavo. «¡Cobra, no me fastidies!»',
  ),
  WordEntry(
    word: 'PISTO',
    definition:
        'Dinero. «No tengo pisto» = no tengo plata.',
  ),
  WordEntry(
    word: 'CHACA',
    definition:
        'Casa de juego de azar o rifa informal. «Vamos a la chaca».',
  ),
  WordEntry(
    word: 'QUEBE',
    definition:
        '«¡Qué onda!»: saludo y expresión de sorpresa o desconcierto.',
  ),
  WordEntry(
    word: 'FECHA',
    definition:
        '«Echar la fecha»: atreverse, tener fe. «¡Échale fecha!»',
  ),
  WordEntry(
    word: 'TRAGO',
    definition:
        'Bebida de una vez. «Dame un trago» o «echar un trago» = tomar.',
  ),
  WordEntry(
    word: 'GUARO',
    definition:
        'Aguardiente de uva típico del sur del Perú.',
  ),
  WordEntry(
    word: 'PISCO',
    definition:
        'Aguardiente de uva de origen peruano y base del Pisco Sour.',
  ),
  WordEntry(
    word: 'CHUCO',
    definition:
        'Un poco, un pelín. «Un chuco de sal» = un poquito.',
  ),
  WordEntry(
    word: 'TAQUE',
    definition:
        '«¡Tácale!»: ¡vamos con todo, con ganas!',
  ),
  WordEntry(
    word: 'SAQUE',
    definition:
        '«¡Sácale!»: ¡tú puedes, con energía!',
  ),
  WordEntry(
    word: 'BORRA',
    definition:
        '«Estar en su borra»: estar borracho.',
  ),
  WordEntry(
    word: 'FORRO',
    definition:
        'Tonto, bobo. «¡Qué forro!» = qué tonto.',
  ),
  WordEntry(
    word: 'JAMON',
    definition:
        'Inútil, torpe. «¡Qué jamón!» = qué paja.',
  ),
  WordEntry(
    word: 'FLACO',
    definition:
        'Amigo, colega. «¡Flaco!» = hey, amigo.',
  ),
  WordEntry(
    word: 'PLATA',
    definition:
        'Dinero. «Estar sin plata» = estar sin recursos.',
  ),
  WordEntry(
    word: 'CUMPA',
    definition:
        'Amigo, compadre, partner. «¡Qué más, cumpa!»',
  ),
  WordEntry(
    word: 'CHULA',
    definition:
        'Muy buena, bonita. «¡Qué chula!» = qué bueno.',
  ),
  WordEntry(
    word: 'PELON',
    definition:
        'Calvo. «¡Pelón!» = sin una gota de pelo.',
  ),
  WordEntry(
    word: 'LETRA',
    definition:
        '«Tener letra»: tener descaro, falta de vergüenza.',
  ),
  WordEntry(
    word: 'JALAR',
    definition:
        'Servir, funcionar. «No me jala» = no me funciona o no me interesa.',
  ),
  WordEntry(
    word: 'VICHA',
    definition:
        'Comunicación, mensaje (sobre todo por WhatsApp). «Te mando una '
        'vicha».',
  ),
  WordEntry(
    word: 'CHOLO',
    definition:
        'Mestizo. Como jerga juvenil, «ser cholo» es timidez o inhibición.',
  ),
  WordEntry(
    word: 'CHOTA',
    definition:
        'Expresión de fastidio o sorpresa: «¡Chota!» = ¡qué lata!',
  ),
  WordEntry(
    word: 'GUATE',
    definition:
        '«¡Guá!»: ¡ey, tú! o ¡qué coraje!',
  ),
  WordEntry(
    word: 'BOMBA',
    definition:
        '«Estar en una bomba»: estar en una gran borrachera.',
  ),
  WordEntry(
    word: 'PILAS',
    definition:
        '«Ser pilas»: tener mucha energía y ser proactivo. «¡Ponte las '
        'pilas!»',
  ),
  WordEntry(
    word: 'TAIFA',
    definition:
        '«Taifá»: muchísimo, en gran cantidad. «Está bien taifá».',
  ),
  WordEntry(
    word: 'QUINO',
    definition:
        'Fiesta, joda, rave. «El sábado va a haber quino en mi barrio».',
  ),
  WordEntry(
    word: 'TINKA',
    definition:
        '«Me tinka que...»: me late, lo presiento, lo veo venir.',
  ),
  WordEntry(
    word: 'BAMBA',
    definition:
        'Falso, falsificado, que no es original. «Zapatos bamba».',
  ),
  WordEntry(
    word: 'COMBI',
    definition:
        'Furgón o combi con asientos y espacio para carga. '
        '«Vamos en combi al norte».',
  ),
  WordEntry(
    word: 'GERMA',
    definition:
        'Novia o pareja. «¿Dónde está tu germa?»',
  ),
  WordEntry(
    word: 'HABLA',
    definition:
        'Hola. «¡Habla!» es el saludo limeño de siempre.',
  ),
  WordEntry(
    word: 'TALCO',
    definition:
        'Cocaína. Se usa al hablar en clave en la calle.',
  ),
  WordEntry(
    word: 'TARRO',
    definition:
        'Culo, poto. «¡Tarro!», de forma cariñosa o de reproche.',
  ),
  WordEntry(
    word: 'PICHI',
    definition:
        'Orina. «Voy a pichar» = voy al baño.',
  ),
  WordEntry(
    word: 'PICON',
    definition:
        'El que no pierde ni se rinde. «Eres un picón, nunca te das por '
        'vencido».',
  ),
  WordEntry(
    word: 'CACHO',
    definition:
        'Torpe, inútil para algo. «Eres un cacho para las maths».',
  ),
  WordEntry(
    word: 'BICHO',
    definition:
        'Bicho. Como insulto: persona rara o que se porta mal.',
  ),
  WordEntry(
    word: 'CHOLA',
    definition:
        'Contrabandista. «La chola del puerto» es la que vende sin '
        'licencia.',
  ),
  WordEntry(
    word: 'CACHI',
    definition:
        'Culo. «¡Cachi!», en tono de reproche o de cariño.',
  ),
  WordEntry(
    word: 'TRAMO',
    definition:
        '«Salir en tramo»: salir bien, tener éxito en lo que sea.',
  ),
  WordEntry(
    word: 'TUMBA',
    definition:
        'Rebote o descarte. «Me dio tumba» = me rechazaron.',
  ),
  WordEntry(
    word: 'PLUMA',
    definition:
        'Presumir, lucirse. «¿Por qué echas la pluma?».',
  ),
  WordEntry(
    word: 'AMPAY',
    definition:
        'Sorprender a alguien en una situación incómoda o vergonzosa. '
        '«Lo ampayaron en la fiesta».',
  ),
  WordEntry(
    word: 'ASADO',
    definition:
        'Enojado, de mal genio. «¡Estoy asado con él!».',
  ),
  WordEntry(
    word: 'CUZCO',
    definition:
        '«Hacerse el cusqueño»: hacerse el que no entiende nada para que '
        'otro te explique.',
  ),
  WordEntry(
    word: 'HIELO',
    definition:
        '«Estar de hielo»: indiferente, frío con alguien.',
  ),
  WordEntry(
    word: 'JERGA',
    definition:
        'La forma de hablar propia de un grupo. «Su jerga no se '
        'entiende».',
  ),
  WordEntry(
    word: 'MANYA',
    definition:
        '¿Entiendes? «¿Manyas?» es la forma limeña de preguntar si te han '
        'explicado.',
  ),
  WordEntry(
    word: 'CHAVO',
    definition:
        'Chico, joven. Viene del Chavo del 8 y se usa a diario en Lima.',
  ),
  WordEntry(
    word: 'PANAS',
    definition:
        'Amigos, conocidos. «Sal con mis panas» = sal con mis amigos.',
  ),
  WordEntry(
    word: 'CUORE',
    definition:
        'Corazón. Anglicismo que en Lima significa «te quiero».',
  ),
  WordEntry(
    word: 'TINTA',
    definition:
        '«Andar con tinta»: tener estilo o buena pinta.',
  ),
  WordEntry(
    word: 'LIMON',
    definition:
        '«Aguantar el limón»: aguantar una situación difícil.',
  ),
  WordEntry(
    word: 'PINON',
    definition:
        'Semilla del pino, usada en la cocina peruana. «Dar piñón» es '
        'ponerle difícil a alguien.',
  ),
  WordEntry(
    word: 'TILIN',
    definition:
        '«¡Tilín!»: me gusta, de acuerdo, me parece bien.',
  ),
  WordEntry(
    word: 'FATAL',
    definition:
        '«¡Qué fatal!»: se usa para celebrar un buen resultado, con ironyía.',
  ),
  WordEntry(
    word: 'BOLSA',
    definition:
        '«Estar en la bolsa»: tener el puesto asegurado.',
  ),
  WordEntry(
    word: 'CHATO',
    definition:
        'El billete de 10 soles. «¿Me das un chato?».',
  ),
];

/// Diccionario por defecto (alias semántico de [peruvianWords]).
List<WordEntry> get defaultWordList => peruvianWords;
