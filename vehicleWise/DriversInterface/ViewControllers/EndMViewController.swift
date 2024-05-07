import UIKit
import AVFoundation
import CoreML

class EndMViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var timer: Timer?
    @IBOutlet weak var endButton: UIButton!
    var isScreenBlack = false
    @IBOutlet weak var blackButton: UIBarButtonItem!
    
    var audioPlayer: AVAudioPlayer? // Declare AVAudioPlayer
    
    var ddModel: DDModel!
    var fdModel: FDModel!
    var captureSession: AVCaptureSession?
    var isDrowsy: Bool = false
    var frameCount: Int = 0
    var drowsinessStartTime: Date?
    let drowsinessThreshold: TimeInterval = 4.0 // Duration for drowsiness to trigger an alert
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 3 // Set the minimum press duration to 3 seconds
        self.view.addGestureRecognizer(longPressGesture)
        
        let buttonLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPress(_:)))
        endButton.addGestureRecognizer(buttonLongPressGesture)
        
        prepareBeepSound() // Prepare the beep sound
        setupDrowsinessDetection()
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
        // Stop the timer if it's running
        timer?.invalidate()
        // Enable the endButton
        endButton.isEnabled = true
        
        // Stop the AVCaptureSession
        captureSession?.stopRunning()
        // Remove the sample buffer delegate
        captureSession?.outputs.forEach { output in
            captureSession?.removeOutput(output)
        }
        
        // Perform segue to the next screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Change "Main" to your storyboard name
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "Monitor Me") // Change "Monitor Me" to your destination view controller's identifier
        self.navigationController?.pushViewController(destinationViewController, animated: true)
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
    
    func setupDrowsinessDetection() {
        do{
            fdModel = try FDModel(configuration: MLModelConfiguration())
            do {
                ddModel = try DDModel(configuration: MLModelConfiguration())
            } catch {
                print("Error initializing DD Model \(error)")
            }
        } catch{
            print("Error initializing FD Model \(error)")
        }
        
        // Setup camera session for drowsiness detection
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else {
            print("Failed to create AVCaptureSession")
            return
        }
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get the front camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.addInput(input)
        } catch {
            print("Error configuring camera input: \(error)")
            return
        }
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(output)
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Process every 3rd frame
        frameCount += 1
        guard frameCount % 3 == 0 else { return }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        do {
            
            let input1 = FDModelInput(image: pixelBuffer)
            let prediction1 = try fdModel.prediction(input: input1)
            let outputString1 = prediction1.target
            
            print("Output String is: \(outputString1)")
            
            if outputString1 == "face detected"{
                do {
                    let input = DDModelInput(image: pixelBuffer)
                    let prediction = try ddModel.prediction(input: input)
                    let outputString = prediction.target
                    
                    // Handle the prediction results as needed
                    print("Output String: \(outputString)")
                    if outputString == "Fatigue" {
                        if isDrowsy {
                            // Drowsiness detected
                            if let startTime = drowsinessStartTime {
                                let elapsedTime = Date().timeIntervalSince(startTime)
                                if elapsedTime >= drowsinessThreshold {
                                    // Drowsiness persisted for the threshold duration, trigger alert
                                    DispatchQueue.main.async { [weak self] in
                                        self?.playBeepSound()
                                        // Trigger an alert or take appropriate action here
                                    }
                                }
                            } else {
                                // Start tracking drowsiness
                                drowsinessStartTime = Date()
                            }
                        } else {
                            // Start tracking drowsiness
                            isDrowsy = true
                            drowsinessStartTime = Date()
                        }
                    } else {
                        // Reset drowsiness tracking
                        isDrowsy = false
                        drowsinessStartTime = nil
                    }
                } catch {
                    print("Error making drowsiness prediction: \(error)")
                }
            } else {
                print("No face to detect drowsiness")
            }
           
        } catch{
            print("Error making face prediction \(error)")
        }
    }
}
