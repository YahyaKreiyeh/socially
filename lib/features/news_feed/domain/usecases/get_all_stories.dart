import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/entities/story.dart';
import 'package:socially/features/news_feed/domain/repositories/news_feed_repository.dart';

class GetAllStories implements UseCase<List<Story>, NoParams> {
  final NewsFeedRepository newsFeedRepository;
  GetAllStories(this.newsFeedRepository);

  @override
  Future<Either<Failure, List<Story>>> call(NoParams params) async {
    return await newsFeedRepository.getAllStories();
  }
}
