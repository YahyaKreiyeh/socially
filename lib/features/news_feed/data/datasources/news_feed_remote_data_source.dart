import 'dart:io';

import 'package:socially/core/error/exceptions.dart';
import 'package:socially/features/news_feed/data/models/comment_model.dart';
import 'package:socially/features/news_feed/data/models/post_model.dart';
import 'package:socially/features/news_feed/data/models/story_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class NewsFeedRemoteDataSource {
  Future<PostModel> uploadPost(PostModel post);
  Future<String> uploadPostImage({
    File? image,
    required PostModel post,
  });
  Future<List<PostModel>> getAllPosts(int page, int limit);
  Future<List<StoryModel>> getAllStories();
  Future<List<CommentModel>> getCommentsForPost(String postId);
  Future<CommentModel> addComment(CommentModel comment);
  Future<void> updateComment(CommentModel comment);
  Future<void> deleteComment(String commentId);
}

class NewsFeedRemoteDataSourceImpl implements NewsFeedRemoteDataSource {
  final SupabaseClient supabaseClient;
  NewsFeedRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<PostModel> uploadPost(PostModel post) async {
    try {
      final postData =
          await supabaseClient.from('posts').insert(post.toJson()).select();

      return PostModel.fromJson(postData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadPostImage({
    File? image,
    required PostModel post,
  }) async {
    try {
      if (image != null) {
        await supabaseClient.storage.from('post_images').upload(
              post.id,
              image,
            );
        return supabaseClient.storage.from('post_images').getPublicUrl(
              post.id,
            );
      }
      return '';
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getAllPosts(int page, int limit) async {
    try {
      final offset = (page - 1) * limit;
      final posts = await supabaseClient
          .from('posts')
          .select('*, profiles (name)')
          .range(offset, offset + limit - 1);

      return posts
          .map(
            (post) => PostModel.fromJson(post).copyWith(
              posterName: post['profiles']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StoryModel>> getAllStories() async {
    try {
      final stories =
          await supabaseClient.from('stories').select('*, profiles (name)');

      return stories
          .map(
            (post) => StoryModel.fromJson(post).copyWith(
              posterName: post['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CommentModel>> getCommentsForPost(String postId) async {
    try {
      final response = await supabaseClient
          .from('comments')
          .select('*, profiles (name)')
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => CommentModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommentModel> addComment(CommentModel comment) async {
    try {
      final response = await supabaseClient
          .from('comments')
          .insert(comment.toJson())
          .select('*, profiles (name)')
          .single();

      return CommentModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateComment(CommentModel comment) async {
    try {
      await supabaseClient
          .from('comments')
          .update(comment.toJson())
          .eq('id', comment.id.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await supabaseClient.from('comments').delete().eq('id', commentId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
