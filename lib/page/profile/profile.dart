import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tom_and_jerry/state/app_info_state.dart';

final Logger log = Logger();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppInfoState get _appInfoState => ScopedModel.of<AppInfoState>(context);

  @override
  Widget build(BuildContext context) {
    log.d("profile page rebuild....");
    List<Widget> body = [
      ScopedModelDescendant<AppInfoState>(
          builder: (context, child, model) =>
              Text("isLogin : ${_appInfoState.state.loginAuth.isLogin}||")),
      Text("accessToken : ${_appInfoState.state.loginAuth.accessToken}"),
      TextButton(onPressed: () {}, child: const Text("click me"))
    ];

    return Row(children: body);
  }
}
