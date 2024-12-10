//
//  ViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import Alamofire
import CoreData

/// 메인 화면 ViewController
final class MainViewController: UIViewController {
    
    private var datas: [PhoneNumber] = []
    
    private let phoneBookManager = PhoneBookManager.shared
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureData()
        configureNavigationController()
        configureTableView()
        
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureData()
    }
    
    //데이터 설정 메서드
    private func configureData() {
        guard let datas = phoneBookManager.read() else { return }
        self.datas = datas
        self.tableView.reloadData()
    }
    
}

//MARK: - NavigationController

extension MainViewController {
    
    // 네비게이션 컨트롤러 설정 메서드
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        
        let titleFont = UIFont.systemFont(ofSize: 23, weight: .bold)
        let itemFont = UIFont.systemFont(ofSize: 21, weight: .semibold)
        navigationController.navigationBar.titleTextAttributes = [.font: titleFont]
        
        let titleLabel = UILabel()
        titleLabel.text = "친구 목록"
        titleLabel.font = titleFont
        
        let addButton = UIBarButtonItem(title: "추가",
                                        style: .plain,
                                        target: self,
                                        action: #selector(pushPhoneBookViewController))
        addButton.setTitleTextAttributes([.font: itemFont], for: .normal)
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.setRightBarButton(addButton, animated: false)
    }
    
    // PhoneBookViewController 푸쉬
    @objc private func pushPhoneBookViewController() {
        guard let navigationController = self.navigationController else { return }
        let phoneBookViewController = makePhoneBookViewController(nil)
        navigationController.pushViewController(phoneBookViewController, animated: false)
    }
    
    // PhoneBookViewController 설정 및 반환
    private func makePhoneBookViewController(_ data: PhoneNumber?) -> PhoneBookViewController {
        let phoneBookViewController = PhoneBookViewController()
        if let data { phoneBookViewController.setData(data) }
    
        return phoneBookViewController
    }
}


//MARK: - TableViewController

extension MainViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // TableView 설정
    private func configureTableView() {
        self.view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
        }
        
        registerCell()
    }
    
    // TableViewCell 등록
    private func registerCell() {
        self.tableView.register(PhoneNumberCell.self,
                                forCellReuseIdentifier: PhoneNumberCell.id)
    }
    
    // 셀 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    // 셀 dequeue
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let phoneNumberCell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberCell.id,
                                                                  for: indexPath) as? PhoneNumberCell else {
            return UITableViewCell()
        }
        
        let phoneNumber = datas[indexPath.row]
        phoneNumberCell.setData(phoneNumber)
        
        return phoneNumberCell
    }
    
    // TableViewCell 사이즈
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    // 셀 선택시 실행
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let phoneNumberCell = tableView.cellForRow(at: indexPath) as? PhoneNumberCell,
              let data = phoneNumberCell.data,
              let navigationController = self.navigationController else { return }
        
        let phoneBookViewController = makePhoneBookViewController(data)
        
        navigationController.pushViewController(phoneBookViewController, animated: false)
    }
    
    // 셀 수정 (삭제)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = datas[indexPath.row]
            phoneBookManager.delete(data)
            configureData()
        }
    }
}

#Preview {
    MainViewController()
}
