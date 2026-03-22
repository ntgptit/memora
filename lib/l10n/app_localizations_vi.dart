// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Memora';

  @override
  String get splashTitle => 'Đang chuẩn bị không gian học tập của bạn';

  @override
  String get loading => 'Đang tải...';

  @override
  String get retry => 'Thử lại';

  @override
  String get navigationDashboardLabel => 'Bảng điều khiển';

  @override
  String get navigationFoldersLabel => 'Thư mục';

  @override
  String get navigationDecksLabel => 'Bộ thẻ';

  @override
  String get navigationProgressLabel => 'Tiến độ';

  @override
  String get navigationSettingsLabel => 'Cài đặt';

  @override
  String get dashboardTitle => 'Bảng điều khiển';

  @override
  String get dashboardHeadlineSubtitle =>
      'Bám sát kế hoạch học hôm nay và xử lý khối ôn tập hữu ích tiếp theo.';

  @override
  String get dashboardSummaryTitle => 'Tổng quan hôm nay';

  @override
  String get dashboardSummarySubtitle =>
      'Cái nhìn nhanh về khối lượng học, nhịp độ và đà học tập.';

  @override
  String get dashboardSummaryDueDecksLabel => 'Bộ thẻ đến hạn';

  @override
  String get dashboardSummaryDueCardsLabel => 'Thẻ hôm nay';

  @override
  String get dashboardSummaryReviewedLabel => 'Đã ôn';

  @override
  String get dashboardSummaryFocusTimeLabel => 'Thời gian tập trung';

  @override
  String get dashboardStreakTitle => 'Chuỗi ngày học';

  @override
  String get dashboardStreakSubtitle =>
      'Sự đều đặn tạo nên khác biệt khi bạn duy trì các phiên học ngắn.';

  @override
  String get dashboardDailyGoalLabel => 'Mục tiêu hằng ngày';

  @override
  String get dashboardQuickActionsTitle => 'Thao tác nhanh';

  @override
  String get dashboardQuickActionsSubtitle =>
      'Đi thẳng vào bước hữu ích tiếp theo.';

  @override
  String get dashboardDueDecksTitle => 'Bộ thẻ đến hạn';

  @override
  String get dashboardDueDecksSubtitle =>
      'Bắt đầu với những bộ thẻ có lượng ôn tập tồn đọng cao nhất.';

  @override
  String get dashboardRefreshTooltip => 'Làm mới bảng điều khiển';

  @override
  String get dashboardStartActionLabel => 'Bắt đầu';

  @override
  String get dashboardOpenActionLabel => 'Mở';

  @override
  String get dashboardLaterActionLabel => 'Để sau';

  @override
  String get dashboardReviewActionTitle => 'Bắt đầu ôn tập';

  @override
  String get dashboardReviewActionSubtitle =>
      'Ưu tiên các bộ thẻ có số lượng đến hạn nhiều nhất trước.';

  @override
  String get dashboardCreateDeckActionTitle => 'Tạo bộ thẻ';

  @override
  String get dashboardCreateDeckActionSubtitle =>
      'Ghi lại một chủ đề mới khi ý tưởng vẫn còn rõ ràng.';

  @override
  String get dashboardImportCardsActionTitle => 'Nhập thẻ';

  @override
  String get dashboardImportCardsActionSubtitle =>
      'Đưa nội dung đã chuẩn bị vào hàng đợi để luyện tập.';

  @override
  String get dashboardReviewFocusLabel => 'Phiên ôn tập';

  @override
  String get dashboardCaptureFocusLabel => 'Chế độ ghi nhận';

  @override
  String get dashboardImportFocusLabel => 'Hàng đợi nhập';

  @override
  String get dashboardCompleteFocusLabel => 'Đã dọn sạch hộp chờ';

  @override
  String get dashboardLaterFocusLabel => 'Hàng đợi để sau';

  @override
  String get dashboardNoDueDecksSubtitle =>
      'Bạn đã xử lý xong toàn bộ bộ thẻ đến hạn trong hàng đợi hiện tại.';

  @override
  String get dashboardQuickActionsEmptyTitle => 'Hiện chưa có thao tác nhanh';

  @override
  String get dashboardQuickActionsEmptySubtitle =>
      'Hàng đợi hiện tại đang ổn định, bạn có thể tiếp tục luồng học đang diễn ra.';

  @override
  String get dashboardTravelDeckTitle => 'Cụm từ du lịch';

  @override
  String get dashboardMedicalDeckTitle => 'Thuật ngữ y khoa';

  @override
  String get dashboardVerbsDeckTitle => 'Động từ tiếng Hàn';

  @override
  String get dashboardLanguageLabFolder => 'Phòng ngôn ngữ';

  @override
  String get dashboardExamPrepFolder => 'Luyện thi';

  @override
  String get dashboardDailyPracticeFolder => 'Luyện tập hằng ngày';

  @override
  String get dashboardRecallModeLabel => 'Gợi nhớ';

  @override
  String get dashboardReviewModeLabel => 'Ôn tập';

  @override
  String get dashboardSpeedModeLabel => 'Luyện nhanh';

  @override
  String get foldersTitle => 'Thư mục';

  @override
  String get foldersPlaceholderTitle => 'Khu vực thư mục đã sẵn sàng';

  @override
  String get foldersPlaceholderMessage =>
      'Tab gốc này đã được nối vào điều hướng chung của ứng dụng. Nội dung riêng cho thư mục có thể được phát triển tiếp tại đây.';

  @override
  String get decksTitle => 'Bộ thẻ';

  @override
  String get decksPlaceholderTitle => 'Thư viện bộ thẻ đã sẵn sàng';

  @override
  String get decksPlaceholderMessage =>
      'Tab này hiện đã là một phần của app shell chung, nên danh sách và bộ lọc bộ thẻ có thể phát triển tiếp mà không cần đổi kiến trúc điều hướng.';

  @override
  String get progressTitle => 'Tiến độ';

  @override
  String get progressPlaceholderTitle => 'Không gian tiến độ đã sẵn sàng';

  @override
  String get progressPlaceholderMessage =>
      'Biểu đồ, chuỗi ngày học và lịch sử có thể được gắn vào vị trí điều hướng chung này khi feature được triển khai.';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsPlaceholderTitle => 'Trung tâm cài đặt đã sẵn sàng';

  @override
  String get settingsPlaceholderMessage =>
      'Ứng dụng đã có sẵn tab gốc cho tuỳ chọn, phù hợp để mở rộng theme, ngôn ngữ, âm thanh và sao lưu.';

  @override
  String get offlineTitle => 'Bạn đang ngoại tuyến';

  @override
  String get offlineMessage => 'Hãy kiểm tra kết nối internet và thử lại.';

  @override
  String get offlineRetryLabel => 'Thử lại';

  @override
  String get maintenanceTitle => 'Bảo trì';

  @override
  String get maintenanceMessage =>
      'Hệ thống hiện đang tạm thời không khả dụng.';

  @override
  String get notFoundTitle => 'Không tìm thấy trang';

  @override
  String get notFoundMessage => 'Trang bạn yêu cầu không tồn tại.';

  @override
  String get clearSelectionTooltip => 'Bỏ chọn';

  @override
  String get filterTooltip => 'Lọc';

  @override
  String get sortTooltip => 'Sắp xếp';

  @override
  String get noResultsTitle => 'Không tìm thấy kết quả';

  @override
  String get noResultsMessage =>
      'Hãy thử điều chỉnh bộ lọc hoặc từ khóa tìm kiếm.';

  @override
  String get accessRequiredTitle => 'Cần quyền truy cập';

  @override
  String get signInMessage => 'Đăng nhập để tiếp tục.';

  @override
  String get signInLabel => 'Đăng nhập';

  @override
  String get clearDateTooltip => 'Xóa ngày';

  @override
  String get clearTimeTooltip => 'Xóa giờ';

  @override
  String get clearSearchTooltip => 'Xóa tìm kiếm';

  @override
  String get selectDateLabel => 'Chọn ngày';

  @override
  String get selectTimeLabel => 'Chọn giờ';

  @override
  String get searchLabel => 'Tìm kiếm';

  @override
  String get requiredFieldMark => ' *';

  @override
  String selectionCountLabel(int count) {
    return 'Đã chọn $count';
  }

  @override
  String dashboardFocusChipLabel(Object focusLabel) {
    return 'Trọng tâm: $focusLabel';
  }

  @override
  String dashboardDueDeckChipLabel(Object dueDeckCount) {
    return '$dueDeckCount bộ thẻ đến hạn';
  }

  @override
  String dashboardDueCardChipLabel(Object dueCardCount) {
    return '$dueCardCount thẻ hôm nay';
  }

  @override
  String dashboardDueDeckValue(Object dueDeckCount) {
    return '$dueDeckCount bộ thẻ';
  }

  @override
  String dashboardDueCardValue(Object dueCardCount) {
    return '$dueCardCount thẻ';
  }

  @override
  String dashboardReviewedValue(Object reviewedCount) {
    return '$reviewedCount thẻ';
  }

  @override
  String dashboardStudyMinutesValue(Object minutes) {
    return '$minutes phút';
  }

  @override
  String dashboardStreakValue(Object days) {
    return '$days ngày';
  }

  @override
  String dashboardGoalProgressMessage(Object reviewed, Object goal) {
    return 'Đã ôn $reviewed / $goal thẻ hôm nay';
  }

  @override
  String dashboardGoalRemainingMessage(Object remaining) {
    return 'Còn $remaining thẻ để đạt mục tiêu hôm nay';
  }

  @override
  String dashboardDeckStatusMessage(
    Object folderName,
    Object modeLabel,
    Object mastery,
  ) {
    return '$folderName • $modeLabel • $mastery% thành thạo';
  }

  @override
  String dashboardDueCountLabel(Object dueCount) {
    return '$dueCount đến hạn';
  }
}
