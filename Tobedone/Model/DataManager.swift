import UIKit
import CoreData

final class DataManager {
    
    static let shared = DataManager(
        context: ((UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    )
    
    private let context: NSManagedObjectContext
    
    var activeTasks: [ToDoListItem] = []
    var completedTasks: [ToDoListItem] = []
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Fetch Tasks
    func fetchTasks(completion: @escaping () -> Void) {
        let fetchRequest: NSFetchRequest<ToDoListItem> = ToDoListItem.fetchRequest()
        
        do {
            let allTasks = try context.fetch(fetchRequest)
            
            activeTasks = allTasks
                .filter { !$0.isDone }
                .sorted { firstTask, secondTask in
                    if firstTask.isPriority && !secondTask.isPriority {
                        return true
                    } else if !firstTask.isPriority && secondTask.isPriority {
                        return false
                    }
                    return firstTask.position < secondTask.position
                }
            
            for (index, task) in activeTasks.enumerated() {
                task.position = Int16(index)
            }
            
            completedTasks = allTasks
                .filter { $0.isDone }
                .sorted { ($0.completionDate ?? Date.distantPast) > ($1.completionDate ?? Date.distantPast) }
            
            saveChanges()
            completion()
        } catch {
            fatalError("Failed to fetch tasks: \(error)")
        }
    }
    
    // MARK: - Create Task
    func createTask(name: String, note: String?) {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.note = note
        newItem.position = Int16(activeTasks.count)
        saveChanges()
    }
    
    // MARK: - Update Task
    func update(_ task: ToDoListItem, newName: String, newNote: String) {
        task.name = newName
        task.note = newNote
        saveChanges()
    }
    
    // MARK: - Delete Task
    func deleteTask(_ task: ToDoListItem) {
        context.delete(task)
        saveChanges()
    }
    
    // MARK: - Toggle completion
    func toggleCompletion(for task: ToDoListItem) {
        task.isDone.toggle()
        task.completionDate = task.isDone ? Date() : nil
        saveChanges()
    }
    
    // MARK: - Toggle priority
    func togglePriority(for task: ToDoListItem) {
        task.isPriority.toggle()
        // Only update position if the task is still active (not completed)
        if !task.isDone {
            if let index = activeTasks.firstIndex(of: task) {
                activeTasks[index].position = Int16(index) // Update position
            }
        }
        saveChanges()
    }
    
    // MARK: - Save Changes
    private func saveChanges() {
        do {
            try context.save()
        } catch {
            fatalError("Failed to save changes: \(error)")
        }
    }
}
