//
//  ViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import Alamofire
import CoreData
import SnapKit

/// 메인 화면 ViewController
final class MainViewController: UIViewController {
    
    private var data: [PokePhoneNumber] = []
    
    private lazy var phoneBookManager: PhoneBookManager? = {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let container = appDelegate.persistentContainer
        
        return PhoneBookManager(container: container)
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureNavigationController()
        configureTableView()
    }
    
}

//MARK: - NavigationController

extension MainViewController {
    
    // 네비게이션 컨트롤러 설정 메서드
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        
        let titleFont = UIFont.systemFont(ofSize: 25, weight: .bold)
        let itemFont = UIFont.systemFont(ofSize: 21, weight: .semibold)
        navigationController.navigationBar.titleTextAttributes = [.font: titleFont]
        
        let addButton = UIBarButtonItem(title: "추가",
                                        style: .plain,
                                        target: self,
                                        action: #selector(pushPhoneBookViewController))
        addButton.setTitleTextAttributes([.font: itemFont], for: .normal)

        self.title = "친구 목록"
        self.navigationItem.setRightBarButton(addButton, animated: false)
    }
    
    // EditorViewController 푸쉬
    @objc private func pushPhoneBookViewController() {
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(PhoneBookViewController(), animated: false)
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
        return data.count
    }
    
    // TableViewCell 로드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let phoneNumberCell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberCell.id, for: indexPath) as? PhoneNumberCell else { return UITableViewCell() }
        
        let phoneNumber = data[indexPath.row]
        phoneNumberCell.setData(phoneNumber)
        
        return phoneNumberCell
    }
    
    // TableViewCell 사이즈
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    

    
}


//MARK: - Set Data

extension MainViewController {
    
    // 데이터 설정 -> CoreData 로드
    private func configureData() {
        
    }
    

}


#Preview {
    MainViewController()
}
