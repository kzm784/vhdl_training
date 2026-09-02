# 03_shift_register_8bit

## モジュール名
`shift_register_8bit`

## 目的
8 ビットのシフトレジスタを設計する。

左右へのシフト動作と並列ロードを備えたレジスタを実装し、シフトの基本原理を練習する。

## 入出力ポート

```vhdl
entity SHIFT_REGISTER_8BIT is
    port (
        CLK           : in  std_logic;
        RST_N         : in  std_logic;
        I_SHIFT_LEFT  : in  std_logic;
        I_SHIFT_RIGHT : in  std_logic;
        I_LOAD        : in  std_logic;
        I_D           : in  std_logic_vector(7 downto 0);
        O_Q           : out std_logic_vector(7 downto 0)
    );
end entity;
```

## ポートの役割

- `CLK` : クロック
- `RST_N` : リセット
- `I_SHIFT_LEFT` : 左シフト有効
- `I_SHIFT_RIGHT` : 右シフト有効
- `I_LOAD` : 並列ロード有効
- `I_D` : ロード時の入力データ
- `O_Q` : 現在のレジスタ状態

## 動作仕様

1. `rst_n = '0'` のとき `q <= "00000000"`。
2. `load = '1'` のとき `q <= d_in`。
3. `shift_left = '1'` のとき、各ビットを左へ1つずらす。
4. `shift_right = '1'` のとき、各ビットを右へ1つずらす。
5. 空いたビット位置には `0` を充填する。
6. `shift_left` と `shift_right` が同時に '1' になる場合は未定義とし、設計では禁止とする。

## 実装上の注意

- 左シフトでは最上位ビットが捨てられ、最下位ビットに 0 が入る。
- 右シフトでは最下位ビットが捨てられ、最上位ビットに 0 が入る。
- 方向が明確に分かるように `q(7)` と `q(0)` の位置に注意する。
- `load` とシフト信号の優先順位を決める。

## 確認用入力例

### 例1: ロード

- `load = '1'`
- `d_in = "10110010"`

期待値:

```text
q = 10110010
```

### 例2: 左シフト

- `q = 10110010`
- `shift_left = '1'`

期待値:

```text
q = 01100100
```

### 例3: 右シフト

- `q = 10110010`
- `shift_right = '1'`

期待値:

```text
q = 01011001
```

## 実装の目安

シフトレジスタは、レジスタ内部状態の更新と、ビット位置の取り扱いを学ぶのに最適である。

シフト処理はフリップフロップの応用として非常に重要な基本概念である。
