import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
        
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
   
    public func configure() {
        
    }
}
