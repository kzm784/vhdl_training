library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UP_DOWN_COUNTER_8BIT is
    port (
        CLK      : in  std_logic;
        RST_N    : in  std_logic;
        I_EN     : in  std_logic;
        I_UP_DOWN: in  std_logic;
        O_COUNT  : out unsigned(7 downto 0)
    );
end entity UP_DOWN_COUNTER_8BIT;

architecture RTL of UP_DOWN_COUNTER_8BIT is

    signal s_i_en      : std_logic := '0';
    signal s_i_up_down : std_logic := '0';
    signal s_o_count   : unsigned(7 downto 0) := (others => '0');

begin

    -- 入力信号保持
    process(CLK, RST_N)
    begin
        if (RST_N = '0') then
            s_i_en <= '0';
            s_i_up_down <= '0';
        elsif rising_edge(CLK) then
            s_i_en <= I_EN;
            s_i_up_down <= I_UP_DOWN;
        end if;
    end process;


    process(CLK, RST_N)
    begin
        if (RST_N = '0') then
            s_o_count <= (others => '0');
        elsif rising_edge(CLK) then
            if (s_i_en = '1' and s_i_up_down = '1') then -- UP 
                s_o_count <= s_o_count + 1;
            elsif (s_i_en = '1' and s_i_up_down = '0') then -- DOWN
                if (s_o_count = 0) then
                    s_o_count <= 255;
                else
                    s_o_count <= s_o_count - 1;
                end if;
            end if;
        end if;
    end process;

    O_COUNT <= s_o_count;

end architecture RTL;
