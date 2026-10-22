import '../models/word_entry.dart';

/// Diccionario local de jergas **[b]peruanas[/b]** de 5 letras.
///
/// La lista es estática y local (sin backend): el mismo orden para todos los
/// usuarios garantiza que la *palabra del día* sea idéntica en cada
/// dispositivo (índice = días transcurridos % longitud de la lista).
///
/// Todos los términos son de uso real en Lima y la costa central, tomados de:
/// - **DiPerú**, diccionario de la Academia Peruana de la Lengua.
/// - **Peruanismos de Lima y la costa central** (108 términos).
/// - **Wikilengua**, Jerga juvenil/Perú.
/// - **Martha Hildebrandt**, *Peruanismos*.
///
/// Se descartaron las palabras que no son propiamente peruanas: las de
/// origen chileno, argentino, mexicano o Simply potensiulyora, y las que
/// son español estándar sin uso jergático en el Perú.
///
/// Todas tienen **exactamente 5 letras** (la Ñ sí cuenta, el teclado la
/// incluye).
///
/// Nota: incluye algunos términos de registro vulgar, propios del habla
/// callejera limeña.
const List<WordEntry> peruvianWords = <WordEntry>[
  WordEntry(
    word: 'AGUJA',
    definition:
        'Sin dinero. «Estoy más aguja que muñeco de brujería».',
  ),
  WordEntry(
    word: 'AMPAY',
    definition:
        'Sorprender a alguien en una situación incómoda o vergonzosa. '
        '«Lo ampayaron en la fiesta».',
  ),
  WordEntry(
    word: 'ARENA',
    definition:
        'Expresión «no te cures la arena»: no te creas ese cuento.',
  ),
  WordEntry(
    word: 'ASADO',
    definition:
        'Enojado, de mal genio. «¡Estoy asado con él!».',
  ),
  WordEntry(
    // Se escribe «bacán», pero sin tilde para que se pueda teclear.
    word: 'BACAN',
    definition:
        'Genial, muy bueno. «¡Qué bacán tu polo!».',
  ),
  WordEntry(
    word: 'BAMBA',
    definition:
        'Falso, falsificado, que no es original. «Zapatos bamba».',
  ),
  WordEntry(
    word: 'BICHO',
    definition:
        'Bicho. Como insulto: persona rara o que se porta mal.',
  ),
  WordEntry(
    word: 'BOMBA',
    definition:
        'Borrachera épica. «Nos metimos una bomba el sábado».',
  ),
  WordEntry(
    word: 'BORRA',
    definition:
        '«Estar en su borra»: estar borracho.',
  ),
  WordEntry(
    word: 'BROER',
    definition:
        'Amigo, del inglés «brother». «Habla broer, ¿cómo va todo?».',
  ),
  WordEntry(
    word: 'BRUJA',
    definition:
        '«Tener bruja»: tener maña o experiencia para salir del apuro.',
  ),
  WordEntry(
    word: 'CAUSA',
    definition:
        'Amigo. «¡Mi causa!» es el vocativo más usado en Lima. También es '
        'la comida ayahuchana de papa y ají amarillo.',
  ),
  WordEntry(
    word: 'CHACA',
    definition:
        'Casa de juego de azar o rifa informal. «Vamos a la chaca».',
  ),
  WordEntry(
    word: 'CHAPO',
    definition:
        '«¡Chapo!»: te atrapé, te pesqué. Como sustantivo, un muchacho.',
  ),
  WordEntry(
    word: 'CHAVO',
    definition:
        'Chico, joven. Viene del Chavo del 8 y se usa a diario en Lima.',
  ),
  WordEntry(
    word: 'CHELA',
    definition:
        'Cerveza. «Nos tomamos unas chelas».',
  ),
  WordEntry(
    word: 'CHOLA',
    definition:
        'Contrabandista. «La chola del puerto» es la que vende sin '
        'licencia.',
  ),
  WordEntry(
    word: 'CHOLO',
    definition:
        'Apelativo de confianza. Fuera de confianza puede sonar despectivo. '
        '«Ese cholo es mi causa».',
  ),
  WordEntry(
    word: 'CHOTA',
    definition:
        'Expresión de fastidio o sorpresa: «¡Chota!» = ¡qué lata!',
  ),
  WordEntry(
    word: 'CHUCO',
    definition:
        'Un poco, un pelín. «Un chuco de sal» = un poquito.',
  ),
  WordEntry(
    word: 'CHULA',
    definition:
        'Muy buena, bonita. «¡Qué chula!» = qué bueno.',
  ),
  WordEntry(
    word: 'COLLA',
    definition:
        '«Ir a la colla»: ir al campo o mercado a vender lo que produces.',
  ),
  WordEntry(
    word: 'COMBI',
    definition:
        'Furgón con asientos y espacio para carga. «Vamos en combi al '
        'norte».',
  ),
  WordEntry(
    word: 'CRUDA',
    definition:
        'Resaca, el malestar del día después de la borrachera.',
  ),
  WordEntry(
    word: 'CUORE',
    definition:
        'Corazón. Anglicismo que en Lima significa «te quiero».',
  ),
  WordEntry(
    word: 'CUMPA',
    definition:
        'Amigo, compadre, partner. «¡Qué más, cumpa!»',
  ),
  WordEntry(
    word: 'CUZCO',
    definition:
        '«Hacerse el cusqueño»: hacerse el que no entiende nada para que '
        'otro te explique.',
  ),
  WordEntry(
    word: 'FECHA',
    definition:
        '«Echar la fecha»: atreverse, tener fe. «¡Échale fecha!»',
  ),
  WordEntry(
    word: 'FICHO',
    definition:
        'Elegante, que tiene estilo. «Está bien ficho ese lugar».',
  ),
  WordEntry(
    word: 'FIACA',
    definition:
        'Aburrimiento, desgano, pereza. «¡Qué fiaca, no salgo!»',
  ),
  WordEntry(
    word: 'FLACO',
    definition:
        'Amigo, colega. Como pareja: «salió con su flaca el sábado».',
  ),
  WordEntry(
    word: 'FORRO',
    definition:
        'Tonto, bobo. «¡Qué forro!» = qué tonto.',
  ),
  WordEntry(
    word: 'GERMA',
    definition:
        'Novia o pareja. «¿Dónde está tu germa?»',
  ),
  WordEntry(
    word: 'GUARO',
    definition:
        'Aguardiente de uva típico del sur del Perú.',
  ),
  WordEntry(
    word: 'GUATE',
    definition:
        '«¡Guá!»: ¡ey, tú! o ¡qué coraje!',
  ),
  WordEntry(
    word: 'GUCHA',
    definition:
        'Cañito en el fútbol. «Me hizo una guacha y me fui al suelo».',
  ),
  WordEntry(
    word: 'GUITA',
    definition:
        'Dinero. «No tengo ni guita».',
  ),
  WordEntry(
    word: 'HABLA',
    definition:
        'Hola. «¡Habla causa! ¿Todo bien?».',
  ),
  WordEntry(
    word: 'JALAR',
    definition:
        'Tirar hacia uno, jalar. También suspender un examen: «jalé el '
        'examen de nuevo».',
  ),
  WordEntry(
    word: 'JAMON',
    definition:
        'Inútil, torpe. «¡Qué jamón!» = qué paja.',
  ),
  WordEntry(
    word: 'JONCA',
    definition:
        'Caja de cervezas. «Trajimos una jonca para el tono».',
  ),
  WordEntry(
    word: 'LETRA',
    definition:
        '«Tener letra»: tener descaro, falta de vergüenza.',
  ),
  WordEntry(
    word: 'LIMON',
    definition:
        '«Aguantar el limón»: aguantar una situación difícil.',
  ),
  WordEntry(
    word: 'LLECA',
    definition:
        'Calle. Del mismo modo: «lleca».',
  ),
  WordEntry(
    word: 'LOMPA',
    definition:
        'Pantalón. «Voy con la lompa negra».',
  ),
  WordEntry(
    word: 'LORNA',
    definition:
        'Tonto, bobo. «No seas lorna, ya pues».',
  ),
  WordEntry(
    word: 'MACHA',
    definition:
        'Valiente, con coraje. «¡Qué macha!» = qué valentón.',
  ),
  WordEntry(
    word: 'MANYA',
    definition:
        '«¿Manyas?» es la forma limeña de preguntar si te han explicado.',
  ),
  WordEntry(
    word: 'MISIO',
    definition:
        'Sin dinero. «Estoy más misio que nunca».',
  ),
  WordEntry(
    word: 'MONSE',
    definition:
        'Tonto, lorna. «¡Qué monse!» = qué aburrimiento.',
  ),
  WordEntry(
    word: 'MORRO',
    definition:
        'Charleta, conversación larga y placentera. «Dame morro» = cuéntame '
        'todo.',
  ),
  WordEntry(
    word: 'PALTA',
    definition:
        'Aguacate. En el «paltear» se golpea a alguien con una palta.',
  ),
  WordEntry(
    word: 'PANAS',
    definition:
        'Amigos, conocidos. «Sal con mis panas» = sal con mis amigos.',
  ),
  WordEntry(
    word: 'PAPAS',
    definition:
        'Patatas, y con cariño los padres: «mis papas».',
  ),
  WordEntry(
    word: 'PELON',
    definition:
        'Calvo. «¡Pelón!» = sin una gota de pelo.',
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
    word: 'PILAS',
    definition:
        '«Ser pilas»: tener mucha energía y ser proactivo. «¡Ponte las '
        'pilas!»',
  ),
  WordEntry(
    word: 'PISCO',
    definition:
        'Aguardiente de uva de origen peruano y base del Pisco Sour.',
  ),
  WordEntry(
    word: 'PISTO',
    definition:
        'Dinero. «No tengo pisto» = no tengo plata.',
  ),
  WordEntry(
    word: 'PLANO',
    definition:
        'Sin plata o sin recursos. «Estoy plano» = no tengo un centavo.',
  ),
  WordEntry(
    word: 'POLLO',
    definition:
        '«A la pollera»: al revés. Todo lo que va «a la pollera» sale mal.',
  ),
  WordEntry(
    word: 'QUEBE',
    definition:
        '«¡Qué onda!»: saludo y expresión de sorpresa o desconcierto.',
  ),
  WordEntry(
    word: 'QUINO',
    definition:
        'Fiesta, joda. «El sábado va a haber quino en mi barrio».',
  ),
  WordEntry(
    word: 'ROCHE',
    definition:
        'Vergüenza. «¡Qué roche caerse así!».',
  ),
  WordEntry(
    word: 'SAQUE',
    definition:
        '«¡Sácale!»: ¡tú puedes, con energía!',
  ),
  WordEntry(
    word: 'SIMON',
    definition:
        'Sí, igual que «cincuenta». «¿Nos vemos a las ocho? Simón».',
  ),
  WordEntry(
    word: 'SONSO',
    definition:
        'Tonto. «¡Qué sonso eres a veces!».',
  ),
  WordEntry(
    word: 'TABAS',
    definition:
        'Zapatillas. «Están chéveres tus tabas».',
  ),
  WordEntry(
    word: 'TAIFA',
    definition:
        '«Taifá»: muchísimo, en gran cantidad. «Está bien taifá».',
  ),
  WordEntry(
    word: 'TALCO',
    definition:
        'Cocaína. Se usa al hablar en clave en la calle.',
  ),
  WordEntry(
    word: 'TARDE',
    definition:
        'Saludo informal: «¡Tarde!». Como adjetivo, malo o fuera de lugar.',
  ),
  WordEntry(
    word: 'TARRO',
    definition:
        'Culo, poto. «¡Tarro!», de forma cariñosa o de reproche.',
  ),
  WordEntry(
    word: 'TASAR',
    definition:
        'Conocer a alguien, tenerlo ubicado. «A ese pata lo taso, estuvo en '
        'mi colegio».',
  ),
  WordEntry(
    word: 'TAQUE',
    definition:
        '«¡Tácale!»: ¡vamos con todo, con ganas!',
  ),
  WordEntry(
    word: 'TINTA',
    definition:
        '«Andar con tinta»: tener estilo o buena pinta.',
  ),
  WordEntry(
    word: 'TINKA',
    definition:
        '«Me tinka que...»: me late, lo presiento, lo veo venir.',
  ),
  WordEntry(
    word: 'TOLDO',
    definition:
        'Sombrero, en especial el grande de paja que usan en la costa.',
  ),
  WordEntry(
    word: 'TROME',
    definition:
        'Muy hábil en algo. «Ese pata es trome arreglando motores».',
  ),
  WordEntry(
    word: 'TRAMO',
    definition:
        '«Salir en tramo»: salir bien, tener éxito en lo que sea.',
  ),
  WordEntry(
    word: 'TRIGO',
    definition:
        '«Dar trigo»: equivocarse o fallar en algo.',
  ),
  WordEntry(
    word: 'TUMBA',
    definition:
        'Rebote o descarte. «Me dio tumba» = me rechazaron.',
  ),
  WordEntry(
    word: 'VICHA',
    definition:
        'Comunicación, mensaje (sobre todo por WhatsApp). «Te mando una '
        'vicha».',
  ),
  WordEntry(
    word: 'YUNTA',
    definition:
        'Amigo inseparable o grupo de amigos del barrio.',
  ),
];

/// Diccionario por defecto (alias semántico de [peruvianWords]).
List<WordEntry> get defaultWordList => peruvianWords;
