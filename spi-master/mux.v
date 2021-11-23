module mux(i_dat0, i_dat1, i_control, o_dat);

input i_dat0, i_dat1, i_control;

output o_dat;
  
assign o_dat = i_control ? i_dat1 : i_dat0;
  
endmodule