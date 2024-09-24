import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/entities/post.dart';
import 'package:socially/features/news_feed/domain/entities/story.dart';
import 'package:socially/features/news_feed/domain/entities/user_stories.dart';
import 'package:socially/features/news_feed/domain/usecases/get_all_posts.dart';
import 'package:socially/features/news_feed/domain/usecases/get_all_stories.dart';

part 'news_feed_event.dart';
part 'news_feed_state.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  final GetAllPosts _getAllPosts;
  final GetAllStories _getAllStories;

  NewsFeedBloc({
    required GetAllPosts getAllPosts,
    required GetAllStories getAllStories,
  })  : _getAllPosts = getAllPosts,
        _getAllStories = getAllStories,
        super(NewsFeedInitial()) {
    on<NewsFeedFetchAllData>(_onFetchAllData);
  }

  void _onFetchAllData(
    NewsFeedFetchAllData event,
    Emitter<NewsFeedState> emit,
  ) async {
    final currentState = state;

    int page = event.page;
    List<Post> currentPosts = [];

    if (currentState is NewsFeedLoaded && page > 1) {
      currentPosts = currentState.posts;

      if (currentState.hasReachedEnd) {
        return;
      }

      emit(currentState.copyWith(isFetchingMore: true));
    } else {
      emit(NewsFeedLoading());
    }

    try {
      final results = await Future.wait([
        _getAllPosts(PageParams(page: page, limit: 10)),
        _getAllStories(NoParams()),
      ]);

      final postsResult = results[0] as Either<Failure, List<Post>>;
      final storiesResult = results[1] as Either<Failure, List<Story>>;
      final posts = postsResult.getOrElse((r) => []);
      final stories = storiesResult.getOrElse((r) => []);

      final Map<String, UserStories> groupedStories = {};
      for (var story in stories) {
        final userId = story.posterId;
        if (!groupedStories.containsKey(userId)) {
          groupedStories[userId] = UserStories(
            userId: userId,
            userName: story.posterName ?? 'Unknown',
            stories: [],
          );
        }
        groupedStories[userId]!.stories.add(story);
      }

      final List<UserStories> userStoriesList = groupedStories.values.toList();

      final hasReachedEnd = posts.isEmpty;

      emit(NewsFeedLoaded(
        posts: currentPosts + posts,
        userStories: userStoriesList,
        isFetchingMore: false,
        hasReachedEnd: hasReachedEnd,
      ));
    } catch (e) {
      emit(NewsFeedFailure('An error occurred while fetching data.'));
    }
  }
}
