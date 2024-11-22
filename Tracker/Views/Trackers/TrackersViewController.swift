//
//  MainTabBarViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//
import UIKit

final class TrackersViewController: LightStatusBarViewController {
    private(set) var viewModel: TrackersViewModelProtocol?
    private(set) var collectionViewModel: TrackerCollectionViewModelProtocol?
    private(set) var trackerRecordStore: TrackerRecordStore?
    private(set) var params: GeometricParams = GeometricParams(cellCount: 2,
                                                          leftInset: Insets.leading,
                                                          rightInset: Insets.leading,
                                                          cellSpacing: 10)
    
    private(set) var selectedDate = Date().startOfDay()
    private(set) var isSearchModeOn = false
    private(set) var currentFilter: Filters = .allTrackers
        
    //MARK: - UI components
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "plus")?
            .withTintColor(AppColors.Dynamic.black, renderingMode: .alwaysOriginal) {
            
            button.setImage(image, for: UIControl.State.normal)
        }
        button.accessibilityIdentifier = "plusButton"
        button.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = AppColors.Fixed.cardBackground
        picker.tintColor = AppColors.Fixed.black
        picker.layer.cornerRadius = Constants.smallRadius
        picker.layer.masksToBounds = true
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        picker.locale = Locale.current
        picker.accessibilityIdentifier = "datePicker"
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
        
    private let placeHolderView: PlaceHolderView = {
        let view = PlaceHolderView()
        view.setText(text: LocalizedStrings.Trackers.placeholderText)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let searchPlaceHolderView: PlaceHolderView = {
        let view = PlaceHolderView()
        view.setText(text: LocalizedStrings.Trackers.searchPlaceHolderText)
        view.setImage(name: "Empty")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = AppColors.Dynamic.white
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInsetAdjustmentBehavior = .always
        return collectionView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedStrings.Trackers.filterButtonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.Fixed.blue
        button.titleLabel?.font = Fonts.textFieldFont
        button.layer.cornerRadius = Constants.radius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
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
        self.title = LocalizedStrings.Trackers.title
        definesPresentationContext = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: Fonts.titleLargeFont
        ]
        navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = AppColors.Dynamic.white
        
        view.addSubview(datePicker)
        view.addSubview(plusButton)
        view.addSubview(trackerCollectionView)
        view.addSubview(placeHolderView)
        view.addSubview(searchPlaceHolderView)
        view.addSubview(filterButton)
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.searchController = searchController
        
        trackerCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
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
            placeHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Insets.leading),
            placeHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Insets.trailing),
            
            searchPlaceHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchPlaceHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchPlaceHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Insets.leading),
            searchPlaceHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Insets.trailing),
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func initiateStore(){
        self.trackerRecordStore = TrackerRecordStore()
        viewModel = TrackersViewModel()
        collectionViewModel = TrackerCollectionViewModel(viewModel: viewModel)
        viewModel?.trackersBinding = updateCollectionView
        viewModel?.fetchTrackers(for: selectedDate)
    }
    
    
    private func updateCollectionView(categories: [TrackerCategory]) {
        trackerCollectionView.reloadData()
        let numberOfSections = categories.count
        let isHidden = numberOfSections > 0
        trackerCollectionView.isHidden = !isHidden
        filterButton.isHidden = !(viewModel?.hasData() ?? false)
        
        if isSearchModeOn {
            placeHolderView.isHidden = true
            searchPlaceHolderView.isHidden = isHidden
        } else {
            placeHolderView.isHidden = isHidden
            searchPlaceHolderView.isHidden = true
        }
    }
    
    private func generateFilterPredicate() -> [(Tracker) -> Bool] {
        var predicates: [(Tracker) -> Bool] = []
        predicates.append(currentFilter.makePredicate())
        let searchText = searchController.searchBar.text ?? ""
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedText.isEmpty {
            predicates.append(textPredicate(for: trimmedText))
        }
        return predicates
    }
    
    private func textPredicate(for text: String) -> (Tracker) -> Bool {
        return { tracker in
            tracker.name.lowercased().contains(text.lowercased())
        }
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
        if currentFilter == .todayTrackers {
            currentFilter = .allTrackers
        }
        viewModel?.fetchTrackers(for: selectedDate)
        dismiss(animated: true)
    }
    
    @IBAction
    func filterButtonTapped(){
        let filtersViewController = FiltersViewController(delegate: self)
        filtersViewController.modalPresentationStyle = .pageSheet
        present(filtersViewController, animated: true, completion: nil)
    }
}

//MARK: - TrackersViewProtocol
extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchModeOn = true
        let predicates = self.generateFilterPredicate()
        viewModel?.filter(predicates: predicates)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchModeOn = false
        searchBar.text = ""
        let filterPredicate = self.currentFilter.makePredicate()
        viewModel?.filter(predicates: [filterPredicate])
        searchBar.resignFirstResponder()
    }
    

}

extension TrackersViewController: FilterDelegateProtocol {
    func didSelectFilter(filter: Filters) {
        self.currentFilter = filter
        if self.currentFilter == .todayTrackers {
            selectedDate = Date().startOfDay()
            datePicker.date = selectedDate
            viewModel?.fetchTrackers(for: selectedDate)
        }
        
        let predicates = self.generateFilterPredicate()
        viewModel?.filter(predicates: predicates)
    }
    
    
}
