//
//  ConverterViewController.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import UIKit

class ConverterViewController: UIViewController {
    
    var data: ParsedCurrencyData?
    
    var viewModel: ConverterViewModelProtocol?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InfoConverterTableViewCell.self, forCellReuseIdentifier: InfoConverterTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = data else { return }
        viewModel = ConverterViewModel(data: data)
        title = data.charCode
        overrideUserInterfaceStyle = .light
//        tableView.separatorStyle = .singleLine
//        tableView.separatorColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension ConverterViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
        {
            view.endEditing(true)
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConverterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell: TableViewCellProtocol
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoConverterTableViewCell.identifier, for: indexPath) as? InfoConverterTableViewCell else { return UITableViewCell() }
            cell.configureCell(valute: data)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else { return UITableViewCell() }
            cell.configureCell(valute: ParsedCurrencyData(charCode: "RUB", value: viewModel?.ruble ?? 0.0, name: "Российский рубль"))
            cell.textFieldDelegate = self
            cell.textFieldValue.delegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else { return UITableViewCell() }
            cell.configureCell(valute: ParsedCurrencyData(charCode: data?.charCode ?? "", value: viewModel?.valute ?? 0.0, name: data?.name ?? ""))
            cell.textFieldDelegate = self
            cell.textFieldValue.delegate = self
            return cell
        }
        
        //return cell as?
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 200.0
        default: return 100.0
        }
    }
    
    
}

extension ConverterViewController: TextFieldChangedValueDelegate {
    func textFieldValueChanged(value: String, charCode: String?) {
        let indexPath: IndexPath
        let valueInDouble = Double(value) ?? 0.0
        if charCode == "RUB" {
            viewModel?.ruble = valueInDouble
            viewModel?.convertRubleToValute()
            indexPath = IndexPath(row: 2, section: 0)
        } else {
            viewModel?.valute = valueInDouble
            viewModel?.convertValuteToRuble()
            indexPath = IndexPath(row: 1, section: 0)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
     
    
}

extension ConverterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //tableView.reloadData()
    }
}

