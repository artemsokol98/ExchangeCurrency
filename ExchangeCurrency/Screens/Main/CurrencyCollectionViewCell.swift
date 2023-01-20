//
//  CurrencyCollectionViewCell.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {
    static let identifier = "CurrencyCollectionViewCell"
    
    lazy var currencyCode: UILabel = {
        let label = UILabel()
//        label.numberOfLines = 0
//        label.font = .systemFont(ofSize: Constants.nameOfCellLabelDetailViewFontSize)
        label.font = .systemFont(ofSize: 30.0, weight: .bold)
        label.textColor = UIColor(red: 83.0/255.0, green: 148.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        return label // 83 148 227
    }()
    
    lazy var currencyValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .regular)
        label.textColor = UIColor(red: 172.0/255.0, green: 174.0/255.0, blue: 188.0/255.0, alpha: 1.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(currencyCode)
        contentView.addSubview(currencyValue)
        backgroundColor = UIColor(red: 242.0/255.0, green: 245.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        layer.cornerRadius = contentView.bounds.width * 0.1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        currencyCode.translatesAutoresizingMaskIntoConstraints = false
        currencyValue.translatesAutoresizingMaskIntoConstraints = false
        
        let currencyCodeConstraints = [
            currencyCode.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            currencyCode.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height * 0.2),
            currencyCode.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height * 0.6)
        ]
        
        let currencyValueConstraints = [
            currencyValue.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            currencyValue.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height * 0.5),
            currencyValue.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height * 0.1)
        ]
        
        NSLayoutConstraint.activate(currencyCodeConstraints)
        NSLayoutConstraint.activate(currencyValueConstraints)
    }
    
    func configureCell(valute: ParsedCurrencyData?) {
        let value = String(format: "%.2f", valute?.value ?? 0) + "₽"
        currencyCode.text = valute?.charCode
        currencyValue.text = value
    }
}
