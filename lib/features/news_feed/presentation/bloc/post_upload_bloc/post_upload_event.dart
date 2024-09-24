part of 'post_upload_bloc.dart';

abstract class PostUploadEvent {}

class PostUploadRequested extends PostUploadEvent {
  final String posterId;
  final String content;
  final File? image;

  PostUploadRequested(
      {required this.posterId, required this.content, this.image});
}
