import 'package:flutter/material.dart';
import 'package:project_3/API/news_api.dart';
import 'package:project_3/News_Model/news_model.dart';
import 'package:project_3/news_screen/news_data.dart';

class EverythingNewsPage extends StatefulWidget {
  @override
  _EverythingNewsPageState createState() => _EverythingNewsPageState();
}

class _EverythingNewsPageState extends State<EverythingNewsPage> {
  NewsApi newsApi = NewsApi();
  late Future<List<NewsModel>> everythingNews;

  @override
  void initState() {
    super.initState();
    everythingNews = newsApi.fetchEverythingNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<NewsModel>>(
        future: everythingNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                NewsModel newsItem = snapshot.data![index];
                return _buildNewsCard(newsItem);
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  // Function to build each news card with improved UI
  Widget _buildNewsCard(NewsModel newsModel) {
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
              newsModel.urlToImage != null
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
                      child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    );
                  },
                ),
              )
                  : SizedBox(),
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
