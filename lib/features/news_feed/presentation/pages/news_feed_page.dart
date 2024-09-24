import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socially/core/common/widgets/buttons/app_elevated_button.dart';
import 'package:socially/core/common/widgets/buttons/app_text_button.dart';
import 'package:socially/core/common/widgets/loading/loading_indicator.dart';
import 'package:socially/core/extenstions/extensions.dart';
import 'package:socially/core/utils/show_snackbar.dart';
import 'package:socially/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:socially/features/news_feed/presentation/bloc/news_feed_bloc/news_feed_bloc.dart';
import 'package:socially/features/news_feed/presentation/widgets/auth_bloc_listener.dart';
import 'package:socially/features/news_feed/presentation/widgets/post_card.dart';
import 'package:socially/features/news_feed/presentation/widgets/story_card.dart';
import 'package:socially/routing/routes.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 500) {
      final state = context.read<NewsFeedBloc>().state;

      if (state is NewsFeedLoaded) {}

      if (state is NewsFeedLoaded &&
          !state.isFetchingMore &&
          !state.hasReachedEnd) {
        context
            .read<NewsFeedBloc>()
            .add(NewsFeedFetchAllData(page: (state.posts.length ~/ 10) + 1));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width > 1200
          ? null
          : AppBar(
              leading: const Icon(Icons.notifications),
              title: const Text(
                'SOCIALLY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              actions: [
                const AuthBlocListener(),
                IconButton(
                  onPressed: () {
                    _showSignOutDialog(context.read<AuthBloc>());
                  },
                  icon: const Icon(
                    Icons.logout,
                  ),
                ),
              ],
            ),
      body: BlocConsumer<NewsFeedBloc, NewsFeedState>(
        listener: (context, state) {
          if (state is NewsFeedFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is NewsFeedLoading) {
            return const LoadingIndicator();
          } else if (state is NewsFeedLoaded) {
            return ListView.builder(
              itemCount: state.posts.length + (state.isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.posts.length && state.isFetchingMore) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E2B39),
                        ),
                        height: 125,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 9,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.userStories.length,
                          itemBuilder: (context, userIndex) {
                            final userStories = state.userStories[userIndex];
                            return StoryCard(
                              userStories: userStories,
                              userIndex: userIndex,
                              allUserStories: state.userStories,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 15);
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  final post = state.posts[index - 1];
                  return PostCard(
                    post: post,
                  );
                }
              },
              controller: _scrollController,
            );
          } else if (state is NewsFeedFailure) {
            return Center(child: Text(state.error));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final value = await context.pushNamed(Routes.addPostPage);

          if (value) {
            context.read<NewsFeedBloc>().add(NewsFeedFetchAllData());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSignOutDialog(AuthBloc authBloc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          AppTextButton(
            onPressed: () => context.pop(),
            text: 'Cancel',
          ),
          AppElevatedButton(
            onPressed: () {
              authBloc.add(AuthSignOut());
            },
            text: 'Sign Out',
          ),
        ],
      ),
    );
  }
}
