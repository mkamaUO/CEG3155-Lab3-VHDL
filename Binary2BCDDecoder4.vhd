--------------------------------------------------------------------------------
-- Title         : Binary2BCDDecoder4
-- Project       : CEG3155 Laboratory 3
-------------------------------------------------------------------------------
-- File          : Binary2BCDDecoder4.vhd
-- Student       : Moghesh Kamalaraj and Akash Karunaharan
-- Created       : 2025/10/29
-- Last modified : 2025/11/09
-------------------------------------------------------------------------------
-- Description : This file creates a a Binary to BCD (Binary-Coded Decimal) decoder 
-- for a 4-bit binary input. The decoder converts a 4-bit binary number into two 
-- 4-bit BCD digits. The input BIN is a 4-bit binary number, and the outputs BCD1 
-- and BCD0 are the two BCD digits. The architecture is done at the RTL abstraction 
-- level and the implementation is done in structural VHDL.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Binary2BCDDecoder4 is
    port (
        BIN: in std_logic_vector(3 downto 0);
        BCD1, BCD0: out std_logic_vector(3 downto 0)
    );
end entity;

architecture Structural of Binary2BCDDecoder4 is
begin
	 -- BCD1 output: most significant digit
    BCD1(3 downto 1) <= "000"; -- Bits 3 to 1 are always 0, since the maximum value is 15
    BCD1(0) <= (BIN(3) and BIN(1)) or (BIN(3) and BIN(2)); -- BCD1 will need to be 1 when 10-15 is input
    
	 -- BCD0 output: least significant digit (values 0-9)
    BCD0(3) <= BIN(3) and not BIN(2) and not BIN(1);
    BCD0(2) <= BIN(2) and (not BIN(3) or BIN(1));   
    BCD0(1) <= (not BIN(3) and BIN(1)) or (BIN(3) and BIN(2) and not BIN(1));
    BCD0(0) <= BIN(0);
end;
