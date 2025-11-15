This is a verilog project of dds.

## Attributes

​    wave_amp[1:0]: Decide the output amplitude.

​    f_word[7:0]: Decide the output frequency. The formula is below:  
$$
f_{word} = (1 << 8) * freq_{dst} / freq_{ref}
$$
​    p_word[7:0]: Additional phase.

​    wave_sel[1:0]: Select the  type of waveform.

| wave_sel |   type   |       status       |
| :------: | :------: | :----------------: |
|  2'b00   |  cosine  |     completed      |
|  2'b01   |  pulse   | diy in `src/mem.v` |
|  2'b10   | triangle |        diy in `src/mem.v`        |
|  2'b11   |   AWG    |        diy in `src/mem.v`        |



## Toolchain

iverilog+gtkwave 

