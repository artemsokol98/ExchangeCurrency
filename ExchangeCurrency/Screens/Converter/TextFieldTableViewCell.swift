//
//  TextFieldTableViewCell.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import UIKit

protocol TextFieldChangedValueDelegate {
    func textFieldValueChanged(value: String, charCode: String?)
}

class TextFieldTableViewCell: UITableViewCell {
    
    static let identifier = "TextFieldTableViewCell"
    
    var textFieldDelegate: TextFieldChangedValueDelegate?
    
    lazy var charCodeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var textFieldValue: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.0"
        textField.font = .systemFont(ofSize: Constants.bigFontSize, weight: .semibold)
        textField.keyboardType = .decimalPad
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y: self.bounds.height), size: CGSize(width: self.bounds.width, height: 1))
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textField.layer.addSublayer(bottomLine)
        
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textFieldValue.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    @objc func textFieldValueChanged() {
        print(textFieldValue.description)
        textFieldDelegate?.textFieldValueChanged(value: textFieldValue.text ?? "0.0", charCode: charCodeLabel.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.addSubview(charCodeLabel)
        contentView.addSubview(textFieldValue)
        
        charCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldValue.translatesAutoresizingMaskIntoConstraints = false
        
        let charCodeLabelConstraints = [
            charCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * Constants.rowPadding),
            charCodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height * Constants.rowPadding),
            charCodeLabel.bottomAnchor.constraint(equalTo: textFieldValue.topAnchor, constant: contentView.bounds.height * Constants.rowPadding)
        ]
        
        let textFieldValueConstraints = [
            textFieldValue.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * Constants.rowPadding),
            textFieldValue.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height * Constants.rowPadding),
            textFieldValue.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.4)
        ]
        
        NSLayoutConstraint.activate(charCodeLabelConstraints)
        NSLayoutConstraint.activate(textFieldValueConstraints)
    }
    
    func configureCell(valute: ParsedCurrencyData?) {
        charCodeLabel.text = valute?.charCode
        textFieldValue.text = String(format: "%.1f", valute?.value ?? 0.0)
    }
}
