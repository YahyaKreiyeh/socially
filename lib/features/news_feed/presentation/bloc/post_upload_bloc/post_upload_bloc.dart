import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/news_feed/domain/usecases/upload_post.dart';

part 'post_upload_event.dart';
part 'post_upload_state.dart';

class PostUploadBloc extends Bloc<PostUploadEvent, PostUploadState> {
  final UploadPost uploadPostUseCase;

  PostUploadBloc({required this.uploadPostUseCase})
      : super(PostUploadInitial()) {
    on<PostUploadRequested>(_onPostUploadRequested);
  }

  void _onPostUploadRequested(
    PostUploadRequested event,
    Emitter<PostUploadState> emit,
  ) async {
    emit(PostUploadLoading());
    final result = await uploadPostUseCase(
      UploadPostParams(
          posterId: event.posterId, content: event.content, image: event.image),
    );
    result.fold(
      (failure) =>
          emit(PostUploadFailure(error: _mapFailureToMessage(failure))),
      (_) => emit(PostUploadSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case Failure():
        return 'Server Error';
      default:
        return 'Unexpected Error';
    }
  }
}
