import UIKit

// MARK: - SettingsViewController

class SettingsViewController: UIViewController {

    // MARK: - Properties
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}


// MARK: - Initial setup

extension SettingsViewController {
    
    func initialSetup() {
        view.backgroundColor = .systemBackground
        configureUI()
        navigationSetup()
    }
    
    func configureUI() {}
}


// MARK: - NavigationController

extension SettingsViewController {
    
    func navigationSetup() {
        title = "Settings"
    
        navigationController?.navigationBar.titleTextAttributes = FontManager.shared.navigationBarTitleAttributes()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTappedDoneButton)
        )
    }
    
    @objc private func didTappedDoneButton() {
        dismiss(animated: true)
    }
}
