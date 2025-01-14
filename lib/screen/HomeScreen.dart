import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utiles/PostItem.dart';
import '../viewModels/HomeViewModel.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hive Posts'),
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: viewModel.posts.length,
              itemBuilder: (context, index) {
                final post = viewModel.posts[index];
                return PostItem(post: post);
              },
            );
          },
        ),
      ),
    );
  }
}
