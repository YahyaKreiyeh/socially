import 'package:socially/features/news_feed/domain/entities/post.dart';

class PostModel extends Post {
  PostModel({
    required super.id,
    required super.posterId,
    required super.content,
    super.imageUrl,
    required super.updatedAt,
    super.posterName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'content': content,
      'image_url': imageUrl,
      'updated_at': updatedAt.toIso8601String(),
      'poster_name': posterName,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String?,
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      posterName: map['poster_name'] as String?,
    );
  }

  PostModel copyWith({
    String? id,
    String? posterId,
    String? content,
    String? imageUrl,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return PostModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}
