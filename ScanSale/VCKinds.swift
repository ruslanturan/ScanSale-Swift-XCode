//
//  VCKinds.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 4/25/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit

class VCKinds: UIViewController {
    var categories = Data()
    var kindId:Int = 0
    var categoryList = UIScrollView()
    let vcProducts = VCProducts()

    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        navigationItem.backBarButtonItem = backBarBtnItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            self?.view.layer.backgroundColor = UIColor.white.cgColor
            self?.navigationItem.title = "ქვეკატეგორიები"
            self?.categoryList.layer.backgroundColor = UIColor.white.cgColor
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            self?.categoryList.frame = CGRect(x: 0, y: 100, width: screenWidth, height: 100)
            self?.view.addSubview(self!.categoryList)
            do {
                DispatchQueue.main.async {
                    for view in self!.categoryList.subviews {
                        view.removeFromSuperview()
                    }
                }
                var x = 20
                if let jsonArray = try JSONSerialization.jsonObject(with: self!.categories, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    for category in jsonArray{
                        DispatchQueue.main.async {
                            let name = category["Name"] as? String
                            let id = category["Id"] as? Int
                            let btnWidth = name!.count * 10 + 30
                            let button = UIButton(frame: CGRect(x: x, y: 10, width: btnWidth, height: 70))
                            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                            button.setTitle(name, for: .normal)
                            button.setTitleColor(UIColor.black, for: .normal)
                            if self?.kindId == id{
                                button.setTitleColor(UIColor(red: 225/255, green: 130/255, blue: 32/255, alpha: 1.0), for: .normal)
                                self?.categoryList.setContentOffset(CGPoint(x: x, y: -5), animated: false)
                            }
                            button.backgroundColor = UIColor.white
                            button.layer.shadowColor = UIColor.gray.cgColor
                            button.layer.shadowOffset = CGSize(width: 1.5, height: 1)
                            button.layer.shadowOpacity = 1
                            button.layer.shadowRadius = 1.0
                            button.clipsToBounds = true
                            button.layer.masksToBounds = false
                            button.layer.cornerRadius = 10
                            button.tag = id!
                            button.addTarget(self, action:#selector(self!.ctButtonClicked), for: .touchUpInside)
                            self?.categoryList.addSubview(button)
                            x += btnWidth + 30
                            self?.categoryList.contentSize = CGSize(width: CGFloat(Float(x + 60)), height: 100)
                        }
                    }
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            let kindList = UIScrollView(frame: CGRect(x: 0, y: 200, width: screenWidth, height: screenHeight - 100))
            kindList.layer.backgroundColor = UIColor.white.cgColor
            self?.view.addSubview(kindList)
            let url = URL(string: "https://myoutlet.ge/api/kinds/get/" + String(self!.kindId))!
            let kindTask = URLSession.shared.dataTask(with: url) {(data,response,error) in guard let data = data else {return}
                self?.vcProducts.kinds = data
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                    {
                        var y = 20
                        for kind in jsonArray{
                            DispatchQueue.main.async {
                                let name = kind["Name"] as? String
                                let image = kind["image"] as? String
                                let id = kind["Id"] as? Int
                                let kindName = UILabel(frame: CGRect(x: 25, y: y, width: Int(screenWidth - 50), height: 50))
                                kindName.text = name
                                kindList.addSubview(kindName)
                                let button = UIButton(frame: CGRect(x: 15, y: y + 50, width: Int(screenWidth - 30), height: 250))
                                button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
                                button.backgroundColor = UIColor.white
                                button.layer.shadowColor = UIColor.gray.cgColor
                                button.layer.shadowOffset = CGSize(width: 1.5, height: 1)
                                button.layer.shadowOpacity = 1
                                button.layer.shadowRadius = 1.0
                                button.clipsToBounds = true
                                button.layer.masksToBounds = false
                                button.layer.cornerRadius = 20
                                button.tag = id!
                                button.addTarget(self, action:#selector(self?.kindButtonClicked), for: .touchUpInside)
                                let imageUrl = URL(string:"https://myoutlet.ge/Images/Kinds/" + image!)
                                let imageTask = URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
                                    guard let data = data, error == nil else { return }
                                    DispatchQueue.main.async() {
                                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(screenWidth - 30), height: 250))
                                        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
                                        imageView.layer.cornerRadius = 20
                                        imageView.clipsToBounds = true
                                        imageView.image = UIImage(data: data)
                                        button.addSubview(imageView)
                                    }
                                }
                                imageTask.resume()
                                button.addTarget(self, action:#selector(self?.kindButtonClicked), for: .touchUpInside)
                                y += 320
                                kindList.addSubview(button)
                                kindList.isScrollEnabled = true
                                kindList.contentSize = CGSize(width: screenWidth, height: CGFloat(Float(y + 100)))
                            }
                        }
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            kindTask.resume()
        }
    }

    @objc func ctButtonClicked(sender: UIButton) {
        DispatchQueue.main.async {
            [weak self] in
            if self?.kindId != sender.tag{
                self?.kindId = sender.tag
                self?.viewWillAppear(true)
            }
        }
    }
    
    @objc func kindButtonClicked(sender: UIButton) {
        DispatchQueue.main.async {
            [weak self] in
            self?.vcProducts.productId = sender.tag
            self?.navigationController?.pushViewController(self!.vcProducts, animated: true)
        }
    }

}
