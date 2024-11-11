// Search Results Page
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_3/News_Model/news_model.dart';
import 'package:project_3/news_screen/news_data.dart';

class MenubarItemDetailsScreen extends StatelessWidget {
  final List<NewsModel> results;

  MenubarItemDetailsScreen({required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final news = results[index];
          return _buildNewsCard(context, news);
        },
      ),
    );
  }

  // Function to build each news card with improved UI
  Widget _buildNewsCard(BuildContext context, NewsModel newsModel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsData(newsModel: newsModel),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              newsModel.urlToImage != null && newsModel.urlToImage!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  newsModel.urlToImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              )
                  : SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'No Image Available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                newsModel.title ?? 'No Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                newsModel.description ?? 'No Description',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
              Text(
                'Published: ${newsModel.publishedAt?.substring(0, 10) ?? 'N/A'}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Read more...',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
