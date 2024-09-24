part of 'post_upload_bloc.dart';

abstract class PostUploadState {}

class PostUploadInitial extends PostUploadState {}

class PostUploadLoading extends PostUploadState {}

class PostUploadSuccess extends PostUploadState {}

class PostUploadFailure extends PostUploadState {
  final String error;

  PostUploadFailure({required this.error});
}
