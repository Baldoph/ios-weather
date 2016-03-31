//
//  ForecastCell.swift
//  weather
//
//  Created by Baldoph Pourprix on 30/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    private var allLabels: [UILabel] {
        return [maxTempLabel, minTempLabel, dayLabel]
    }
    
    var today: Bool = false {
        didSet {
            if oldValue == today {
                return
            }
            for label in allLabels {
                if today {
                    label.font = UIFont.boldSystemFontOfSize(label.font.pointSize)
                } else {
                    label.font = UIFont.systemFontOfSize(label.font.pointSize)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }
}
