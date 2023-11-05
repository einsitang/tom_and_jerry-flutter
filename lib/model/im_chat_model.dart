import 'package:isar/isar.dart';
import 'package:tom_and_jerry/common/fash_hash.dart';

part 'im_chat_model.g.dart';

@collection
class ImChatModel {
  String? id;

  Id get isarId => Tool.fastHash(id!);

  String? lastMessageId;

  String? lastMessageContent;

  DateTime? lastMessageTime;
}
