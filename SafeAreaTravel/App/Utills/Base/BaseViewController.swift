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

    // MARK: Rx
    var disposeBag = DisposeBag()
    
    func layout() {}
    func configure() {}
    func addView() {}
    func binding() {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.addView()
        self.layout()
        self.binding()
        self.view.backgroundColor = .white
    }
}
