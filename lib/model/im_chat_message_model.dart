import 'package:isar/isar.dart';
import 'package:tom_and_jerry/common/fash_hash.dart';

part 'im_chat_message_model.g.dart';

@collection
class ImChatMessageModel {
  String? id;

  Id get isarId => Tool.fastHash(id!);
}
