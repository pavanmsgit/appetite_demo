import 'package:firebase_storage/firebase_storage.dart';

void deleteFireBaseStorageItem(String fileUrl) async {
  print('CHECKING IF DELETE FILE METHOD IS WORKING YAAY');
  String filePath = fileUrl.replaceAll(
      RegExp(
          r'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/'),
      '');

  FirebaseStorage.instance
      .ref()
      .child(filePath)
      .delete()
      .then((_) => print('Successfully deleted $filePath storage item'));
}
