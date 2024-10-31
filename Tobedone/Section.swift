import Foundation

class Section {
    let withTitle: String
    var isOpened: Bool = true
    
    init(withTitle: String, isOpened: Bool = true) {
        self.withTitle = withTitle
        self.isOpened = isOpened
    }
}
