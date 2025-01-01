//
//  SwiftUIView.swift
//  AutismAppTeam20Test
//
//  Created by shuruq alshammari on 30/06/1446 AH.
//

import Foundation
import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ZStack {
            // Background shape
            Path { path in
                let width: CGFloat = 400
                let height: CGFloat = 120
                let cornerRadius: CGFloat = 30

                path.move(to: CGPoint(x: 0, y: cornerRadius))
                path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius,
                            startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
                path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
                path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius,
                            startAngle: .degrees(270), endAngle: .degrees(360), clockwise: false)
                path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
                path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius,
                            startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
                path.addLine(to: CGPoint(x: cornerRadius, y: height))
                path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius,
                            startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
                path.closeSubpath()
            }
            .fill(Color(hex: "#FCF0DE"))
            .frame(width: 450, height: 550)

            // Foreground file shape
            ZStack {
                // Blue background for the file
                Path { path in
                    let width: CGFloat = 400
                    let height: CGFloat = 200
                    let cornerRadius: CGFloat = 30
                    let tabHeight: CGFloat = -40
                    let tabWidth: CGFloat = 300
                    let tabCornerRadius: CGFloat = 15

                    path.move(to: CGPoint(x: 0, y: cornerRadius))
                    path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius,
                                startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
                    let tabStartX = (width - tabWidth) / 2
                    path.addLine(to: CGPoint(x: tabStartX - tabCornerRadius, y: 0))
                    path.addArc(center: CGPoint(x: tabStartX, y: tabHeight + tabCornerRadius), radius: tabCornerRadius,
                                startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
                    path.addLine(to: CGPoint(x: tabStartX + tabWidth - tabCornerRadius, y: tabHeight))
                    path.addArc(center: CGPoint(x: tabStartX + tabWidth, y: tabHeight + tabCornerRadius), radius: tabCornerRadius,
                                startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
                    path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
                    path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius,
                                startAngle: .degrees(270), endAngle: .degrees(360), clockwise: false)
                    path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
                    path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius,
                                startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
                    path.addLine(to: CGPoint(x: cornerRadius, y: height))
                    path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius,
                                startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
                    path.closeSubpath()
                }
                .fill(Color(hex: "#FFE6DC")) // File background color

                // Orange stroke (border) for the file
                Path { path in
                    let width: CGFloat = 400
                    let height: CGFloat = 200
                    let cornerRadius: CGFloat = 30
                    let tabHeight: CGFloat = -40
                    let tabWidth: CGFloat = 300
                    let tabCornerRadius: CGFloat = 15

                    path.move(to: CGPoint(x: 0, y: cornerRadius))
                    path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius,
                                startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
                    let tabStartX = (width - tabWidth) / 2
                    path.addLine(to: CGPoint(x: tabStartX - tabCornerRadius, y: 0))
                    path.addArc(center: CGPoint(x: tabStartX, y: tabHeight + tabCornerRadius), radius: tabCornerRadius,
                                startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
                    path.addLine(to: CGPoint(x: tabStartX + tabWidth - tabCornerRadius, y: tabHeight))
                    path.addArc(center: CGPoint(x: tabStartX + tabWidth, y: tabHeight + tabCornerRadius), radius: tabCornerRadius,
                                startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
                    path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
                    path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius,
                                startAngle: .degrees(270), endAngle: .degrees(360), clockwise: false)
                    path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
                    path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius,
                                startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
                    path.addLine(to: CGPoint(x: cornerRadius, y: height))
                    path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius,
                                startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
                    path.closeSubpath()
                }
                .stroke(Color(hex: "#FFC967"), lineWidth: 5) // File border color
            }
            .frame(width: 450, height: 390)
        }
    }
}

#Preview {
    SwiftUIView()
}
