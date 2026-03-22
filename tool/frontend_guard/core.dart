import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

const String ruleRequiredAppBootstrapFiles = 'REQUIRED_APP_BOOTSTRAP_FILES_EXIST';
const String ruleRequiredFrontendStructure = 'REQUIRED_FRONTEND_STRUCTURE_EXISTS';
const String ruleRequiredThemeStructure = 'REQUIRED_THEME_STRUCTURE_EXISTS';
const String ruleRequiredL10nBundles = 'REQUIRED_L10N_BUNDLES_EXIST';
const String ruleRequiredRuntimeDependencies = 'REQUIRED_RUNTIME_DEPENDENCIES_PRESENT';
const String ruleRequiredDevDependencies = 'REQUIRED_DEV_DEPENDENCIES_PRESENT';
const String ruleGeneratedFilesIgnored = 'GENERATED_FILES_ARE_GITIGNORED';
const String ruleNoManualProviderDeclaration = 'NO_MANUAL_RIVERPOD_PROVIDER_DECLARATION';
const String ruleRiverpodPartDirective = 'RIVERPOD_ANNOTATED_FILE_HAS_PART_DIRECTIVE';
const String ruleUiNoProviderDeclaration = 'UI_LAYER_NO_PROVIDER_DECLARATION';
const String ruleUiNoDataOrNetworkImport = 'UI_LAYER_NO_DATA_OR_NETWORK_IMPORT';
const String ruleNavigationUsesGoRouter = 'NAVIGATION_MUST_USE_GO_ROUTER';
const String ruleSharedWidgetsNoNavigation = 'SHARED_WIDGETS_NO_NAVIGATION';
const String rulePresentationAvoidRawThemeAccess = 'PRESENTATION_AVOID_RAW_THEME_ACCESS';

const String severityError = 'ERROR';
const String severityWarning = 'WARN';
const String reportFile = 'frontend_guard_report.json';

final RegExp _manualProviderPattern = RegExp(
  r'\b(Provider|StateProvider|FutureProvider|StreamProvider|'
  r'ChangeNotifierProvider|StateNotifierProvider|NotifierProvider|'
  r'AsyncNotifierProvider)\s*(<|\()',
);

final RegExp _riverpodAnnotationPattern = RegExp(r'@\s*(riverpod|Riverpod)\b');
final RegExp _importPattern = RegExp(r'''^\s*import\s+['"]([^'"]+)['"];''', multiLine: true);
final RegExp _navigatorPattern = RegExp(
  r'Navigator\.of\s*\(|MaterialPageRoute\s*\(|onGenerateRoute\b',
);
final RegExp _sharedNavigationPattern = RegExp(
  r'Navigator\.of\s*\(|GoRouter\.of\s*\(|context\.(go|push|replace|pop)\s*\(',
);
final RegExp _rawThemePattern = RegExp(
  r'Theme\.of\s*\(|TextTheme\.of\s*\(|ColorScheme\.of\s*\(|'
  r'styleFrom\s*\(|ButtonStyle\s*\(',
);

const List<String> _requiredAppPaths = <String>[
  'lib/main.dart',
  'lib/app/app.dart',
  'lib/app/app_router.dart',
  'lib/app/app_routes.dart',
  'lib/app/app_providers.dart',
  'lib/app/app_initializer.dart',
  'lib/app/app_lifecycle_handler.dart',
];

const List<String> _requiredFrontendPaths = <String>[
  'lib/app',
  'lib/core',
  'lib/core/config',
  'lib/core/theme',
  'lib/core/di',
  'lib/presentation',
  'lib/presentation/shared',
  'lib/presentation/shared/primitives',
  'lib/presentation/shared/composites',
  'lib/presentation/features',
  'lib/data',
  'lib/domain',
  'lib/l10n',
];

const List<String> _requiredThemePaths = <String>[
  'lib/core/theme/tokens',
  'lib/core/theme/responsive',
  'lib/core/theme/extensions',
  'lib/core/theme/component_themes',
  'lib/core/theme/app_color_scheme.dart',
  'lib/core/theme/app_text_theme.dart',
  'lib/core/theme/app_theme.dart',
  'lib/core/theme/theme_helpers.dart',
];

const List<String> _requiredL10nPaths = <String>[
  'lib/l10n/app_en.arb',
  'lib/l10n/app_vi.arb',
  'lib/l10n/app_ko.arb',
  'lib/l10n/l10n.dart',
];

const List<String> _requiredRuntimeDependencies = <String>[
  'flutter_riverpod',
  'riverpod_annotation',
  'go_router',
  'dio',
  'retrofit',
  'freezed_annotation',
  'json_annotation',
  'flutter_secure_storage',
  'shared_preferences',
  'connectivity_plus',
  'flutter_localizations',
  'intl',
];

const List<String> _requiredDevDependencies = <String>[
  'build_runner',
  'riverpod_generator',
  'retrofit_generator',
  'json_serializable',
  'freezed',
  'custom_lint',
  'yaml',
];

class Violation {
  const Violation({
    required this.rule,
    required this.severity,
    required this.file,
    required this.line,
    required this.reason,
    required this.snippet,
  });

  final String rule;
  final String severity;
  final String file;
  final int line;
  final String reason;
  final String snippet;

  String toConsole() {
    return '$file:$line: [$severity] $rule - $reason :: $snippet';
  }

  Map<String, Object> toJson() {
    return <String, Object>{
      'rule': rule,
      'severity': severity,
      'file': file,
      'line': line,
      'reason': reason,
      'snippet': snippet,
    };
  }
}

class ProjectContext {
  ProjectContext({
    required this.root,
    required this.pubspecMap,
    required this.pubspecText,
    required this.gitignoreText,
  });

  final Directory root;
  final Map<Object?, Object?> pubspecMap;
  final String pubspecText;
  final String gitignoreText;
}

class FileContext {
  FileContext({
    required this.file,
    required this.relativePath,
    required this.text,
  }) : lines = text.split('\n');

  final File file;
  final String relativePath;
  final String text;
  final List<String> lines;

  String get fileName {
    final segments = relativePath.split('/');
    return segments.isEmpty ? relativePath : segments.last;
  }

  String get fileNameWithoutExtension {
    final index = fileName.lastIndexOf('.');
    return index <= 0 ? fileName : fileName.substring(0, index);
  }
}

abstract class Rule {
  String get name;

  List<Violation> checkProject(ProjectContext context) {
    return const <Violation>[];
  }

  List<Violation> checkFile(ProjectContext context, FileContext fileContext) {
    return const <Violation>[];
  }
}

class RequiredPathsRule extends Rule {
  RequiredPathsRule({
    required this.name,
    required this.paths,
    required this.reasonPrefix,
  });

  @override
  final String name;

  final List<String> paths;
  final String reasonPrefix;

  @override
  List<Violation> checkProject(ProjectContext context) {
    final violations = <Violation>[];

    for (final relativePath in paths) {
      final entity = File('${context.root.path}\\${relativePath.replaceAll('/', '\\')}');
      final directory = Directory('${context.root.path}\\${relativePath.replaceAll('/', '\\')}');

      if (entity.existsSync() || directory.existsSync()) {
        continue;
      }

      violations.add(
        Violation(
          rule: name,
          severity: severityError,
          file: relativePath,
          line: 1,
          reason: '$reasonPrefix Missing required path "$relativePath".',
          snippet: relativePath,
        ),
      );
    }

    return violations;
  }
}

class RequiredDependenciesRule extends Rule {
  RequiredDependenciesRule({
    required this.name,
    required this.section,
    required this.dependencies,
  });

  @override
  final String name;

  final String section;
  final List<String> dependencies;

  @override
  List<Violation> checkProject(ProjectContext context) {
    final sectionMap = _readYamlSection(context.pubspecMap, section);
    final violations = <Violation>[];

    for (final dependency in dependencies) {
      if (sectionMap.containsKey(dependency)) {
        continue;
      }

      violations.add(
        Violation(
          rule: name,
          severity: severityError,
          file: 'pubspec.yaml',
          line: _lineNumberOf(context.pubspecText, dependency, defaultLine: 1),
          reason: 'Required dependency "$dependency" is missing from $section.',
          snippet: dependency,
        ),
      );
    }

    return violations;
  }
}

class GeneratedFilesIgnoredRule extends Rule {
  @override
  String get name => ruleGeneratedFilesIgnored;

  @override
  List<Violation> checkProject(ProjectContext context) {
    final violations = <Violation>[];

    for (final pattern in const <String>['*.g.dart', '*.freezed.dart']) {
      if (context.gitignoreText.split('\n').any((line) => line.trim() == pattern)) {
        continue;
      }

      violations.add(
        Violation(
          rule: name,
          severity: severityError,
          file: '.gitignore',
          line: 1,
          reason: 'Generated file pattern "$pattern" must be ignored.',
          snippet: pattern,
        ),
      );
    }

    return violations;
  }
}

class NoManualProviderDeclarationRule extends Rule {
  @override
  String get name => ruleNoManualProviderDeclaration;

  @override
  List<Violation> checkFile(ProjectContext context, FileContext fileContext) {
    if (_manualProviderPattern.hasMatch(fileContext.text) == false) {
      return const <Violation>[];
    }

    final violations = <Violation>[];
    for (var index = 0; index < fileContext.lines.length; index += 1) {
      final line = fileContext.lines[index];
      if (_manualProviderPattern.hasMatch(line) == false) {
        continue;
      }

      violations.add(
        Violation(
          rule: name,
          severity: severityError,
          file: fileContext.relativePath,
          line: index + 1,
          reason:
              'Use Riverpod annotation generated providers instead of manual provider declarations.',
          snippet: line.trim(),
        ),
      );
    }
    return violations;
  }
}

class RiverpodPartDirectiveRule extends Rule {
  @override
  String get name => ruleRiverpodPartDirective;

  @override
  List<Violation> checkFile(ProjectContext context, FileContext fileContext) {
    if (_riverpodAnnotationPattern.hasMatch(fileContext.text) == false) {
      return const <Violation>[];
    }

    final expectedPart = "part '${fileContext.fileNameWithoutExtension}.g.dart';";
    if (fileContext.text.contains(expectedPart)) {
      return const <Violation>[];
    }

    return <Violation>[
      Violation(
        rule: name,
        severity: severityError,
        file: fileContext.relativePath,
        line: 1,
        reason:
            'Files with @riverpod or @Riverpod must declare the generated part directive.',
        snippet: expectedPart,
      ),
    ];
  }
}

class UiLayerNoProviderDeclarationRule extends Rule {
  @override
  String get name => ruleUiNoProviderDeclaration;

  @override
  List<Violation> checkFile(ProjectContext context, FileContext fileContext) {
    if (_isUiFile(fileContext.relativePath) == false) {
      return const <Violation>[];
    }

    final violations = <Violation>[];
    for (var index = 0; index < fileContext.lines.length; index += 1) {
      final line = fileContext.lines[index];
      if (_riverpodAnnotationPattern.hasMatch(line) == false &&
          _manualProviderPattern.hasMatch(line) == false) {
        continue;
      }

      violations.add(
        Violation(
          rule: name,
          severity: severityError,
          file: fileContext.relativePath,
          line: index + 1,
          reason: 'UI files must not declare providers or Riverpod notifiers.',
          snippet: line.trim(),
        ),
      );
    }
    return violations;
  }
}

class UiLayerNoDataOrNetworkImportRule extends Rule {
  @override
  String get name => ruleUiNoDataOrNetworkImport;

  @override
  List<Violation> checkFile(ProjectContext context, FileContext fileContext) {
    if (_isUiFile(fileContext.relativePath) == false) {
      return const <Violation>[];
    }

    final violations = <Violation>[];
    for (final match in _importPattern.allMatches(fileContext.text)) {
      final importPath = match.group(1) ?? '';
      if (_isForbiddenUiImport(importPath) == false) {
        continue;
      }

      final line = _lineForOffset(fileContext.text, match.start);
      violations.add(
        Violation(
          rule: name,
          severity: severityError,
          file: fileContext.relativePath,
          line: line,
          reason:
              'UI files must stay render-only and must not import data, network, service, or IO layers directly.',
          snippet: importPath,
        ),
      );
    }
    return violations;
  }
}

class NavigationUsesGoRouterRule extends Rule {
  @override
  String get name => ruleNavigationUsesGoRouter;

  @override
  List<Violation> checkFile(ProjectContext context, FileContext fileContext) {
    final violations = <Violation>[];
    for (var index = 0; index < fileContext.lines.length; index += 1) {
      final line = fileContext.lines[index];
      if (_navigatorPattern.hasMatch(line) == false) {
        continue;
      }

      violations.add(
        Violation(
          rule: name,
          severity: severityError,
          file: fileContext.relativePath,
          line: index + 1,
          reason: 'Use go_router app routing instead of Navigator or MaterialPageRoute APIs.',
          snippet: line.trim(),
        ),
      );
    }
    return violations;
  }
}

class SharedWidgetsNoNavigationRule extends Rule {
  @override
  String get name => ruleSharedWidgetsNoNavigation;

  @override
  List<Violation> checkFile(ProjectContext context, FileContext fileContext) {
    if (_isSharedWidgetFile(fileContext.relativePath) == false) {
      return const <Violation>[];
    }

    final violations = <Violation>[];
    for (var index = 0; index < fileContext.lines.length; index += 1) {
      final line = fileContext.lines[index];
      if (_sharedNavigationPattern.hasMatch(line) == false) {
        continue;
      }

      violations.add(
        Violation(
          rule: name,
          severity: severityError,
          file: fileContext.relativePath,
          line: index + 1,
          reason: 'Shared widgets must remain navigation-free render components.',
          snippet: line.trim(),
        ),
      );
    }
    return violations;
  }
}

class PresentationAvoidRawThemeAccessRule extends Rule {
  @override
  String get name => rulePresentationAvoidRawThemeAccess;

  @override
  List<Violation> checkFile(ProjectContext context, FileContext fileContext) {
    if (fileContext.relativePath.startsWith('lib/presentation/') == false) {
      return const <Violation>[];
    }

    final violations = <Violation>[];
    for (var index = 0; index < fileContext.lines.length; index += 1) {
      final line = fileContext.lines[index];
      if (_rawThemePattern.hasMatch(line) == false) {
        continue;
      }

      violations.add(
        Violation(
          rule: name,
          severity: severityWarning,
          file: fileContext.relativePath,
          line: index + 1,
          reason:
              'Prefer centralized theme/context extensions over raw Theme.of or local Material style overrides in presentation code.',
          snippet: line.trim(),
        ),
      );
    }
    return violations;
  }
}

class FrontendGuardRunner {
  Future<int> run(List<String> arguments) async {
    final configuration = _parseArguments(arguments);
    if (configuration == null) {
      _printUsage();
      return 1;
    }

    final root = Directory(configuration.rootPath).absolute;
    final libDirectory = Directory('${root.path}\\lib');
    if (libDirectory.existsSync() == false) {
      stdout.writeln('No lib directory found under ${root.path}.');
      return 1;
    }

    final pubspecFile = File('${root.path}\\pubspec.yaml');
    if (pubspecFile.existsSync() == false) {
      stdout.writeln('Missing pubspec.yaml under ${root.path}.');
      return 1;
    }

    final projectContext = ProjectContext(
      root: root,
      pubspecMap: _loadPubspec(pubspecFile),
      pubspecText: await pubspecFile.readAsString(),
      gitignoreText: await _readOptionalFile('${root.path}\\.gitignore'),
    );

    final dartFiles = _collectDartFiles(root);
    if (dartFiles.isEmpty) {
      stdout.writeln('No Dart files found under lib/.');
      return 1;
    }

    final selectedNames = _resolveSelectedRuleNames(configuration.onlyFilters);
    final rules = _filterRules(_defaultRules(), selectedNames);

    final violations = <Violation>[];
    for (final rule in rules) {
      violations.addAll(rule.checkProject(projectContext));
    }
    for (final fileContext in dartFiles) {
      for (final rule in rules) {
        violations.addAll(rule.checkFile(projectContext, fileContext));
      }
    }

    violations.sort(_compareViolations);
    await _writeReport(root, violations);
    _printSummary(violations);

    final hasErrors = violations.any((violation) => violation.severity == severityError);
    if (hasErrors) {
      return 1;
    }
    if (configuration.strict && violations.isNotEmpty) {
      return 1;
    }
    return 0;
  }
}

class _CliConfiguration {
  const _CliConfiguration({
    required this.rootPath,
    required this.onlyFilters,
    required this.strict,
  });

  final String rootPath;
  final Set<String> onlyFilters;
  final bool strict;
}

List<Rule> _defaultRules() {
  return <Rule>[
    RequiredPathsRule(
      name: ruleRequiredAppBootstrapFiles,
      paths: _requiredAppPaths,
      reasonPrefix: 'App bootstrap contract violation.',
    ),
    RequiredPathsRule(
      name: ruleRequiredFrontendStructure,
      paths: _requiredFrontendPaths,
      reasonPrefix: 'Frontend structure contract violation.',
    ),
    RequiredPathsRule(
      name: ruleRequiredThemeStructure,
      paths: _requiredThemePaths,
      reasonPrefix: 'Theme foundation contract violation.',
    ),
    RequiredPathsRule(
      name: ruleRequiredL10nBundles,
      paths: _requiredL10nPaths,
      reasonPrefix: 'Localization contract violation.',
    ),
    RequiredDependenciesRule(
      name: ruleRequiredRuntimeDependencies,
      section: 'dependencies',
      dependencies: _requiredRuntimeDependencies,
    ),
    RequiredDependenciesRule(
      name: ruleRequiredDevDependencies,
      section: 'dev_dependencies',
      dependencies: _requiredDevDependencies,
    ),
    GeneratedFilesIgnoredRule(),
    NoManualProviderDeclarationRule(),
    RiverpodPartDirectiveRule(),
    UiLayerNoProviderDeclarationRule(),
    UiLayerNoDataOrNetworkImportRule(),
    NavigationUsesGoRouterRule(),
    SharedWidgetsNoNavigationRule(),
    PresentationAvoidRawThemeAccessRule(),
  ];
}

Map<String, Set<String>> _ruleGroupAliases() {
  return <String, Set<String>>{
    'structure': <String>{
      ruleRequiredAppBootstrapFiles,
      ruleRequiredFrontendStructure,
      ruleRequiredThemeStructure,
      ruleRequiredL10nBundles,
    },
    'deps': <String>{
      ruleRequiredRuntimeDependencies,
      ruleRequiredDevDependencies,
      ruleGeneratedFilesIgnored,
    },
    'state': <String>{
      ruleNoManualProviderDeclaration,
      ruleRiverpodPartDirective,
      ruleUiNoProviderDeclaration,
    },
    'ui': <String>{
      ruleUiNoDataOrNetworkImport,
      rulePresentationAvoidRawThemeAccess,
    },
    'navigation': <String>{
      ruleNavigationUsesGoRouter,
      ruleSharedWidgetsNoNavigation,
    },
    'theme': <String>{
      ruleRequiredThemeStructure,
      rulePresentationAvoidRawThemeAccess,
    },
  };
}

Set<String> _resolveSelectedRuleNames(Set<String> onlyFilters) {
  if (onlyFilters.isEmpty) {
    return <String>{};
  }

  final groups = _ruleGroupAliases();
  final selected = <String>{};
  for (final token in onlyFilters) {
    if (groups.containsKey(token)) {
      selected.addAll(groups[token]!);
      continue;
    }
    selected.add(token);
  }
  return selected;
}

List<Rule> _filterRules(List<Rule> rules, Set<String> selectedRuleNames) {
  if (selectedRuleNames.isEmpty) {
    return rules;
  }
  return rules.where((rule) => selectedRuleNames.contains(rule.name)).toList();
}

Future<void> _writeReport(Directory root, List<Violation> violations) async {
  final payload = <String, Object>{
    'summary': <String, Object>{
      'total': violations.length,
      'errors': violations.where((item) => item.severity == severityError).length,
      'warnings': violations.where((item) => item.severity == severityWarning).length,
    },
    'violations': violations.map((item) => item.toJson()).toList(),
  };

  final report = File('${root.path}\\$reportFile');
  await report.writeAsString(
    const JsonEncoder.withIndent('  ').convert(payload),
  );
}

void _printSummary(List<Violation> violations) {
  if (violations.isEmpty) {
    stdout.writeln('Frontend checklist guard passed.');
    return;
  }

  final errorCount = violations.where((item) => item.severity == severityError).length;
  final warningCount = violations.where((item) => item.severity == severityWarning).length;

  if (errorCount > 0) {
    stdout.writeln(
      'Frontend checklist guard failed. errors=$errorCount, warnings=$warningCount',
    );
  } else {
    stdout.writeln(
      'Frontend checklist guard completed with warnings. warnings=$warningCount',
    );
  }

  for (final violation in violations) {
    stdout.writeln(violation.toConsole());
  }
}

void _printUsage() {
  stdout.writeln('Frontend checklist guard for Memora Flutter client.');
  stdout.writeln('Usage:');
  stdout.writeln('  dart run tool/verify_frontend_checklists.dart');
  stdout.writeln('  dart run tool/verify_frontend_checklists.dart --strict');
  stdout.writeln('  dart run tool/verify_frontend_checklists.dart --only=state,ui');
  stdout.writeln('  dart run tool/verify_frontend_checklists.dart --root=path');
}

_CliConfiguration? _parseArguments(List<String> arguments) {
  var rootPath = '.';
  var strict = false;
  var onlyValue = '';

  for (final argument in arguments) {
    if (argument == '--strict') {
      strict = true;
      continue;
    }
    if (argument.startsWith('--root=')) {
      rootPath = argument.substring('--root='.length).trim();
      continue;
    }
    if (argument.startsWith('--only=')) {
      onlyValue = argument.substring('--only='.length).trim();
      continue;
    }
    if (argument == '--help' || argument == '-h') {
      return null;
    }
    stdout.writeln('Unknown argument: $argument');
    return null;
  }

  return _CliConfiguration(
    rootPath: rootPath.isEmpty ? '.' : rootPath,
    onlyFilters: _parseOnlyFilters(onlyValue),
    strict: strict,
  );
}

Set<String> _parseOnlyFilters(String rawValue) {
  if (rawValue.trim().isEmpty) {
    return <String>{};
  }

  return rawValue
      .split(',')
      .map((token) => token.trim())
      .where((token) => token.isNotEmpty)
      .toSet();
}

Map<Object?, Object?> _loadPubspec(File pubspecFile) {
  final text = pubspecFile.readAsStringSync();
  final yaml = loadYaml(text);
  if (yaml is YamlMap) {
    return Map<Object?, Object?>.from(yaml);
  }
  return <Object?, Object?>{};
}

Map<Object?, Object?> _readYamlSection(Map<Object?, Object?> yaml, String section) {
  final dynamic value = yaml[section];
  if (value is YamlMap) {
    return Map<Object?, Object?>.from(value);
  }
  if (value is Map<Object?, Object?>) {
    return value;
  }
  return <Object?, Object?>{};
}

Future<String> _readOptionalFile(String path) async {
  final file = File(path);
  if (file.existsSync() == false) {
    return '';
  }
  return file.readAsString();
}

List<FileContext> _collectDartFiles(Directory root) {
  final libDirectory = Directory('${root.path}\\lib');
  final fileContexts = <FileContext>[];

  for (final entity in libDirectory.listSync(recursive: true)) {
    if (entity is! File) {
      continue;
    }

    final filePath = _toPosixPath(entity.path);
    if (filePath.endsWith('.dart') == false) {
      continue;
    }
    if (filePath.endsWith('.g.dart') || filePath.endsWith('.freezed.dart')) {
      continue;
    }

    final relativePath = _relativeToRoot(root.path, entity.path);
    final text = entity.readAsStringSync();
    fileContexts.add(
      FileContext(
        file: entity,
        relativePath: relativePath,
        text: text,
      ),
    );
  }

  return fileContexts;
}

bool _isUiFile(String relativePath) {
  if (relativePath.startsWith('lib/presentation/') == false) {
    return false;
  }

  const uiFolders = <String>[
    '/screens/',
    '/widgets/',
    '/layouts/',
    '/primitives/',
    '/composites/',
  ];

  return uiFolders.any(relativePath.contains);
}

bool _isSharedWidgetFile(String relativePath) {
  return relativePath.startsWith('lib/presentation/shared/primitives/') ||
      relativePath.startsWith('lib/presentation/shared/composites/');
}

bool _isForbiddenUiImport(String importPath) {
  const exactMatches = <String>{
    'dart:io',
    'dart:convert',
    'package:dio/dio.dart',
    'package:retrofit/retrofit.dart',
  };

  if (exactMatches.contains(importPath)) {
    return true;
  }

  const partialMatches = <String>[
    '/core/network/',
    '/data/',
    '/datasources/',
    '/repositories/',
    '/services/',
  ];

  return partialMatches.any(importPath.contains);
}

String _toPosixPath(String path) {
  return path.replaceAll('\\', '/');
}

String _relativeToRoot(String rootPath, String fullPath) {
  final normalizedRoot = _toPosixPath(rootPath);
  final normalizedFull = _toPosixPath(fullPath);
  final prefix = normalizedRoot.endsWith('/') ? normalizedRoot : '$normalizedRoot/';
  if (normalizedFull.startsWith(prefix)) {
    return normalizedFull.substring(prefix.length);
  }
  return normalizedFull;
}

int _lineNumberOf(String text, String needle, {required int defaultLine}) {
  if (needle.isEmpty) {
    return defaultLine;
  }

  final offset = text.indexOf(needle);
  if (offset < 0) {
    return defaultLine;
  }
  return _lineForOffset(text, offset);
}

int _lineForOffset(String text, int offset) {
  if (offset <= 0) {
    return 1;
  }

  var line = 1;
  for (var index = 0; index < offset && index < text.length; index += 1) {
    if (text.codeUnitAt(index) == 10) {
      line += 1;
    }
  }
  return line;
}

int _compareViolations(Violation left, Violation right) {
  final severityOrder = <String, int>{
    severityError: 0,
    severityWarning: 1,
  };

  final severityComparison =
      (severityOrder[left.severity] ?? 99).compareTo(severityOrder[right.severity] ?? 99);
  if (severityComparison != 0) {
    return severityComparison;
  }

  final fileComparison = left.file.compareTo(right.file);
  if (fileComparison != 0) {
    return fileComparison;
  }

  return left.line.compareTo(right.line);
}
