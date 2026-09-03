# VHDL Practice Problems

このリポジトリは、フリップフロップを含む RTL 設計の練習用に作成した問題集です。

各問題は以下の形式で整理しています。

- モジュール名
- 目的
- 入出力ポート
- ポートの役割
- 動作仕様
- 実装時の注意点
- 確認用の入力例

実装は各問題の README を参照して行い、最終的に答え合わせの対象としてください。

## 問題一覧

1. [01_sync_up_counter_4bit/README.md](01_sync_up_counter_4bit/README.md) - 同期アップカウンタ
2. [02_async_down_counter_8bit/README.md](02_async_down_counter_8bit/README.md) - 非同期ダウンカウンタ
3. [03_shift_register_8bit/README.md](03_shift_register_8bit/README.md) - 左右シフトレジスタ
4. [04_debounce_switch/README.md](04_debounce_switch/README.md) - チャタリング除去
5. [05_clk_divider/README.md](05_clk_divider/README.md) - クロック分周
6. [06_piso_shift_register/README.md](06_piso_shift_register/README.md) - PISO シフトレジスタ
7. [07_up_down_counter_8bit/README.md](07_up_down_counter_8bit/README.md) - 同期アップダウンカウンタ
8. [08_sipo_shift_register/README.md](08_sipo_shift_register/README.md) - SIPOシフトレジスタ
9. [09_piso_shift_register/README.md](09_piso_shift_register/README.md) - 立ち上がりエッジ検出
10. [10_traffic_light_controller/README.md](10_traffic_light_controller/README.md) - 信号機コントローラ（FSM）
11. [11_sequence_detector_1011/README.md](11_sequence_detector_1011/README.md) - 1011シーケンス検出器（FSM）

## レクチャー

- [FSM_DESIGN_GUIDE.md](FSM_DESIGN_GUIDE.md) - 状態遷移回路を設計する定石

## 命名規則

- エンティティ名: `UPPER_CASE_WITH_UNDERSCORE`
- クロック: `CLK`
- リセット: `RST_N`
- 入力: `I_` を先頭につける
- 出力: `O_` を先頭につける
- 内部信号: `s_` を先頭につける

例:

```vhdl
entity SYNC_UP_COUNTER_4BIT is
    port (
        CLK    : in  std_logic;
        RST_N  : in  std_logic;
        I_EN   : in  std_logic;
        O_COUNT: out unsigned(3 downto 0)
    );
end entity;
```

## テンプレートの利用

毎回ファイルを作ってエンティティを書くのが面倒な場合は、
[00_template/TEMPLATE.vhd](00_template/TEMPLATE.vhd) をコピーして利用してください。

- エンティティ名を問題名に置き換える
- ポートの命名を問題の仕様に合わせる
- アーキテクチャ本体だけ記述する

## 実装の進め方

1. まずは 1 問を選ぶ
2. その問題の README をよく読む
3. ポート定義と振る舞いを整理する
4. VHDL で RTL を記述する
5. シミュレーションで動作確認する
6. 仕上げとして、設計意図と動作説明をまとめる

## 目標

- フリップフロップを使った状態更新を理解する
- 同期/非同期、シフト、分周、カウンタなどの設計パターンを習得する
- 実際のハードウェア設計の感覚を身につける
