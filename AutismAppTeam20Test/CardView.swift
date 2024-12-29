//
//  CardView.swift
//  AutismAppTeam20
//
//  Created by Sumayah Alqahtani on 17/06/1446 AH.
//

//import SwiftUI
//
//struct CardView: View {
//    var card: Card
//    
//    var body: some View {
//        VStack {
//            Text(card.emoji)  // عرض الإيموجي
//                .font(.system(size: 50))
//            
//            Text(card.cardDescription)  // عرض وصف البطاقة
//                .font(.system(size: 40))  // تغيير حجم الخط هنا حسب الحاجة
//                .padding(.top, 5)
//                .multilineTextAlignment(.center)  // محاذاة النص في المنتصف
//        }
//        .padding()
//        .frame(maxWidth: .infinity)  // جعل البطاقة تأخذ المساحة المتاحة
//        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))  // إضافة خلفية
//        .padding(.bottom, 10)
//        .environment(\.layoutDirection, .rightToLeft)  // تعيين اتجاه الكتابة من اليمين لليسار
//    }
//}
//import SwiftUI
//
//struct CardView: View {
//    var card: Card
//    
//    var body: some View {
//        VStack {
//            // عرض الصورة أولاً إذا كانت موجودة
//            if let imageData = card.imageData, let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 150)
//                    .padding(.bottom, 10)
//            }
//
//            // عرض الإيموجي فقط إذا كان موجودًا
//            if let emoji = card.emoji, !emoji.isEmpty {
//                Text(emoji)
//                    .font(.system(size: 50))
//                    .padding(.bottom, 10)  // إضافة حشو بين الإيموجي والشرح
//            }
//
//            // عرض الوصف أسفل الإيموجي
//            Text(card.cardDescription)
//                .font(.system(size: 40))
//                .padding(.top, 5)
//                .multilineTextAlignment(.center)
//                .lineLimit(3)  // لتحديد عدد الأسطر المسموح بها في الوصف (اختياري)
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
//        .padding(.bottom, 10)
//        .environment(\.layoutDirection, .rightToLeft)  // محاذاة من اليمين لليسار
//    }
//}
//import SwiftUI
//
//struct CardView: View {
//    var card: Card
//    
//    var body: some View {
//        VStack {
//            // عرض الصورة أولاً إذا كانت موجودة
//            if let imageData = card.imageData, let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 150)  // تحديد ارتفاع ثابت للصورة
//                    .padding(.bottom, 10)
//            }
//
//            // عرض الإيموجي فقط إذا كان موجودًا
//            if let emoji = card.emoji, !emoji.isEmpty {
//                Text(emoji)
//                    .font(.system(size: 50))
//                    .padding(.bottom, 10)  // إضافة حشو بين الإيموجي والشرح
//            }
//
//            // عرض الوصف أسفل الإيموجي
//            Text(card.cardDescription)
//                .font(.system(size: 40))
//                .padding(.top, 5)
//                .multilineTextAlignment(.center)
//                .lineLimit(3)  // لتحديد عدد الأسطر المسموح بها في الوصف (اختياري)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)  // جعل البطاقة تأخذ المساحة المتاحة
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
//        .padding(.bottom, 10)
//        .environment(\.layoutDirection, .rightToLeft)  // محاذاة من اليمين لليسار
//        .frame(height: 300)  // تحديد ارتفاع ثابت للبطاقة بحيث يتساوى مع البطاقات الأخرى
//    }
//}
import SwiftUI
import AVFoundation

struct CardView: View {
    var card: Card
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            // عرض الصورة أولاً إذا كانت موجودة
            if let imageData = card.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)  // تحديد ارتفاع ثابت للصورة
                    .padding(.bottom, 10)
            }

            // عرض الإيموجي فقط إذا كان موجودًا
            if let emoji = card.emoji, !emoji.isEmpty {
                Text(emoji)
                    .font(.system(size: 50))
                    .padding(.bottom, 10)  // إضافة حشو بين الإيموجي والشرح
            }

            // عرض الوصف أسفل الإيموجي
            Text(card.cardDescription)
                .font(.system(size: 40))
                .padding(.top, 5)
                .multilineTextAlignment(.center)
                .lineLimit(3)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
        .padding(.bottom, 10)
        .frame(height: 300)
        .onTapGesture {
            // عند النقر على البطاقة، إذا كانت تحتوي على صوت، نقوم بتشغيله
            if let audioData = card.audioData {
                playAudio(from: audioData)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    private func playAudio(from data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
