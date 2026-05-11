import SwiftUI

// 計測画面
struct MeasureView: View {
    @EnvironmentObject private var playerViewModel: PlayerViewModel
    @EnvironmentObject private var toastViewModel: ToastViewModel
    @ObservedObject private var measureViewModel = MeasureViewModel()

    var body: some View {
        ZStack {
            VStack{
                MeasurePageView(measureViewModel : measureViewModel)
            }

            HStack {
                // 左矢印
                Image(systemName: "chevron.left")
                    .font(.largeTitle)
                    .padding()
                    .background(.black.opacity(0.4))
                    .clipShape(Circle())
                    
                Spacer()

                // 右矢印
                Image(systemName: "chevron.right")
                    .font(.largeTitle)
                    .padding()
                    .background(.black.opacity(0.4))
                    .clipShape(Circle())
            }

            // カメラ起動中の背景、背面タップでカメラを閉じるようにしている
            if  measureViewModel.showingCamera {
                Color.black.opacity(0.01)
                    .ignoresSafeArea()
                    .onTapGesture {
                        measureViewModel.closeCamera()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // カメラシート
            // showingCameraがtrueの時に、sheetが表示される
            .sheet(isPresented: $measureViewModel.showingCamera, content: {
                // CameraViewを表示、未完成のためコメントアウト
                // CameraView(
                //     isRecognized: $measureViewModel.isRecognized, label: $measureViewModel.label
                // )
            })

            if measureViewModel.isRecognized() {
                VStack{
                    Text("認識成功: \(label)")
                        .font(.largeTitle)
                        .padding()
                        .background(.black.opacity(0.7))
                        .foregroundStyle(.white)
                        .cornerRadius(12)

                    Button {
                        // カメラ
                        measureViewModel.closeCamera()
                    } label :{
                        Text("OK")
                        .font(.largeTitle)
                        .padding()
                        .background(.black.opacity(0.7))
                        .foregroundStyle(.red)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

