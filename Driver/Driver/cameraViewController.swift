//
//  cameraViewController.swift
//  Camera
//
//  Created by Utsav  on 28/04/24.
//

import UIKit
import  AVFoundation
class cameraViewController: UIViewController {
    
    @IBOutlet weak var gifview: UIImageView!
    // @IBOutlet weak var button: UIButton!
   @IBOutlet weak var cameraView: UIView!
    var captureSession = AVCaptureSession()
    var sessionOutput =  AVCapturePhotoOutput()
    var previewLayer =  AVCaptureVideoPreviewLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        gifview.loadGif(name: "giphy")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let deviceSession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )
        
        // Safely unwrap the devices array
        for device in deviceSession.devices {
            if device.position == .front {
                configureCamera(with: device)
                
            }
        }
        
        if deviceSession.devices.isEmpty {
            print("No devices found")
        }
        
        
        func configureCamera(with device: AVCaptureDevice) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                    
                    let sessionOutput = AVCapturePhotoOutput()
                    if captureSession.canAddOutput(sessionOutput) {
                        captureSession.addOutput(sessionOutput)
                        
                        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                        previewLayer.videoGravity = .resizeAspectFill
                        previewLayer.connection?.videoOrientation = .portrait
                        previewLayer.frame = cameraView.bounds
                        cameraView.layer.addSublayer(previewLayer)
                        //cameraView.addSubview(button)
                        
                        if !captureSession.isRunning {
                            captureSession.startRunning()
                        }
                    }
                }
            } catch {
                print("Error configuring camera: \(error)")
            }
        }
        gifview.loadGif(name: "giphy")
        
    }
    
    
     
   // @IBAction func button(_ sender: Any) {
    }
    
    

