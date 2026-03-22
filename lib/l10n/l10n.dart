import 'package:flutter/widgets.dart';
import 'package:memora/l10n/app_localizations.dart';

export 'package:memora/l10n/app_localizations.dart';

extension L10nContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
