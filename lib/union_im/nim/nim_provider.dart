import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:nim_core/nim_core.dart';
import 'package:tom_and_jerry/union_im/model/union_im_chat.dart';
import 'package:tom_and_jerry/union_im/model/union_im_message.dart';
import 'package:tom_and_jerry/union_im/union_im_provider.dart';

final Logger log = Logger();

class NIMProvider extends UnionIMProvider {
  static const String NIM_APP_KEY = "NIM_APP_KEY";
  static const String NIM_LOGIN_TOKEN = "NIM_LOGIN_TOKEN";

  String? _account;

  final List<StreamSubscription> subscriptions = [];

  final UnionIMChatTypeMapping chatTypeMapping =
      UnionIMChatTypeMapping<NIMSessionType>();
  final UnionIMMessageTypeMapping messageTypeMapping =
      UnionIMMessageTypeMapping<NIMMessageType>();
  final UnionIMMessageDirectionMapping messageDirectionMapping =
      UnionIMMessageDirectionMapping<NIMMessageDirection>();

  UnionIMListener? _unionIMListener;
  UnionIMSysListener? _unionIMSysListener;
  UnionIMMessageListener? _unionIMMessageListener;

  NIMProvider() {
    chatTypeMapping
      ..register(NIMSessionType.p2p, UnionIMChatType.P2P)
      ..register(NIMSessionType.team, UnionIMChatType.GROUP)
      ..register(NIMSessionType.system, UnionIMChatType.SYSTEM);

    messageTypeMapping
      ..register(NIMMessageType.text, UnionIMMessageType.TEXT)
      ..register(NIMMessageType.audio, UnionIMMessageType.AUDIO)
      ..register(NIMMessageType.image, UnionIMMessageType.IMAGE);

    messageDirectionMapping
      ..register(NIMMessageDirection.outgoing, UnionIMMessageDirection.OUTGOING)
      ..register(
          NIMMessageDirection.received, UnionIMMessageDirection.RECEIVED);
  }

  static NIMProvider? _instance;

  static NIMProvider get instance => _instance ??= NIMProvider();

  @override
  bool get isInitialized => NimCore.instance.isInitialized;

  @override
  init(options) {
    String appKey = options![NIM_APP_KEY] as String;
    final NIMSDKOptions nimsdkOptions;
    if (Platform.isAndroid) {
      nimsdkOptions = NIMAndroidSDKOptions(
        appKey: appKey,

        /// 其他 通用/Android 配置
      );
    } else {
      nimsdkOptions = NIMIOSSDKOptions(
        appKey: appKey,

        /// 其他通用配置/iOS 配置
      );
    }
    if (!NimCore.instance.isInitialized) {
      NimCore.instance.initialize(nimsdkOptions).then((result) {
        if (result.isSuccess) {
          log.d("NIM SDK 初始化成功");
          _unionIMListener?.onInitSuccess();
          _registerMessageListener();
        } else {
          log.d("NIM SDK 初始化失败 : ${result.errorDetails}");
          _unionIMListener?.onInitFail(result.errorDetails);
        }
      });
    } else {
      _unionIMListener?.onInitSuccess();
    }
  }

  @override
  bool get isLogin => _account != null;

  @override
  String? get loginAccount => _account;

  _registerMessageListener() {
    StreamSubscription subscription = NimCore.instance.messageService.onMessage
        .listen((List<NIMMessage> list) {
      List<UnionIMMessage> messages = list.map<UnionIMMessage>((nimMessage) {
        UnionIMMessageType messageType =
            messageTypeMapping.match(nimMessage.messageType);
        return UnionIMMessage(
            chatId: nimMessage.sessionId!,
            chatType: chatTypeMapping.match(nimMessage.sessionType),
            fromAccount: nimMessage.fromAccount!,
            fromNickname: nimMessage.fromNickname!,
            messageType: messageType,
            timestamp:
                DateTime.fromMillisecondsSinceEpoch(nimMessage.timestamp),
            messageDirection:
                messageDirectionMapping.match(nimMessage.messageDirection));
      }).toList();
      _unionIMMessageListener?.onChatP2PMessageReceived(messages);
    });
    subscriptions.add(subscription);
  }

  _unregisterMessageListener() {
    for (StreamSubscription s in subscriptions) {
      s.cancel();
    }
  }

  @override
  login(String account, {Map<String, Object>? options}) {
    String token = options![NIM_LOGIN_TOKEN] as String;
    NimCore.instance.authService
        .login(NIMLoginInfo(account: account, token: token))
        .then((result) {
      if (result.isSuccess) {
        _account = account;
        _unionIMListener?.onLoginSuccess(account);
      } else {
        _unionIMListener?.onLoginFail(result.errorDetails);
      }
    });
  }

  @override
  logout() {
    NimCore.instance.authService.logout().then((result) {
      if (result.isSuccess) {
        _unionIMListener?.onLogout(_account ?? "");
        _account = null;
        _unregisterMessageListener();
      }
    });
  }

  @override
  onListener(UnionIMListener listener) {
    _unionIMListener = listener;
  }

  @override
  onMessageListener(UnionIMMessageListener listener) {
    _unionIMMessageListener = listener;
  }

  @override
  onSysListener(UnionIMSysListener listener) {
    _unionIMSysListener = listener;
  }

  @override
  Future<bool> sendMessage(message) async {
    final String sessionId = message.chatId;

    final NIMSessionType sessionType;
    switch (message.chatType) {
      case UnionIMChatType.GROUP:
        sessionType = NIMSessionType.team;
        break;
      case UnionIMChatType.P2P:
        sessionType = NIMSessionType.p2p;
        break;
      default:
        sessionType = NIMSessionType.p2p;
    }

    NIMResult<NIMMessage> nimMessageResult;
    switch (message.messageType) {
      case UnionIMMessageType.IMAGE:
        nimMessageResult = await MessageBuilder.createImageMessage(
            sessionId: sessionId,
            sessionType: sessionType,
            filePath: message.attachment!.filePath,
            fileSize: message.attachment!.fileSize);
        break;
      case UnionIMMessageType.AUDIO:
        nimMessageResult = await MessageBuilder.createAudioMessage(
            sessionId: sessionId,
            sessionType: sessionType,
            filePath: message.attachment!.filePath,
            fileSize: message.attachment!.fileSize,
            duration: message.attachment!.duration!.inSeconds);
        break;
      case UnionIMMessageType.TEXT:
      default:
        nimMessageResult = await MessageBuilder.createTextMessage(
            sessionId: sessionId,
            sessionType: sessionType,
            text: message.content!);
    }

    if (nimMessageResult.isSuccess) {
      var result = await NimCore.instance.messageService
          .sendMessage(message: nimMessageResult.data!);

      return result.isSuccess;
    }

    return false;
  }

  @override
  bool sendMessageSync(message) {
    throw UnsupportedError("NIM 不支持同步发送消息,请使用 sendMessage");
  }
}
