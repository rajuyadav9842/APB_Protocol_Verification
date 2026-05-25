module apb_slave(dut_if.slave dif);
 
  logic [31:0] mem [0:255];
 
  typedef enum logic [1:0] {
    IDLE   = 2'b00,
    SETUP  = 2'b01,
    ACCESS = 2'b10
  } apb_state_t;
 
  apb_state_t present_state, next_state;
 
  
  always_ff @(posedge dif.pclk or negedge dif.rst_n) begin
    if(!dif.rst_n)
      present_state <= IDLE;
    else
      present_state <= next_state;
  end
 
 
  
  always_comb begin
    case(present_state)
 
      IDLE:
        next_state = (dif.psel) ? SETUP : IDLE;
 
      SETUP:
        next_state = ACCESS;
 
      ACCESS: begin
        if(!dif.pready)
          next_state = ACCESS;   
        else
          next_state = (dif.psel && !dif.penable) ? SETUP : IDLE; 
          
      end
 
      default:
        next_state = IDLE;
 
    endcase
  end
 
 
  
  always_ff @(posedge dif.pclk or negedge dif.rst_n) begin
    if(!dif.rst_n) begin
 
      for(int i=0;i<256;i++)
        mem[i] <= 0;
 
      dif.prdata <= 0;
      dif.pready <= 0;
 
    end
    else begin
 
      case(present_state)
 
        IDLE, SETUP: begin
          dif.pready <= 0;
        end
 
        ACCESS: begin
          dif.pready <= 1;
 
          if(dif.psel && dif.penable) begin
 
            if(dif.pwrite)
              mem[dif.paddr[7:0]] <= dif.pwdata;
            else
              dif.prdata <= mem[dif.paddr[7:0]];
 
          end
 
        end
 
      endcase
 
    end
  end
 
endmodule

interface dut_if(input logic pclk, rst_n);
  
  logic        psel;
  logic        penable;
  logic        pwrite;
  logic [31:0] paddr;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;

  modport slave (
    input  pclk, rst_n, psel, penable, pwrite, paddr, pwdata, 
    output prdata, pready
  );

    sequence setup;
      (psel && !penable);
    endsequence

  property penable_only_when_psel;
    @(posedge pclk)
    disable iff (!rst_n)
     setup |=> penable;
  endproperty

  property stable_addr_data_during_access;
    @(posedge pclk)
    disable iff (!rst_n)
    setup |=>  ($stable(paddr) && $stable(pwdata));
  endproperty

   assert property(penable_only_when_psel) else
    $error("penable should  be high in access phase.");

  assert property(stable_addr_data_during_access) else
    $error("Address and data must be stable between setup and access phases.");

endinterface














