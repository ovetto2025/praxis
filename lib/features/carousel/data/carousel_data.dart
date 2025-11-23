import 'package:praxis/features/carousel/models/carousel_model.dart';

final List<CarouselModel> carouselData = [
  CarouselModel(
    numberId: 0,
    locationId: [],
    title: "PERCORSO CULTURALE (LUOGHI DELLA GRANDE INVASIONE)",
    description:
        "Descrizione: Questo percorso vi porterà a scoprire il lato di Ivrea più legato alla cultura, con un tracciato che attraversa i luoghi della Grande Invasione: partendo dal Museo Civico Pier Alessandro Garda, situato all’interno dell’antico monastero di Santa Chiara, potrete in seguito ammirare la centrale e folkloristica Piazza Ottinetti (anche Piazza di Città e Piazza della Morte Nera), per poi arrivare in Piazza Santa Marta, caratterizzata dalla sua chiesa ormai sconsacrata, e concludere visitando lo storico ed elegante Teatro Civico Giuseppe Giacosa.\nLunghezza: 350 metri (500 passi)",
    location: [
      "Teatro Civico Giuseppe Giacosa",
      "Piazza Ottinetti",
      "Piazza Santa Marta",
      "Museo Civico Pier Alessandro Garda",
    ],
  ),
  CarouselModel(
    numberId: 1,
    locationId: [],
    title: "PERCORSO SPORTIVO",
    description:
        "Descrizione: Questo percorso vi farà scoprire la città di Ivrea in chiave sportiva, con un viaggio che inizia dallo spettacolare e unico nel suo genere Stadio della Canoa e le sue acque impetuose, per poi passare dalla famosa Piscina Comunale e arrivare infine in Piazza Ottinetti (anche Piazza di Città), il luogo in cui si svolge la storica battaglia delle arance del celebre Carnevale d’Ivrea.\nLunghezza: 2100 metri (3000 passi)",
    location: ["Stadio della Canoa", "Piscina Comunale", "Piazza Ottinetti"],
  ),
  CarouselModel(
    numberId: 2,
    locationId: [],
    title: "PERCORSO FAMILY FRIENDLY",
    description:
        "Descrizione: Questo tipo di percorso è stato pensato soprattutto per le famiglie e i più piccoli, mettendo a disposizione un modo per visitare la città di Ivrea fatto di gioco all’interno dei suoi parchi e di scoperta (anche) a piccoli passi. Partendo dal bellissimo Parco Dora Baltea con il suo giardino \"Donne della Resistenza\", si potrà raggiungere l’imponente Castello Sabaudo con le sue torri medievali, per poi passare attraverso la storia di Piazza Ottinetti, e infine concludere giocando e divertendosi ai giardini Giusiana con la loro spettacolare vista sul fiume.\nLunghezza: 1700 metri (2450 passi) ",
    location: [
      "Parco Dora Baltea",
      "Castello Sabaudo",
      "Piazza Ottinetti",
      "giardini Giusiana",
    ],
  ),
  CarouselModel(
    numberId: 3,
    locationId: [],
    title: "PERCORSO SLOW TOURISM",
    description:
        "Descrizione: Questo è il percorso più lungo e snodato di tutti, quello che parte da lontano per arrivare fino alla storia recente di Ivrea: si inizia dalla centrale Piazza Ottinetti (anche Piazza di Città) con i suoi portici, per poi giungere al Castello Sabaudo costruito nel XIV secolo dai Savoia. Da qui si scende verso il Parco Dora Baltea con il suo tributo alle \"Donne della Resistenza\", per poi giungere nella zona patrimonio dell’UNESCO e la sua avveniristica via Jervis, le sue officine, ma anche le abitazioni degli ex dipendenti e dirigenti della storica azienda Olivetti.\nLunghezza: 3200 metri (4600 passi)",
    location: [
      "Piazza Ottinetti",
      "Castello Sabaudo",
      "Parco Dora Baltea",
      "Case dipendenti e dirigenti Olivetti",
    ],
  ),
];
