import 'package:flutter/material.dart';
import 'package:online_image_classification/model/upload_response.dart';
import 'package:online_image_classification/ui/camera_page.dart';
import 'package:image_picker/image_picker.dart';

import '../service/http_service.dart';
import '../service/image_service.dart';

class HomeProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;

  final HttpService _httpService;
  HomeProvider(this._httpService);

  bool isUploading = false;
  String? message;
  UploadResponse? uploadResponse;

  void _setImage(XFile? value) {
    imageFile = value;
    imagePath = value?.path;
    notifyListeners();
  }

  void openCamera() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      _setImage(pickedFile);
      _resetUploadState();
    }
  }

  void openGallery() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _setImage(pickedFile);
      _resetUploadState();
    }
  }

  void openCustomCamera(BuildContext context) async {
    final XFile? resultImageFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(),
      ),
    );

    if (resultImageFile != null) {
      _setImage(resultImageFile);
      _resetUploadState();
    }
  }

  void upload() async {
    if (imageFile == null || imageFile == null) return;

    isUploading = true;
    _resetUploadState();

    final bytes = await imageFile!.readAsBytes();
    final filename = imageFile!.name;

    final miniBytes = await ImageService.compressImage(bytes);

    uploadResponse = await _httpService.uploadDocument(miniBytes, filename);
    message = uploadResponse?.message;
    isUploading = false;
    notifyListeners();
  }

  void _resetUploadState() {
    message = null;
    uploadResponse = null;
    notifyListeners();
  }
}
