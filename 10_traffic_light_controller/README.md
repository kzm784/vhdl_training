# 10_traffic_light_controller

## モジュール名
`TRAFFIC_LIGHT_CONTROLLER`

## 目的
有限状態機械（FSM）を使った信号機コントローラを設計する。

状態レジスタ、次状態論理、出力論理を分けて記述し、状態遷移を伴うRTL設計を練習する。

## 入出力ポート

```vhdl
entity TRAFFIC_LIGHT_CONTROLLER is
    port (
        CLK       : in  std_logic;
        RST_N     : in  std_logic;
        I_ENABLE  : in  std_logic;
        O_RED     : out std_logic;
        O_YELLOW  : out std_logic;
        O_GREEN   : out std_logic
    );
end entity;
```

## ポートの役割

- `CLK` : 状態更新に使うシステムクロック
- `RST_N` : アクティブLowの非同期リセット
- `I_ENABLE` : 状態遷移許可信号。'1'のクロックで次の状態へ進む
- `O_RED` : 赤信号出力
- `O_YELLOW` : 黄信号出力
- `O_GREEN` : 青信号出力

## 状態

次の3状態を用いる。

```text
ST_GREEN -> ST_YELLOW -> ST_RED -> ST_GREEN -> ...
```

各状態では、対応する出力だけを '1' にする。

| 状態 | `O_RED` | `O_YELLOW` | `O_GREEN` |
| --- | --- | --- | --- |
| `ST_GREEN` | 0 | 0 | 1 |
| `ST_YELLOW` | 0 | 1 | 0 |
| `ST_RED` | 1 | 0 | 0 |

## 動作仕様

1. `RST_N = '0'` のとき、状態を `ST_GREEN` にする。
2. `I_ENABLE = '1'` のクロック立ち上がりで、次の状態へ遷移する。
3. `I_ENABLE = '0'` のとき、現在の状態を保持する。
4. 状態遷移の順番は `ST_GREEN`、`ST_YELLOW`、`ST_RED`、`ST_GREEN` とする。
5. 常に3つの出力のうち1つだけを '1' にする。
6. 出力は現在の状態だけで決まる（Moore型）。

## 状態遷移表

| 現在の状態 | `I_ENABLE = 0` | `I_ENABLE = 1` |
| --- | --- | --- |
| `ST_GREEN` | `ST_GREEN` | `ST_YELLOW` |
| `ST_YELLOW` | `ST_YELLOW` | `ST_RED` |
| `ST_RED` | `ST_RED` | `ST_GREEN` |

## 確認用入力例

```text
I_ENABLE : 0 1 0 1 1 0 1 1 1
STATE    : G G Y Y R R G Y R
O_GREEN  : 1 1 0 0 0 0 1 0 0
O_YELLOW : 0 0 1 1 0 0 0 1 0
O_RED    : 0 0 0 0 1 1 0 0 1
```

リセット直後は `ST_GREEN` であり、`I_ENABLE = '1'` のクロックごとに状態が進む。

## 実装上の注意

- 状態を表す列挙型信号を用いると実装しやすい。
- 状態レジスタを更新するクロック付きプロセスを用意する。
- 次状態を決める組み合わせ回路を用意する。
- 現在状態から出力を決める組み合わせ回路を用意する。
- `I_ENABLE = '0'` の場合は、次状態を現在状態とする。
- 出力論理では、最初に全出力を '0' にしてから状態ごとに1つを '1' にすると安全である。

## 実装の目安

次の3ブロックに分けて考える。

```text
状態レジスタ: CLKでcurrent_stateを更新
次状態論理  : current_stateとI_ENABLEからnext_stateを決定
出力論理    : current_stateから信号機出力を決定
```

まずは1つのプロセスにまとめてもよいが、状態レジスタ・次状態論理・出力論理の役割を意識して記述すること。
