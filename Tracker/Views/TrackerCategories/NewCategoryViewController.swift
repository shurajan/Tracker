//
//  NewTracker.swift
//  Tracker
//
//  Created by Alexander Bralnin on 11.11.2024.
//

import UIKit

class NewCategoryViewController: LightStatusBarViewController {
    weak var delegate: NewCategoryDelegateProtocol?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.backgroundColor = .ysBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.gray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(categoryTextField)
        view.addSubview(createButton)
        
        // Title Label Constraints
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
    func createButtonTapped(){
        guard let category = categoryTextField.text,
              let delegate
        else {return}
        
        delegate.didTapCreateButton(category: category)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate
extension NewCategoryViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let length = (updatedText as NSString).length
        return length <= Constants.trackerNameMaxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
