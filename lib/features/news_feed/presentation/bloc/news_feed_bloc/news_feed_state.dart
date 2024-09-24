part of 'news_feed_bloc.dart';

abstract class NewsFeedState {}

class NewsFeedInitial extends NewsFeedState {}

class NewsFeedLoading extends NewsFeedState {}

class NewsFeedFailure extends NewsFeedState {
  final String error;
  NewsFeedFailure(this.error);
}

class NewsFeedLoaded extends NewsFeedState {
  final List<Post> posts;
  final List<UserStories> userStories;
  final bool isFetchingMore;
  final bool hasReachedEnd;

  NewsFeedLoaded({
    required this.posts,
    required this.userStories,
    this.isFetchingMore = false,
    this.hasReachedEnd = false,
  });

  NewsFeedLoaded copyWith({
    List<Post>? posts,
    List<UserStories>? userStories,
    bool? isFetchingMore,
    bool? hasReachedEnd,
  }) {
    return NewsFeedLoaded(
      posts: posts ?? this.posts,
      userStories: userStories ?? this.userStories,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}
