//
//  QRNBarCodeCodeViewController.swift
//  EmptyLine
//
//  Created by Pursuit on 4/4/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase


class QRNBarCodeCodeViewController:
UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var panGesture = UIPanGestureRecognizer()
    var webby = QRCodeWebSiteViewController()
    //        @IBOutlet weak var barCodeRawValueLabel: UILabel!
    var barCodeRawValueLabel: UILabel!
    
    var bar = ""
    var website = ""
    
    let session = AVCaptureSession()
    lazy var vision = Vision.vision()
    var barcodeDetector :VisionBarcodeDetector?
    
    var idk = MyWebby()
    var productDetailView = ProductDetailsView()
    private var products:Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLiveVideo()
        addToShoppingCart()
        dontAddToShoppingCart()
        byebyeWebSite()
        fetchProduct(barCode: bar)
        self.barcodeDetector = vision.barcodeDetector()
        navigationController?.isNavigationBarHidden = true
        let gradient = CAGradientLayer()
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))
//        productDetailView.isUserInteractionEnabled = true
//        productDetailView.addGestureRecognizer(panGesture)

//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(dr))
        //        gradient.frame = self.view.frame
        //        gradient.colors = [UIColor.magenta.cgColor,UIColor.red.cgColor,UIColor.purple.cgColor,UIColor.blue.cgColor]
        //        self.view.layer.addSublayer(gradient)
        // view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    }
    
    func stopRecording() {
        session.stopRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopRecording()
    }
    
    @objc func panGestureHandler(_ recognizer: UIPanGestureRecognizer){
        self.view.bringSubviewToFront(productDetailView)
        let translation = recognizer.translation(in: self.view)
        imageView.center = CGPoint(x: productDetailView.center.x + translation.x, y: productDetailView.center.y + translation.y)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let barcodeDetector = self.barcodeDetector {
            let visionImage = VisionImage(buffer: sampleBuffer)
            barcodeDetector.detect(in: visionImage) { (barcodes, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if barcodes!.count == 1 {
                    if (barcodes?.first?.rawValue!.contains("https"))! || (barcodes?.first?.rawValue!.contains("http"))! {
                        self.website = (barcodes?.first?.rawValue)!
                        self.QRCodeSetView()
                        print("i is here \(self.website)")
                    } else {
                        if (barcodes?.first?.rawValue!.count)! > 3 {
                            self.bar = (barcodes?.first?.rawValue)!
                            self.fetchProduct(barCode: self.bar)
                            self.setupView()
                            print("i is in second part \(self.bar)")
                        }
                    }
                }
            }
        }
    }
    
    func backGroundColor(){
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.magenta.cgColor,UIColor.red.cgColor,UIColor.purple.cgColor,UIColor.blue.cgColor]
        self.view.layer.addSublayer(gradient)
    }
    
    public func QRCodeSetView(){
        
        if let window = UIApplication.shared.keyWindow {
            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(byebye)))
            window.addSubview(idk)
            let height: CGFloat = 600
            let y = window.frame.height - height
            view.frame = window.frame
            //view.alpha = 0
            
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.75, options: .curveEaseOut, animations: {
                //self.view.alpha = 1
                self.idk.frame = CGRect(x: 0, y: y, width:
                    self.idk.frame.width, height:
                    self.idk.frame.height)
            }, completion: nil)
        }
    }
    
    
    private func byebyeWebSite(){
        print("i work?")
        idk.exit.addTarget(self, action: #selector(byebye), for: .touchUpInside)
    }
    
    @objc func byebye() {
        byeee()
    }
    
    @objc func byeee(){
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
            if let window = UIApplication.shared.keyWindow {
                self.idk.frame = CGRect(x: 0, y: window.frame.height, width: self.idk.frame.width, height: self.idk.frame.height)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    
    
    
    public func setupView(){
        if let window = UIApplication.shared.keyWindow {
            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(productDetailView)
            
            let height: CGFloat = 700
            
            let y = window.frame.height - height
            view.frame = window.frame
            // view.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.alpha = 1
                self.productDetailView.frame = CGRect(x: 0, y: y, width: self.productDetailView.frame.width, height: self.productDetailView.frame.height)
            }, completion: nil)
            
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
            if let window = UIApplication.shared.keyWindow {
                self.productDetailView.frame = CGRect(x: 0, y: window.frame.height, width: self.productDetailView.frame.width, height: self.productDetailView.frame.height)
            }
        }
    }
    
    
    
    
    
    
    
    private func fetchProduct(barCode: String){
        DBService.getProducts(productBarcode: barCode) { (error, product) in
            if let error = error {
                self.showAlert(title: "Error fetching product information", message: error.localizedDescription)
            } else {
                if let product = product {
                    self.products = product
                    dump(self.products)
                    self.productDetailView.productName.text = product.name
                    self.productDetailView.productDetails.text = product.description
                    self.productDetailView.productPrice.text = "$" + String(product.price)
                    self.productDetailView.productImage.kf.setImage(with: URL(string: product.image))
                }
            }
        }
    }
    
    
    
    private func addToShoppingCart(){
        productDetailView.addToCartButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
    }
    
    private func dontAddToShoppingCart(){
        productDetailView.deleteButton.addTarget(self, action: #selector(dontAddMe), for: .touchUpInside)
    }
    
    @objc func dontAddMe(){
        handleDismiss()
    }
    
    
    @objc private func addButtonPressed(){
        let itemSavedDate = ItemSavedDate.init(createdDate: products?.createdAt ?? "")
        savedDate.add(newDate: itemSavedDate)

        if let item = products {
            ItemsDataManager.addToShoppingCart(item: item, savedDate: "\(itemSavedDate.createdDate).plist")
            let alertController = UIAlertController(title: "Success", message: "Successfully added item to shopping cart", preferredStyle: .alert)
            
            let continueShopping = UIAlertAction(title: "Continue Shopping", style: .cancel, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            })
            
            let checkOut = UIAlertAction(title: "Check Out", style: .default, handler: { (alert) in
                self.navigationController?.pushViewController(ShoppingListViewController(), animated: true)
            })
            
            alertController.addAction(checkOut)
            alertController.addAction(continueShopping)
            self.present(alertController, animated: true)
            self.handleDismiss()
            print("Item added")
        }
    }
    
    
    
    
    
    
    
    
    
    
    func startLiveVideo() {
        
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = CGRect(x: 0, y: 0, width: self.imageView.frame.size.width + 100, height: self.imageView.frame.size.height + 250)
        imageLayer.videoGravity = .resizeAspectFill
        imageView.layer.addSublayer(imageLayer)
        session.startRunning()
    }
    
    
}
