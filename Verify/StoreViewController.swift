//
//  StoreViewController.swift
//  Verify
//
//  Created by Razvan Julian on 27/09/17.
//
//

import UIKit
import GoogleMobileAds

class StoreViewController: UIViewController, GADBannerViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productDescription: UITextView!
    @IBOutlet var restoreButton: UIButton!
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet var returnButton: UIButton!
    @IBOutlet var storeImageView: UIImageView!
    
    
    
    var product: SKProduct?
    var productID = "Verify.adsRemovalService"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        productTitle.layer.cornerRadius = 10.0
        productDescription.layer.cornerRadius = 10.0
        restoreButton.layer.cornerRadius = 10.0
        purchaseButton.layer.cornerRadius = 10.0
        returnButton.layer.cornerRadius = 10.0
        
        purchaseButton.isEnabled = false
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
        
        
        bannerView.isHidden = true
        bannerView.delegate = self
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let save = UserDefaults.standard
        
        if save.value(forKey: "Verify.Purchase") == nil {
            
            
            bannerView.adUnitID = "ca-app-pub-8073575255978731/6048897362"
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
            self.storeImageView.image = UIImage(named: "shopping-cart-128px")
            
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            
        } else {
            
            bannerView.isHidden = true
            self.storeImageView.image = UIImage(named: "Image")
            
        }
        
        
    }
    
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        bannerView.isHidden = true
        
        
    }
    
    
    
    
    @IBAction func restoreAction(_ sender: AnyObject) {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        
    }
    @IBAction func purchaseAction(_ sender: AnyObject) {
        
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
        
        
    }
    @IBAction func returnAction(_ sender: AnyObject) {
        
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func getPurchaseInfo() {
        
        if SKPaymentQueue.canMakePayments(){
            
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: self.productID) as! Set<String>)
            
            request.delegate = self
            request.start()
            
        } else {
            
            productTitle.text = "Warning"
            productDescription.text = "Please enable in - app purchases in your Settings"
            self.storeImageView.image = UIImage(named: "warning")
            
            
        }
        
    }
    
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        var products = response.products
        
        if products.count == 0 {
            
            productTitle.text = "Warning"
            productDescription.text = "Service Not Found"
            self.storeImageView.image = UIImage(named: "warning")


            
        } else {
            
            
            product = products[0]
            productTitle.text = product?.localizedTitle
            productDescription.text = product?.localizedDescription
            purchaseButton.isEnabled = true
            
        }
        
        let invalids = response.invalidProductIdentifiers
        
        for product in invalids {
            
            print("Service not found: \(product)")
            self.storeImageView.image = UIImage(named: "warning")

            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                productTitle.text = "Thank you!"
                productDescription.text = "The service has been purchased."
                self.storeImageView.image = UIImage(named: "Image")
                purchaseButton.isEnabled = false
                
                let save = UserDefaults.standard
                save.set(true, forKey: "Verify.Purchase")
                save.synchronize()
                
                
            case SKPaymentTransactionState.restored:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                productTitle.text = "Thank you!"
                productDescription.text = "The service has been restored."
                self.storeImageView.image = UIImage(named: "Image")
                purchaseButton.isEnabled = false
                
                let save = UserDefaults.standard
                save.set(true, forKey: "Verify.Purchase")
                save.synchronize()
                
                
            case SKPaymentTransactionState.failed:
                productTitle.text = "Warning!"
                productDescription.text = "The service hasn't been purchased."
                self.storeImageView.image = UIImage(named: "warning")

                
            default:
                break
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
