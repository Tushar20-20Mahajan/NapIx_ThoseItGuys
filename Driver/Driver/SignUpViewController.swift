import UIKit
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {


    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func signup(_ sender: Any) {
        
            guard let email = emailTextField.text,
                  let password = passwordTextField.text else { return }
            
            // Get the selected role from the segmented control
            let role = roleSegmentedControl.selectedSegmentIndex == 0 ? "Driver" : "Logistics"

            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error creating user: \(error.localizedDescription)")
                    return
                }
                
                // Store additional user data including role in Firestore
                self.saveUserData(email: email, role: role)
            }
        }

        func saveUserData(email: String, role: String) {
            guard let currentUser = Auth.auth().currentUser else { return }
            
            let db = Firestore.firestore()
            db.collection("Users").document(currentUser.uid).setData([
                "email": email,
                "role": role,
                "name": "" // Add additional user data fields as needed
            ]) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                    return
                }
                
                // Navigate to the next screen
                self.performSegue(withIdentifier: "su", sender: self)
            }
        }
    }
    
    

