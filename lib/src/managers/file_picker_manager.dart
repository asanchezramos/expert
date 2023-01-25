import 'package:image_picker/image_picker.dart';

class FilePickerManager {
  static Future<String?> pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final file = await _picker.getImage(source: ImageSource.gallery);
    return file?.path;
  }
}
