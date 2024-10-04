import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socially/features/news_feed/data/models/post_model.dart';
import 'package:socially/features/news_feed/data/models/story_model.dart';

abstract interface class NewsFeedLocalDataSource {
  void uploadLocalPosts({required List<PostModel> posts});
  void uploadLocalStories({required List<StoryModel> stories});
  List<PostModel> loadPosts();
  List<StoryModel> loadStories();
}

class NewsFeedLocalDataSourceImpl implements NewsFeedLocalDataSource {
  final SharedPreferences sharedPreferences;

  NewsFeedLocalDataSourceImpl(this.sharedPreferences);

  @override
  List<PostModel> loadPosts() {
    final postListString = sharedPreferences.getStringList('posts') ?? [];
    return postListString
        .map((postJson) => PostModel.fromJson(json.decode(postJson)))
        .toList();
  }

  @override
  List<StoryModel> loadStories() {
    final storyListString = sharedPreferences.getStringList('stories') ?? [];
    return storyListString
        .map((storyJson) => StoryModel.fromJson(json.decode(storyJson)))
        .toList();
  }

  @override
  void uploadLocalPosts({required List<PostModel> posts}) {
    List<PostModel> existingPosts = loadPosts();
    Map<String, PostModel> postsMap = {};
    for (var post in posts) {
      postsMap[post.id] = post;
    }
    for (var post in existingPosts) {
      if (!postsMap.containsKey(post.id)) {
        postsMap[post.id] = post;
      }
    }
    List<PostModel> combinedPosts = postsMap.values.toList();
    combinedPosts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    List<PostModel> first10Posts = combinedPosts.take(10).toList();
    List<String> postListString =
        first10Posts.map((post) => json.encode(post.toJson())).toList();
    sharedPreferences.setStringList('posts', postListString);
  }

  @override
  void uploadLocalStories({required List<StoryModel> stories}) {
    List<StoryModel> existingStories = loadStories();
    Map<String, StoryModel> storiesMap = {};
    for (var story in stories) {
      storiesMap[story.id] = story;
    }
    for (var story in existingStories) {
      if (!storiesMap.containsKey(story.id)) {
        storiesMap[story.id] = story;
      }
    }
    List<StoryModel> combinedStories = storiesMap.values.toList();
    combinedStories.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    List<StoryModel> first10Stories = combinedStories.take(10).toList();
    List<String> storyListString =
        first10Stories.map((story) => json.encode(story.toJson())).toList();
    sharedPreferences.setStringList('stories', storyListString);
  }
}
