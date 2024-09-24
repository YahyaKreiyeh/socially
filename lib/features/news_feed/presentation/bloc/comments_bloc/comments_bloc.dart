import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socially/features/news_feed/data/models/comment_model.dart';
import 'package:socially/features/news_feed/domain/entities/comment.dart';
import 'package:socially/features/news_feed/domain/usecases/add_comment.dart';
import 'package:socially/features/news_feed/domain/usecases/delete_comment.dart';
import 'package:socially/features/news_feed/domain/usecases/get_comments.dart';
import 'package:socially/features/news_feed/domain/usecases/update_comment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetCommentsForPost _getCommentsForPost;
  final AddComment _addComment;
  final UpdateComment _updateComment;
  final DeleteComment _deleteComment;

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  CommentsBloc({
    required GetCommentsForPost getCommentsForPost,
    required AddComment addComment,
    required UpdateComment updateComment,
    required DeleteComment deleteComment,
  })  : _getCommentsForPost = getCommentsForPost,
        _addComment = addComment,
        _updateComment = updateComment,
        _deleteComment = deleteComment,
        super(CommentsInitial()) {
    on<FetchComments>(_onFetchComments);
    on<AddCommentEvent>(_onAddComment);
    on<UpdateCommentEvent>(_onUpdateComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    on<CommentsUpdated>(_onCommentsUpdated);
  }

  void _onFetchComments(
      FetchComments event, Emitter<CommentsState> emit) async {
    emit(CommentsLoading());
    final result = await _getCommentsForPost(event.postId);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (comments) {
        final commentTree = _buildCommentTree(comments);
        emit(CommentsLoaded(commentTree));
        _subscribeToComments(event.postId);
      },
    );
  }

  List<Comment> _buildCommentTree(List<Comment> comments) {
    final Map<String, Comment> commentMap = {
      for (var c in comments) c.id.toString(): c.copyWith(replies: [])
    };
    final List<Comment> rootComments = [];

    for (var comment in commentMap.values) {
      if (comment.parentCommentId == null) {
        rootComments.add(comment);
      } else {
        final parentComment = commentMap[comment.parentCommentId];
        if (parentComment != null) {
          parentComment.replies.add(comment);
        }
      }
    }

    return rootComments;
  }

  void _subscribeToComments(String postId) {
    _subscription?.cancel();
    final supabase = Supabase.instance.client;

    _subscription = supabase
        .from('comments:post_id=eq.$postId')
        .stream(primaryKey: ['id']).listen((data) {
      final comments = data.map((json) => CommentModel.fromJson(json)).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      add(CommentsUpdated(comments));
    });
  }

  void _onAddComment(AddCommentEvent event, Emitter<CommentsState> emit) async {
    final result = await _addComment(event.comment);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (_) {},
    );
  }

  void _onUpdateComment(
      UpdateCommentEvent event, Emitter<CommentsState> emit) async {
    final result = await _updateComment(event.comment);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (_) {},
    );
  }

  void _onDeleteComment(
      DeleteCommentEvent event, Emitter<CommentsState> emit) async {
    final result = await _deleteComment(event.commentId);
    result.fold(
      (failure) => emit(CommentsError(failure.message)),
      (_) {},
    );
  }

  void _onCommentsUpdated(CommentsUpdated event, Emitter<CommentsState> emit) {
    final commentTree = _buildCommentTree(event.comments);
    emit(CommentsLoaded(commentTree));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
