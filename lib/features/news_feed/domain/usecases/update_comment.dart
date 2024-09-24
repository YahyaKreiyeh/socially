import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/entities/comment.dart';
import 'package:socially/features/news_feed/domain/repositories/news_feed_repository.dart';

class UpdateComment implements UseCase<void, Comment> {
  final NewsFeedRepository repository;

  UpdateComment(this.repository);

  @override
  Future<Either<Failure, void>> call(Comment comment) async {
    return repository.updateComment(comment);
  }
}
