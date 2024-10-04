part of 'news_feed_bloc.dart';

class NewsFeedState {
  final List<Post>? itemList;
  final int? nextPage;
  final dynamic error;
  final dynamic refreshError;

  const NewsFeedState({
    this.itemList,
    this.nextPage,
    this.error,
    this.refreshError,
  });

  const NewsFeedState.loading() : this();

  const NewsFeedState.success({
    required List<Post> itemList,
    required int? nextPage,
  }) : this(itemList: itemList, nextPage: nextPage);

  NewsFeedState copyWithNewError(dynamic error) => NewsFeedState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        refreshError: null,
      );

  NewsFeedState copyWithNewRefreshError(dynamic refreshError) => NewsFeedState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        refreshError: refreshError,
      );
}
