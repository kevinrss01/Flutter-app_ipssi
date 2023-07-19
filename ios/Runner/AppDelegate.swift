import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() // Initialise Firebase
    GeneratedPluginRegistrant.register(with: self) // Enregistre les plugins Flutter
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}