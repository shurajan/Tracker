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
    private var viewModel: TrackersViewModelProtocol?
    private var trackerRecordStore: TrackerRecordStore?
    private let params: GeometricParams = GeometricParams(cellCount: 2,
                                                          leftInset: 16,
                                                          rightInset: 16,
                                                          cellSpacing: 10)
    
    private var selectedDate = Date().startOfDay()
    
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
        
    private let placeHolderView: PlaceHolderView = {
        let view = PlaceHolderView()
        view.setText(text: "Что будем отслеживать?")
        view.isHidden = true
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
        setupLayout()
        initiateStore()
        datePicker.date = Date().startOfDay()
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
        ])
    }
    
    private func initiateStore(){
        self.trackerRecordStore = TrackerRecordStore()
        viewModel = TrackersViewModel()
        viewModel?.trackersBinding = updateCollectionView
        viewModel?.date = selectedDate
        viewModel?.fetchTrackers()
    }
    
    
    private func updateCollectionView(categories: [TrackerCategory]) {
        trackerCollectionView.reloadData()
        let numberOfSections = categories.count
        let isHidden = numberOfSections > 0
        trackerCollectionView.isHidden = !isHidden
        placeHolderView.isHidden = isHidden
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
        selectedDate = sender.date.startOfDay()
        viewModel?.date = selectedDate
        viewModel?.fetchTrackers()
        dismiss(animated: true)
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell,
              let tracker = viewModel?.object(at: indexPath),
              let trackerRecordStore
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(tracker: tracker, date: datePicker.date.startOfDay(), dataProvider: trackerRecordStore)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? UICollectionReusableView,
                  let dataProvider = viewModel,
                  let sectionTitle = dataProvider.titleForSection(indexPath.section) else {
                return UICollectionReusableView()
            }
                        
            let label = UILabel(frame: headerView.bounds)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = sectionTitle
            label.textAlignment = .left
            label.textColor = .ysBlack
            label.font = UIFont.boldSystemFont(ofSize: 19)
            
            headerView.subviews.forEach { $0.removeFromSuperview() }
            headerView.addSubview(label)
            
            NSLayoutConstraint.activate([
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
        newTrackerViewController.selectedDate = selectedDate
        newTrackerViewController.eventType = .habit
        newTrackerViewController.delegate = viewModel
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: true, completion: nil)
    }
    
    func showIrregularEventController() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.selectedDate = selectedDate
        newTrackerViewController.eventType = .one_off
        newTrackerViewController.delegate = viewModel
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: true, completion: nil)
    }
    
}
