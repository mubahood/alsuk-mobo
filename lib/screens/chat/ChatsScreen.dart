import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/MainController.dart';
import '../../../models/ChatHead.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/Utils.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final MainController mainController = Get.find<MainController>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<ChatHead> _allHeads = [];
  bool _loading = true;
  bool _showSearch = false;
  String _searchQuery = '';
  Timer? _pollingTimer;
  bool _showAppBarBorder = false;

  List<ChatHead> get _filteredHeads {
    if (!_showSearch || _searchQuery.isEmpty) return _allHeads;
    final q = _searchQuery.toLowerCase();
    return _allHeads.where((h) {
      final otherUserName =
          (mainController.userModel.id.toString() == h.customer_id
                  ? h.product_owner_name
                  : h.customer_name)
              .toLowerCase();
      return otherUserName.contains(q) ||
          h.last_message_body.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(
        () => setState(() {})); // To update clear button visibility
    _loadHeads();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 10 && !_showAppBarBorder) {
      setState(() => _showAppBarBorder = true);
    } else if (_scrollController.offset <= 10 && _showAppBarBorder) {
      setState(() => _showAppBarBorder = false);
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (mounted) _loadHeads(isPolling: true);
    });
  }

  Future<void> _loadHeads({bool isPolling = false}) async {
    if (!isPolling && _allHeads.isEmpty) {
      setState(() => _loading = true);
    }
    await mainController.getLoggedInUser();
    final heads = await ChatHead.get_items(mainController.userModel);
    if (mounted) {
      setState(() {
        _allHeads = heads;
        _loading = false;
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      if (_showSearch) {
        _searchQuery = '';
        _searchController.clear();
      }
      _showSearch = !_showSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.red,
        foregroundColor: AppTheme.theme.colorScheme.onBackground,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 1.0,
            color:
                _showAppBarBorder ? Colors.grey.shade300 : Colors.transparent,
          ),
        ),
        toolbarHeight: 0,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: IconButton(
              key: ValueKey(_showSearch),
              icon: Icon(
                _showSearch ? FeatherIcons.xCircle : FeatherIcons.search,
                color: CustomTheme.primary,
              ),
              tooltip: _showSearch ? "Close search" : "Search messages",
              onPressed: _toggleSearch,
              splashRadius: 22,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 15,
              top: 10,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _showSearch
                  ? _buildSearchField()
                  : Row(
                      children: [
                        Icon(
                          FeatherIcons.messageCircle,
                          color: CustomTheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Messages",
                          key: const ValueKey('title'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.theme.colorScheme.onBackground,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const Spacer(),
                        // add _showSearch toggle button
                        InkWell(
                          onTap: _toggleSearch,
                          borderRadius: BorderRadius.circular(22),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              _showSearch
                                  ? FeatherIcons.x
                                  : FeatherIcons.search,
                              color: CustomTheme.primary,
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
          Divider(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return _buildShimmerList();
    if (_filteredHeads.isEmpty) return _buildEmptyState();

    return RefreshIndicator(
      color: CustomTheme.primary,
      onRefresh: () => _loadHeads(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 0),
        itemCount: _filteredHeads.length,
        itemBuilder: (ctx, i) => _ChatListItem(
          head: _filteredHeads[i],
          mainController: mainController,
          onTap: () async {
            await Get.to(() => ChatScreen({
                  'chatHead': _filteredHeads[i],
                  'receiver_id': _getOtherUserId(_filteredHeads[i]),
                  'sender_id': mainController.userModel.id.toString(),
                }));
            _loadHeads(isPolling: true);
          },
        ),
      ),
    );
  }

  String _getOtherUserId(ChatHead head) {
    return (mainController.userModel.id.toString() == head.customer_id)
        ? head.product_owner_id
        : head.customer_id;
  }

  Widget _buildSearchField() {
    return SizedBox(
      key: const ValueKey('search'),
      height: 32,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hintText: "Search messages...",
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(FeatherIcons.x, size: 18),
                    )
                  : null,
            ),
          ),
          IconButton(
            icon: const Icon(FeatherIcons.xCircle, size: 20),
            tooltip: "Close search",
            onPressed: _toggleSearch,
            splashRadius: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const CircleAvatar(radius: 28, backgroundColor: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 16,
                        width: 120,
                        color: Colors.white,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 8),
                    Container(
                        height: 14,
                        width: 200,
                        color: Colors.white,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FeatherIcons.messageCircle,
                color: Colors.grey.shade300, size: 80),
            const SizedBox(height: 24),
            Text(
              _showSearch ? "No Results Found" : "No Messages Yet",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _showSearch
                  ? "Try searching for something else."
                  : "When you start a conversation, it will appear here.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _loadHeads(),
              icon: const Icon(FeatherIcons.refreshCw, size: 16),
              label: const Text("Refresh"),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// A dedicated widget for a single chat list item for better readability and performance.
class _ChatListItem extends StatelessWidget {
  final ChatHead head;
  final MainController mainController;
  final VoidCallback onTap;

  const _ChatListItem(
      {required this.head, required this.mainController, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amICustomer =
        mainController.userModel.id.toString() == head.customer_id;
    final otherUserName =
        amICustomer ? head.product_owner_name : head.customer_name;
    final otherUserPhoto =
        amICustomer ? head.product_owner_photo : head.customer_photo;
    final unreadCount = head.myUnread(mainController.userModel);
    final isUnread = unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 5,
        ),
        color: isUnread
            ? CustomTheme.primary.withOpacity(0.05)
            : Colors.transparent,
        child: Row(
          children: [
            // =======================================================
            // === NEW AVATAR LOGIC WITH DEFAULT IMAGE FALLBACK ===
            // =======================================================
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: (otherUserPhoto != null && otherUserPhoto.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: Utils.getImageUrl(head.product_photo),
                        fit: BoxFit.cover,
                        width: 56,
                        height: 56,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (context, url, error) =>
                            _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
            const SizedBox(width: 10), // Increased spacing slightly
            // Name, Message, and Timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Unread Indicator Dot
                      if (isUnread)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 9,
                          width: 9,
                          decoration: const BoxDecoration(
                            color: CustomTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      // User Name
                      Expanded(
                        child: Text(
                          otherUserName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight:
                                isUnread ? FontWeight.bold : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Timestamp
                      Text(
                        Utils.timeAgo(head.last_message_time),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isUnread
                              ? CustomTheme.primary
                              : Colors.grey.shade500,
                          fontWeight:
                              isUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  // Last Message Snippet
                  Padding(
                    padding: EdgeInsets.only(left: isUnread ? 17 : 0),
                    // Aligns with name
                    child: Text(
                      head.last_message_body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isUnread
                            ? theme.colorScheme.onBackground.withOpacity(0.9)
                            : Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the default avatar
  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(
        FeatherIcons.user,
        color: Colors.grey.shade400,
        size: 32,
      ),
    );
  }
}
/*
*
Check out this product on Al Suk!

Garmin Forerunner 245
Price: UGX 40,000

Get the app here: https://app.alsukssd.com
* * */