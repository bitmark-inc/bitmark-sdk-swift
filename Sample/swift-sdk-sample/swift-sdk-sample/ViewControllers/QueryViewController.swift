//
//  QueryViewController.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/17.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import UIKit
import BitmarkSDK

class QueryViewController: UIViewController {
    private var bitmarkIds: [String] = []
    
    @IBOutlet var tfAccountNumber: UITextField!
    @IBOutlet var swIsPending: UISwitch!
    @IBOutlet var tblViewBitmarks: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewBitmarks.dataSource = self
        tblViewBitmarks.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        
        if Global.currentAccount != nil {
            tfAccountNumber.text = Global.currentAccount?.getAccountNumber()
        }
    }
    
    @IBAction func queryBitmarksHandler(_ sender: Any) {
        let accountNumber = tfAccountNumber.text ?? ""
        
        if accountNumber.isEmpty {
            Toast.show(message: "Please input Account Number", controller: self)
            return
        }
        
        let isPending = swIsPending.isOn
        
        var success = true
        activityIndicator.startAnimating();
        Tasker.runOnBackground {
            do {
                let queryParams = Bitmark.newBitmarkQueryParams()
                    .ownedBy(accountNumber)
                    .pending(isPending)
                    .loadAsset(false)
                
                let (bitmarks, _) = try QuerySample.queryBitmarks(params: queryParams)
                
                self.bitmarkIds = [];
                bitmarks?.forEach { bitmark in
                    self.bitmarkIds.append(bitmark.id)
                }
            } catch let e {
                print(e.localizedDescription)
                success = false
            }
            
            Tasker.runOnMain {
                self.activityIndicator.stopAnimating();
                if success == true {
                    self.tblViewBitmarks.reloadData()
                } else {
                    Toast.show(message: "Can not query Bitmarks", controller: self)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension QueryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bitmarkIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bitmarkCell", for: indexPath)
        cell.textLabel?.text = bitmarkIds[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bitmarkId = bitmarkIds[indexPath.item]
        CommonUtil.setClipboard(text: bitmarkId)
        Toast.show(message: "Copied!", controller: self)
    }
}

// MARK: - UITableViewDelegate
extension QueryViewController: UITableViewDelegate {
}
