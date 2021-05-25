' Background load 
' Made by Franco Gaetan
' Date: 11/27/2020
' Load sewers bmp and grab 32 x 32 shapes

 

#import "../stdsettings.inc"
DIM integer blitobjx(50)
DIM integer blitobjy(50)
const displayscreen =1 
page write 1
cls 
load png "sodan1.png"
x=0
y=0
for j = 1 to 4
sprite read j,x,0,64,128,1
x = x + 69
'sprite show j,100,100,1
'  box 0,0,64,128,1  
next j
page write 2
cls
xx=1
x1=1
do
sprite show xx,100+x1,100,2
xx=xx+1
x1 = x1 + 5
if xx = 5 then xx =1
pause 90
page copy 2 to 0,b
cls
loop

