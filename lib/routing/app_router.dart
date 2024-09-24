import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socially/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:socially/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:socially/features/auth/presentation/pages/signin_page.dart';
import 'package:socially/features/auth/presentation/pages/signup_page.dart';
import 'package:socially/features/news_feed/domain/entities/user_stories.dart';
import 'package:socially/features/news_feed/presentation/bloc/comments_bloc/comments_bloc.dart';
import 'package:socially/features/news_feed/presentation/bloc/post_upload_bloc/post_upload_bloc.dart';
import 'package:socially/features/news_feed/presentation/pages/add_post_page.dart';
import 'package:socially/features/news_feed/presentation/pages/comments_page.dart';
import 'package:socially/features/news_feed/presentation/pages/news_feed_page.dart';
import 'package:socially/features/news_feed/presentation/pages/story_view_page.dart';
import 'package:socially/init_dependencies.dart';
import 'package:socially/navigation_page.dart';
import 'package:socially/routing/routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.navigationPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: const NavigationPage(),
          ),
        );
      case Routes.signupPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: const SignUpPage(),
          ),
        );
      case Routes.signinPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: const SigninPage(),
          ),
        );
      case Routes.newsFeedPage:
        return MaterialPageRoute(
          builder: (_) => const NewsFeedPage(),
        );
      case Routes.addPostPage:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<PostUploadBloc>(),
              ),
              BlocProvider(
                create: (context) => getIt<AppUserCubit>(),
              ),
            ],
            child: const AddPostPage(),
          ),
        );
      case Routes.commentsPage:
        final postId = arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<CommentsBloc>(),
            child: CommentsPage(postId: postId),
          ),
        );
      case Routes.storyViewPage:
        arguments as Map<String, dynamic>;
        final userStoriesList =
            arguments['userStoriesList'] as List<UserStories>;
        final initialUserIndex = arguments['initialUserIndex'] as int;
        return MaterialPageRoute(
          builder: (_) => StoryViewerPage(
            userStoriesList: userStoriesList,
            initialUserIndex: initialUserIndex,
          ),
        );
      default:
        return null;
    }
  }
}
