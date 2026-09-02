# 02_async_down_counter_8bit

## モジュール名
`async_down_counter_8bit`

## 目的
8 ビットの非同期ダウンカウンタを設計する。

値を 1 ずつ減らすカウンタを実装し、リセット・ロード機能を組み合わせた典型的なカウンタ処理を練習する。

## 入出力ポート

```vhdl
entity ASYNC_DOWN_COUNTER_8BIT is
    port (
        CLK     : in  std_logic;
        RST_N   : in  std_logic;
        I_LOAD  : in  std_logic;
        I_D     : in  std_logic_vector(7 downto 0);
        O_COUNT : out std_logic_vector(7 downto 0)
    );
end entity;
```

## ポートの役割

- `CLK` : クロック入力
- `RST_N` : リセット入力
- `I_LOAD` : ロード有効信号
- `I_D` : ロード時の初期値
- `O_COUNT` : 現在のカウント値

## 動作仕様

1. `rst_n = '0'` のとき、`count` は `"11111111"` に設定される。
2. `load = '1'` のとき、`d_in` を `count` に代入する。
3. `load = '0'` かつ `rst_n = '1'` のとき、各クロックで `count` を 1 ずつ減らす。
4. `count = 0` の状態で 1 減算すると `255` に戻る。
5. `load` は通常のカウント動作を優先しない設計にしてよい。

## 実装上の注意

- 8 ビットの減算は `count <= count - 1;` として実装可能。
- `load` が優先される設計を選ぶとわかりやすい。
- `rst_n` と `load` の優先順位を明確にする。
- 0 からの減算で 255 に巻き戻ることを確認する。

## 確認用入力例

### 例1: リセット

- `rst_n = '0'`
- `clk` 立ち上がり後
- `count` は `11111111`

### 例2: ロード

- `rst_n = '1'`
- `load = '1'`
- `d_in = "00110101"`

期待値:

```text
count = 00110101
```

### 例3: 減算

- `count = 00000000`
- 次のクロックで減算すると `11111111`

## 実装の目安

この問題は、減算演算と巻き戻しを含む基本的なカウンタ設計である。

カウンタの信号優先順と状態遷移の考え方を身につけるのに適している。
