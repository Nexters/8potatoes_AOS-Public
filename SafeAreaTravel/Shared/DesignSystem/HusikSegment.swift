//
//  HusikSegment.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/20/24.
//

import UIKit

import RxSwift
import RxCocoa

class HusikSegment: UISegmentedControl {

    private let underlineView = UIView()
    
    var selectedTextColor: UIColor = .main100
    var unselectedTextColor: UIColor = .bik40
    var underlineColor: UIColor = .main100
    
    private var disposeBag = DisposeBag()
     
    override init(frame: CGRect) {
         super.init(frame: frame)
         setupSegment()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
     
    func configureSegments(titles: [String]) {
         removeAllSegments()
         for (index, title) in titles.enumerated() {
             insertSegment(withTitle: title, at: index, animated: false)
        }
         selectedSegmentIndex = 0
         updateSegmentStyle()
         setupUnderline()
    }

    private func setupSegment() {
         rx.selectedSegmentIndex
             .asDriver()
             .drive(onNext: { [weak self] index in
                 self?.updateSegmentStyle()
                 self?.updateUnderlinePosition()
             })
             .disposed(by: disposeBag)
    }

    private func updateSegmentStyle() {
         let selectedAttributes = [NSAttributedString.Key.foregroundColor: selectedTextColor]
         let unselectedAttributes = [NSAttributedString.Key.foregroundColor: unselectedTextColor]
         
         setTitleTextAttributes(selectedAttributes, for: .selected)
         setTitleTextAttributes(unselectedAttributes, for: .normal)
    }

    private func setupUnderline() {
         underlineView.backgroundColor = underlineColor
         addSubview(underlineView)
         updateUnderlinePosition()
    }

    private func updateUnderlinePosition() {
         let segmentWidth = bounds.width / CGFloat(numberOfSegments)
         UIView.animate(withDuration: 0.3) {
             self.underlineView.frame = CGRect(
                 x: segmentWidth * CGFloat(self.selectedSegmentIndex),
                 y: self.bounds.height - 2,
                 width: segmentWidth,
                 height: 2
            )
        }
    }
}
