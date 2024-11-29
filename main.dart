
import 'package:banc_didactique/parametre.dart';
import 'package:banc_didactique/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'accueil.dart';
import 'compte_rebout.dart';
import 'connexion.dart';
import 'tp1.dart';
import 'tp2.dart';
import 'tp3.dart';
import 'tp4.dart';
import 'tp5.dart';
import 'tp6.dart';
import 'tp7.dart';
import 'tp8.dart';
import 'tp9.dart';
import 'tp10.dart';
import 'tp11.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: '',
      home: const ArduinoConnectionPage(),
    );
  }
}

class ArduinoConnectionPage extends StatefulWidget {
  final int? index;

  const ArduinoConnectionPage({super.key, this.index});

  @override
  _ArduinoConnectionPageState createState() => _ArduinoConnectionPageState();
}

class _ArduinoConnectionPageState extends State<ArduinoConnectionPage>
    with SingleTickerProviderStateMixin {
  int? _change;
  int tp = 0, durer = 0;
  late TabController _tabController;
  bool etat_Bouton = false;
  int _currentIndex = 0;
   String? _selectedPort;
   bool eTatPort=false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = context.read<ThemeProvider>();
      themeProvider.addListener(() {
        setState(() {
          tp = themeProvider.tp;
          durer = themeProvider.durer;
          etat_Bouton = themeProvider.isFeatureEnabled;
        });
      });
    });

    _tabController = TabController(length: 4, vsync: this);
    if (_change != null) {

      // Attendre 3 secondes avant de remettre _currentIndex à null
      Timer(Duration(seconds: 3), () {
        setState(() {
          _change = null;
        });
      });
    }

    int? previousIndex = _tabController.index; // Initialise avec l'index actuel

    _tabController.addListener(() {
      if (_tabController.index != previousIndex) {
        previousIndex = _tabController.index; // Met à jour l'index précédent
        setState(() {
          int? a = _tabController.index - 1;
          if (a == 0) {
            _currentIndex = a;
          }
          if (a == 1) {
            _currentIndex = a;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    context.read<ThemeProvider>().removeListener(() {});
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Effectuez vos initialisations dépendant du Provider ici
    _selectedPort = Provider
        .of<ThemeProvider>(context).com;
    eTatPort=Provider
        .of<ThemeProvider>(context).etaT;
    print("Accueil list  $_selectedPort");
    if(eTatPort){
      _releasePort();
    }
  }
  void _releasePort() {
    SerialPort port = SerialPort(_selectedPort!);
    SerialPortReader? reader = SerialPortReader(port);
      port.close();
      reader = null;
      setState(() {
        print("Port libéré : $_selectedPort");
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              etat_Bouton
                  ? SizedBox(
                child: CountdownWidget(
                  tp: tp, // Numéro du TP
                  durationInMinutes: durer, // Durée du TP en minutes
                ),
              )
                  : Text(""),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange,
                    width: 10,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(8),
                child: const Text(
                  'INTERFACE GRAPHIQUE DE PILOTAGE DU BANC DIDATIQUE_-ENSGEP ABOMEY',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    fontSize: 25,
                  ),
                ),
              ),

            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.white,

          actions: [
            ArduinoAnimatedConnection(),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.indigo,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(
                icon: PopupMenuButton<int>(
                  icon: Icon(
                    Icons.menu_open_outlined,
                    color: Colors.indigo,
                    size: 30,
                  ),
                  tooltip: 'Options du Menu',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.grey.shade50,
                  onSelected: (value) {
                    // Actions pour chaque élément du menu
                    switch (value) {
                      case 1:
                        print("Accueil sélectionné");
                        break;
                      case 2:
                        setState(() {
                          _currentIndex = 14;
                        });
                        break;
                      case 3:
                        setState(() {
                          _currentIndex = 13;
                        });
                        print("Paramètre sélectionné");
                        break;
                      case 4:
                        print("Aide sélectionné");
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 1,
                      child: SizedBox(
                        width: 350,
                        // Largeur personnalisée pour agrandir le menu
                        child: ListTile(
                          leading: Icon(Icons.home, color: Colors.indigo),
                          title: Text(
                            'Accueil',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: SizedBox(
                        width: 350,
                        // Largeur personnalisée pour agrandir le menu
                        child: ListTile(
                          leading: Icon(
                            Icons.history,
                            color: Colors.indigo, // Couleur de l'icône
                            size: 30.0, // Taille de l'icône
                          ),
                          title: Text(
                            'Historique',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: SizedBox(
                        width: 350,
                        // Largeur personnalisée pour agrandir le menu
                        child: ListTile(
                          leading:
                              Icon(Icons.settings, color: Colors.blue.shade700),
                          title: Text(
                            'Paramètre',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: SizedBox(
                        width: 350,
                        // Largeur personnalisée pour agrandir le menu
                        child: ListTile(
                          leading:
                              Icon(Icons.help, color: Colors.purple.shade700),
                          title: Text(
                            'Aide',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                text: "Menu",
              ),
              Tab(
                text: "Accueil",
                icon: Icon(Icons.home, color: Colors.indigo, size: 28),
              ),
              Tab(
                text: "Dispositif",
                icon: Icon(Icons.memory, color: Colors.indigo, size: 28),
              ),
              Tab(
                icon: PopupMenuButton<int>(
                  icon: Icon(
                    Icons.school,
                    color: Colors.indigo,
                    size: 30,
                  ),
                  tooltip: 'Sélectionnez un TP',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  onSelected: (value) {
                    // Actions pour chaque élément du menu
                    switch (value) {
                      case 1:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        break;
                      case 2:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        break;
                      case 3:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        break;
                      case 4:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        break;
                      case 5:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        break;
                      case 6:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        break;
                      case 7:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        break;
                      case 8:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        break;
                      case 9:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        break;
                      case 10:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        // Actions pour le cas 10
                        break;
                      case 11:
                        setState(() {
                          _currentIndex = value + 1;
                        });
                        // Actions pour le cas 11
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    for (int i = 1; i <= 11; i++)
                      PopupMenuItem(
                        value: i,
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            // color: i.isEven ? Colors.blue.shade50 : Colors.blue.shade100, // Alternance de couleur
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.science_outlined,
                              color: i % 2 == 0
                                  ? Colors.indigo
                                  : Colors
                                      .orange, // Alternance de couleur de l'icône
                            ),
                            title: Text(
                              'TP$i',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              // color: Colors.grey.shade600,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                text: "TP",
              ),
            ],
          ),
        ),
        body: [
          Accueil(),
          const Dispositif(),
          TP1Page(),
          TP2Page(),
          TP3Page(),
          TP4Page(),
          TP5Page(),
          TP6Page(),
          TP7Page(),
          TP8Page(),
          TP9Page(),
          Tp10Page(),
          Tp11Page(),
          SettingsPage(),
          const Historique()
        ][_currentIndex]);
  }
}
