//
//  ViewController.swift
//  NFCReaderQ
//
//  Created by 111542 on 11/23/20.
//

import UIKit


import NFCPassportReader
import Lottie

@available(iOS 13, *)

class ViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    var passport: NFCPassportModel?
    private let passportReader = PassportReader()

    @IBOutlet weak var userSerialNo: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userCardStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationView.play()
        animationView.loopMode = .loop
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.scanUserPass()
        }
    }
    
    func lottieInit() {
        let animation = Animation.named("passport")
        animationView.animation = animation
    }


    func scanUserPass() {
        let mrzKey = NFCKeyUtils.instance.getMRZKey(idNumber: "SERIALNO", birthDate: "YYMMDD", cardExpiryDate: "YYMMDD")
        let masterListURL = Bundle.main.url(forResource: "masterList", withExtension: ".pem")!
        passportReader.setMasterListURL(masterListURL)
        passportReader.readPassport(mrzKey: mrzKey) { (displayMessage) -> String? in
            switch displayMessage {
            case .requestPresentPassport:
                return "Telefonu yakin tutun."
            case .successfulRead:
                return "Okuma islemi basarili"
            case .readingDataGroupProgress(let dataGroup, let progress):
                let progressString = progress.handleProgress()
                return "Okunuyor \(dataGroup).....\n\n\(progressString)"
            default:
                return nil
            }
        } completed: { (passport, error) in

            if let passport = passport {
                // All good, we got a passport
                DispatchQueue.main.async {
                    UIView.transition(with: self.animationView, duration: 0.4, options: .transitionCrossDissolve) {
                        self.animationView.isHidden = true
                    }completion: { (val) in
                        if val {
                            UIView.transition(with: self.userCardStackView, duration: 0.2, options: .curveEaseIn) {
                                self.userCardStackView.isHidden = false
                                self.userSerialNo.text = passport.personalNumber
                                self.userFullName.text = "\(passport.firstName) \(passport.lastName)"
                                self.userImageView.image = passport.passportImage
                                
                            
                                self.userCardStackView.centerXAnchor.anchorWithOffset(to: self.view.centerXAnchor)
                                
                                self.userCardStackView.centerYAnchor.anchorWithOffset(to: self.view.centerYAnchor)
                            }
                        }
                    }

                }

            }

        }


    }
}

