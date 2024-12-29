
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
    @State private var selectedFile: File? = nil  // لتخزين الملف المحدد أثناء الضغط المطول
    @State private var showPasswordPrompt = false  // عرض نافذة إدخال الرقم السري
    @State private var password = ""  // الرقم السري المدخل
    @State private var passwordError = false  // حالة لتحديد إذا كان الرقم السري خاطئًا
    @State private var showPassword = false  // التحكم في إظهار/إخفاء كلمة المرور

    let correctPassword = "1234"  // الرقم السري الصحيح (يمكن تغييره إلى أي شيء آخر)

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // تعيين الصورة كخلفية
                Color(hex: "#FFF6E8") // هنا تضع كود الهيكس الذي تريده
                    .ignoresSafeArea()  // لتغطية كامل الشاشة

                
                VStack {
                    
                    // Content Section
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach($files) { $file in
                                VStack {
                                    // Link to CardsListScreen
                                    NavigationLink(destination: CardsListScreen(file: $file)) {
                                        FileView(file: file)  // عرض الملف
                                            .padding()
                                    }

                                    Button(action: {
                                        withAnimation {
                                            // عند الضغط على الزر، نعرض نافذة الرقم السري
                                            if selectedFile == file {
                                                selectedFile = nil  // إخفاء الأزرار إذا كانت ظاهرة
                                            } else {
                                                showPasswordPrompt = true  // إظهار نافذة إدخال الرقم السري
                                                password = ""  // إعادة تعيين الرقم السري إلى فارغ
                                                fileToEdit = file  // تعيين الملف الذي سيتم التعامل معه
                                            }
                                        }
                                    }) {
                                        Image("􀌆") // استبدال "yourImageName" باسم الصورة الموجودة في أصول مشروعك
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)

                                    }

                                    
                                    // عرض الأزرار أسفل الملف فقط إذا كان الرقم السري صحيحًا
                                    if selectedFile == file {
                                        HStack(spacing: 20) {
                                            // زر تعديل
                                            Button(action: {
                                                fileToEdit = file
                                                showingEditFileSheet.toggle()  // إظهار نافذة التعديل
                                            }) {
                                                Image(systemName: "pencil")
                                                    .font(.system(size: 22, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .padding(12)
                                                    .background(Color.blue)
                                                    .clipShape(Circle())
                                            }
                                            .frame(width: 44, height: 44)
                                            
                                            // زر حذف
                                            Button(action: {
                                                fileToDelete = file
                                                showingDeleteConfirmation = true  // إظهار التنبيه للحذف
                                            }) {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 22, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .padding(12)
                                                    .background(Color.red)
                                                    .clipShape(Circle())
                                            }
                                            .frame(width: 44, height: 44)
                                        }
                                        .padding(.top, 8)  // مسافة بين الملف والأزرار
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .onAppear {
                    loadFiles()  // إعادة تحميل الملفات عند ظهور الشاشة
                }
                // نافذة تعديل الملف
                .sheet(isPresented: $showingEditFileSheet) {
                    if let fileToEdit = fileToEdit {
                        EditFile(file: fileToEdit) { updatedFile in
                            if let index = files.firstIndex(where: { $0.id == updatedFile.id }) {
                                files[index] = updatedFile  // تحديث الملف في القائمة
                            }
                        }
                    }
                }
                // التنبيه الذي يطلب تأكيد الحذف
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
                // نافذة إدخال الرقم السري
                .sheet(isPresented: $showPasswordPrompt) {
                    VStack(spacing: 20) {
                        Text("أدخل الرقم السري")
                            .font(.headline)
                        
                        // حقل النص الذي يمكن رؤية الباسورد فيه
                        HStack {
                            if showPassword {
                                TextField("الرقم السري", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .multilineTextAlignment(.center)  // نص في المنتصف
                                    .padding(.horizontal)
                            } else {
                                SecureField("الرقم السري", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .multilineTextAlignment(.center)  // نص في المنتصف
                                    .padding(.horizontal)
                            }
                        }
                        
                        if passwordError {
                            Text("الرقم السري غير صحيح.")
                                .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            // تحقق من الرقم السري
                            if password == correctPassword {
                                selectedFile = fileToEdit  // إذا كان الرقم السري صحيحًا، نعرض الأزرار
                                showPasswordPrompt = false  // إغلاق نافذة الرقم السري
                            } else {
                                passwordError = true  // الرقم السري خاطئ
                            }
                        }) {
                            Text("تأكيد")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        // زر للتبديل بين إظهار وإخفاء كلمة المرور
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Text(showPassword ? "إخفاء الرقم السري" : "إظهار الرقم السري")
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
                // تخصيص شريط التنقل
                .toolbar {
                    // زر ملف جديد على اليسار مع المسافة الآمنة
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            showingNewFileSheet.toggle()
                        }) {
                            Image("addCardImageHome")  // استخدم الصورة من الـ Assets
                                .padding(.top, 20)
                                .padding()
              
                        }
                    }

                    
                    // العنوان "ملفات" في المنتصف مع تكبير الخط وإضافة مسافة فوقه
                    ToolbarItem(placement: .principal) {
                        Text("ملفات")
                            .font(.largeTitle)  // تكبير النص ليكون عنوانًا أكبر
                            .fontWeight(.bold)  // جعل كلمة "ملفات" بالخط العريض
                            .foregroundColor(.primary)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .center) // محاذاة العنوان في المنتصف
                    }
                }
                .sheet(isPresented: $showingNewFileSheet) {
                    NewFile(files: $files)
                }
                .environment(\.layoutDirection, .rightToLeft) // محاذاة الواجهة من اليمين لليسار
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
}

