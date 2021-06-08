//
//  VCProduct.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 4/28/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit

class VCProduct: UIViewController {
    var productId:Int = 0
    var desc:String = ""
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var slider = UIScrollView()
    var body = UIScrollView()
    var lblAdd = UILabel()
    var btnAdd = UIButton()
    var product = classProduct(id: 0,name: "",cost: 0.0,unique: 0,baseCount: 0, count: 1, photo: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        navigationItem.backBarButtonItem = backBarBtnItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            self?.navigationItem.title = ""
            for view in self!.slider.subviews {
                view.removeFromSuperview()
            }
            for view in self!.body.subviews {
                view.removeFromSuperview()
            }
            self?.slider.layer.backgroundColor = UIColor.white.cgColor
            self?.body.layer.backgroundColor = UIColor.white.cgColor
            self?.slider.frame = CGRect(x: 0, y: 100, width: self!.screenWidth, height: 200)
            self?.body.frame = CGRect(x: 0, y: 310, width: self!.screenWidth, height: self!.screenHeight - 310)
            self?.view.layer.backgroundColor = UIColor.white.cgColor
            self?.view.addSubview(self!.slider)
            self?.view.addSubview(self!.body)
            self?.slider.layer.shadowColor = UIColor.gray.cgColor
            self?.slider.layer.shadowOffset = CGSize(width: 1.5, height: 1)
            self?.slider.layer.shadowOpacity = 1
            self?.slider.layer.shadowRadius = 1.0
            self?.slider.clipsToBounds = true
            self?.slider.layer.masksToBounds = false
            self?.slider.layer.cornerRadius = 10
            let url = URL(string: "https://myoutlet.ge/api/product/get/" + String(self!.productId))!
            let productTask = URLSession.shared.dataTask(with: url) {(data,response,error) in guard let data = data else {return}
                do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                            for product in jsonArray{
                                DispatchQueue.main.async {
                                    let id = product["id"] as? Int
                                    self?.product.id = id!
                                    let uniqueNum = product["uniqueNum"] as? Int
                                    self?.product.unique = uniqueNum!
                                    let baseCount = product["count"] as? Int
                                    self?.product.baseCount = baseCount!
                                    let name = product["productName"] as? String
                                    self?.product.name = name!
                                    let cost = product["saledCost"] as? Double
                                    self?.product.cost = cost!
                                    let images = product["galleries"] as? Array<String>
                                    let description = product["descriptions"] as? Array<String>
                                    var x = 0
                                    for image in images! {
                                        if x == 0 {
                                            self?.product.photo = image
                                        }
                                        let imageUrl = URL(string:"https://myoutlet.ge/Images/Product-images/" + String(uniqueNum!) + "/"  + image)
                                        let imageTask = URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
                                            guard let data = data, error == nil else { return }
                                            DispatchQueue.main.async() {
                                                let icon = UIButton(frame: CGRect(x: x, y: 0, width: Int(self!.screenWidth), height: 200))
                                                icon.backgroundColor = UIColor.white
                                                icon.layer.cornerRadius = 10
                                                icon.tag = id!
                                                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(self!.screenWidth), height: 200))
                                                imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
                                                imageView.layer.cornerRadius = 10
                                                imageView.clipsToBounds = true
                                                imageView.image = UIImage(data: data)
                                                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self?.imageOnClick(tapGestureRecognizer:)))
                                                imageView.isUserInteractionEnabled = true
                                                imageView.addGestureRecognizer(tapGestureRecognizer)
                                                icon.addSubview(imageView)
                                                x += Int(self!.screenWidth)
                                                self?.slider.addSubview(icon)
                                                self?.slider.contentSize = CGSize(width: CGFloat(x), height: 200)
                                            }
                                        }
                                        imageTask.resume()
                                    }
                                    let imageCount = UILabel(frame: CGRect(x: 0, y: 0, width: self!.screenWidth, height: 20))
                                    imageCount.font = UIFont.boldSystemFont(ofSize: 13.0)
                                    imageCount.textColor = UIColor.darkGray
                                    imageCount.textAlignment = NSTextAlignment.center
                                    self?.body.addSubview(imageCount)
                                    imageCount.text = String(images!.count) + " ფოტო"
                                    let productCost = UILabel(frame: CGRect(x: 10, y: 40, width: Int(self!.screenWidth*3/8 - 10), height: Int(self!.screenWidth*5/32)))
                                    productCost.font = UIFont.boldSystemFont(ofSize: 18.0)
                                    productCost.textColor = UIColor(red: 225/255, green: 130/255, blue: 32/255, alpha: 1.0)
                                    self?.body.addSubview(productCost)
                                    productCost.text = String(cost!) + " GEL"
                                    self?.lblAdd = UILabel(frame: CGRect(x: Int(self!.screenWidth*3/8), y: 40, width: Int(self!.screenWidth*5/8 - 10), height: Int(self!.screenWidth*5/32)))
                                    self?.lblAdd.textColor = UIColor(red: 225/255, green: 130/255, blue: 32/255, alpha: 1.0)
                                    self?.lblAdd.font = UIFont.boldSystemFont(ofSize: 18.0)
                                    self?.lblAdd.text = "ნივთი კალათაშია"
                                    self?.lblAdd.textAlignment = .center
                                    self?.body.addSubview(self!.lblAdd)
                                    self?.btnAdd = UIButton(frame: CGRect(x: Int(self!.screenWidth*3/8), y: 40, width: Int(self!.screenWidth*5/8 - 10), height: Int(self!.screenWidth*5/32)))
                                    self?.btnAdd.tag = id!
                                    self?.btnAdd.addTarget(self, action:#selector(self?.addToBasket), for: .touchUpInside)
                                    self?.btnAdd.setImage(UIImage(named: "btn_add_to_basket"), for: .normal)
                                    self?.body.addSubview(self!.btnAdd)
                                    let productName = UILabel(frame: CGRect(x: 0, y: 40 + Int(self!.screenWidth*5/32) , width: Int(self!.screenWidth), height: 60))
                                    productName.numberOfLines = 0
                                    productName.textAlignment = NSTextAlignment.center
                                    productName.font = UIFont.boldSystemFont(ofSize: 18.0)
                                    productName.textColor = UIColor.black
                                    productName.text = String(name!)
                                    self?.body.addSubview(productName)
                                    let data = Data(description!.joined(separator:"").utf8)
                                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
                                        self?.desc = attributedString.string
                                    }
                                    let font = UIFont.systemFont(ofSize: 18.0)
                                    let height = self?.heightForView(text:self!.desc, font: font, width: self!.screenWidth)
                                    let productDesc = UILabel(frame: CGRect(x: 20, y: 100 + self!.screenWidth*5/32 , width: self!.screenWidth - 40, height: height!))
                                    productDesc.textAlignment = NSTextAlignment.center
                                    productDesc.textColor = UIColor.black
                                    productDesc.text = self?.desc
                                    productDesc.lineBreakMode = NSLineBreakMode.byWordWrapping
                                    productDesc.numberOfLines = 0
                                    self?.body.addSubview(productDesc)
                                    self?.btnAdd.alpha = 1
                                    self?.lblAdd.alpha = 0
                                    let contentHeight = 100 + self!.screenWidth*5/32 + height!
                                    self?.body.contentSize = CGSize(width: self!.screenWidth, height: contentHeight)
                                    if let blogData = UserDefaults.standard.data(forKey: "basket"),
                                        let basket = try? JSONDecoder().decode([classProduct].self, from: blogData) {
                                        for product in basket{
                                            if product.id == id{
                                                self?.btnAdd.alpha = 0
                                                self?.lblAdd.alpha = 1
                                            }
                                        }
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
            productTask.resume()
        }
    }
    
    @objc func imageOnClick(tapGestureRecognizer: UITapGestureRecognizer){
        DispatchQueue.main.async {
            [weak self] in
            let imageView = tapGestureRecognizer.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            newImageView.frame = self!.view.frame
            newImageView.backgroundColor = .white
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self?.dismissFullscreenImage(sender:)))
            newImageView.addGestureRecognizer(tap)
            self?.view.addSubview(newImageView)
            self?.navigationItem.hidesBackButton = true
        }
    }
    
    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            [weak self] in
            sender.view?.removeFromSuperview()
            self?.navigationItem.hidesBackButton = false
        }
    }
    
    @objc func addToBasket(sender: UIButton) {
        DispatchQueue.main.async {
            [weak self] in
            var basket = Array<classProduct>()
            if let blogData = UserDefaults.standard.data(forKey: "basket"),
                let productArr = try? JSONDecoder().decode([classProduct].self, from: blogData) {
                basket.append(contentsOf: productArr)
            }
            basket.append(self!.product)
            if let encoded = try? JSONEncoder().encode(basket) {
                UserDefaults.standard.set(encoded, forKey: "basket")
            }
            self?.btnAdd.alpha = 0
            self?.lblAdd.alpha = 1
        }
    }
    
     func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
