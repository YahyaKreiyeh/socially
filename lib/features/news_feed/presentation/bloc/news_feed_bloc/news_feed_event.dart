part of 'news_feed_bloc.dart';

abstract class NewsFeedEvent {
  const NewsFeedEvent();
}

class NewsFeedNextPageRequested extends NewsFeedEvent {
  final int pageNumber;

  const NewsFeedNextPageRequested({required this.pageNumber});
}

class NewsFeedFailedFetchRetried extends NewsFeedEvent {
  const NewsFeedFailedFetchRetried();
}
