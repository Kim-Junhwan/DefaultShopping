//
//  LikeButton.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit

class LikeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/2
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setImage(UIImage(systemName: "heart.fill"), for: .normal) : setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
