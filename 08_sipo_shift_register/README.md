# 08_sipo_shift_register

## モジュール名
`sipo_shift_register`

## 目的
Serial In Parallel Out（シリアル入力／並列出力）のシフトレジスタを設計する。

1ビットずつ入力されたデータを8クロック分集積し、8ビット並列データとして一度に出力する回路を実装。
シリアル→並列変換とPISOの逆プロセスを学ぶ。

## 入出力ポート

```vhdl
entity SIPO_SHIFT_REGISTER is
    port (
        CLK       : in  std_logic;
        RST_N     : in  std_logic;
        I_SERIAL  : in  std_logic;
        I_SHIFT_EN: in  std_logic;
        O_PARALLEL: out std_logic_vector(7 downto 0);
        O_DONE    : out std_logic
    );
end entity;
```

## ポートの役割

- `CLK` : クロック
- `RST_N` : リセット
- `I_SERIAL` : シリアル入力（1ビットずつ）
- `I_SHIFT_EN` : シフト有効信号
- `O_PARALLEL` : 8ビット並列データ出力
- `O_DONE` : データ受信完了フラグ

## 動作仕様

1. `rst_n = '0'` のとき、内部レジスタをクリアし、`done = '0'`（受信待機状態）。
2. `done = '0'` かつ `shift_en = '1'` のとき、`serial_in` を受け取ってシフト。
   - 毎クロック1ビットを右側から取り込む（最下位ビットからスタート）
   - シフトカウンタをインクリメント
3. `shift_en = '0'` のときは、シフト動作を停止し保持する。
4. シフトカウンタが7に達したら、次のクロックで `done = '1'` に変更（受信完了）。
5. `done = '1'` の状態で `shift_en = '1'` が入ると、次のデータ受信のために `done = '0'` に戻る。
6. `done = '1'` の間、`O_PARALLEL` に受信完了したデータを出力。

## 実装上の注意

- 右シフトで受信する（最下位ビットから最上位ビットへ）
- 内部カウンタは 3 ビット（0～7）で、8 ビットの受信を管理
- `done` の初期値は '0'（受信待機）
- `shift_en` でシフト動作を制御
- 受信完了後は次のシフト信号まで出力を保持

## 確認用入力例

### WaveDrom波形

WaveDrom拡張機能をインストール済みのVS Codeでは、次のファイルを開いて波形を確認できる。

- [SIPO_SHIFT_REGISTER.json5](SIPO_SHIFT_REGISTER.json5)

この波形では、`I_SERIAL = 10101011` を8回サンプリングし、受信完了後に
`O_PARALLEL = 11010101`、`O_DONE = '1'` となる動作を示している。

### 例1: シリアル受信→並列出力

```text
CLK    : 0  1  2  3  4  5  6  7  8  9  10
RST_N  : 1  1  1  1  1  1  1  1  1  1  1
SHIFT_EN: 1  1  1  1  1  1  1  1  1  0  0
SERIAL  : 1  0  1  0  1  0  1  1  X  X  X
O_DONE  : 0  0  0  0  0  0  0  0  1  1  1
O_PAR   : X  X  X  X  X  X  X  X  11010101 11010101
```

- CLK=0-7: シリアル入力`1,0,1,0,1,0,1,1`を8クロックで受信
- CLK=8: 受信完了 → `done='1'`, `parallel=11010101`
- CLK=9-: `shift_en='0'`で保持

### 例2: 連続受信

```text
CLK=0-8 : 最初のデータ受信（結果:11010101）
CLK=9   : SHIFT_EN='1'で新規受信開始 → done:'1'→'0'
CLK=10-17: 次のデータ受信
CLK=18  : 受信完了
```

## 実装の目安

SIPOはPISOの逆方向処理である。
- PISOでは「出力」が中心
- SIPOでは「入力」が中心

8回のシフト入力と完了フラグの生成が重要である。
