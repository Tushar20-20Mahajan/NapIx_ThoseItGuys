import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

        
    @IBAction func login(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            
            // User signed in successfully, navigate to the next screen
        self.performSegue(withIdentifier: "si", sender: self)
        }
    }
}

