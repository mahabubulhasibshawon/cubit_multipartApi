import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/upload_cubit.dart';

class UploadImageScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  UploadImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadCubit(),
      child: Scaffold(
        body: BlocConsumer<UploadCubit, UploadCubitState>(
          listener: (context, state) {
            if (state is UploadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("all data uploaded successfully!")),
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
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                      SizedBox(height: 16),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: "Title"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Title is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: "Price"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Price is required";
                          }
                          if (double.tryParse(value) == null) {
                            return "Enter a valid number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      state is UploadLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.uploadImage(
                              titleController.text,
                              priceController.text,
                            );
                          }
                        },
                        child: Text("Submit"),
                      ),
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
