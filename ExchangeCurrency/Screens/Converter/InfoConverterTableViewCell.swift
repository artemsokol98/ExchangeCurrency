//
//  InfoConverterTableViewCell.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import UIKit

class InfoConverterTableViewCell: UITableViewCell {
    
    static let identifier = "InfoConverterTableViewCell"
    
    lazy var nameCurrency: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Constants.smallFontSize, weight: .semibold)
        return label
    }()
    
    lazy var labelCourse: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var valueCurrency: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.bigFontSize, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Color.backgroundLightBlue
        labelCourse.text = "Курс"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(nameCurrency)
        contentView.addSubview(labelCourse)
        contentView.addSubview(valueCurrency)
        
        nameCurrency.translatesAutoresizingMaskIntoConstraints = false
        labelCourse.translatesAutoresizingMaskIntoConstraints = false
        valueCurrency.translatesAutoresizingMaskIntoConstraints = false
        
        let nameCurrencyConstraints = [
            nameCurrency.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height * Constants.rowPadding),
            nameCurrency.bottomAnchor.constraint(equalTo: labelCourse.topAnchor, constant: -contentView.bounds.height * Constants.rowPadding),
            nameCurrency.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * Constants.rowPadding),
            nameCurrency.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.bounds.width * Constants.rowPadding)
        ]
        
        let labelCourseConstraints = [
            labelCourse.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelCourse.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * Constants.rowPadding)
        ]
        
        let valueCurrencyConstraints = [
            valueCurrency.topAnchor.constraint(equalTo: labelCourse.bottomAnchor, constant: -contentView.bounds.height * Constants.rowPadding),
            valueCurrency.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: contentView.bounds.height * Constants.rowPadding),
            valueCurrency.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * Constants.rowPadding)
        ]
        
        NSLayoutConstraint.activate(nameCurrencyConstraints)
        NSLayoutConstraint.activate(labelCourseConstraints)
        NSLayoutConstraint.activate(valueCurrencyConstraints)
    }
    
    func configureCell(valute: ParsedCurrencyData?) {
        let value = String(format: "%.2f", valute?.value ?? 0) + "₽"
        nameCurrency.text = valute?.name
        valueCurrency.text = value
    }
}
