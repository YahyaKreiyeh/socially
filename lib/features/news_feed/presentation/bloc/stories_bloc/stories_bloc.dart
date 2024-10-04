import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/features/news_feed/domain/entities/user_stories.dart';
import 'package:socially/features/news_feed/domain/usecases/get_all_stories.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final GetAllStories _getAllStories;

  StoriesBloc({
    required GetAllStories getAllStories,
  })  : _getAllStories = getAllStories,
        super(StoriesInitial()) {
    on<FetchStories>(_onFetchAllData);
  }

  void _onFetchAllData(
    FetchStories event,
    Emitter<StoriesState> emit,
  ) async {
    final result = await _getAllStories(NoParams());
    result.fold(
      (failure) => emit(StoriesFailure(failure.message)),
      (stories) {
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
        emit(StoriesLoaded(userStories: groupedStories.values.toList()));
      },
    );
  }
}
