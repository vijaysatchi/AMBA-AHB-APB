# AMBA-AHB-APB
Coding the AMBA AHB/APB protocols in Verilog.

## APB WAVEFORM:
![image](https://github.com/user-attachments/assets/ba516347-aee1-45c7-a5d3-f2abae96dc6e)

The image above holds the results of running our implementation of the APB protocol in Verilog. Details of the simulation including the test data can be found in the apb_tb.v file.

## AHB WAVEFORMS
The sections below will hold the waveform results of performing various operations under the AHB protocol.

# 8 Beat Write-Increment followed by 8 beat Read-Increment from Master #3
<img width="1227" height="753" alt="image" src="https://github.com/user-attachments/assets/636beabb-255a-45d1-9b48-497796113db2" />

# 4 Beat Write-Increment followed by 4 beat Read-Increment from Master #2
<img width="952" height="736" alt="image" src="https://github.com/user-attachments/assets/bb2e881e-9a4f-4f46-8c15-faf09dfc0cc7" />

# Out of bounds 8 beat Write/Read-Increment operation
<img width="1017" height="745" alt="image" src="https://github.com/user-attachments/assets/6bd07486-7e1a-4f48-ba27-af84cdb6a7ac" />
This transfer is displayed specifically to showcase how a transfer is handled when it would go out of bounds.

# 16-Beat Write/Read-wrap operation.
<img width="1534" height="738" alt="image" src="https://github.com/user-attachments/assets/18965733-a9b5-4754-bf53-bd83b6cfeb17" />
