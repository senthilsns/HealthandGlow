//
//  ViewController.swift
//  HealthandGlow
//
//  Created by SENTHILKUMAR on 16/02/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var isLoading: Bool = false

    
    var arrayOfList : [DataModel] = []{
        // Reload data when data set
        didSet{
            
            DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        showProductList(pageCount: 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func showProductList(pageCount:Int) {
        
        if  NetworkManager.SharedInstance.isNetworkReachable() == false {
            
            AlertManager.SharedInstance.internetAlert()
            
        }else {
            
            let urlString :String = "http://35.194.142.124:8080/api/product/v1/search/176?app=desktop&version=1.0&tag=/makeup/lips/lipstick&page=0:\(pageCount)"
            
            guard let url = URL(string: urlString) else {return}
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                
                do{
                    
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: []) as! Dictionary<String,AnyObject>
                    
                    
                    let productDetail = jsonResponse["data"] as! Dictionary<String,Any>
                    let products = productDetail["products"] as! Array<[String : Any]>
                    
                    
                    for list in products {
                        
                        guard let promoText = list["sku_promo_text"] as? String else { return }
                        
                        guard let wishList = list["in_wishlist"] as? Bool else { return }
                        
                        guard let productImage = list["sku_image_url"] as? String else { return }
                        
                        guard let productName = list["sku_name"] as? String else { return }
                        
                        guard let finalPrice = list["sku_list_price"] as? Int else { return }
                        
                        guard let actualPrice = list["sku_list_price"] as? Int else { return }
                        
                        let detail = DataModel(promoText: promoText, wishlist: wishList, productImageUrl: productImage, productName: productName, finalPrice: finalPrice, actualPrice: actualPrice)
                        self.arrayOfList.append(detail)
                        
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            
            task.resume()
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        if contentOffsetX >= (scrollView.contentSize.width - scrollView.bounds.width) - 20 /* Needed offset */ {
            guard !self.isLoading else { return }
            self.isLoading = true
            // load more data
            // than set self.isLoading to false when new data is loaded
        }
    }

}



extension ViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrayOfList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 2
        
        let listObj = arrayOfList[indexPath.row]
        cell.productNameLabel.text = listObj.productName
        cell.offerLabel.text = listObj.promoText
        cell.productImageView.downloaded(from: listObj.productImageUrl!)
        
       // cell.actualPriceLabel.text = " \(listObj.actualPrice ?? 0) "
        cell.finalPriceLabel.text = "RS \(listObj.finalPrice ?? 0) "
        
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "RS \(listObj.actualPrice ?? 0) ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))

        cell.actualPriceLabel.attributedText = attributeString
        
        

        
 
        return cell
}

 

}



extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
