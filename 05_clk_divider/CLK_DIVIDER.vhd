library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CLK_DIVIDER is
    port (
        CLK        : in  std_logic;
        RST_N      : in  std_logic;
        I_DIV_RATIO: in  unsigned(7 downto 0);
        O_CLK_DIV  : out std_logic
    );
end entity CLK_DIVIDER;

architecture RTL of CLK_DIVIDER is
    signal s_cnt       : unsigned(7 downto 0) := (others => '0');
    signal s_o_clk_div : std_logic := '0';
begin

    process(CLK, RST_N)
    begin
        if (RST_N = '0') then
            s_cnt       <= (others => '0');
            s_o_clk_div <= '0';
        elsif rising_edge(CLK) then
            if (s_cnt = I_DIV_RATIO - 1) then
                s_cnt       <= (others => '0');
                s_o_clk_div <= not s_o_clk_div;
            else
                s_cnt <= s_cnt + 1;
            end if;
        end if;
    end process;

    O_CLK_DIV <= s_o_clk_div;

end architecture RTL;