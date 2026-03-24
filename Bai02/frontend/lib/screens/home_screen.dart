import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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
  Widget build(BuildContext context) {
    final mutedText = Theme.of(context)
        .colorScheme
        .onBackground
        .withOpacity(0.6);
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
          child: CustomScrollView(
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
                            child: const Icon(Icons.person, color: AppTheme.primary)
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
                  child: _SectionHeader(title: "Featured", actionLabel: "View all")
                )
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 230,
                  child: ListView(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _FeaturedCard(
                        title: "The Silent Library",
                        author: "A. Hemsworth",
                        price: "12.90"
                      ),
                      _FeaturedCard(
                        title: "City of Pages",
                        author: "L. Bennett",
                        price: "14.50"
                      ),
                      _FeaturedCard(
                        title: "Moonlight Ink",
                        author: "R. Alcott",
                        price: "11.20"
                      )
                    ]
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                  child: _SectionHeader(title: "Categories", actionLabel: "Explore")
                )
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 46,
                  child: ListView(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _CategoryChip(label: "Romance"),
                      _CategoryChip(label: "Science"),
                      _CategoryChip(label: "Business"),
                      _CategoryChip(label: "Fantasy"),
                      _CategoryChip(label: "Children"),
                      _CategoryChip(label: "Self-help")
                    ]
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                  child: _SectionHeader(title: "Best sellers", actionLabel: "More")
                )
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  const [
                    _BookListItem(
                      title: "Design for Real Life",
                      author: "J. Morgan",
                      price: "18.00"
                    ),
                    _BookListItem(
                      title: "Startup Compass",
                      author: "V. Carter",
                      price: "16.40"
                    ),
                    _BookListItem(
                      title: "Mindful Steps",
                      author: "N. Kapoor",
                      price: "10.60"
                    ),
                    SizedBox(height: 120)
                  ]
                )
              )
            ]
          )
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

  const _FeaturedCard({
    required this.title,
    required this.author,
    required this.price
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
            child: const Center(
              child: Icon(Icons.auto_stories, size: 40, color: Colors.white)
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

  const _BookListItem({
    required this.title,
    required this.author,
    required this.price
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
            child: const Icon(Icons.menu_book, color: AppTheme.accent)
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
