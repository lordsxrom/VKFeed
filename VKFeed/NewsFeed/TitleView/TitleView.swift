//
//  TitleView.swift
//  VKFeed
//
//  Created by Nikita Shumskii on 28.12.2022.
//

import UIKit

protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

class TitleView: UIView {
    
    private let avatarView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let textField = IsetableTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(avatarView)
        addSubview(textField)
        makeConstraints()
    }
    
    func set(userViewModel: TitleViewViewModel) {
        avatarView.set(imageUrl: userViewModel.photoUrlString)
    }
    
    private func makeConstraints() {
        avatarView.anchor(
            top: topAnchor,
            leading: nil,
            bottom: nil,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 4, left: 777, bottom: 777, right: 4)
        )
        avatarView.heightAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 1).isActive = true
        avatarView.widthAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 1).isActive = true
        
        textField.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: avatarView.leadingAnchor,
            padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 12)
        )
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
}
