//
//  ViewController.swift
//  CarSales
//
//  Created by batuhan on 13.12.2023.
//

import UIKit

class CarViewController: UIViewController {

    private let slides : [CarSlide] = [CarSlide(carImage: UIImage(named: "nsx")!, carTitle: "Honda NSX\n26.000Km\nFull Build engine"),CarSlide(carImage: UIImage(named: "evo")!, carTitle: "Mitsubishi Evo\n 80.000Km"),CarSlide(carImage:  UIImage(named: "gtr")!, carTitle: "Nissan R34 GTR\n40.000Km\nRB26Engine")]
    
    
    private lazy var slidesView : SlidesView = {
       let view = SlidesView(carSlides: slides)
        return view
    }()
    
    private lazy var buttonView : ButtonView = {
        let view = ButtonView(textColor: .systemBlue)
        
        return view
    }()
    
    private lazy var stackView : UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [slidesView,buttonView])
        stackView.axis = .vertical
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        slidesView.showNextCarSlide()
    }

    
    private func setLayout(){
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
    }

}

