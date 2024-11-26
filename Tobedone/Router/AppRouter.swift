import UIKit

final class AppRouter {
    
    static let shared = AppRouter()
    
    private init() {}
    
    func addNewTask(
        in viewController: UIViewController,
        delegate: AddTaskViewControllerDelegate?,
        transitioningDelegate: UIViewControllerTransitioningDelegate?
    ) {
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = delegate
        addTaskVC.transitioningDelegate = transitioningDelegate
        addTaskVC.modalPresentationStyle = .custom
        viewController.present(addTaskVC, animated: true)
    }
}
