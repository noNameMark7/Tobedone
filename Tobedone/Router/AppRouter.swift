import UIKit

class AppRouter {
    
    static let shared =  AppRouter()
    
    private init() {}
    
    func navigateToSideMenu(from viewController: UIViewController) {
        let sideMenuViewController = SideMenuViewController()
        let nav = UINavigationController(rootViewController: sideMenuViewController)
        viewController.navigationController?.pushViewController(nav, animated: true)
    }
}
