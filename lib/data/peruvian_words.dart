import '../models/word_entry.dart';

/// Diccionario local de jergas peruanas de 5 letras.
///
/// La lista es estática y local (sin backend): el mismo orden para todos los
/// usuarios garantiza que la *palabra del día* sea idéntica en cada
/// dispositivo (índice = días transcurridos % longitud de la lista).
///
/// Para extender el juego basta con añadir entradas al final de la lista
/// (manteniendo 5 letras) y subir la versión del diccionario.
const List<WordEntry> peruvianWords = <WordEntry>[
  WordEntry(
    word: 'CAUSA',
    definition:
        'Comida ayahuchana a base de papa y ají amarillo. Como vocativo, '
        '«¡causa!» es una forma cariñosa de llamar a un amigo.',
  ),
  WordEntry(
    word: 'CHAMBA',
    definition:
        'Trabajo. Del inglés "job". «¿Cómo te va en la chamba?»',
  ),
  WordEntry(
    word: 'PALTA',
    definition:
        'Aguacate. En Perú es fundamental en la cocina y en el «paltear», '
        'golpear a alguien con una palta.',
  ),
  WordEntry(
    word: 'CHELA',
    definition:
        'Cerveza light. Por extensión, también el candado de una puerta.',
  ),
  WordEntry(
    word: 'PIÑA',
    definition:
        'Error o cacharrería. «Metí la pata, fue una piña».',
  ),
  WordEntry(
    word: 'FIRME',
    definition:
        'Seguro, en orden, sin problema. «Todo firme» = todo tranquilo.',
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
    word: 'PLUMA',
    definition:
        'Elegante, con estilo. «Anda con plumas» = viste bien.',
  ),
  WordEntry(
    word: 'PATA',
    definition:
        'Amigo, compadre. «¡Hola, pata!»',
  ),
  WordEntry(
    word: 'TARDE',
    definition:
        'Saludo informal: «¡Tarde!». Como adjetivo significa malo o fuera de '
        'lugar.',
  ),
  WordEntry(
    word: 'FIACA',
    definition:
        'Aburrimiento, desgano, pereza. «¡Qué fiaca, no salgo!»',
  ),
  WordEntry(
    word: 'PICO',
    definition:
        'Inútil, que no sirve. «No sirve de pico». También la moneda de un '
        'sol.',
  ),
  WordEntry(
    word: 'BIRRIA',
    definition:
        'Guiso de carne de res típico del norte del Perú. Como jerga, '
        '«estar birria» es quedar jadeando.',
  ),
  WordEntry(
    word: 'CHICHO',
    definition:
        'Chicha, bebida tradicional peruana. En el norte, «chicha» también '
        'significa cariño o amor.',
  ),
  WordEntry(
    word: 'PLANO',
    definition:
        'Sin plata o sin recursos. «Estoy plano» = no tengo un centavo.',
  ),
  WordEntry(
    word: 'FIERRO',
    definition:
        'Bueno, guapo. «Echar los fierros» = posesarse o ponerse tough.',
  ),
  WordEntry(
    word: 'ARENA',
    definition:
        'Expresión «no te cures la arena»: no te creas ese cuento.',
  ),
  WordEntry(
    word: 'YAÑA',
    definition:
        'Maña, astucia. «Tiene yaña» = se las sabe todas.',
  ),
  WordEntry(
    word: 'NICA',
    definition:
        '«Ni cagando»: de ninguna manera. Como interjección, «¡nica!» = '
        '¡nada!',
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
    word: 'VANO',
    definition:
        '«Ser vano»: ser inútil, inservible. De ahí viene «vanidad».',
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
    word: 'ROCA',
    definition:
        'Durísimo, invencible. «El muro es una roca».',
  ),
  WordEntry(
    word: 'LIMA',
    definition:
        'Ciudad capital del Perú. También el fruto ácido con el que se '
        'elabora el pisco.',
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
    word: 'FANO',
    definition:
        '«Salir al fano»: salir a la calle, al mundo.',
  ),
  WordEntry(
    word: 'GRINGO',
    definition:
        'Extranjero, especialmente de habla anglosajona. De uso muy común '
        'en el Perú.',
  ),
  WordEntry(
    word: 'QUEBE',
    definition:
        '«¡Qué onda!»: saludo y expresión de sorpresa o de desconcierto.',
  ),
  WordEntry(
    word: 'CHULO',
    definition:
        'Muy bueno, bacán. «¡Qué chulo!» = qué bonito.',
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
    word: 'CHAMPI',
    definition:
        'Champú. Jerga por alargamiento fonético.',
  ),
  WordEntry(
    word: 'LONCHE',
    definition:
        'Almuerzo. Del inglés «lunch». «¿Ya almorzaste o te traigo un lonche?»',
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
    word: 'CHUSCO',
    definition:
        'Perro callejero. Por extensión, algo de mal gusto o descuidado.',
  ),
  WordEntry(
    word: 'CHUCO',
    definition:
        'Un poco, un pelín. «Un chuco de sal» = un poquito.',
  ),
  WordEntry(
    word: 'TILIN',
    definition:
        '«¡Tilín!»: me gusta, de acuerdo, me parece bien.',
  ),
  WordEntry(
    word: 'GUATE',
    definition:
        '«¡Guá!»: ¡ey, tú! o ¡qué coraje!',
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
    word: 'PIFO',
    definition:
        'Error o equivocación. «¡Pifo!» = te equivocaste.',
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
    word: 'FATAL',
    definition:
        '«¡Qué fatal!»: expresión que celebrate un buenos resultado con '
        'entusiasmo.',
  ),
  WordEntry(
    word: 'CHULA',
    definition:
        'Muy buena, bonita. «¡Qué chula!» = qué bueno.',
  ),
  WordEntry(
    word: 'NUBE',
    definition:
        '«Estar con la nube»: estar de mal humor, molesto.',
  ),
  WordEntry(
    word: 'PELON',
    definition:
        'Calvo. «¡Pelón!» = sin una gota de pelo.',
  ),
  WordEntry(
    word: 'SUAVE',
    definition:
        '«¡Qué suave!»: expresión de gusto, agradable y sin concreto.',
  ),
  WordEntry(
    word: 'BRAVO',
    definition:
        '«¡Qué bravo!»: excelente, peligrosamente bueno.',
  ),
  WordEntry(
    word: 'LETRA',
    definition:
        '«Tener letra»: tener descaro, falta de vergüenza.',
  ),
  WordEntry(
    word: 'BOLSA',
    definition:
        '«Estar en la bolsa»: tener el puesto asegurado.',
  ),
  WordEntry(
    word: 'JALAR',
    definition:
        'Servir, funcionar. «No me jala» = no me funciona o no me interesa.',
  ),
  WordEntry(
    word: 'VICHA',
    definition:
        'Comunicación, mensaje (por WhatsApp sobre todo). «Te mando una '
        'vicha».',
  ),
  WordEntry(
    word: 'TRUJO',
    definition:
        '«Estar en el trujo»: estar enredado, en un lío.',
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
    word: 'PESCAR',
    definition:
        'Conseguir o alcanzar algo. «Pesqué el trabajo».',
  ),
];

/// Diccionario por defecto (alias semántico de [peruvianWords]).
List<WordEntry> get defaultWordList => peruvianWords;
