# 用語集 / Glossary

Keep terminology consistent across `src/<target>.md` and `figures/*.<target>.txt`.
Change an entry here first, then report affected occurrences and get the editor's confirmation before replacing
them in either place.

Style (ja): です・ます調. Half-width alphanumerics, no space between Japanese and Latin text (e.g. `4D.Vector型`).
Full-width `（）` and `：` in prose. Do not automatically add English glosses on first occurrence; use English only
when needed to disambiguate, when approved by the editor, or for identifiers and actual quoted UI strings.
Use the approved localised component/tool title consistently in prose, without renaming code identifiers or
overriding resource-verified UI text. Record that title under Document-specific terms.
See the [translation conventions](.github/instructions/technote-translation.instructions.md#translation-conventions)
for cover, byline and documentation-link rules.

## 4D terms

Use official 4D Japanese documentation terminology except where Notes explicitly identifies an editor-approved
narrative term. Narrative choices do not establish authoritative UI translations.

| English | 日本語 | Notes |
|---|---|---|
| entity / entity selection | エンティティ / エンティティセレクション | |
| datastore | データストア | |
| dataclass | データクラス | |
| attribute | 属性 | |
| computed attribute | 計算属性 | |
| collection | コレクション | |
| object | オブジェクト | |
| method | メソッド | |
| project method | プロジェクトメソッド | |
| function | 関数 | |
| class | クラス | |
| parameter | 引数 | |
| form | フォーム | |
| form object | フォームオブジェクト | |
| list box | リストボックス | |
| web area | Webエリア | |
| 4D Web Server | 4D Webサーバー | |
| worker | ワーカー | |
| process | プロセス | |
| query | クエリ | |
| formula | フォーミュラ | |
| component | コンポーネント | |
| standalone | シングルユーザー版 | Editor's narrative term for the 4D product edition, not standalone method execution. |
| Code Editor | メソッドエディター | Editor's narrative term; quoted or screenshot UI must use resource-verified wording. |
| form style sheet | フォームのスタイルシート | 4D docs: スタイルシート |
| media feature | メディア特性 | 4D docs use both メディア特性 and メディア機能 |
| media query | メディアクエリ | |
| form theme | フォームテーマ | Unverified: 4D docs mostly say テーマ / プラットフォームテーマ |
| light / dark appearance | ライトモード / ダークモード | "appearance" alone: 外観 |
| form description file | フォーム定義ファイル | form.4DForm |
| form editor | フォームエディター | |
| form event | フォームイベント | |
| project mode | プロジェクトモード | |
| list box column / header / footer | リストボックスの列 / ヘッダー / フッター | |
| collection list box | コレクションリストボックス | |
| input (object) | 入力オブジェクト | |
| rectangle | 四角 | 4D form object name |
| picture object / static picture | ピクチャーオブジェクト / スタティックピクチャー | |
| form expression | フォーム式 | |
| data source | データソース | |
| bind / binding | バインドする / バインド | |
| dependency | 依存関係 | |
| feature release | フィーチャーリリース | 21 Rx |
| form method | フォームメソッド | |

## Document-specific terms

| English | 日本語 | Notes |
|---|---|---|
| Rendering the macOS Liquid Glass Appearance in 4D | 4DでmacOSのLiquid Glassの外観を再現する | Cover title (approved) |
| Quality Support Engineer | 品質サポートエンジニア | Byline role |
| Liquid Glass | Liquid Glass | Apple design name, untranslated |
| translucent / translucency | 半透明 | |
| material | マテリアル | |
| tint | ティント | |
| alpha | アルファ | |
| specular edge / specular rim | 鏡面ハイライトの縁 | |
| refraction / refract | 屈折 / 屈折させる | |
| blur / Gaussian blur | ぼかし / ガウスぼかし | |
| color matrix | カラーマトリクス | |
| filter primitive | フィルタープリミティブ | SVG term |
| saturation / contrast | 彩度 / コントラスト | |
| luma | 輝度 | |
| pivot (tone) | ピボット（トーン） | |
| fraction | 割合 | interpolation parameter |
| linear interpolation | 線形補間 | |
| rung (chrome / glass / hairline) | 段階 | rung names kept in English (identifiers) |
| surface | サーフェス | |
| panel / pane | パネル / ペイン | |
| sidebar / inspector | サイドバー / インスペクター | |
| register (list of vessels) | 一覧 | |
| unified title bar | 統合タイトルバー | |
| window chrome | ウィンドウのクローム | |
| accent color | アクセントカラー | macOS |
| selection highlight | 選択ハイライト | |
| tertiary label color | 第3レベルのラベルカラー | macOS tertiaryLabelColor |
| operator | オペレーター | end user of the window |
| contour | 等高線 | background artwork |
| canvas | キャンバス | fig-03 |

## Proper nouns in examples

| English | 日本語 | Notes |
|---|---|---|
| Tahoe / Golden Gate | Tahoe / Golden Gate | macOS 26 / 27 names, untranslated |
| Meridian | Meridian | Demo app brand, untranslated |
| Yacht names and models (Levante, Nautor Swan 54 …) | unchanged | Demo data (approved) |
| Hayama / Yokohama / Atami / Ginowan / Ishigaki / Aburatsubo / Ushimado / Gamagori | 葉山 / 横浜 / 熱海 / 宜野湾 / 石垣 / 油壺 / 牛窓 / 蒲郡 | Demo harbours (`harbor` / `harborJa`) |
| Eri Nakamura / Daisuke Fujita / Isamu Kinjo / Eiji Asato / Kaori Kobayashi / Makoto Arakaki | 中村 恵理 / 藤田 大輔 / 金城 勇 / 安里 英二 / 小林 かおり / 新垣 誠 | Demo skippers (`skipper` / `skipperJa`) |
| Hatsushima / Pearl Race | 初島 / パールレース | Demo notes |

## Demo UI terms

Source of truth: `demo/LiquidGlassAppearance/Resources/ja.lproj/*.xlf`.

| English | 日本語 | Notes |
|---|---|---|
| vessel | 艇 | counter: 〜艇 |
| fleet / fleet register | 船団 / 船団一覧 | launcher: チャーター船団台帳 |
| Charters / Desk / Laid up (sections) | チャーター / デスク / 休航 | |
| Available / On charter / Turnaround / In refit / Laid up (status) | 空き / チャーター中 / 準備中 / 改装中 / 休航中 | stored keys stay English |
| Sloop / Catamaran / Motor / Ketch / Gulet (type) | スループ / カタマラン / モーターヨット / ケッチ / ギュレット | stored keys stay English |
| Bareboat (skipper) | ベアボート | stored key stays English |
| Home port / Harbour | 母港 | |
| Flag | 船籍 | |
| Berths | バース数 | |
| Built | 建造年 | |
| Rate / night, Per night, Per week | 1泊料金, 1泊, 1週間 | amounts: `¥` + comma grouping in both UIs |
| FLEET UTILISATION / COMMITTED TONIGHT | 船団稼働率 / 今夜の確定額 | |
| Activity (log) | アクティビティ | |
| Flagship | フラッグシップ | |
