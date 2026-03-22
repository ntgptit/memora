#!/usr/bin/env dart
/*
 * Frontend checklist guard entrypoint.
 *
 * Run:
 *   dart run tool/verify_frontend_checklists.dart
 *   dart run tool/verify_frontend_checklists.dart --strict
 */

import 'dart:io';

import 'frontend_guard/core.dart';

Future<void> main(List<String> arguments) async {
  final exitCode = await FrontendGuardRunner().run(arguments);
  if (exitCode != 0) {
    exit(exitCode);
  }
}
