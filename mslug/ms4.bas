' load metal slug gfx
' and sprites
'mode 1 
readx=106
width=32
height=42
page write 1
cls
load gif "msbg2.gif"

page write 2
cnt = 0
for i = 1 to 23
'print ""+str$(i)+".png"
load png "PlayerWalking\"+str$(cnt)+".png"
sprite read i,0,0,32,39,2
cnt = cnt + 1
next i
cls

page write 1
x=190
y=150

do
for i=1 to 23
  sprite show i,x,y,1
  x = x +4
   pause 40
   page copy 1 to 0,b
   next i
loop

