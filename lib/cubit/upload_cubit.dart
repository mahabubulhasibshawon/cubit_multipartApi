import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

part 'upload_cubit_state.dart';

class UploadCubit extends Cubit<UploadCubitState> {
  final ImagePicker _picker;

  UploadCubit() : _picker = ImagePicker(), super(UploadInitial());

  File? image;

  Future<void> pickImage() async {
    try {
      emit(UploadLoading());
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        image = File(pickedFile.path);
        emit(UploadImageSelected(image!));
      } else {
        emit(UploadError("No image selected"));
      }
    } catch (e) {
      emit(UploadError("Failed to pick image: $e"));
    }
  }

  Future<void> uploadImage() async {
    if (image == null) {
      emit(UploadError("No image to upload"));
      return;
    }

    try {
      emit(UploadLoading());
      var stream = http.ByteStream(image!.openRead());
      stream.cast();

      var length = await image!.length();
      var uri = Uri.parse('https://fakestoreapi.com/products');

      var request = http.MultipartRequest('POST', uri);
      request.fields['title'] = 'Static title';

      var multipart = http.MultipartFile('image', stream, length);
      request.files.add(multipart);

      var response = await request.send();

      if (response.statusCode == 200) {
        emit(UploadSuccess());
      } else {
        emit(UploadError("Failed to upload image"));
      }
    } catch (e) {
      emit(UploadError("Error uploading image: $e"));
    }
  }
}
