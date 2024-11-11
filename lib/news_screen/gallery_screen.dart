import 'package:flutter/material.dart';
import 'package:project_3/API/news_api.dart';
import 'package:project_3/News_Model/news_model.dart';
import 'package:project_3/news_screen/news_data.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenPageState createState() => _GalleryScreenPageState();
}

class _GalleryScreenPageState extends State<GalleryScreen> {
  NewsApi newsApi = NewsApi();
  late Future<List<NewsModel>> combinedNews;

  @override
  void initState() {
    super.initState();
    combinedNews = fetchCombinedNews();
  }

  Future<List<NewsModel>> fetchCombinedNews() async {
    // Fetch everythingNews and topHeadlines simultaneously
    List<NewsModel> everythingNews = await newsApi.fetchEverythingNews();
    List<NewsModel> topHeadlines = await newsApi.fetchTopHeadlines();

    // Combine both lists and return only articles with images
    return [...everythingNews, ...topHeadlines]
        .where((news) => news.urlToImage != null)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<NewsModel>>(
        future: combinedNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Filtered combined news list with images
            List<NewsModel> newsWithImages = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns in the grid
                crossAxisSpacing: 8.0, // Horizontal space between items
                mainAxisSpacing: 8.0, // Vertical space between items
                childAspectRatio: 1, // To make grid items square
              ),
              itemCount: newsWithImages.length,
              itemBuilder: (context, index) {
                return _buildImageCard(newsWithImages[index]);
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  // Function to build an image card for each news item
  Widget _buildImageCard(NewsModel newsModel) {
    return InkWell(
      onTap: () {
        // When the image is tapped, navigate to detailed news view
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsData(newsModel: newsModel),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          newsModel.urlToImage!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 50,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
