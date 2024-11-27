import UIKit

class MainScreenViewModel {
    
    // MARK: - Properties
    let dataManager = DataManager.shared
    
    var sections: [Section] = [
        Section(withTitle: "Active tasks"),
        Section(withTitle: "Completed tasks", isOpened: false)
    ]
    
    // Reload callback
    var reloadTableView: (() -> Void)?
    
    init() {
        fetchTasks()
    }
    
    // MARK: - Fetch Tasks
    func fetchTasks() {
        dataManager.fetchTasks { [weak self] in
            self?.reloadTableView?()
        }
    }
    
    // MARK: - Create Task
    func createTask(name: String, note: String?) {
        dataManager.createTask(name: name, note: note)
        fetchTasks()
    }
    
    // MARK: - Update Task
    func updateTask(_ task: ToDoListItem, newName: String, newNote: String) {
        dataManager.update(task, newName: newName, newNote: newNote)
        fetchTasks()
    }
    
    // MARK: - Delete Task
    func deleteTask(_ task: ToDoListItem) {
        dataManager.deleteTask(task)
        fetchTasks()
    }
    
    // MARK: - Toggle Completion
    func toggleCompletion(for task: ToDoListItem) {
        dataManager.toggleCompletion(for: task)
        fetchTasks()
    }
    
    // MARK: - Toggle Priority
    func togglePriority(for task: ToDoListItem) {
        dataManager.togglePriority(for: task)
        
        dataManager.activeTasks
            .sort { firstTask, secondTask in
                if firstTask.isPriority && !secondTask.isPriority {
                    return true
                } else if !firstTask.isPriority && secondTask.isPriority {
                    return false
                }
                return firstTask.position < secondTask.position
            }
        
        for (index, task) in dataManager.activeTasks.enumerated() {
            task.position = Int16(index)
        }
        
        fetchTasks()
    }
    
    // MARK: - Accessors for TableView
    func numberOfSections() -> Int {
        sections.count
    }
    
    func titleForSection(_ section: Int) -> String {
        sections[section].withTitle
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return sections[section].isOpened
        ? (section == 0 ? dataManager.activeTasks.count : dataManager.completedTasks.count)
        : 0
    }
    
    func taskForIndexPath(_ indexPath: IndexPath) -> ToDoListItem {
        indexPath.section == 0 ? dataManager.activeTasks[indexPath.row] : dataManager.completedTasks[indexPath.row]
    }
    
    func toggleSection(_ index: Int) {
        sections[index].isOpened.toggle()
    }
}
