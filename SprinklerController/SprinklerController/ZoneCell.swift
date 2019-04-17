//
//  ZoneCell.swift
//  SprinklerController
//
//  Created by Roderic Campbell on 4/16/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import UIKit
import IntentsUI

protocol ZoneCellDelegate: class {
    func addSiri(cell: ZoneCell)
}

class ZoneCell: UITableViewCell {
    static let reuseID = "zonecell"

    weak var delegate: ZoneCellDelegate?

    let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        stack.isLayoutMarginsRelativeArrangement = true;
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()

    let zoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMinYCorner]
        return imageView
    }()

    let shadowView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10;
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.22;
        view.clipsToBounds = false;
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view
    }()

    let whiteStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true;
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stack.backgroundColor = .white
        return stack
    }()

    let siriButton: INUIAddVoiceShortcutButton = {
        let button = INUIAddVoiceShortcutButton(style: .whiteOutline)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override func prepareForReuse() {
        zoneImageView.image = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        zoneImageView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        contentView.addSubview(shadowView)

        contentView.addSubview(contentStack)
        contentStack.addArrangedSubview(zoneImageView)
        contentStack.addArrangedSubview(whiteStack)
        whiteStack.addArrangedSubview(nameLabel)
        whiteStack.addArrangedSubview(siriButton)

        contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        contentStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        contentStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true

        contentStack.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true;
        contentStack.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true;
        contentStack.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true;
        contentStack.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true;

        let action = #selector(ZoneCell.addSiri(_:))
        siriButton.addTarget(self, action: action, for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func addSiri(_ sender: INUIAddVoiceShortcutButton) {
        delegate?.addSiri(cell: self)
    }
}
