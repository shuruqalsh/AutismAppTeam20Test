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
                    .frame(height: 300)  // تحديد ارتفاع ثابت للصورة
//                   .padding(.bottom, 10)
            }

            // عرض الإيموجي فقط إذا كان موجودًا
          else if let emoji = card.emoji, !emoji.isEmpty {
                Text(emoji)
                    .font(.system(size: 200))
                    .padding(.bottom, 10)  // إضافة حشو بين الإيموجي والشرح
            }

            // عرض الوصف أسفل الإيموجي
            Text(card.cardDescription)
                .font(.system(size: 30))
                .foregroundColor(.black)
                .padding(.top, 5)
                .multilineTextAlignment(.center)
                .lineLimit(3)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
        .padding(.bottom, 10)
        .frame(height: 300)
        Spacer()
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
