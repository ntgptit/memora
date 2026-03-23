import 'package:flutter/foundation.dart';

@immutable
class SettingsState {
  const SettingsState({
    required this.ttsEnabled,
    required this.reviewSoundsEnabled,
    required this.hapticsEnabled,
    required this.cloudBackupEnabled,
    required this.lastBackupAt,
  });

  final bool ttsEnabled;
  final bool reviewSoundsEnabled;
  final bool hapticsEnabled;
  final bool cloudBackupEnabled;
  final DateTime? lastBackupAt;

  bool get hasBackupSnapshot => lastBackupAt != null;

  SettingsState copyWith({
    bool? ttsEnabled,
    bool? reviewSoundsEnabled,
    bool? hapticsEnabled,
    bool? cloudBackupEnabled,
    DateTime? lastBackupAt,
    bool clearLastBackupAt = false,
  }) {
    return SettingsState(
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      reviewSoundsEnabled: reviewSoundsEnabled ?? this.reviewSoundsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      cloudBackupEnabled: cloudBackupEnabled ?? this.cloudBackupEnabled,
      lastBackupAt: clearLastBackupAt
          ? null
          : lastBackupAt ?? this.lastBackupAt,
    );
  }
}
