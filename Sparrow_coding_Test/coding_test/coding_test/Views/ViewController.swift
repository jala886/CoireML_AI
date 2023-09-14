//
//  ViewController.swift
//  coding_test
//
//  Created by jianli on 9/11/23.
//

import UIKit
import CoreML
import AVKit

typealias AiMachine = YOLOv3FP16

class ViewController: UIViewController, UINavigationControllerDelegate {
    var model: AiMachine?
    
    required init?(coder aDecoder: NSCoder) {
        model = try? AiMachine()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    //MARK: TOP Section
    lazy var videoLabel = {
        let label = UILabel()
        label.text = "Load Video"
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints  = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadVideo))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    lazy var titleLabel = {
        let label = UILabel()
        label.text = "Sparrow AI"
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    lazy var libLabel = {
        let label = UILabel()
        label.text = "Load Image"
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints  = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadLibrary))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var topSect: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
        videoLabel, titleLabel, libLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    //MARK: UI DEFINED
    lazy var imageView: UIImageView = {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 299, height: 299)).image{_ in }
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.yellow.cgColor
        imageView.backgroundColor = UIColor.yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var classifier: UILabel = {
        let label = UILabel()
        label.text = "Choose a Image..."
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.textAlignment = .center
        label.textColor = .red
        //label.backgroundColor = UIColor.yellow
        return label
    }()
    
    private func setupUI() {
        view.addSubview(topSect)
        view.addSubview(imageView)
        view.addSubview(classifier)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            topSect.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            topSect.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            topSect.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            
            imageView.topAnchor.constraint(equalTo: topSect.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            
            classifier.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            classifier.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            classifier.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            //classifier.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),
        ])
    }
    
    //MAKR: ACTIONS
    @objc func loadVideo(sender: UITapGestureRecognizer) {
        print("click load video")
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        // picker.videoExportPreset = AVAssetExportPresetHEVC1920x1080
        picker.videoExportPreset = AVAssetExportPresetPassthrough
        present(picker, animated: true)
    }
    
    @objc func loadLibrary(sender: UITapGestureRecognizer) {
        print("click load library")
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
}



