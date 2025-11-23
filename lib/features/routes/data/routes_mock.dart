import 'package:praxis/features/routes/models/route_model.dart';

final culturalRoute = RouteModel(
  id: 'cultural_route',
  title: 'Percorso Culturale',
  subtitle: 'Luoghi della Grande Invasione',
  description:
      'Questo percorso vi porterà a scoprire il lato di Ivrea più legato alla cultura, con un tracciato che attraversa i luoghi della Grande Invasione: potrete quindi ammirare la centrale Piazza di Città (o Piazza della Morte Nera), Piazza Santa Marta e la sua chiesa, oggi sconsacrata, lo storico e grazioso Teatro Civico e il Museo Civico Pier Alessandro Garda, situato all’interno dell’antico monastero di Santa Chiara in Piazza Ottinetti, con le sue collezioni.',
  placeIds: [
    'piazza_ottinetti',
    'piazza_santa_marta',
    'teatro_giacosa',
    'museo_garda',
  ],
);

final List<RouteModel> routesMock = [culturalRoute];
