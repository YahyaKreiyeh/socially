import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/entities/post.dart';
import 'package:socially/features/news_feed/domain/repositories/news_feed_repository.dart';

class UploadPost implements UseCase<Post, UploadPostParams> {
  final NewsFeedRepository newsFeedRepository;
  UploadPost(this.newsFeedRepository);

  @override
  Future<Either<Failure, Post>> call(UploadPostParams params) async {
    return await newsFeedRepository.uploadPost(
      image: params.image,
      content: params.content,
      posterId: params.posterId,
    );
  }
}

class UploadPostParams {
  final String posterId;

  final String content;
  final File? image;

  UploadPostParams({
    required this.posterId,
    required this.content,
    this.image,
  });
}
