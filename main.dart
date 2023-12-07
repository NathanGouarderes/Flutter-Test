import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/page/Aled.dart';
import 'package:test_flutter/page/DefinePreferencesPage.dart';
import 'package:test_flutter/page/MultiTextInputFormaterPage.dart';
import 'package:test_flutter/page/PokemonPage.dart';
import 'package:test_flutter/page/ConditionMachine.dart';
import 'package:test_flutter/page/WordPairsPage.dart';
import 'package:test_flutter/service/FavoriteService.dart';
import 'package:test_flutter/service/MultiTextInputFormaterService.dart';
import 'package:test_flutter/service/SQLite/DogDatabase.dart';
import 'package:test_flutter/service/ThemeModeService.dart';
import 'package:test_flutter/service/injector/Injector.dart';
import 'package:test_flutter/widget/DockerApiWidget.dart';
import 'package:test_flutter/widget/EditBaseWidget.dart';
import 'package:test_flutter/widget/FavoritesWidget.dart';
import 'package:test_flutter/widget/SqliteWidget.dart';

void main() async {
  Injector().setupKiwi();
  final dogDatabase = DogDatabase();

  await dogDatabase.initializeDatabase();
  await dogDatabase.displayAllDogs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => KiwiContainer().resolve<FavoriteService>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.lightBlue
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
        ),
        initial: AdaptiveThemeMode.light,
        builder:  (theme, darktheme) => MaterialApp(
            title: 'Namer App',
            theme: theme,
          home: MyHomePage(),
          darkTheme: darktheme,
            ),

        );
  }
}

class MyAppState extends ChangeNotifier {


}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  int maxWidth = 600;


  void initState(){
    super.initState();
    ThemeModeService().getCurrentTheme();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = WordPairPage();
        print('Home');
        break;
      case 1:
        //page = FavoritesPage();
        page = FavoritesWidget();
        print('Favoris');
        break;
      case 2:
        page = MultiTextInputFormaterPage();
        print('MultiMask');
        break;
      case 3:
        page = SqliteWidget();
        print('Affichage base de données');
        break;
      case 4:
        page = GestionBaseWidget();
        print('Gestion base de données');
        break;
      case 5:
        page = PokemonPage();
        print('Pokemon page');
        break;
      case 6:
        page = DefinePreferencesPage();
        break;
      case 7:
        page = Aled();
        break;
      case 8:
        page = DockerApiWidget();
        break;
      default:
        throw UnimplementedError('Pas de widget pour $selectedIndex');
    }
    if (selectedIndex == 1) {
      maxWidth = 500;
    } else {
      maxWidth = 600;
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= maxWidth,
                    destinations: [
                      const NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      const NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                      const NavigationRailDestination(
                          icon: Icon(Icons.notifications),
                          label: Text('multiMask')),
                      const NavigationRailDestination(
                          icon: Icon(Icons.animation),
                          label: Text('Base de donnée sur les chiens')),
                      const NavigationRailDestination(
                          icon: Icon(Icons.data_array),
                          label: Text('Gestion base de données')),
                      const NavigationRailDestination(
                          icon: Icon(Icons.api),
                          label: Text('Pokemons API')),
                      const NavigationRailDestination(
                          icon: Icon(Icons.data_array),
                          label: Text('Préférences page')),
                      const NavigationRailDestination(
                          icon: Icon(Icons.home_filled),
                          label: Text('Préférences page')),
                      const NavigationRailDestination(
                          icon: Icon(Icons.train),
                          label: Text('Api docker')),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}






  //final WordPair pair;



