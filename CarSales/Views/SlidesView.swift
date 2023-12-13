//
//  SlidesView.swift
//  CarSales
//
//  Created by batuhan on 13.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class SlidesView : UIView{
    
    
    //MARK: Initialize
    var carSlides : [CarSlide]
    var timer : DispatchSourceTimer?
    
    init(carSlides: [CarSlide]) {
        self.carSlides = carSlides
        super.init(frame: .zero)
        setLayout()
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Properties
    private lazy var carImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "gtr")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var imageBars :  [AnimationBarView] = {
       var bars = [AnimationBarView]()
        carSlides.forEach { slide in
            bars.append(AnimationBarView(barColor: .systemBlue))
        }
        return bars
    }()
    
    private lazy var barStackView : UIStackView = {
       let stackView = UIStackView()
        imageBars.forEach { bar in
            stackView.addArrangedSubview(bar)
        }
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var carDetailText = CarDetailText()
    
    private lazy var stackView : UIStackView = {
       let view = UIStackView(arrangedSubviews: [carImageView,carDetailText])
        view.axis = .vertical
        view.distribution = .fill
        return view
    }()
  
    
    //MARK: Methods
    private func setLayout(){
        addSubviews(stackView,barStackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        barStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.top.equalTo(snp.topMargin)
            make.height.equalTo(4)
        }
        
        carImageView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.8)
        }
    }
    func addGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        carImageView.addGestureRecognizer(gesture)
    }
    @objc func imageTapped(_ gesture :UITapGestureRecognizer){
        let point = gesture.location(in: self)
        let size = carImageView.frame.width / 2
        let position = point.x > size ? true : false
        if position {
            handleTap(.right)
        }else {
            handleTap(.left)
        }
    }
    var index = -1
    
    func handleTap(_ position : Position){
        switch position {
        case .left:
            imageBars[index].clear()
            if imageBars.indices.contains(index-1){
                imageBars[index-1].clear()
            }
            index -= 2
        case .right:
            imageBars[index].complete()
        }
        timer?.cancel()
        timer = nil
        startAction()
    }
    
    func showNextCarSlide(){
        var carImage : UIImage
        var title : String
        var nextBar : AnimationBarView
        
        if carSlides.indices.contains(index + 1){
            carImage = carSlides[self.index + 1].carImage
            title = carSlides[self.index + 1].carTitle
            nextBar =  imageBars[self.index + 1]
            index += 1
        }else {
            imageBars.forEach { $0.clear() }
            nextBar = imageBars[0]
            carImage = carSlides[0].carImage
            title = carSlides[0].carTitle
            index = 0
        }
        UIView.transition(with: carImageView, duration: 0.5,options: .transitionCrossDissolve) {
            self.carImageView.image = carImage
            self.carDetailText.setTitleString(title)
        }
        nextBar.animation()
        
    }
    
    func buildTimer(){
        guard timer == nil else {return}
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(),repeating: .seconds(3),leeway: .seconds(1))
        timer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.showNextCarSlide()
            }
        })
    }
    
    func startAction(){
        buildTimer()
        timer?.resume()
    }
    
}

extension UIView{
    
    func addSubviews(_ views : UIView...){
        for view in views {
            addSubview(view)
        }
    }
}

enum Position {
    case left
    case right
}
