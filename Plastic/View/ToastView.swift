import SwiftUI

// トースト表示用View
struct ToastView: View {
    @EnvironmentObject private var toastViewModel: ToastViewModel

    var body: some View {
        Text(toastViewModel.toastMessage)
            .padding()
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
