import UIKit
import AVFoundation
import CoreML

class cameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var ddModel: DDModel!
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var gifview: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        gifview.loadGif(name: "giphy")
        do {
            ddModel = try DDModel(configuration: MLModelConfiguration())
        } catch {
            print("Error initializing Core ML Model \(error)")
        }
        prepareBeepSound()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCamera()
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

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        do {
            let input = DDModelInput(image: pixelBuffer)
            let prediction = try ddModel.prediction(input: input)
            let outputString = prediction.target
            
            // Handle the prediction results as needed
            print("Output String: \(outputString)")
            if outputString == "fatigue" {
                DispatchQueue.main.async { [weak self] in
                    self?.playBeepSound()
                }
            }
        } catch {
            print("Error making prediction: \(error)")
        }
    }

    func playBeepSound() {
        audioPlayer?.play()
    }

    func configureCamera() {
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
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = cameraView.bounds
        cameraView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
}
