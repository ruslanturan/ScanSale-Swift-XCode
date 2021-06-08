//
//  VCProductsQR.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 5/3/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit

class VCProductsQR: UIViewController {
    var Url:String = ""
    var productId:Int = 0
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var productList = UICollectionView(frame: CGRect(x: 0, y: 160, width: 10, height: 10), collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = productList.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        navigationItem.backBarButtonItem = backBarBtnItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            self?.productList = UICollectionView(frame: CGRect(x: 0, y: 0, width: self!.screenWidth, height: self!.screenHeight), collectionViewLayout: UICollectionViewFlowLayout.init())
            self?.navigationItem.title = "პროდუქტები"
            self?.productList.layer.backgroundColor = UIColor.white.cgColor
            self?.view.addSubview(self!.productList)
            let url = URL(string: self!.Url)
            let productTask = URLSession.shared.dataTask(with: url!) {(data,response,error) in guard let data = data else {return}
                var index = 0
                var y = 0
                do {
                    DispatchQueue.main.async {
                        for view in self!.productList.subviews {
                            view.removeFromSuperview()
                        }
                    }
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                    {
                        let itemWidth = Int(self!.screenWidth / 2 - 10)
                        let itemHeight = Int(itemWidth*5/3)
                        for product in jsonArray{
                            let id = product["id"] as? Int
                            let uniqueNum = product["productUniqueNumber"] as? Int
                            let image = product["photo"] as? String
                            let name = product["productName"] as? String
                            let cost = product["saledCost"] as? Double
                            let sale = product["sale"] as? Double
                            DispatchQueue.main.async {
                                let productItem = UIButton()
                                if index % 2 == 0 {
                                    productItem.frame = CGRect(x: 5, y:y, width: itemWidth, height: itemHeight)
                                    self?.productList.contentSize = CGSize(width: self!.screenWidth, height: CGFloat(y + itemHeight + 100))
                                }
                                else{
                                    productItem.frame = CGRect(x: Int(15 + itemWidth), y:y, width: itemWidth, height: itemHeight)
                                    y += itemHeight + 20
                                    self?.productList.contentSize = CGSize(width: self!.screenWidth, height: CGFloat(y + 100))
                                }
                                productItem.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                                productItem.layer.shadowColor = UIColor.gray.cgColor
                                productItem.layer.shadowOffset = CGSize(width: 0, height: 1.0)
                                productItem.layer.shadowOpacity = 1
                                productItem.layer.shadowRadius = 1.0
                                productItem.clipsToBounds = true
                                productItem.layer.masksToBounds = false
                                productItem.layer.cornerRadius = 10
                                productItem.tag = id!
                                productItem.addTarget(self, action:#selector(self?.productButtonClicked), for: .touchUpInside)
                                self?.productList.insertSubview(productItem, at: index)
                                index += 1
                                self?.productList.isScrollEnabled = true
                                let icon = UIButton(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth))
                                icon.backgroundColor = UIColor.white
                                icon.layer.shadowColor = UIColor.gray.cgColor
                                icon.layer.shadowOffset = CGSize(width: 1.5, height: 1)
                                icon.layer.shadowOpacity = 1
                                icon.layer.shadowRadius = 1.0
                                icon.clipsToBounds = true
                                icon.layer.masksToBounds = false
                                icon.layer.cornerRadius = 10
                                icon.tag = id!
                                icon.addTarget(self, action:#selector(self?.productButtonClicked), for: .touchUpInside)
                                productItem.addSubview(icon)
                                let imageUrl = URL(string:"https://myoutlet.ge/Images/Product-images/" + String(uniqueNum!) + "/"  + image!)
                                let imageTask = URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
                                    guard let data = data, error == nil else { return }
                                    DispatchQueue.main.async() {
                                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth))
                                        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
                                        imageView.layer.cornerRadius = 20
                                        imageView.clipsToBounds = true
                                        imageView.image = UIImage(data: data)
                                        icon.addSubview(imageView)
                                    }
                                }
                                imageTask.resume()
                                let productName = UILabel(frame: CGRect(x: 5, y: itemWidth + 5, width: itemWidth - 10, height: itemWidth/2 - 10))
                                productName.text = name
                                productName.font = productName.font.withSize(13)
                                productName.lineBreakMode = NSLineBreakMode.byWordWrapping
                                productName.numberOfLines = 0
                                productName.textAlignment = NSTextAlignment.center
                                productItem.addSubview(productName)
                                let productCost = UILabel(frame: CGRect(x: 5, y: itemHeight*9/10, width: itemWidth - 10, height: itemHeight/10))
                                productCost.text = String(cost!) + " GEL"
                                productCost.textColor = UIColor.darkGray
                                productCost.font = UIFont.boldSystemFont(ofSize: 14.0)
                                productItem.addSubview(productCost)
                                if sale! > 0.0 {
                                    let productSale = UILabel(frame: CGRect(x: itemWidth*2/3 - 10, y: 0, width: itemWidth/3 + 10, height: itemHeight/10))
                                    productSale.text = "-" + String(sale!) + " %"
                                    productSale.textColor = UIColor.white
                                    productSale.backgroundColor = UIColor(red: 225/255, green: 130/255, blue: 32/255, alpha: 1.0)
                                    productSale.font = UIFont.boldSystemFont(ofSize: 12.0)
                                    productSale.layer.cornerRadius = 5
                                    productSale.layer.masksToBounds = true
                                    productSale.textAlignment = NSTextAlignment.center
                                    productItem.addSubview(productSale)
                                }
                            }
                        }
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            let btnBasket = UIButton(frame: CGRect(x: (self!.screenWidth - 100), y: (self!.screenHeight - 100), width: 60, height: 60))
            btnBasket.layer.backgroundColor = UIColor(red: 225/255, green: 130/255, blue: 32/255, alpha: 1.0).cgColor
            btnBasket.layer.cornerRadius = 20
            btnBasket.layer.masksToBounds = true
            btnBasket.setImage(UIImage(named: "basket_logo"), for: .normal)
            btnBasket.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
            btnBasket.addTarget(self, action:#selector(self?.basketBtnClicked), for: .touchUpInside)
            self?.view.addSubview(btnBasket)
            productTask.resume()
        }
        self.navigationItem.title = "პროდუქტები"
    }
    
    @objc func basketBtnClicked(sender: UIButton) {
        DispatchQueue.main.async {
            [weak self] in
            var basket = Array<classProduct>()
            if let blogData = UserDefaults.standard.data(forKey: "basket"),
                let productArr = try? JSONDecoder().decode([classProduct].self, from: blogData) {
                basket.append(contentsOf: productArr)
            }
            if basket.count > 0 {
                let vcBasket = VCBasket()
                self?.navigationController?.pushViewController(vcBasket, animated: true)
            }
            else{
                let alert = UIAlertController(title: "გაფრთხილება", message: "კალათა ცარიელია", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "კარგი", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc func productButtonClicked(sender: UIButton) {
        DispatchQueue.main.async {
            [weak self] in
            let vcProduct = VCProduct()
            vcProduct.productId = sender.tag
            self?.navigationController?.pushViewController(vcProduct, animated: true)
        }
    }
}
