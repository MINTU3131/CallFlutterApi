import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import '../models/Post.dart';
import 'package:html/parser.dart' as html_parser;


class HomeViewModel extends ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  HomeViewModel() {
    fetchPosts();
  }

  // Fetch posts from API
  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('https://api.hive.blog/'),
      headers: {
        'accept': 'application/json, text/plain, */*',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        "id": 1,
        "jsonrpc": "2.0",
        "method": "bridge.get_ranked_posts",
        "params": {
          "sort": "trending",
          "tag": "",
          "observer": "hive.blog"
        }
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> postList = jsonDecode(response.body)['result'];
      _posts = postList.map((json) => Post.fromJson(json)).toList();
    } else {
      // Handle error
      print('Failed to load posts');
    }

    _isLoading = false;
    notifyListeners();
  }

  String getRelativeTime(String timestamp) {
    final DateTime createdTime = DateTime.parse(timestamp);
    return timeago.format(createdTime);
  }

  String getShortDescription(String body) {
    final document = html_parser.parse(body);
    final text = document.body?.text.split('\n').take(2).join(' ') ?? '';
    return text;
  }

}
