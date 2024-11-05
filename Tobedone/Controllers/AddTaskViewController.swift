import UIKit

protocol AddTaskViewControllerDelegate: AnyObject {
    func didAdd(task: String, note: String?)
}

class AddTaskViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: AddTaskViewControllerDelegate?
    
    // MARK: - UI Components
    private let addTaskTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = true
        view.isSelectable = true
        view.textAlignment = .left
        view.text = TASK_PLACEHOLDER
        view.textColor = PLACEHOLDER_COLOR
        return view
    }()
    
    private let addNoteTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = true
        view.isSelectable = true
        view.textAlignment = .left
        view.text = NOTE_PLACEHOLDER
        view.textColor = PLACEHOLDER_COLOR
        return view
    }()
    
    private let saveButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Save", for: .normal)
        view.setTitleColor(PLACEHOLDER_COLOR, for: .normal)
        view.isEnabled = false
        return view
    }()
    
    private let cancelButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Cancel", for: .normal)
        view.setTitleColor(LINK_TEXT_COLOR, for: .normal)
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let screenHeight = view.window?.windowScene?.screen.bounds.height else { return }
        guard let screenWidth = view.window?.windowScene?.screen.bounds.width else { return }
        
        preferredContentSize = CGSize(
            width: screenWidth,
            height: screenHeight / 5.8
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTaskTextView.becomeFirstResponder()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAppearance(for: traitCollection)
    }
}


// MARK: - Initial setup
private extension AddTaskViewController {
    
    func initialSetup() {
        configureUI()
        setupActions()
        setupTextViewDelegates()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(addTaskTextView)
        view.addSubview(addNoteTextView)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            addTaskTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            addTaskTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addTaskTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addTaskTextView.heightAnchor.constraint(equalToConstant: 30),
            
            addNoteTextView.topAnchor.constraint(equalTo: addTaskTextView.bottomAnchor, constant: 8),
            addNoteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addNoteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addNoteTextView.heightAnchor.constraint(equalToConstant: 30),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
        updateAppearance(for: traitCollection)
    }
    
    func setupTextViewDelegates() {
        addTaskTextView.delegate = self
        addNoteTextView.delegate = self
    }
    
    func updateAppearance(for traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .light {
            
        } else {
            
        }
    }
}


// MARK: - Actions
private extension AddTaskViewController {
    
    func setupActions() {
        let saveAction = UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.didTappedSaveButton()
        }
        
        saveButton.addAction(saveAction, for: .touchUpInside)
        
        let cancelAction = UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.didTappedCancelButton()
        }
        
        cancelButton.addAction(cancelAction, for: .touchUpInside)
    }
    
    func didTappedSaveButton() {
        let taskText = addTaskTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let noteText = addNoteTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        delegate?.didAdd(task: taskText, note: noteText.isEmpty ? EMPTY_PLACEHOLDER : noteText)
        dismiss(animated: true)
    }
    
    func didTappedCancelButton() {
        dismiss(animated: true)
    }
    
    func updateSaveButtonState() {
        let isTaskEmpty = addTaskTextView.text == TASK_PLACEHOLDER || addTaskTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isNoteEmpty = addNoteTextView.text == NOTE_PLACEHOLDER || addNoteTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        if !isTaskEmpty || !isNoteEmpty {
            saveButton.setTitleColor(LINK_TEXT_COLOR, for: .normal)
            saveButton.isEnabled = true
        } else {
            saveButton.setTitleColor(PLACEHOLDER_COLOR, for: .normal)
            saveButton.isEnabled = false
        }
    }
}


// MARK: - UITextViewDelegate
extension AddTaskViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == addTaskTextView && textView.text == TASK_PLACEHOLDER {
            textView.text = EMPTY_PLACEHOLDER
            textView.textColor = LABEL_TEXT_COLOR
        } else if textView == addNoteTextView && textView.text == NOTE_PLACEHOLDER {
            textView.text = EMPTY_PLACEHOLDER
            textView.textColor = LABEL_TEXT_COLOR
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == addTaskTextView && textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = TASK_PLACEHOLDER
            textView.textColor = PLACEHOLDER_COLOR
        } else if textView == addNoteTextView && textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = NOTE_PLACEHOLDER
            textView.textColor = PLACEHOLDER_COLOR
        }
        
        updateSaveButtonState()
    }
}
