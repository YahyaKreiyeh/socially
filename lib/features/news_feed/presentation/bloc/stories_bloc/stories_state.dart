part of 'stories_bloc.dart';

abstract class StoriesState {}

class StoriesInitial extends StoriesState {}

class StoriesLoading extends StoriesState {}

class StoriesFailure extends StoriesState {
  final String error;
  StoriesFailure(this.error);
}

class StoriesLoaded extends StoriesState {
  final List<UserStories> userStories;

  StoriesLoaded({
    required this.userStories,
  });
}
