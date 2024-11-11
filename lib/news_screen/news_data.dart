import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';  // Import url_launcher
import 'package:project_3/News_Model/news_model.dart';  // Import your NewsModel

class NewsData extends StatelessWidget {
  final NewsModel? newsModel;

  // Constructor accepting a NewsModel object
  NewsData({super.key, this.newsModel});

  // Function to launch the URL in the browser
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newsModel?.title ?? 'News Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the news image if available
              if (newsModel?.urlToImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    newsModel!.urlToImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Show a placeholder if the image fails to load
                      return Container(
                        height: 200,
                        child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                      );
                    },
                  ),
                ),
              SizedBox(height: 10),

              // News title
              Text(
                newsModel?.title ?? 'No Title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // News description
              Text(
                newsModel?.description ?? 'No Description',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),

              // News author
              Text(
                'Author: ${newsModel?.author ?? 'Unknown'}',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10),

              // Published date
              Text(
                'Published At: ${newsModel?.publishedAt ?? 'N/A'}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),

              // News content
              Text(
                newsModel?.content ?? 'No Content Available',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Button to open full article
              ElevatedButton(
                onPressed: () {
                  if (newsModel?.url != null) {
                    _launchURL(newsModel!.url!);  // Launch the full article URL
                  }
                },
                child: Text('Read Full Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
