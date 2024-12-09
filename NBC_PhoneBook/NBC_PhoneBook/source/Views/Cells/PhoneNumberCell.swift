//
//  PhoneNumberCell.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import Alamofire
import SnapKit

final class PhoneNumberCell: UITableViewCell {
    
    static let id: String = "PhoneNumberCell"
    
    private var data: PokePhoneNumber?

    // 포켓몬 이미지 뷰
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        imageView.backgroundColor = .clear
        
        imageView.image = UIImage(systemName: "pencil.circle.fill")
        
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
        label.font = UIFont.systemFont(ofSize: 20,
                                       weight: .medium)

        label.backgroundColor = .clear

        label.text = "name"
        
        return label
    }()
    
    // 이름 라벨 뷰
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        
        label.font = UIFont.systemFont(ofSize: 17,
                                       weight: .regular)
        
        label.text = "010-0000-0000"

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PhoneNumberCell {
    
    private func configureUI() {
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
    
    func setData(_ phoneNumber: PokePhoneNumber) {
        self.data = phoneNumber
        
    }
    
    private func updateNameLabel(_ name: String) {
        nameLabel.text = name
    }
    
    private func updateNumberLabel(_ phoneNumber: String) {
        numberLabel.text = phoneNumber
    }
    
    private func updatePokeImage(_ pokeNumber: Int) {
        
    }
    
}



#Preview {
    MainViewController()
}
