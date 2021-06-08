//
//  VCBasket.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 5/3/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit

class VCBasket: UIViewController {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var scrollView = UIScrollView()
    var lblTotal = UILabel()
    var btnGoToPay = UIButton()
    var total = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        navigationItem.backBarButtonItem = backBarBtnItem
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool){
        total = 0.0
        self.lblTotal.text = "სულ: 0.0 GEL"
        navigationItem.title = "კალათაში"
        view.layer.backgroundColor = UIColor.white.cgColor
        scrollView.frame = CGRect(x: 0, y: 200, width: self.screenWidth, height: (self.screenHeight - 160))
        view.addSubview(scrollView)
        lblTotal.frame = CGRect(x: 20, y: 100, width: (self.screenWidth*2/3), height: (self.screenWidth/6))
        lblTotal.font = UIFont.boldSystemFont(ofSize: 17.0)
        lblTotal.numberOfLines = 1
        view.addSubview(lblTotal)
        btnGoToPay.frame = CGRect(x: (self.screenWidth*2/3) - 20, y: 100, width: (self.screenWidth/3), height: (self.screenWidth/6))
        btnGoToPay.setImage(UIImage(named: "go_to_pay"), for: .normal)
        btnGoToPay.addTarget(self, action:#selector(self.btnGoToPayClicked), for: .touchUpInside)
        view.addSubview(btnGoToPay)
        DispatchQueue.main.async {
            [weak self] in
            for view in self!.scrollView.subviews {
                view.removeFromSuperview()
            }
            var basket = Array<classProduct>()
            if let blogData = UserDefaults.standard.data(forKey: "basket"),
                let productArr = try? JSONDecoder().decode([classProduct].self, from: blogData) {
                basket.append(contentsOf: productArr)
            }
            var y = 0
            for product in basket {
                let productView = UIView(frame: CGRect(x: 0, y: y, width: Int(self!.screenWidth), height: 200))
                productView.layer.backgroundColor = UIColor.white.cgColor
                productView.layer.shadowColor = UIColor.gray.cgColor
                productView.layer.shadowOffset = CGSize(width: 1, height: 1)
                productView.layer.shadowOpacity = 1
                productView.layer.shadowRadius = 1.0
                productView.clipsToBounds = true
                productView.layer.masksToBounds = false
                self?.scrollView.addSubview(productView)
                y += 202
                self?.scrollView.contentSize = CGSize(width: CGFloat(self!.screenWidth), height: CGFloat(y + 60))
                let icon = UIButton(frame: CGRect(x: (self!.screenWidth - 120)/2, y: 25, width: 120, height: 120))
                icon.backgroundColor = UIColor.white
                icon.layer.shadowColor = UIColor.gray.cgColor
                icon.layer.shadowOffset = CGSize(width: 1.5, height: 1)
                icon.layer.shadowOpacity = 1
                icon.layer.shadowRadius = 1.0
                icon.clipsToBounds = true
                icon.layer.masksToBounds = false
                icon.layer.cornerRadius = 10
                productView.addSubview(icon)
                let imageUrl = URL(string:"https://myoutlet.ge/Images/Product-images/" + String(product.unique) + "/"  + product.photo)
                let imageTask = URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
                        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
                        imageView.layer.cornerRadius = 20
                        imageView.clipsToBounds = true
                        imageView.image = UIImage(data: data)
                        icon.addSubview(imageView)
                    }
                }
                imageTask.resume()
                let productName = UILabel(frame: CGRect(x: 10, y: 150, width: (self!.screenWidth - 20), height: 20))
                productName.text = product.name
                productName.font = productName.font.withSize(15)
                productName.numberOfLines = 1
                productName.textAlignment = NSTextAlignment.center
                productView.addSubview(productName)
                let productCost = UILabel(frame: CGRect(x: 10, y: 180, width: (self!.screenWidth - 20), height: 20))
                let itemCost = Double(product.count)*round(10*product.cost)/10
                productCost.text = String(product.count) + " X " + String(product.cost) + " GEL = " + String(itemCost) + " GEL"
                productCost.font = UIFont.boldSystemFont(ofSize: 15.0)
                productCost.numberOfLines = 1
                productCost.textAlignment = NSTextAlignment.center
                productView.addSubview(productCost)
                let btnDecrease = UIButton(frame: CGRect(x: (self!.screenWidth)/2 - 120, y: 80, width: 30, height: 30))
                btnDecrease.backgroundColor = UIColor(red: 225/255, green: 130/255, blue: 32/255, alpha: 1.0)
                btnDecrease.setTitle("-", for: .normal)
                btnDecrease.setTitleColor(UIColor.white, for: .normal)
                btnDecrease.clipsToBounds = true
                btnDecrease.layer.masksToBounds = false
                btnDecrease.layer.cornerRadius = 10
                btnDecrease.tag = product.id
                btnDecrease.addTarget(self, action:#selector(self?.btnDecreaseClicked), for: .touchUpInside)
                productView.addSubview(btnDecrease)
                let btnIncrease = UIButton(frame: CGRect(x: (self!.screenWidth)/2 + 90, y: 80, width: 30, height: 30))
                btnIncrease.backgroundColor = UIColor(red: 225/255, green: 130/255, blue: 32/255, alpha: 1.0)
                btnIncrease.setTitle("+", for: .normal)
                btnIncrease.setTitleColor(UIColor.white, for: .normal)
                btnIncrease.clipsToBounds = true
                btnIncrease.layer.masksToBounds = false
                btnIncrease.layer.cornerRadius = 10
                productView.addSubview(btnIncrease)
                btnIncrease.tag = product.id
                btnIncrease.addTarget(self, action:#selector(self?.btnIncreaseClicked), for: .touchUpInside)
                let btnRemove = UIButton(frame: CGRect(x: self!.screenWidth - 50, y: 10, width: 30, height: 30))
                btnRemove.backgroundColor = UIColor.darkGray
                btnRemove.setTitle("X", for: .normal)
                btnRemove.setTitleColor(UIColor.white, for: .normal)
                btnRemove.clipsToBounds = true
                btnRemove.layer.masksToBounds = false
                btnRemove.layer.cornerRadius = 10
                productView.addSubview(btnRemove)
                btnRemove.tag = product.id
                btnRemove.addTarget(self, action:#selector(self?.btnRemoveClicked), for: .touchUpInside)
                self?.total += itemCost
                self?.lblTotal.text = "სულ: " + String(self!.total) + " GEL"
                if product.count < 2 {
                    btnDecrease.isEnabled = false
                }
                if product.count == product.baseCount {
                    btnIncrease.isEnabled = false
                }
            }
        }
    }
    
    @objc func btnIncreaseClicked(sender: UIButton){
        let offsetY = scrollView.contentOffset.y
        var basket = Array<classProduct>()
        if let blogData = UserDefaults.standard.data(forKey: "basket"),
            let productArr = try? JSONDecoder().decode([classProduct].self, from: blogData) {
            for product in productArr{
                if product.id == sender.tag{
                    if product.count < product.baseCount{
                        product.count += 1
                    }
                }
                basket.append(product)
            }
        }
        if let encoded = try? JSONEncoder().encode(basket) {
            UserDefaults.standard.set(encoded, forKey: "basket")
        }
        self.viewWillAppear(true)
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: offsetY),animated: false)
        }
    }

    @objc func btnDecreaseClicked(sender: UIButton){
        let offsetY = scrollView.contentOffset.y
        var basket = Array<classProduct>()
        if let blogData = UserDefaults.standard.data(forKey: "basket"),
            let productArr = try? JSONDecoder().decode([classProduct].self, from: blogData) {
            for product in productArr{
                if product.id == sender.tag{
                    if product.count > 1{
                        product.count -= 1
                    }
                }
                basket.append(product)
            }
        }
        if let encoded = try? JSONEncoder().encode(basket) {
            UserDefaults.standard.set(encoded, forKey: "basket")
        }
        self.viewWillAppear(true)
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: offsetY),animated: false)
        }
    }
    
    @objc func btnRemoveClicked(sender: UIButton){
        let offsetY = scrollView.contentOffset.y
        var basket = Array<classProduct>()
        if let blogData = UserDefaults.standard.data(forKey: "basket"),
            let productArr = try? JSONDecoder().decode([classProduct].self, from: blogData) {
            for product in productArr{
                if product.id == sender.tag{

                }
                else{
                    basket.append(product)
                }
            }
        }
        if let encoded = try? JSONEncoder().encode(basket) {
            UserDefaults.standard.set(encoded, forKey: "basket")
        }
        self.viewWillAppear(true)
        DispatchQueue.main.async {
            if basket.count > 3{
                self.scrollView.setContentOffset(CGPoint(x: 0, y: offsetY),animated: false)
            }
            else{
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 0),animated: false)
            }
        }
    }
    
    @objc func btnGoToPayClicked(sender: UIButton){
        var basket = Array<classProduct>()
        if let blogData = UserDefaults.standard.data(forKey: "basket"),
            let productArr = try? JSONDecoder().decode([classProduct].self, from: blogData) {
            basket.append(contentsOf: productArr)
        }
        if basket.count < 1 {
            let alert = UIAlertController(title: "გაფრთხილება", message: "კალათა ცარიელია", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "კარგი", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            DispatchQueue.main.async {
                [weak self] in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vcForm = storyBoard.instantiateViewController(withIdentifier: "Form") as! VCForm
                self?.navigationController?.pushViewController(vcForm, animated: true)
            }
        }
    }
}
