//
//  WeatherInfoView.swift
//  weather
//
//  Created by Baldoph Pourprix on 30/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit

class WeatherInfoView: UIView {
    
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var valueLabels: [UILabel]!
    
    func titleLabelAtIndex(index: Int) -> UILabel {
        return titleLabels.filter { $0.tag == index }[0]
    }
    
    func valueLabelAtIndex(index: Int) -> UILabel {
        return valueLabels.filter { $0.tag == index }[0]
    }
    
    func clearAllValues() {
        for lbl in valueLabels {
            lbl.text = nil
        }
    }
}
