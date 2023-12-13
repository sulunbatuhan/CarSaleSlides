//
//  ButtonView.swift
//  CarSales
//
//  Created by batuhan on 13.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class ButtonView : UIView{
    
    var textColor : UIColor
    
    init(textColor: UIColor) {
        self.textColor = textColor
        super.init(frame: .zero)
        self.backgroundColor = .white
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var nextCar: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next Car", for: .normal)
        button.setTitleColor(tintColor, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = tintColor.cgColor
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private lazy var review : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Review", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = textColor
        button.layer.cornerRadius = 12
        button.layer.shadowColor = textColor.cgColor
        button.layer.shadowOffset = .init(width: 4, height:4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private lazy var buttonStackView : UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [nextCar,review])
        stackView.axis = .horizontal
        stackView.spacing = 24
        
        return stackView
    }()
    
    private func setLayout(){
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 36, left:36, bottom: 36, right: 36))
        }
        nextCar.snp.makeConstraints { make in
            make.width.equalTo(review.snp.width).multipliedBy(0.5)
        }
    }
}
