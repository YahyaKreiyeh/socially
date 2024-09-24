class Post {
  final String id;
  final String posterId;
  final String content;
  final String? imageUrl;
  final DateTime updatedAt;
  final String? posterName;

  Post({
    required this.id,
    required this.posterId,
    required this.content,
    this.imageUrl,
    required this.updatedAt,
    this.posterName,
  });
}
