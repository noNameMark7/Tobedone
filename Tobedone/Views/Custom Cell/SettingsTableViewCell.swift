import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
        
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "Akatsuki Cloud")
        imageView.isHidden = true
        return imageView
    }()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}


// MARK: - Initial Setup
private extension SettingsTableViewCell {
    
    func initialSetup() {
        configureUI()
    }
    
    func configureUI() {
    }
}


// MARK: - Cell Configuration
extension SettingsTableViewCell {
   
}
