//
//  ViewController.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 4/24/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnQr: UIButton!
    @IBOutlet weak var btnCategories: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        navigationItem.backBarButtonItem = backBarBtnItem
        btnQr.addTarget(self, action:#selector(self.scanBtnClicked), for: .touchUpInside)
        btnCategories.addTarget(self, action:#selector(self.ctBtnClicked), for: .touchUpInside)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @objc func scanBtnClicked(sender: UIButton) {
        DispatchQueue.main.async {
            [weak self] in
            let vcScan = VCScan()
            self?.navigationController?.pushViewController(vcScan, animated: true)
        }
    }
    @objc func ctBtnClicked(sender: UIButton) {
        DispatchQueue.main.async {
            [weak self] in
            let vcCategories = VCCategories()
            self?.navigationController?.pushViewController(vcCategories, animated: true)
        }
    }
}

