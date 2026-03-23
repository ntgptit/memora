import 'package:memora/core/config/app_keys.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/core/storage/preferences_storage.dart';
import 'package:memora/presentation/features/settings/providers/settings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  SettingsState build() {
    final storage = ref.watch(preferencesStorageProvider);
    final rawLastBackupAt = storage.read<String>(
      AppKeys.lastBackupAtStorageKey,
    );

    return SettingsState(
      ttsEnabled: storage.read<bool>(AppKeys.ttsEnabledStorageKey) ?? true,
      reviewSoundsEnabled:
          storage.read<bool>(AppKeys.reviewSoundsEnabledStorageKey) ?? true,
      hapticsEnabled:
          storage.read<bool>(AppKeys.hapticsEnabledStorageKey) ?? true,
      cloudBackupEnabled:
          storage.read<bool>(AppKeys.cloudBackupEnabledStorageKey) ?? false,
      lastBackupAt: DateTime.tryParse(rawLastBackupAt ?? ''),
    );
  }

  Future<void> setTtsEnabled(bool value) async {
    state = state.copyWith(ttsEnabled: value);
    await _storage.write(AppKeys.ttsEnabledStorageKey, value);
  }

  Future<void> setReviewSoundsEnabled(bool value) async {
    state = state.copyWith(reviewSoundsEnabled: value);
    await _storage.write(AppKeys.reviewSoundsEnabledStorageKey, value);
  }

  Future<void> setHapticsEnabled(bool value) async {
    state = state.copyWith(hapticsEnabled: value);
    await _storage.write(AppKeys.hapticsEnabledStorageKey, value);
  }

  Future<void> setCloudBackupEnabled(bool value) async {
    state = state.copyWith(cloudBackupEnabled: value);
    await _storage.write(AppKeys.cloudBackupEnabledStorageKey, value);
  }

  Future<void> createBackupSnapshot() async {
    final timestamp = DateTime.now();
    state = state.copyWith(lastBackupAt: timestamp);
    await _storage.write(
      AppKeys.lastBackupAtStorageKey,
      timestamp.toIso8601String(),
    );
  }

  Future<void> clearBackupSnapshot() async {
    state = state.copyWith(clearLastBackupAt: true);
    await _storage.delete(AppKeys.lastBackupAtStorageKey);
  }

  PreferencesStorage get _storage => ref.read(preferencesStorageProvider);
}
