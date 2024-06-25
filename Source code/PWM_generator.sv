
module DFF_PWM(
	input logic clk,
  	input logic en,
  	input logic D,
  	output logic Q
);
  
  always_ff @(posedge clk)	begin: D_ffs
    if(en)	begin
      Q<=D;
    end
  end: D_ffs
endmodule: DFF_PWM

module PWM_Generator(
	input logic clk,
  	input logic increase_duty,
  	input logic decrease_duty,
  	output logic PWM_OUT
);
  
logic slow_clk_enable; // slow clock enable signal for debouncing FFs
logic [27:0] counter_debounce=0;// counter for creating slow clock enable signals 
logic tmp1,tmp2,duty_inc;// temporary flip-flop signals for debouncing the increasing button
logic tmp3,tmp4,duty_dec;// temporary flip-flop signals for debouncing the decreasing button  
logic [3:0] counter_PWM=0;// counter for creating 10Mhz PWM signal
logic [3:0] DUTY_CYCLE=2; // initial duty cycle is 50%
  
  always_ff @(posedge clk)	begin: debouncing_ffs
    counter_debounce <= counter_debounce + 1;
    if(counter_debounce>=1) 
    counter_debounce <= 0;
  end: debouncing_ffs
  
assign slow_clk_enable = counter_debounce == 1 ?1:0;
  // debouncing FFs for increasing button
 DFF_PWM PWM_DFF1(clk,slow_clk_enable,increase_duty,tmp1);
 DFF_PWM PWM_DFF2(clk,slow_clk_enable,tmp1, tmp2); 
assign duty_inc =  tmp1 & (~ tmp2) & slow_clk_enable;
 // debouncing FFs for decreasing button
 DFF_PWM PWM_DFF3(clk,slow_clk_enable,decrease_duty, tmp3);
 DFF_PWM PWM_DFF4(clk,slow_clk_enable,tmp3, tmp4); 
assign duty_dec =  tmp3 & (~ tmp4) & slow_clk_enable;
  
  always_ff @(posedge clk)	begin: DUTY_CONTROL_FFs
    if(duty_inc==1 && DUTY_CYCLE<=9)	begin: increase_duty_cycle
      DUTY_CYCLE<=DUTY_CYCLE+1;
    end: increase_duty_cycle
    else if(duty_dec==1 && DUTY_CYCLE>0)	begin: decrease_duty_cycle
      DUTY_CYCLE<=DUTY_CYCLE-1;
    end: decrease_duty_cycle
  end: DUTY_CONTROL_FFs
  
  always_ff @(posedge clk)	begin: PWM_GEN_FFs
   counter_PWM <= counter_PWM + 1;
    if(counter_PWM>=9) begin
    	counter_PWM <= 0;
    end
    
 end: PWM_GEN_FFs
  
 assign PWM_OUT = counter_PWM < DUTY_CYCLE ? 1:0;
  
endmodule: PWM_Generator
