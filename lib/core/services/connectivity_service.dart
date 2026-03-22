import 'package:memora/core/network/network_info.dart';

abstract interface class ConnectivityService {
  Future<bool> get isConnected;
}

class DefaultConnectivityService implements ConnectivityService {
  const DefaultConnectivityService(this._networkInfo);

  final NetworkInfo _networkInfo;

  @override
  Future<bool> get isConnected => _networkInfo.isConnected;
}
