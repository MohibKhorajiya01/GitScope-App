import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/recent_searches_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _search() {
    final username = _controller.text.trim();
    if (username.isEmpty) return;
    _focusNode.unfocus();
    ref.read(recentSearchesProvider.notifier).add(username);
    context.push('/profile/$username');
  }

  @override
  Widget build(BuildContext context) {
    final recent = ref.watch(recentSearchesProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FA),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Pinned Small AppBar
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xFF161B22),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: 34,
                      height: 34,
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'GitScope',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Hero Header
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF161B22),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF30363D), width: 1),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explore GitHub\nProfiles & Repos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Search any GitHub username to explore their world.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Body Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Card
                    _SearchCard(
                      controller: _controller,
                      focusNode: _focusNode,
                      onSearch: _search,
                    ),
                    const SizedBox(height: 28),

                    // 1. Top Accounts (Popular)
                    _PopularSection(
                      onTap: (u) {
                        ref.read(recentSearchesProvider.notifier).add(u);
                        context.push('/profile/$u');
                      },
                    ),

                    // 2. Recent Searches (only if not empty)
                    if (recent.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      _RecentSearchesSection(
                        recents: recent,
                        onTap: (u) {
                          ref.read(recentSearchesProvider.notifier).add(u);
                          context.push('/profile/$u');
                        },
                        onRemove: (u) =>
                            ref.read(recentSearchesProvider.notifier).remove(u),
                        onClear: () =>
                            ref.read(recentSearchesProvider.notifier).clear(),
                      ),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Search Card Widget
class _SearchCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSearch;

  const _SearchCard({
    required this.controller,
    required this.focusNode,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0D7DE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF24292F),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.person_search_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Search Developer',
                style: TextStyle(
                  color: Color(0xFF1F2328),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => onSearch(),
                  style: const TextStyle(
                    color: Color(0xFF1F2328),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'GitHub username...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9198A1),
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.alternate_email_rounded,
                      size: 17,
                      color: Color(0xFF9198A1),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF6F8FA),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xFFD0D7DE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Color(0xFF24292F), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF24292F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.search_rounded, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Recent Searches Section
class _RecentSearchesSection extends StatelessWidget {
  final List<String> recents;
  final void Function(String) onTap;
  final void Function(String) onRemove;
  final VoidCallback onClear;

  const _RecentSearchesSection({
    required this.recents,
    required this.onTap,
    required this.onRemove,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Icon(Icons.history_rounded,
                size: 15, color: Color(0xFF656D76)),
            const SizedBox(width: 6),
            const Text(
              'Recent Searches',
              style: TextStyle(
                color: Color(0xFF1F2328),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onClear,
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: Color(0xFF656D76),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // List
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD0D7DE)),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recents.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Color(0xFFD0D7DE),
            ),
            itemBuilder: (context, index) {
              final username = recents[index];
              return InkWell(
                onTap: () => onTap(username),
                borderRadius: BorderRadius.vertical(
                  top: index == 0
                      ? const Radius.circular(10)
                      : Radius.zero,
                  bottom: index == recents.length - 1
                      ? const Radius.circular(10)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF24292F),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            username[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@$username',
                              style: const TextStyle(
                                color: Color(0xFF1F2328),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'Tap to view profile & repos',
                              style: TextStyle(
                                color: Color(0xFF9198A1),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 16, color: Color(0xFF9198A1)),
                        onPressed: () => onRemove(username),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Popular Section
class _PopularSection extends StatelessWidget {
  final void Function(String) onTap;

  const _PopularSection({required this.onTap});

  static const _users = [
    (username: 'torvalds', name: 'Linus Torvalds', desc: 'Linux creator'),
    (username: 'gaearon', name: 'Dan Abramov', desc: 'React core team'),
    (username: 'JakeWharton', name: 'Jake Wharton', desc: 'Android developer'),
    (username: 'sindresorhus', name: 'Sindre Sorhus', desc: 'Open source hero'),
    (username: 'tj', name: 'TJ Holowaychuk', desc: 'Express.js author'),
    (username: 'addyosmani', name: 'Addy Osmani', desc: 'Google Chrome team'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.people_outline_rounded,
                size: 15, color: Color(0xFF656D76)),
            SizedBox(width: 6),
            Text(
              'Popular Developers',
              style: TextStyle(
                color: Color(0xFF1F2328),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD0D7DE)),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _users.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Color(0xFFD0D7DE),
            ),
            itemBuilder: (context, index) {
              final u = _users[index];
              return InkWell(
                onTap: () => onTap(u.username),
                borderRadius: BorderRadius.vertical(
                  top: index == 0
                      ? const Radius.circular(10)
                      : Radius.zero,
                  bottom: index == _users.length - 1
                      ? const Radius.circular(10)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFF24292F),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            u.username[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${u.username}',
                              style: const TextStyle(
                                color: Color(0xFF1F2328),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              u.desc,
                              style: const TextStyle(
                                color: Color(0xFF9198A1),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: Color(0xFF9198A1),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

