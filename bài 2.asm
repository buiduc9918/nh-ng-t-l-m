DAUVAO 			EQU	 	0x2000H; địa chỉ bắt đầu của mảng
MANGDUONG    	EQU	 	0x3000H; địa chỉ bắt đầu của mảng số dương
MANGAM 			EQU     0x5000H; địa chỉ bắt đầu của mảng số âm
NHO2			EQU		0x0500H; địa chỉ của số nhỏ thứ 2
LON2			EQU		0x0504H; địa chỉ của số lớn thứ 2


AREA Bai2, CODE, READONLY
ENTRY 
EXPORT main

main 				MOV R0, #0; biến chạy i được dùng để đếm số phần tử của mảng ban đầu
					MOV R1, MANGDUONG; R1 được gán với mảng dương      
					MOV R2, MANGAM; R2 được gán với mảng âm
					MOV R4, #0 ;chiều dài của mảng dương bắt đầu với giá trị bằng 0
					MOV R5, #0 ;chiều dài của mảng âm bắt đầu với giá trị bằng 0

;Lọc các số âm và số dương
LOOP				LDR R3, DAUVAO; R3 được gán với đầu vào của chuỗi ban đầu 
					CMP R3, #0; so sánh R3 với 0
					BLGT LUUDUONG; nếu R3 > 0 thì chuyển sang LUUDUONG
					BLLT LUUAM; nếu R3 < 0 thì chuyển sang LUUAM
					ADD R3, R3, #4; tăng giá trị R3 lên 4 đơn vị để chuyển sang ô nhớ tiếp theo
					ADD R0, R0, #1; biến chạy R0 được tăng thêm 1 đơn vị
					CMP R0, #256; so sánh R0 với 256
					BNE LOOP
					BEQ SAPXEPDUONG; nếu bằng thì chuyển sang SAPXEP

LUUDUONG			STR R3, [R1]; lưu giá trị vào R1 
					ADD R1, R1, #4; R1 được tăng thêm 4 để trỏ tới ô nhớ tiếp theo
					ADD R4, R4, #1; chiều dài của mảng dương được tăng thêm 1
					MOV PC, LR; trở lại hàm

LUUAM    			STR R3, [R2]; lưu giá trị vào R2
					ADD R2, R2, #4; R2 được tăng thêm 4 để trỏ tới ô nhớ tiếp theo
					ADD R5, R5, #1; chiều dài của mảng âm được tăng thêm 1
					MOV PC, LR; trở lại hàm

;Sắp xếp các số dương tăng dần
SAPXEPDUONG			MOV R0, #0; tạo biến chạy i = 0
					MOV R1, #0; tạo biến chạy j=i+1
					B SAPXEPDUONG
					LDR R2, MANGDUONG; load địa chỉ đầu tiên của mảng dương
					LDR R3, MANGDUONG,#4; load địa chỉ tiếp theo của mảng dương
LOOP1 				CMP R0, R4; so sánh i với chiều dài của mảng dương
					BEQ LUU1; thoát khỏi vòng lặp để lưu kết quả
LOOP2				ADD R1, R0, #1; j = i + 1
					LDR R6, [R2]; R6 = table[R2]      
					LDR R7, [R3]; R7 = table[R3]=table[R2+4];
					CMP R6,	R7; so sánh R6 với R7
					BGT DOI1; nếu lớn hơn thì đổi chỗ
					CMP R1, R4; so sánh j với chiều dài của mảng dương
					BNE LOOP2
					ADD R2, R2, #4; tăng giá trị của R2 thêm 4 để trỏ tới ô nhớ kế tiếp
					ADD R0, R0, #1; tăng giá trị của i thêm 1
					B LOOP1
DOI1				STR R6, [R3]; R6 = table[R3]
					STR R7, [R2]; R7 = table[R2]
					MOV PC, LR; trở lại hàm
LUU1             	LDR R8, MANGDUONG; load mảng dương vào R8
					ADD R8, R0, #8; tăng biến chạy R0(i) thêm 8 rồi lưu vào R8 ta được số nhỏ thứ 2 của mảng dương
					STR R8, NHO2; lưu số nhỏ thứ 2 vào địa chỉ 500H
					B SAPXEPAM;

;Sắp xếp các số âm giảm dần
SAPXEPAM			MOV R0, #0; tạo biến chạy i = 0
					MOV R1, #0; tạo biến chạy j=i+1
					B SAPXEPAM
					LDR R2, MANGAM ; load địa chỉ đầu tiên của mảng âm
					LDR R3, MANGAM, #4 ; load địa chỉ tiếp theo của mảng âm
LOOP3 				CMP R0, R5; so sánh i với chiều dài của mảng âm
					BEQ LUU2; thoát khỏi vòng lặp để lưu kết quả
LOOP4				ADD R1, R0, #1; j = i + 1
					LDR R6, [R2]; R6 = table[R2]      
					LDR R7, [R3]; R7 = table[R3]=table[R2+4]
					CMP R6,	R7; so sánh R6 với R7
					BLT DOI2; nếu nhỏ hơn thì đổi chỗ
					CMP R1, R5; so sánh j với chiều dài của mảng âm
					BNE LOOP4
					ADD R2, R2, #4; tăng giá trị của R2 thêm 4 để trỏ tới ô nhớ kế tiếp
					ADD R0, R0, #1; tăng giá trị của i thêm 1
					B LOOP3
DOI2				STR R6, [R3]; R6 = table[R3]
					STR R7, [R2]; R7 = table[R2]
					MOV PC, LR; trở lại hàm

LUU2             	LDR R9, MANGAM; load mảng âm vào R9
					ADD R9, R0, #8; tăng biến chạy R0(i) thêm 8 rồi lưu vào R9 ta được số lớn thứ 2 của mảng âm
					STR R9, LON2; lưu số lớn thứ 2 vào địa chỉ 504H
END	
