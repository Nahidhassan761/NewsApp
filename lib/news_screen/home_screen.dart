import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_3/API/news_api.dart';
import 'package:project_3/Log_In_Service/login_page.dart';
import 'package:project_3/News_Model/news_model.dart';
import 'package:project_3/news_screen/everything_news.dart';
import 'package:project_3/news_screen/gallery_screen.dart';
import 'package:project_3/news_screen/menubar_item_details_screen.dart';
import 'package:project_3/news_screen/news_search_delegate.dart';
import 'package:project_3/news_screen/top_news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isDarkTheme = false;

  NewsApi newsApi = NewsApi();
  User? _user = FirebaseAuth.instance.currentUser;

  static List<Widget> _pages = <Widget>[
    EverythingNewsPage(),
    TopNewsPage(),
    GalleryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<DocumentSnapshot> _fetchUserData() async {
    return await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
  }

  void _searchNews({String? predefinedQuery}) async {
    String? searchQuery = predefinedQuery ?? await showSearch(
      context: context,
      delegate: NewsSearchDelegate(),
    );

    if (searchQuery != null && searchQuery.isNotEmpty) {
      List<NewsModel> searchResults = await newsApi.fetchSearchData(searchQuery);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenubarItemDetailsScreen(results: searchResults),
        ),
      );
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _searchNews,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'NEWS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 2.0,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 48), // To center the text in between the icons
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              FutureBuilder<DocumentSnapshot>(
                future: _fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return DrawerHeader(
                      child: Center(child: CircularProgressIndicator()),
                      decoration: BoxDecoration(color: Colors.blue),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                    return DrawerHeader(
                      child: Center(child: Text("User data not found")),
                      decoration: BoxDecoration(color: Colors.blue),
                    );
                  }

                  var userData = snapshot.data!;
                  String name = userData['name'] ?? 'User Name';
                  String email = userData['email'] ?? 'Email not available';
                  String? photoUrl = _user?.photoURL;

                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image: AssetImage('assets/images/drawer_background.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.6),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: photoUrl != null
                                ? Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )
                                : Icon(Icons.account_circle, size: 50, color: Colors.blue),
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    _buildMenuCard('News', Icons.article),
                    _buildMenuCard('Sport', Icons.sports),
                    _buildMenuCard('Business', Icons.business),
                    _buildMenuCard('Innovation', Icons.lightbulb),
                    _buildMenuCard('Culture', Icons.museum),
                    _buildMenuCard('Arts', Icons.brush),
                    _buildMenuCard('Travel', Icons.airplanemode_active),
                    _buildMenuCard('Earth', Icons.public),
                    _buildMenuCard('Live', Icons.live_tv),
                    _buildMenuCard('Weather', Icons.wb_sunny),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.grey),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () async {
                  bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                  if (result != null) {
                    setState(() {
                      _isDarkTheme = result;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Everything News'),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Top Headlines'),
            BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Top Gallery'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon) {
    List<Widget> subMenuItems = [];

    if (title == 'News') {
      subMenuItems = [
        ListTile(
          title: Text('Israel-Gaza War'),
          onTap: () => _searchNews(predefinedQuery: 'Israel-Gaza War'),
        ),
        ListTile(
          title: Text('Bangladesh'),
          onTap: () => _searchNews(predefinedQuery: 'Bangladesh'),
        ),
      ];
    } else if (title == 'Sport') {
      subMenuItems = [
        ListTile(
          title: Text('Football'),
          onTap: () => _searchNews(predefinedQuery: 'Football'),
        ),
        ListTile(
          title: Text('Cricket'),
          onTap: () => _searchNews(predefinedQuery: 'Cricket'),
        ),
      ];
    } else if (title == 'Business') {
      subMenuItems = [
        ListTile(
          title: Text('Economy'),
          onTap: () => _searchNews(predefinedQuery: 'Economy'),
        ),
        ListTile(
          title: Text('Finance'),
          onTap: () => _searchNews(predefinedQuery: 'Finance'),
        ),
      ];
    }
    return Card(
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        children: subMenuItems,
      ),
    );
  }
}
