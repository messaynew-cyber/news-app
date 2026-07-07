import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  // Replace with your own key from https://newsapi.org
  static const String _apiKey = 'YOUR_NEWSAPI_KEY';
  static const String _baseUrl = 'https://newsapi.org/v2';

  static const List<Map<String, String>> categories = [
    {'id': 'general', 'label': 'Top'},
    {'id': 'business', 'label': 'Business'},
    {'id': 'technology', 'label': 'Tech'},
    {'id': 'sports', 'label': 'Sports'},
    {'id': 'entertainment', 'label': 'Entertainment'},
    {'id': 'science', 'label': 'Science'},
    {'id': 'health', 'label': 'Health'},
  ];

  static Future<List<Article>> fetchTopHeadlines({
    String category = 'general',
    String? query,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, String>{
      'apiKey': _apiKey,
      'country': 'us',
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };

    if (query != null && query.isNotEmpty) {
      params['q'] = query;
      params.remove('country');
    } else {
      params['category'] = category;
    }

    final uri = Uri.parse('$_baseUrl/top-headlines').replace(queryParameters: params);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['articles'] as List)
            .map((a) => Article.fromJson(a))
            .where((a) => a.title.isNotEmpty && a.url.isNotEmpty)
            .toList();
        return articles;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
