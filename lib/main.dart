import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tom_and_jerry/page/home.dart';
import 'package:tom_and_jerry/provider/app_info_provider.dart';
import 'package:tom_and_jerry/provider/isar/app_info_isar_provider.dart';
import 'package:tom_and_jerry/state/app_info_state.dart';

import 'model/app_info_model.dart';

final Logger log = Logger();

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
        // 修改 highlightColor 和 splashColor 移除 material 按钮特效
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        // primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        // 修改 highlightColor 和 splashColor 移除 material 按钮特效
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const HomePage homePage = HomePage(title: "home");

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    AppInfoProvider appInfoProvider = AppInfoIsarProvider();
    Future<AppInfoState> loadState() async {
      AppInfoModel appInfoModel = await appInfoProvider.appInfo;
      return AppInfoState(appInfoModel);
    }

    FutureBuilder futureBuilder = FutureBuilder<AppInfoState>(
        future: loadState(),
        builder: (context, AsyncSnapshot<AppInfoState> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                color: Colors.white, child: const Text("Loading..."));
          }

          if (snapshot.hasError) {
            log.e(snapshot.error);
            log.e(snapshot.stackTrace);
          }

          return ScopedModel(model: snapshot.data!, child: homePage);
        });

    return futureBuilder;
  }
}
