//
//  AgendaModel.swift
//  NC1HelpfullApp
//
//  Created by Eki Rifaldi on 07/03/20.
//  Copyright © 2020 Eki Rifaldi. All rights reserved.
//

import UIKit

class AgendaModel {
    var title: String?
    var definition: String?
    var image: String?
    var tempat: String?
    var waktu: String?
    var jenis: String?
    var bentukKegiatan: String?

    init(title: String?, definition: String?, image: String?, tempat: String?, waktu: String?, jenis: String?, bentukKegiatan: String?) {
        self.title = title
        self.definition = definition
        self.image = image
        self.tempat = tempat
        self.waktu = waktu
        self.jenis = jenis
        self.bentukKegiatan = bentukKegiatan
    }
    
    func getTitle() -> String{
        return self.title ?? "kosong"
    }
    
    func getDefinition() -> String{
        return self.definition ?? "kosong"
    }
    
    func getImage() -> String{
        return self.image ?? "satu"
    }
    
    func getTempat() -> String{
        return self.tempat ?? "kosong"
    }
    
    func getWaktu() -> String{
        return self.waktu ?? "kosong"
    }
    
    func getJenis() -> String{
        return self.jenis ?? "kosong"
    }
    
    func getBentukKegiatan() -> String{
        return self.bentukKegiatan ?? "kosong"
    }
}
