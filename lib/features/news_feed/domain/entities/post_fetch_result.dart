import 'package:socially/features/news_feed/domain/entities/post.dart';

class PostFetchResult {
  final List<Post> posts;
  final bool hasMore;

  PostFetchResult({required this.posts, required this.hasMore});
}
