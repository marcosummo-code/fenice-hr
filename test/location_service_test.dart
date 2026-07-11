import 'package:flutter_test/flutter_test.dart';
import 'package:hr/services/location_service.dart';

void main() {
  group('LocationService', () {
    test(
      'buildAddressText returns a readable address when parts are available',
      () {
        final address = LocationService.buildAddressText(
          parts: ['Via Roma 10', 'Milano', 'MI', 'Italia'],
          lat: 45.4642,
          lng: 9.1900,
        );

        expect(address, 'Via Roma 10, Milano, MI, Italia');
      },
    );

    test(
      'buildAddressText falls back to coordinates when no address parts exist',
      () {
        final address = LocationService.buildAddressText(
          parts: [null, '', '   '],
          lat: 45.4642,
          lng: 9.1900,
        );

        expect(address, 'Lat: 45.464200, Lng: 9.190000');
      },
    );
  });
}
