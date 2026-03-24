import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late Future<ApiResult> _homeFuture;

  void _onNavTap(int index) {
    if (index == 0) {
      setState(() => _currentIndex = index);
      return;
    }
    if (index == 1) {
      Navigator.pushNamed(context, "/profile");
      return;
    }
    if (index == 2) {
      Navigator.pushNamed(context, "/settings");
    }
  }

  @override
  void initState() {
    super.initState();
    _homeFuture = ApiClient().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.add),
        label: const Text("New"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings"
          )
        ]
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient(
            Theme.of(context).brightness
          )
        ),
        child: SafeArea(
          child: FutureBuilder<ApiResult>(
            future: _homeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data?.success != true) {
                return _ErrorState(
                  message: snapshot.data?.message ?? "Failed to load home data",
                  onRetry: () => setState(
                    () => _homeFuture = ApiClient().fetchHomeData()
                  )
                );
              }

              final data = snapshot.data!.data;
              final categories = List<Map<String, dynamic>>.from(
                data["categories"] ?? []
              );
              final featured = List<Map<String, dynamic>>.from(
                data["featured"] ?? []
              );
              final bestSellers = List<Map<String, dynamic>>.from(
                data["bestSellers"] ?? []
              );

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, Reader",
                                  style: Theme.of(context).textTheme.titleLarge
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Find your next favorite book",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(0.6)
                                      )
                                )
                              ]
                            )
                          ),
                          const SizedBox(width: 12),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppTheme.secondary.withOpacity(0.2),
                                child: const Icon(
                                  Icons.person,
                                  color: AppTheme.primary
                                )
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.accent,
                                    shape: BoxShape.circle
                                  )
                                )
                              )
                            ]
                          )
                        ]
                      )
                    )
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _SearchBar()
                    )
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                      child: _SectionHeader(
                        title: "Featured",
                        actionLabel: "View all"
                      )
                    )
                  ),
                  if (featured.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("No featured books yet")
                      )
                    )
                  else
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 230,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: featured.length,
                          itemBuilder: (context, index) {
                            final book = featured[index];
                            return _FeaturedCard(
                              title: book["title"]?.toString() ?? "",
                              author: book["author"]?.toString() ?? "",
                              price: book["price"]?.toString() ?? "",
                              imageUrl: book["cover_image"]?.toString()
                            );
                          }
                        )
                      )
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                      child: _SectionHeader(
                        title: "Categories",
                        actionLabel: "Explore"
                      )
                    )
                  ),
                  if (categories.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("No categories available")
                      )
                    )
                  else
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 46,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return _CategoryChip(
                              label: category["name"]?.toString() ?? ""
                            );
                          }
                        )
                      )
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                      child: _SectionHeader(
                        title: "Best sellers",
                        actionLabel: "More"
                      )
                    )
                  ),
                  if (bestSellers.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("No books found")
                      )
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == bestSellers.length) {
                            return const SizedBox(height: 120);
                          }
                          final book = bestSellers[index];
                          return _BookListItem(
                            title: book["title"]?.toString() ?? "",
                            author: book["author"]?.toString() ?? "",
                            price: book["price"]?.toString() ?? "",
                            imageUrl: book["cover_image"]?.toString()
                          );
                        },
                        childCount: bestSellers.length + 1
                      )
                    )
                ]
              );
            }
          )
        )
      )
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text("Retry"))
          ]
        )
      )
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mutedText = Theme.of(context)
        .colorScheme
        .onBackground
        .withOpacity(0.6);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 8)
          )
        ]
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Search for books, authors...",
              style: TextStyle(color: mutedText)
            )
          ),
          Icon(Icons.tune, color: Theme.of(context).iconTheme.color)
        ]
      )
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;

  const _SectionHeader({required this.title, required this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
        ),
        Text(actionLabel, style: const TextStyle(color: AppTheme.secondary))
      ]
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final String title;
  final String author;
  final String price;
  final String? imageUrl;

  const _FeaturedCard({
    required this.title,
    required this.author,
    required this.price,
    this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    final mutedText = Theme.of(context)
        .colorScheme
        .onBackground
        .withOpacity(0.6);
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 10)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(14)
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl == null || imageUrl!.isEmpty
                ? const Center(
                    child: Icon(
                      Icons.auto_stories,
                      size: 40,
                      color: Colors.white
                    )
                  )
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 40,
                          color: Colors.white
                        )
                      );
                    }
                  )
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600)
          ),
          const SizedBox(height: 4),
          Text(author, style: TextStyle(color: mutedText)),
          const Spacer(),
          Text(
            "\$${price}",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.accent
            )
          )
        ]
      )
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 6)
          )
        ]
      ),
      child: Text(label)
    );
  }
}

class _BookListItem extends StatelessWidget {
  final String title;
  final String author;
  final String price;
  final String? imageUrl;

  const _BookListItem({
    required this.title,
    required this.author,
    required this.price,
    this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    final mutedText = Theme.of(context)
        .colorScheme
        .onBackground
        .withOpacity(0.6);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8)
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12)
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl == null || imageUrl!.isEmpty
                ? const Icon(Icons.menu_book, color: AppTheme.accent)
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image_outlined,
                        color: AppTheme.accent
                      );
                    }
                  )
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600)
                ),
                const SizedBox(height: 4),
                Text(author, style: TextStyle(color: mutedText))
              ]
            )
          ),
          Text(
            "\$${price}",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.primary
            )
          )
        ]
      )
    );
  }
}
