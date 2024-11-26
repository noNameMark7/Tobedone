import UIKit

class MainScreenViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = MainScreenViewModel()
    private var sideMenuIsOpened = false
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var sideMenuView: UIView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1215627306, green: 0.1251553095, blue: 0.1435456147, alpha: 1)
        return view
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
        view.alpha = 0
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideMenu))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        viewModel.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAppearance(for: traitCollection)
    }
}


// MARK: - Initial Setup
private extension MainScreenViewController {
    
    func initialSetup() {
        configureUI()
        tableViewSetup()
        navigationSetup()
        sideMenuSetup()
    }
    
    func configureUI() {
        view.addSubview(tableView)
        updateAppearance(for: traitCollection)
    }
    
    func updateAppearance(for traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            tableView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        } else {
            tableView.backgroundColor = .systemBackground
        }
    }
}


// MARK: - UITableView, UINavigationController
extension MainScreenViewController {
    
    func tableViewSetup() {
        tableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func navigationSetup() {
        title = "#Tobedone"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.largeTitleTextAttributes = FontManager.shared.navigationBarTitleAttributes(large: true)
        navigationController?.navigationBar.titleTextAttributes = FontManager.shared.navigationBarTitleAttributes()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddNewTaskButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "addButtonColorSet")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(didTapSideMenuButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "addButtonColorSet")
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - viewForHeaderInSection
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerContainer = UITableViewHeaderFooterView()
        let header = HeaderView()
        header.backgroundColor = .clear
        header.delegate = self
        header.sectionIndex = section
        header.sectionsButtonView.setTitle(viewModel.sections[section].withTitle, for: .normal)
        header.sectionsButtonView.backgroundColor = section == 0 ? #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1) : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        // Add `HeaderView` as a subview to the header container
        header.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.contentView.addSubview(header)
        
        // Set constraints for `HeaderView` within the container
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: headerContainer.contentView.topAnchor),
            header.leadingAnchor.constraint(equalTo: headerContainer.contentView.leadingAnchor),
            header.bottomAnchor.constraint(equalTo: headerContainer.contentView.bottomAnchor),
            header.trailingAnchor.constraint(equalTo: headerContainer.contentView.trailingAnchor)
        ])
        
        return headerContainer
    }
    
    // MARK: - heightForHeaderInSection
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        28
    }
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    // MARK: - cellForRowAt
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let task = viewModel.taskForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier,
            for: indexPath
        ) as! CustomTableViewCell
        cell.configurationOfValuesWith(task)
        return cell
    }
    
    // MARK: - didSelectRowAt
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Cell click logic
    }
    
    // MARK: - leadingSwipeActionsConfigurationForRowAt
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let task = viewModel.taskForIndexPath(indexPath)
        
        let completeAction = ActionHelpers.createCompleteAction(
            for: task,
            viewModel: viewModel
        )
        let editAction = ActionHelpers.createEditAction(
            for: task,
            in: self,
            delegate: self,
            transitioningDelegate: self
        )
        
        return UISwipeActionsConfiguration(actions: [
            completeAction,
            editAction
        ])
    }
    
    // MARK: - trailingSwipeActionsConfigurationForRowAt
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let task = viewModel.taskForIndexPath(indexPath)
        
        let deleteAction = ActionHelpers.createDeleteAction(
            for: task,
            viewModel: viewModel,
            in: self
        )
        let priorityAction = ActionHelpers.createPriorityAction(
            for: task,
            viewModel: viewModel
        )
        
        return UISwipeActionsConfiguration(actions: [
            deleteAction,
            priorityAction
        ])
    }
}


// MARK: - HeaderViewDelegate
extension MainScreenViewController: HeaderViewDelegate {

    func callHeader(by index: Int) {
        let section = viewModel.sections[index]
        section.isOpened.toggle()

        // Prepare index paths for row updates
        var indexPaths: [IndexPath] = []
        let rowCount = (section.withTitle == "Active tasks")
        ? viewModel.dataManager.activeTasks.count
        : viewModel.dataManager.completedTasks.count

        for row in 0..<rowCount {
            indexPaths.append(IndexPath(row: row, section: index))
        }

        // Animate the row changes
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .transitionCurlDown,
            animations: {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    if section.isOpened {
                        self.tableView.insertRows(at: indexPaths, with: .fade)
                    } else {
                        self.tableView.deleteRows(at: indexPaths, with: .fade)
                    }
                    self.tableView.endUpdates()
                }
            }, completion: nil
        )
    }
}


// MARK: - UIViewControllerTransitioningDelegate
extension MainScreenViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        CustomSizePresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}


// MARK: - AddTaskViewControllerDelegate
extension MainScreenViewController: AddTaskViewControllerDelegate {
    
    func didAdd(
        task: String,
        note: String?
    ) {
        viewModel.createTask(
            name: task,
            note: note
        )
    }
    
    func didEdit(
        task: ToDoListItem,
        editedTask: String,
        editedNote: String?
    ) {
        guard let newNote = editedNote else { return }
        viewModel.updateTask(
            task,
            newName: editedTask,
            newNote: newNote
        )
    }
}


// MARK: - Actions
private extension MainScreenViewController {
    
    @objc func didTapAddNewTaskButton() {
        AppRouter.shared.addNewTask(
            in: self,
            delegate: self,
            transitioningDelegate: self
        )
    }
    
    @objc func didTapSideMenuButton() {
        toggleSideMenu()
    }
}

// MARK: - Side menu logic
private extension MainScreenViewController {
    
    func sideMenuSetup() {
        view.addSubview(dimmingView)
        view.addSubview(sideMenuView)
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            sideMenuView.topAnchor.constraint(equalTo: view.topAnchor),
            sideMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -SIDE_MENU_WIDTH),
            sideMenuView.widthAnchor.constraint(equalToConstant: SIDE_MENU_WIDTH)
        ])
    }
    
    @objc func didTapOutsideMenu() {
        if (sideMenuIsOpened) {
            toggleSideMenu()
        }
    }
    
    func toggleSideMenu() {
        sideMenuIsOpened.toggle()
        
        let sideMenuViewLeading = sideMenuIsOpened ? 0 : -SIDE_MENU_WIDTH
        let dimmingAlpha = sideMenuIsOpened ? 1 : 0
        
        UIView.animate(withDuration: 0.3) {
            self.sideMenuView.transform = CGAffineTransform(translationX: sideMenuViewLeading + SIDE_MENU_WIDTH, y: 0)
            self.dimmingView.alpha = CGFloat(dimmingAlpha)
        }
    }
}
