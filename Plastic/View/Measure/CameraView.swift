import SwiftUI

struct CameraView: UIViewControllerRepresentable {

    @Binding var isRecognized: Bool // 認識できたか
    @Binding var label: String // ラベル

    // UIKitのViewControllerを生成（大体固定テンプレ）
    func makeUIViewController(context: Context) -> CameraViewController {
        let vc = CameraViewController()

        // フレーム取得時に呼ばれる処理（基本固定だが、使う変数によってカスタムする）
        vc.onRecognized = { label, confidence in
            self.isRecognized = true
            self.label = label
        }

        return vc
    }

    // View更新時に行いたい処理を記述する関数、今回はViewと共有しているimage変数が変化したときに呼び出される
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
		    // 今回は特になし
    }
}