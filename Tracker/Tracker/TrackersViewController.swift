//
//  MainTabBarViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//
import UIKit




final class TrackersViewController: LightStatusBarViewController {
    private(set) var currentDate: Date = Date()
    private let params: GeometricParams = GeometricParams(cellCount: 2,
                                                          leftInset: 16,
                                                          rightInset: 16,
                                                          cellSpacing: 10)
    
    private var categories = [TrackerCategory]()
    private var filteredTrackers: [Tracker] = []
    private var completedTrackers = [TrackerRecord]()
    private var completedTrackersSet: Set<TrackerRecord> = []
    
    
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
    
    private var dizzyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Dizzy"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeHolderView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dizzyImageView, questionLabel])
        stackView.addSubview(dizzyImageView)
        stackView.addSubview(questionLabel)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        //TODO: - added in sprint_14 as a stub
        let category = TrackerCategory(id: UUID(), title: "Базовая", trackers: [])
        addCategory(category: category)
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
        view.addSubview(placeHolderView)
        view.addSubview(trackerCollectionView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.searchController = searchController
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            dizzyImageView.widthAnchor.constraint(equalToConstant: 80),
            dizzyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            placeHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        refreshViewForDate(date: currentDate)
    }
    
    //MARK: - Private Methods
    private func addCategory(category: TrackerCategory){
        self.categories = categories + [category]
    }
    
    private func filterTrackers(by date: Date, trackers: [Tracker]) -> [Tracker] {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        
        return trackers.filter { tracker in
            if let schedule = tracker.schedule,
               let weekDay = WeekDays.fromGregorianStyle(dayOfWeek) {
                return schedule.contains(weekDay)
            }
            
            return calendar.isDate(tracker.date, inSameDayAs: date)

        }
    }
    
    private func refreshViewForDate(date: Date){
        filteredTrackers = filterTrackers(by: date, trackers: categories[safe: 0]?.trackers ?? [])
        
        if filteredTrackers.isEmpty {
            trackerCollectionView.isHidden = true
            placeHolderView.isHidden = false
        } else {
            trackerCollectionView.isHidden = false
            trackerCollectionView.reloadData()
            placeHolderView.isHidden = true
        }
    }
    
    //MARK: - IB Outlet
    @IBAction
    private func plusButtonTapped(_ sender: UIButton) {
        let trackerCreationViewController = TrackerTypeSelectorViewController()
        trackerCreationViewController.delegate = self
        trackerCreationViewController.modalPresentationStyle = .pageSheet
        present(trackerCreationViewController, animated: false, completion: nil)
    }
    
    @IBAction
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        refreshViewForDate(date: currentDate)
        dismiss(animated: true)
    }
}

//MARK: - TrackersViewControllerProtocol
extension TrackersViewController: TrackersViewControllerProtocol {
    func didCreateTrackerRecord(tracker: Tracker, date: Date) -> Int {
        let record = TrackerRecord(trackerId: tracker.id, date: date)
        
        let isSetContainingID = completedTrackersSet.contains(record)
        
        if !isSetContainingID {
            completedTrackers.append(record)
            completedTrackersSet.insert(record)
            
            if tracker.schedule == nil {
                return 1
            }
            
            return completedTrackers.filter { $0.trackerId == tracker.id }.count
        }
        
        let index = completedTrackers.firstIndex(where: {$0 == record})

        if let index {
            completedTrackers.remove(at: index)
            completedTrackersSet.remove(record)
            let count = completedTrackers.filter { $0.trackerId == tracker.id }.count
            return count
        }
        
        return 0
    }
    
    func didCreateNewTracker(tracker: Tracker) {
        guard let category = categories[safe: 0] else {return}
        let trackers = category.trackers + [tracker]
        categories.remove(at: 0)
        categories.append(TrackerCategory(id: category.id, title: category.title, trackers: trackers))
        refreshViewForDate(date: currentDate)
    }
    
    func showNewHabitViewController() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.eventType = .habit
        newTrackerViewController.delegate = self
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: false, completion: nil)
    }
    
    func showIrregularEventController() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.eventType = .one_off
        newTrackerViewController.delegate = self
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: false, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTrackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = filteredTrackers[indexPath.item]
        let record = TrackerRecord(trackerId: tracker.id, date: currentDate)
        let isDone = completedTrackersSet.contains(record)
        
        if tracker.schedule != nil {
            let count = completedTrackers.filter { $0.trackerId == tracker.id }.count
            cell.configure(with: tracker, selectedDate: currentDate, count: count, isDone: isDone)
        } else {
            let count = isDone ? 1 : 0
            cell.configure(with: tracker, selectedDate: currentDate, count: count, isDone: isDone)
        }
        
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // Получаем зарегистрированный заголовок
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            let label = UILabel(frame: headerView.bounds)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = categories[safe: indexPath.row]?.title
            label.textAlignment = .left
            label.textColor = .ysBlack
            label.font = UIFont.boldSystemFont(ofSize: 19)
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
