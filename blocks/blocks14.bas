' fill the screen with boxes every 32 pixels
' Writen by Franco Gaetan
' December 18, 2020
' 
mode 1
page write 1       ' the background will be on page 1
cls rgb(0,0,0)
load bmp "sewers.bmp"
a=0
dim integer row = 0
dim float other
dim float block
dim integer tmpplayerx
dim integer tmpplayery

dim integer colorx=0
dim integer colory=0
dim integer startx=32*2  ' 32 x 1 two blocks over
dim integer starty=32*2 ' Start one block down
dim integer newx = MM.HRES/2
dim integer newy = MM.VRES/2
dim integer shipspeed = 4
DIM integer player.gravity = 5
DIM integer player.velx = 3
DIM integer player.vely = 3
DIM integer player.x=32*8+32
DIM integer player.y=32*8+32
dim integer player.delay=5
dim integer player.anim=2
dim integer player.animspeed=4
dim integer player.locationx=0
dim integer player.locationy=0
dim integer player.flagblock=0
dim integer player.falldistance=0

dim integer player.readxpixel
dim integer player.readypixel
dim integer player.lockjump=0
dim integer playerread.x=30*1
dim integer platerread.y=35+7 
dim as integer playsound=0
DIM integer MAPData(15,20)

data 35,35,35,35,35,35,35,35,00,00,00,00,00,00,00,00,00,00,00,00
data 36,00,00,00,00,00,00,35,00,00,00,00,00,00,00,00,00,00,00,00
data 36,00,00,00,00,00,00,35,00,00,00,00,00,00,00,00,00,00,00,00
data 13,00,00,00,00,35,35,35,00,00,00,00,00,00,00,00,00,00,00,00
data 37,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
data 13,36,15,13,16,15,13,13,17,03,15,13,17,13,15,17,13,14,13,17
' read the map in to the array
for j = 1 to 15
  for i = 1 to 20
    read MAPData(j,i)
 next i
next j      ' Now the Map Data is read in to he array

for x = 1 to 15     ' 15 blocks high
   for t = 1 to 20    '   20 blocks accross 
    other = MapData(x,t)    ' other = array  element    
    other = other /10       ' you devide by 10 to get a decimal
    y=int(other)    ' this will give you row   y = other / 10 
    z=other-y       ' this will give you remainder only   /this sub from the whole number
    z=z*10          ' make remainder a whole number      / this multiples the decimal to make it whole
    blit 32*z,y*32,32*t+startx,32*x+starty,32,32,1
    next t
next x

readrick
page write 1

'*************************** MAIN   ********************************

do

page write 0 
checkinput
moveplayer
player.lockjump = player.lockjump +1
  if player.lockjump > 12 then player.lockjump=1
page copy 1 to 0,b

loop

'*************************** END MAIN **********************************


sub readrick

page write 2  ' load the rick sprite sheet on page 2
cls rgb(0,0,0)

load bmp "ricksheet1.bmp"

sp=1
x1=32*2
y1=35+4
     for ii = 1 to 4
         for jj = 1 to 8
          sprite read sp,x1,y1,32,32,2 
         ' sprite show sp,100,100,1
          sp = sp + 1
          x1 = x1 + 32
         next jj
     x1 = 32 * 2
     y1 = y1 + 32
     next ii
end sub

sub checkinput
keya$=str$(keydown(1),4)
keyb$=bin$(keydown(7),8)


  if keyb$ = "00000010" and player.lockjump=1 then player.lockjump=2:playerjump



if player.delay < 0 then
       if keydown(0) then
                     
            if keya$ = " 130" then player.x = player.x - shipspeed:play wav "sounds/walk.wav":player.anim = player.anim - 1
   
            if keya$ = " 131" then player.x = player.x + shipspeed:play wav "sounds/walk.wav":player.anim = player.anim + 1

            if keya$ = " 128" then player.y = player.y - shipspeed ' up arrow
            if keya$ = " 129" then player.y = player.y + shipspeed ' right arrow  ' down
            if keya$ = " 166" then x = x + shipspeed ' extra
       player.delay=5
       end if


end if
   player.delay = player.delay -1

end sub
 
sub playerjump
    player.y = player.y = player.vely
    play wav "sounds/jump.wav"
    end if
end sub


sub moveplayer
  sprite show player.anim,player.x,player.y,1
  pixel player.x+25,player.y+16
  player.readxpixel = pixel (player.x+26,player.y+16)    ' read the pixel in front of the sprite
  print @(0,0),player.readxpixel
  if player.anim =5 then player.anim =2
end sub


sub checkcollision
  tmpplayerx = player.x / 32
  tmpplayery = player.y / 32 
  tmpplayerx = tmpplayerx - 1   ' one below the player
end sub

sub restorebackground

end sub

