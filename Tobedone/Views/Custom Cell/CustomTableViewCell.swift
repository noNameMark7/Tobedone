import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "CustomTableViewCell"
    
    // MARK: - UI Components
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontManager.shared.labelFont(withSize: 15, withWeight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontManager.shared.labelFont(withSize: 12, withWeight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let isPriorityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "no_priority")
        imageView.isHidden = false
        return imageView
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "AnyDarkAppearance")
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Initial Setup
private extension CustomTableViewCell {
    
    func initialSetup() {
        configureUI()
    }
    
    func configureUI() {
        contentView.addSubview(taskLabel)
        contentView.addSubview(noteLabel)
        contentView.addSubview(isPriorityImageView)
        
        NSLayoutConstraint.activate([
            taskLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            noteLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 7),
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            isPriorityImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            isPriorityImageView.leadingAnchor.constraint(equalTo: taskLabel.trailingAnchor, constant: 7),
            isPriorityImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            isPriorityImageView.heightAnchor.constraint(equalToConstant: 23),
            isPriorityImageView.widthAnchor.constraint(equalToConstant: 23)
        ])
    }
}


// MARK: - Cell Configuration
extension CustomTableViewCell {
    
    func configurationOfValuesWith(_ task: ToDoListItem) {
        noteLabel.text = task.note
        
        if task.isDone {
            let attributedText = NSAttributedString(
                string: task.name ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray
                ]
            )
            taskLabel.attributedText = attributedText
            isPriorityImageView.isHidden = true
        } else {
            taskLabel.attributedText = NSAttributedString(string: task.name ?? "")
            isPriorityImageView.isHidden = false
            
            let imageName = task.isPriority ? "priority" : "no_priority"
            
            UIView.transition(
                with: isPriorityImageView,
                duration: 0.3,
                options: .transitionCrossDissolve
            ) {
                self.isPriorityImageView.image = UIImage(named: imageName)
            }
        }
    }
}
