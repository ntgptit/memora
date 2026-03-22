abstract final class AppStrings {
  static const appName = 'Memora';
  static const splashTitle = 'Preparing your learning workspace';
  static const loading = 'Loading...';
  static const genericError = 'Something went wrong.';
  static const retry = 'Retry';
  static const dashboardTitle = 'Dashboard';
  static const dashboardFoundationTitle = 'Dashboard foundation';
  static const dashboardFoundationDescription =
      'Architecture scaffold is ready for app, core, presentation, data, domain, and l10n.';
  static const dashboardRuntimeSnapshotTitle = 'Runtime snapshot';
  static const dashboardScreenClassLabel = 'Screen class';
  static const dashboardContentMaxWidthLabel = 'Content max width';
  static const offlineTitle = 'You are offline';
  static const offlineMessage = 'Check your internet connection and try again.';
  static const offlineRetryLabel = 'Retry';
  static const maintenanceTitle = 'Maintenance';
  static const maintenanceMessage = 'The system is temporarily unavailable.';
  static const notFoundTitle = 'Page not found';
  static const notFoundMessage = 'The requested page does not exist.';
  static const clearSelectionTooltip = 'Clear selection';
  static const filterTooltip = 'Filter';
  static const sortTooltip = 'Sort';
  static const noResultsTitle = 'No results found';
  static const noResultsMessage = 'Try adjusting your filters or search terms.';
  static const accessRequiredTitle = 'Access required';
  static const signInMessage = 'Sign in to continue.';
  static const signInLabel = 'Sign in';
  static const clearDateTooltip = 'Clear date';
  static const clearTimeTooltip = 'Clear time';
  static const clearSearchTooltip = 'Clear search';
  static const selectDateLabel = 'Select date';
  static const selectTimeLabel = 'Select time';
  static const searchLabel = 'Search';
  static const requiredFieldMark = ' *';
  static const cancelLabel = 'Cancel';
  static const confirmLabel = 'Confirm';
  static const saveLabel = 'Save';
  static const developmentLabel = 'DEV';
  static const stagingLabel = 'STAGE';
  static const productionLabel = 'PROD';

  static String dashboardScreenClassMessage(String screenClass) {
    return '$dashboardScreenClassLabel: $screenClass';
  }

  static String dashboardContentMaxWidthMessage(String contentMaxWidth) {
    return '$dashboardContentMaxWidthLabel: $contentMaxWidth';
  }
}
