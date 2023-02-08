import 'dart:io';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoRart',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'LoRart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _showCards = [];
  List allCards = [];
  double maxImageSize = 400;

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/cards.json');
    final data = await json.decode(response);
    setState(() {
      final allCards = data['units'];
      _showCards = List.from(allCards);
      //print('...number of items ${_all_cards.length}');
    });
  }

  final List _regions = [
    ['All', 'all'],
    ['Bandle City', 'bandlecity'],
    ['Bilgewater', 'bilgewater'],
    ['Demacia', 'demacia'],
    ['Freljord', 'freljord'],
    ['Ionia', 'ionia'],
    ['Noxus', 'noxus'],
    ['Piltover & Zaun', 'piltoverzaun'],
    ['Runeterra', 'runeterra'],
    ['Shadow Isles', 'shadowisles'],
    ['Shurima', 'shurima'],
    ['Targon', 'targon'],
  ];

  @override
  void initState() {
    readJson().then((value) {});
    super.initState();
  }

  void tmpFunction(int index) {
    if (allCards.isEmpty) {
      allCards = List.from(_showCards);
    }
    if (index == 0) {
      setState(() {
        _showCards = List.from(allCards);
      });
    } else {
      var tempList = [];
      setState(() {
        for (var i = 0; i < allCards.length; i++) {
          if (allCards[i]['regions'].contains(_regions[index][0])) {
            tempList.add(allCards[i]);
          }
        }
        _showCards = List.from(tempList);
      });
    }
  }

  Future<void> _launchUrl(String cardUrl) async {
    if (!await launchUrl(
      Uri.parse(cardUrl),
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $cardUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text('LoRart'),
            ),
            const ListTile(
              leading: Icon(Icons.update),
              title: Text('Update'),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              //onTap: _popupDialog,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Row(
        children: <Widget>[
          SizedBox(
            width: 50,
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //maxCrossAxisExtent: 30,
                crossAxisCount: 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: _regions.length,
              itemBuilder: (BuildContext context, index) {
                return Tooltip(
                  message: _regions[index][0],
                  waitDuration: const Duration(seconds: 1),
                  child: InkWell(
                    onTap: () => tmpFunction(index),
                    child: Image.asset(
                      'assets/img/regions/icon-' + _regions[index][1] + '.png',
                    ),
                  ),
                  /*child: Image.asset(
                    'assets/img/regions/icon-' + _regions[index][1] + '.png',
                  ),*/
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxImageSize,
                childAspectRatio: 2 / 1.4,
                //childAspectRatio: 2 / 1.02,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _showCards.length,
              itemBuilder: (BuildContext context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    children: [
                      Image.network(
                        _showCards[index]['img'],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        _showCards[index]['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        onPressed: () => _launchUrl(
                            _showCards[index]['img']),
                        child: Text('Open image in browser'),
                      )
                    ],
                  ),
                );
                /*return FillImageCard(
                  //heightImage: 120,
                  imageProvider: NetworkImage(
                    _showCards[index]['assets'][0]['fullAbsolutePath']
                  ),
                  title: Text(
                    _showCards[index]['name'],
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                );*/
                /*return TransparentImageCard(
                  contentMarginTop: 0,
                  //contentPadding: const EdgeInsets.only(bottom: 20),
                  width: 1000,
                  height: 500,
                  imageProvider: NetworkImage(
                      _showCards[index]['assets'][0]['fullAbsolutePath']),
                  title: Text(
                    _showCards[index]['name'],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  /*description: Text(
                    _showCards[index]['regions'].toString(),
                    style: const TextStyle(color: Colors.blue),
                  ),*/
                );*/
              },
            ),
          ),
        ],
      ),

      /*bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.zoom_out),
            label: 'Zoom out',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.zoom_in),
            label: 'Zoom in',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              print('Zoom out');
              setState(() {
                maxImageSize = maxImageSize - 20;
              });
              break;
            case 1:
              print('Zoom in');
              setState(() {
                maxImageSize = maxImageSize + 20;
              });
              break;
          }
        },
      ),*/
    );
  }
}
