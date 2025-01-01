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
