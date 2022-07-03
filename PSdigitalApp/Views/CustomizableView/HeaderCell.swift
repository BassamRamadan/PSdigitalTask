//
//  HeaderCell.swift
//  PSdigitalApp
//
//  Created by Bassam on 7/2/22.
//

import UIKit

class HeaderCell: UICollectionReusableView{
    let CategoryName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        CategoryName.font = .boldSystemFont(ofSize: 22)
        addSubview(CategoryName)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CategoryName.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
