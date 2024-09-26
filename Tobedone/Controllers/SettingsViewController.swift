import UIKit

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackColor: UIColor
    let handler: (() -> Void)
}

// MARK: - SettingsViewController

class SettingsViewController: UIViewController {

    // MARK: - Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var models = [SettingsOption]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configure() {
        models = Array(0...100).compactMap {
            SettingsOption(title: "Item \($0)", icon: UIImage(systemName: "house"), iconBackColor: .systemPink) {
                
            }
        }
    }
}


// MARK: - Initial setup

private extension SettingsViewController {
    
    func initialSetup() {
        configureUI()
        navigationSetup()
        tableViewSetup()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
    }
}


// MARK: - UITableView, UINavigationController

extension SettingsViewController {
    
    func tableViewSetup() {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "UITableViewCell"
        )
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func navigationSetup() {
        title = "Info"
    
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


// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "UITableViewCell",
            for: indexPath
        )
        cell.textLabel?.text = model.title
        return cell
    }
}
