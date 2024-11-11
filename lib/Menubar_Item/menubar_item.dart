// import 'package:flutter/material.dart';
//
// class MenuBarItem extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Function(String) onItemTapped; // Callback function for when an item is tapped
//
//   MenuBarItem({required this.title, required this.icon, required this.onItemTapped});
//
//   @override
//   // Helper method to build a menu card with dropdown
//   Widget _buildMenuCard(String title, IconData icon) {
//     // Check if the title is "Sport" to add specific submenus for Football and Cricket
//     if (title == 'Sport') {
//       return Card(
//         child: ExpansionTile(
//           leading: Icon(icon),
//           title: Text(
//             title,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           children: <Widget>[
//             ListTile(
//               title: Text('Football'),
//               onTap: () {
//                 // Trigger search with predefined query "Football"
//                 _searchNews(predefinedQuery: 'Football');
//               },
//             ),
//             ListTile(
//               title: Text('Cricket'),
//               onTap: () {
//                 // Trigger search with predefined query "Cricket"
//                 _searchNews(predefinedQuery: 'Cricket');
//               },
//             ),
//           ],
//         ),
//       );
//     }
//
//     // For other menu items, use default structure
//     return Card(
//       child: ExpansionTile(
//         leading: Icon(icon),
//         title: Text(
//           title,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         children: <Widget>[
//           ListTile(
//             title: Text('Option 1'),
//             onTap: () {
//               // Handle option 1 action
//             },
//           ),
//           ListTile(
//             title: Text('Option 2'),
//             onTap: () {
//               // Handle option 2 action
//             },
//           ),
//           ListTile(
//             title: Text('Option 3'),
//             onTap: () {
//               // Handle option 3 action
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
