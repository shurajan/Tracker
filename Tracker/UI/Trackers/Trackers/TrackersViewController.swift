//
//  MainTabBarViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//
import UIKit


protocol TrackersViewProtocol: AnyObject {
    func showNewHabitViewController()
    func showIrregularEventController()
}


final class TrackersViewController: LightStatusBarViewController {
    private var dataProvider: TrackersViewModelProtocol?
    
    private let params: GeometricParams = GeometricParams(cellCount: 2,
                                                          leftInset: 16,
                                                          rightInset: 16,
                                                          cellSpacing: 10)
    
    
    //MARK: - UI components
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Add tracker"), for: UIControl.State.normal)
        button.accessibilityIdentifier = "plusButton"
        button.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = UIColor.ysBackground
        picker.layer.cornerRadius = 8
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        picker.locale = Locale(identifier: "ru_RU")
        picker.accessibilityIdentifier = "datePicker"
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
    private let dizzyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Dizzy"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var trackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .ysWhite
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider = try? TrackersViewModel(delegate: self)
        setupLayout()
    }
    
    //MARK: - View Layout methods
    private func setupLayout(){
        self.title = "Трекеры"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        view.backgroundColor = UIColor.ysWhite
        
        view.addSubview(datePicker)
        view.addSubview(plusButton)
        view.addSubview(trackerCollectionView)
        view.addSubview(placeHolderView)
        
        placeHolderView.addSubview(dizzyImageView)
        placeHolderView.addSubview(questionLabel)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.searchController = searchController
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            trackerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            placeHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dizzyImageView.centerXAnchor.constraint(equalTo: placeHolderView.centerXAnchor),
            dizzyImageView.topAnchor.constraint(equalTo: placeHolderView.topAnchor),
            dizzyImageView.widthAnchor.constraint(equalToConstant: 80),
            dizzyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            questionLabel.topAnchor.constraint(equalTo: dizzyImageView.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: placeHolderView.centerXAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: placeHolderView.bottomAnchor)
        ])
    }
    
    //MARK: - IB Outlet
    @IBAction
    private func plusButtonTapped(_ sender: UIButton) {
        let trackerCreationViewController = TrackerTypeSelectorViewController()
        trackerCreationViewController.delegate = self
        trackerCreationViewController.modalPresentationStyle = .pageSheet
        present(trackerCreationViewController, animated: true, completion: nil)
    }
    
    @IBAction
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        dataProvider?.currentDate = sender.date.startOfDay()
        dismiss(animated: true)
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider?.numberOfRowsInSection(section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataProvider?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell,
              let dataProvider,
              let tracker = dataProvider.tracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: tracker, dataProvider: dataProvider)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? UICollectionReusableView,
                  let dataProvider = dataProvider,
                  let sectionTitle = dataProvider.titleForSection(indexPath.section) else {
                return UICollectionReusableView()
            }
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            let label = UILabel(frame: headerView.bounds)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = sectionTitle
            label.textAlignment = .left
            label.textColor = .ysBlack
            label.font = UIFont.boldSystemFont(ofSize: 19)
            
            headerView.subviews.forEach { $0.removeFromSuperview() }
            headerView.addSubview(label)
            
            NSLayoutConstraint.activate([
                headerView.heightAnchor.constraint(equalToConstant: 54),
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 28),
                label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24),
            ])
            
            return headerView
        }
        return UICollectionReusableView()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

//MARK: - TrackersViewProtocol
extension TrackersViewController: TrackersViewProtocol {
    func showNewHabitViewController() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.eventType = .habit
        newTrackerViewController.delegate = dataProvider
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: true, completion: nil)
    }
    
    func showIrregularEventController() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.eventType = .one_off
        newTrackerViewController.delegate = dataProvider
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: true, completion: nil)
    }
    
}

//MARK: - DataProviderDelegate
extension TrackersViewController: TrackersViewModelDelegate {
    
    func didUpdate(_ update: IndexUpdate) {
        trackerCollectionView.performBatchUpdates({
            if !update.deletedSections.isEmpty {
                trackerCollectionView.deleteSections(update.deletedSections)
            }
            
            if !update.insertedSections.isEmpty {
                trackerCollectionView.insertSections(update.insertedSections)
            }
            
            for (section, items) in update.insertedItems {
                let indexPaths = items.map { IndexPath(item: $0, section: section) }
                trackerCollectionView.insertItems(at: indexPaths)
            }
            
            for (section, items) in update.deletedItems {
                let indexPaths = items.map { IndexPath(item: $0, section: section) }
                trackerCollectionView.deleteItems(at: indexPaths)
            }
            
            for (section, items) in update.updatedItems {
                let indexPaths = items.map { IndexPath(item: $0, section: section) }
                trackerCollectionView.reloadItems(at: indexPaths)
            }
            
            for move in update.movedItems {
                trackerCollectionView.moveItem(at: move.from, to: move.to)
            }
        }, completion: nil)
    }
    
    func updatePlaceholderVisibility(isHidden: Bool) {
        self.trackerCollectionView.isHidden = !isHidden
        self.placeHolderView.isHidden = isHidden
    }
    
    func reloadData() {
        trackerCollectionView.reloadData()
    }
    
}
