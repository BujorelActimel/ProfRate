import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService {
  static Future<String> getImageUrl(String imagePath) async {
    final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
    return await ref.getDownloadURL();
  }
}