import UIKit
import AVFoundation

class EndMViewController: UIViewController {

    var timer: Timer?
    @IBOutlet weak var endButton: UIButton!
    var isScreenBlack = false
    @IBOutlet weak var blackButton: UIBarButtonItem!
    
    var audioPlayer: AVAudioPlayer? // Declare AVAudioPlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 3 // Set the minimum press duration to 3 seconds
        self.view.addGestureRecognizer(longPressGesture)
        
        let buttonLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPress(_:)))
        endButton.addGestureRecognizer(buttonLongPressGesture)
        
        prepareBeepSound() // Prepare the beep sound
    }
    
    func prepareBeepSound() {
        if let soundURL = Bundle.main.url(forResource: "beep", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading beep sound: \(error)")
            }
        }
    }
    
    func playBeepSound() {
        audioPlayer?.play()
    }
    
    @IBAction func End(_ sender: Any) {
        // Do nothing here, the segue will be triggered from timerAction()
    }

    @objc func longPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // Start the timer when the long press begins
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            // Disable the button when the long press begins
            endButton.isEnabled = false
        } else if gestureRecognizer.state == .ended {
            // Invalidate the timer when the long press ends
            timer?.invalidate()
            // Enable the button when the long press ends
            endButton.isEnabled = true
        }
    }

    @objc func timerAction() {
        // Perform the action when the timer fires (after 3 seconds)
        print("Long press detected for 3 seconds")
        // Play the beep sound
        playBeepSound()
        // Perform segue to the next screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Change "Main" to your storyboard name
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "Monitor Me") // Change "Monitor Me" to your destination view controller's identifier
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    @objc func buttonLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // Perform navigation to another view controller when the button is long-pressed
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Change "Main" to your storyboard name
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "Monitor Me") // Change "Monitor Me" to your destination view controller's identifier
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    @IBAction func turnScreenBlack(_ sender: Any) {
        if isScreenBlack {
            // If the screen is already black, change it back to white
            self.view.backgroundColor = .white
            blackButton.tintColor = .black // Change the color of the button icon to black
        } else {
            // If the screen is not black, change it to black
            self.view.backgroundColor = .black
            blackButton.tintColor = .white // Change the color of the button icon to white
        }
        // Toggle the screen state flag
        isScreenBlack = !isScreenBlack
    }
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }
    @IBAction func nwindSegue(_ sender: UIStoryboardSegue){
        
    }
}
