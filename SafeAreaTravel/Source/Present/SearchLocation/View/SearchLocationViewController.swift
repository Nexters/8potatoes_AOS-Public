//
//  SearchLocationViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/23/24.
//

import UIKit


final class SearchLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let reactor: SearchLocationReactor
    
    // MARK: - UI
    
    private let searchBar = SearchBar()
    private let divideView = DivideLine(type: .dot)
    private let searchTipInfoImg = UIImageView().then {
        $0.image = UIImage(named: "searchTipInfo")
    }
    private let searchResultTabelView = UITableView(frame: .zero, style: .plain).then {
        $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        $0.backgroundColor = .clear
    }
    private let resultContentLabel = UILabel().then {
        $0.text = "xx 검색된 주소"
    }
    
    // MARK: - Init & LifeCycle
    
    override func viewDidLoad() {
        print("asdasd")
        view.backgroundColor = .white
        addView()
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
    
     func  configure() {
        self.navigationItem.title = "위치 검색"
        self.navigationItem.backBarButtonItem?.tintColor = .black
        self.navigationItem.backButtonTitle = ""
        view.backgroundColor = .black
    }
    
     func addView() {
         [searchBar, divideView, searchTipInfoImg, searchResultTabelView, resultContentLabel].forEach {
             self.view.addSubview($0)
         }
    }
    
     func layout() {
        
        searchBar.pin
            .top(self.view.pin.safeArea.top + 20)
            .horizontally(20)
            .height(48)
        
        divideView.pin
            .below(of: searchBar)
            .marginTop(40)
            .horizontally(20)
            .height(2)
    }
    
    // MARK: - Bind
    
    private func bind(reactor: SearchLocationReactor) {
        
    }
}
// MARK: - UITableViewDelegate

extension SearchLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
