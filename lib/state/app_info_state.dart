import 'package:scoped_model/scoped_model.dart';
import 'package:tom_and_jerry/model/app_info_model.dart';

class AppInfoState extends Model {
  final AppInfoModel _state;

  AppInfoState(this._state);

  AppInfoModel get state => _state;

  updateLoginAuth(LoginAuth loginAuth) {
    _state.loginAuth = loginAuth;
    notifyListeners();
  }

  updateUserProfile(UserProfile userProfile) {
    _state.userProfile = userProfile;
    notifyListeners();
  }
}
