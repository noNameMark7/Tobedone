import UIKit

class SideMenuViewController: UIViewController {

    // MARK: - UI Components
    private let sideView: UIView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}


// MARK: - Initial setup
private extension SideMenuViewController {
    
    func initialSetup() {
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .clear
        
        view.addSubview(sideView)
        
        NSLayoutConstraint.activate([
            sideView.topAnchor.constraint(equalTo: view.topAnchor),
            sideView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}


// MARK: - UITableView, UINavigationController
extension SideMenuViewController {
    
    func navigationSetup() {
        title = "Menu"
    
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
