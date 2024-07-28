//
//  UITextField+Extension.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

extension UITextField {
    
    func addLeftView(view: UIView) {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width + 12, height: view.frame.height))
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        container.addSubview(view)
        
        self.leftView = container
        self.leftViewMode = .always
    }
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addRightView(view: UIView) {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width + 12, height: view.frame.height))
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        container.addSubview(view)
        
        self.rightView = container
        self.rightViewMode = .always
    }
}

