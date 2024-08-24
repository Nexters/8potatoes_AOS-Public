//
//  BaseViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

import PinLayout
import FlexLayout
import RxSwift

class BaseViewController: UIViewController {
    
    lazy private(set) var className: String = {
      return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    deinit {
      log.verbose("DEINIT: \(self.className)")
    }

    
    func layout() {}
    func configure() {}
    func addView() {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("ViewDidLoad: \(self.className)")
        self.view.backgroundColor = .white
        self.configure()
        self.addView()
    }
}
