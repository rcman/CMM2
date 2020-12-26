' fill the screen with boxes every 32 pixels
' Writen by Franco Gaetan
' December 18, 2020
' 
mode 1
page write 1       ' the background will be on page 1
cls rgb(0,0,0)
load bmp "sewers.bmp"
a=0
const velmoving = 4
const veljump = 13
const gravity = 13 

dim integer row = 0
dim float other
dim float block
dim integer tmpplayerx
dim integer tmpplayery
dim integer quit=0
dim integer colorx=0
dim integer colory=0
dim integer startx=32*2  ' 32 x 1 two blocks over
dim integer starty=32*2 ' Start one block down
dim integer newx = MM.HRES/2
dim integer newy = MM.VRES/2

'player struct
'player info 
'default player stand facing right anim is = 1
'default player stand facing left anim is = 13
'default player jump right anim is = 6
'default player jump left anim = 18 

DIM integer player.x=32*8+32
DIM integer player.y=32*10+32
DIM integer player.velx = 0
DIM integer player.vely = 0
DIM integer player.faceright=1
dim integer player.faceleft=0
dim integer player.shooting=0
dim integer player.crouching=0
dim integer player.lockjump=0
dim integer player.jumping=0
dim integer player.moving=0
dim integer player.animnumber=1    ' starting sprite standing facing right
dim integer player.collisiondetact=0
dim integer player.animdelay
dim integer player.animcounters
dim integer player.climbing=0
dim integer player.cancelclimb=0
dim integer player.playermapindex=0

dim integer shipspeed = 4
'DIM integer player.gravity = 5
dim integer player.delay=7
dim integer player.anim=1
dim integer player.animspeed=4
dim integer player.locationx=0
dim integer player.locationy=0
dim integer player.flagblock=0
dim integer player.falldistance=0

dim integer player.readxpixel=0
dim integer player.readypixel=0
dim integer rpixel=0

dim integer playerread.x=30*1
dim integer platerread.y=35+7 
dim as integer playsound=0
'
DIM integer MAPData(15,20)

data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
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
if quit = 1 then exit do

page write 0 
'checkinput
newcheck
moveplayer
'showthesprites
print @(0,0),rpixel

page copy 1 to 0,b

loop

'*************************** END MAIN **********************************


sub readrick

page write 2  ' load the rick sprite sheet on page 2
cls rgb(0,0,0)
tmpxx=10
load bmp "ricksheet1.bmp"

sp=1
x1=32*2
y1=35+4
     for ii = 1 to 4
         for jj = 1 to 8
          sprite read sp,x1,y1,32,32,2 
'          sprite show sp,tmpxx,100,1
          sp = sp + 1
          x1 = x1 + 32
          tmpxx=tmpxx+32
         next jj
     x1 = 32 * 2
     y1 = y1 + 32
     next ii
end sub


' Here is the deal
' if standing still you can jump, shoot, crouch
' if you're jumping you can shoot only
' if you're running you cannot shoot, can jump and crouch
' if crouching then you cannot jump, cannot shoot
' if you're not doing anything you're standing
' BOOL values are
' faceright=true   by default
' shooting = false  not shooting by default
' crouching = false not crouching by default
' lockjump   = false not jumping by default
' jumping   = is false byt default you're not jumping
' moving = false by default you're standing still
' climbing = false
' cancelclimbing = false
' set the player.velx =0 because they are not moving on the start
' player.vely = Gravity   Player is falling by default

sub newcheck

    player.crouching = 0 ' false
    player.shooting = 0 'false
    player.velx =0
  if player.faceright = 1 and player.moving <> 1 then player.animnumber = 1
  if player.faceleft = 1 and player.moving <> 0 then player.animnumber = 13

'*****************************movement*****************************
  
keya$=str$(keydown(1),4)
keyb$=bin$(keydown(7),8)


            ' 130 left   131 right   128 up     129  down         
'*************************** MOVEMENT ************************


if keya$ = " 131" then   ' moving right
  player.velx = velmoving
  player.animnumber = 1     ' starting anim
  player.faceright =1
  player.moving =1
end if

if keya$ = " 130" then      ' moving left
  player.velx = - velmoving       ' moving left
  player.animnumber = 13
  player.moving   = 1
  player.faceleft = 1
end if

     ' did the CTRL key get pressed? if I did I'm shooting
    if keyb$ = "00000010" and player.faceright = 1 then play.animnumber = 11:player.shooting =1 

    if keyb$ = "00000010" and player.faceleft = 1 then player.animnumber = 23:player.shooting =1


'**************************crouching*******************************
    
  if keya$ = " 129" and player.faceright =1 then player.animnumber =7:player.crouching =1 
  
  if keya$ = " 129" and player.faceleft =1 then player.animnumber =19:player.crouching =1 
  
 

'*************************jumping   SPACE Bar************************

   
  if keya$ = "  32" and player.lockjump = 0 then  ' if the player isn't jumping already
      print @(1,1),"SPACE BAR"
      player.jumptime = 6
      player.jumpcounter = 0        ' reset the jump counter
      player.vely = -veljump
      player.y = player.y + player.vely     ' JUMP
      player.lockjump = 1   ' true          ' player is not allow to jump anymore
      player.jumping =1     ' true
  end if

      if player.jumping = 1 then
         ' in C code playermapindex = map(playerx + (playery * madwidth)
         ' dim integer player.playermapindex=0
         player.jumptime =0
         player.jumpcounter = 0
         player.jumping = 0
         player.vely = gravity
      ELSE 
          if gravity=player.vely then
            player.vely =0
            player.lockjump=0
            player.jumping=0
          end if
          ' nothing done
      endif


        ' player jumper timing code
           if player.jumpcounter >= player.jumptime then
              player.jumptime =0
              player.jumpcounter =0
              player.jumping = 0
              player.vely = gravity
           end if
          
        player.jumpcounter = player.jumpcounter + 1
           
   if gravity = player.vely then             ' we are falling GRAVITY==PLAYER.VELY
         player.readxpixel = pixel (player.x+16,player.y+32) 
'        player.readpixel = pixel player.x+16,player.y+32 ' below player
        if player.readxpixel <> 0 then
               'if player.faceright = 1 then play.animnumber = 6
                player.jumptime=0
                player.jumpcounter=0
                player.jumping = 0
                player.vely = gravity
'        print "Stand on the ground"
        else
         player.x = player.x + player.velx
         player.y = player.y + player.vely
       end if
    end if
' **************** Collision *************************************


'        player.readypixel = pixel (player.x+16,player.y+32) 
'         rpixel = pixel (player.x+16,player.y+31)    ' read below
'         pixel player.x+16,player.y+31    ' read below
         


'        player.readxpixel = pixel (player.x+16,Player.y+32) ' below player
'        pause 500
        'player.readpixel = pixel player.x+16,player.y+32 ' below player

'        if rpixel <> 0 then
 '      ' print "WOWOWOW!"
  '      player.jumptime=0
  '      player.jumpcounter=0
  '      player.jumping =0
  '      player.vely = gravity
        
'        end if
  


end sub


sub checkinput
keya$=str$(keydown(1),4)
keyb$=bin$(keydown(7),8)


  if keyb$ = "00000010" then playerjump 



if player.delay < 0 then
       if keydown(0) then
            ' 130 left   131 right   128 up     129  down         
if keya$ = " 113" then quit=1
if keya$ = " 130" then player.x = player.x - shipspeed:player.anim=player.anim + 1:play wav "sounds/walk.wav"
if keya$ = " 131" then player.x = player.x + shipspeed:player.anim=player.anim + 1:play wav "sounds/walk.wav"
if keya$ = " 128" then player.y = player.y - shipspeed ' up arrow
if keya$ = " 129" then player.y = player.y + shipspeed ' right arrow  ' down
            if keya$ = " 166" then x = x + shipspeed ' extra
       player.delay=7
       end if


end if
   player.delay = player.delay -1

end sub

sub walksound

play wav "sounds/walk.wav"

end sub


 
sub playerjump
    ' C Code
    ' if keystat and Not player.jumping ' if the player isn't jumping already
    ' player.jumptime =6
    ' player.jumpcounter = 0
    ' player.vely = -VELJUMP
    ' player.y = player.y + player.vely
    ' player.lockjump = true or 1
    ' player.jumping = true or 1
    ' and then draw player
    ' player.x, player.y,
    ' at the end player.x = player.x + player.velx
    '            player.y = player.y + player.vely
          


'  player.lockjump=1
  player.jumping = 1  
  
  player.y = player.y - 8:player.vely =3
'  player.jumping = player.jumping + 1
  'if player.jumping =15 then player.jumping=0
 

end sub


sub moveplayer
'dim integer player.animnumber=1 
'  sprite show player.anim,player.x,player.y,1
  sprite show player.animnumber,player.x,player.y,1

'  player.y = player.y + player.vely

'  pixel player.x+25,player.y+16 ' in front of player
'  pixel player.x+16,Player.y+32 ' below player
  'player.readxpixel = pixel (player.x+26,player.y+16)    ' read the pixel in front of the sprite
'   player.readxpixel = pixel (player.x+16,player.y+31)    ' read below
'   print @(0,0),player.readxpixel
'   if player.readxpixel <> 0 then player.vely = 0:player.lockjumping = 0:player.jumping=0
'  
' pause 200
'   player.y = player.y + 1
'  if player.anim = 6 then player.anim =1
'  if player.anim < 2 then player.anim = 5

'  if player.jumping = 1 then player.y = player.y - 8:player.vely =3



end sub


sub checkcollision
  tmpplayerx = player.x / 32
  tmpplayery = player.y / 32 
  tmpplayerx = tmpplayerx - 1   ' one below the player
end sub

sub restorebackground

end sub



sub showthesprites
c1=1
c2=10
c3=1
for nn = 1 to 4
  for mm = 1 to  8
     sprite show c3,32*c1,c2,1
    print@(c1*32-8,c2+40),c3
    c3 = c3 + 1
    c1 = c1 + 1
   next mm
 c2 = c2 + 94
 c1 = 1 
next nn

end sub


