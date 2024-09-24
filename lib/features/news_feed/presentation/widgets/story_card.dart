import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:socially/core/extenstions/extensions.dart';
import 'package:socially/features/news_feed/domain/entities/user_stories.dart';
import 'package:socially/routing/routes.dart';

class StoryCard extends StatelessWidget {
  final UserStories userStories;
  final int userIndex;
  final List<UserStories> allUserStories;

  const StoryCard({
    super.key,
    required this.userStories,
    required this.userIndex,
    required this.allUserStories,
  });

  @override
  Widget build(BuildContext context) {
    final storyImage = userStories.stories.first.imageUrl;

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.storyViewPage,
          arguments: {
            'userStoriesList': allUserStories,
            'initialUserIndex': userIndex,
            'initialStoryIndex': 0,
          },
        );
      },
      child: Container(
        width: 116,
        height: 116,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 58,
          backgroundImage: CachedNetworkImageProvider(storyImage),
        ),
      ),
    );
  }
}
