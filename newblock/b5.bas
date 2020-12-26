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

const MAPWIDTH=32
const MAPHEIGHT=15
const TILEHEIGHT=20
const TILEWIDTH=32
const PLAYERWIDTH=32
const PLAYERHEIGHT=32

dim integer playermapx=0
dim integer playermapy=0
dim integer playerindex=0

dim integer row = 0
dim float other
dim float block
dim integer tmpplayerx
dim integer tmpplayery
dim integer quit=0
dim integer colorx=0
dim integer colory=0
dim integer startx=0  ' 32 x 1 two blocks over
dim integer starty=0 ' Start one block down
'dim integer startx=32*2  ' 32 x 1 two blocks over
'dim integer starty=32*2 ' Start one block down

dim integer newx = MM.HRES/2
dim integer newy = MM.VRES/2

'player struct
'player info 
'default player stand facing right anim is = 1
'default player stand facing left anim is = 13
'default player jump right anim is = 6
'default player jump left anim = 18 

'DIM integer player.x=32*8+32
'DIM integer player.y=32*10+32
DIM integer player.x=32
DIM integer player.y=32

DIM integer player.velx = 0
DIM integer player.vely = 0
DIM integer player.faceright=1
dim integer player.faceleft=0
dim integer player.shooting=0
dim integer player.crouching=0
dim integer player.lockjump=0
dim integer player.jumping=6
dim integer player.moving=0
dim integer player.animnumber=1    ' starting sprite standing facing right

dim integer player.collisiondetact=0
dim integer player.animdelay
dim integer player.animcounters=0
dim integer player.climbing=0
dim integer player.cancelclimb=0
dim integer player.playermapindex=0

dim integer player.leftanims(1)=(3,4)
dim integer player.leftanimvalue=0
dim integer player.rightanims(1)=(1,2)
dim integer player.rightanimvalue=0
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
dim integer bpixel=0
dim integer lpixel=0
dim integer rpixel=0

dim integer playerread.x=0
dim integer platerread.y=0 
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
data 35,35,35,35,35,35,35,35,35,35,17,35,35,35,35,35,35,35,35,35
data 35,35,35,35,35,35,35,35,35,17,17,17,35,35,35,35,35,35,35,35
data 13,36,15,13,16,15,13,13,17,03,15,13,17,13,15,17,13,14,13,17

' read the map in to the array

for j = 1 to 15
  for i = 1 to 20
    read MAPData(j,i)
 next i
next j      ' Now the Map Data is read in to he array


xx=0
tt=0
page write 3
cls
for x = 0 to 15     ' 15 blocks high
   for t = 0 to 20    '   20 blocks accross 
    other = MapData(x,t)    ' other = array  element    
    other = other /10       ' you devide by 10 to get a decimal
    y=int(other)    ' this will give you row   y = other / 10 
    z=other-y       ' this will give you remainder only   /this sub from the whole number
    z=z*10          ' make remainder a whole number      / this multiples the decimal to make it whole
    blit 32*z,y*32,32*tt+startx,32*xx+starty,32,32,1
'    blit z*32,y*32,32*tt+startx,32*xx+starty,32,32,1
 
    tt=tt+1
    next t
    tt=0
    xx=xx+1
next x

readrick
page write 2
cls
'page write 1 
'cls
page copy 3 to 1



'page write 1
player.velx=0
player.vely=gravity

'*************************** MAIN   ********************************

do
'


if quit = 1 then exit do

page write 0 

'   playermapx = player.x /32 
'   playermapy = player.y /32
'   playermapx = 640 / player.y
'   playermapy = 480 / player.x
playermapx = ((player.x + PLAYERWIDTH)/2)/TILEWIDTH   
playermapy = ((player.y+TILEHEIGHT)/32)

   playerindex = MAPData(playermapy,playermapx)
'   sprite show 2,playermapx*32,playermapy*32,1 
if playerindex <> 35 then
    player.vely =0
end if  

newcheck
newcollision
moveplayer
checkjump
print @(0,400),playermapy,playermapx,playerindex

box playermapx*32,playermapy*32,32,32,,rgb(red)
pause 20
page copy 1 to 0,b

loop

'*************************** END MAIN **********************************


sub readrick

page write 2  ' load the rick sprite sheet on page 2
cls rgb(0,0,0)
tmpxx=10
load bmp "defaultnew.bmp"

sp=1
x1=0
y1=0
'y1=0
    for ii = 1 to 4
      '   for jj = 1 to 8
          sprite read sp,x1,y1,32,32,2 
'          sprite show sp,tmpxx,100,1
          sp = sp + 1
          x1 = x1 + 32
          'tmpxx=tmpxx+32
       '  next jj
     'x1 = 32 * 2
     'y1 = y1 + 32
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
'********************** LEFT and RIGHT ***************************

if keya$ = " 131" then   ' moving right
  player.velx = velmoving
  player.animnumber = player.rightanims(player.rightanimvalue)     ' starting anim
  player.faceright =1
  player.faceleft =0
  player.moving =1
  player.rightanimvalue = player.rightanimvalue +1
    if player.rightanimvalue =2 then player.rightanimvalue =1
end if

if keya$ = " 130" then      ' moving left
  player.velx = - velmoving       ' moving left
  player.animnumber = player.leftanims(player.leftanimvalue)
  player.moving   = 1
  player.faceright=0
  player.faceleft = 1
  player.leftanimvalue = player.leftanimvalue +1
    if player.leftanimvalue =2 then player.leftanimvalue =1



end if
'*****************************  JUMP  ************************************

    if keyb$ = "00000010" and player.lockjump=0 then 'play.animnumber = 11:player.shooting =1 


'  if keya$ = "  32" and player.lockjump = 0 then  ' if the player isn't jumping already
'      print @(1,1),"SPACE BAR"
      player.jumptime = 6
      player.jumpcounter = 0        ' reset the jump counter
      player.vely = -veljump
      player.y = player.y + player.vely     ' JUMP
      player.lockjump = 1   ' true          ' player is not allow to jump anymore
      player.jumping =1     ' true
  end if



end sub

'********************************* CHECK JUMP   ****************************
sub checkjump

if player.jumping =1 then

  player.jumpcounter = player.jumpcounter + 1

  if player.jumpcounter = player.jumptime then
    player.jumptime =0
    player.jumpcounter=0
    player.jumping=0
    player.vely = gravity
  end if
'    player.vely = gravity

end if

end sub 


sub walksound

play wav "sounds/walk.wav"

end sub
 
sub playerjump

end sub

'********************** MOVE PLAYER  ************************
sub moveplayer

         player.x = player.x + player.velx
         player.y = player.y+ player.vely
  sprite show player.animnumber,player.x,player.y,1
end sub
' ******************************** check collision ************************

sub newcollision

'playermapx = ((player.x + 16 /2)/32)-3
'playermapy = ((player.y + 32)/32)-2
'playerindex = MAPData(playermapx,playermapy)
'const velmoving = 4
'const veljump = 13
'const gravity = 13
'const MAPWIDTH=20
'const MAPHEIGHT=15
'const TILEHEIGHT=32
'const TILEWIDTH=32
'const PLAYERWIDTH=32
'const PLAYERHEIGHT=32
' if (0 != player->velx && !player->jumping && !player->vely)
'            {
'                if (player->faceright)
'                {
'                    // test for tiles right of the player
'                    int playermapx = (player->x + player->velx + player->w) / TILEWIDTH; // The Players X Map Position
'                    int playermapy = (player->y + player->h / 2) / TILEHEIGHT; // The Players Y Map Position
'                    int playermapindex = map[playermapx + (playermapy * MAPWIDTH)];
'                        if (0 == playermapindex)
'                        {
'                            player->x = (playermapx-1) * TILEWIDTH;
'                            player->velx = 0;
'                            player->animnumber =0;'''
'
'                        }
'                }
'                else
'                {
'                    // test for tiles left of the player
'                    int playermapx = (player->x + player->velx) / TILEWIDTH; // The Players X Map Position
'                    int playermapy = (player->y + player->h / 2) / TILEHEIGHT; // The Players Y Map Position
'                    int playermapindex = map[playermapx + (playermapy * MAPWIDTH)];
'                        if (0 == playermapindex)
'                        {
'                            player->x = (playermapx+1) * TILEWIDTH;
'                            player->velx = 0;
'                            player->animnumber =3;''
'
'                        }
'                }
'
'   // test for falling off a ledge
'
'   int playermapx = (player->x + player->w / 2) / TILEWIDTH; // The Players X Map Position
'     int playermapy = (player->y + player->h) / TILEHEIGHT; // The Players Y Map Position
'   int playermapindex = map[playermapx + (playermapy * MAPWIDTH)];
'   if (0x23 == playermapindex)
'   {
'     player->jumptime = 0;
'     player->jumpcounter = 0;
'     player->jumping = false;
'     player->vely = GRAVITY;
'
''if player.velx <> 0 and player.jumping =1 and player.vely > 1 then 

' if (player->faceright)
'{
' // test for tiles right of the player
'int playermapx = (player->x + player->velx + player->w) / TILEWIDTH; // The Players X Map Position
'int playermapy = (player->y + player->h / 2) / TILEHEIGHT; // The Players Y Map Position
'int playermapindex = map[playermapx + (playermapy * MAPWIDTH)];
'if (0 == playermapindex)
' {
' player->x = (playermapx-1) * TILEWIDTH;
' player->velx = 0;
' player->animnumber =0;'''
' }

if player.faceright=1 then
 ' test the tiles on the right side of the player
   playermapx = ((player.x + player.velx + PLAYERWIDTH)/TILEWIDTH)
   playermapy = (player.y + PLAYERHEIGHT/2)/TILEHEIGHT
'    playerindex = MAPold(playermapx +(playermapy*MAPWIDTH))
       if playerindex =35 then
            player.x=(playermapx+1) *TILEWIDTH
            player.velx=0
        end if
   end if
'// test for tiles left of the player
'int playermapx = (player->x + player->velx) / TILEWIDTH; // The Players X Map Position
'int playermapy = (player->y + player->h / 2) / TILEHEIGHT; // The Players Y Map Position
'int playermapindex = map[playermapx + (playermapy * MAPWIDTH)];
'if (0 == playermapindex)
'{
'player->x = (playermapx+1) * TILEWIDTH;
'player->velx = 0;
'player->animnumber =3;''

  if player.faceleft=1 then
    ' test the tiles on the left side of the player
    playermapx = (player.x + player.velx) /TILEWIDTH
    playermapy = (player.y + PLAYERHEIGHT/2)/TILEHEIGHT
    playerindex = MAPold(playermapx+ (playermapy * MAPWIDTH))
        if playerindex <>35 then
            player.x = (playermax-1) *TILEWIDTH
            player.velx=0
        end if
  end if
 

  'falling
'  if gravity = player.vely then ' we are falling
    
    playermapx = (player.x + 32 / 2) /TILEWIDTH
    playermapy = (player.y + PLAYERHEIGHT) / TILEHEIGHT
'    playerindex = MAPold(playermapx + (playermapy * MAPWIDTH))


    if playerindex = 35 then
    print @(0,410),"standing"
    player.vely=0
'    sprite show player.animnumber,player.x,player.y+6,1
    player.y = (player.y /TILEHEIGHT) * TILEHEIGHT
    player.lockjump=0
    player.jumpcounter=0
    player.jumping=0
    player.jumptime=0
    end if
'end if    

'         player.x = player.x + player.velx
'         player.y = player.y+ player.vely


    
end sub

