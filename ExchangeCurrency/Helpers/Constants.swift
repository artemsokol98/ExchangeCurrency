//
//  Constants.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 22.01.2023.
//

import UIKit

class Constants {
    
    // MARK: - Main View Controller
    static let mainVCSpacingBetweenCells: CGFloat = 10.0
    static let numberOfItemsPerRow: CGFloat = 3
    static let heightOfDatePicker: CGFloat = 200
    static let spaceEdgeForCollectionView: CGFloat = 20.0
    
    // MARK: - Converter View Converter
    static let minimalHeightOfScreenForMovingUp: CGFloat = 600
    static let heightOfFirstRow: CGFloat = 200
    static let heightOfSecondAndThirdRow: CGFloat = 100
    static let rowPadding = 0.05
    static let numberOfRowsInConverter = 3
    
    // MARK: - Font size
    static let bigFontSize = 30.0
    static let smallFontSize = 15.0
    
    // MARK: - Network manager
    static let numberOfWaitingSeconds: TimeInterval = 15
}
