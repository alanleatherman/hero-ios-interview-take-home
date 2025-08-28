import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.interactors) private var interactors
    @State private var userProfile: UserProfile?
    @State private var isEditingName = false
    @State private var editedName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: Theme.Spacing.xl) {
                    Spacer()
                    
                    // Profile image section
                    VStack(spacing: Theme.Spacing.lg) {
                        // Large profile avatar
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Group {
                                    if let profileImage = userProfile?.profileImage,
                                       let uiImage = UIImage(data: profileImage) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 60))
                                            .foregroundColor(.gray)
                                    }
                                }
                            )
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Theme.Colors.primary, lineWidth: 3)
                            )
                        
                        Button("Change Photo") {
                            // TODO: Implement photo picker
                        }
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.primary)
                    }
                    
                    // Name section with edit capability
                    VStack(spacing: Theme.Spacing.sm) {
                        if isEditingName {
                            HStack {
                                TextField("Name", text: $editedName)
                                    .textFieldStyle(PurpleTextFieldStyle())
                                    .font(Theme.Typography.title)
                                    .multilineTextAlignment(.center)
                                
                                Button("Save") {
                                    saveNameChange()
                                }
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.primary)
                            }
                        } else {
                            HStack {
                                Text(userProfile?.name ?? "User")
                                    .font(Theme.Typography.largeTitle)
                                    .foregroundColor(.white)
                                
                                Button(action: { startEditingName() }) {
                                    Image(systemName: "pencil")
                                        .font(.caption)
                                        .foregroundColor(Theme.Colors.primary)
                                }
                            }
                        }
                        
                        Text("Tap to edit your name")
                            .font(Theme.Typography.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    // Settings options
                    VStack(spacing: Theme.Spacing.md) {
                        SettingsRow(
                            icon: "bell",
                            title: "Notifications",
                            action: {}
                        )
                        
                        SettingsRow(
                            icon: "moon",
                            title: "Dark Mode",
                            action: {}
                        )
                        
                        SettingsRow(
                            icon: "gear",
                            title: "Settings",
                            action: {}
                        )
                        
                        SettingsRow(
                            icon: "questionmark.circle",
                            title: "Help & Support",
                            action: {}
                        )
                    }
                    .padding(.horizontal, Theme.Spacing.xl)
                    
                    Spacer()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    dismiss()
                }
                .foregroundColor(Theme.Colors.primary)
            )
        }
        .task {
            userProfile = await interactors.userInteractor.getUserProfile()
        }
    }
    
    private func startEditingName() {
        editedName = userProfile?.name ?? ""
        isEditingName = true
    }
    
    private func saveNameChange() {
        // TODO: Implement name saving
        isEditingName = false
        // Update userProfile name locally for now
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Theme.Colors.primary)
                    .frame(width: 24)
                
                Text(title)
                    .font(Theme.Typography.body)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    UserProfileView()
        .inject(AppContainer(
            appState: AppState(),
            interactors: .stub
        ))
}