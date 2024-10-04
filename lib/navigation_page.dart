import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socially/core/common/widgets/buttons/app_elevated_button.dart';
import 'package:socially/core/common/widgets/buttons/app_text_button.dart';
import 'package:socially/core/extenstions/extensions.dart';
import 'package:socially/core/theme/app_pallete.dart';
import 'package:socially/discover_page.dart';
import 'package:socially/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:socially/features/news_feed/presentation/bloc/news_feed_bloc/news_feed_bloc.dart';
import 'package:socially/features/news_feed/presentation/bloc/stories_bloc/stories_bloc.dart';
import 'package:socially/features/news_feed/presentation/pages/news_feed_page.dart';
import 'package:socially/features/news_feed/presentation/widgets/auth_bloc_listener.dart';
import 'package:socially/init_dependencies.dart';
import 'package:socially/profile_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final List<String> images = [
    'https://picsum.photos/id/73/200/300',
    'https://picsum.photos/id/13/200/300',
    'https://picsum.photos/id/23/200/300',
    'https://picsum.photos/id/33/200/300',
    'https://picsum.photos/id/43/200/300',
    'https://picsum.photos/id/53/200/300',
    'https://picsum.photos/id/63/200/300',
  ];

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<NewsFeedBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<StoriesBloc>()..add(FetchStories()),
        ),
        BlocProvider(
          create: (context) => getIt<AuthBloc>(),
        ),
      ],
      child: const NewsFeedPage(),
    ),
    const DiscoverPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (MediaQuery.of(context).size.width > 1200) {
            return Row(
              children: [
                NavigationRail(
                  backgroundColor: AppPallete.whiteColor,
                  selectedIconTheme:
                      const IconThemeData(color: AppPallete.whiteColor),
                  unselectedIconTheme:
                      const IconThemeData(color: AppPallete.greyColor),
                  selectedLabelTextStyle:
                      const TextStyle(color: AppPallete.blackColor),
                  unselectedLabelTextStyle:
                      const TextStyle(color: AppPallete.greyColor),
                  indicatorColor: AppPallete.blackColor,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(CupertinoIcons.house),
                      selectedIcon: Icon(CupertinoIcons.house_fill),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(CupertinoIcons.compass),
                      selectedIcon: Icon(CupertinoIcons.compass_fill),
                      label: Text('Discover'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(CupertinoIcons.person_circle),
                      selectedIcon: Icon(CupertinoIcons.person_circle_fill),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                Expanded(
                  flex: 70,
                  child: _pages[_selectedIndex],
                ),
                Expanded(
                  flex: 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 16.0,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: AppPallete.whiteColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              AppBar(
                                backgroundColor: AppPallete.whiteColor,
                                foregroundColor: AppPallete.blackColor,
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
                                      _showSignOutDialog(
                                          context.read<AuthBloc>());
                                    },
                                    icon: const Icon(
                                      Icons.logout,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  'https://picsum.photos/id/3/1280/1720',
                                ),
                                radius: 100,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text(
                                'Alex Strohl',
                                style: TextStyle(
                                  color: AppPallete.blackColor,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_outlined,
                                    color: AppPallete.blackColor,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Explore',
                                    style: TextStyle(
                                      color: AppPallete.blackColor,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              StaggeredGrid.count(
                                crossAxisCount: 6,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                                children: [
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 3,
                                    mainAxisCellCount: 2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: CachedNetworkImage(
                                          imageUrl: images[0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 3,
                                    mainAxisCellCount: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: images[1],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 3,
                                    mainAxisCellCount: 2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: images[2],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 2,
                                    mainAxisCellCount: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: images[3],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 2,
                                    mainAxisCellCount: 2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: images[4],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 2,
                                    mainAxisCellCount: 2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: images[5],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: images[6],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return _pages[_selectedIndex];
          }
        },
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width > 1200
          ? null
          : ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                backgroundColor: AppPallete.whiteColor,
                selectedItemColor: AppPallete.blackColor,
                unselectedItemColor: AppPallete.greyColor,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.house),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.compass),
                    label: 'Discover',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person_circle),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
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
