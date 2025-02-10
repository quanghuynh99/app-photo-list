import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = UINavigationController(rootViewController: PhotoListViewController())
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
