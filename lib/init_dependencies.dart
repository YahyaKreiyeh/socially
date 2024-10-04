import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socially/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:socially/core/network/connection_checker.dart';
import 'package:socially/core/secrets/app_secrets.dart';
import 'package:socially/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:socially/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:socially/features/auth/domain/repository/auth_repository.dart';
import 'package:socially/features/auth/domain/usecases/current_user.dart';
import 'package:socially/features/auth/domain/usecases/user_signin.dart';
import 'package:socially/features/auth/domain/usecases/user_signout.dart';
import 'package:socially/features/auth/domain/usecases/user_signup.dart';
import 'package:socially/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:socially/features/news_feed/data/datasources/news_feed_data_source.dart';
import 'package:socially/features/news_feed/data/datasources/news_feed_remote_data_source.dart';
import 'package:socially/features/news_feed/data/repositories/news_feed_repository_impl.dart';
import 'package:socially/features/news_feed/domain/repositories/news_feed_repository.dart';
import 'package:socially/features/news_feed/domain/usecases/add_comment.dart';
import 'package:socially/features/news_feed/domain/usecases/delete_comment.dart';
import 'package:socially/features/news_feed/domain/usecases/get_all_posts.dart';
import 'package:socially/features/news_feed/domain/usecases/get_all_stories.dart';
import 'package:socially/features/news_feed/domain/usecases/get_comments.dart';
import 'package:socially/features/news_feed/domain/usecases/update_comment.dart';
import 'package:socially/features/news_feed/domain/usecases/upload_post.dart';
import 'package:socially/features/news_feed/presentation/bloc/comments_bloc/comments_bloc.dart';
import 'package:socially/features/news_feed/presentation/bloc/news_feed_bloc/news_feed_bloc.dart';
import 'package:socially/features/news_feed/presentation/bloc/post_upload_bloc/post_upload_bloc.dart';
import 'package:socially/features/news_feed/presentation/bloc/stories_bloc/stories_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
