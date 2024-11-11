import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_3/News_Model/news_model.dart';


class NewsApi {
  // Your API key
  final String apiKey = '4a475ee9a8964055b8fe8b6eb9d13d48';

  // Everything API URL
  final String everythingApiUrl = 'https://newsapi.org/v2/everything?q=bitcoin&apiKey=4e205c462fdc4bccb7b2bf9e72ead59d';

  // Top Headlines API URL
  final String topHeadlinesApiUrl = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=4e205c462fdc4bccb7b2bf9e72ead59d';

  // Fetch everything (news about Bitcoin in this case)
  Future<List<NewsModel>> fetchEverythingNews() async {
    final response = await http.get(Uri.parse(everythingApiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> articles = jsonData['articles'];

      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Fetch top headlines
  Future<List<NewsModel>> fetchTopHeadlines() async {
    final response = await http.get(Uri.parse(topHeadlinesApiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> articles = jsonData['articles'];

      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  // Fetch news based on search query
  Future<List<NewsModel>> fetchSearchData(String query) async {
    // Construct the API URL for everything
    final String searchApiUrl = 'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey';

    final response = await http.get(Uri.parse(searchApiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> articles = jsonData['articles'];

      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }


}