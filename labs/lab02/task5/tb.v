// tb.v -- self-checking testbench for alu.v
module tb;

reg [3:0] t_a, t_b;
reg t_op;
wire [3:0] t_result;

reg [3:0] exp_result;
integer ia, ib, iop;
integer errors, total;

alu DUT (
.a (t_a),
.b (t_b),
.op (t_op),
.result (t_result)
);

string vcd_file;
initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
end

initial begin
    errors = 0;
    total  = 0;
 
    for (ia = 0; ia < 16; ia = ia + 1) begin
      for (ib = 0; ib < 16; ib = ib + 1) begin
        for (iop = 0; iop < 2; iop = iop + 1) begin
 
         
          t_a  = ia;
          t_b  = ib;
          t_op = iop;
 
          if (iop == 0) exp_result = ia + ib;
          else          exp_result = ia - ib;
 
          total = total + 1;
          if (t_result !== exp_result) begin
            $display("FAIL at time %0t: op=%b A=%0d B=%0d  got %0d  expected %0d",
                     $time, t_op, t_a, t_b, t_result, exp_result);
            errors = errors + 1;
          end
        end
      end
    end
 
    for (iop = 0; iop < 2; iop = iop + 1) begin
      for (ia = 0; ia < 16; ia = ia + 1) begin
        for (ib = 0; ib < 16; ib = ib + 1) begin
 
          t_a  = ia;
          t_b  = ib;
          t_op = iop;
 
          if (iop == 0) exp_result = ia + ib;
          else          exp_result = ia - ib;
 
          #5;
 
          total = total + 1;
          if (t_result !== exp_result) begin
            $display("FAIL at time %0t: op=%b A=%0d B=%0d  got %0d  expected %0d",
                     $time, t_op, t_a, t_b, t_result, exp_result);
            errors = errors + 1;
          end
        end
      end
    end
 
    $write("SUMMARY: %0d/%0d passed", total - errors, total);
    $finish; 
end
 
endmodule