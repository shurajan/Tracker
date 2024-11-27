//
//  NewTracker.swift
//  Tracker
//
//  Created by Alexander Bralnin on 11.11.2024.
//

import UIKit

final class NewCategoryViewController: BasicViewController {
    weak var delegate: NewCategoryDelegateProtocol?
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedStrings.NewCategory.title
        label.font = Fonts.titleMediumFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizedStrings.NewCategory.placeholder
        textField.font = Fonts.textFieldFont
        textField.textAlignment = .left
        textField.backgroundColor = AppColors.Dynamic.background
        textField.layer.cornerRadius = Constants.radius
        textField.layer.masksToBounds = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(categoryTextFieldChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedStrings.NewCategory.doneButton, for: .normal)
        button.titleLabel?.font = Fonts.titleMediumFont
        button.setTitleColor(AppColors.Dynamic.white, for: .normal)
        button.backgroundColor = AppColors.Fixed.gray
        button.isEnabled = false
        button.layer.cornerRadius = Constants.radius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    init() {
        super.init(nibName: nil, bundle: nil)
        self.screenName = AnalyticsEventData.NewCategoryScreen.name
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.Dynamic.white
        setupLayout()
    }
    
    // MARK: - Private func
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(categoryTextField)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            categoryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryTextField.heightAnchor.constraint(equalToConstant: 60),
       
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @IBAction
    private func categoryTextFieldChanged(_ textField: UITextField){
        let isEmpty = textField.text?.isEmpty ?? true
       
        if isEmpty {
            createButton.isEnabled = false
            createButton.backgroundColor = AppColors.Fixed.gray
            return
        }
        
        createButton.isEnabled = true
        createButton.backgroundColor = AppColors.Dynamic.black
    }
    
    @IBAction
    func createButtonTapped(){
        guard let category = categoryTextField.text,
              let delegate
        else {return}
        
        Log.info(message: "reporting create event")
        AnalyticsService.shared.trackEvent(event: .click, params: AnalyticsEventData.NewCategoryScreen.clickCreate)
        
        delegate.didTapCreateButton(category: category)
        dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - UITextViewDelegate
extension NewCategoryViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
