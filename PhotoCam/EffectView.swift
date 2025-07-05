//
//  EffectView.swift
//  PhotoCam
//
//  Created by Dev Tech on 2024/12/29.
//

import SwiftUI

struct EffectView: View {
    // エフェクト編集画面(sheet)の開閉状態を管理
    @Binding var isShowSheet: Bool
    // 撮影した写真
    let captureImage: UIImage
    // 表示する写真
    @State var showImage: UIImage?
    
    // フィルタ名を列挙した配列（Array）
    // 0.モノクロ
    // 1.Chorome
    // 2.Fade
    // 3.Instant
    // 4.Noir
    // 5.Process
    // 6.Tonal
    // 7.Transfer
    // 8.SepiTone
    let filterArray = [
        "CIPhotoEffectMono",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    
    // 選択中のエフェクト (filterArrayの添字)
    @State var filterSelectNumber = 0
    
    var body: some View {
        ZStack {
            // 背景画像を表示
            Image(.screen)
            // リサイズ
                .resizable()
            // セーフエリア外まで表示
                .ignoresSafeArea()
            // アスペクト比を維持し短辺基準に収める
                .scaledToFill()
            // 縦方向レイアウト
            VStack {
                // スペース追加
                Spacer()
                
                if let showImage {
                    //表示する写真がある場合は画面表示
                    Image(uiImage: showImage)
                    // リサイズ
                        .resizable()
                    // アスペクト比（縦横比）を維持し画面内に収める
                        .scaledToFit()
                } // if End
                // スペース追加
                Spacer()
                // 「エフェクト」ボタン
                Button {
                    // ボタンタップアクション
                    // フィルタ名指定
                    let filterName = filterArray[filterSelectNumber]
                    
                    // 次回に適用するフィルタを決めておく
                    filterSelectNumber += 1
                    // 最後のフィルタまで適用した場合
                    if filterSelectNumber == filterArray.count {
                        // 最後の場合は、最初のフィルタに戻す
                        filterSelectNumber = 0
                    }
                    // 元々の画像の回転角度取得
                    let rotate = captureImage.imageOrientation
                    // UImage形式の画像をCIImage形式に変換
                    let inputImage = CIImage(image: captureImage)
                    
                    // フィルタ名を指定しCIFilterインスタンス取得
                    guard let effectFilter = CIFilter(name: filterName) else {
                        return
                    }
                    
                    // フィルタ加工のパラメータ初期化
                    effectFilter.setDefaults()
                    // インスタンスにフィルタ加工する元画像を設定
                    effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                    
                    guard let outputImage = effectFilter.outputImage else {
                        return
                    }
                    
                    // CIContextのインスタンス取得
                    let ciContext = CIContext(options: nil)
                    // フィルタ加工後の画像をCIContext上に描画し、
                    guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                        return
                    }
                    
                    // フィルタ加工後の画像をCGImage形式から
                    showImage = UIImage(
                        cgImage: cgImage,
                        scale: 1,
                        orientation: rotate
                    )
                    
                } label: {
                    // テキスト表示
                    Text("エフェクト")
                    // 横幅いっぱい
                        .frame(maxWidth: .infinity)
                    // 高さ50ポイント指定
                        .frame(height: 50)
                    // 文字列センタリング指定
                        .multilineTextAlignment(.center)
                    // 背景に青色指定
                        .background(Color.blue)
                    // 文字色を白色指定
                        .foregroundColor(Color.white)
                } // 「エフェクト」ボタン End
                // 上下左右に余白追加
                .padding()
                
                // showImageをアンラップ
                if let showImage {
                    // shareImageから共有画像を生成
                    let shareImage = Image(uiImage: showImage)
                    // 共有シート
                    ShareLink(item: shareImage, subject: nil, message: nil, preview: SharePreview("Photo", image: shareImage)) {
                        // テキスト表示
                        Text("シェア")
                        // 横幅いっぱい
                            .frame(maxWidth: .infinity)
                        // 高さ50ポイント指定
                            .frame(height: 50)
                        // 背景を青色指定
                            .background(Color.blue)
                        // 文字色を白色指定
                            .foregroundStyle(Color.white)
                    } // ShareLink End
                    // 上下左右に余白追加
                    .padding()
                } // アンラップ End
                
                // 「閉じる」ボタン
                Button {
                    // ボタンタップアクション
                    // エフェクト編集画面を閉じる
                    isShowSheet.toggle()
                } label: {
                    // テキスト表示
                    Text("閉じる")
                    // 横幅いっぱい
                        .frame(maxWidth: .infinity)
                    // 高さ50ポイント指定
                        .frame(height: 50)
                    // 文字列センタリング指定
                        .multilineTextAlignment(.center)
                    // 背景を青色指定
                        .background(Color.blue)
                    // 文字色を白色指定
                        .foregroundStyle(Color.white)
                } // 「閉じる」ボタン End
                // 上下左右に余白追加
                .padding()
            } // VStack End
        }
        .onAppear {
            // 撮影した写真を表示する写真に設定
            showImage = captureImage
        } // on Appear End
    } // Body End
} // EffectView End

#Preview {
    EffectView(
        isShowSheet: .constant(true),
        captureImage: UIImage(named: "preview_use")!
    )
}
