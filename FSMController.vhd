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

    signal signalD, signalY: std_logic_vector(3 downto 0);
begin
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
    
    -- Output Generation
    S(1) <= signalD(1);
    S(0) <= signalD(0);
	 
	 
    MSTL(2) <= signalD(1);
    MSTL(1) <= (SSCS and CTO and not(signalY(1)) and not(signalY(0))) or (not(CTO) and not(signalY(1)) and signalY(0));
    MSTL(0) <= (not(SSCS) and not(signalY(1)) and not(signalY(0))) or (not(CTO) and not(signalY(1)) and not(signalY(0))) or (CTO and signalY(1) and signalY(0));
    
    SSTL(2) <= (not(signalY(1)) and not(signalY(0))) or (not(CTO) and not(signalY(1))) or (CTO and signalY(1) and signalY(0));
    SSTL(1) <= (not(CTO) and signalY(1) and signalY(0)) or (CTO and signalY(1) and not(signalY(0)));
    SSTL(0) <= (CTO and not(signalY(1)) and signalY(0)) or (not(CTO) and signalY(1) and not(signalY(0)));
    
    
    SetCounter <= (((SSCS and CTO) or (CTO and signalY(1)) or (CTO and signalY(0))) and RESETN) or ('1' and not(RESETN));
end;
