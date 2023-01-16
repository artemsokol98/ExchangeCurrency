//
//  TextFieldTableViewCell.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    static let identifier = "TextFieldTableViewCell"
    
    lazy var charCodeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var textFieldValue: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            charCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * 0.1),
            charCodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height * 0.1),
            charCodeLabel.bottomAnchor.constraint(equalTo: textFieldValue.topAnchor, constant: contentView.bounds.height * 0.1)
        ]
        
        let textFieldValueConstraints = [
            textFieldValue.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * 0.1),
            textFieldValue.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height * 0.1)
        ]
        
        NSLayoutConstraint.activate(charCodeLabelConstraints)
        NSLayoutConstraint.activate(textFieldValueConstraints)
    }
    
    func configureCell(valute: ParsedCurrencyData?) {
        charCodeLabel.text = valute?.charCode
        textFieldValue.text = "0"
    }

    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
*/
}

extension TextFieldTableViewCell: TableViewCellProtocol {
    
}
