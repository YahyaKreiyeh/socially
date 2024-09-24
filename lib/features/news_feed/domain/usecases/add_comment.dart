import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/entities/comment.dart';
import 'package:socially/features/news_feed/domain/repositories/news_feed_repository.dart';

class AddComment implements UseCase<Comment, Comment> {
  final NewsFeedRepository repository;

  AddComment(this.repository);

  @override
  Future<Either<Failure, Comment>> call(Comment comment) async {
    return repository.addComment(comment);
  }
}
