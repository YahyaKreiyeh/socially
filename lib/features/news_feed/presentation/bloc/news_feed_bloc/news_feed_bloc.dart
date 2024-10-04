import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socially/features/news_feed/domain/entities/post.dart';
import 'package:socially/features/news_feed/domain/usecases/get_all_posts.dart';

part 'news_feed_event.dart';
part 'news_feed_state.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  final GetAllPosts _getAllPosts;

  NewsFeedBloc({
    required GetAllPosts getAllPosts,
  })  : _getAllPosts = getAllPosts,
        super(const NewsFeedState.loading()) {
    on<NewsFeedEvent>((event, emitter) async {
      if (event is NewsFeedFailedFetchRetried) {
        await _handleFailedFetchRetried(emitter);
      } else if (event is NewsFeedNextPageRequested) {
        await _handleNextPageRequested(emitter, event);
      }
    });
  }

  Future<void> _handleFailedFetchRetried(Emitter<NewsFeedState> emitter) async {
    emitter(state.copyWithNewError(null));

    final firstPageFetchStream = _fetchPostPage(1);

    await emitter.onEach<NewsFeedState>(
      firstPageFetchStream,
      onData: emitter.call,
    );
  }

  Future<void> _handleNextPageRequested(
    Emitter<NewsFeedState> emitter,
    NewsFeedNextPageRequested event,
  ) async {
    emitter(state.copyWithNewError(null));

    final nextPageFetchStream = _fetchPostPage(event.pageNumber);

    await emitter.onEach<NewsFeedState>(
      nextPageFetchStream,
      onData: emitter.call,
    );
  }

  Stream<NewsFeedState> _fetchPostPage(int page) async* {
    final response = await _getAllPosts(PageParams(page: page, limit: 10));
    List<Post>? data;
    response.fold(
      (failure) async* {
        yield state.copyWithNewError(failure.message);
      },
      (posts) {
        data = posts;
      },
    );
    if (data == null) {
      return;
    }
    try {
      final newPage = data!;
      final newItemList = newPage;
      final oldItemList = state.itemList ?? [];
      final completeItemList =
          page == 1 ? newItemList : (oldItemList + newItemList);
      final nextPage = newPage.isEmpty ? null : page + 1;
      var newState = NewsFeedState.success(
        nextPage: nextPage,
        itemList: completeItemList,
      );
      yield newState;
    } catch (error) {
      yield state.copyWithNewError(error);
    }
  }
}
