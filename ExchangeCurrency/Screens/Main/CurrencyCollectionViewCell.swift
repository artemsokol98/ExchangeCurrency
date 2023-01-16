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
        return label
    }()
    
    lazy var currencyValue: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(currencyCode)
        contentView.addSubview(currencyValue)
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
            currencyCode.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height * 0.1),
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
        currencyCode.text = valute?.charCode
        currencyValue.text = valute?.value.description
    }
}
