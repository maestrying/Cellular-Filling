//
//  CustomTableViewCell.swift
//  Cellular-Filling
//
//  Created by Дывак Максим on 22.05.2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    let stackView = UIStackView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    let cellImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        return img
    }()

    //MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createStack()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func createStack() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupLayouts() {
        contentView.addSubview(cellImage)
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.widthAnchor.constraint(equalToConstant: 40),
            cellImage.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 16)
        ])
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    func configure(with title: String, description: String, image: UIImage) {
        titleLabel.text = title
        descriptionLabel.text = description
        cellImage.image = image
    }

}
