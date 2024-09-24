import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/entities/comment.dart';
import 'package:socially/features/news_feed/domain/entities/post.dart';
import 'package:socially/features/news_feed/domain/entities/story.dart';

abstract class NewsFeedRepository {
  Future<Either<Failure, Post>> uploadPost({
    File? image,
    required String content,
    required String posterId,
  });

  Future<Either<Failure, List<Post>>> getAllPosts(
    final int page,
    final int limit,
  );

  Future<Either<Failure, List<Story>>> getAllStories();
  Future<Either<Failure, List<Comment>>> getCommentsForPost(String postId);
  Future<Either<Failure, Comment>> addComment(Comment comment);
  Future<Either<Failure, void>> updateComment(Comment comment);
  Future<Either<Failure, void>> deleteComment(String commentId);
}
