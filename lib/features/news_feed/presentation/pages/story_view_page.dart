import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:socially/core/extenstions/extensions.dart';
import 'package:socially/core/theme/app_pallete.dart';
import 'package:socially/core/utils/show_snackbar.dart';
import 'package:socially/features/news_feed/domain/entities/user_stories.dart';

class StoryViewerPage extends StatefulWidget {
  final List<UserStories> userStoriesList;
  final int initialUserIndex;

  const StoryViewerPage({
    super.key,
    required this.userStoriesList,
    required this.initialUserIndex,
  });

  @override
  StoryViewerPageState createState() => StoryViewerPageState();
}

class StoryViewerPageState extends State<StoryViewerPage>
    with SingleTickerProviderStateMixin {
  late PageController _userPageController;
  late AnimationController _animationController;

  int _currentUserIndex = 0;
  int _currentStoryIndex = 0;

  bool _isPaused = false;
  bool _isDownloading = false;
  double _verticalDrag = 0.0;

  @override
  void initState() {
    super.initState();

    _currentUserIndex = widget.initialUserIndex;
    _currentStoryIndex = 0;

    _userPageController = PageController(initialPage: _currentUserIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animationController.addStatusListener(_onAnimationStatusChanged);
    _loadStory();
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_onAnimationStatusChanged);
    _animationController.dispose();
    _userPageController.dispose();
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _nextStory();
    }
  }

  void _loadStory({bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();
    _animationController.forward();
  }

  void _nextStory() {
    final userStories = widget.userStoriesList[_currentUserIndex];

    if (_currentStoryIndex < userStories.stories.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
      _loadStory();
    } else if (_currentUserIndex < widget.userStoriesList.length - 1) {
      _currentUserIndex++;
      _currentStoryIndex = 0;
      if (_userPageController.hasClients) {
        _userPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      _loadStory();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
      _loadStory();
    } else if (_currentUserIndex > 0) {
      _currentUserIndex--;
      final userStories = widget.userStoriesList[_currentUserIndex];
      setState(() {
        _currentStoryIndex = userStories.stories.length - 1;
      });
      if (_userPageController.hasClients) {
        _userPageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      _loadStory();
    } else {
      Navigator.pop(context);
    }
  }

  void _handleTap(TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;

    if (tapPosition < width / 2) {
      _previousStory();
    } else {
      _nextStory();
    }
  }

  Future<void> _downloadImage() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final currentStory =
          widget.userStoriesList[_currentUserIndex].stories[_currentStoryIndex];
      final imageUrl = currentStory.imageUrl;

      final imageId = await ImageDownloader.downloadImage(imageUrl);
      if (imageId == null || !mounted) return;

      showSnackBar(context, 'Image saved to gallery');
    } catch (error) {
      showSnackBar(context, 'Failed to download image');
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Widget _buildProgressIndicators(UserStories userStories) {
    return Row(
      children: List.generate(
        userStories.stories.length,
        (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  double value = 0.0;
                  if (index < _currentStoryIndex) {
                    value = 1.0;
                  } else if (index == _currentStoryIndex) {
                    value = _animationController.value;
                  }
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(UserStories userStories) {
    return Positioned(
      top: 50,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppPallete.iconButtonBackgroundColor,
                  ),
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppPallete.gradient1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                userStories.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _isDownloading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.download, color: Colors.white),
                      onPressed: _downloadImage,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoryContent(UserStories userStories) {
    final currentStory = userStories.stories[_currentStoryIndex];

    return CachedNetworkImage(
      imageUrl: currentStory.imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Text(
          'Failed to load image',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userStories = widget.userStoriesList[_currentUserIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (_) {
          _isPaused = true;
          _animationController.stop();
        },
        onTapUp: _handleTap,
        onLongPressStart: (_) {
          _isPaused = true;
          _animationController.stop();
        },
        onLongPressEnd: (_) {
          _isPaused = false;
          _animationController.forward();
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            _verticalDrag += details.delta.dy;
          });
        },
        onVerticalDragEnd: (_) {
          if (_verticalDrag > 100) {
            Navigator.pop(context);
          }
          _verticalDrag = 0.0;
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _userPageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.userStoriesList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentUserIndex = index;
                  _currentStoryIndex = 0;
                });
                _loadStory();
              },
              itemBuilder: (context, userIndex) {
                final userStories = widget.userStoriesList[userIndex];
                return _buildStoryContent(userStories);
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              right: 10,
              child: _buildProgressIndicators(userStories),
            ),
            _buildTopBar(userStories),
          ],
        ),
      ),
    );
  }
}
