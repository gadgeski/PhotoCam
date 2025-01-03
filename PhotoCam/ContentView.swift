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
                    .font(.title)
                // 横幅いっぱい
                .frame(maxWidth: .infinity)
                // 高さ50ポイント指定
                .frame(width: 100, height: 100)
                // 文字列センタリング指定
                .multilineTextAlignment(.center)
                // 背景を青色に指定
                .background(Color.blue)
                // 文字色を白色指定
                .foregroundStyle(Color.white)
                
                // 円形に切り抜く
                .clipShape(Circle())
                // 余白追加
                .padding()
            } // 「カメラ起動ボタン」ボタン End
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
                Text("フォトライブラリーから選択")
                // 横幅いっぱい
                    .frame(maxWidth: .infinity)
                // 高さ50ポイント指定
                    .frame(height: 50)
                // 背景を青色指定
                    .background(Color.blue)
                // 文字色を白色指定
                    .foregroundStyle(Color.white)
                // 上下左右に余白追加
                    .padding()
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
