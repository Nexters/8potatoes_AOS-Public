//
//  StartViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

import Then
import PinLayout
import FlexLayout

final class StartViewController: BaseViewController {
    // MARK: - Properties


    // MARK: - UI
    
    private let welecomeLabel = UILabel().then {
        $0.text = "쥬쥬와 함께\n휴게소 맛집을 찾아보세요!"
    }
    private let welecomeImg = UIImageView().then {
        $0.image = UIImage(named: "")
    }
    private let startInputDesLabel = UILabel().then {
        $0.text = "출발지 입력*"
    }
    private let goalInputDesLabel = UILabel().then {
        $0.text = "출발지 입력*"
    }
    private let startLocateTextField = UITextField()
    private let divideLine = UIView()
    private let goalLocateTextField = UITextField()
    private let sideImge = UIImageView().then {
        $0.image = UIImage(named: "sideLocateImg")
    }

    // MARK: - Init & LifeCycle
    
    
    // MARK: - SetUpUI
    override func addView() {
        [welecomeImg, welecomeLabel].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func layout() {
        
    }

    
    // MARK: - Bind
    
    private func bind(reactor: MainMapReactor) {
        
    }
}
