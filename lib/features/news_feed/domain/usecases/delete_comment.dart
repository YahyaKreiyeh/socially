import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/repositories/news_feed_repository.dart';

class DeleteComment implements UseCase<void, String> {
  final NewsFeedRepository repository;

  DeleteComment(this.repository);

  @override
  Future<Either<Failure, void>> call(String commentId) async {
    return repository.deleteComment(commentId);
  }
}
