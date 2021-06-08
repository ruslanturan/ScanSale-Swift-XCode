//
//  VCForm.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 5/12/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit

class VCForm: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblMail: UILabel!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnPay: UIButton!
    
    var vcPay = VCPay()
    var orderId = ""
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardShowNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        navigationItem.backBarButtonItem = backBarBtnItem
        view.layer.backgroundColor = UIColor.white.cgColor
        lblName.frame = CGRect(x: 20, y: 20, width: screenWidth - 40, height: 40)
        txtName.frame = CGRect(x: 20, y: 60, width: screenWidth - 40, height: 40)
        lblMail.frame = CGRect(x: 20, y: 120, width: screenWidth - 40, height: 40)
        txtMail.frame = CGRect(x: 20, y: 160, width: screenWidth - 40, height: 40)
        lblNumber.frame = CGRect(x: 20, y: 220, width: screenWidth - 40, height: 40)
        txtNumber.frame = CGRect(x: 20, y: 260, width: screenWidth - 40, height: 40)
        lblCity.frame = CGRect(x: 20, y: 320, width: screenWidth - 40, height: 40)
        txtCity.frame = CGRect(x: 20, y: 360, width: screenWidth - 40, height: 40)
        lblAddress.frame = CGRect(x: 20, y: 420, width: screenWidth - 40, height: 40)
        txtAddress.frame = CGRect(x: 20, y: 460, width: screenWidth - 40, height: 40)
        btnPay.frame = CGRect(x: (screenWidth - 200)/2, y: 520, width: 200, height: 45)
        DispatchQueue.main.async {
            [weak self] in
            self?.scrollView.frame = CGRect(x: 0, y: 0, width: self!.screenWidth, height: self!.screenHeight)
            self?.scrollView.isScrollEnabled = true
            self?.scrollView.contentSize = CGSize(width: self!.screenWidth, height: 600.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnPayClicked(_ sender: Any) {
        DispatchQueue.main.async {
            [weak self] in
            if self!.txtName.text!.count < 2 {
                let alert = UIAlertController(title: "გაფრთხილება", message: "გთხოვთ, შეავსოთ სახელის ნაწილი", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "კარგი", style: .default, handler: nil))
                self?.present(alert, animated: true)
                return
            }
            if !(self!.txtMail.text!.contains("@")) || (self!.txtMail.text!.contains(" ")) || !(self!.txtMail.text!.contains(".")) || self!.txtMail.text!.count < 5 {
                let alert = UIAlertController(title: "გაფრთხილება", message: "გთხოვთ, შეავსოთ ელექტრონული ფოსტის ნაწილი", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "კარგი", style: .default, handler: nil))
                self?.present(alert, animated: true)
                return
            }
            if !(self!.txtNumber.text!.starts(with: "5")) || self!.txtNumber.text!.count != 9 {
                let alert = UIAlertController(title: "გაფრთხილება", message: "გთხოვთ, შეავსოთ ნომრის ნაწილი", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "კარგი", style: .default, handler: nil))
                self?.present(alert, animated: true)
                return
            }
            if self!.txtAddress.text!.count < 2 {
                let alert = UIAlertController(title: "გაფრთხილება", message: "გთხოვთ, შეავსოთ მისამართის ნაწილი", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "კარგი", style: .default, handler: nil))
                self?.present(alert, animated: true)
                return
            }
            var price = 0
            var desc = ""
            if let blogData = UserDefaults.standard.data(forKey: "basket"),
                let productArr = try? JSONDecoder().decode([classProduct].self, from: blogData) {
                for product in productArr{
                    let cost = Double(product.count) * product.cost
                    desc += " / " + product.name + " - " + String(product.count) + " X " + String(product.cost) + " GEL = " + String((round(10*cost))/10) + " GEL"
                    price += Int(Double(100)*cost)
                }
            }
            let urlString = "https://myoutlet.ge/api/createorder/get?fullname=" + self!.txtName.text! + "&email=" + self!.txtMail.text! + "&phone=" + self!.txtNumber.text! + "&town=0&address=" + self!.txtAddress.text! + "&price=" + String(price) + "&desc=" + desc
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            let orderTask = URLSession.shared.dataTask(with: url) {(data,response,error) in guard let data = data else {return}
                DispatchQueue.main.async {
                    self!.orderId = String(data:data,encoding:.utf8)!
                    self!.vcPay.orderId = self!.orderId
                    self?.navigationController?.pushViewController(self!.vcPay, animated: true)
                }
            }
            orderTask.resume()
        }
    }
    @objc
    private func handle(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            DispatchQueue.main.async {
                [weak self] in
                self?.scrollView.contentSize = CGSize(width: self!.screenWidth, height: 600.0 + keyboardRectangle.height)
            }
        }
    }
}
