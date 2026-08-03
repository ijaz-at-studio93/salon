import 'package:flutter_test/flutter_test.dart';
import 'package:salon/service/appsflyer_service.dart';

// Covers the OneLink click-event grammar only. Everything past parseDeepLink
// needs a running app.
void main() {
  group('deep_link_value naming an action', () {
    test('takes the id from deep_link_sub1', () {
      final result = AppsFlyerService.parseDeepLink({
        'deep_link_value': 'appointment',
        'deep_link_sub1': '6712ab',
      });
      expect(result?['appointmentId'], '6712ab');
    });

    test('takes the id from a named appointment_id parameter', () {
      final result = AppsFlyerService.parseDeepLink({
        'deep_link_value': 'appointment',
        'appointment_id': '6712ab',
      });
      expect(result?['appointmentId'], '6712ab');
    });

    test('accepts booking as a synonym for appointment', () {
      final result = AppsFlyerService.parseDeepLink({
        'deep_link_value': 'booking',
        'deep_link_sub1': '6712ab',
      });
      expect(result?['appointmentId'], '6712ab');
    });

    test('is case insensitive on the action', () {
      final result = AppsFlyerService.parseDeepLink({
        'deep_link_value': 'Appointment',
        'deep_link_sub1': '6712ab',
      });
      expect(result?['appointmentId'], '6712ab');
    });

    test('prefers appointment_id over deep_link_sub1', () {
      final result = AppsFlyerService.parseDeepLink({
        'deep_link_value': 'appointment',
        'appointment_id': 'named',
        'deep_link_sub1': 'generic',
      });
      expect(result?['appointmentId'], 'named');
    });
  });

  group('deep_link_value carrying the id inline', () {
    test('reads appointment/<id>', () {
      final result = AppsFlyerService.parseDeepLink({
        'deep_link_value': 'appointment/6712ab',
      });
      expect(result?['appointmentId'], '6712ab');
    });

    test('wins over a conflicting parameter', () {
      final result = AppsFlyerService.parseDeepLink({
        'deep_link_value': 'appointment/inline',
        'deep_link_sub1': 'parameter',
      });
      expect(result?['appointmentId'], 'inline');
    });

    test('tolerates leading and trailing slashes', () {
      final result = AppsFlyerService.parseDeepLink({
        'deep_link_value': '/appointment/6712ab/',
      });
      expect(result?['appointmentId'], '6712ab');
    });
  });

  group('extras', () {
    test('reach the resolver so status is not lost', () {
      final result = AppsFlyerService.parseDeepLink({
        'deep_link_value': 'appointment',
        'deep_link_sub1': '6712ab',
        'status': 'cancelled',
      });
      expect(result?['status'], 'cancelled');
      expect(result?['appointmentId'], '6712ab');
    });
  });

  group('links with no destination', () {
    test('returns null when the id is missing everywhere', () {
      expect(
        AppsFlyerService.parseDeepLink({'deep_link_value': 'appointment'}),
        isNull,
      );
    });

    test('returns null for an unknown action', () {
      expect(
        AppsFlyerService.parseDeepLink({
          'deep_link_value': 'payout',
          'deep_link_sub1': '6712ab',
        }),
        isNull,
      );
    });

    test('returns null when deep_link_value is absent', () {
      // An attribution-only OneLink with no routing intent — a campaign link
      // that should just open the app.
      expect(
        AppsFlyerService.parseDeepLink({
          'media_source': 'sms',
          'campaign': 'staff_reactivation',
        }),
        isNull,
      );
    });

    test('returns null when deep_link_value is blank', () {
      expect(
        AppsFlyerService.parseDeepLink({'deep_link_value': '   '}),
        isNull,
      );
    });
  });
}
