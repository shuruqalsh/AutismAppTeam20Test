//
//  NewCard.swift
//  AutismAppTeam20
//
//  Created by Sumayah Alqahtani on 17/06/1446 AH.
//

//import SwiftUI
//import SwiftData
//
//struct NewCard: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File // مررنا الملف هنا
//    @State private var emoji: String = ""
//    @State private var description: String = ""
//    @Environment(\.dismiss) var dismiss  // دالة لإغلاق الـ sheet
//
//    var body: some View {
//        VStack {
//            // حقل إدخال الإيموجي
//            TextField("أدخل الإيموجي", text: $emoji)
//                .font(.largeTitle)
//                .multilineTextAlignment(.center)
//                .padding()
//
//            // حقل إدخال الوصف
//            TextField("أدخل الوصف", text: $description)
//                .font(.system(size: 30)) // التحكم بحجم الخط للوصف هنا
//                .disableAutocorrection(true)
//                .padding()
//
//            HStack {
//                // زر الحفظ
//                Button("حفظ") {
//                    if !emoji.isEmpty && !description.isEmpty {
//                        // إنشاء كارد جديد
//                        let newCard = Card(emoji: emoji, cardDescription: description)
//                        
//                        // إضافة الكارد إلى الملف
//                        file.cards.append(newCard)
//                        
//                        // إضافة الكارد إلى الـ modelContext
//                        modelContext.insert(newCard)
//                        
//                        // حفظ التغييرات في الـ modelContext
//                        do {
//                            try modelContext.save()
//                            
//                            // بعد حفظ الكارد، نعيد تعيين القيم المدخلة
//                            emoji = ""
//                            description = ""
//                            dismiss()  // إغلاق الـ sheet بعد الحفظ
//                        } catch {
//                            print("Error saving card: \(error.localizedDescription)")
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//                // زر الإلغاء
//                Button("إلغاء") {
//                    // إعادة تعيين الحقول
//                    emoji = ""
//                    description = ""
//                    dismiss()  // إغلاق الـ sheet عند الإلغاء
//                }
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding(.top, 20)
//
//            Spacer()
//        }
//        .padding()
//        .environment(\.layoutDirection, .rightToLeft) // تعيين اتجاه الكتابة من اليمين لليسار
//    }
//}

//import SwiftUI
//import SwiftData
//import PhotosUI
//
//struct NewCard: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File
//    @State private var emoji: String? = nil  // جعل الإيموجي اختياريًا
//    @State private var description: String = ""
//    @State private var imageData: Data? = nil
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var showingImagePicker = false
//    @State private var selectedItem: PhotosPickerItem? = nil
//
//    var body: some View {
//        VStack {
//            // عرض الصورة إذا تم اختيارها
//            if let imageData, let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
//                    .padding(.bottom, 10)
//            }
//
//            // زر لاختيار صورة
//            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
//                Text("اختار صورة")
//            }
//            .onChange(of: selectedItem) { newItem in
//                Task {
//                    if let selectedItem, let data = try? await selectedItem.loadTransferable(type: Data.self) {
//                        imageData = data
//                    }
//                }
//            }
//
//            // حقل إدخال الإيموجي (اختياري)
//            TextField("أدخل الإيموجي (اختياري)", text: Binding(
//                get: { emoji ?? "" },
//                set: { emoji = $0.isEmpty ? nil : $0 }
//            ))
//            .font(.largeTitle)
//            .multilineTextAlignment(.center)
//            .padding()
//
//            // حقل إدخال الوصف
//            TextField("أدخل الوصف", text: $description)
//                .font(.system(size: 30))
//                .disableAutocorrection(true)
//                .padding()
//
//            HStack {
//                // زر الحفظ
//                Button("حفظ") {
//                    if !description.isEmpty {
//                        let newCard = Card(emoji: emoji, cardDescription: description, imageData: imageData)
//                        file.cards.append(newCard)
//                        modelContext.insert(newCard)
//                        do {
//                            try modelContext.save()
//                            emoji = nil
//                            description = ""
//                            dismiss()
//                        } catch {
//                            print("Error saving card: \(error.localizedDescription)")
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//                Button("إلغاء") {
//                    emoji = nil
//                    description = ""
//                    dismiss()
//                }
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding(.top, 20)
//            
//            Spacer()
//        }
//        .padding()
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}

//import SwiftUI
//import SwiftData
//import PhotosUI

//struct NewCard: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File
//    @State private var emoji: String? = nil  // جعل الإيموجي اختياريًا
//    @State private var description: String = ""
//    @State private var imageData: Data? = nil
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var showingImagePicker = false
//    @State private var selectedItem: PhotosPickerItem? = nil
//
//    var body: some View {
//        VStack {
//            // نص توجيهي
//            Text("يمكنك إضافة إما إيموجي أو صورة (أحدهما يكفي).")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.top)
//
//            // عرض الصورة إذا تم اختيارها
//            if let imageData, let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
//                    .padding(.bottom, 10)
//            }
//
//            // زر لاختيار صورة
//            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
//                Text("اختار صورة")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(width: 200)  // عرض ثابت للأزرار
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                    .padding(.bottom, 10)
//            }
//            .onChange(of: selectedItem) { newItem in
//                Task {
//                    if let selectedItem, let data = try? await selectedItem.loadTransferable(type: Data.self) {
//                        imageData = data
//                    }
//                }
//            }
//
//            // حقل إدخال الإيموجي (اختياري)
//            TextField("أدخل الإيموجي (اختياري)", text: Binding(
//                get: { emoji ?? "" },
//                set: { emoji = $0.isEmpty ? nil : $0 }
//            ))
//            .font(.largeTitle)
//            .multilineTextAlignment(.center)
//            .padding()
//
//            // حقل إدخال الوصف
//            TextField("أدخل الوصف", text: $description)
//                .font(.system(size: 30))
//                .disableAutocorrection(true)
//                .padding()
//
//            HStack {
//                // زر الحفظ
//                Button("حفظ") {
//                    if !description.isEmpty {
//                        let newCard = Card(emoji: emoji, cardDescription: description, imageData: imageData)
//                        file.cards.append(newCard)
//                        modelContext.insert(newCard)
//                        do {
//                            try modelContext.save()
//                            emoji = nil
//                            description = ""
//                            dismiss()
//                        } catch {
//                            print("Error saving card: \(error.localizedDescription)")
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//                Button("إلغاء") {
//                    emoji = nil
//                    description = ""
//                    dismiss()
//                }
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding(.top, 20)
//            
//            Spacer()
//        }
//        .padding()
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//import AVFoundation

//struct NewCard: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File
//    @State private var emoji: String? = nil
//    @State private var description: String = ""
//    @State private var imageData: Data? = nil
//    @State private var audioData: Data? = nil  // لتخزين بيانات الصوت
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var showingImagePicker = false
//    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var isRecording = false  // حالة لتتبع إذا كنا في وضع التسجيل
//    @State private var audioRecorder: AVAudioRecorder?  // لتسجيل الصوت
//    @State private var audioFileURL: URL?  // لحفظ المسار الخاص بالملف الصوتي
//
//    var body: some View {
//        VStack {
//            Text("يمكنك إضافة إما إيموجي أو صورة أو تسجيل صوت (أحدهما يكفي).")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.top)
//
//            if let imageData, let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
//                    .padding(.bottom, 10)
//            }
//
//            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
//                Text("اختار صورة")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(width: 200)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                    .padding(.bottom, 10)
//            }
//            .onChange(of: selectedItem) { newItem in
//                Task {
//                    if let selectedItem, let data = try? await selectedItem.loadTransferable(type: Data.self) {
//                        imageData = data
//                    }
//                }
//            }
//
//            TextField("أدخل الإيموجي (اختياري)", text: Binding(
//                get: { emoji ?? "" },
//                set: { emoji = $0.isEmpty ? nil : $0 }
//            ))
//            .font(.largeTitle)
//            .multilineTextAlignment(.center)
//            .padding()
//
//            TextField("أدخل الوصف", text: $description)
//                .font(.system(size: 30))
//                .disableAutocorrection(true)
//                .padding()
//
//            // زر التسجيل الصوتي
//            Button(action: {
//                toggleRecording()
//            }) {
//                Text(isRecording ? "إيقاف التسجيل" : "ابدأ التسجيل")
//                    .padding()
//                    .background(isRecording ? Color.red : Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//
//            HStack {
//                Button("حفظ") {
//                    if !description.isEmpty {
//                        let newCard = Card(emoji: emoji, cardDescription: description, imageData: imageData, audioData: audioData)
//                        file.cards.append(newCard)
//                        modelContext.insert(newCard)
//                        do {
//                            try modelContext.save()
//                            emoji = nil
//                            description = ""
//                            dismiss()
//                        } catch {
//                            print("Error saving card: \(error.localizedDescription)")
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//                Button("إلغاء") {
//                    emoji = nil
//                    description = ""
//                    dismiss()
//                }
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding(.top, 20)
//            
//            Spacer()
//        }
//        .padding()
//        .onAppear {
//            prepareAudioSession()
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//    
//    private func prepareAudioSession() {
//        let session = AVAudioSession.sharedInstance()
//        do {
//            try session.setCategory(.playAndRecord, mode: .default)
//            try session.setActive(true)
//        } catch {
//            print("Error setting up audio session: \(error.localizedDescription)")
//        }
//    }
//
//    private func toggleRecording() {
//        if isRecording {
//            stopRecording()
//        } else {
//            startRecording()
//        }
//    }
//
//    private func startRecording() {
//        let fileName = UUID().uuidString + ".m4a"
//        let directoryURL = FileManager.default.temporaryDirectory
//        audioFileURL = directoryURL.appendingPathComponent(fileName)
//        
//        let settings: [String: Any] = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//        
//        do {
//            audioRecorder = try AVAudioRecorder(url: audioFileURL!, settings: settings)
//            audioRecorder?.record()
//            isRecording = true
//        } catch {
//            print("Error starting recording: \(error.localizedDescription)")
//        }
//    }
//
//    private func stopRecording() {
//        audioRecorder?.stop()
//        isRecording = false
//        
//        // بعد إيقاف التسجيل، نقوم بحفظ الصوت كبيانات
//        if let audioFileURL = audioFileURL {
//            do {
//                let audioData = try Data(contentsOf: audioFileURL)
//                self.audioData = audioData
//            } catch {
//                print("Error loading recorded audio: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//import SwiftUI
//import SwiftData
//import PhotosUI
//import AVFoundation
//
//struct NewCard: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File
//    @State private var emoji: String? = nil
//    @State private var description: String = ""
//    @State private var imageData: Data? = nil
//    @State private var audioData: Data? = nil  // لتخزين بيانات الصوت
//    @Environment(\.dismiss) var dismiss
//
//    @State private var showingImagePicker = false
//    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var isRecording = false  // حالة لتتبع إذا كنا في وضع التسجيل
//    @State private var isPlaying = false  // حالة لتتبع إذا كان الصوت قيد التشغيل
//    @State private var audioPlayer: AVPlayer?  // لتشغيل الصوت
//    @State private var audioRecorder: AVAudioRecorder?  // لتسجيل الصوت
//    @State private var audioFileURL: URL?  // لحفظ المسار الخاص بالملف الصوتي
//
//    var body: some View {
//        VStack {
//            Text("يمكنك إضافة إما إيموجي أو صورة أو تسجيل صوت (أحدهما يكفي).")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.top)
//
//            // عرض الصورة إذا كانت موجودة
//            if let imageData, let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
//                    .padding(.bottom, 10)
//            }
//
//            // اختيار صورة جديدة
//            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
//                Text("اختار صورة")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(width: 200)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                    .padding(.bottom, 10)
//            }
//            .onChange(of: selectedItem) { newItem in
//                Task {
//                    if let selectedItem, let data = try? await selectedItem.loadTransferable(type: Data.self) {
//                        imageData = data
//                    }
//                }
//            }
//
//            // حقل إدخال الإيموجي (اختياري)
//            TextField("أدخل الإيموجي (اختياري)", text: Binding(
//                get: { emoji ?? "" },
//                set: { emoji = $0.isEmpty ? nil : $0 }
//            ))
//            .font(.largeTitle)
//            .multilineTextAlignment(.center)
//            .padding()
//
//            // حقل إدخال الوصف
//            TextField("أدخل الوصف", text: $description)
//                .font(.system(size: 30))
//                .disableAutocorrection(true)
//                .padding()
//
//            // زر التسجيل الصوتي
//            Button(action: {
//                toggleRecording()
//            }) {
//                Text(isRecording ? "إيقاف التسجيل" : "ابدأ التسجيل")
//                    .padding()
//                    .background(isRecording ? Color.red : Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//
//            // زر معاينة الصوت
//            if let audioData, !audioData.isEmpty {
//                Button(action: {
//                    toggleAudioPlayback()
//                }) {
//                    Text(isPlaying ? "إيقاف المعاينة" : "معاينة الصوت")
//                        .padding()
//                        .background(isPlaying ? Color.red : Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding(.top)
//            }
//
//            // الأزرار لحفظ أو إلغاء
//            HStack {
//                Button("حفظ") {
//                    if !description.isEmpty {
//                        let newCard = Card(emoji: emoji, cardDescription: description, imageData: imageData, audioData: audioData)
//                        file.cards.append(newCard)
//                        modelContext.insert(newCard)
//                        do {
//                            try modelContext.save()
//                            emoji = nil
//                            description = ""
//                            dismiss()
//                        } catch {
//                            print("Error saving card: \(error.localizedDescription)")
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//                Button("إلغاء") {
//                    emoji = nil
//                    description = ""
//                    dismiss()
//                }
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding(.top, 20)
//
//            Spacer()
//        }
//        .padding()
//        .onAppear {
//            prepareAudioSession()
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//
//    // تحضير الجلسة الصوتية
//    private func prepareAudioSession() {
//        let session = AVAudioSession.sharedInstance()
//        do {
//            try session.setCategory(.playAndRecord, mode: .default)
//            try session.setActive(true)
//        } catch {
//            print("Error setting up audio session: \(error.localizedDescription)")
//        }
//    }
//
//    // بدء أو إيقاف التسجيل
//    private func toggleRecording() {
//        if isRecording {
//            stopRecording()
//        } else {
//            startRecording()
//        }
//    }
//
//    // بدء التسجيل
//    private func startRecording() {
//        let fileName = UUID().uuidString + ".m4a"
//        let directoryURL = FileManager.default.temporaryDirectory
//        audioFileURL = directoryURL.appendingPathComponent(fileName)
//
//        let settings: [String: Any] = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//
//        do {
//            audioRecorder = try AVAudioRecorder(url: audioFileURL!, settings: settings)
//            audioRecorder?.record()
//            isRecording = true
//        } catch {
//            print("Error starting recording: \(error.localizedDescription)")
//        }
//    }
//
//    // إيقاف التسجيل
//    private func stopRecording() {
//        audioRecorder?.stop()
//        isRecording = false
//
//        // بعد إيقاف التسجيل، نقوم بحفظ الصوت كبيانات
//        if let audioFileURL = audioFileURL {
//            do {
//                let audioData = try Data(contentsOf: audioFileURL)
//                self.audioData = audioData
//            } catch {
//                print("Error loading recorded audio: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    // تشغيل أو إيقاف المعاينة الصوتية
//    private func toggleAudioPlayback() {
//        if isPlaying {
//            audioPlayer?.pause()
//            isPlaying = false
//        } else {
//            guard let audioData = audioData else { return }
//
//            // إنشاء ملف مؤقت لتخزين بيانات الصوت
//            let tempDirectory = FileManager.default.temporaryDirectory
//            let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".m4a")
//            
//            do {
//                // كتابة البيانات الصوتية إلى الملف المؤقت
//                try audioData.write(to: tempFileURL)
//                
//                // إنشاء AVPlayerItem من الملف المؤقت
//                let playerItem = AVPlayerItem(url: tempFileURL)
//                audioPlayer = AVPlayer(playerItem: playerItem)
//                audioPlayer?.play()
//                isPlaying = true
//            } catch {
//                print("Error writing audio data to file: \(error.localizedDescription)")
//            }
//        }
//    }
//}
import SwiftUI
import SwiftData
import PhotosUI
import AVFoundation
import MobileCoreServices

struct NewCard: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var file: File
    @State private var emoji: String? = nil
    @State private var description: String = ""
    @State private var imageData: Data? = nil
    @State private var audioData: Data? = nil  // لتخزين بيانات الصوت
    @Environment(\.dismiss) var dismiss

    @State private var showingImagePicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isRecording = false  // حالة لتتبع إذا كنا في وضع التسجيل
    @State private var isPlaying = false  // حالة لتتبع إذا كان الصوت قيد التشغيل
    @State private var audioPlayer: AVPlayer?  // لتشغيل الصوت
    @State private var audioRecorder: AVAudioRecorder?  // لتسجيل الصوت
    @State private var audioFileURL: URL?  // لحفظ المسار الخاص بالملف الصوتي
    @State private var showDocumentPicker = false  // لإظهار مستعرض الملفات لاختيار الصوت

    var body: some View {
        VStack {
            Text("يمكنك إضافة إما إيموجي أو صورة أو تسجيل صوت (أو اختيار صوت من جهازك).")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top)

            // عرض الصورة إذا كانت موجودة
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
            }

            // اختيار صورة جديدة
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("اختار صورة")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let selectedItem, let data = try? await selectedItem.loadTransferable(type: Data.self) {
                        imageData = data
                    }
                }
            }

            // حقل إدخال الإيموجي (اختياري)
            TextField("أدخل الإيموجي (اختياري)", text: Binding(
                get: { emoji ?? "" },
                set: { emoji = $0.isEmpty ? nil : $0 }
            ))
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()

            // حقل إدخال الوصف
            TextField("أدخل الوصف", text: $description)
                .font(.system(size: 30))
                .disableAutocorrection(true)
                .padding()

            // زر التسجيل الصوتي
            Button(action: {
                toggleRecording()
            }) {
                Text(isRecording ? "إيقاف التسجيل" : "ابدأ التسجيل")
                    .padding()
                    .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // زر معاينة الصوت
            if let audioData, !audioData.isEmpty {
                Button(action: {
                    toggleAudioPlayback()
                }) {
                    Text(isPlaying ? "إيقاف المعاينة" : "معاينة الصوت")
                        .padding()
                        .background(isPlaying ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }

            // زر لاختيار صوت من الجهاز
            Button(action: {
                showDocumentPicker = true
            }) {
                Text("اختار صوت من جهازك")
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)

            // الأزرار لحفظ أو إلغاء
            HStack {
                Button("حفظ") {
                    if !description.isEmpty {
                        let newCard = Card(emoji: emoji, cardDescription: description, imageData: imageData, audioData: audioData)
                        file.cards.append(newCard)
                        modelContext.insert(newCard)
                        do {
                            try modelContext.save()
                            emoji = nil
                            description = ""
                            dismiss()
                        } catch {
                            print("Error saving card: \(error.localizedDescription)")
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("إلغاء") {
                    emoji = nil
                    description = ""
                    dismiss()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .onAppear {
            prepareAudioSession()
        }
        .environment(\.layoutDirection, .rightToLeft)
        .fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.audio]) { result in
            switch result {
            case .success(let url):
                loadAudioFile(from: url)
            case .failure(let error):
                print("Error picking audio file: \(error.localizedDescription)")
            }
        }
    }

    // تحضير الجلسة الصوتية
    private func prepareAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }

    // بدء أو إيقاف التسجيل
    private func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    // بدء التسجيل
    private func startRecording() {
        let fileName = UUID().uuidString + ".m4a"
        let directoryURL = FileManager.default.temporaryDirectory
        audioFileURL = directoryURL.appendingPathComponent(fileName)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL!, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }

    // إيقاف التسجيل
    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false

        // بعد إيقاف التسجيل، نقوم بحفظ الصوت كبيانات
        if let audioFileURL = audioFileURL {
            do {
                let audioData = try Data(contentsOf: audioFileURL)
                self.audioData = audioData
            } catch {
                print("Error loading recorded audio: \(error.localizedDescription)")
            }
        }
    }

    // تشغيل أو إيقاف المعاينة الصوتية
    private func toggleAudioPlayback() {
        if isPlaying {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            guard let audioData = audioData else { return }

            // إنشاء ملف مؤقت لتخزين بيانات الصوت
            let tempDirectory = FileManager.default.temporaryDirectory
            let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".m4a")
            
            do {
                // كتابة البيانات الصوتية إلى الملف المؤقت
                try audioData.write(to: tempFileURL)
                
                // إنشاء AVPlayerItem من الملف المؤقت
                let playerItem = AVPlayerItem(url: tempFileURL)
                audioPlayer = AVPlayer(playerItem: playerItem)
                audioPlayer?.play()
                isPlaying = true
            } catch {
                print("Error writing audio data to file: \(error.localizedDescription)")
            }
        }
    }

    // تحميل ملف الصوت من الجهاز
    private func loadAudioFile(from url: URL) {
        do {
            // قراءة بيانات الصوت من الملف
            let audioData = try Data(contentsOf: url)
            self.audioData = audioData
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
}
