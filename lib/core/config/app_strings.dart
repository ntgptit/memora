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
  static const maintenanceTitle = 'Maintenance';
  static const maintenanceMessage = 'The system is temporarily unavailable.';
  static const notFoundTitle = 'Page not found';
  static const notFoundMessage = 'The requested page does not exist.';
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
