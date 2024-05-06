import UIKit
import AVFoundation
import Vision

class cameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var gifview: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifview.loadGif(name: "giphy")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCamera()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Perform face detection on the captured video frames
        detectFaces(in: sampleBuffer)
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
    
    func detectFaces(in sampleBuffer: CMSampleBuffer) {
        // Perform face detection using Vision Kit
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("Error detecting faces: \(error)")
                return
            }
            
            guard let results = request.results as? [VNFaceObservation] else { return }
            
            for observation in results {
                // Process each detected face observation
                let boundingBox = observation.boundingBox
                let transformedRect = self.transformRect(boundingBox, viewRect: self.cameraView.bounds)
                self.highlightFace(rect: transformedRect)
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform face detection: \(error)")
        }
    }
    
    func transformRect(_ faceRect: CGRect, viewRect: CGRect) -> CGRect {
        let w = viewRect.width
        let h = viewRect.height
        
        let x = w * faceRect.origin.x
        let y = h * (1 - faceRect.origin.y - faceRect.height)
        let width = w * faceRect.width
        let height = h * faceRect.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func highlightFace(rect: CGRect) {
        // Add visual highlighting for detected face
        let faceRectLayer = CAShapeLayer()
        faceRectLayer.frame = rect
        faceRectLayer.borderColor = UIColor.red.cgColor
        faceRectLayer.borderWidth = 2
        cameraView.layer.addSublayer(faceRectLayer)
    }
}
