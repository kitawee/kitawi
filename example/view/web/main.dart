import 'package:view/view.dart';

void main() => Router.run(
      initialRoute: '/',
      debugMode: true,
      routes: [
        Route(
          path: '/',
          view: (p) => Text("Hello World"),
        ),
        Route(
          path: '/:name',
          view: (p) => Text("Hello ${p['name']}"),
        ),
        Route(
          path: '/search',
          view: (p) => Text("Search: ${SearchParams.get('q') ?? ''}"),
        ),
      ],
    );
