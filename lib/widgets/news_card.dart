import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/article.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final int index;

  const NewsCard({super.key, required this.article, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openArticle(context),
          borderRadius: BorderRadius.circular(16),
          splashColor: theme.colorScheme.primary.withOpacity(0.08),
          highlightColor: theme.colorScheme.primary.withOpacity(0.04),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.08),
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                  _buildImage(theme),
                // Text section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source & time row
                      Row(
                        children: [
                          if (article.sourceName != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                article.sourceName!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Icon(Icons.schedule,
                              size: 12,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.35)),
                          const SizedBox(width: 4),
                          Text(
                            article.timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.35),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          height: 1.3,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (article.description != null &&
                          article.description!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          article.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.55),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: article.urlToImage!,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: theme.colorScheme.onSurface.withOpacity(0.05),
          highlightColor: theme.colorScheme.onSurface.withOpacity(0.1),
          child: Container(color: theme.colorScheme.surface),
        ),
        errorWidget: (_, __, ___) => Container(
          color: theme.colorScheme.surface,
          child: Icon(Icons.image_outlined,
              size: 32, color: theme.colorScheme.onSurface.withOpacity(0.15)),
        ),
      ),
    );
  }

  void _openArticle(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ArticleDetailScreen(article: article),
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }
}

// -- Article Detail Screen --------------------------------------------

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_rounded,
                color: theme.colorScheme.onSurface, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.open_in_new_rounded,
                  color: theme.colorScheme.onSurface, size: 20),
            ),
            onPressed: () {
              // url_launcher would go here
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: theme.colorScheme.onSurface.withOpacity(0.05),
                    highlightColor:
                        theme.colorScheme.onSurface.withOpacity(0.1),
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(color: theme.colorScheme.surface)),
                  ),
                  errorWidget: (_, __, ___) => const SizedBox(),
                ),
              ),
            const SizedBox(height: 24),
            // Source & time
            Row(
              children: [
                if (article.sourceName != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      article.sourceName!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Icon(Icons.schedule,
                    size: 13,
                    color: theme.colorScheme.onSurface.withOpacity(0.35)),
                const SizedBox(width: 5),
                Text(
                  article.timeAgo,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withOpacity(0.35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              article.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
                height: 1.25,
                letterSpacing: -0.5,
              ),
            ),
            if (article.author != null && article.author!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'By ${article.author}',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Divider(
                color: theme.colorScheme.outline.withOpacity(0.08),
                height: 1),
            const SizedBox(height: 20),
            // Content
            if (article.content != null && article.content!.isNotEmpty)
              Text(
                article.content!.replaceAll(RegExp(r'\[\+\d+\s?chars\]'), ''),
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  height: 1.7,
                  letterSpacing: -0.1,
                ),
              ),
            if (article.description != null &&
                article.description!.isNotEmpty &&
                (article.content == null || article.content!.isEmpty))
              Text(
                article.description!,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  height: 1.7,
                  letterSpacing: -0.1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
