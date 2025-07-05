//
//  ContentView.swift
//  PhotoCam
//
//  Created by Dev Tech on 2024/12/29.
//

import SwiftUI
import PhotosUI
    
struct ContentView: View {
    // 撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    // 撮影画面(Sheet)の開閉状態管理
    @State var isShowSheet = false
    // フォトライブラリーで選択した写真を管理
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        ZStack {
            // 背景画像を指定
            Image(.background)
            // リサイズ
                .resizable()
            // セーフエリア外まで画面表示
                .ignoresSafeArea()
            // アスペクト比を維持し短辺基準に収める
                .scaledToFill()
                let bgColor = Color.init(red: 0.3, green: 0.5, blue: 0.95)
                let blueColor = Color.init(red: 0.15, green: 0.3, blue: 0.85, opacity: 0.5)
            
            VStack {
                // スペース追加
                Spacer()
                // 「カメラ起動(Touch)」ボタン
                Button {
                    // ボタンタップアクション
                    // カメラが利用可能かチェック
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        print("利用可能")
                        // 撮影写真を初期化
                        captureImage = nil
                        // カメラ使用可能時isShowSheetをtrueに処理
                        isShowSheet.toggle()
                    } else {
                        print("利用不可")
                    }
                } label: {
                    Text("Touch")
                    // 文字サイズ指定
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    // 文字色を白色指定
                        .foregroundColor(.white)
                    // 余白追加
                        .padding()
                        .frame(width: 150, height: 50)
                    // 背景指定
                        .background(RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(bgColor)
                        // 上側shadow
                            .shadow(color: .blue, radius: 10, x: -7, y: -7)
                        // 下側shadow
                            .shadow(color: blueColor, radius: 10, x: 7, y: 7)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white, lineWidth: 0)
                 )
                } // 「カメラ起動ボタン」ボタン End
                // 余白追加
                    .padding()
                // Sheet表示
                // isPresentedで指定した状態変数がtrueの際実行
                .sheet(isPresented: $isShowSheet) {
                    if let captureImage {
                        // 撮影した写真がある→EffectViewを表示
                        EffectView(isShowSheet: $isShowSheet, captureImage: captureImage)
                    } else {
                        // UIImagePickerController(写真撮影)を表示
                        ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
                    }
                } // 「カメラを起動」ボタンSheet End
                
                // フォトライブラリーから選択
                PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                    // テキスト表示
                    Text("Select to Photo Gallery")
                    // 文字サイズ指定
                        .font(.system(size: 20, weight: .semibold, design: .default))
                    // 文字色を白色指定
                        .foregroundColor(.white)
                    // 余白追加
                        .padding(.horizontal, 60)
                        .padding(.vertical, 20)
                    // 背景指定
                        .background(Color.blue)
                        .cornerRadius(30)
                } // PhotosPicker End
                
                // 選択した写真情報を写真から取り出す
                .onChange(of: photoPickerSelectedImage, initial: true, { oldValue, newValue in
                    // 選択した写真がある際
                    if let newValue {
                        Task {
                            // Data型で写真を取り出す
                            if let data = try? await newValue.loadTransferable(type: Data.self) {
                                // 写真がある際
                                // 写真をcaptureImageに保存
                                captureImage = UIImage(data: data)
                            }
                        }
                    }
                }) // .onChange End
            } // VStack End
        }
        // 撮影した写真を保持する状態変数が変化したら実行
        .onChange(of: captureImage, initial: true, { oldValue, newValue in
            if let _ = newValue {
                // 撮影した写真があるEffectViewを表示
                isShowSheet.toggle()
            }
            
        }) // .onChange End
        
    } // body End

} // ContentView End

#Preview {
    ContentView()
}
