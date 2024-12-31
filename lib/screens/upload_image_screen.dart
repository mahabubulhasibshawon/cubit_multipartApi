import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/upload_cubit.dart';

class UploadImageScreen extends StatelessWidget {
  const UploadImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadCubit(),
      child: Scaffold(
        body: BlocConsumer<UploadCubit, UploadCubitState>(
          listener: (context, state) {
            if (state is UploadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Image uploaded successfully!")),
              );
            } else if (state is UploadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<UploadCubit>();

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: cubit.pickImage,
                    child: Container(
                      child: state is UploadImageSelected
                          ? Image.file(
                        state.image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                          : Center(child: Text('Pick image')),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: cubit.uploadImage,
                    child: Container(
                      height: 50,
                      width: 100,
                      color: Colors.blue,
                      child: Center(child: Text('Upload')),
                    ),
                  ),
                  if (state is UploadLoading)
                    CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
