import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:socially/core/constants/constants.dart';
import 'package:socially/core/error/exceptions.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/core/network/connection_checker.dart';
import 'package:socially/features/news_feed/data/datasources/news_feed_data_source.dart';
import 'package:socially/features/news_feed/data/datasources/news_feed_remote_data_source.dart';
import 'package:socially/features/news_feed/data/models/comment_model.dart';
import 'package:socially/features/news_feed/data/models/post_model.dart';
import 'package:socially/features/news_feed/domain/entities/comment.dart';
import 'package:socially/features/news_feed/domain/entities/post.dart';
import 'package:socially/features/news_feed/domain/entities/story.dart';
import 'package:socially/features/news_feed/domain/repositories/news_feed_repository.dart';
import 'package:uuid/uuid.dart';

class NewsFeedRepositoryImpl implements NewsFeedRepository {
  final NewsFeedRemoteDataSource newsFeedRemoteDataSource;
  final NewsFeedLocalDataSource newsFeedLocalDataSource;
  final ConnectionChecker connectionChecker;
  NewsFeedRepositoryImpl(
    this.newsFeedRemoteDataSource,
    this.newsFeedLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Post>> uploadPost({
    File? image,
    required String content,
    required String posterId,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      PostModel postModel = PostModel(
        id: const Uuid().v1(),
        posterId: posterId,
        content: content,
        imageUrl: '',
        updatedAt: DateTime.now(),
      );

      final imageUrl = await newsFeedRemoteDataSource.uploadPostImage(
        image: image,
        post: postModel,
      );

      postModel = postModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedPost = await newsFeedRemoteDataSource.uploadPost(postModel);
      return right(uploadedPost);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPosts(int page, int limit) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final posts = newsFeedLocalDataSource.loadPosts();
        return right(posts);
      }
      final posts = await newsFeedRemoteDataSource.getAllPosts(page, limit);
      if (page == 1) {
        newsFeedLocalDataSource.uploadLocalPosts(posts: posts);
      }
      return right(posts);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getAllStories() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final stories = newsFeedLocalDataSource.loadStories();
        return right(stories);
      }
      final stories = await newsFeedRemoteDataSource.getAllStories();
      newsFeedLocalDataSource.uploadLocalStories(stories: stories);
      return right(stories);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getCommentsForPost(
      String postId) async {
    try {
      final comments =
          await newsFeedRemoteDataSource.getCommentsForPost(postId);
      return right(comments);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment(Comment comment) async {
    try {
      final commentModel = CommentModel(
        id: comment.id,
        postId: comment.postId,
        commenterId: comment.commenterId,
        commenterName: comment.commenterName,
        content: comment.content,
        createdAt: comment.createdAt,
        parentCommentId: comment.parentCommentId,
      );
      final addedComment =
          await newsFeedRemoteDataSource.addComment(commentModel);
      return right(addedComment);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateComment(Comment comment) async {
    try {
      await newsFeedRemoteDataSource.updateComment(comment as CommentModel);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await newsFeedRemoteDataSource.deleteComment(commentId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
