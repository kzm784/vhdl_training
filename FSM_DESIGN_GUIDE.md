# VHDLで状態遷移回路を設計する定石

## 1. 状態遷移回路とは

状態遷移回路は、現在の状態と入力信号から次の状態を決定し、クロックの立ち上がりで状態を更新する回路である。

```text
現在状態 + 入力
       |
       v
   次状態論理
       |
       v
次のクロックで状態更新
```

FSM（Finite State Machine、有限状態機械）として設計する。

## 2. FSMの基本要素

FSMは次の3要素に分けて考える。

1. 状態レジスタ
2. 次状態論理
3. 出力論理

### 状態レジスタ

現在の状態をフリップフロップで保持する。

```vhdl
process(CLK, RST_N)
begin
    if (RST_N = '0') then
        s_current_state <= ST_IDLE;
    elsif rising_edge(CLK) then
        s_current_state <= s_next_state;
    end if;
end process;
```

状態レジスタでは、リセット時の初期状態設定と、クロックエッジでの状態更新だけを行う。

### 次状態論理

現在状態と入力から、次のクロックで遷移する状態を決める。

```vhdl
process(s_current_state, I_START)
begin
    s_next_state <= s_current_state;

    case s_current_state is
        when ST_IDLE =>
            if (I_START = '1') then
                s_next_state <= ST_RUN;
            end if;

        when ST_RUN =>
            s_next_state <= ST_IDLE;

        when others =>
            s_next_state <= ST_IDLE;
    end case;
end process;
```

最初に `s_next_state <= s_current_state;` と書くことで、条件に該当しない場合の状態保持を明示する。代入漏れによるラッチ推論を防ぐための定石である。

### 出力論理

現在状態から出力を決める。現在状態だけで出力が決まる方式を Moore 型という。

```vhdl
process(s_current_state)
begin
    O_BUSY <= '0';

    case s_current_state is
        when ST_RUN =>
            O_BUSY <= '1';

        when others =>
            O_BUSY <= '0';
    end case;
end process;
```

最初に出力のデフォルト値を設定し、その後で状態ごとの差分だけを代入する。

## 3. 状態の宣言

状態名には動作の意味を持たせる。列挙型を使うと状態遷移が読みやすい。

```vhdl
type t_state is (
    ST_IDLE,
    ST_RUN,
    ST_DONE
);

signal s_current_state : t_state := ST_IDLE;
signal s_next_state    : t_state := ST_IDLE;
```

`ST_0`、`ST_1` のような名前より、`ST_IDLE`、`ST_RECEIVE`、`ST_ERROR` のような名前が望ましい。

## 4. 設計手順

### 手順1: 状態を日本語で列挙する

```text
待機、受信中、完了
```

### 手順2: 各状態の役割を書く

```text
待機  : 開始条件を待つ
受信中: データを処理する
完了  : 完了を1クロック通知する
```

### 手順3: 遷移条件を整理する

```text
待機 + START       -> 受信中
受信中 + FINISH    -> 完了
完了               -> 待機
```

### 手順4: 状態遷移表を作る

| 現在状態 | 条件 | 次状態 |
| --- | --- | --- |
| `ST_IDLE` | `START = 0` | `ST_IDLE` |
| `ST_IDLE` | `START = 1` | `ST_RUN` |
| `ST_RUN` | `FINISH = 0` | `ST_RUN` |
| `ST_RUN` | `FINISH = 1` | `ST_DONE` |
| `ST_DONE` | 条件なし | `ST_IDLE` |

### 手順5: 状態レジスタ、次状態論理、出力論理に分ける

最初は3プロセス構成が理解しやすい。慣れてから1プロセスFSMやMealy型へ進む。

## 5. Moore型とMealy型

### Moore型

出力が現在状態だけで決まる。

```text
出力 = 現在状態
```

出力がクロック同期で変化しやすく、状態図と対応づけやすい。初学者にはMoore型を推奨する。

### Mealy型

出力が現在状態と入力で決まる。

```text
出力 = 現在状態 + 入力
```

入力に応じて出力を早く変化させられる一方、入力の変化による出力の揺れに注意する。

## 6. よくある注意点

- 状態更新には `rising_edge(CLK)` を使う
- リセット後の初期状態を決める
- 次状態論理でデフォルトとして現在状態を保持する
- 出力論理でデフォルト値を設定する
- `when others` で異常状態から安全な状態へ戻す
- 状態遷移表とRTLの条件が一致しているか確認する
- 1クロック幅のパルスは、状態を1クロックだけ用意すると実装しやすい

## 7. デバッグの考え方

波形では、次の順番で確認する。

1. リセット後の状態
2. 入力を与えたクロックで次状態が正しいか
3. 入力がないときに状態を保持するか
4. 完了やエラー状態から意図した状態へ戻るか
5. 各状態で出力が正しいか

状態名、現在状態、次状態、入力、出力を同時に観測すると原因を見つけやすい。

## まとめ

状態遷移回路を設計するときは、いきなりVHDLを書かない。

```text
状態を列挙
  -> 遷移条件を整理
  -> 状態遷移表を作成
  -> 状態レジスタを記述
  -> 次状態論理を記述
  -> 出力論理を記述
  -> 波形で確認
```

この手順を繰り返すことが、FSM設計の基本的な定石である。
