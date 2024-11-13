//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 15.10.2024.
//

import UIKit

final class ScheduleViewController: LightStatusBarViewController {
    
    var selectedDays = WeekDays()
    
    weak var delegate: NewTrackerDelegateProtocol?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = Fonts.titleMediumFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .ysWhite
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.layer.cornerRadius = Constants.radius
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = Fonts.titleMediumFont
        button.setTitleColor(.ysWhite, for: .normal)
        button.backgroundColor = .ysBlack
        button.layer.cornerRadius = Constants.radius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ysWhite
        setupLayout()
    }
    
    // Разметка экрана
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Insets.leading),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Insets.trailing),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(WeekDays.count*75))
        ])
    }
    
    @IBAction
    private func switchChanged(_ sender: UISwitch) {
        guard let day = WeekDays.from(Int32(sender.tag - 1)) else {
            return
        }
        
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
    
    @IBAction
    private func doneButtonTapped() {
        delegate?.didSelectDays(selectedDays)
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITableViewDataSource и UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDays.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == WeekDays.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = Insets.separatorInset
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let day = WeekDays.from(Int32(indexPath.row)) else {return UITableViewCell()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = day.description
        
        let switchView = UISwitch()
        switchView.onTintColor = .ysBlue
        switchView.isOn = selectedDays.contains(day)
        switchView.tag = indexPath.row + 1
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        cell.backgroundColor = .ysBackground
        cell.layoutMargins = Insets.cellInsets
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
