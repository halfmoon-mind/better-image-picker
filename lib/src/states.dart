import 'package:get/get.dart';

class GlobalStates extends GetXState {
  final RxInt _maxImageCount = 10.obs;
  int get maxImageCount => _maxImageCount.value;

  set maxImageCount(int value) => _maxImageCount.value = value;

  final selectedImagePaths = <String>[].obs;

  void addImagePath(String path) {
    selectedImagePaths.add(path);
  }

  void removeImagePath(String path) {
    selectedImagePaths.remove(path);
  }
}
