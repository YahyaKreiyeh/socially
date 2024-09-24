part of 'news_feed_bloc.dart';

abstract class NewsFeedEvent {}

class NewsFeedFetchAllData extends NewsFeedEvent {
  final int page;
  NewsFeedFetchAllData({this.page = 1});
}
