//
//  EditCard.swift
//  AutismAppTeam20
//
//  Created by Sumayah Alqahtani on 22/06/1446 AH.
//

//import SwiftUI
//
//struct EditCard: View {
//    @Environment(\.modelContext) private var modelContext
//    @State private var emoji: String
//    @State private var description: String
//    var card: Card
//    var onSave: (Card) -> Void  // Closure لتمرير التغييرات
//
//    init(card: Card, onSave: @escaping (Card) -> Void) {
//        _emoji = State(initialValue: card.emoji)
//        _description = State(initialValue: card.cardDescription)
//        self.card = card
//        self.onSave = onSave
//    }
//
//    var body: some View {
//        VStack {
//            TextField("أدخل الإيموجي", text: $emoji)  // حقل إدخال الإيموجي
//                .font(.largeTitle)
//                .multilineTextAlignment(.center)
//                .padding()
//
//            TextField("أدخل الوصف", text: $description)  // حقل إدخال الوصف
//                .font(.system(size: 30)) // التحكم بحجم الخط للوصف هنا
//                .disableAutocorrection(true)
//                .padding()
//
//            Button("حفظ") {
//                if !emoji.isEmpty && !description.isEmpty {
//                    // تحديث البطاقة
//                    card.emoji = emoji
//                    card.cardDescription = description
//                    
//                    // حفظ التغييرات في الـ modelContext
//                    do {
//                        try modelContext.save()
//                        onSave(card)  // تمرير البطاقة المعدلة إلى الـ parent view
//                    } catch {
//                        print("Error saving card: \(error.localizedDescription)")
//                    }
//                }
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//
//            Spacer()
//        }
//        .padding()
//        .environment(\.layoutDirection, .rightToLeft)  // محاذاة من اليمين لليسار
//    }
//}
//import SwiftUI
//import PhotosUI
//
//struct EditCard: View {
//    @Environment(\.modelContext) private var modelContext
//    @State private var emoji: String?  // جعل الإيموجي اختياريًا
//    @State private var description: String
//    @State private var imageData: Data?
//    var card: Card
//    var onSave: (Card) -> Void
//
//    @State private var selectedItem: PhotosPickerItem? = nil
//
//    init(card: Card, onSave: @escaping (Card) -> Void) {
//        _emoji = State(initialValue: card.emoji)
//        _description = State(initialValue: card.cardDescription)
//        _imageData = State(initialValue: card.imageData)
//        self.card = card
//        self.onSave = onSave
//    }
//
//    var body: some View {
//        VStack {
//            // عرض الصورة الحالية في الأعلى إذا كانت موجودة
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
//                Text("اختار صورة جديدة")
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
//            Button("حفظ") {
//                if !description.isEmpty {
//                    card.emoji = emoji
//                    card.cardDescription = description
//                    card.imageData = imageData
//                    
//                    do {
//                        try modelContext.save()
//                        onSave(card)
//                    } catch {
//                        print("Error saving card: \(error.localizedDescription)")
//                    }
//                }
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//            
//            Spacer()
//        }
//        .padding()
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//import SwiftUI
//import PhotosUI
//import AVFoundation
//
//struct EditCard: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss  // لإغلاق الـ sheet
//    @State private var emoji: String?  // جعل الإيموجي اختياريًا
//    @State private var description: String
//    @State private var imageData: Data?
//    @State private var audioData: Data?  // لتخزين بيانات الصوت
//    var card: Card
//    var onSave: (Card) -> Void
//
//    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var isRecording = false  // لتتبع حالة التسجيل
//    @State private var audioRecorder: AVAudioRecorder?  // لتسجيل الصوت
//    @State private var audioFileURL: URL?  // لتخزين مسار الملف الصوتي
//
//    init(card: Card, onSave: @escaping (Card) -> Void) {
//        _emoji = State(initialValue: card.emoji)
//        _description = State(initialValue: card.cardDescription)
//        _imageData = State(initialValue: card.imageData)
//        _audioData = State(initialValue: card.audioData)  // لتحديد الصوت من البطاقة الحالية
//        self.card = card
//        self.onSave = onSave
//    }
//
//    var body: some View {
//        VStack {
//            // نص توجيهي
//            Text("يمكنك إضافة إما إيموجي أو صورة أو تسجيل صوت (أحدهما يكفي).")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.top)
//
//            // عرض الصورة الحالية إذا كانت موجودة
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
//                Text("اختار صورة جديدة")
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
//            .padding(.top)
//
//            // زر حفظ
//            Button("حفظ") {
//                if !description.isEmpty {
//                    card.emoji = emoji
//                    card.cardDescription = description
//                    card.imageData = imageData
//                    card.audioData = audioData  // حفظ بيانات الصوت في البطاقة
//                    
//                    do {
//                        try modelContext.save()
//                        onSave(card)
//                        dismiss()  // إغلاق الـ sheet بعد الحفظ
//                    } catch {
//                        print("Error saving card: \(error.localizedDescription)")
//                    }
//                }
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(10)
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
//}

//import SwiftUI
//import PhotosUI
//import AVFoundation
//
//struct EditCard: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss  // لإغلاق الـ sheet
//    @State private var emoji: String?  // جعل الإيموجي اختياريًا
//    @State private var description: String
//    @State private var imageData: Data?
//    @State private var audioData: Data?  // لتخزين بيانات الصوت
//    var card: Card
//    var onSave: (Card) -> Void
//
//    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var isRecording = false  // لتتبع حالة التسجيل
//    @State private var audioRecorder: AVAudioRecorder?  // لتسجيل الصوت
//    @State private var audioFileURL: URL?  // لتخزين مسار الملف الصوتي
//    @State private var audioPlayer: AVPlayer?  // لتشغيل الصوت
//    @State private var isPlaying = false  // حالة تشغيل الصوت
//
//    init(card: Card, onSave: @escaping (Card) -> Void) {
//        _emoji = State(initialValue: card.emoji)
//        _description = State(initialValue: card.cardDescription)
//        _imageData = State(initialValue: card.imageData)
//        _audioData = State(initialValue: card.audioData)  // لتحديد الصوت من البطاقة الحالية
//        self.card = card
//        self.onSave = onSave
//    }
//
//    var body: some View {
//        VStack {
//            // نص توجيهي
//            Text("يمكنك إضافة إما إيموجي أو صورة أو تسجيل صوت (أحدهما يكفي).")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.top)
//
//            // عرض الصورة الحالية إذا كانت موجودة
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
//                Text("اختار صورة جديدة")
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
//            .padding(.top)
//
//            // زر معاينة الصوت
//            if let audioData, !isRecording {
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
//            // زر حفظ
//            Button("حفظ") {
//                if !description.isEmpty {
//                    card.emoji = emoji
//                    card.cardDescription = description
//                    card.imageData = imageData
//                    card.audioData = audioData  // حفظ بيانات الصوت في البطاقة
//                    
//                    do {
//                        try modelContext.save()
//                        onSave(card)
//                        dismiss()  // إغلاق الـ sheet بعد الحفظ
//                    } catch {
//                        print("Error saving card: \(error.localizedDescription)")
//                    }
//                }
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(10)
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
//    // تشغيل أو إيقاف الصوت
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
import PhotosUI
import AVFoundation
import MobileCoreServices

struct EditCard: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss  // لإغلاق الـ sheet
    @State private var emoji: String?  // جعل الإيموجي اختياريًا
    @State private var description: String
    @State private var imageData: Data?
    @State private var audioData: Data?  // لتخزين بيانات الصوت
    var card: Card
    var onSave: (Card) -> Void

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isRecording = false  // لتتبع حالة التسجيل
    @State private var audioRecorder: AVAudioRecorder?  // لتسجيل الصوت
    @State private var audioFileURL: URL?  // لتخزين مسار الملف الصوتي
    @State private var audioPlayer: AVPlayer?  // لتشغيل الصوت
    @State private var isPlaying = false  // حالة تشغيل الصوت
    @State private var showDocumentPicker = false  // لإظهار مستعرض الملفات لاختيار الصوت

    init(card: Card, onSave: @escaping (Card) -> Void) {
        _emoji = State(initialValue: card.emoji)
        _description = State(initialValue: card.cardDescription)
        _imageData = State(initialValue: card.imageData)
        _audioData = State(initialValue: card.audioData)  // لتحديد الصوت من البطاقة الحالية
        self.card = card
        self.onSave = onSave
    }

    var body: some View {
        VStack {
            // نص توجيهي
            Text("يمكنك إضافة إما إيموجي أو صورة أو تسجيل صوت (أو اختيار صوت من جهازك).")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top)

            // عرض الصورة الحالية إذا كانت موجودة
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
            }

            // اختيار صورة جديدة
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("اختار صورة جديدة")
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
            .padding(.top)

            // زر معاينة الصوت
            if let audioData, !isRecording {
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

            // زر حفظ
            Button("حفظ") {
                if !description.isEmpty {
                    card.emoji = emoji
                    card.cardDescription = description
                    card.imageData = imageData
                    card.audioData = audioData  // حفظ بيانات الصوت في البطاقة
                    
                    do {
                        try modelContext.save()
                        onSave(card)
                        dismiss()  // إغلاق الـ sheet بعد الحفظ
                    } catch {
                        print("Error saving card: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

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

    // تشغيل أو إيقاف الصوت
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
