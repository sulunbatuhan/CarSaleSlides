//
//  AnimationBarView.swift
//  CarSales
//
//  Created by batuhan on 13.12.2023.
//

import Foundation
import UIKit
import SnapKit
import Combine

final class AnimationBarView : UIView {
    
    enum State {
        case animating
        case filled
        case clear
    }
    var animator : UIViewPropertyAnimator!
    var barColor : UIColor
    @Published var state : State = .clear
    private var subscribers = Set<AnyCancellable>()
    
    init(barColor: UIColor) {
        self.barColor = barColor
        super.init(frame: .zero)
        setLayout()
        setAnimator()
        dependsOnState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var backgroundBarColor: UIView = {
        let view = UIView()
        view.backgroundColor = barColor.withAlphaComponent(0.2)
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var foregroundColor:UIView = {
        let view = UIView()
        view.backgroundColor = barColor
        view.alpha = 0
        return view
    }()

    
    func setAnimator(){
        animator = UIViewPropertyAnimator(duration: 3, curve: .easeInOut, animations: {
            self.foregroundColor.transform = .identity
        })
    }

    private func setLayout(){
        addSubview(backgroundBarColor)
        backgroundBarColor.addSubview(foregroundColor)
        backgroundBarColor.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        foregroundColor.snp.makeConstraints { make in
            make.edges.equalTo(backgroundBarColor)
        }
    }
    
    func dependsOnState(){
        $state.sink { [unowned self] state in
            switch state{
            case .animating:
                foregroundColor.transform = .init(scaleX: 0, y: 1)
                foregroundColor.transform = .init(translationX: -frame.size.width, y: 0)
                foregroundColor.alpha = 1
                animator.startAnimation()
            case .clear:
                self.setAnimator()
                foregroundColor.alpha = 0
                animator.stopAnimation(false)
             
            case .filled:
                self.animator.stopAnimation(true)
                foregroundColor.transform = .identity
            }
        }.store(in: &subscribers)
      
    }
    
    func animation(){
        state = .animating
    }
    func complete(){
        state = .filled
    }
    func clear(){
        state = .clear
    }
    
    
}


