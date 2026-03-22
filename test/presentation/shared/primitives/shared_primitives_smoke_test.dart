import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_danger_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_fab_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_icon_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_secondary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_date_field.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_dropdown_field.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_form_field_label.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_multiline_field.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_number_field.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_password_field.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_score_input.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_search_field.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_slider_input.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_text_field.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_time_field.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_caption_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_link_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

void main() {
  Finder richTextContaining(String text) {
    return find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText().contains(text),
    );
  }

  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  testWidgets('button primitives render with shared theme', (tester) async {
    await tester.pumpWidget(
      wrapWithApp(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppButton(text: 'Base'),
            AppPrimaryButton(text: 'Primary'),
            AppSecondaryButton(text: 'Secondary'),
            AppOutlineButton(text: 'Outline'),
            AppTextButton(text: 'Text'),
            AppDangerButton(text: 'Danger'),
            AppIconButton(icon: Icon(Icons.edit_rounded)),
            AppFabButton(
              icon: Icon(Icons.add_rounded),
              label: 'Create',
            ),
          ],
        ),
      ),
    );

    expect(find.text('Base'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Secondary'), findsOneWidget);
    expect(find.text('Outline'), findsOneWidget);
    expect(find.text('Text'), findsOneWidget);
    expect(find.text('Danger'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('input primitives render with shared theme', (tester) async {
    await tester.pumpWidget(
      wrapWithApp(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTextField(
              label: 'Name',
              hintText: 'Enter name',
            ),
            const SizedBox(height: 16),
            const AppPasswordField(label: 'Password'),
            const SizedBox(height: 16),
            const AppSearchField(label: 'Search'),
            const SizedBox(height: 16),
            const AppNumberField(label: 'Score'),
            const SizedBox(height: 16),
            const AppMultilineField(label: 'Notes'),
            const SizedBox(height: 16),
            AppDropdownField<String>(
              label: 'Deck',
              value: 'math',
              items: const [
                DropdownMenuItem(value: 'math', child: Text('Math')),
                DropdownMenuItem(value: 'history', child: Text('History')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            AppDateField(
              label: 'Review date',
              value: DateTime(2026, 3, 23),
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            const AppTimeField(
              label: 'Review time',
              value: TimeOfDay(hour: 9, minute: 30),
            ),
            const SizedBox(height: 16),
            AppSliderInput(
              label: 'Confidence',
              value: 3,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            AppScoreInput(
              label: 'Result score',
              score: 3,
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            const AppFormFieldLabel(label: 'Standalone label'),
          ],
        ),
      ),
    );

    expect(richTextContaining('Name'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Password'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Search'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Score'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Notes'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Deck'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Review date'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Review time'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Confidence'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Result score'), findsAtLeastNWidgets(1));
    expect(richTextContaining('Standalone label'), findsAtLeastNWidgets(1));
  });

  testWidgets('text primitives render with shared theme', (tester) async {
    var linkTapped = false;

    await tester.pumpWidget(
      wrapWithApp(
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: 'Base text'),
            AppTitleText(text: 'Title text'),
            AppBodyText(text: 'Body text'),
            AppCaptionText(text: 'Caption text'),
            AppLinkText(text: 'Link text'),
          ],
        ),
      ),
    );

    expect(find.text('Base text'), findsOneWidget);
    expect(find.text('Title text'), findsOneWidget);
    expect(find.text('Body text'), findsOneWidget);
    expect(find.text('Caption text'), findsOneWidget);
    expect(find.text('Link text'), findsOneWidget);

    await tester.pumpWidget(
      wrapWithApp(
        AppLinkText(
          text: 'Tap me',
          onTap: () {
            linkTapped = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('Tap me'));
    await tester.pump();

    expect(linkTapped, isTrue);
  });
}
