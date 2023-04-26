----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 01:10:52 PM
-- Design Name: 
-- Module Name: UART - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is
    port (
    CLK100MHZ : in    std_logic;
    RxTx      : in    std_logic;
    SBIT      : in    std_logic;
    DATA      : in    std_logic_vector(7 downto 0);
    ONEBYTE   : in    std_logic;
    BAUD      : in    std_logic_vector(2 downto 0);
    
    BTNC      : in    std_logic;
    
    TX : out std_logic;
    RX : in std_logic;
    
     ARR : out std_logic_vector(7 downto 0)
    -- LED       : out   std_logic_vector(15 downto 0) -- Bit reciever LED-information
    );
end UART;

architecture Behavioral of UART is

    signal byte_in : std_logic_vector(7 downto 0);
    signal valid : std_logic :='0';

begin

    reciever : entity work.Nex_Reciever
        port map(
            clk => CLK100MHZ,
            rst => BTNC,
            rx_tx_switch => RxTx,
            start_bit => SBIT,
            data_in_sw => DATA(7 downto 0),
            one_byte => ONEBYTE,
            baud_switches => BAUD(2 downto 0),
            
            byte_out => TX
            );
    
    
    transmitter : entity work.Nex_Transmitter
        port map(
            clk => CLK100MHZ,
            rst => BTNC,
            rx_tx_switch => RxTx,
            data_bit => RX,
            baud_switches => BAUD(2 downto 0),
            led_bytes => ARR
            );
            
end Behavioral;
