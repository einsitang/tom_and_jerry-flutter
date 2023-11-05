import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tom_and_jerry/common/app_theme.dart';
import 'package:tom_and_jerry/model/app_info_model.dart';
import 'package:tom_and_jerry/page/home.dart';
import 'package:tom_and_jerry/provider/app_info_provider.dart';
import 'package:tom_and_jerry/provider/isar/app_info_isar_provider.dart';
import 'package:tom_and_jerry/state/app_info_state.dart';

final Logger log = Logger();

void main() {
  runApp(const MyApp());
}

const HomePage _homePage = HomePage(HomePageTab.defaultTab, title: "home");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String appTitle = "Tom And Jerry";

  final HomePage _homePage =
      const HomePage(HomePageTab.defaultTab, title: "home");

  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp(
      title: appTitle,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: StarterApp(title: appTitle),
      routes: <String, WidgetBuilder>{
        HomePage.routeName: (context) => _homePage
      },
    );

    return materialApp;
  }
}

class StarterApp extends StatefulWidget {
  const StarterApp({super.key, required this.title});

  final String title;

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
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
            /// 此处可以放加载页面，如果广告、动画界面
            return Container(color: Colors.white);
          }

          if (snapshot.hasError) {
            log.e(snapshot.error);
            log.e(snapshot.stackTrace);
          }

          return ScopedModel(model: snapshot.data!, child: _homePage);
        });

    return futureBuilder;
  }
}
