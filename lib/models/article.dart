class Article {
  final String title;
  final String? author;
  final String? description;
  final String? urlToImage;
  final String url;
  final DateTime publishedAt;
  final String? sourceName;
  final String? content;

  Article({
    required this.title,
    this.author,
    this.description,
    this.urlToImage,
    required this.url,
    required this.publishedAt,
    this.sourceName,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'Untitled',
      author: json['author'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url'] ?? '',
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt']) ?? DateTime.now()
          : DateTime.now(),
      sourceName: json['source']?['name'],
      content: json['content'],
    );
  }

  String get timeAgo {
    final diff = DateTime.now().difference(publishedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${publishedAt.day}/${publishedAt.month}/${publishedAt.year}';
  }
}
