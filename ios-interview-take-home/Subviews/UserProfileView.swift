import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.interactors) private var interactors
    @Environment(\.appState) private var appState
    @State private var isEditingName = false
    @State private var editedName = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: Theme.Spacing.xl) {
                    Spacer()
                    
                    // Profile image section
                    VStack(spacing: Theme.Spacing.lg) {
                        // Large profile avatar - tappable
                        Button(action: { showingImagePicker = true }) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Group {
                                        if let selectedImage = selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } else if let profileImage = appState.userState.profileImage,
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
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button("Change Photo") {
                            showingImagePicker = true
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
                                Button(action: { startEditingName() }) {
                                    Text(appState.userState.userName)
                                        .font(Theme.Typography.largeTitle)
                                        .foregroundColor(.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
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
                            action: { openAppSettings() }
                        )
                        
                        SettingsRow(
                            icon: "gear",
                            title: "Settings",
                            action: { openAppSettings() }
                        )
                        
                        SettingsRow(
                            icon: "questionmark.circle",
                            title: "Help & Support",
                            action: { showHelpAlert() }
                        )
                        
                        SettingsRow(
                            icon: "rectangle.portrait.and.arrow.right",
                            title: "Sign Out",
                            action: { showSignOutAlert() }
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
        .sheet(isPresented: $showingImagePicker) {
            ProfileImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { _, newImage in
            if let newImage = newImage {
                let imageData = newImage.jpegData(compressionQuality: 0.8)
                appState.userState.updateProfileImage(imageData)
            }
        }
        .alert("Help & Support", isPresented: $showingHelpAlert) {
            Button("OK") {}
        } message: {
            Text("Coming soon - reach out for anything you need at support@messages.com")
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {
                Task {
                    await signOut()
                }
            }
        } message: {
            Text("Are you sure you want to sign out? This will clear all your data and return you to the onboarding screen.")
        }
    }
    
    private func startEditingName() {
        editedName = appState.userState.userName
        isEditingName = true
    }
    
    private func saveNameChange() {
        appState.userState.updateUserName(editedName)
        isEditingName = false
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    @State private var showingHelpAlert = false
    @State private var showingSignOutAlert = false
    
    private func showHelpAlert() {
        showingHelpAlert = true
    }
    
    private func showSignOutAlert() {
        showingSignOutAlert = true
    }
    
    private func signOut() async {
        await interactors.userInteractor.signOut()
        // Clear app state as well
        appState.userState.hasCompletedOnboarding = false
        appState.userState.hasShownTypewriter = false
        appState.userState.userName = "User"
        appState.userState.profileImage = nil
        
        // Dismiss the profile view
        dismiss()
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