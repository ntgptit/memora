import 'package:memora/core/storage/local_storage.dart';

class SecureStorage extends InMemoryLocalStorage {
  SecureStorage({super.seed = const <String, Object?>{}});
}
