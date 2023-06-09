----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2023 20:19:31
-- Design Name: 
-- Module Name: Nex_Transmitter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Nex_Transmitter is
  Port (
        clk : in std_logic;
        rst : in std_logic;
        
        data_bit : in std_logic;
        
        led_bytes : out std_logic_vector(7 downto 0);
        
        rx_tx_switch : in std_logic;
       
        baud_switches : in STD_LOGIC_VECTOR (2 downto 0)
  
   );
end Nex_Transmitter;

architecture Behavioral of Nex_Transmitter is

    signal d_byte : std_logic_vector(7 downto 0) := (others => '0');
    signal parity : std_logic;
    
    signal clk_bits : integer range 0 to 9 := 0;
    
    signal sig_baud_enable : std_logic;
    
    signal data_busy : std_logic := '0';
    
    signal end_bit : std_logic := '0';
    
    signal dat_led : natural := 0;

begin

     baud_en0 : entity work.baud
        port map (
            clk => clk,
            rst => rst,
            clk_baud => sig_baud_enable,
            baud_sw => baud_switches,
            rx_tx_switch => rx_tx_switch
             );


    inside : process(clk, sig_baud_enable) is
    begin
    if (rising_edge(clk)) then
    if (sig_baud_enable = '1') then
        if (data_bit = '0' and data_busy = '0') then
                data_busy <= '1';
                end_bit <= '0';
                clk_bits <= 0;
        elsif (data_busy = '1') then
                if (rx_tx_switch = '0') then
                    
                        if (clk_bits < 8) then
                            d_byte(clk_bits) <= data_bit;
                            clk_bits <= clk_bits + 1;
                        elsif (clk_bits = 8) then
                            parity <= data_bit;
                            clk_bits <= clk_bits + 1;
                        elsif (clk_bits = 9) then
                            end_bit <= data_bit;
                            clk_bits <= clk_bits + 1;
                            data_busy <= '0';
                        end if;
                end if;
             end if;
         end if;
         end if;
     end process inside;
     
     
     
     mit : process(clk) is
     begin
            if (rising_edge(clk)) then
                if (sig_baud_enable = '1') then
                    if (end_bit = '1') then
                        led_bytes <= d_byte; 
                    end if;
                end if;
            end if;
     end process mit;
     
     
     
end Behavioral;