class Story {
  final String id;
  final String posterId;
  final String imageUrl;
  final DateTime updatedAt;
  final String? posterName;

  Story({
    required this.id,
    required this.posterId,
    required this.imageUrl,
    required this.updatedAt,
    this.posterName,
  });
}
