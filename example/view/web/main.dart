import 'package:kitawi/utils/query.dart';
import 'package:kitawi/view.dart';

void main() => Router.run(
      initialRoute: '/',
      debugMode: true,
      routes: [
        Route(
          path: '/',
          view: (p) => Text("Home"),
        ),
        Route(
          path: '/:name',
          view: (p) => Text("Hello ${p['name']}"),
        ),
        Route(
          path: '/search',
          view: (p) => Text("Search: ${Query.get('q')}"),
        ),
      ],
    );
