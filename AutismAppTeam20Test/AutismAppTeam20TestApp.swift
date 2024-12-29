//
//  AutismAppTeam20TestApp.swift
//  AutismAppTeam20Test
//
//  Created by Sumayah Alqahtani on 24/06/1446 AH.
//

import SwiftUI

@main
struct AutismAppTeam20TestApp: App {
    var body: some Scene {
        WindowGroup {
            FilesScreen()
                .modelContainer(for: File.self) // تحديد الـ model container لـ File
                .modelContainer(for: Card.self) // تحديد الـ model container لـ Card
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

