`timescale 1ns / 1ps

module PWM_Generator_tb;
  
  logic clk;
  logic increase_duty;
  logic decrease_duty;
  
  PWM_Generator	PWM_Generator_Unit(
  .clk(clk), 
  .increase_duty(increase_duty), 
  .decrease_duty(decrease_duty), 
  .PWM_OUT(PWM_OUT)
 );
 // Create 100Mhz clock
 initial begin
   $dumpfile("dump.vcd"); $dumpvars;
 clk = 0;
 forever #5 clk = ~clk;
 end 
 initial begin
  increase_duty = 0;
  decrease_duty = 0;
  #100; 
    increase_duty = 1; 
  #100;// increase duty cycle by 10%
    increase_duty = 0;
  #100; 
    increase_duty = 1;
  #100;// increase duty cycle by 10%
    increase_duty = 0;
  #100; 
    increase_duty = 1;
   #100; 
    increase_duty = 0;
   #100; 
    increase_duty = 1;
   #100; 
    increase_duty = 0;
  #100; 
    increase_duty = 1;
   #100; 
    increase_duty = 0;
  #100;
    decrease_duty = 1; 
  #100;//decrease duty cycle by 10%
    decrease_duty = 0;
  #100; 
    decrease_duty = 1;
  #100;//decrease duty cycle by 10%
    decrease_duty = 0;
  #100;
    decrease_duty = 1;
  #100;//decrease duty cycle by 10%
    decrease_duty = 0;
   #1000	$finish;
 end
  
endmodule