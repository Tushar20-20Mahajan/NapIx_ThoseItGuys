//
//  BlackViewController.swift
//  Napix
//
//  Created by student on 10/05/24.
//

import UIKit

class BlackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func blackButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "camera") as? UIViewController {
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }

}
