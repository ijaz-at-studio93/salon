import UIKit
import Flutter
import FirebaseCore
import GoogleMaps
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      if #available(iOS 12.0, *) {
        UNUserNotificationCenter.current().delegate = self
      }
    GMSServices.provideAPIKey("AIzaSyDdvZgn2cnPXchnUDNLIl1WA6HFPhwt8WI")
    GeneratedPluginRegistrant.register(with: self)
    // Ensures APNs registration runs early so FCM can resolve a device token.
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Allow local notifications (from flutter_local_notifications) to show as banners
  // while the app is in foreground. FCM remote notifications are intercepted by the
  // Firebase plugin before reaching here, so this does NOT cause double banners.
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .badge, .sound])
    } else {
      completionHandler([.alert, .badge, .sound])
    }
  }
}
