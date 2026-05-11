import UIKit
import AVFoundation
import Vision
import CoreML

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // カメラセッション
    let session = AVCaptureSession()

    // カメラ映像を表示するレイヤー
    var previewLayer: AVCaptureVideoPreviewLayer!

    // 返り値用、ラベルと推定値
    var onRecognized: ((String, Float) -> Void)?

    // AIモデル格納用
    private var visionModel: VNCoreMLModel?

    // 多重処理防止用フラグ
    var isProcessing = false

    // フレームカウント
    var frameCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupModel()
    }

    // モデル設定関数
    func setupModel() {
        do {
            let config = MLModelConfiguration()

            // ここで自分が作成したモデルを読み込みGarbageClassifier
            let model = try GarbageClassifier(configuration: config).model
            visionModel = try VNCoreMLModel(for: model)
        } catch {
            print("モデル読み込み失敗:", error)
        }
    }

    // カメラ設定（基本は固定テンプレ、必要に応じて変更）
    func setupCamera() {
        // 画質設定（任意で変更）
        session.sessionPreset = .medium

        // カメラデバイス取得
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        // 入力追加
        session.addInput(input)

        // 出力（フレーム取得）
        let output = AVCaptureVideoDataOutput()

        // 出力形式の設定（今回：ピクセルフォーマット、扱いやすい形式）
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String:
            kCVPixelFormatType_32BGRA
        ]

        // 1フレームごとに呼ばれるデリゲート設定
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera"))

        // 出力追加
        session.addOutput(output)

        // カメラ映像を画面に表示
        previewLayer = AVCaptureVideoPreviewLayer(session: session) // 基本固定
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // カメラ開始
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }


    // 毎フレーム呼ばれるメソッド、ここをカスタマイズして機能を変える。
    // 今回は、画像をフレーム単位で取得するメソッド
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        // フレーム数をカウント
        frameCount += 1

        // 10フレームに1回処理を行う（ここの数値をカスタマイズすることで、処理を行うフレーム頻度を変えられる）
        if frameCount % 10 != 0 {
            return
        }

		// 画像をAI認識に適した形式へ変換する処理
        // CMSampleBuffer → CVPixelBuffer（画像データ）
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // 画像認識メソッドの実行
        recognize(pixelBuffer: pixelBuffer)
    }

    // AI認識メソッド
    func recognize(pixelBuffer: CVPixelBuffer) {
        guard let visionModel = visionModel else { return }

        isProcessing = true

        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            defer {
                self?.isProcessing = false
            }

            guard let results = request.results as? [VNClassificationObservation],
                let first = results.first else {
                return
            }

            let label = first.identifier
            let confidence = first.confidence

            if label == "plastic_bottle", confidence > 0.8 {
                DispatchQueue.main.async {
                    self?.onRecognized?(label, confidence)
                }
            }
        }

        request.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: .right
        )

        try? handler.perform([request])
    }
}