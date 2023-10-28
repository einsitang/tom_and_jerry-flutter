import 'package:badges/badges.dart' as badges;
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tom_and_jerry/page/profile/profile.dart';

import '../state/app_info_state.dart';
import 'im/im.dart';
import 'map/map.dart';

final Logger log = Logger();

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class HomePageJumpPageNotification extends Notification {
  const HomePageJumpPageNotification({required this.page});

  final int page;
}

const int defaultPageIndex = 1;

class _HomePageState extends State<HomePage> {
  int _pageIndex = defaultPageIndex;

  final PageController pageController =
      PageController(initialPage: defaultPageIndex);

  final ImPage imPage = const ImPage(title: "Chat");
  final MapPage mapPage = const MapPage(title: "Map");
  final ProfilePage profilePage = const ProfilePage(title: "Profile");

  AppInfoState get _appInfoState => ScopedModel.of<AppInfoState>(context);

  jumpPage(int page) {
    setState(() {
      _pageIndex = page;
    });
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = _appInfoState.state.loginAuth.isLogin;
    if (isLogin) {
      log.d("未登录用户");
    }

    log.d("main page build");

    final List<Widget> pages = [mapPage, imPage, profilePage];

    bool mapNotice = true;
    int imUnread = 8;
    bool profileNotice = false;

    CustomNavigationBar customNavigationBar = CustomNavigationBar(
      currentIndex: _pageIndex,
      items: [
        CustomNavigationBarItem(
            icon: ScopedModelDescendant<AppInfoState>(
                builder: (context, child, model) {
              return badges.Badge(
                  showBadge: _appInfoState.state.loginAuth.isLogin,
                  badgeContent: const Text("!",
                      style: TextStyle(fontSize: 11, color: Colors.white)),
                  child: const Icon(Icons.map));
            }),
            title: const Text("map",
                style: TextStyle(fontWeight: FontWeight.w300)),
            selectedTitle: const Text("Map",
                style: TextStyle(fontWeight: FontWeight.w600))),
        CustomNavigationBarItem(
            icon: badges.Badge(
                showBadge: imUnread > 0,
                badgeContent: Text("${imUnread > 99 ? 99 : imUnread}",
                    style: const TextStyle(fontSize: 11, color: Colors.white)),
                child: const Icon(Icons.chat)),
            title: const Text("chat",
                style: TextStyle(fontWeight: FontWeight.w300)),
            selectedTitle: const Text("Chat",
                style: TextStyle(fontWeight: FontWeight.w600))),
        CustomNavigationBarItem(
            icon: badges.Badge(
                showBadge: profileNotice,
                badgeContent: const Text("!",
                    style: TextStyle(fontSize: 11, color: Colors.white)),
                child: const Icon(Icons.person_outline)),
            title:
                const Text("my", style: TextStyle(fontWeight: FontWeight.w300)),
            selectedTitle:
                const Text("My", style: TextStyle(fontWeight: FontWeight.w600)))
      ],
      onTap: (int page) {
        setState(() {
          _pageIndex = page;
        });
        pageController.jumpToPage(page);
      },
    );

    DefaultTabController tabController = DefaultTabController(
        length: pages.length,
        child: Scaffold(
          bottomNavigationBar: customNavigationBar,
          body: PageView(
            controller: pageController,
            // 禁止手势滑动
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
          ),
        ));

    return NotificationListener<HomePageJumpPageNotification>(
        onNotification: (notification) {
          int page = notification.page;
          setState(() {
            _pageIndex = page;
          });

          pageController.jumpToPage(page);
          return true;
        },
        child: tabController);
  }
}
