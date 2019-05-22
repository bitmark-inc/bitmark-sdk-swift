//
//  RegistrationViewController.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/15.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import UIKit
import BitmarkSDK

class RegistrationViewController: UIViewController {
    private let FILE_NAME = "example.txt"
    private var bitmarkIds: [String] = []
    
    @IBOutlet var lblFileContent: UILabel!
    @IBOutlet var lblFilePath: UILabel!
    @IBOutlet var tfAssetId: UITextField!
    @IBOutlet var tfQuantity: UITextField!
    @IBOutlet var tblViewBitmarks: UITableView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewBitmarks.dataSource = self
        tblViewBitmarks.delegate = self
        
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func generateRandomFileHandler(_ sender: Any) {
        let randomText = CommonUtil.randomAlphaNumeric(count: 10)
        
        do {
            let filePath = try CommonUtil.writeFile(text: randomText, fileName: FILE_NAME)
            lblFileContent.text = randomText
            lblFilePath.text = filePath
        } catch let e {
            print(e.localizedDescription)
            Toast.show(message: "Can not generate random file", controller: self)
        }
    }
    
    @IBAction func registerAssetHandler(_ sender: Any) {
        if (!Global.needToHaveCurrentAccount(self)) {return}
        
        if (lblFilePath.text ?? "").isEmpty {
            Toast.show(message: "Please generate file first", controller: self)
            return
        }
        
        let assetName = "YOUR_ASSET_NAME"; // Asset length must be less than or equal 64 characters
        let assetFilePath = lblFilePath.text!;
        let metadata = ["key1": "value1", "key2": "value2"] // Metadata length must be less than or equal 2048 characters
        
        
        var success = true
        activityIndicator.startAnimating();
        Tasker.runOnBackground {
            var assetId = ""
            do {
                assetId = try AssetRegistrationSample.registerAsset(registrant: Global.currentAccount!, assetName: assetName, assetFilePath: assetFilePath, metadata: metadata)
            } catch let e {
                print(e.localizedDescription)
                success = false
            }
            
            Tasker.runOnMain {
                self.activityIndicator.stopAnimating();
                
                if success {
                    self.tfAssetId.text = assetId;
                } else {
                    Toast.show(message: "Can not register asset", controller: self)
                }
            }
        }
    }
    
    @IBAction func issueBitmarksHandler(_ sender: Any) {
        if (!Global.needToHaveCurrentAccount(self)) {return}
        
        let assetId = tfAssetId.text ?? ""
        let quantity = tfQuantity.text ?? ""
        
        if assetId.isEmpty {
            Toast.show(message: "Please register asset first", controller: self)
            return
        }
        
        if quantity.isEmpty {
            Toast.show(message: "Please input quantity", controller: self)
            return
        }
        
        var success = true
        activityIndicator.startAnimating();
        Tasker.runOnBackground {
            do {
                self.bitmarkIds = try BitmarkIssuanceSample.issueBitmarks(issuer: Global.currentAccount!, assetId: assetId, quantity: Int(quantity)!)
            } catch let e {
                print(e.localizedDescription)
                success = false
            }
            
            Tasker.runOnMain {
                self.activityIndicator.stopAnimating();
                if success == true {
                    self.tblViewBitmarks.reloadData()
                } else {
                    Toast.show(message: "Can not register asset", controller: self)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension RegistrationViewController: UITableViewDataSource {
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
extension RegistrationViewController: UITableViewDelegate {
}

