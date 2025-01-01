import SwiftData
import Foundation
@Model
class File: Identifiable {
    var id: UUID
    var title: String
    var emoji: String?  // حقل الإيموجي أصبح اختياريًا
    var imageData: Data?  // حقل الصورة (اختياري)

    @Relationship var cards: [Card]

    init(title: String, emoji: String? = nil, imageData: Data? = nil) {
        self.id = UUID()
        self.title = title
        self.emoji = emoji
        self.imageData = imageData
        self.cards = []
    }
}
