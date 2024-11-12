//
//  TrackerCategoriesViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 11.11.2024.
//

import UIKit

protocol NewCategoryDelegateProtocol: AnyObject {
    func didTapCreateButton(category: String)
}

final class CategoriesViewController: LightStatusBarViewController {
    
    var selectedCategory: String?
    
    weak var delegate: NewTrackerDelegateProtocol?
    
    private var viewModel: TrackerCategoryViewModel?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .ysWhite
        table.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        table.layer.cornerRadius = 16
        table.isScrollEnabled = true
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    private lazy var addNewCategory: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ysWhite, for: .normal)
        button.backgroundColor = .ysBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ysWhite
        setupLayout()
        
        do {
            viewModel = try TrackerCategoryViewModel()
        } catch {
            Log.error(error: error, message: "failed to create TrackerCategoryViewModel")
        }
        
        viewModel?.trackerCategoriesBinding = { [weak self] _ in
            guard let self = self else { return }
            Log.info(message: "created new category")
            self.tableView.reloadData()
        }
    }
    
    // Разметка экрана
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addNewCategory)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(WeekDays.count*75)),
            
            addNewCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addNewCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addNewCategory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addNewCategory.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @IBAction
    private func addCategoryButtonTapped() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        newCategoryViewController.modalPresentationStyle = .pageSheet
        present(newCategoryViewController, animated: true, completion: nil)
    }
}


// MARK: - UITableViewDataSource и UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.trackerCategories.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = viewModel?.trackerCategories.count ?? 0
        
        cell.layer.mask = nil
        
        if indexPath.row == count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            let maskPath = UIBezierPath(roundedRect: cell.bounds,
                                        byRoundingCorners: [.bottomLeft, .bottomRight],
                                        cornerRadii: CGSize(width: 16.0, height: 16.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.layer.mask = maskLayer
            
        } else {
            cell.layer.mask = nil
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CategoryTableViewCell
        else {
            return UITableViewCell()
        }
        
        let title = viewModel?.trackerCategories[safe: indexPath.row]?.title ?? ""
        
        cell.configure(text: title,
                       isSelected: title == selectedCategory)
        cell.backgroundColor = .ysBackground
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let category = viewModel?.trackerCategories[indexPath.row].title {
            self.selectedCategory = category
            delegate?.didSelectCategory(category: category)
        }
        dismiss(animated: true)
    }
}


extension CategoriesViewController: NewCategoryDelegateProtocol {
    func didTapCreateButton(category: String) {
        viewModel?.addTrackerCategory(category: category)
    }
}
