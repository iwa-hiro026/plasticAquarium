import SwiftUI

final class MeasureViewModel : ObservableObject {
    @Published var showingCamera = false // カメラ起動フラグ
    @Published private var isRecognized = false // カメラ認証フラグ
    @Published private var label = "" // ラベル

    
    // カメラ起動
    func openCamera(label: String) {
        self.label = label
        self.isRecognized = false
        self.showingCamera = true

        // test
        self.isRecognized = true
        // test
    }

    // カメラ停止
    func closeCamera() {
        self.showingCamera = false
        if self.isRecognized {
            // ここに認証時処理

        }
        self.isRecognized = false
        self.label = ""
    }
}