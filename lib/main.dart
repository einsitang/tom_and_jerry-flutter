import 'package:flutter/material.dart';
import 'package:tom_and_jerry/page/im/im.dart';
import 'package:tom_and_jerry/page/map/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tom and Jerry',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const int defaultPageIndex = 1;

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = defaultPageIndex;

  @override
  Widget build(BuildContext context) {
    PageController pageController =
        PageController(initialPage: defaultPageIndex);

    const ImPage imPage = ImPage(title: "Chat");
    const MapPage mapPage = MapPage(title: "Map");
    const Icon page3 = Icon(Icons.person_outline);

    const List<Widget> pages = [mapPage, imPage, page3];

    return DefaultTabController(
        length: pages.length,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _pageIndex,
            items: const [
              BottomNavigationBarItem(label: 'Map', icon: Icon(Icons.map)),
              BottomNavigationBarItem(label: 'Chat', icon: Icon(Icons.chat)),
              BottomNavigationBarItem(
                  label: 'My', icon: Icon(Icons.person_outline)),
            ],
            onTap: (int page) {
              setState(() {
                _pageIndex = page;
              });
              pageController.jumpToPage(page);
            },
          ),
          body: PageView(
            controller: pageController,
            // 禁止手势滑动
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
          ),
        ));
  }
}
