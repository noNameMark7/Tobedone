import UIKit
import CoreData

// MARK: - ViewController

class MainScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var activeTasks = [ToDoListItem]()
    private var completedTasks = [ToDoListItem]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}


// MARK: - Initial Setup

extension MainScreenViewController {
    
    func initialSetup() {
        configureUI()
        tableViewSetup()
        navigationSetup()
    }
    
    func configureUI() {
        view.addSubview(tableView)
    }
}


// MARK: - UITableView, UINavigationController

extension MainScreenViewController {
    
    func tableViewSetup() {
        tableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        // Dynamic cell size
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        // Movable code
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
    
    func navigationSetup() {
        title = "to be done"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = FontManager.shared.navigationBarTitleAttributes(large: true)
        
        navigationController?.navigationBar.titleTextAttributes = FontManager.shared.navigationBarTitleAttributes()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTappedAddTaskButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "addButtonColorSet")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "info"),
            style: .plain,
            target: self,
            action: #selector(didTappedSettingsButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "addButtonColorSet")
    }
    
    @objc private func didTappedAddTaskButton() {
        debugPrint("Button is pressed...")
        
        let alert = UIAlertController(
            title: "New Task",
            message: "Enter new task",
            preferredStyle: .alert
        )
        
        let addAction = UIAlertAction(
            title: "Add",
            style: .default
        ) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.isEmpty else {
                return
            }
            let newPosition: Int16 = Int16(strongSelf.activeTasks.count)
            strongSelf.createItem(name: text, position: newPosition)
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        
        alert.addTextField()
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func didTappedSettingsButton() {
        let vc = SettingsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Active tasks" : "Completed tasks"
    }
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        section == 0 ? activeTasks.count : completedTasks.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let item = (indexPath.section == 0) ? activeTasks[indexPath.row] : completedTasks[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier,
            for: indexPath
        ) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configurationOfValuesWith(item)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = (indexPath.section == 0) ? activeTasks[indexPath.row] : completedTasks[indexPath.row]
        let priorityTitle = item.isPriority ? "Remove priority" : "Mark as priority"
        let completedTitle = item.isDone ? "Return to active" : "Mark as completed"
        
        let sheet = UIAlertController(
            title: "Edit Mode",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let edit = UIAlertAction(
            title: "Edit",
            style: .default
        ) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            let alert = UIAlertController(
                title: "Edit Task",
                message: "Edit task or add some note",
                preferredStyle: .alert
            )
            
            alert.addTextField { textField in
                textField.text = item.name // Existing name
                textField.placeholder = "Enter new task"
            }
            
            alert.addTextField { textField in
                textField.text = item.note // Enter note
                textField.placeholder = "Add a note (optional)"
            }
            
            let saveAction = UIAlertAction(
                title: "Save",
                style: .default
            ) { [weak self] _ in
                guard let strongSelf = self else { return }
                
                // Get text from both fields
                guard let nameField = alert.textFields?[0],
                      let noteField = alert.textFields?[1],
                      let newName = nameField.text,
                      !newName.isEmpty else {
                    return
                }
                
                let newNote = noteField.text ?? ""
                strongSelf.updateItem(item: item, newName: newName, newNote: newNote)
            }
            
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            strongSelf.present(alert, animated: true)
        }
        
        let priority = UIAlertAction(
            title: priorityTitle,
            style: .default
        ) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.markItemAsPriority(at: indexPath)
        }
        
        let completed = UIAlertAction(
            title: completedTitle,
            style: .default
        ) { [weak self] _ in
            self?.toggleTaskCompletion(item: item)
        }
    
        let delete = UIAlertAction(
            title: "Delete",
            style: .destructive
        ) { [weak self] _ in
            
            let alert = UIAlertController(
                title: "Warning",
                message: "The task will be deleted, do you want to confirm this?",
                preferredStyle: .alert
            )
            
            let confirmAction = UIAlertAction(
                title: "Confirm",
                style: .destructive
            ) { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.deleteItem(item: item)
            }
            
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true)
        }
        
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        
        sheet.addAction(edit)
        sheet.addAction(priority)
        sheet.addAction(completed)
        sheet.addAction(delete)
        sheet.addAction(cancel)
    
        present(sheet, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        let item: ToDoListItem
        
        if sourceIndexPath.section == 0 {
            item = activeTasks.remove(at: sourceIndexPath.row)
            item.isDone = true // Update for completed tasks
            completedTasks.insert(item, at: destinationIndexPath.row)
        } else {
            item = completedTasks.remove(at: sourceIndexPath.row)
            item.isDone = false // Update for active tasks
            activeTasks.insert(item, at: destinationIndexPath.row)
        }
        
        // Save changes to Core Data
        saveNewOrderToCoreData()
        tableView.reloadData()
    }
    
    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            
            let item: ToDoListItem
            
            if indexPath.section == 0 {
                item = activeTasks[indexPath.row]
                activeTasks.remove(at: indexPath.row)
            } else {
                item = completedTasks[indexPath.row]
                completedTasks.remove(at: indexPath.row)
            }
            
            tableView.beginUpdates()
            
            deleteItem(item: item)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
    
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
}


// MARK: - UITableViewDragDelegate, UITableViewDropDelegate

extension MainScreenViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        let item = (indexPath.section == 0) ? activeTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let itemProvider = NSItemProvider(object: item.name! as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return[dragItem]
    }
    
    func tableView(
        _ tableView: UITableView,
        performDropWith coordinator: UITableViewDropCoordinator
    ) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get the last index path of tableView.
            let row = tableView.numberOfRows(inSection: 0)
            destinationIndexPath = IndexPath(row: row, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(
                coordinator: coordinator,
                destinationIndexPath: destinationIndexPath,
                tableView: tableView
            )
        }
    }
    
    func reorderItems(
        coordinator: UITableViewDropCoordinator,
        destinationIndexPath: IndexPath,
        tableView: UITableView
    ) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            var movedItem: ToDoListItem
            
            // Remove the item from the original section
            if sourceIndexPath.section == 0 {
                movedItem = activeTasks.remove(at: sourceIndexPath.row)
            } else {
                movedItem = completedTasks.remove(at: sourceIndexPath.row)
            }
            
            // Update the item's status based on the destination section
            if destinationIndexPath.section == 0 {
                movedItem.isDone = false // Mark it as active
                activeTasks.insert(movedItem, at: destinationIndexPath.row)
            } else {
                movedItem.isDone = true // Mark it as completed
                completedTasks.insert(movedItem, at: destinationIndexPath.row)
            }
            
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
                tableView.insertRows(at: [destinationIndexPath], with: .automatic)
            }, completion: { _ in
                self.saveNewOrderToCoreData()
            })
            coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
        }
    }
}


// MARK: - Core Data

extension MainScreenViewController {
    
    func createItem(name: String, position: Int16) {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.position = position
        
        do {
            try context.save()
            getAllItems()
        } catch {
            let nserror = error as NSError
            fatalError("Can not create item \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getAllItems() {
        let fetchRequest: NSFetchRequest<ToDoListItem> = ToDoListItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let allTasks = try context.fetch(fetchRequest)
            
            activeTasks = allTasks.filter { !$0.isDone }
            completedTasks = allTasks.filter { $0.isDone }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            let nserror = error as NSError
            fatalError("Cannot get items \(nserror), \(nserror.userInfo)")
        }
    }

    func updateItem(item: ToDoListItem, newName: String, newNote: String) {
        item.name = newName
        item.note = newNote
        
        do {
            try context.save()
            getAllItems()
        } catch {
            let nserror = error as NSError
            fatalError("Can not delete item \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            let nserror = error as NSError
            fatalError("Can not delete item \(nserror), \(nserror.userInfo)")
        }
    }
}


// MARK: - Save new order and mark as priority

extension MainScreenViewController {
    
    func saveNewOrderToCoreData() {
        for (index, item) in activeTasks.enumerated() {
            item.position = Int16(index)
        }
        for (index, item) in completedTasks.enumerated() {
            item.position = Int16(index)
        }
        
        do {
            try context.save()
            getAllItems()
        } catch {
            let nserror = error as NSError
            fatalError("Cannot save order \(nserror), \(nserror.userInfo)")
        }
    }
    
    func markItemAsPriority(at indexPath: IndexPath) {
        let item = (indexPath.section == 0) ? activeTasks[indexPath.row] : completedTasks[indexPath.row]
        
        item.isPriority.toggle()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            let nserror = error as NSError
            fatalError("Failed to mark item as priority: \(nserror), \(nserror.userInfo)")
        }
        
        // Update the UI
        if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
            cell.isPriorityImageView.isHidden = !item.isPriority
        }
    }
    
    func toggleTaskCompletion(item: ToDoListItem) {
        item.isDone.toggle()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            let nserror = error as NSError
            fatalError("Failed to toggle task completion \(nserror), \(nserror.userInfo)")
        }
    }
}
