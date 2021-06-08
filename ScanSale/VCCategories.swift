//
//  VCCategories.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 4/24/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit
import Foundation

class VCCategories: UIViewController {
    let vcKinds = VCKinds()
    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        navigationItem.backBarButtonItem = backBarBtnItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "კატეგორიები"
        navigationController?.setNavigationBarHidden(false, animated: true)
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        scrollView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        scrollView.layer.backgroundColor = UIColor.white.cgColor
        view.addSubview(scrollView)
        let url = URL(string: "https://myoutlet.ge/api/categories/get")!
        let categoryTask = URLSession.shared.dataTask(with: url) {(data,response,error) in guard let data = data else {return}
            self.vcKinds.categories = data
            do {
                var y = 20
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    for category in jsonArray{
                        DispatchQueue.main.async {
                            [weak self] in
                            let name = category["Name"] as? String
                            let id = category["Id"] as? Int
                            let button = UIButton(frame: CGRect(x: 15, y: y, width: Int(screenWidth - 30), height: 70))
                            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
                            button.setTitle(name, for: .normal)
                            button.setTitleColor(UIColor.black, for: .normal)
                            button.backgroundColor = UIColor.white
                            button.layer.shadowColor = UIColor.gray.cgColor
                            button.layer.shadowOffset = CGSize(width: 1.5, height: 1)
                            button.layer.shadowOpacity = 1
                            button.layer.shadowRadius = 1.0
                            button.clipsToBounds = true
                            button.layer.masksToBounds = false
                            button.layer.cornerRadius = 10
                            button.tag = id!
                            button.addTarget(self, action:#selector(self?.buttonClicked), for: .touchUpInside)
                            self?.scrollView.addSubview(button)
                            y += 100
                            self?.scrollView.isScrollEnabled = true
                            self?.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(Float(y + 20)))
                        }
                    }
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        categoryTask.resume()
        
    }
    @objc func buttonClicked(sender: UIButton) {
        DispatchQueue.main.async {
            [weak self] in
            self?.vcKinds.kindId = sender.tag
            self?.navigationController?.pushViewController(self!.vcKinds, animated: true)
        }
    }
}

