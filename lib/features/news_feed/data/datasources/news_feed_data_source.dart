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
    List<PostModel> posts = [];
    final postListString = sharedPreferences.getStringList('posts') ?? [];
    for (String postJson in postListString) {
      posts.add(PostModel.fromJson(json.decode(postJson)));
    }
    return posts;
  }

  @override
  List<StoryModel> loadStories() {
    List<StoryModel> stories = [];
    final storyListString = sharedPreferences.getStringList('stories') ?? [];
    for (String storyJson in storyListString) {
      stories.add(StoryModel.fromJson(json.decode(storyJson)));
    }
    return stories;
  }

  @override
  void uploadLocalPosts({required List<PostModel> posts}) {
    List<String> postListString =
        posts.map((post) => json.encode(post.toJson())).toList();
    sharedPreferences.setStringList('posts', postListString);
  }

  @override
  void uploadLocalStories({required List<StoryModel> stories}) {
    List<String> storyListString =
        stories.map((story) => json.encode(story.toJson())).toList();
    sharedPreferences.setStringList('stories', storyListString);
  }
}
