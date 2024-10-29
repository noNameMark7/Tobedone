import UIKit

class AddTaskViewController: UIViewController {
    
    // MARK: - Properties
    
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}


// MARK: - Initial Setup

private extension AddTaskViewController {
    
    func initialSetup() {
        configureUI()
        setupAction()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}


// MARK: - Actions

private extension AddTaskViewController {
    
    func setupAction() {
        
    }
}
