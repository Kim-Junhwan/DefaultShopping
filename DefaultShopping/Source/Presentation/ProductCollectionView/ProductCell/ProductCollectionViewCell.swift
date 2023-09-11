//
//  ProductCollectionViewCell.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ProductCollectionViewCell.self)
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 1
        return stackView
    }()
    
    let imageBackgroundView: UIView = {
       let view = UIView()
        return view
    }()
    
    let productImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let likeButton: LikeButton = {
        let button = LikeButton()
        return button
    }()
    
    let mallLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.layoutIfNeeded()
        setView()
        setConstraints()
    }
    
    private func setView() {
        contentView.addSubview(stackView)
        imageBackgroundView.addSubview(productImageView)
        imageBackgroundView.addSubview(likeButton)
        stackView.addArrangedSubview(imageBackgroundView)
        stackView.addArrangedSubview(mallLabel)
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(priceLabel)
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.bottom.lessThanOrEqualTo(contentView)
        }
        imageBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.height.equalTo(imageBackgroundView.snp.width)
        }
        productImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        likeButton.snp.makeConstraints { make in
            make.width.height.equalToSuperview().multipliedBy(0.2)
            make.bottom.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configureCell(product: Product) {
        productImageView.setImageFromImagePath(imagePath: product.imagePath)
        likeButton.isSelected = product.like
        mallLabel.text = product.mall
        productNameLabel.text = product.title
        priceLabel.text = "\(product.price)"
    }
}
