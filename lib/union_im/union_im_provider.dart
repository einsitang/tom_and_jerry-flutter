import 'model/union_im_message.dart';

abstract class UnionIMProvider {
  bool get isInitialized;

  /// 初始化
  init(Map<String, String>? options);

  /// 登录
  login(String account, {Map<String, Object>? options});

  String? get loginAccount;

  bool get isLogin;

  /// 注销
  logout();

  /// 发送消息 同步
  bool sendMessageSync(UnionIMMessage message);

  /// 发送消息
  Future<bool> sendMessage(UnionIMMessage message);

  /// 创建群组
  /// 申请加入群组
  /// 退出群组
  /// 移除群组成员
  /// 添加群组成员
  /// 查看群组资料
  /// 获取群组所有成员信息
  /// 查看好友/用户信息
  /// 申请添加好友
  /// 删除好友
  /// 历史消息查询

  /// 消息监听
  onListener(UnionIMListener listener);

  onSysListener(UnionIMSysListener listener);

  onMessageListener(UnionIMMessageListener listener);
}

class UnionIMSysListener {
  final Function() onFriendRequest;
  final Function() onAddFriendFeedBack;
  final Function() onFriendDeleted;
  final Function() onGroupInvite;
  final Function() onGroupKickout;
  final Function() onGroupCreated;
  final Function() onGroupNewMember;
  final Function() onGroupDissolve;

  UnionIMSysListener(
      {required this.onFriendRequest,
      required this.onAddFriendFeedBack,
      required this.onFriendDeleted,
      required this.onGroupInvite,
      required this.onGroupKickout,
      required this.onGroupCreated,
      required this.onGroupNewMember,
      required this.onGroupDissolve});
}

class UnionIMListener {
  final Function() onInitSuccess;
  final Function(String? errorDetails) onInitFail;
  final Function(String account) onLoginSuccess;
  final Function(String? errorDetails) onLoginFail;
  final Function(String account) onLogout;
  final Function() onKickout;
  final Function() onAuthExpire;

  UnionIMListener(
      {required this.onInitSuccess,
      required this.onInitFail,
      required this.onLoginSuccess,
      required this.onLoginFail,
      required this.onLogout,
      required this.onKickout,
      required this.onAuthExpire});
}

class UnionIMMessageListener {
  final Function() onChatP2PMessageReceipt;
  final Function(List<UnionIMMessage> messages) onChatP2PMessageReceived;
  final Function() onChatGroupMessageReceived;

  UnionIMMessageListener(
      {required this.onChatP2PMessageReceipt,
      required this.onChatP2PMessageReceived,
      required this.onChatGroupMessageReceived});
}
