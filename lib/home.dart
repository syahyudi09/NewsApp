import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/detail.dart';
import 'package:news_app/model/category.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _posts = [];

  List<Category> _categories = [
    Category('General', 'general'),
    Category('Business', 'business'),
    Category('Technology', 'technology'),
    Category('Science', 'science'),
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getData(String categoryApiKey) async {
    try {
      final Uri uri = Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=id&category=$categoryApiKey&apiKey=dbad5ba587c943a699739d05db1b441e');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _posts = data['articles'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('NewsApp'),
          bottom: TabBar(
            tabs: _categories.map((category) {
              return Tab(text: category.name);
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: _categories.map((category) {
            return _buildCategoryListView(category.apiKey);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryListView(String categoryApiKey) {
    return FutureBuilder(
      future: _getData(categoryApiKey),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  color: Colors.grey[200],
                  height: 120,
                  width: 100,
                  child: _posts[index]['urlToImage'] != null
                      ? Image.network(_posts[index]['urlToImage'])
                      : Center(),
                ),
                title: Text('${_posts[index]['title']}'),
                subtitle: Text('${_posts[index]['description']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => Detail(post: _posts[index]),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
