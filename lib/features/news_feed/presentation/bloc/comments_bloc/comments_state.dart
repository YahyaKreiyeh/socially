import 'package:socially/features/news_feed/domain/entities/comment.dart';

abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<Comment> comments;

  CommentsLoaded(this.comments);
}

class CommentsError extends CommentsState {
  final String message;

  CommentsError(this.message);
}
