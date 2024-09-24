import 'package:socially/features/news_feed/domain/entities/story.dart';

class UserStories {
  final String userId;
  final String userName;
  final List<Story> stories;

  UserStories({
    required this.userId,
    required this.userName,
    required this.stories,
  });
}
