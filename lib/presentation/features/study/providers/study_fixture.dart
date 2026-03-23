import 'package:memora/presentation/features/study/providers/study_blueprint_models.dart';
import 'package:memora/presentation/features/study/providers/study_core_models.dart';

const _deckTitle = 'Everyday Korean Sprint';
const _deckFolder = 'Language Lab / Commute';
const _exitLabel = 'Exit';
const _platformLabel = 'Platform';
const _transferLabel = 'Transfer';
const _ticketGateLabel = 'Ticket gate';
const _ticketLabel = 'Ticket';
const _entranceLabel = 'Entrance';
const _askArrivalTimeLabel = '언제 도착할까요?';
const _askEndTimeLabel = '몇 시에 끝나요?';
const _askMeetingPointLabel = '어디에서 만날까요?';
const _askOrderLabel = '무엇을 주문할까요?';
const _ticketKoreanLabel = '표';
const _transferKoreanLabel = '환승';
const _entranceKoreanLabel = '입구';

StudySessionBlueprint buildStudySessionBlueprint({
  required StudySessionType sessionType,
}) {
  const deck = StudyDeckSummary(
    deckId: 42,
    title: _deckTitle,
    folderLabel: _deckFolder,
    availableCards: 24,
    dueCards: 9,
    estimatedMinutes: 12,
    masteryRatio: 0.68,
  );

  const reviewItems = [
    StudySessionItem(
      id: 'review-1',
      prompt: '지하철',
      answer: 'Subway',
      instruction: 'Glance fast and decide whether this feels immediate.',
      note: 'Common transport word for everyday commuting.',
      pronunciation: 'jihacheol',
      speechLabel: 'ko-KR',
    ),
    StudySessionItem(
      id: 'review-2',
      prompt: '약속',
      answer: 'Appointment / promise',
      instruction: 'Keep the pace up and make a quick confidence call.',
      note: 'Used for plans with another person or a scheduled commitment.',
      pronunciation: 'yaksok',
      speechLabel: 'ko-KR',
    ),
  ];
  const recallItems = [
    StudySessionItem(
      id: 'recall-1',
      prompt: 'How do you say “to arrive” in Korean?',
      answer: '도착하다',
      instruction: 'Pause for a second before revealing the answer.',
      note: 'Useful when describing travel or scheduling.',
      pronunciation: 'dochak-hada',
      speechLabel: 'ko-KR',
    ),
    StudySessionItem(
      id: 'recall-2',
      prompt: 'Korean phrase for “I am running late”',
      answer: '늦을 것 같아요',
      instruction: 'Recall the whole phrase before you compare.',
      note: 'Softens the message and sounds polite.',
      pronunciation: 'neujeul geot gatayo',
      speechLabel: 'ko-KR',
    ),
  ];
  const guessItems = [
    StudySessionItem(
      id: 'guess-1',
      prompt: 'Choose the best meaning for “출구”.',
      answer: _exitLabel,
      instruction: 'Pick the answer that fits signage and navigation.',
      note: 'Often paired with entrance signs in stations or buildings.',
      pronunciation: 'chulgu',
      speechLabel: 'ko-KR',
      correctChoiceId: 'guess-1-a',
      choices: [
        StudyChoiceOption(id: 'guess-1-a', label: _exitLabel),
        StudyChoiceOption(id: 'guess-1-b', label: _platformLabel),
        StudyChoiceOption(id: 'guess-1-c', label: _transferLabel),
        StudyChoiceOption(id: 'guess-1-d', label: _ticketGateLabel),
      ],
    ),
    StudySessionItem(
      id: 'guess-2',
      prompt: 'Which phrase asks “Where should we meet?”',
      answer: _askMeetingPointLabel,
      instruction: 'Scan for the phrase that sets a meeting point.',
      correctChoiceId: 'guess-2-c',
      choices: [
        StudyChoiceOption(id: 'guess-2-a', label: _askArrivalTimeLabel),
        StudyChoiceOption(id: 'guess-2-b', label: _askEndTimeLabel),
        StudyChoiceOption(id: 'guess-2-c', label: _askMeetingPointLabel),
        StudyChoiceOption(id: 'guess-2-d', label: _askOrderLabel),
      ],
    ),
  ];
  const matchItems = [
    StudySessionItem(
      id: 'match-1',
      prompt: 'Match each prompt with the correct meaning.',
      answer: 'Create every pair before checking the result.',
      instruction: 'Pair one left item with one right item.',
      matchPairs: [
        StudyMatchPair(
          left: StudyMatchOption(id: 'm1-left-1', label: _ticketKoreanLabel),
          right: StudyMatchOption(id: 'm1-right-1', label: _ticketLabel),
        ),
        StudyMatchPair(
          left: StudyMatchOption(id: 'm1-left-2', label: _transferKoreanLabel),
          right: StudyMatchOption(id: 'm1-right-2', label: _transferLabel),
        ),
        StudyMatchPair(
          left: StudyMatchOption(id: 'm1-left-3', label: _entranceKoreanLabel),
          right: StudyMatchOption(id: 'm1-right-3', label: _entranceLabel),
        ),
      ],
    ),
  ];
  const fillItems = [
    StudySessionItem(
      id: 'fill-1',
      prompt: 'Type the Korean for “reservation”.',
      answer: '예약',
      instruction: 'Enter the exact word from memory.',
      inputPlaceholder: 'Type the Korean word',
      note: 'Often used when booking seats, rooms, or appointments.',
      pronunciation: 'yeyak',
      speechLabel: 'ko-KR',
    ),
    StudySessionItem(
      id: 'fill-2',
      prompt: 'Type the phrase for “Please wait a moment”.',
      answer: '잠시만 기다려 주세요',
      instruction: 'Aim for the full polite phrase.',
      inputPlaceholder: 'Type the phrase',
      pronunciation: 'jamsiman gidaryeo juseyo',
      speechLabel: 'ko-KR',
    ),
  ];

  final modeOrder = sessionType == StudySessionType.firstLearning
      ? const [
          StudyMode.review,
          StudyMode.guess,
          StudyMode.recall,
          StudyMode.match,
          StudyMode.fill,
        ]
      : const [
          StudyMode.review,
          StudyMode.recall,
          StudyMode.guess,
          StudyMode.match,
          StudyMode.fill,
        ];
  final modeMap = <StudyMode, StudyModeBlueprint>{
    StudyMode.review: const StudyModeBlueprint(
      mode: StudyMode.review,
      items: reviewItems,
    ),
    StudyMode.recall: const StudyModeBlueprint(
      mode: StudyMode.recall,
      items: recallItems,
    ),
    StudyMode.guess: const StudyModeBlueprint(
      mode: StudyMode.guess,
      items: guessItems,
    ),
    StudyMode.match: const StudyModeBlueprint(
      mode: StudyMode.match,
      items: matchItems,
    ),
    StudyMode.fill: const StudyModeBlueprint(
      mode: StudyMode.fill,
      items: fillItems,
    ),
  };

  return StudySessionBlueprint(
    deck: deck,
    sessionType: sessionType,
    modes: [for (final mode in modeOrder) modeMap[mode]!],
    resumeSummary: const StudyResumeSummary(
      sessionId: 'resume-204',
      activeMode: StudyMode.recall,
      completedItems: 3,
      totalItems: 9,
    ),
    historyEntries: [
      StudyHistoryEntry(
        id: 'history-1',
        deckTitle: _deckTitle,
        sessionType: StudySessionType.review,
        primaryMode: StudyMode.review,
        completedAt: DateTime(2026, 3, 22, 20, 15),
        masteredItems: 7,
        totalItems: 9,
        retryItems: 2,
        status: StudyHistoryStatus.completed,
      ),
      StudyHistoryEntry(
        id: 'history-2',
        deckTitle: _deckTitle,
        sessionType: StudySessionType.firstLearning,
        primaryMode: StudyMode.guess,
        completedAt: DateTime(2026, 3, 20, 7, 30),
        masteredItems: 5,
        totalItems: 8,
        retryItems: 3,
        status: StudyHistoryStatus.resumed,
      ),
      StudyHistoryEntry(
        id: 'history-3',
        deckTitle: 'Travel Phrases Warmup',
        sessionType: StudySessionType.review,
        primaryMode: StudyMode.fill,
        completedAt: DateTime(2026, 3, 18, 18, 5),
        masteredItems: 4,
        totalItems: 7,
        retryItems: 2,
        status: StudyHistoryStatus.interrupted,
      ),
    ],
  );
}
