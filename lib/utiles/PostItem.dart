import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Post.dart';
import '../viewModels/HomeViewModel.dart';

class PostItem extends StatelessWidget {
  final Post post;

  PostItem({required this.post});

  @override
  Widget build(BuildContext context) {
    final relativeTime = context.watch<HomeViewModel>().getRelativeTime(post.created);
    final shortDescription = context.watch<HomeViewModel>().getShortDescription(post.body);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: post.thumbnail.isNotEmpty
                      ? NetworkImage(post.thumbnail)
                      : null,
                  child: post.thumbnail.isEmpty
                      ? Icon(Icons.person, size: 40)
                      : null,
                  radius: 24,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.author,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '(${post.reputation})',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Text(
                        'in ${post.community} • $relativeTime',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                // Image on the left with a fixed size
                SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: Image.network(
                    post.thumbnail,
                    fit: BoxFit.cover, // Ensures the image is scaled appropriately
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Image has loaded
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ), // Placeholder while loading
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Center(
                        child: Icon(Icons.downloading, size: 50), // Error icon if image fails to load
                      ); // Placeholder when there's an error loading the image
                    },
                  ),
                ),
                SizedBox(width: 8.0), // Space between image and text/icons

                // Expanded Column for Title, Description, and Row for payout, vote count, and comments count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        post.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),

                      // Short description
                      Text(
                        shortDescription,
                        style: TextStyle(color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.0),

                      // Row for payout, vote count, and comments count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.arrow_upward, size: 16.0),
                              SizedBox(width: 4.0),
                              Text('\$${post.payout}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.thumb_up_alt, size: 16.0),
                              SizedBox(width: 4.0),
                              Text('${post.voteCount}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.comment, size: 16.0),
                              SizedBox(width: 4.0),
                              Text('${post.commentsCount}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
