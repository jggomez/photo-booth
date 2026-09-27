import 'dart:typed_data';
import '../repositories/i_event_config_repository.dart';

/// Business use case to validate and upload event assets (logos, mascots).
class UploadEventAssetUseCase {
  final IEventConfigRepository _repository;

  static const _allowedExtensions = ['.png', '.jpg', '.jpeg', '.webp', '.svg'];

  const UploadEventAssetUseCase(this._repository);

  Future<String> execute({
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (bytes.isEmpty) {
      throw ArgumentError('El archivo no puede estar vacío.');
    }

    final trimmedName = fileName.trim().toLowerCase();
    if (trimmedName.isEmpty) {
      throw ArgumentError('El nombre de archivo no puede estar vacío.');
    }

    final hasValidExt = _allowedExtensions.any(trimmedName.endsWith);
    if (!hasValidExt) {
      throw ArgumentError(
        'Extensión no permitida. Formatos soportados: ${_allowedExtensions.join(", ")}',
      );
    }

    return await _repository.uploadEventAsset(
      bytes: bytes,
      fileName: fileName.trim(),
    );
  }
}
