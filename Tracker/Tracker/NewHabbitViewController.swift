//
//  NewHabbitViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 14.10.2024.
//

import UIKit

class NewHabitViewController: BasicViewController {
    var delegate: TrackersViewControllerProtocol?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackerNameTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 17
    
        textField.backgroundColor = .ysBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tableView: UITableView  = {
        let table = UITableView()
        table.backgroundColor = .ysWhite
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // Кнопка "Отменить"
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.ysRed.cgColor
        return button
    }()
    
    // Кнопка "Создать"
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ysGray
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let hStackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 8
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        return hStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
    }
    
    private func drawSelf(){
        view.backgroundColor = .ysWhite

        view.addSubview(titleLabel)
        view.addSubview(trackerNameTextField)
        view.addSubview(tableView)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trackerNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            trackerNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackerNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension NewHabitViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            // Переход на экран выбора категории
            print("0")
            //let categoryVC = CategoryViewController()
            //navigationController?.pushViewController(categoryVC, animated: true)
        } else {
            print("1")
            // Переход на экран расписания
            //let scheduleVC = ScheduleViewController()
            //navigationController?.pushViewController(scheduleVC, animated: true)
            
        }
    }
    
    // Задаем высоту ячеек
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75 // Высота каждой ячейки
    }
}

extension NewHabitViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Настройка текста для каждой ячейки
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
        } else {
            cell.textLabel?.text = "Расписание"
        }
        
        // Добавление стрелки справа
        cell.accessoryType = .disclosureIndicator
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        // Стилизация фона и текста
        cell.backgroundColor = .ysBackground
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel?.textColor = .black
        
        return cell
    }
}
