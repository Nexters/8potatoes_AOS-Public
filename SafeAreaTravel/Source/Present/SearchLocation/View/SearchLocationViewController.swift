//
//  SearchLocationViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/23/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class SearchLocationViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let reactor: SearchLocationReactor
        
    // MARK: - UI
    
    private let titleLabel = UILabel().then {
        $0.text = "위치 검색"
        $0.sizeToFit()
    }
    private let backBtn = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .bik100
    }
    private let searchBar = SearchBar().then {
        $0.placeholder = "지번, 도로명, 건물명으로 검색"
    }
    private let divideView = DivideLine(type: .dot)
    private let searchTipInfoImg = UIImageView().then {
        $0.image = UIImage(named: "searchTipInfo")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    private let searchResultTabelView = UITableView(frame: .zero, style: .plain).then {
        $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        $0.backgroundColor = .clear
    }
    private let resultContentLabel = UILabel().then {
        $0.text = "xx 검색된 주소"
        $0.sizeToFit()
    }
    
    // MARK: - Init & LifeCycle
    
    override func viewDidLoad() {
        addView()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout()
    }
    
    init(reactor: SearchLocationReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUpUI
    
    override func  configure() {
         self.view.backgroundColor = UIColor(hexString: "FFFCF6")
     }
    
    override func addView() {
         [titleLabel, backBtn, searchBar, divideView, searchTipInfoImg, searchResultTabelView, resultContentLabel].forEach {
             self.view.addSubview($0)
         }
    }
    
    override func layout() {
         titleLabel.pin
             .top(self.view.pin.safeArea.top + 32)
             .hCenter()
        
         backBtn.pin
             .top(self.view.pin.safeArea.top + 32)
             .left(20)
             .height(24)
             .width(24)
        
        searchBar.pin
            .below(of: titleLabel)
            .marginTop(46)
            .horizontally(20)
            .height(48)
        
         resultContentLabel.pin
             .below(of: searchBar)
             .marginTop(40)
             .left(20)
         
        divideView.pin
            .below(of: resultContentLabel)
            .marginTop(20)
            .horizontally(20)
            .height(2)
         
         searchResultTabelView.pin
             .below(of: divideView)
             .marginTop(2)
             .left()
             .right()
             .bottom(self.view.safeAreaInsets.bottom)
    }
    
    // MARK: - Bind
    
    private func bind(reactor: SearchLocationReactor) {
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.searchTipInfoImg.isHidden = true
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .map { SearchLocationReactor.Action.searchLocation($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.searchResults }
            .bind(to: searchResultTabelView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self)) { index, model, cell in
                cell.configure(model)
            }
            .disposed(by: disposeBag)
        
    }
}
// MARK: - UITableViewDelegate

extension SearchLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
