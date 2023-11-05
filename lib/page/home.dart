import 'package:badges/badges.dart' as badges;
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tom_and_jerry/common/app_theme.dart';
import 'package:tom_and_jerry/page/im/im.dart';
import 'package:tom_and_jerry/page/map/map.dart';
import 'package:tom_and_jerry/page/profile/profile.dart';
import 'package:tom_and_jerry/state/app_info_state.dart';

final Logger log = Logger();

class HomePage extends StatefulWidget {
  static const String routeName = "/home";

  const HomePage(this.tab, {super.key, required this.title});

  final HomePageTab tab;
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class HomePageJumpPageNotification extends Notification {
  const HomePageJumpPageNotification({required this.tab});

  final HomePageTab tab;
}

enum HomePageTab {
  /// 地图 tab
  MAP(0),

  /// 即时聊天 TAB
  IM(1),

  /// 个人资料 TAB
  PROFILE(2);

  static const HomePageTab defaultTab = HomePageTab.IM;

  final int tabIndex;

  const HomePageTab(this.tabIndex);

  static of(int tabIndex) {
    if (tabIndex < 0 || tabIndex > HomePageTab.values.length - 1) {
      return defaultTab;
    }
    return HomePageTab.values[tabIndex];
  }
}

const ImPage imPage = ImPage(title: "Chat");
const MapPage mapPage = MapPage(title: "Map");
const ProfilePage profilePage = ProfilePage(title: "Profile");

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  late HomePageTab _tab;

  AppInfoState get _appInfoState => ScopedModel.of<AppInfoState>(context);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.tab.tabIndex);
    _tab = widget.tab;
  }

  jumpPage(HomePageTab tab) {
    setState(() {
      _tab = tab;
    });
    _pageController.jumpToPage(tab.tabIndex);
  }

  Widget _buildHomePage(BuildContext context) {
    final List<Widget> pages = [mapPage, imPage, profilePage];

    bool mapNotice = true;
    int imUnread = 8;
    bool profileNotice = false;

    CustomNavigationBar customNavigationBar = CustomNavigationBar(
      currentIndex: _tab.tabIndex,
      brightness: AppTheme.of(context).brightness,
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
        jumpPage(HomePageTab.of(page));
      },
    );

    DefaultTabController tabController = DefaultTabController(
        length: pages.length,
        child: Scaffold(
          bottomNavigationBar:
              Theme(data: AppTheme.of(context), child: customNavigationBar),
          body: PageView(
            controller: _pageController,
            // 禁止手势滑动
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
          ),
        ));

    return tabController;
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = _appInfoState.state.loginAuth.isLogin;
    if (isLogin) {
      log.d("未登录用户");
    }

    log.d("main page build");

    return NotificationListener<HomePageJumpPageNotification>(onNotification:
        (notification) {
      HomePageTab tab = notification.tab;
      jumpPage(tab);
      return true;
    }, child:
        ScopedModelDescendant<AppInfoState>(builder: (context, child, model) {
      return _buildHomePage(context);
    }));
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
