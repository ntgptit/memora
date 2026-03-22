abstract final class AppRoutes {
  static const splash = '/splash';
  static const dashboard = '/';
  static const offline = '/offline';
  static const maintenance = '/maintenance';
  static const notFound = '/not-found';

  static const all = <String>{
    splash,
    dashboard,
    offline,
    maintenance,
    notFound,
  };
}

abstract final class AppRouteNames {
  static const splash = 'splash';
  static const dashboard = 'dashboard';
  static const offline = 'offline';
  static const maintenance = 'maintenance';
  static const notFound = 'not_found';
}
