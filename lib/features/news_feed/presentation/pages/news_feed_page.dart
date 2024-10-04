import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:socially/core/common/widgets/buttons/app_elevated_button.dart';
import 'package:socially/core/common/widgets/buttons/app_text_button.dart';
import 'package:socially/core/common/widgets/loading/loading_indicator.dart';
import 'package:socially/core/extenstions/extensions.dart';
import 'package:socially/core/utils/show_snackbar.dart';
import 'package:socially/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:socially/features/news_feed/domain/entities/post.dart';
import 'package:socially/features/news_feed/presentation/bloc/news_feed_bloc/news_feed_bloc.dart';
import 'package:socially/features/news_feed/presentation/bloc/stories_bloc/stories_bloc.dart';
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
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      context
          .read<NewsFeedBloc>()
          .add(NewsFeedNextPageRequested(pageNumber: pageKey));
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<NewsFeedBloc, NewsFeedState>(
            listener: (context, state) {
              if (state.error != null) {
                showSnackBar(context, state.error.toString());
              }
              _pagingController.value = PagingState(
                itemList: state.itemList,
                nextPageKey: state.nextPage,
                error: state.error,
              );
            },
          ),
          BlocListener<StoriesBloc, StoriesState>(
            listener: (context, state) {
              if (state is StoriesFailure) {
                showSnackBar(context, state.error);
              }
            },
          ),
        ],
        child: CustomScrollView(
          slivers: [
            BlocBuilder<StoriesBloc, StoriesState>(
              builder: (context, state) {
                if (state is StoriesLoaded && state.userStories.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
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
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(width: 15);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (state is StoriesLoading) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 125,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
              },
            ),
            PagedSliverList<int, Post>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Post>(
                itemBuilder: (context, post, index) {
                  return PostCard(
                    post: post,
                  );
                },
                firstPageProgressIndicatorBuilder: (context) =>
                    const LoadingIndicator(),
                newPageProgressIndicatorBuilder: (context) =>
                    const LoadingIndicator(),
                firstPageErrorIndicatorBuilder: (context) => const Center(
                  child: Text('Error loading posts.'),
                ),
                noItemsFoundIndicatorBuilder: (context) => const Center(
                  child: Text('No posts found.'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final value = await context.pushNamed(Routes.addPostPage);

          if (value && context.mounted) {
            _pagingController.refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
