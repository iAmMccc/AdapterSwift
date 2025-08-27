//
//  ViewController.swift
//  AdapterSwift
//
//  Created by Mccc on 11/27/2023.
//  Copyright (c) 2023 Mccc. All rights reserved.
//

import UIKit
import SnapKit
import AdapterSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    

        let size = CGSize(width: 117.adapter, height: 40.adapter)
        
        let size1 = CGSize(width: 117, height: 40).adapter
        
        print(size, size1)
        
        CGSize(width: <#T##Int#>, height: <#T##Int#>)
        
        Adapter.share.base = 375
        
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(10.adapter)
            make.top.equalTo(100.adapter)
            make.size.equalTo(CGSize(width: 100, height: 100).adapter)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10.adapter)
            make.right.equalTo(-10.adapter)
            make.top.equalTo(imageView)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5.adapter)
            make.left.right.equalTo(titleLabel)
            make.bottom.lessThanOrEqualTo(imageView)
        }
        
        
        
        
        let aView = UIView()
        aView.backgroundColor = UIColor.blue
        view.addSubview(aView)
        
        
        let bView = UIView()
        bView.backgroundColor = UIColor.yellow
        view.addSubview(bView)
        
        let cView = UIView()
        cView.backgroundColor = UIColor.orange
        view.addSubview(cView)
        
        var width = (UIScreen.main.bounds.size.width - 20) / 3
        
        // ⚠️ 再进行适配，就会出现UI问题，导致超出屏幕。
        width = width.adapter
        aView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.height.equalTo(100)
            make.top.equalTo(300)
            make.width.equalTo(width)
        }
        
        bView.snp.makeConstraints { make in
            make.height.top.width.equalTo(aView)
            make.left.equalTo(aView.snp.right)
        }
        
        cView.snp.makeConstraints { make in
            make.height.top.width.equalTo(aView)
            make.left.equalTo(bView.snp.right)
        }
        
        
    }

    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20).adapter
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.text = "Swift 数据解析库 SmartCodable"
        return label
    }()
    
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16).adapter
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        label.text = "使用系统Codable为解码和性，对Codable解析失败的情况（没有键，值为null，值类型错误）做了兼容处理。如果可以进行值类型转换为有效值就转换返回出去，如果不能转换就提供模型属性对应类型的默认值。 "
        return label
    }()
    
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_60pt")
        return iv
    }()
}


