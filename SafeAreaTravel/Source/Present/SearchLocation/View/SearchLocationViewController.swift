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
    private var disposeBag = DisposeBag()
    private var isFirstInput = true
    
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
        $0.isUserInteractionEnabled = true // 상호작용 허용
    }
    private let resultContentLabel = UILabel().then {
        $0.text = ""
        $0.sizeToFit()
    }
    
    // MARK: - Init & LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        configure()
        bind(reactor: reactor)
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
    
    override func configure() {
        self.view.backgroundColor = UIColor(hexString: "FFFCF6")
        searchResultTabelView.delegate = self
        searchResultTabelView.tableFooterView = UIView() // 이 부분을 추가합니다.
        searchResultTabelView.allowsSelection = true // 셀 선택을 허용합니다.
        bindUI()
    }
    
    override func addView() {
         [titleLabel, backBtn, searchBar, divideView, searchResultTabelView, resultContentLabel].forEach {
             self.view.addSubview($0)
         }
        searchResultTabelView.addSubview(searchTipInfoImg)
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
             .marginTop(8)
             .left()
             .right()
             .bottom(self.view.safeAreaInsets.bottom)
        
        searchTipInfoImg.pin
            .below(of: divideView)
            .marginTop(2)
            .left()
            .right()
            .height(300)
    }
    
    // MARK: - Bind
    
    private func bind(reactor: SearchLocationReactor) {
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .map { SearchLocationReactor.Action.searchLocation($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchResultTabelView.rx.modelSelected(SearchLocationModel.self)
            .map { SearchLocationReactor.Action.selectLocation($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.searchResults }
            .bind(to: searchResultTabelView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self)) { index, model, cell in
                cell.configure(model)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.searchResults.isEmpty }
            .bind(to: searchBar.searchResultExists)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        searchBar.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] in
                if self?.isFirstInput == true {
                    self?.isFirstInput = false
                    self?.searchTipInfoImg.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension SearchLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
