import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/news_service.dart';
import '../widgets/category_bar.dart';
import '../widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _selectedCategory = 'general';
  List<Article> _articles = [];
  bool _loading = true;
  String? _error;

  late AnimationController _staggerController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _staggerController,
      curve: Curves.easeOut,
    );
    _loadNews();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Future<void> _loadNews() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final articles =
          await NewsService.fetchTopHeadlines(category: _selectedCategory);
      if (mounted) {
        setState(() {
          _articles = articles;
          _loading = false;
        });
        _staggerController.forward(from: 0);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Failed to load news. Pull to retry.';
        });
      }
    }
  }

  void _changeCategory(String category) {
    if (category != _selectedCategory) {
      setState(() => _selectedCategory = category);
      _staggerController.reset();
      _loadNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadNews,
          color: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NewsApp',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _categoryLabel,
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.4),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.search_rounded,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                              size: 22),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: CategoryBar(
                    selected: _selectedCategory,
                    onChanged: _changeCategory,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: theme.colorScheme.outline.withOpacity(0.06),
                    height: 1,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              if (_loading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (_error != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.wifi_off_rounded,
                              size: 48,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.15)),
                          const SizedBox(height: 16),
                          Text(_error!,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.4),
                                fontSize: 15,
                              )),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final delay = (index * 0.06).clamp(0.0, 0.5);
                      return AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          final v = ((_fadeAnimation.value - delay) /
                                  (1.0 - delay))
                              .clamp(0.0, 1.0);
                          return Opacity(
                            opacity: v,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - v)),
                              child: NewsCard(
                                  article: _articles[index], index: index),
                            ),
                          );
                        },
                      );
                    },
                    childCount: _articles.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  String get _categoryLabel {
    final cat = NewsService.categories.firstWhere(
      (c) => c['id'] == _selectedCategory,
      orElse: () => {'label': 'Top'},
    );
    return '${cat['label']} Headlines';
  }
}
