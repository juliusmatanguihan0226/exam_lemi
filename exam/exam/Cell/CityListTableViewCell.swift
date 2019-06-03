//
//  CityListTableViewCell.swift
//  exam
//
//  Created by Julius Matanguihan on 02/06/2019.
//  Copyright © 2019 julius. All rights reserved.
//

import UIKit



class CityListTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblShortname: UILabel!
    @IBOutlet weak var imgviewBanner: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewContainer.layer.cornerRadius = self.viewContainer.frame.size.width/2
        self.viewContainer.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(cityArray : [String:Any]){
        let strName = cityArray["name"] as? String
        let strSubtitle = cityArray["subtitle"] as? String
        let strbanner = cityArray["banner"] as? String
        let sColor = cityArray["color"] as? String
        let color = hexStringToUIColor(hex:sColor!)
        self.lblName?.text = strName
        self.lblSubtitle?.text = strSubtitle
        self.viewContainer.backgroundColor = color;
        self.lblShortname?.text = String((strName?.prefix(3))!)
        self.imgviewBanner.isHidden = true
        if (strbanner != nil) {
            let url = URL(string: strbanner!)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.imgviewBanner.image = image
                self.imgviewBanner.isHidden = false
            }
        }
    }

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
