import UIKit

class MonitorMeViewController: UIViewController {

    @IBOutlet weak var Gifview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Gifview.loadGif(name: "output-onlinegiftools")
    }
    
    @IBAction func ButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Enter Passkey", message: "Enter passkey to start monitoring", preferredStyle: .alert)

        // Add text field to the alert
        alert.addTextField { (textField) in
            textField.placeholder = "Passkey"
            textField.isSecureTextEntry = true // To hide the entered passkey
        }
        
        // Add Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            NSLog("Cancel action tapped.")
        }))
        
        // Add Confirm action
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0], let passkey = textField.text {
                NSLog("Confirm action tapped with passkey: \(passkey)")
                self.performSegue(withIdentifier: "Confirm", sender: nil)

                // Place your code here to handle confirmation with passkey
            }
        }))

        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
//    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
//       
    }

