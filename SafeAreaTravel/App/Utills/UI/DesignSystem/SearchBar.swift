//
//  SearchBar.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

import PinLayout
import RxSwift
import RxCocoa

final class SearchBar: UITextField {
    
    private let searchImg = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .bik70
        $0.frame.size = CGSize(width: 24, height: 24)
    }
    
    private let xMarkBtn = UIButton().then {
        $0.setImage(UIImage(named: "close_btn"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = true
        $0.frame.size = CGSize(width: 24, height: 24)
    }
    
    private let disposeBag = DisposeBag()
    let searchResultExists = BehaviorRelay<Bool>(value: true)

    private func layout() {
        self.addSubview(xMarkBtn)
        self.addLeftView(view: searchImg)

        NSLayoutConstraint.activate([
            xMarkBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            xMarkBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            xMarkBtn.heightAnchor.constraint(equalToConstant: 24),
            xMarkBtn.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func bindUI() {
        self.rx.text.orEmpty
            .map { $0.isEmpty }
            .bind(to: xMarkBtn.rx.isHidden)
            .disposed(by: disposeBag)
        
        xMarkBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.text = ""
                self?.sendActions(for: .valueChanged)
            })
            .disposed(by: disposeBag)
        
        searchResultExists
            .map { $0 ? UIColor.green.cgColor : UIColor.red.cgColor }
            .subscribe(onNext: { [weak self] borderColor in
                self?.layer.borderColor = borderColor
            })
            .disposed(by: disposeBag)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // xMarkBtn이 탭된 경우, 그 뷰를 반환하여 텍스트 필드 이벤트를 무시합니다.
        if let result = super.hitTest(point, with: event), result == xMarkBtn {
            return result
        }
        return super.hitTest(point, with: event)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addLeftPadding()
        layout()
        bindUI()
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "D2CEC6").cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
