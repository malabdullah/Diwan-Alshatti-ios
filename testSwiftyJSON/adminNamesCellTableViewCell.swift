import UIKit

class adminNamesCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name_value: UILabel!
    @IBOutlet weak var date_value: UILabel!
    @IBOutlet weak var comment_value: UILabel!
    @IBOutlet weak var id_value: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
