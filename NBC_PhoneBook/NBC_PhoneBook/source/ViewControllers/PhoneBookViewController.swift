//
//  EditorViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import SnapKit

/*
 FIXME: 리팩토링
 1. 데이터 형태 수정? -> Core Data에 이미지를 저장하는 것은 잘못된 것 같다.
                     그렇다고 번호를 통해 매번 로드해야할까? 캐싱? Kingfisher
 
 2. 
 
 2. 코드 정리
 3. VC 역할 분리
 4. 메서드 분리
 5. 모델 형태 수정
 6. 델리게이터 패턴 만들어보기
 
 TODO: 추가 기능
 1. 적용버튼 비활성화
 */

/// 전화번호 생성 화면 ViewController
final class PhoneBookViewController: UIViewController {
    
    private let phoneBookManager = PhoneBookManager.shared
    private var data: PhoneNumber?
    private var haveData: Bool { self.data != nil }
    private var isSet: Bool {
        guard pokeImageView.image != nil,
              !nameTextView.text.isEmpty,
              !phoneNumberTextView.text.isEmpty else { return false }
        return true
    }
        
    // 포켓몬 이미지, 랜덤 이미지 생성 버튼
    private let pokeImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    // 포켓몬 이미지
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.cornerRadius = 100
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    // 랜덤 이미지 생성 버튼
    private let pokeRandomButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.backgroundColor = .lightGray
        button.contentMode = .center
        
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    // 이름 텍스트 뷰, 번호 텍스트 뷰
    private let textViewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()
    
    // 이름 텍스트 뷰
    private lazy var nameTextView: UITextView = inputTextView()
    
    // 번호 텍스트 뷰
    private lazy var phoneNumberTextView: UITextView = inputTextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationController()
        
        if !haveData {
            defaultImage()
        }
        
        self.pokeRandomButton.addTarget(self,
                                        action: #selector(randomButtonTapped),
                                        for: .touchUpInside)
    }
    
}

//MARK: - Configure UI
extension PhoneBookViewController {
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        [
            pokeImageStackView,
            textViewStackView
        ].forEach { view.addSubview($0) }
        
        [
            pokeImageView,
            pokeRandomButton
        ].forEach { pokeImageStackView.addArrangedSubview($0) }
        
        [
            nameTextView,
            phoneNumberTextView
        ].forEach { textViewStackView.addArrangedSubview($0) }
        
        pokeImageStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.height.equalTo(250)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        pokeImageView.snp.makeConstraints {
            $0.width.height.equalTo(200)
        }
        
        textViewStackView.snp.makeConstraints {
            $0.top.equalTo(pokeImageStackView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(80)
        }
        
    }
}


//MARK: - Navigation Controller
extension PhoneBookViewController {
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        
        let titleFont = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        navigationController.navigationBar.titleTextAttributes = [.font: titleFont]
        
        let titleLabel = UILabel()
        titleLabel.text = "연락처 추가"
        titleLabel.font = titleFont
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(applyButtonTapped))
        
    }
    
    @objc private func applyButtonTapped() {
        saveData()
        
        guard let navigationController else { return }
        let _ = navigationController.popViewController(animated: false)
    }
    
    // PhoneBookManager 에 데이터 저장
    private func saveData() {
        guard let phoneNumber = currentPhoneNumber() else { return }

        if !haveData {
            phoneBookManager.creat(phoneNumber)
            self.data = phoneNumber
        } else {
            phoneBookManager.update(phoneNumber)
        }
    }
    
    // 입력 데이터를 PhoneNumber로 반환
    private func currentPhoneNumber() -> PhoneNumber? {
        guard isSet,
              let pngData = pokeImageView.image?.pngData(),
              let name = nameTextView.text,
              let number = phoneNumberTextView.text else { return nil }
        
        let id = data?.id ?? UUID()
        let numberStr = MobilePhoneNumber(number).form()
        
        return PhoneNumber(id: id,
                           pokeImage: pngData,
                           name: name,
                           number: numberStr)
    }
    
    func setData(_ phoneNumber: PhoneNumber) {
        guard let image = UIImage(data: phoneNumber.pokeImage) else { return }
        
        self.data = phoneNumber
        
        DispatchQueue.main.async {
            self.pokeImageView.image = image
            self.nameTextView.text = phoneNumber.name
            self.phoneNumberTextView.text = phoneNumber.number
        }
    }
    
}


//TODO: URLSession or Alamofire 로 API 통신
extension PhoneBookViewController {
    
    //데이터가 없을 경우 메타몽 설정
    private func defaultImage() {
        fetchPokeImage(PokeData(from: 132))
    }
    
    //TODO: URLSession or Alamofire 로 API 통신
    @objc private func randomButtonTapped() {
        fetchPokeImage(PokeData())
    }
    
    // 이미지 요청 메서드
    private func fetchPokeImage(_ pokeData: PokeData) {
        guard let pngURL = pokeData.pngURL else { return }
        let urlRequest = URLRequest(url: pngURL)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard error == nil,
                  let self,
                  let data,
                  let image = UIImage(data: data),
                  let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else { return }
            
            DispatchQueue.main.async {
                self.pokeImageView.image = image
            }
        }.resume()
    }
    
    
    // 재사용 텍스트 뷰 (이름, 번호)
    private func inputTextView() -> UITextView {
        let textView = UITextView()
        textView.textContentType = .telephoneNumber
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .black
        textView.text = nil
        
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8

        textView.isScrollEnabled = false
        textView.isEditable = true
        
        return textView
    }
    
}

#Preview {
    PhoneBookViewController()
}
