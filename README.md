# 4DでmacOSのLiquid Glassの外観を再現する

Rendering the macOS Liquid Glass Appearance in 4D (Technical Note 26-10): Japanese edition.

4D 21 Rx のフォームのスタイルシート、`prefers-color-scheme` メディア特性、フォームテーマを組み合わせて、macOS の Liquid Glass の外観を 4D のフォームで再現する方法を解説したテクニカルノートの日本語版です。スタイルシートとフォーム定義ファイルの規則、フォームオブジェクトが表示する値を読み込む順序を説明し、スタイルシートが受け付ける値の形式だけで半透明のサーフェス、鏡面ハイライトの縁、屈折した背景を作り出します。付属のデモ「Meridian」は、ヨットのチャーター船団を管理するアプリケーションで、ライトモードとダークモードの両方に対応したウィンドウ、サイドバー、インスペクター、確認ダイアログを実装しています。

## Download

| | |
|---|---|
| PDF (Japanese) | [26-10_LiquidGlassAppearance_ja.pdf](https://github.com/miyako/LiquidGlassAppearance/releases/latest/download/26-10_LiquidGlassAppearance_ja.pdf) |
| 4D demo | [LiquidGlassAppearance.zip](https://github.com/miyako/LiquidGlassAppearance/releases/latest/download/LiquidGlassAppearance.zip) |
| Original (English) | `document/26-10_LiquidGlassAppearance.pdf` |

## Demo

- 4D version: 4D 21 R4 or later, on macOS
- Open `demo/LiquidGlassAppearance/Project/LiquidGlassAppearance.4DProject`.
- Languages: Japanese and English. The UI follows the system language; the XLIFF files are in `Resources/<lang>.lproj/`.
- On startup, the "Meridian Home" launcher window opens in its own process.

### Demo data

The sample fleet (method `MN_Fleet`) was localised for Japan: Mediterranean harbours were replaced with Japanese
marinas (葉山, 横浜, 熱海, 宜野湾, 石垣, 油壺, 牛窓, 蒲郡), skippers with Japanese names, flags with 日本, and rates
converted from euros to yen (× 160, rounded to ¥10,000). Each record keeps its English fields and adds `*Ja` fields;
the UI shows the field for the current language and falls back to the other one.

## Differences from the original

- The Japanese cover omits the Technical Note number.
- Screenshots in Figures 5–8 were recaptured from the localised demo in Japanese.
- The demo UI (forms, menus, messages, list box headers, drop-down choices) is localised with XLIFF, using 4D's
  built-in strings for OK, Cancel, Close and the Edit menu.
- The vessel sheet's Type field is a drop-down, like Status.
- Amounts are shown in yen (`MN_Yen` replaces `MN_Euro`), with thousands separators.
- The Main and Launcher layouts were adjusted for the Japanese labels.
- The development audit and verification methods (`MN_Audit*`, `Probe*`, `Verify*`, `Css*`, `Skin*`) were not
  localised; they expect the original English output.

## Editing and rebuilding

The PDF is generated from plain-text sources. Edit them and run `make`.

| File | What |
|---|---|
| `src/ja.md` | Translated text. Keep body blocks aligned with the source; the approved Japanese cover metadata omission is allowed. **Don't touch code blocks** (`make check` verifies them). |
| `figures/fig-NN.ja.txt` | Text drawn in figure NN. Line N corresponds to line N of `fig-NN.en.txt`: an identical line keeps the original, an empty line erases it. |
| `figures/layout/fig-NN.json` | Per-label overrides for size, weight, alignment and position; `"replace"` uses a ready-made image (e.g. `fig-NN.ja.png`) |
| `glossary.md` | Terminology |

```sh
make            # check → figures → build/26-10_LiquidGlassAppearance_ja.pdf
make check      # code blocks unchanged, figure references complete
make review     # contact sheets of the figures (build/contact-N.png)
make release-assets
```

Requirements: Python 3, Google Chrome, CJK fonts, and Tesseract (only needed for re-extraction).
See the [localisation template](https://github.com/miyako/4d-technote-localisation-template) for the full workflow.

## Credits

- Original: Anouar Moustarih（4D Morocco 品質サポートエンジニア）
- Produced with [4d-technote-localisation-template](https://github.com/miyako/4d-technote-localisation-template) and GitHub Copilot.
