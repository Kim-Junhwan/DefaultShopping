//
//  TableProductCollectionViewCell.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit

class TableProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: TableProductCollectionViewCell.self)
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(imageBackgroundView)
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(likeButton)
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var labelStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.addArrangedSubview(mallLabel)
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.axis = .vertical
        stackView.spacing = 5
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
        label.numberOfLines = 1
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setView() {
        contentView.addSubview(stackView)
        imageBackgroundView.addSubview(productImageView)
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        imageBackgroundView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
        }
        productImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
    }
    
    func configureCell(product: Product) {
        likeButton.isSelected = product.like
        mallLabel.text = product.mall
        productNameLabel.text = product.title
        priceLabel.text = priceFormat(price: product.price)
    }
    
    func updateImageStatus(status: ImageStatus) {
        switch status {
        case .success(let uIImage):
            productImageView.image = uIImage
        case .fail:
            productImageView.image = UIImage(systemName: "xmark")
        }
    }
    
    private func priceFormat(price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let formattedText = formatter.string(from: .init(value: price)) else { return "" }
        return formattedText
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(named: "ready")
    }
}
