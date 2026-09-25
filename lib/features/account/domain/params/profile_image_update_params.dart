import 'package:dio/dio.dart' show FormData, MultipartFile;
import 'package:image_picker/image_picker.dart' show XFile;

class UpdateProfileImageParams {
  final XFile image;

  const UpdateProfileImageParams({required this.image});

  FormData toFormData() {
    return FormData.fromMap({
      'image': MultipartFile.fromFileSync(image.path, filename: image.name),
    });
  }
}
