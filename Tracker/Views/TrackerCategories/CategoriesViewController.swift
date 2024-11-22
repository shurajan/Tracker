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

final class CategoriesViewController: BasicViewController {    
    var selectedCategory: String?
    
    private let delegate: TrackerDelegateProtocol
    
    private var viewModel: TrackerCategoryViewModel?
    
    init(delegate: TrackerDelegateProtocol, viewModel: TrackerCategoryViewModel = TrackerCategoryViewModel()) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedStrings.Categories.title
        label.font = Fonts.titleMediumFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = AppColors.Dynamic.white
        table.register(SelectionTableViewCell.self, forCellReuseIdentifier: "cell")
        table.layer.cornerRadius = Constants.radius
        table.isScrollEnabled = true
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    private lazy var addNewCategory: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedStrings.Categories.addButton, for: .normal)
        button.titleLabel?.font = Fonts.titleMediumFont
        button.setTitleColor(AppColors.Dynamic.white, for: .normal)
        button.backgroundColor = AppColors.Dynamic.black
        button.layer.cornerRadius = Constants.radius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let placeHolderView: PlaceHolderView = {
        let view = PlaceHolderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setText(text: LocalizedStrings.Categories.placeholderText)
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.Dynamic.white
        setupLayout()
        
        viewModel?.trackerCategoriesBinding = updateTableView
        viewModel?.fetchTrackerCategories()
    }
    
    private func updateTableView(categories: [TrackerCategory]) {
        tableView.reloadData()
        let isHidden = categories.isEmpty
        tableView.isHidden = isHidden
        placeHolderView.isHidden = !isHidden
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addNewCategory)
        view.addSubview(placeHolderView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addNewCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addNewCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addNewCategory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addNewCategory.heightAnchor.constraint(equalToConstant: 60),
            
            placeHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Insets.leading),
            placeHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Insets.trailing),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Insets.leading),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Insets.trailing),
            tableView.bottomAnchor.constraint(equalTo: addNewCategory.topAnchor, constant: -24)
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
            cell.separatorInset = Insets.separatorInset
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SelectionTableViewCell
        else {
            return UITableViewCell()
        }
        
        let title = viewModel?.trackerCategories[safe: indexPath.row]?.title ?? ""
        
        cell.configure(text: title,
                       isSelected: title == selectedCategory)
        cell.layoutMargins = Insets.cellInsets
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let category = viewModel?.trackerCategories[indexPath.row].title {
            self.selectedCategory = category
            delegate.didSelectCategory(category: category)
        }
        dismiss(animated: true)
    }
}


extension CategoriesViewController: NewCategoryDelegateProtocol {
    func didTapCreateButton(category: String) {
        viewModel?.addTrackerCategory(category: category)
    }
}
