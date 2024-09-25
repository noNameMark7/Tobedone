import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var isPriority: Bool
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var position: Int16
    @NSManaged public var isDone: Bool

}

extension ToDoListItem : Identifiable {}
