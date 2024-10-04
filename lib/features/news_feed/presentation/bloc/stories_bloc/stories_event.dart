part of 'stories_bloc.dart';

abstract class StoriesEvent {}

class FetchStories extends StoriesEvent {
  FetchStories();
}
