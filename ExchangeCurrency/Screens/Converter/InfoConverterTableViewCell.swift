//
//  InfoConverterTableViewCell.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import UIKit

protocol TableViewCellProtocol {
    
}

class InfoConverterTableViewCell: UITableViewCell {
    
    static let identifier = "InfoConverterTableViewCell"
    
    lazy var nameCurrency: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var labelCourse: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var valueCurrency: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            nameCurrency.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height * 0.1),
            nameCurrency.bottomAnchor.constraint(equalTo: labelCourse.topAnchor, constant: -contentView.bounds.height * 0.1),
            nameCurrency.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * 0.1),
            nameCurrency.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.bounds.width * 0.1)
            
        ]
        
        let labelCourseConstraints = [
            labelCourse.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelCourse.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * 0.1)
        ]
        
        let valueCurrencyConstraints = [
            valueCurrency.topAnchor.constraint(equalTo: labelCourse.bottomAnchor, constant: -contentView.bounds.height * 0.1),
            valueCurrency.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: contentView.bounds.height * 0.1),
            valueCurrency.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * 0.1)

        ]
        
        NSLayoutConstraint.activate(nameCurrencyConstraints)
        NSLayoutConstraint.activate(labelCourseConstraints)
        NSLayoutConstraint.activate(valueCurrencyConstraints)
    }
    
    func configureCell(valute: ParsedCurrencyData?) {
        nameCurrency.text = valute?.name
        valueCurrency.text = valute?.value.description
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

extension InfoConverterTableViewCell: TableViewCellProtocol {
    
}

