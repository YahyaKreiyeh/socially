import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:socially/core/common/widgets/buttons/app_elevated_button.dart';
import 'package:socially/core/common/widgets/loading/loading_indicator.dart';
import 'package:socially/core/extenstions/extensions.dart';
import 'package:socially/core/theme/app_pallete.dart';
import 'package:socially/core/utils/show_snackbar.dart';
import 'package:socially/features/news_feed/presentation/bloc/post_upload_bloc/post_upload_bloc.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;

  void selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void uploadPost() {
    if (formKey.currentState!.validate()) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<PostUploadBloc>().add(
            PostUploadRequested(
              posterId: posterId,
              content: contentController.text.trim(),
              image: image,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocProvider.of<PostUploadBloc>(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Post'),
        ),
        body: BlocConsumer<PostUploadBloc, PostUploadState>(
          listener: (context, state) {
            if (state is PostUploadFailure) {
              showSnackBar(context, state.error);
            } else if (state is PostUploadSuccess) {
              showSnackBar(context, "Post uploaded successfully!");
              context.pop(true);
            }
          },
          builder: (context, state) {
            if (state is PostUploadLoading) {
              return const LoadingIndicator();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  image!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : DottedBorder(
                                color: AppPallete.borderColor,
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [8, 4],
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: contentController,
                        decoration: const InputDecoration(
                          hintText: 'What’s on your mind?',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      AppElevatedButton(
                        width: double.infinity,
                        text: 'Post',
                        onPressed: uploadPost,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
