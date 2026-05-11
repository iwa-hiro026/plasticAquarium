import SwiftUI
import Combine

final class ToastViewModel : ObservableObject {
    @Published var showToast : Bool // トースト通知表示フラグ
    @Published var toastMessage : String // トースト通知テキスト

    init() {
        showToast = false
        toastMessage = ""
    }

    // トースト通知を表示するメソッド、引数で表示する文字列を受け取る
    func toastPreview(message : String) {
        self.showToast = true
        self.toastMessage = message
    }
}
