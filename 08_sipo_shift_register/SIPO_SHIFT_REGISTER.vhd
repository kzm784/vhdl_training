library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SIPO_SHIFT_REGISTER is
    port (
        CLK       : in  std_logic;
        RST_N     : in  std_logic;
        I_SERIAL  : in  std_logic;
        I_SHIFT_EN: in  std_logic;
        O_PARALLEL: out std_logic_vector(7 downto 0);
        O_DONE    : out std_logic
    );
end entity SIPO_SHIFT_REGISTER;

architecture RTL of SIPO_SHIFT_REGISTER is
    
    signal s_o_done     : std_logic := '0';
    signal s_reg        : std_logic_vector(7 downto 0) := (others => '0');
    signal s_cnt        : unsigned(2 downto 0)         := (others => '0');

begin

    -- シリアル・パラレル変換
    process(CLK, RST_N)
    begin
        if (RST_N = '0') then
            s_o_done     <= '0';
            s_reg        <= (others => '0');
            s_cnt        <= (others => '0');

        elsif rising_edge(CLK) then
            if (I_SHIFT_EN = '1') then
                if (s_o_done = '1') then
                    s_o_done <= '0';
                else
                    s_cnt <= s_cnt + 1;
                    s_reg <= s_reg(6 downto 0) & I_SERIAL;
                
                    if (s_cnt = 7) then
                        s_cnt <= (others => '0');
                        s_o_done <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    O_PARALLEL <= s_reg;
    O_DONE     <= s_o_done;

end architecture RTL;
