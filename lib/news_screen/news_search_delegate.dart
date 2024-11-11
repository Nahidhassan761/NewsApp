import 'package:flutter/material.dart';
import 'package:project_3/API/news_api.dart';
import 'package:project_3/News_Model/news_model.dart';
import 'package:project_3/news_screen/news_data.dart';


class NewsSearchDelegate extends SearchDelegate<String> {
  final NewsApi newsApi = NewsApi(); // Initialize your NewsApi

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.blue),
      onPressed: () {
        close(context, ''); // Close the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: newsApi.fetchSearchData(query), // Fetch search data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found for "$query"', style: TextStyle(color: Colors.grey)));
        }

        final results = snapshot.data!;
        return ListView.separated(
          itemCount: results.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
          itemBuilder: (context, index) {
            final news = results[index];
            return _buildNewsTile(news, context);
          },
        );
      },
    );
  }

  Widget _buildNewsTile(NewsModel news, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: news.urlToImage != null && news.urlToImage!.isNotEmpty
            ? Image.network(
          news.urlToImage!,
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 100,
              width: 100,
              color: Colors.grey.shade300,
              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ); // Display broken image icon
          },
        )
            : Container(
          height: 100,
          width: 100,
          color: Colors.grey.shade300,
          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
        ),
      ),
      title: Text(
        news.title ?? 'No Title',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            news.source?.name ?? 'Unknown Source',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
          ),
          Text(
            news.publishedAt != null
                ? _formatDate(news.publishedAt!)
                : 'Unknown Date',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      onTap: () {
        // Navigate to the NewsData screen with the selected news
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsData(newsModel: news), // Pass the whole news model
          ),
        );
      },
    );
  }

  // Helper function to format date
  String _formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions based on the current query
    final suggestions = ['Sport', 'Business', 'Travel', 'Video', 'Live', 'Weather']; // Example suggestions

    return ListView.separated(
      itemCount: suggestions.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion, style: TextStyle(fontWeight: FontWeight.w500)),
          onTap: () {
            query = suggestion; // Set query to suggestion and show results
            showResults(context);
          },
        );
      },
    );
  }
}
