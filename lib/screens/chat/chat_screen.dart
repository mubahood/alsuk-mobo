import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../../../controllers/MainController.dart';
import '../../../../../models/RespondModel.dart';
import '../../../../../utils/AppConfig.dart';
import '../../../models/ChatHead.dart';
import '../../../models/ChatMessage.dart';
import '../../../models/Product.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

// NOTE: This file only contains UI changes. The core logic remains identical
// to what you provided to ensure functionality is not broken.

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> params;

  const ChatScreen(this.params, {Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // ================================================================
  // === ALL LOGIC AND STATE VARIABLES ARE UNCHANGED FROM YOUR CODE ===
  // ================================================================
  ChatHead chatHead = ChatHead();
  late Product product;
  late ScrollController _scrollC;
  late TextEditingController _txtC;
  late FocusNode _focusNode;

  final MainController _mainC = Get.find<MainController>();
  final List<String> _menuChoices = ['Delete chat'];
  final List<Timer> _timers = [];

  List<ChatMessage> _msgs = [];
  bool _inputEmpty = true, _showAttach = false;
  bool _disposed = false, _listenerBusy = false;
  late Future<void> _initFuture;
  late AnimationController _fadeC;

  @override
  void initState() {
    super.initState();
    _scrollC = ScrollController();
    String start_message =
        widget.params['start_message']?.toString().trim() ?? '';

    _txtC = TextEditingController(text: start_message)
      ..addListener(() => setState(() => _inputEmpty = _txtC.text.isEmpty));

    if (start_message.isNotEmpty) {
      _txtC.selection =
          TextSelection.fromPosition(TextPosition(offset: _txtC.text.length));
    }

    _focusNode = FocusNode();

    _fadeC = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..forward();

    _initFuture = _initialize();
  }

  @override
  void dispose() {
    _disposed = true;
    _scrollC.dispose();
    _txtC.dispose();
    _focusNode.dispose();
    _fadeC.dispose();
    for (var t in _timers) t.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    // THIS IS YOUR ORIGINAL LOGIC - UNCHANGED
    if (!widget.params.containsKey('receiver_id')) {
      Utils.toast('Receiver ID not found.');
      Get.back();
      return;
    }
    if (widget.params.containsKey('chatHead')) {
      if (widget.params['chatHead'].runtimeType == chatHead.runtimeType) {
        chatHead = widget.params['chatHead'];
        _markAsRead();
      }
    }

    String receiver_id = widget.params['receiver_id'];
    if (receiver_id.isEmpty) {
      Utils.toast('Receiver ID is empty.');
      Get.back();
      return;
    }
    if (_mainC.userModel.id < 1) {
      await _mainC.getLoggedInUser();
    }
    if (_mainC.userModel.id < 1) {
      Utils.toast('Logged in user not found.');
      Get.back();
      return;
    }

    String sender_id = _mainC.userModel.id.toString();
    if (sender_id.isEmpty) {
      Utils.toast('Sender ID is empty.');
      Get.back();
      return;
    }
    sender_id = sender_id.trim();
    receiver_id = receiver_id.trim();

    if (sender_id == receiver_id) {
      Utils.toast('Sender and receiver IDs are the same.');
      Get.back();
      return;
    }

    if (widget.params.containsKey('task')) {
      if (widget.params['task'] == 'PRODUCT_CHAT') {
        if (widget.params['product'].runtimeType != ((Product()).runtimeType)) {
          return;
        }
        product = widget.params['product'];
        String product_id = product.id.toString();

        List<ChatHead> temp_chats = await ChatHead.get_items(_mainC.userModel,
            where:
                ' product_owner_id = $receiver_id AND customer_id = $sender_id AND product_id = $product_id ');
        if (temp_chats.isEmpty) {
          temp_chats = await ChatHead.get_items(_mainC.userModel,
              where:
                  ' product_owner_id = $sender_id AND customer_id = $receiver_id AND product_id = $product_id ');
          if (temp_chats.isNotEmpty) {
            chatHead = temp_chats[0];
          }
        } else {
          chatHead = temp_chats[0];
        }
      }
    } else if (chatHead.id < 1) {
      List<ChatHead> temp_chats = await ChatHead.get_items(_mainC.userModel,
          where:
              ' product_owner_id = $receiver_id AND customer_id = $sender_id');
      if (temp_chats.isEmpty) {
        temp_chats = await ChatHead.get_items(_mainC.userModel,
            where:
                ' product_owner_id = $sender_id AND customer_id = $receiver_id');
        if (temp_chats.isNotEmpty) {
          chatHead = temp_chats[0];
        }
      } else {
        chatHead = temp_chats[0];
      }
    }

    if (mounted) setState(() {});

    _markAsRead();

    if (chatHead.id < 1) {
      await _startChat();
      if (chatHead.id < 1) {
        Utils.toast2('Failed to start chat');
        if (mounted) Get.back();
        return;
      }
    }

    _msgs = await ChatMessage.get_items(
      _mainC.userModel,
      where: 'chat_head_id = ${chatHead.id}',
    )
      ..sort((a, b) => a.id.compareTo(b.id));

    _markAsRead();

    _pollLoop();
    if (mounted) setState(() {});

    _scrollToBottom();
  }

  Future<void> _startChat() async {
    // THIS IS YOUR ORIGINAL LOGIC - UNCHANGED
    if (chatHead.id > 0) {
      if (mounted) setState(() {});
      return;
    }

    String? product_id;
    if (widget.params['product'] is Product) {
      product = widget.params['product'];
      product_id = product.id.toString();
    }

    if (!await Utils.is_connected()) {
      Utils.toast2('No internet connection');
      return;
    }

    RespondModel? resp;
    Utils.showLoader(false);
    try {
      resp = RespondModel(
        await Utils.http_post('chat-start', {
          'sender_id': _mainC.userModel.id.toString(),
          'receiver_id': widget.params['receiver_id'],
          'product_id': product_id ?? '',
        }),
      );
    } catch (e) {
      Utils.toast('Failed to start chat because: $e');
      if (mounted) Get.back();
      return;
    } finally {
      Utils.hideLoader();
    }

    if (resp.code != 1) {
      Utils.toast(resp.message);
      if (mounted) Get.back();
      return;
    }

    ChatHead tempHead = ChatHead.fromJson(resp.data);
    if (tempHead.id < 1) {
      Utils.toast('Failed to parse chat');
      if (mounted) Get.back();
      return;
    }
    chatHead = tempHead;
    _markAsRead();
    if (mounted) setState(() {});
  }

  // ALL OTHER LOGIC METHODS (_markAsRead, _pollLoop, _sendMessage, etc.) ARE UNCHANGED.
  Future<void> _markAsRead() async {
    if (chatHead.id < 1) return;
    await Utils.http_post('chat-mark-as-read', {
      'receiver_id': _mainC.userModel.id.toString(),
      'chat_head_id': chatHead.id.toString(),
    });
  }

  void _pollLoop() {
    if (_disposed || _listenerBusy) return;
    _listenerBusy = true;
    ChatMessage.getOnlineItems(
      _mainC.userModel,
      params: {'chat_head_id': chatHead.id, 'doDeleteAll': true},
    ).then((_) async {
      final all = await ChatMessage.getLocalData(_mainC.userModel,
          where: 'chat_head_id = ${chatHead.id}')
        ..sort((a, b) => a.id.compareTo(b.id));
      if (all.length > _msgs.length) {
        if (mounted) setState(() => _msgs = all);
        _scrollToBottom();
      }
      _listenerBusy = false;
      if (!_disposed) Future.delayed(const Duration(seconds: 5), _pollLoop);
    });
  }

  Future<void> _onRefresh() => _initialize();

  Future<void> _sendMessage() async {
    final text = _txtC.text.trim();
    if (text.isEmpty) return;

    final me = _mainC.userModel.id.toString();
    final other = me == chatHead.product_owner_id
        ? chatHead.customer_id
        : chatHead.product_owner_id;

    ChatMessage msg = ChatMessage()
      ..chat_head_id = chatHead.id.toString()
      ..sender_id = me
      ..receiver_id = other
      ..body = text
      ..type = 'text'
      ..created_at = DateTime.now().toIso8601String()
      ..updated_at = DateTime.now().toIso8601String()
      ..isMyMessage = true;

    _txtC.clear();
    setState(() {
      _inputEmpty = true;
      _showAttach = false;
      _msgs.add(msg);
    });

    _scrollToBottom();
    _focusNode.requestFocus();
    await msg.save();
    doSendMessage(msg);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollC.hasClients) {
        _scrollC.animateTo(_scrollC.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  Future<void> doSendMessage(ChatMessage msg) async {
    final err = await msg.uploadSelf(_mainC.userModel);
    if (err.isNotEmpty) Utils.toast('FAILED: to send message: $err');
  }

  // ================================================================
  // =================== NEW, REDESIGNED UI BELOW ===================
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A light, off-white background for a clean look
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _initFuture,
              builder: (_, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Main message list with background texture
                return Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/chat_bg.png'),
                      fit: BoxFit.cover,
                      opacity: 0.05,
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: CustomTheme.primary,
                    child: ListView.builder(
                      // Use ListView.builder for better performance
                      controller: _scrollC,
                      padding: const EdgeInsets.all(16),
                      itemCount: _msgs.length,
                      itemBuilder: (_, i) => ScaleTransition(
                        scale: _fadeC,
                        child: _buildBubble(_msgs[i]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    final otherUser = chatHead.getOtherUser(_mainC.userModel);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: theme.colorScheme.onBackground,
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(
          FeatherIcons.arrowLeft,
          color: CustomTheme.primary,
        ),
        onPressed: () => Get.back(),
      ),
      leadingWidth: 50,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: (otherUser['photo'] != null &&
                      otherUser['photo']!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: Utils.getImageUrl(otherUser['photo']),
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      errorWidget: (context, url, error) => const Icon(
                          FeatherIcons.user,
                          size: 20,
                          color: Colors.grey),
                    )
                  : const Icon(FeatherIcons.user, size: 20, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                otherUser['name'] ?? 'Chat',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Online", // This can be made dynamic later
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.green.shade600),
              ),
            ],
          )
        ],
      ),
      actions: [
        IconButton(
            icon: const Icon(FeatherIcons.moreVertical), onPressed: () {}),
      ],
    );
  }

  Widget _buildBubble(ChatMessage m) {
    final me = m.isMyMessage;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.75),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
                color: me ? CustomTheme.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(me ? 16 : 0),
                  bottomRight: Radius.circular(me ? 0 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  m.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: me ? Colors.white : theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Utils.timeAgo(m.created_at, short: true),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: me ? Colors.white70 : Colors.grey.shade500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom + 8),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5))
      ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /*  IconButton(
            icon: Icon(FeatherIcons.paperclip, color: Colors.grey.shade600),
            onPressed: () => setState(() => _showAttach = !_showAttach),
          ),*/
          Expanded(
            child: TextField(
              controller: _txtC,
              focusNode: _focusNode,
              minLines: 1,
              maxLines: 5,
              autocorrect: true,
              enableSuggestions: true,
              onChanged: (text) {
                setState(() {
                  _inputEmpty = text.trim().isEmpty;
                });
              },
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Type a message...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: _inputEmpty ? null : _sendMessage,
            backgroundColor:
                _inputEmpty ? Colors.grey.shade300 : CustomTheme.primary,
            elevation: 0,
            child: Icon(FeatherIcons.send, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}
