import UIKit

class ActionHelpers {
    
    static private func presentDeleteConfirmation(
        in viewController: UIViewController,
        for task: ToDoListItem,
        viewModel: MainScreenViewModel,
        completion: @escaping (Bool) -> Void
    ) {
        let alert = UIAlertController(
            title: "Warning",
            message: "The task will be deleted, do you want to confirm this?",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: "Confirm",
            style: .destructive
        ) {  _ in
            viewModel.deleteTask(task)
            completion(true)
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        ) { _ in completion(false) }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true)
    }
    
    static func presentEditTask(
        in viewController: UIViewController,
        task: ToDoListItem,
        delegate: AddTaskViewControllerDelegate?,
        transitioningDelegate: UIViewControllerTransitioningDelegate?,
        completion: @escaping (Bool) -> Void
    ) {
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = delegate
        addTaskVC.taskToEdit = task
        addTaskVC.modalPresentationStyle = .custom
        addTaskVC.transitioningDelegate = transitioningDelegate
        viewController.present(addTaskVC, animated: true)
        completion(true)
    }
    
    static func createDeleteAction(
        for task: ToDoListItem,
        viewModel: MainScreenViewModel,
        in viewController: UIViewController
    ) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            presentDeleteConfirmation(in: viewController, for: task, viewModel: viewModel, completion: completionHandler)
        }
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: "trash.circle")
        return action
    }
    
    static func createPriorityAction(
        for task: ToDoListItem,
        viewModel: MainScreenViewModel
    ) -> UIContextualAction {
        let title = task.isPriority ? "Remove priority" : "Priority"
        let imageName = task.isPriority ? "star.slash" : "star"
        
        let action = UIContextualAction(style: .normal, title: title) { _, _, completionHandler in
            viewModel.togglePriority(for: task)
            completionHandler(true)
        }
        action.backgroundColor = .systemOrange
        action.image = UIImage(systemName: imageName)
        return action
    }
    
    static func createCompleteAction(
        for task: ToDoListItem,
        viewModel: MainScreenViewModel
    ) -> UIContextualAction {
        let completedTitle = task.isDone ? "Undone" : "Done"
        let imageName = task.isDone ? "arrow.uturn.left.circle" : "checkmark.circle"
        
        let action = UIContextualAction(style: .normal, title: completedTitle) { _, _, completionHandler in
            viewModel.toggleCompletion(for: task)
            completionHandler(true)
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: imageName)
        return action
    }
    
    static func createEditAction(
        for task: ToDoListItem,
        in viewController: UIViewController,
        delegate: AddTaskViewControllerDelegate?,
        transitioningDelegate: UIViewControllerTransitioningDelegate?
    ) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { _, _, completionHandler in
            presentEditTask(
                in: viewController,
                task: task,
                delegate: delegate,
                transitioningDelegate: transitioningDelegate,
                completion: completionHandler
            )
        }
        action.backgroundColor = .systemBlue
        action.image = UIImage(systemName: "pencil.circle")
        return action
    }
}
