enum UnionIMEvent {
  /// 初始化成功
  ON_INIT_SUCCESS,

  /// 初始化失败
  ON_INIT_FAIL,

  /// 登录成功
  ON_LOGIN_SUCCESS,

  /// 登录失败
  ON_LOGIN_FAIL,

  /// 踢出下线
  ON_KICKOUT,

  /// 认证过期
  ON_AUTH_EXPIRE;
}

enum UnionIMSysEvent {
  /// 好友申请请求
  ON_FRIEND_REQUEST,

  /// 添加好友反馈
  ON_ADD_FRIEND_FEEDBACK,

  /// 好友关系解除 (双向删除好友通知)
  ON_FRIEND_DELETED,

  /// 群组邀请通知
  ON_GROUPD_INVITE,

  /// 踢出群组通知
  ON_GROUPD_KICKOUT,

  /// 群组新成员进入
  ON_GROUPD_NEW_MEMBER,

  /// 群组创建成功
  ON_GROUP_CREATED,

  /// 群组解散
  ON_GROUP_DISSOLVE
}

enum UnionIMMessageEvent {
  /// 单点消息已读回执
  ON_CHAT_P2P_MESSAGE_RECEIPT,

  /// 单点消息接收
  ON_CHAT_P2P_MESSAGE_RECEIVED,

  /// 群组消息接收
  ON_CHAT_GROUP_MESSAGE_RECEIVED,
}
