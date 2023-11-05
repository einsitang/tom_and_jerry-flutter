import 'package:tom_and_jerry/union_im/model/union_im_message.dart';

enum UnionIMChatType {
  /// 点对点
  P2P,

  /// 群组
  GROUP,

  /// 系统
  SYSTEM;

  const UnionIMChatType();
}

class UnionIMChatTypeMapping<T> {
  final Map<T, UnionIMChatType> mapper = {};

  register(T t, UnionIMChatType unionIMChatType) {
    mapper[t] = unionIMChatType;
  }

  match(T t) => mapper[t];
}

class UnionIMChat {
  String? id;
  final UnionIMChatType type;
  List<UnionIMMessage> messages = [];
  String? lastMessageId;
  String? lastMessageContent;
  DateTime? lastMessageTime;

  UnionIMChat(this.type,
      {this.id,
      messages,
      this.lastMessageId,
      this.lastMessageContent,
      this.lastMessageTime});
}
