import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/entities/post.dart';
import 'package:socially/features/news_feed/domain/repositories/news_feed_repository.dart';

class GetAllPosts implements UseCase<List<Post>, PageParams> {
  final NewsFeedRepository newsFeedRepository;
  GetAllPosts(this.newsFeedRepository);

  @override
  Future<Either<Failure, List<Post>>> call(PageParams params) async {
    return await newsFeedRepository.getAllPosts(params.page, params.limit);
  }
}

class PageParams {
  final int page;
  final int limit;

  PageParams({required this.page, required this.limit});
}
