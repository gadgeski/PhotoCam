//
//  ImagePickerView.swift
//  PhotoCam
//
//  Created by Dev Tech on 2024/12/29.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    // UIImagePickerController(写真撮影)が表示されているか管理
    @Binding var isShowSheet: Bool
    
    // 撮影した写真を格納する変数
    @Binding var captureImage: UIImage?
    
    // Coodinatorでコントローラのdelegateを管理
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        // ImagePickerView型定数を用意
        let parent: ImagePickerView
        
        // イニシャライザ
        init(parent: ImagePickerView) {
            self.parent = parent
            
        }
        
        // 撮影が終わった際呼び出すdelegateメソッド必須
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // UIImagePickerControllerを閉じ、isShowSheetがfalseに変更
            picker.dismiss(animated: true) {
                
                // 撮影した写真をcaptureimageに保存
                if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.parent.captureImage = originalImage
                }
            }
        }
        
        // キャンセルを選択した際に呼び出すdelegateメソッド必須
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Sheet閉じる
            parent.isShowSheet.toggle()
        }
    } // Coordinator End

    // Coordinator生成、SwiftUIで自動呼び出し
    func makeCoordinator() -> Coordinator {
        // Coordinatorクラスインスタンス生成
        Coordinator(parent: self)
    } // makeCoordinator
    
    // View生成時実行
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // UIImagePickerControllerインスタンス生成
        let myImagePickerController = UIImagePickerController()
        // sourceTypeにCameraを設定
        myImagePickerController.sourceType = .camera
        // delegate設定
        myImagePickerController.delegate = context.coordinator
        // UIImagePickerControllerを返す
        return myImagePickerController
    } // makeUIViewController End
    
    // View更新時実行
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // 処理無し
        
    } // updateUIViewController End
    
} // ImagePicker End
