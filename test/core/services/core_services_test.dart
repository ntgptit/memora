import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/network/network_info.dart';
import 'package:memora/core/services/connectivity_service.dart';

void main() {
  group('ConnectivityService', () {
    test('proxies current status and stream from NetworkInfo', () async {
      final networkInfo = _FakeNetworkInfo(initialStatus: true);
      final service = DefaultConnectivityService(networkInfo);

      expect(await service.isConnected, isTrue);

      final emittedStatuses = <bool>[];
      final subscription = service.onStatusChange.listen(emittedStatuses.add);

      networkInfo.emit(false);
      networkInfo.emit(true);
      await Future<void>.delayed(Duration.zero);

      expect(emittedStatuses, <bool>[false, true]);
      await subscription.cancel();
      await networkInfo.dispose();
    });
  });
}

class _FakeNetworkInfo implements NetworkInfo {
  _FakeNetworkInfo({required bool initialStatus}) : _status = initialStatus;

  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  bool _status;

  @override
  Future<bool> get isConnected async => _status;

  @override
  Stream<bool> get onStatusChange => _controller.stream;

  void emit(bool status) {
    _status = status;
    _controller.add(status);
  }

  Future<void> dispose() => _controller.close();
}
