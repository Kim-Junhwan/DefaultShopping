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
        setButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButton() {
        backgroundColor = .white
        tintColor = .black
        setImage(UIImage(systemName: "heart.fill"), for: .selected)
        setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/2
    }
}
