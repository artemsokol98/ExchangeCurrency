//
//  MainViewController.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
//        let currentMonth = calendar.component(.month, from: Date())
//        let currentDay = calendar.component(.day, from: Date())
        guard let maximumDate = calendar.date(from: DateComponents(year: currentYear + 1))?.addingTimeInterval(-1) else {
            fatalError("Couldn't get next year")
        }
        datePicker.maximumDate = maximumDate
        return datePicker
    }()
    
    lazy var textDatePicker: UITextField = {
        let textDatePicker = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.width, height: view.bounds.height * 0.1)))
        textDatePicker.borderStyle = .roundedRect
//        textDatePicker.layer.borderWidth = 15
//        textDatePicker.layer.borderColor = CGColor(gray: 1.0, alpha: 1.0)
//        textDatePicker.layer.backgroundColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
          let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
          toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        textDatePicker.inputAccessoryView = toolbar
        textDatePicker.inputView = datePicker
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        textDatePicker.text = DateFormatter().string(from: date)

        return textDatePicker
    }()
    
    @objc func donedatePicker(){

       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"
        textDatePicker.text = formatter.string(from: datePicker.date)
        
       self.view.endEditing(true)
     }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: 20,
            left: 20,
            bottom: 20,
            right: 20
        )
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: layout)
        collectionView.register(CurrencyCollectionViewCell.self, forCellWithReuseIdentifier: CurrencyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var viewModel: MainViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Money"
        viewModel = MainViewModel()
        viewModel?.fetchData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(()):
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
            collectionView.topAnchor.constraint(equalTo: textDatePicker.bottomAnchor)
            //collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.5)
        ]
        
        let datePickerConstraints = [
            textDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1),
            textDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.1),
            textDatePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.15),
            textDatePicker.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.1)
           // textDatePicker.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: view.bounds.height * 0.1)
            //textDatePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height * 0.5)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
        NSLayoutConstraint.activate(datePickerConstraints)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destanation = segue.destination as? ConverterViewController else { return }
        guard let index = sender as? Int else { return }
        destanation.data = viewModel?.parsedData[index]
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
        let width: CGFloat = view.frame.size.width * 0.2
        let height: CGFloat = view.frame.size.width * 0.3
        return CGSize(width: width, height: height)
    }
}
