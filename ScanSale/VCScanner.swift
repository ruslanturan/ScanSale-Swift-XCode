import AVFoundation
import UIKit

class VCScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var scanRect = UIImageView()
    var lblScan = UILabel()
    var screenWidth = UIScreen.main.bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        navigationItem.backBarButtonItem = backBarBtnItem
        
        view.backgroundColor = UIColor.white
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        self.scanRect.frame = CGRect(x: (self.screenWidth - self.screenWidth*7/10)/2, y: 100, width: (self.screenWidth*7/10), height: (self.screenWidth*7/10))
        self.scanRect.image = UIImage(named: "scan_rect")
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: (self.screenWidth*7/10), height: (self.screenWidth*7/10))
        previewLayer.videoGravity = .resizeAspectFill
        view.addSubview(self.scanRect)
        let scanRound = UIView(frame: CGRect(x: (self.screenWidth*3/50), y: (self.screenWidth*3/50), width: (self.screenWidth*3/5), height: (self.screenWidth*3/5)))
        scanRound.layer.cornerRadius = self.screenWidth*3/10
        scanRound.layer.masksToBounds = true
        self.scanRect.addSubview(scanRound)
        scanRound.layer.addSublayer(previewLayer)
        self.lblScan.frame = CGRect(x: 0, y: 200 + (self.screenWidth*7/10), width: self.screenWidth, height: 60)
        self.lblScan.text = "სკანირდება..."
        self.lblScan.font = UIFont.boldSystemFont(ofSize: 24.0)
        self.lblScan.textColor = UIColor.darkGray
        self.lblScan.textAlignment = .center
        view.addSubview(lblScan)
        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        if code.starts(with: "https://myoutlet.ge/api/barcode/get"){
            self.lblScan.text = "მზად არის"
            let vcProducts = VCProductsQR()
            vcProducts.Url = code
            self.navigationController!.pushViewController(vcProducts, animated: true)
        } else {
            self.lblScan.text = "QR კოდი არასწორია"
        }
        print(code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
