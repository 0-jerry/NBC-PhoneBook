//
//  EditorViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import Kingfisher
import SnapKit

/// 전화번호 생성 및 수정 화면
///
final class PhoneBookViewController: UIViewController, ErrorAlertPresentable {
    
    // 전화번호 데이터 매니저
    private let phoneBookManager = PhoneBookManager.shared
    
    // 전화번호 데이터
    private var phoneNumber: PhoneNumber?
    
    // 현재 이미지 주소 저장
    private var imageURL: URL?
    
    // 생성화면 or 수정화면
    private var editingStyle: PhoneBookViewController.EditingStyle {
        switch self.phoneNumber {
        case nil:
            return .creat
        default:
            return .update
        }
    }
    
    // 화면 스타일 (생성, 수정)
    private enum EditingStyle {
        case creat
        case update
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
    private lazy var nameTextView: UITextView = {
        let textView = UITextView()
        setUpTextView(textView)
        return textView
    }()
    
    // 번호 텍스트 뷰
    private lazy var phoneNumberTextView: UITextView = {
        let textView = UITextView()
        setUpTextView(textView)
        return textView
    }()
    
    // 재사용 텍스트 뷰 (이름, 번호)
    private func setUpTextView(_ textView: UITextView) {
        textView.textContentType = .telephoneNumber
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .black
        textView.text = nil
        
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        
        textView.isScrollEnabled = false
        textView.isEditable = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        configureNavigationController()
        
        switch editingStyle {
        case .creat:
            defaultPokeImage()
        case .update:
            configureData()
        }
        
        self.pokeRandomButton.addTarget(self,
                                        action: #selector(randomButtonTapped),
                                        for: .touchUpInside)
    }
    
}

//MARK: - set up UI
extension PhoneBookViewController {
    
    //UI 레이아웃 설정
    private func setUpUI() {
        
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


//MARK: - 외부 사용 메서드
extension PhoneBookViewController {
    
    // 데이터 저장
    func setData(_ phoneNumber: PhoneNumber) {
        self.phoneNumber = phoneNumber
    }
    
    // 뷰에 데이터 적용
    private func configureData() {
        guard let phoneNumber = self.phoneNumber else { return }
        
        configurePokeImage(phoneNumber.imageURL)
        nameTextView.text = phoneNumber.name
        phoneNumberTextView.text = phoneNumber.number
    }
}


//MARK: - NavigationController
extension PhoneBookViewController {
    
    // 네비게이션 바 설정
    private func configureNavigationController() {
        let rightBarButtonItem = UIBarButtonItem(title: "적용",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(applyButtonTapped))
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        titleLabel.text = editingStyle == .creat ? "연락처 추가" : phoneNumber?.name
        titleLabel.textAlignment = .center
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // 네비게이션 바 적용 버튼 액션
    @objc private func applyButtonTapped() {
        savePhoneNumber()
        guard let navigationController else { return }
        let _ = navigationController.popViewController(animated: false)
    }
    
    // PhoneBookManager 에 데이터 저장
    private func savePhoneNumber() {
        guard let phoneNumber = currentPhoneNumber() else { return }
        switch editingStyle {
        case .creat:
            creat(phoneNumber)
        case .update:
            update(phoneNumber)
        }
    }
    
    // 입력 데이터를 PhoneNumber로 반환
    private func currentPhoneNumber() -> PhoneNumber? {
        guard let name = nameTextView.text,
              let number = phoneNumberTextView.text,
              let imageURL = imageURL else { return nil }
        
        let id = phoneNumber?.id ?? UUID()
        let numberStr = PhoneNumberFormatter(number).form()
        
        return PhoneNumber(id: id,
                           imageURL: imageURL,
                           name: name,
                           number: numberStr)
    }
    
    // phoneBookManager를 통해 CoreData에 데이터 저장
    private func creat(_ phoneNumber: PhoneNumber) {
        do {
            self.phoneNumber = phoneNumber
            try phoneBookManager.creat(phoneNumber)
        } catch {
            presentErrorAlert("creat failed")
        }
    }
    
    // phoneBookManager를 통해 CoreData의 데이터 수정
    private func update(_ phoneNumber: PhoneNumber) {
        do {
            try phoneBookManager.update(phoneNumber)
        } catch {
            presentErrorAlert("update failed")
        }
    }
    
}


//MARK: - 이미지 로드 (Kingfisher 사용)
extension PhoneBookViewController {
    
    // 랜덤 이미지 생성 버튼 액션
    @objc private func randomButtonTapped() {
        guard let imageURL = PokeData.randomURL() else { return }
        configurePokeImage(imageURL)
    }
    
    //데이터가 없을 경우 메타몽 설정
    private func defaultPokeImage() {
        guard let imageURL = PokeData.dafaultURL() else { return }
        configurePokeImage(imageURL)
    }
    
    //URL 저장 및 pokeImageView 업데이트
    private func configurePokeImage(_ imageURL: URL) {
        self.imageURL = imageURL
        pokeImageView.kf.setImage(with: imageURL)
    }
    
}
