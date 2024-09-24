import 'package:socially/features/news_feed/domain/entities/story.dart';

class StoryModel extends Story {
  StoryModel({
    required super.id,
    required super.posterId,
    required super.imageUrl,
    required super.updatedAt,
    super.posterName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'image_url': imageUrl,
      'updated_at': updatedAt.toIso8601String(),
      'poster_name': posterName,
    };
  }

  factory StoryModel.fromJson(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      imageUrl: map['image_url'] as String,
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      posterName: map['poster_name'] as String?,
    );
  }

  StoryModel copyWith({
    String? id,
    String? posterId,
    String? imageUrl,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return StoryModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}
