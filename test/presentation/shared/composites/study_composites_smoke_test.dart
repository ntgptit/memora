import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/study/app_answer_result_banner.dart';
import 'package:memora/presentation/shared/composites/study/app_flashcard_face.dart';
import 'package:memora/presentation/shared/composites/study/app_score_input_dialog.dart';
import 'package:memora/presentation/shared/composites/study/app_study_progress_header.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  testWidgets('study composites render', (tester) async {
    await tester.pumpWidget(
      wrap(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppAnswerResultBanner(
              title: 'Correct',
              message: 'Well done.',
              kind: AppAnswerResultKind.correct,
            ),
            const SizedBox(height: 16),
            AppFlashcardFace(
              isRevealed: false,
              front: const Text('Front'),
              back: const Text('Back'),
              onTap: () {},
            ),
            const SizedBox(height: 16),
            const AppScoreInputDialog(
              title: 'Score answer',
              message: 'Pick a score from 1 to 5.',
              initialScore: 3,
            ),
            const SizedBox(height: 16),
            const AppStudyProgressHeader(
              title: 'Study session',
              subtitle: '12 cards left',
              progress: 0.4,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Correct'), findsOneWidget);
    expect(find.text('Well done.'), findsOneWidget);
    expect(find.text('Front'), findsOneWidget);
    expect(find.text('Score answer'), findsOneWidget);
    expect(find.text('Study session'), findsOneWidget);
    expect(find.text('12 cards left'), findsOneWidget);
  });
}
