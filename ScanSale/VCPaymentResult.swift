//
//  VCPaymentResult.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 5/15/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit

class VCPaymentResult: UIViewController {

    var url:String = ""
    var orderId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.white.cgColor
        
        let myURLString = "https://www.unipay.com/checkout?id=" + url
        if let myURL = NSURL(string: myURLString) {
          do {
            let myHTMLString = try NSString(contentsOf: myURL as URL, encoding: String.Encoding.utf8.rawValue)
                if (myHTMLString.contains("icon_confirmed")){
                    DispatchQueue.main.async {
                        let url = URL(string: "https://myoutlet.ge/api/successorder/get/" + self.orderId)!
                        let successOrderTask = URLSession.shared.dataTask(with: url) {(data,response,error) in guard let data = data else {return}
                            let res = String(data:data,encoding:.utf8)!
                            print(res)
                        }
                        successOrderTask.resume()
                    }
                    DispatchQueue.main.async {
                        var basket = Array<classProduct>()
                        if let blogData = UserDefaults.standard.data(forKey: "basket"),
                            let productArr = try? JSONDecoder().decode([classProduct].self, from: blogData) {
                            basket.append(contentsOf: productArr)
                        }
                        for product in basket {
                            let url = URL(string: "https://myoutlet.ge/api/decreaseproductcount?id=" + String(product.id) + "&count=" + String(product.count))!
                            let editPtCountTask = URLSession.shared.dataTask(with: url) {(data,response,error) in guard let data = data else {return}
                                let res = String(data:data,encoding:.utf8)!
                                print(res)
                            }
                            editPtCountTask.resume()
                        }
                    }
                    let basket = Array<classProduct>()
                    if let encoded = try? JSONEncoder().encode(basket) {
                        UserDefaults.standard.set(encoded, forKey: "basket")
                    }
                    let alert = UIAlertController(title: "გაფრთხილება", message: "გადახდა წარმატებით დასრულდა", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "კარგი", style: UIAlertAction.Style.default, handler: { (action) in
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "Main") as! ViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    self.present(alert, animated: true)
                }
                else{
                    let basket = Array<classProduct>()
                    if let encoded = try? JSONEncoder().encode(basket) {
                        UserDefaults.standard.set(encoded, forKey: "basket")
                    }
                    let alert = UIAlertController(title: "გაფრთხილება", message: "გადახდა ვერ მოხერხდა", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "კარგი", style: UIAlertAction.Style.default, handler: { (action) in
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "Main") as! ViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    self.present(alert, animated: true)
            }
          } catch {
            print(error)
          }
        }
    }
    
}
