    import SwiftUI
    import SwiftData

    struct FilesScreen: View {
        @Environment(\.modelContext) private var modelContext
        @State private var files: [File] = []
        @State private var showingNewFileSheet = false
        @State private var showingEditFileSheet = false
        @State private var fileToEdit: File?
        @State private var showingDeleteConfirmation = false
        @State private var fileToDelete: File?
        @State private var showPasswordPrompt = false
        @State private var password = ""
        @State private var passwordError = false
        @State private var showPassword = false
        @State private var isPasswordCorrect = false
        @State private var isEditingMode = false
        

        @State private var selectedFile: File? = nil
      
        @State private var currentPage: Int = 0  // الصفحة الحالية
        @State private var showButtonsForFile: File?  // الملف الذي تظهر له الأزرار
        

        @FocusState private var focusedField: Int? // هذا سيتحكم في التركيز بين الحقول
        
        let correctPassword = "1234"
        
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        @State private var isPressed1 = false // حالة الزر الأول (Checkmark)
        @State private var isPressed2 = false // حالة الزر الثاني (Line)
        
        var body: some View {
            NavigationStack {
                ZStack {
                    
                    Color(hex: "#FFF6E8").ignoresSafeArea()
                    VStack{
                        Text("المكتبات")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        // إضافة مسافة من الأعلى
                    }
                    VStack{
                        
                        HStack{
                            
                            ZStack {
                                if isEditingMode {
                                    // زر التشيك مارك
                                    Image(systemName: "checkmark")
                                        .frame(width: 50, height: 50)
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(Color(hex: "#FFF6E8"))
                                        .background(Color(hex: "#FFC967"))
                                        .cornerRadius(43)
                                        .onTapGesture {
                                            // الضغط العادي فقط لزر التشيك مارك
                                            if isEditingMode {
                                                isEditingMode = false
                                            } else {
                                                showPasswordPrompt = true
                                            }
                                        }
                                } else {
                                    // زر اللاين مع الضغط المطول
                                    Image("Line")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .onLongPressGesture(minimumDuration: 1.0) {
                                            // الضغط المطول فقط لزر الـ Line
                                            print("Long press on Line")
                                            
                                            // إظهار نافذة الرقم السري عند الضغط المطول على زر اللاين
                                            showPasswordPrompt = true  // هذا متغير لتحديد ما إذا كان يجب عرض نافذة الرقم السري
                                        }
                                        .onTapGesture {
                                            // إذا أردت إضافة أي إجراء عند الضغط العادي على اللاين يمكن إضافته هنا
                                        }
                                }
                            }
                            .padding()


                            Spacer() // المسافة بين الأزرار

                            ZStack {
                                Image("plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .onLongPressGesture(minimumDuration: 1.0) { // الضغط المطول لمدة ثانية واحدة لزر plus
                                        // تفعيل الـ sheet عند الضغط المطول
                                        showingNewFileSheet.toggle()
                                    }
                            }
                            .padding()
                            .padding(.top, 10)
                            .sheet(isPresented: $showingNewFileSheet) {
                                NewFile(files: $files)
                            }

                        }
                        TabView(selection: $currentPage) {
                                      ForEach(0..<splitFilesIntoPages().count, id: \.self) { index in
                                          let page = splitFilesIntoPages()[index]
                                          VStack {
                                              LazyVGrid(columns: columns, spacing: 16) {
                                                  ForEach(page, id: \.id) { file in
                                                      VStack {
                                                          ZStack {
                                                              NavigationLink(destination: CardsListScreen(file: .constant(file))) {
                                                                  FileView(file: file)
                                                                      .padding(.bottom, 16)
                                                              }
                                                              if isEditingMode {
                                                                  HStack(spacing: 20) {
                                                                      Button(action: {
                                                                          fileToEdit = file
                                                                          showingEditFileSheet.toggle()
                                                                      }) {
                                                                          Image(systemName: "pencil")
                                                                              .font(.system(size: 22, weight: .bold))
                                                                              .foregroundColor(.white)
                                                                              .padding(12)
                                                                              .background(Color.blue)
                                                                              .clipShape(Circle())
                                                                      }
                                                                      Button(action: {
                                                                          fileToDelete = file
                                                                          showingDeleteConfirmation = true
                                                                      }) {
                                                                          Image(systemName: "trash")
                                                                              .font(.system(size: 22, weight: .bold))
                                                                              .foregroundColor(.white)
                                                                              .padding(12)
                                                                              .background(Color.red)
                                                                              .clipShape(Circle())
                                                                      }
                                                                  }
                                                              }
                                                          }
                                                      }
                                                  }
                                              }
                                              .padding()
                                          }
                                          .tag(index)
                                      }
                                  }
                                  .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                  .padding(.top)
                                  .onAppear {
                                      loadFiles()
                                  }

                                  HStack {
                                      ForEach(0..<splitFilesIntoPages().count, id: \.self) { index in
                                          Circle()
                                              .fill(index == currentPage ? Color.orange : Color.gray)
                                              .frame(width: 10, height: 10)
                                              .scaleEffect(index == currentPage ? 1.5 : 1)
                                              .animation(.spring(), value: currentPage)
                                              .onTapGesture {
                                                  currentPage = index
                                              }
                                      }
                                  }
                                  .padding(.top, 10)
                        
                        
                        .sheet(isPresented: $showingEditFileSheet) {
                            if let fileToEdit = fileToEdit {
                                EditFile(file: fileToEdit) { updatedFile in
                                    if let index = files.firstIndex(where: { $0.id == updatedFile.id }) {
                                        files[index] = updatedFile
                                    }
                                }
                            }
                        }
                        
                        .alert(isPresented: $showingDeleteConfirmation) {
                            Alert(
                                title: Text("هل أنت متأكد؟"),
                                message: Text("هل ترغب في حذف هذا الملف؟ هذه العملية لا يمكن التراجع عنها."),
                                primaryButton: .destructive(Text("حذف")) {
                                    if let fileToDelete = fileToDelete {
                                        deleteFile(fileToDelete)
                                    }
                                },
                                secondaryButton: .cancel(Text("إلغاء"))
                            )
                        }
                        
                        .sheet(isPresented: $showPasswordPrompt) {
                            ZStack {
                                Color(hex: "#FFF6E8").ignoresSafeArea()
                                
                                VStack {
                                    Image("IpadGirl")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 400, height: 240)
                                    
                                    Text("هنا يمكنكم اضافة بطاقات جديدة وتعديل بطاقاتكم!\nالرقم السري : 1234.")
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .font(.headline)
                                    
                                    TextField("أدخل الرقم السري", text: $password)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 200, height: 50)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                        .focused($focusedField, equals: 0)
                                        .onChange(of: password) { _ in
                                            if password.count > 4 {
                                                password = String(password.prefix(4))
                                            }
                                        }
                                        .foregroundColor(.black)
                                        .padding(.horizontal)
                                    
                                    if passwordError {
                                        Text("الرقم السري غير صحيح.")
                                            .foregroundColor(.red)
                                    }
                                    
                                    Button(action: {
                                        let enteredPassword = convertToEnglishDigits(password)
                                        
                                        if enteredPassword == correctPassword {
                                            isPasswordCorrect = true
                                            showPasswordPrompt = false
                                            isEditingMode = true
                                        } else {
                                            passwordError = true
                                        }
                                    }) {
                                        Text("تأكيد")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color(hex: "#FFC967"))
                                            .cornerRadius(10)
                                    }
                                    
                                    Text("الرقم السري يهدف لضمان عدم تعديل الإعدادات من قبل الطفل، مما يساعد في الحفاظ على استقرار التطبيق.")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(hex: "#4C4C4C"))
                                        .font(.headline)
                                }
                                .padding()
                            }
                        }

                    }
                }
            }
        }
        private func loadFiles() {
            do {
                let fetchDescriptor = FetchDescriptor<File>()
                let filesFetch = try modelContext.fetch(fetchDescriptor)
                files = filesFetch.sorted { $0.title < $1.title }
            } catch {
                print("Error loading files: \(error.localizedDescription)")
            }
        }

        private func deleteFile(_ file: File) {
            modelContext.delete(file)

            do {
                try modelContext.save()
                loadFiles()
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
            }
        }

        private func splitFilesIntoPages() -> [[File]] {
            var pages: [[File]] = []
            let chunkSize = 6
            for index in stride(from: 0, to: files.count, by: chunkSize) {
                let chunk = Array(files[index..<min(index + chunkSize, files.count)])
                pages.append(chunk)
            }
            return pages
        }

        private func convertToEnglishDigits(_ input: String) -> String {
            let arabicToEnglishMapping: [Character: Character] = [
                "٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4",
                "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9"
            ]
            return String(input.map { arabicToEnglishMapping[$0] ?? $0 })
        }
    }
    struct FilesScreen_Previews: PreviewProvider {
        static var previews: some View {
            FilesScreen()
                .previewDevice("iPhone 14")
                .previewLayout(.sizeThatFits)
        }
    }
