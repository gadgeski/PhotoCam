# PhotoCam

写真撮影とフィルタ機能を持つ iOS アプリケーション

## 概要

PhotoCam は、SwiftUI で作成されたシンプルなカメラアプリです。写真の撮影、フォトライブラリからの選択、フィルタ効果の適用、そして写真の共有機能を提供します。

## 主な機能

### 📸 写真撮影

- デバイスのカメラを使用して写真を撮影
- カメラの利用可能性を自動チェック
- 撮影後に自動的にエフェクト編集画面へ遷移

### 📚 フォトライブラリ連携

- フォトライブラリから既存の写真を選択
- 選択した写真に対してもフィルタ効果を適用可能

### 🎨 フィルタ効果

以下のフィルタ効果が利用可能です：

- モノクロ（CIPhotoEffectMono）
- Chrome（CIPhotoEffectChrome）
- Fade（CIPhotoEffectFade）
- Instant（CIPhotoEffectInstant）
- Noir（CIPhotoEffectNoir）
- Process（CIPhotoEffectProcess）
- Tonal（CIPhotoEffectTonal）
- Transfer（CIPhotoEffectTransfer）
- セピアトーン（CISepiaTone）

### 📤 共有機能

- 編集した写真をシステムの共有シートを通じて他のアプリと共有
- ShareLink を使用したネイティブな共有体験

## アーキテクチャ

### ファイル構成

```
PhotoCam/
├── PhotoCamApp.swift          # アプリのエントリーポイント
├── ContentView.swift          # メイン画面
├── EffectView.swift           # フィルタ効果編集画面
├── ImagePickerView.swift      # カメラ撮影画面
├── UIImageExtension.swift     # UIImage拡張（リサイズ機能）
└── PhotoCam.entitlements      # アプリの権限設定
```

### 画面構成

1. **ContentView（メイン画面）**

   - カメラ撮影ボタン
   - フォトライブラリ選択ボタン
   - 写真選択時の自動遷移処理

2. **EffectView（エフェクト編集画面）**

   - 選択した写真の表示
   - フィルタ効果の適用
   - 写真の共有
   - 画面を閉じる機能

3. **ImagePickerView（カメラ撮影画面）**
   - UIImagePickerController を SwiftUI で利用
   - 撮影完了時の自動遷移

### 技術仕様

- **フレームワーク**: SwiftUI, UIKit
- **画像処理**: Core Image
- **写真選択**: PhotosUI
- **対応プラットフォーム**: iOS
- **アプリサンドボックス**: 有効

## 主要コンポーネント

### State Management

- `@State` を使用した状態管理
- `@Binding` によるコンポーネント間データ連携

### 画像処理

- Core Image フレームワークを使用
- CIFilter によるフィルタ効果適用
- 画像の回転情報保持

### UI/UX

- 円形のカメラ撮影ボタン
- ブルーカラーの UI テーマ
- Sheet 表示による画面遷移
- レスポンシブデザイン

## 使い方

1. **写真撮影**

   - 「Touch」ボタンをタップしてカメラを起動
   - 写真を撮影すると自動的にエフェクト編集画面へ

2. **フォトライブラリから選択**

   - 「フォトライブラリから選択」ボタンをタップ
   - 写真を選択すると自動的にエフェクト編集画面へ

3. **フィルタ効果適用**

   - エフェクト編集画面で「エフェクト」ボタンをタップ
   - 現在はモノクロフィルタが適用される

4. **写真共有**
   - 「シェア」ボタンをタップして他のアプリに写真を共有

## 注意事項

- カメラ機能は iOS 実機でのみ動作します（シミュレーターでは利用不可）
- 写真へのアクセス権限が必要です
- 現在のバージョンでは「エフェクト」ボタンは固定でモノクロフィルタを適用します
- 「閉じる」ボタンの実装は現在未完成です

## 今後の拡張予定

- フィルタの選択機能
- 複数フィルタの組み合わせ
- カスタムフィルタの作成
- 写真の保存機能
- UI の改善とアニメーション追加
