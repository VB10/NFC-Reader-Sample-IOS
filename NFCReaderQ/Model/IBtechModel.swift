//
//  IBtechModel.swift
//  NFCReaderQ
//
//  Created by 111542 on 11/24/20.
//

import Foundation
import NFCPassportReader

class IBtechModel {

    let passportModel: NFCPassportModel

    init(passportModel: NFCPassportModel) {
        self.passportModel = passportModel
    }


    public lazy var documentType: String = { return passportModel.documentType }()
    public lazy var userID: String = { return passportModel.personalNumber }()
    public lazy var name: String = { return passportModel.firstName }()
    public  var surName : String { return passportModel.lastName }


}
