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
    
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var gifview: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var turnOfCamView: UIBarButtonItem!
    @IBOutlet weak var turnOnCamView: UIBarButtonItem!
    
    @IBOutlet weak var emojiPic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(gifview)
        gifview.loadGif(name: "giphy")
        prepareBeepSound()
        setupDrowsinessDetection()
        configureCamera()
        emojiPic.isHidden = true

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

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        do {
            let input1 = FDModelInput(image: pixelBuffer)
            let prediction1 = try fdModel.prediction(input: input1)
            let outputString1 = prediction1.target

            print("Output String is: \(outputString1)")

            if outputString1 == "face detected" {
                do {
                    let input = DDModelInput(image: pixelBuffer)
                    let prediction = try ddModel.prediction(input: input)
                    let outputString = prediction.target

                    print("Output String: \(outputString)")
                    if outputString == "Fatigue" {
                        if !isDrowsy {
                            isDrowsy = true
                            drowsinessStartTime = Date()
                        } else {
                            // Check if drowsiness duration exceeds the threshold
                            if let startTime = drowsinessStartTime, Date().timeIntervalSince(startTime) >= drowsinessAlertThreshold {
                                // Check if an alert has been sent recently
                                if let lastAlertTime = lastAlertTime, Date().timeIntervalSince(lastAlertTime) < drowsinessAlertThreshold {
                                    return // Avoid sending multiple alerts within the threshold
                                }
                                // Play alert sound
                                playBeepSound()
                                // Update last alert time
                                self.lastAlertTime = Date()
                            }
                        }
                    } else {
                        // Reset drowsiness tracking if fatigue is not detected
                        isDrowsy = false
                        drowsinessStartTime = nil
                    }
                } catch {
                    print("Error making drowsiness prediction: \(error)")
                }
            } else {
                // Reset drowsiness tracking if face is not detected
                isDrowsy = false
                drowsinessStartTime = nil
                print("No face detected")
                playFaceSound()
            }

        } catch {
            print("Error making face prediction \(error)")
        }
    }

    @IBAction func end(_ sender: Any) {
        timer?.invalidate()
        captureSession?.stopRunning()
        captureSession?.outputs.forEach { output in
            captureSession?.removeOutput(output)
        }
        self.dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "Monitor Me") as? MonitorMeViewController {
                self.navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
    }
    
    @IBAction func TurnTheCamViewOn(_ sender: Any) {
        emojiPic.isHidden = true
                gifview.isHidden = false
                cameraView.isHidden = false
    }
    
    @IBAction func TurnOffTheCamView(_ sender: Any) {
        emojiPic.isHidden = false
               gifview.isHidden = true
               cameraView.isHidden = true
    }
}
