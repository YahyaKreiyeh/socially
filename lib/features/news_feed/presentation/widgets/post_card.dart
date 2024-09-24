import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socially/core/extenstions/extensions.dart';
import 'package:socially/core/theme/app_pallete.dart';
import 'package:socially/features/news_feed/domain/entities/post.dart';
import 'package:socially/routing/routes.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('en', timeago.EnMessages());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      margin: const EdgeInsets.all(16).copyWith(bottom: 4),
      decoration: BoxDecoration(
        color: AppPallete.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      'https://picsum.photos/id/1/1280/1920'),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    post.posterName ?? 'Anonymous',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppPallete.blackColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  timeago.format(post.updatedAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPallete.blackColor,
                  ),
                ),
              ],
            ),
          ),
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            Center(
              child: CachedNetworkImage(
                imageUrl: post.imageUrl!,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.fill,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Text(
              post.content,
              style: const TextStyle(
                fontSize: 16,
                color: AppPallete.blackColor,
              ),
            ),
          ),
          const Divider(
            endIndent: 2,
            indent: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: AppPallete.secondaryTextColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Like',
                      style: TextStyle(
                        color: AppPallete.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.pushNamed(
                      Routes.commentsPage,
                      arguments: post.id,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.chat_bubble_text,
                          color: AppPallete.secondaryTextColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Comment',
                          style: TextStyle(
                            color: AppPallete.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.bookmark_outline,
                  color: AppPallete.secondaryTextColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
