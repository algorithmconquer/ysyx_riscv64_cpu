module alu (
  input         [`CPU_WIDTH-1:0]      src1    ,
  input         [`CPU_WIDTH-1:0]      src2    ,
  input         [`EXU_OPT_WIDTH-1:0]  opt     ,
  output logic  [`CPU_WIDTH-1:0]      result  ,
  output logic                        sububit 
); 

  always @(*) begin
    result   = `CPU_WIDTH'b0;
    sububit  = 1'b0;
    case (opt)
        `ALU_ADD:   result = src1 + src2;
        `ALU_SUB:   result = src1 - src2;
        `ALU_ADDW:  begin result[31:0] = src1[31:0] + src2[31:0]; result = {{32{result[31]}}, result[31:0]};end
        `ALU_SUBW:  begin result[31:0] = src1[31:0] - src2[31:0]; result = {{32{result[31]}}, result[31:0]};end
        `ALU_AND:   result = src1 & src2;
        `ALU_OR:    result = src1 | src2;
        `ALU_XOR:   result = src1 ^ src2;
        `ALU_SLL:   result = src1 << src2[5:0];
        `ALU_SRL:   result = src1 >> src2[5:0];
        `ALU_SRA:   result = {{{64{src1[63]}},src1} >> src2[5:0]}[63:0];
        `ALU_SLLW:  begin result[31:0] = src1[31:0] << src2[4:0];             result = {{32{result[31]}},result[31:0]}; end
        `ALU_SRLW:  begin result[31:0] = src1[31:0] >> src2[4:0];             result = {{32{result[31]}},result[31:0]}; end
        `ALU_SRAW:  begin result = {{32{src1[31]}}, src1[31:0]} >> src2[4:0]; result = {{32{result[31]}},result[31:0]}; end
        `ALU_MUL:   result = src1 * src2;
        `ALU_MULH:  result = src1 * src2 >> 64;
        `ALU_MULHSU:result = {{1'b0, src1} * src2 >> 64}[63:0];
        `ALU_MULHU: result = {{1'b0, src1} * {1'b0, src2} >> 64}[63:0]; 
        `ALU_DIV:   result = src1 / src2;
        `ALU_DIVU:  result = {{1'b0, src1} / {1'b0, src2}}[63:0];
        `ALU_REM:   result = src1 % src2;
        `ALU_REMU:  result = {{1'b0, src1} % {1'b0, src2}}[63:0];
        `ALU_MULW:  begin result[31:0] = {src1[31:0] * src2[31:0]}[31:0];             result = {{32{result[31]}}, result[31:0]}; end
        `ALU_DIVW:  begin result[31:0] = {src1[31:0] / src2[31:0]};                   result = {{32{result[31]}}, result[31:0]}; end
        `ALU_DIVUW: begin result[31:0] = {{1'b0,src1[31:0]}/{1'b0,src2[31:0]}}[31:0]; result = {{32{result[31]}}, result[31:0]}; end
        `ALU_REMW:  begin result[31:0] = {src1[31:0] % src2[31:0]};                   result = {{32{result[31]}}, result[31:0]}; end
        `ALU_REMUW: begin result[31:0] = {{1'b0,src1[31:0]}%{1'b0,src2[31:0]}}[31:0]; result = {{32{result[31]}}, result[31:0]}; end
        `ALU_SUBU:  {sububit,result} = {1'b0,src1} - {1'b0,src2};  // use for sltu,bltu,bgeu
        default: ;
    endcase
  end

endmodule
