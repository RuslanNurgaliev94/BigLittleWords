//
//  WordCell.swift
//  Big_LittleWords
//
//  Created by Руслан Нургалиев on 01.10.2022.
//

import UIKit

class WordCell: UITableViewCell {
    
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
