import 'dart:convert';
import 'package:image_picker/image_picker.dart';

/// Ouvre la galerie de l'appareil, laisse choisir une photo, la redimensionne
/// (au chargement, via l'options natives du picker) et l'encode en base64
/// pour un stockage léger dans SharedPreferences — équivalent de
/// `resizeImageToDataUrl.ts` côté web. Retourne `null` si l'utilisateur
/// annule la sélection.
Future<String?> pickAndEncodeProfilePhoto() async {
  final picker = ImagePicker();
  final file = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 512,
    maxHeight: 512,
    imageQuality: 85,
  );
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  return base64Encode(bytes);
}
