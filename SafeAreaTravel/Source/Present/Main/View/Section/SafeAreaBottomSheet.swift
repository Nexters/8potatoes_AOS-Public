//
//  SafeAreaBottomSheet.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/23/24.
//

import UIKit
import FloatingPanel

final class SafeAreaBottomSheet: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        // 바텀 시트의 레이아웃 설정
        let label = UILabel()
        label.text = "Bottom Sheet"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
