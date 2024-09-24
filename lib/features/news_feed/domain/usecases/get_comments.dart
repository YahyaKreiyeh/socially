import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/entities/comment.dart';
import 'package:socially/features/news_feed/domain/repositories/news_feed_repository.dart';

class GetCommentsForPost implements UseCase<List<Comment>, String> {
  final NewsFeedRepository repository;

  GetCommentsForPost(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(String postId) async {
    return repository.getCommentsForPost(postId);
  }
}
