library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PISO_SHIFT_REGISTER is
    port (
        CLK        : in  std_logic;
        RST_N      : in  std_logic;
        I_LOAD     : in  std_logic;
        I_PARALLEL : in  std_logic_vector(7 downto 0);
        O_SERIAL   : out std_logic;
        O_DONE     : out std_logic
    );
end entity PISO_SHIFT_REGISTER;

architecture RTL of PISO_SHIFT_REGISTER is
    signal s_reg      : std_logic_vector(7 downto 0) := (others => '0');
    signal s_cnt      : unsigned(2 downto 0)         := (others => '0');
    signal s_o_serial : std_logic := '0';
    signal s_o_done   : std_logic := '0';
begin

    process(CLK, RST_N)
    begin
        if (RST_N = '0') then
            s_reg    <= (others => '0');
            s_cnt    <= (others => '0');
            s_o_done <= '1';
        elsif rising_edge(CLK) then
            if (s_o_done = '1') then    -- シフト転送完了中
                if (I_LOAD = '1') then
                    s_reg <= I_PARALLEL;
                    s_o_done = '0';
                end if;
            else                        -- シフト転送中
                s_cnt <= s_cnt + 1;
                s_o_serial <= s_reg(7);
                s_reg <= s_reg(6 downto 0) & '0';   -- 最上位ビットを捨てる

                if (s_cnt = 7) then             -- シフト転送完了
                    s_cnt <= (others => '0');   -- カウンタをリセット
                    s_reg <= (others => '0');   -- レジスタの値をクリア（この時点ですべて0になっているはず．）
                    s_o_done <= '1';            -- シフト転送完了フラグ立てる
                end if;
            end if;
        end if;
    end process;

    O_SERIAL <= s_o_serial;
    O_DONE   <= s_o_done;

end architecture RTL;
