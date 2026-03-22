import 'package:memora/core/storage/local_storage.dart';

class PreferencesStorage extends InMemoryLocalStorage {
  PreferencesStorage({super.seed = const <String, Object?>{}});
}
