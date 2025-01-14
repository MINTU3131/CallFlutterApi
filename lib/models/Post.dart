class Post {
  final String author;
  final String reputation;
  final String community;
  final String title;
  final String body;
  final String thumbnail;
  final String created;
  final String voteCount;
  final String commentsCount;
  final String payout;

  Post({
    required this.author,
    required this.reputation,
    required this.community,
    required this.title,
    required this.body,
    required this.thumbnail,
    required this.created,
    required this.voteCount,
    required this.commentsCount,
    required this.payout,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      author: json['author'] ?? 'Unknown',
      reputation: json['author_reputation'] != null
          ? json['author_reputation'].toString() // Convert to String
          : '0',
      community: json['community'] ?? 'Unknown',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      thumbnail: json['json_metadata']['image'] != null &&
          json['json_metadata']['image'] is List &&
          json['json_metadata']['image'].isNotEmpty
          ? json['json_metadata']['image'][0]
          : '',
      created: json['created'] ?? '',
      voteCount: json['net_votes']?.toString() ?? '0', // Ensure it's a String
      commentsCount: json['children']?.toString() ?? '0', // Ensure it's a String
      payout: json['pending_payout_value']?.toString() ?? '0.00', // Ensure it's a String
    );
  }
}
