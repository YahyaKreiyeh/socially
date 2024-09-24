import 'package:flutter/material.dart';
import 'package:socially/core/theme/app_pallete.dart';
import 'package:socially/features/news_feed/domain/entities/comment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsPage extends StatefulWidget {
  final String postId;

  const CommentsPage({super.key, required this.postId});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  late final Stream<List<Comment>> _commentsStream;
  String? _replyToCommentId;
  String? _replyToCommenterName;

  @override
  void initState() {
    super.initState();
    _commentsStream = _getCommentsStream();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Stream<List<Comment>> _getCommentsStream() {
    return supabase
        .from('comments')
        .stream(primaryKey: ['id'])
        .eq('post_id', widget.postId)
        .order('created_at')
        .map((data) {
          final comments = data.map((json) => Comment.fromJson(json)).toList();
          return _buildCommentTree(comments);
        });
  }

  List<Comment> _buildCommentTree(List<Comment> comments) {
    final Map<String, Comment> commentMap = {
      for (var c in comments) c.id!: c.copyWith(replies: [])
    };
    final List<Comment> rootComments = [];

    for (var comment in commentMap.values) {
      if (comment.parentCommentId == null) {
        rootComments.add(comment);
      } else {
        final parentComment = commentMap[comment.parentCommentId];
        if (parentComment != null) {
          parentComment.replies.add(comment);
        }
      }
    }

    return rootComments;
  }

  void _addComment() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) return;

    final commentData = {
      'post_id': widget.postId,
      'commenter_id': currentUser.id,
      'content': content,
      'parent_comment_id': _replyToCommentId,
    };

    try {
      await supabase.from('comments').insert(commentData);
      _controller.clear();
      setState(() {
        _replyToCommentId = null;
        _replyToCommenterName = null;
      });
    } catch (e) {
      null;
    }
  }

  Widget _buildCommentItem(Comment comment, {int depth = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(comment.commenterName[0].toUpperCase()),
            ),
            title: Text(comment.commenterName),
            subtitle: Text(comment.content),
            trailing: IconButton(
              icon: const Icon(Icons.reply),
              onPressed: () {
                setState(() {
                  _replyToCommentId = comment.id;
                  _replyToCommenterName = comment.commenterName;
                });
              },
            ),
          ),
          if (comment.replies.isNotEmpty)
            ...comment.replies
                .map((reply) => _buildCommentItem(reply, depth: depth + 1)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = _replyToCommentId != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: _commentsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No comments yet.'));
                } else {
                  final comments = snapshot.data!;
                  return ListView(
                    children: comments
                        .map((comment) => _buildCommentItem(comment))
                        .toList(),
                  );
                }
              },
            ),
          ),
          if (isReplying)
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to $_replyToCommenterName',
                      style: const TextStyle(color: AppPallete.blackColor),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _replyToCommentId = null;
                        _replyToCommenterName = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
