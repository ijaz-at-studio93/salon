import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:salon/util/notification_service.dart';

/// AppsFlyer OneLink deep linking.
///
/// A OneLink carries a `deep_link_value` naming the destination plus a
/// parameter holding its id. Both are turned into the same payload shape a
/// push notification carries and handed to [handleNotification], so links and
/// notifications share one place that decides which screen opens — and one
/// place that defers it when the app is not ready yet, see [AppLaunchGate].
///
/// AppsFlyer hosts the App Link and Universal Link verification files for
/// [oneLinkHost] itself, so there is nothing to publish on a Scuts server.
class AppsFlyerService {
  AppsFlyerService._();

  static final AppsFlyerService instance = AppsFlyerService._();

  /// Account-level key, so it is deliberately the same value the customer app
  /// uses. Apps are told apart by package name and [_iosAppId], not by this.
  static const String _afDevKey = 'hMDxmwzSTzacYFDh4BRtGP';

  /// App Store numeric ID for com.ananta.saloon, without the `id` prefix that
  /// appears in store URLs. Per-app, unlike [_afDevKey] — this is what tells
  /// AppsFlyer which app record an iOS launch belongs to. Android ignores it.
  static const String _iosAppId = '6744883802';

  /// Salon has its own OneLink subdomain, separate from the customer app's
  /// scuts.onelink.me. Mirrored in AndroidManifest.xml and both .entitlements
  /// files — changing it here alone is not enough.
  static const String oneLinkHost = 'scutssaloon.onelink.me';

  /// Template path on [oneLinkHost] — full link base is
  /// https://scutssaloon.onelink.me/iM7Y/. Used as the Android intent filter's
  /// pathPrefix so the app claims only its own template on that domain.
  static const String oneLinkPathPrefix = '/iM7Y';

  /// Keys checked, in order, for the destination id. `deep_link_sub1` is
  /// AppsFlyer's generic slot and needs no template setup; the named ones let
  /// a template that defines an explicit parameter work too.
  static const List<String> _idKeys = [
    'appointment_id',
    'appointmentId',
    'deep_link_sub1',
    'id',
  ];

  AppsflyerSdk? _sdk;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    final options = AppsFlyerOptions(
      afDevKey: _afDevKey,
      appId: Platform.isIOS ? _iosAppId : '',
      showDebug: kDebugMode,
      timeToWaitForATTUserAuthorization: 50,
    );

    final sdk = AppsflyerSdk(options);
    _sdk = sdk;

    sdk.onDeepLinking(_handleDeepLink);

    // registerOnDeepLinkingCallback is what makes deferred links work: a link
    // tapped before the app existed is replayed on first launch after install.
    await sdk.initSdk(
      registerConversionDataCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    _initialized = true;
    if (kDebugMode) {
      debugPrint('[AppsFlyer] initialised');
    }
  }

  /// Ties attribution to the signed-in account. Call after login.
  void setCustomerUserId(String userId) {
    if (!_initialized || userId.isEmpty) return;
    _sdk?.setCustomerUserId(userId);
  }

  void _handleDeepLink(DeepLinkResult result) {
    switch (result.status) {
      case Status.FOUND:
        final clickEvent = result.deepLink?.clickEvent;
        if (clickEvent == null) return;
        final payload = parseDeepLink(clickEvent);
        if (payload == null) {
          debugPrint('[AppsFlyer] no destination in link: $clickEvent');
          return;
        }
        debugPrint('[AppsFlyer] opening: $payload');
        handleNotification(payload);
      case Status.NOT_FOUND:
        debugPrint('[AppsFlyer] no deep link on this launch');
      case Status.ERROR:
        debugPrint('[AppsFlyer] deep link error: ${result.error}');
      case Status.PARSE_ERROR:
        debugPrint('[AppsFlyer] deep link parse error');
    }
  }

  /// Maps a OneLink click event onto a destination payload, or null when it
  /// names nothing this app knows how to open.
  ///
  /// `deep_link_value` may be a bare action (`appointment`) or carry the id
  /// with it (`appointment/6712ab`), since either is a reasonable way to set a
  /// template up.
  ///
  /// To add a destination: add a case here returning the keys the resolver
  /// reads, and teach `handleNotification` to act on them.
  @visibleForTesting
  static Map<String, dynamic>? parseDeepLink(Map<String, dynamic> clickEvent) {
    final value = clickEvent['deep_link_value']?.toString().trim() ?? '';
    if (value.isEmpty) return null;

    final segments =
        value.split('/').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return null;

    switch (segments.first.toLowerCase()) {
      case 'appointment':
      case 'booking':
        final id = segments.length > 1
            ? segments[1]
            : _firstNonEmpty(clickEvent, _idKeys);
        if (id.isEmpty) return null;
        return {
          // Click event first so an id in deep_link_value wins, and so extras
          // the link carries (status, for one) still reach the resolver.
          ...clickEvent,
          'appointmentId': id,
        };
      default:
        return null;
    }
  }

  static String _firstNonEmpty(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }
}
