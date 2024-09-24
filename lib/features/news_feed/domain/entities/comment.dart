class Comment {
  final String? id;
  final String postId;
  final String commenterId;
  final String commenterName;
  final String content;
  final DateTime createdAt;
  final String? parentCommentId;
  final List<Comment> replies;

  Comment({
    this.id,
    required this.postId,
    required this.commenterId,
    required this.commenterName,
    required this.content,
    required this.createdAt,
    this.parentCommentId,
    this.replies = const [],
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? commenterId,
    String? commenterName,
    String? content,
    DateTime? createdAt,
    String? parentCommentId,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      commenterId: commenterId ?? this.commenterId,
      commenterName: commenterName ?? this.commenterName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
    );
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String?,
      postId: json['post_id'] as String,
      commenterId: json['commenter_id'] as String,
      commenterName: json['commenter_name'] as String? ?? 'Unknown',
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      parentCommentId: json['parent_comment_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'post_id': postId,
      'commenter_id': commenterId,
      'content': content,
      'parent_comment_id': parentCommentId,
      'commenter_name': commenterName,
    };
    if (id != null) {
      json['id'] = id;
    }
    return json;
  }
}
