import UIKit
import Firebase

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var logistic : UIView!
    @IBOutlet weak var drivers : UIView!
    @IBAction func switchTheView(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            logistic.alpha = 1
            drivers.alpha = 0
        } else if sender.selectedSegmentIndex == 1{
            logistic.alpha = 0
            drivers.alpha = 1
        }
    }

        
}

