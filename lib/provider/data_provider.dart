import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class DataProvider<T> {

  DataProvider({String? scope});

  String get scope;

  updateScope(String scope);

  static Future<String> dir({String? scope}) async {
    scope ??= "global";
    String baseDir = (await getApplicationDocumentsDirectory()).path;
    String dir = "$baseDir/global";
    Directory directory = Directory(dir);
    bool isExists = await directory.exists();
    if(!isExists){
      await directory.create(recursive:true);
    }
    return dir;
  }

  Future<T> db();
}
