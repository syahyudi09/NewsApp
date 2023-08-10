import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final Map<String, dynamic> post;

  Detail({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Column(
        children: [
          Image.network(post['urlToImage'] ?? ''),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  post['title'] ?? '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  post['description'] ?? '',
                  style: TextStyle(fontSize: 16),
                ),
                // Add more details from the post as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
