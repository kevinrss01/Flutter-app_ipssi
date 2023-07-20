import UIKit
import Flutter
import Firebase
import UIKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() // Initialise Firebase
    GMSServices.provideAPIKey("AIzaSyBE6QGeG_GQMHG6otiBPEwLhW-nf92-2nI")
    GeneratedPluginRegistrant.register(with: self) // Enregistre les plugins Flutter
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}