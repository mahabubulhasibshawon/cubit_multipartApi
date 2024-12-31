part of 'upload_cubit.dart';

abstract class UploadCubitState {}

class UploadInitial extends UploadCubitState {}

class UploadLoading extends UploadCubitState {}

class UploadImageSelected extends UploadCubitState {
  final File image;

  UploadImageSelected(this.image);
}

class UploadSuccess extends UploadCubitState {}

class UploadError extends UploadCubitState {
  final String message;

  UploadError(this.message);
}
