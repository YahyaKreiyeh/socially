import 'package:socially/features/news_feed/domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    super.id,
    required super.postId,
    required super.commenterId,
    required super.commenterName,
    required super.content,
    required super.createdAt,
    super.parentCommentId,
    super.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String?,
      postId: json['post_id'] as String,
      commenterId: json['commenter_id'] as String,
      commenterName: json['commenter_name'] as String? ?? 'Anonymous',
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      parentCommentId: json['parent_comment_id'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'post_id': postId,
      'commenter_id': commenterId,
      'content': content,
      'commenter_name': commenterName,
      'parent_comment_id': parentCommentId,
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }
}
