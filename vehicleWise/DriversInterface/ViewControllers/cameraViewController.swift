import UIKit
import AVFoundation
import CoreML
import Vision

@available(iOS 17.0, *)
class cameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // Timer to track drowsiness
    var timer: Timer?
    // Flag to track if the screen is black
    var isScreenBlack = false
    // Audio player for beep sound
    var audioPlayer: AVAudioPlayer?
    // Image view to display monitoring GIF

    @IBOutlet weak var MoniterMeGif: UIImageView!
    // CoreML models for face and drowsiness detection
    var ddModel: DDModel!
    var fdModel: FDModel!
    // Capture session for camera
    var captureSession: AVCaptureSession?
    // Flag to track drowsiness

    var isDrowsy: Bool = false
    // Timestamp for drowsiness start

    var drowsinessStartTime: Date?
    // Timestamp for last alert
    var lastAlertTime: Date?
    let drowsinessAlertThreshold: TimeInterval = 3 // Threshold for drowsiness alert (3 seconds)
    var alertArray : [String] = []
    // Flag to track if face is visible

    var faceVisible = false
    // Image view to display emoji
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var gifview: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var turnOffCamView: UIBarButtonItem!
    
    @IBOutlet weak var emojiPic: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Bring GIF view to front

        view.bringSubviewToFront(gifview)
        // Load monitoring GIF
        gifview.loadGif(name: "giphy")
        MoniterMeGif.loadGif(name: "MonitorActivity")
        // Hide monitoring GIF
        MoniterMeGif.isHidden = true
        // Prepare beep sound
        prepareBeepSound()
        // Setup drowsiness detection
        setupDrowsinessDetection()
        // Configure camera
        configureCamera()
        // Hide emoji initially
        emojiPic.isHidden = true
        // Set emoji image
        emojiPic.image = UIImage(named: "Green")
        // Add long-press gesture recognizer to the endButton
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(endButtonLongPressed(_:)))
        endButton.addGestureRecognizer(longPressRecognizer)
    }

    // Handle long-press gesture on endButton
    @objc func endButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            // Long press detected, perform end action
            end(sender)
        }
    }
    // Prepare beep sound
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
    // Play beep sound

    func playBeepSound() {
        audioPlayer?.play()
    }
    // Play face detection sound
    func playFaceSound() {
        if let soundURL = Bundle.main.url(forResource: "face", withExtension: "mp3") {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print("Error playing face sound: \(error)")
            }
        }
    }
    // Configure camera
    func configureCamera() {
        guard let captureSession = captureSession else {
            print("Capture session is nil")
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

        // Configure preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = cameraView.bounds
        cameraView.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    // Setup drowsiness detection
    func setupDrowsinessDetection() {
        do {
            if #available(iOS 17.0, *) {
                fdModel = try FDModel(configuration: MLModelConfiguration())
             
            } else {
                // Fallback on earlier versions
            }
            do {
                if #available(iOS 17.0, *) {
                    ddModel = try DDModel(configuration: MLModelConfiguration())
                } else {
                    // Fallback on earlier versions
                }
            } catch {
                print("Error initializing DD Model \(error)")
            }
        } catch {
            print("Error initializing FD Model \(error)")
        }

        captureSession = AVCaptureSession()
    }
    // Define a date formatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Use 'h' for 12-hour clock, 'a' for AM/PM designator
        formatter.locale = Locale(identifier: "en_US") // Set locale to a region that uses AM/PM time notation
        return formatter
    }()
    
    // Function to log messages with IST timestampIs
        func logWithISTDate(_ message: String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(identifier: "Asia/Kolkata") // Set timezone to IST

            let dateString = formatter.string(from: Date())
            print("\(dateString): \(message)")
        }


    // AVCaptureVideoDataOutputSampleBufferDelegate method
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        DispatchQueue.main.async {
            do {
                let input1 = FDModelInput(image: pixelBuffer)
                let prediction1 = try self.fdModel.prediction(input: input1)
                let outputString1 = prediction1.target

                self.logWithISTDate("Output String is: \(outputString1)")

                if outputString1 == "face detected" {
                    // If the face was not detected previously, append the detection output
                    
                    self.emojiPic.image = UIImage(named: "Green")
                    if self.gifview.isHidden == false && self.cameraView.isHidden == false {
                        self.MoniterMeGif.isHidden = true
                    }else{
                        self.MoniterMeGif.isHidden = false
                    }
                    
                    let input = DDModelInput(image: pixelBuffer)
                    let prediction = try self.ddModel.prediction(input: input)
                    let outputString = prediction.target
                    if self.faceVisible == false  && outputString1 == "face detected"{
                        self.faceVisible = true
                        self.alertArray.append("\(self.dateFormatter.string(from: Date())): Face detection output: face detected")
                        dataModel.addNewAlertOnAlertBoard(newAlert: AlertTimming(iconImage: "person.crop.circle.badge.checkmark", timeAlert: "\(self.dateFormatter.string(from: Date()))", alertMessage: "Face Detected"))
                    }


                    self.logWithISTDate("Output String: \(outputString)")
                    if outputString == "Fatigue" {
                        if !self.isDrowsy {
                            self.isDrowsy = true
                            self.drowsinessStartTime = Date()
                        } else {
                            // Check if drowsiness duration exceeds the threshold
                            if let startTime = self.drowsinessStartTime, Date().timeIntervalSince(startTime) >= self.drowsinessAlertThreshold {
                                // Check if an alert has been sent recently
                                if let lastAlertTime = self.lastAlertTime, Date().timeIntervalSince(lastAlertTime) < self.drowsinessAlertThreshold {
                                    return // Avoid sending multiple alerts within the threshold
                                }
                                // Play alert sound
                                self.playBeepSound()
                                // Update last alert time
                                self.alertArray.append("\(self.dateFormatter.string(from: Date())): Drowsiness detection output: Fatigue")
                                dataModel.addNewAlertOnAlertBoard(newAlert: AlertTimming(iconImage: "eye.trianglebadge.exclamationmark.fill", timeAlert: "\(self.dateFormatter.string(from: Date()))", alertMessage: "Drowsiness Detcted"))
                                self.lastAlertTime = Date()
                            }
                        }
                    } else {
                        // Reset drowsiness tracking if fatigue is not detected
                        self.isDrowsy = false
                        self.drowsinessStartTime = nil
                    }
                } else {
                    // Reset drowsiness tracking if face is not detected
                    self.isDrowsy = false
                    self.drowsinessStartTime = nil
                    print("No face detected")

                    // Append detection output with formatted timestamp to the array only if it's the first time
                    if self.faceVisible == true && outputString1 == "face Not detected" {
                        self.faceVisible = false
                        self.alertArray.append("\(self.dateFormatter.string(from: Date())): Face detection output: face not detected")
                        dataModel.addNewAlertOnAlertBoard(newAlert: AlertTimming(iconImage: "person.crop.circle.badge.xmark", timeAlert: "\(self.dateFormatter.string(from: Date()))", alertMessage: "Face Not Detcted"))
                        
                    }

                    self.emojiPic.image = UIImage(named: "RedImageNotFound")
                    self.MoniterMeGif.isHidden = true
                    self.playFaceSound()
                }
            } catch {
                print("Error making face prediction \(error)")
            }
        }
    }

    @IBAction func end(_ sender: Any) {
        let alertController = UIAlertController(title: "Stop Monitoring", message: "Do you want to end monitoring?", preferredStyle: .alert)
        
        // Add action for continuing monitoring
        let continueAction = UIAlertAction(title: "Continue", style: .default) { _ in
            // Dismiss the alert controller
        }
        alertController.addAction(continueAction)
        
        // Add action for stopping monitoring
        let stopAction = UIAlertAction(title: "Stop", style: .destructive) { _ in
            // Navigate to the desired destination
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                // Set modal presentation style to full screen
                tabBarController.modalPresentationStyle = .fullScreen
                
                // Present the tab bar controller modally
                self.present(tabBarController, animated: true, completion: nil)
            }
            
            // Print the alertArray
            print(self.alertArray)
            
            // Stop the timer and remove capture session outputs
            self.timer?.invalidate()
            self.captureSession?.stopRunning()
            self.captureSession?.outputs.forEach { output in
                self.captureSession?.removeOutput(output)
            }
        }
        alertController.addAction(stopAction)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }


    @IBAction func TurnTheCamViewToggle(_ sender: Any) {
        if turnOffCamView.image == UIImage(systemName: "shareplay") {
                // Change back to the original image
                turnOffCamView.image = UIImage(systemName: "shareplay.slash")
                emojiPic.isHidden = true
                gifview.isHidden = false
                cameraView.isHidden = false
            MoniterMeGif.isHidden = true
            } else if turnOffCamView.image == UIImage(systemName: "shareplay.slash") {
                // Change to the new image
                turnOffCamView.image = UIImage(systemName: "shareplay")
                emojiPic.isHidden = false
                gifview.isHidden = true
                cameraView.isHidden = true
                MoniterMeGif.isHidden = false
            }
       
    }
    @IBAction func black(_ sender: Any) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "black") as? UIViewController {
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                
            }
        }
    
}
