# VHDLテンプレート

## 命名規則

- エンティティ名: 大文字 + アンダースコア
  - 例: `SYNC_UP_COUNTER_4BIT`
- クロック/リセット: `CLK`, `RST_N`
- 入力: `I_` を付ける
  - 例: `I_EN`, `I_D`, `I_LOAD`
- 出力: `O_` を付ける
  - 例: `O_COUNT`, `O_FLAG`
- 内部信号: `s_` を付ける
  - 例: `s_o_count`

## 使い方

各問題フォルダ内で、[TEMPLATE.vhd](TEMPLATE.vhd) をコピーして、
エンティティ名とポート名を問題に合わせて書き換えるだけで使えます。

## テンプレートファイル

- [TEMPLATE.vhd](TEMPLATE.vhd)

## 例

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
