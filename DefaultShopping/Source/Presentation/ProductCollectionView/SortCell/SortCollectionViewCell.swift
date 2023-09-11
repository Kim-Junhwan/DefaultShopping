//
//  SortCollectionViewCell.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit
import SnapKit

class SortCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: SortCollectionViewCell.self)
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                sortTitleLabel.textColor = .black
                backgroundColor = .white
            } else {
                sortTitleLabel.textColor = .white
                backgroundColor = .black
            }
        }
    }
    
    let sortTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        addSubview(sortTitleLabel)
        contentView.addSubview(sortTitleLabel)
        sortTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(5)
        }
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
}
