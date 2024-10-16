//
//  NewHabbitViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 14.10.2024.
//

import UIKit

enum EventType: Int {
    case one_off = 1
    case habit = 2
    
    var description: String {
        switch self {
        case .habit:
            return "Новая привычка"
        case .one_off:
            return "Нерегулярное событие"
        }
    }
}

final class NewTrackerViewController: LightStatusBarViewController {
    var delegate: TrackersViewControllerProtocol?
    
    var eventType: EventType = .one_off
    private var selectedDays = [WeekDays]()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = eventType.description
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
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
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
    
    private let categoryCell: UITableViewCell = {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "Категория"
        cell.accessoryType = .disclosureIndicator
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.backgroundColor = .ysBackground
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = .ysGray
        cell.textLabel?.textColor = .ysBlack
        
        return cell
    }()
    
    private let scheduleCell: UITableViewCell = {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "Расписание"
        cell.accessoryType = .disclosureIndicator
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.backgroundColor = .ysBackground
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = .ysGray
        cell.textLabel?.textColor = .ysBlack
        
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout(){
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
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(eventType.rawValue * 75)),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @IBAction
    private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction
    private func createButtonTapped() {
        guard let name = trackerNameTextField.text,
              !name.isEmpty,
              let delegate
        else {return}
        
        
        let schedule = (eventType == .habit) ? TrackerSchedule.weekly(selectedDays) : TrackerSchedule.specificDate(delegate.selectedDate)
        let color = (eventType == .habit) ? TrackerColor.selection1 : TrackerColor.selection2
        let emoji = (eventType == .habit) ? Emoji.angel : Emoji.broccoli

        let tracker = Tracker(id: UUID(),
                              name: name,
                              color: color,
                              emoji: emoji,
                              schedule: schedule)
        
        delegate.didCreateNewTracker(tracker: tracker)
        dismiss(animated: true, completion: nil)
    }
}

extension NewTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            // Переход на экран выбора категории
            //let categoryVC = CategoryViewController()
            //navigationController?.pushViewController(categoryVC, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.selectedDays = selectedDays
            scheduleViewController.delegate = self
            scheduleViewController.modalPresentationStyle = .pageSheet
            present(scheduleViewController, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75 // Высота каждой ячейки
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == eventType.rawValue - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

extension NewTrackerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventType.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return categoryCell
        } else {
            return scheduleCell
        }
    }
}

extension NewTrackerViewController: ScheduleDelegateProtocol {
    func didSelectDays(_ selectedDays: [WeekDays]) {
        self.selectedDays = selectedDays.sorted()
        
        var detail = ""
        for day in selectedDays {
            if detail != "" {
                detail = detail + ", " + day.shortDescription
            } else {
                detail = day.shortDescription
            }
        }
        scheduleCell.detailTextLabel?.text = detail
        
    }
}
