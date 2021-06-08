//
//  VCScan.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 4/30/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit

class VCScan: UIViewController {

    var imgScan = UIImageView()
    var btnScan = UIButton()
    var screenWidth = UIScreen.main.bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        navigationItem.backBarButtonItem = backBarBtnItem
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            self?.navigationController?.isNavigationBarHidden = false
            self?.view.backgroundColor = UIColor.white
            self?.imgScan.frame = CGRect(x: (self!.screenWidth - self!.screenWidth*7/10)/2, y: 100, width: (self!.screenWidth*7/10), height: (self!.screenWidth*7/10))
            self?.imgScan.image = UIImage(named: "scan_rect")
            self?.btnScan.frame = CGRect(x: (self!.screenWidth - self!.screenWidth*4/5)/2, y: 100 + self!.screenWidth, width: (self!.screenWidth*4/5), height: (self!.screenWidth*1/5))
            self?.btnScan.setImage(UIImage(named: "btn_start_scan"), for: .normal)
            self?.view.addSubview(self!.imgScan)
            self?.btnScan.addTarget(self, action:#selector(self?.scanButtonClicked), for: .touchUpInside)
            self?.view.addSubview(self!.btnScan)
        }
    }
    @objc func scanButtonClicked(sender: UIButton) {
        DispatchQueue.main.async {
            [weak self] in
            let vcScanner = VCScanner()
            self?.navigationController?.pushViewController(vcScanner, animated: true)
        }
    }
}
