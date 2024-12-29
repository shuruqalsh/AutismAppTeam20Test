//
//  Card.swift
//  AutismAppTeam20
//
//  Created by Sumayah Alqahtani on 23/06/1446 AH.
//

//import SwiftData
//import Foundation

//@Model
//class Card: Identifiable {
//    var id: UUID
//    var emoji: String
//    var cardDescription: String
//    @Relationship(inverse: \File.cards) var file: File? // العلاقة العكسية مع File
//
//    init(emoji: String, cardDescription: String) {
//        self.id = UUID()
//        self.emoji = emoji
//        self.cardDescription = cardDescription
//    }
//}
import SwiftData
import Foundation

@Model
class Card: Identifiable {
    var id: UUID
    var emoji: String?
    var cardDescription: String
    @Relationship(inverse: \File.cards) var file: File?
    var imageData: Data?
    var audioData: Data?  // إضافة بيانات الصوت

    init(emoji: String? = nil, cardDescription: String, imageData: Data? = nil, audioData: Data? = nil) {
        self.id = UUID()
        self.emoji = emoji
        self.cardDescription = cardDescription
        self.imageData = imageData
        self.audioData = audioData  // تهيئة بيانات الصوت
    }
}

