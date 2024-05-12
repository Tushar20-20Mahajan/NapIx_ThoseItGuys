import UIKit
import AVFoundation
import CoreML
import Vision

@available(iOS 17.0, *)
class cameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var timer: Timer?
    var isScreenBlack = false
    var audioPlayer: AVAudioPlayer?

    var ddModel: DDModel!
    var fdModel: FDModel!
    var captureSession: AVCaptureSession?
    var isDrowsy: Bool = false
    var drowsinessStartTime: Date?
    var lastAlertTime: Date?
    let drowsinessAlertThreshold: TimeInterval = 3 // Threshold for drowsiness alert (3 seconds)
    var alertArray : [String] = []
    var faceVisible = false
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var gifview: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var turnOffCamView: UIBarButtonItem!
    
    @IBOutlet weak var emojiPic: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(gifview)
        gifview.loadGif(name: "giphy")
        prepareBeepSound()
        setupDrowsinessDetection()
        configureCamera()
        emojiPic.isHidden = true
        emojiPic.image = UIImage(named: "Green")

      //  turnOnCamView.isEnabled = false

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
            formatter.dateFormat = "HH:mm:ss"
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

//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//            DispatchQueue.main.async {
//                do {
//                    let input1 = FDModelInput(image: pixelBuffer)
//                    let prediction1 = try self.fdModel.prediction(input: input1)
//                    let outputString1 = prediction1.target
//                    
//                    print("Output String is: \(outputString1)")
//                    
//                    if outputString1 == "face detected" {
//                        do {
//                            if(self.alertArray.count != 0 && self.alertArray[self.alertArray.count-1] == "\(self.dateFormatter.string(from: Date())): Face detection output: face not detected"){
//                                self.alertArray.append("\(self.dateFormatter.string(from: Date())): Face detection output: face detected")
//                            }
//                            self.emojiPic.image = UIImage(named: "Green")
//                            let input = DDModelInput(image: pixelBuffer)
//                            let prediction = try self.ddModel.prediction(input: input)
//                            let outputString = prediction.target
//                            
//                            // Append detection output with formatted timestamp to the array
//                            //self.alertArray.append("\(self.dateFormatter.string(from: Date())): \(outputString)")
//                            
//                            print("Output String: \(outputString)")
//                            if outputString == "Fatigue" {
//                                if !self.isDrowsy {
//                                    self.isDrowsy = true
//                                    self.drowsinessStartTime = Date()
//                                } else {
//                                    // Check if drowsiness duration exceeds the threshold
//                                    if let startTime = self.drowsinessStartTime, Date().timeIntervalSince(startTime) >= self.drowsinessAlertThreshold {
//                                        // Check if an alert has been sent recently
//                                        if let lastAlertTime = self.lastAlertTime, Date().timeIntervalSince(lastAlertTime) < self.drowsinessAlertThreshold {
//                                            return // Avoid sending multiple alerts within the threshold
//                                        }
//                                        // Play alert sound
//                                        self.playBeepSound()
//                                        // Update last alert time
//                                        self.alertArray.append("\(self.dateFormatter.string(from: Date())): Drowsiness detection output: Fatigue")
//                                        self.lastAlertTime = Date()
//                                    }
//                                }
//                            } else {
//                                // Reset drowsiness tracking if fatigue is not detected
//                                self.isDrowsy = false
//                                self.drowsinessStartTime = nil
//                            }
//                        } catch {
//                            print("Error making drowsiness prediction: \(error)")
//                        }
//                    } else {
//                        // Reset drowsiness tracking if face is not detected
//                        self.isDrowsy = false
//                        self.drowsinessStartTime = nil
//                        print("No face detected")
//                        
//                        // Append detection output with formatted timestamp to the array
//                        self.alertArray.append("\(self.dateFormatter.string(from: Date())): Face detection output: face not detected")
//                        
//                        self.emojiPic.image = UIImage(named: "RedImageNotFound")
//                        self.playFaceSound()
//                    }
//                } catch {
//                    print("Error making face prediction \(error)")
//                }
//            }
//        }
    
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
                    let input = DDModelInput(image: pixelBuffer)
                    let prediction = try self.ddModel.prediction(input: input)
                    let outputString = prediction.target
                    if self.faceVisible == false  && outputString1 == "face detected"{
                        self.faceVisible = true
                        self.alertArray.append("\(self.dateFormatter.string(from: Date())): Face detection output: face detected")
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
                    }

                    self.emojiPic.image = UIImage(named: "RedImageNotFound")
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
            } else if turnOffCamView.image == UIImage(systemName: "shareplay.slash") {
                // Change to the new image
                turnOffCamView.image = UIImage(systemName: "shareplay")
                emojiPic.isHidden = false
                gifview.isHidden = true
                cameraView.isHidden = true
            }
       
    }
    @IBAction func black(_ sender: Any) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "black") as? UIViewController {
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                
            }
        }
    
}

