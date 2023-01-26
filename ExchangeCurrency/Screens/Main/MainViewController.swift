//
//  MainViewController.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private let spacing: CGFloat = Constants.spaceEdgeForCollectionView
    var viewModel: MainViewModelProtocol?
    let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - UI Elements
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        guard let maximumDate = calendar.date(from: DateComponents(year: currentYear + 1))?.addingTimeInterval(-1) else {
            fatalError("Couldn't get next year")
        }
        datePicker.maximumDate = maximumDate
        return datePicker
    }()
    
    lazy var textDatePicker: UITextField = {
        let textDatePicker = UITextField() 
        textDatePicker.borderStyle = .roundedRect
        textDatePicker.addTarget(self, action: #selector(alertController), for: .touchDown)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        textDatePicker.text = dateFormatter.string(from: date)

        return textDatePicker
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
         
        layout.minimumLineSpacing = Constants.mainVCSpacingBetweenCells
        layout.minimumInteritemSpacing = Constants.mainVCSpacingBetweenCells
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CurrencyCollectionViewCell.self, forCellWithReuseIdentifier: CurrencyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Override view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Валюты"
        collectionView.backgroundView = spinner
        viewModel = MainViewModel()
        sendRequest(url: Strings.dailyCourseApiString)
        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(collectionView)
        view.addSubview(textDatePicker)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        textDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionViewConstraints = [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: textDatePicker.bottomAnchor, constant: view.bounds.height * 0.01)
        ]
        
        let datePickerConstraints = [
            textDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            textDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            textDatePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.15),
            textDatePicker.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
        NSLayoutConstraint.activate(datePickerConstraints)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destanation = segue.destination as? ConverterViewController else { return }
        guard let index = sender as? Int else { return }
        destanation.data = viewModel?.parsedData[index]
    }
    
    @objc func alertController() {
        datePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: Constants.heightOfDatePicker)
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(datePicker)
        let saveAlertAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            self.donedatePicker()
        }
        let cancelAlertAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alertController.addAction(saveAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true)
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textDatePicker.text = formatter.string(from: datePicker.date)
        
        let formatterForRequest = DateFormatter()
        formatterForRequest.dateFormat = "yyyy/MM/dd"
        print(formatterForRequest.string(from: datePicker.date))
        sendRequest(url: Strings.firstPartForPreviousDateApiString + formatterForRequest.string(from: datePicker.date) + Strings.secondPartForPreviousDateApiString)
     }
    
    private func sendRequest(url: String) {
        spinner.startAnimating()
        viewModel?.fetchData(url: url) { [weak self] result in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                switch result {
                case .success(()):
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let action = UIAlertAction(title: "Try again", style: .default) { _ in
            self.sendRequest(url: Strings.dailyCourseApiString)
        }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - CollectionView

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowConverter", sender: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.parsedData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCollectionViewCell.identifier, for: indexPath) as? CurrencyCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(valute: viewModel?.parsedData[indexPath.row])
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = Constants.numberOfItemsPerRow
        let spacingBetweenCells:CGFloat = Constants.mainVCSpacingBetweenCells
        let totalSpacing = self.spacing * 2 + ((numberOfItemsPerRow - 1) * spacingBetweenCells) // Amount of total spacing in a row
        let width = floor((collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow)
        return CGSize(width: width, height: width)
    }
}
