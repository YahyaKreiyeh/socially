import 'package:socially/features/news_feed/domain/entities/comment.dart';

abstract class CommentsEvent {}

class FetchComments extends CommentsEvent {
  final String postId;

  FetchComments(this.postId);
}

class AddCommentEvent extends CommentsEvent {
  final Comment comment;

  AddCommentEvent(this.comment);
}

class UpdateCommentEvent extends CommentsEvent {
  final Comment comment;

  UpdateCommentEvent(this.comment);
}

class DeleteCommentEvent extends CommentsEvent {
  final String commentId;

  DeleteCommentEvent(this.commentId);
}

class CommentsUpdated extends CommentsEvent {
  final List<Comment> comments;

  CommentsUpdated(this.comments);
}
