//
//  PhoneNumberCell.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import Kingfisher
import SnapKit

///PhoneNumberTableViewCell
final class PhoneNumberTableViewCell: UITableViewCell {
    
    static let id: String = "PhoneNumberTableViewCell"
    
    private(set) var data: PhoneNumber?

    // 포켓몬 이미지 뷰
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // 라벨 스택 뷰
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    // 이름 라벨 뷰
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.backgroundColor = .clear
        
        return label
    }()
    
    // 전화번호 라벨 뷰
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //재사용시 데이터 초기화
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetData()
    }
}


extension PhoneNumberTableViewCell {
    
    // UI 설정
    private func setUpUI() {
        self.backgroundColor = .clear
        
        [pokeImageView,
         labelStackView
        ].forEach { addSubview($0) }
        
        [nameLabel,
         numberLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
        
        pokeImageView.snp.makeConstraints {
            $0.width.height.equalTo(70)
            $0.leading.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(pokeImageView.snp.trailing).offset(80)
        }
        
    }
    
    //데이터 저장
    func configureData(_ phoneNumber: PhoneNumber) {
        self.data = phoneNumber
        
        updateNameLabel(phoneNumber.name)
        updateNumberLabel(phoneNumber.number)
        updatePokeImage(phoneNumber.imageURL)
    }
    
    // 이름 라벨 업데이트
    private func updateNameLabel(_ name: String) {
        nameLabel.text = name
    }
    
    // 전화번호 라벨 업데이트
    private func updateNumberLabel(_ phoneNumber: String) {
        numberLabel.text = phoneNumber
    }
    
    // 이미지 업데이트
    private func updatePokeImage(_ imageURL: URL) {
        pokeImageView.kf.setImage(with: imageURL)
    }
    
    // 데이터 초기화
    private func resetData() {
        self.data = nil
        self.pokeImageView.image = nil
        self.nameLabel.text = nil
        self.numberLabel.text = nil
    }
    
}



#Preview {
    MainViewController()
}
