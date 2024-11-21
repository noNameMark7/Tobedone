import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "CustomTableViewCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        imageView.image = #imageLiteral(resourceName: "Akatsuki Cloud")
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAppearance(for: traitCollection)
    }
}


// MARK: - Initial Setup
private extension CustomTableViewCell {
    
    func initialSetup() {
        configureUI()
    }
    
    func configureUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(taskLabel)
        containerView.addSubview(noteLabel)
        containerView.addSubview(isPriorityImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            taskLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            taskLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            noteLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 7),
            noteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            noteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            noteLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            isPriorityImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            isPriorityImageView.leadingAnchor.constraint(equalTo: taskLabel.trailingAnchor, constant: 7),
            isPriorityImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            isPriorityImageView.heightAnchor.constraint(equalToConstant: 14.6),
            isPriorityImageView.widthAnchor.constraint(equalToConstant: 22)
        ])
        
        updateAppearance(for: traitCollection)
    }
    
    func updateAppearance(for traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            contentView.backgroundColor = #colorLiteral(red: 0.09698758538, green: 0.0979478585, blue: 0.0979478585, alpha: 1)
        } else {
            contentView.backgroundColor = #colorLiteral(red: 0.8187154134, green: 0.6849408206, blue: 0.3920946181, alpha: 1)
        }
    }
}


// MARK: - Cell Configuration
extension CustomTableViewCell {
    
    func configurationOfValuesWith(_ task: ToDoListItem) {
        noteLabel.text = task.note
        isPriorityImageView.isHidden = !task.isPriority
        
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
        }
    }
}
