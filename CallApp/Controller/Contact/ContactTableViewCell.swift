//
//  ContactTableViewCell.swift
//  CallApp
//
//  Created by hau on 4/8/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarByNameLB: UILabel!
    @IBOutlet weak var fullnameLB: UILabel!
    @IBOutlet weak var emailLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func editTapped(_ sender: Any) {
        
    }
    var contact : User! {
        didSet {
            avatarByNameLB.firstLabelForName(name: contact.fullname)
            fullnameLB.text = contact.fullname
            emailLB.text = contact.email
        }
    }
}
extension UILabel {
    func firstLabelForName(name: String){
        let nameWords = name.components(separatedBy: " ")
        var firstCharacter = ""
        for word in nameWords {
            firstCharacter += String(word[word.startIndex])
        }
        self.text = firstCharacter
        self.backgroundColor = pickColor(alphabet: name[name.startIndex])
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    func pickColor(alphabet: Character) -> UIColor {
        let alphabetColors = [0x5A8770, 0xB2B7BB, 0x6FA9AB, 0xF5AF29, 0x0088B9, 0xF18636, 0xD93A37, 0xA6B12E, 0x5C9BBC, 0xF5888D, 0x9A89B5, 0x407887, 0x9A89B5, 0x5A8770, 0xD33F33, 0xA2B01F, 0xF0B126, 0x0087BF, 0xF18636, 0x0087BF, 0xB2B7BB, 0x72ACAE, 0x9C8AB4, 0x5A8770, 0xEEB424, 0x407887]
        let str = String(alphabet).unicodeScalars
        let unicode = Int(str[str.startIndex].value)
        if 65...90 ~= unicode {
            let hex = alphabetColors[unicode - 65]
            return UIColor(red: CGFloat(Double((hex >> 16) & 0xFF)) / 255.0, green: CGFloat(Double((hex >> 8) & 0xFF)) / 255.0, blue: CGFloat(Double((hex >> 0) & 0xFF)) / 255.0, alpha: 1.0)
        }
        return UIColor.black
    }
}
