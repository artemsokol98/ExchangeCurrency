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
        print(contentView.bounds.width)
        label.font = .systemFont(ofSize: self.bounds.width * 0.3, weight: .bold) //30.0
        label.textColor = Color.lightBlue
        return label
    }()
    
    lazy var currencyValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: self.bounds.width * 0.2, weight: .regular)
        label.textColor = Color.lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(currencyCode)
        contentView.addSubview(currencyValue)
        backgroundColor = Color.backgroundLightBlue
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
            currencyCode.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height * 0.5)
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
