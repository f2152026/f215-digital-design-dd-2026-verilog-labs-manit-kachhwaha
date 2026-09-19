module tb;

reg [1:0] t_a, t_b;
wire t_gt, t_lt,t_eq;
reg exp_gt, exp_lt, exp_eq;
integer ia, ib;
integer errors,total;

comp2 dut(
.A (t_a),
.B (t_b),
.GT (t_gt),
.LT (t_lt),
.EQ (t_eq)
);

string vcd_file;
initial begin
  if ($value$plusargs("vcd=%s", vcd_file)) begin
    $dumpfile(vcd_file);
    $dumpvars(0, dut);
  end
end

initial begin
errors = 0;
    

for (ia = 0; ia < 4; ia = ia + 1) begin
  for (ib = 0; ib < 4; ib = ib + 1) begin
    t_a = ia;
    t_b = ib;

    exp_gt = (ia >  ib);
    exp_lt = (ia <  ib);
    exp_eq = (ia == ib);

    total = total + 1;
    if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
          $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
    end
  end
end

$write("SUMMARY: %0d/%0d passed", total - errors, total);

$finish;
end

endmodule