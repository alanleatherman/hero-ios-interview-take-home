import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItem: PhotosPickerItem?
    
    let onImageSelected: (UIImage) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.Spacing.xl) {
                Spacer()
                
                Image(systemName: "camera.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Theme.Colors.primary)
                
                VStack(spacing: Theme.Spacing.md) {
                    Text("Select Photo")
                        .font(Theme.Typography.largeTitle)
                        .foregroundColor(.white)
                    
                    Text("Choose a photo to send")
                        .font(Theme.Typography.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Choose Photo")
                        .font(Theme.Typography.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .fill(Theme.Colors.primary)
                        )
                }
                .padding(.horizontal, Theme.Spacing.xl)
                
                Text("📱 In simulator: This will open the photo library")
                    .font(Theme.Typography.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, Theme.Spacing.xl)
                
                Spacer()
            }
            .background(Color.black)
            .navigationTitle("Send Photo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(Theme.Colors.primary)
            )
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let newItem = newItem,
                   let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    onImageSelected(image)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ImagePicker { _ in }
}
