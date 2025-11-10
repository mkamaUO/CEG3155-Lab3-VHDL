--------------------------------------------------------------------------------
-- Title         : FSMController
-- Project       : CEG3155 Laboratory 3
-------------------------------------------------------------------------------
-- File          : FSMController.vhd
-- Student       : Moghesh Kamalaraj and Akash Karunaharan
-- Created       : 2025/10/29
-- Last modified : 2025/11/09
-------------------------------------------------------------------------------
-- Description : This file creates a Finite State Machine (FSM) controller for 
-- the traffic light system. It controls the states for both a main street and 
-- a side street, taking into account car sensors and a counter. The architecture 
-- is done at the RTL abstraction level and the implementation is done in structural VHDL.
-------------------------------------------------------------------------------

library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity FSMController is
    port (
        CLK: in std_logic;
        RESETN: in std_logic;
        
        -- Car sensor interface
        SSCS: in std_logic;                         -- Side Street Car Sensor
        
        -- Counter interface
        S: out std_logic_vector(1 downto 0);     	 -- Select Counter Load
                                                    -- 00: MSC
                                                    -- 01: MST
                                                    -- 10: SSC
                                                    -- 11: SST
        
        SetCounter: out std_logic;                  -- Set Counter
        CTO: in std_logic;                          -- Counter Overtime
        
        -- Light interface
        MSTL: out std_logic_vector(2 downto 0);     -- Main Street Traffic Lights
        SSTL: out std_logic_vector(2 downto 0)      -- Side Street Traffic Lights
    );
end;

architecture Structural of FSMController is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
	 
	 -- Define signals for state transition and output generation
    signal signalD, signalY: std_logic_vector(3 downto 0);
	 
begin

	 -- Generate D flip-flops for state transition
    generateDFF: for i in 1 downto 0 generate
        dffInst: enARdFF_2
            port map (
                i_resetBar => RESETN,
                i_d => signalD(i),
                i_enable => '1',
                i_clock => CLK,
                o_q => signalY(i)
            );
    end generate;
    
    -- State Transition
    signalD(1) <= (not(CTO) and signalY(1)) or (CTO and not(signalY(1)) and signalY(0)) or (signalY(1) and not(signalY(0)));
    signalD(0) <= (not(CTO) and signalY(0)) or (SSCS and CTO and not(signalY(0))) or (CTO and signalY(1) and not(signalY(0)));
    
    -- Select Counter Type Output Generation
    S(1) <= signalD(1);
    S(0) <= signalD(0);
	 
	 -- Main Street Traffic Light Output Generation
    MSTL(2) <= signalD(1); -- Red light
    MSTL(1) <= (SSCS and CTO and not(signalY(1)) and not(signalY(0))) or (not(CTO) and not(signalY(1)) and signalY(0)); -- Yellow light
    MSTL(0) <= (not(SSCS) and not(signalY(1)) and not(signalY(0))) or (not(CTO) and not(signalY(1)) and not(signalY(0))) or (CTO and signalY(1) and signalY(0)); -- Green light
    
	 -- Side Street Traffic Light Output Generation
    SSTL(2) <= (not(signalY(1)) and not(signalY(0))) or (not(CTO) and not(signalY(1))) or (CTO and signalY(1) and signalY(0)); -- Red light
    SSTL(1) <= (not(CTO) and signalY(1) and signalY(0)) or (CTO and signalY(1) and not(signalY(0))); -- Yellow light
    SSTL(0) <= (CTO and not(signalY(1)) and signalY(0)) or (not(CTO) and signalY(1) and not(signalY(0))); -- Green light
    
    -- Counter Output Generation
    SetCounter <= (((SSCS and CTO) or (CTO and signalY(1)) or (CTO and signalY(0))) and RESETN) or ('1' and not(RESETN)); -- signal equation for loading new counter values
end;
