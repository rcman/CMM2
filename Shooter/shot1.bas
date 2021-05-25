                                                                                                                                                                                                      ' Background load 
' Made by Franco Gaetan
' Date: 11/27/2020
' Load sewers bmp and grab 32 x 32 shapes
' blocks in bmp are 10 across
' there are 6 blocks going down
' calculate the block I want by x * 32 and y + 32 
' blocks I want are line 2 
' 4 in from the left
' 5 * 32
' this needs a look up table for the objects below. 
' I brought in the array from C below to have the same shapes being shown

#import "../stdsettings.inc"
' NOTE What ever page write I do last will be my display page
' by default without specifying page write the default is 0
mode 1,16

option default integer
const MAX_SHOTS=20
const MAX_ENEMIES=5
shotnumber=2
shotxoffset=30
shipx=0
shipy=0
oldx=0
oldy=0
shdelay=0 ' shot delay
shipspeed=8
delcount=0
oldcount=0
DIM integer x=mm.hres/2, y=mm.vres/2

'----------------------------------------

page write 1
load bmp "1945_newblack.bmp"
'----------------------------------------
'global
dim integer maxenemies=8
dim integer maxenemiesarray=maxenemies*4
'################# check collision
dim integer coll1.x
dim integer coll1.y
const coll1half.w =16
const coll1half.h=16 
dim integer coll1.centerx
dim integet coll1.centery

dim integer coll1.alive(maxenemies)
dim integer coll1.tmpx(maxenemies)
dim integer coll1.tmpy(maxenemies)
dim integer coll1.explosions=6

'
dim integer lefta1
dim integer lefta2
dim integer lefta3
dim integer lefta4
      
dim integer topa1
dim integer topa2
dim integer topa3
dim integer topa4

dim integer righta1
dim integer righta2
dim integer righta3
dim integer righta4

dim integer bottoma1
dim integer bottoma2
dim integer bottoma3
dim integer bottoma4

dim integer bxa1 
dim integer bya1
dim integer bbxa1
dim integer bbya1
'SOUND SETTINGS
sfx_snd=2   ' sound effects




'################# Enemy1 planes
dim integer enemy1.id(maxenemies)
dim integer enemy1.x(maxenemies)
dim integer enemy1.y(maxenemies)
dim integer enemy1.exp_framecount=103
dim integer enemy1.framespace=33
dim integer enemy1.explosionx(maxenemies)
dim integer enemy1.explosiony(maxenemies)
dim integer enemy1.explode_delay=1
dim integer enemy1.alive(maxenemies)
dim integer enemy1.speed(maxenemies)
dim integer enemy1.tmpx
dim integer enemy1.tmpy
dim integer enemy1.delay=8
dim integer enemy1.wait=0
dim integer enemy1stat=0
const enemy1.maximum=10

'################# Enemy2 planes
dim integer enemy2.id(maxenemies)
dim integer enemy2.x(maxenemies)
dim integer enemy2.y(maxenemies)

dim integer enemy2.exp_framecount=103
dim integer enemy2.framespace=33
dim integer enemy2.explode_delay=1

dim integer enemy2.explosionx(maxenemies)
dim integer enemy2.explosiony(maxenemies)
dim integer enemy2.alive(maxenemies)
dim integer enemy2.speed(maxenemies)
dim integer enemy2.tmpx
dim integer enemy2.tmpy
dim integer enemy2.delay=8
dim integer enemy2.wait=0
dim integer enemy2stat=0
const enemy2.maximum=3

'################# Enemy3 planes
dim integer enemy3.id(maxenemies)
dim integer enemy3.x(maxenemies)
dim integer enemy3.y(maxenemies)

dim integer enemy3.exp_framecount=103
dim integer enemy3.framespace=33
dim integer enemy3.explode_delay=1


dim integer enemy3.explosionx(maxenemies)
dim integer enemy3.explosiony(maxenemies)
dim integer enemy3.alive(maxenemies)
dim integer enemy3.speed(maxenemies)
dim integer enemy3.tmpx
dim integer enemy3.tmpy
dim integer enemy3.delay=8
dim integer enemy3.wait=0
dim integer enemy3stat=0
const enemy3.maximum=6

'################# Enemy4 planes
dim integer enemy4.id(maxenemies)
dim integer enemy4.x(maxenemies)
dim integer enemy4.y(maxenemies)

dim integer enemy4.exp_framecount=103
dim integer enemy4.framespace=33
dim integer enemy4.explode_delay=1



dim integer enemy4.explosionx(maxenemies)
dim integer enemy4.explosiony(maxenemies)
dim integer enemy4.alive(maxenemies)
dim integer enemy4.speed(maxenemies)
dim integer enemy4.tmpx
dim integer enemy4.tmpy
dim integer enemy4.delay=8
dim integer enemy4.wait=0
dim integer enemy4stat=0
const enemy4.maximum=8


'################# Player Bullets
dim integer bullet.id(60)
dim integer bullet.x(60)
dim integer bullet.y(60)
dim integer bullet.alive(60)
dim integer bullet.speed(60)
dim integer bullet.tmpx
dim integer bullet.tmpy
dim integer bullet.delay=8
dim integer bullet.wait=0
dim integer checkbullet=0
const bullet.maximum=10
dim integer bullet_in_use=0
'blit 0,0,41,169,26,26,1

'for e = 1 to 8
'  sprite read 30+e,s,g,32,32,1
'  s = s + 33
'print e
'next e
' sprite read #, x,y,w,h,page 
'for i = 2 to 30
'    sprite read i, 41,169,26,25,1
'next i
sprite read 1, 703,118,84,62,1    ' read plane image
'sprite show 1, 10, 10,2
page write 2
cls

for i = 1 to 60
  bullet.id(i)=0
  bullet.alive(i)=0
  bullet.speed(i)=15
next i

for i = 1 to maxenemies
  enemy1.id(i)=0
  enemy2.id(i)=0
  enemy3.id(i)=0
  enemy4.id(i)=0

  enemy1.alive(i)=1
  enemy2.alive(i)=1
  enemy3.alive(i)=1
  enemy4.alive(i)=1

  enemy1.speed(i)=8
  enemy2.speed(i)=4
  enemy3.speed(i)=3
  enemy4.speed(i)=2


  enemy1.x(i) = (rnd()*799)
  enemy2.x(i) = (rnd()*799)
  enemy3.x(i) = (rnd()*799)
  enemy4.x(i) = (rnd()*799)

  enemy1.y(i) = (rnd()*700)
  enemy2.y(i) = (rnd()*700)
  enemy3.y(i) = (rnd()*700)
  enemy4.y(i) = (rnd()*700)

next i




' initbullets
' draw bullets
' fire bullets
' update bullets
' blit x1,y1,x2,y2,w,h,page

sub DrawBullets
  for i = 1 to MAX_SHOTS
    if bullet.alive(i)=1 then
    '      sprite show 31,x,y,2
'    blit 0,0,bullet.x(i),bullet.y(i),26,26,2
    end if
  next i


end sub

Sub FireBullets         ' this saves the bullets x and y when shot

  bullet.wait = bullet.wait + 1
      if bullet.wait > 4 then 
               play stop
               play modfile "laser2.mod"
            ' the + 30 and -15 are the offset of where the bullet starts from
'            play tone 122,122,1
            checkbullet=checkbullet+1
            for i = 1 to 60
              if bullet.alive(i)=0 then 
                 bullet.x(i)=x+30
                 bullet.y(i)=y-15
                 bullet.alive(i)=1
                 bullet.wait=0
                
              return
              end if
            next i
      end if

end sub

Sub UpdateBullets
  for i = 1 to MAX_SHOTS
    if bullet.alive(i) =1 then
      bullet.tmpx = bullet.x(i)
      bullet.tmpy = bullet.y(i)
      bullet.tmpy = bullet.tmpy - bullet.speed(i)
      bullet.y(i) = bullet.tmpy
      blit 41,169,bullet.x(i),bullet.y(i),26,25,1
      if bullet.y(i) < 1 then bullet.alive(i)=0
    end if
  next i      
end sub

DIM integer enemymotion(30,30)
DIM integer shots(30)
DIM integer old_ship_coordinates(60,60)
DIM integer old_ship_x(60)
DIM integer old_ship_y(60)
DIM integer enemy(1,1)
DIM integer enemyx(1)=(80,80)
dim integer offset=0
dim float spx=10
dim float spy=0
dim float swav


DIM integer enemyy(1)=(100,100)
dim integer eseq(7) = (1,8,7,6,5,4,3,2)
DIM integer enemyanim(1)=(31,31)
'sprite read #N,x,y,w,h,page number


s=4
g=4


cls

'Main
'things to add
'timer for shots
'save ship x and y
newx=10
newy=10
enemysprite = 31

'for ax = 1 to 8

'  sprite show enemysprite,newx,newy,2
'  enemysprite = enemysprite + 1
'  newx = newx + 32
'next ax

'checkinput
'page write 1
'sprite show 1,x,y,2
'###################################################################################
'##########                     MAIN          ######################################
'###################################################################################
strx=4

do while keydown(1) <> 113
   page write 2
   cls
   sprite show 1,x,y,2
' blit x1,y1,x2,y2,w,h,page
 ' box 1,1,37,37,,rgb(red)  
' blit 4,4,00,0,32,32,1  ' orange plane straight down
' blit 4,37,00,32,32,32,1  ' blue plane. Next plane down
' blit 4,70,00,64,32,32,1   ' green plane
' blit 4,103,00,96,32,32,1   ' grey plane
' blit 4,136,00,128,32,32,1
' blit 4,169,00,160,32,32,1 
' blocks over 
' blit 103,169,32,220,32,32,1    ' explosion 1
' blit 136,169,64,220,32,32,1    ' explosion 1
' blit 169,169,96,220,32,32,1    ' explosion 1
' blit 202,169,128,220,32,32,1    ' explosion 1
' blit 235,169,160,220,32,32,1    ' explosion 1
' blit 268,169,192,220,32,32,1    ' explosion 1

'blit 2,6,00,0,36,33,1  ' orange plane straight down
' blit 2,39,00,40,36,33,1  ' blue plane. Next plane down
' blit 2,72,00,90,36,33,1   ' green plane
' blit 2,105,00,130,36,33,1   ' grey plane
 
     checkinput
   UpdateBullets
    moveenemy
  checkbulletcol
  showexplosion
  bullinuse
  print @(0,0),bullet_in_use
   page copy 2 to 0
   'pause 4
loop

'###################################################################################
'##########                 END MAIN          ######################################
'###################################################################################





sub checkinput
  keya$=str$(keydown(1),4)
   keyb$=bin$(keydown(7),8)    
  ' print t$+keya$+z$
   if keydown(0) then
     ' if keydown(1) = 113 then exit do    ' pressed Q to quit
      if keya$ = " 130" then x = x - shipspeed  'left arrow keys
      if keya$ = " 131" then x = x + shipspeed  'right arrow keys
      if keya$ = " 128" then y = y - shipspeed  'up arrow keys
      if keya$ = " 129" then y = y + shipspeed  'down arrow keys
      if keyb$ = "00000010" then FireBullets
'     print @(0,0)
'     print shots(0)          
   '  print keyb$
'     
          

'      sprite move 1,x,y,1
   sprite show 1, x, y,2      ' move our ship
  
     'check boundaries
     if x < 1 then x =1
     if x > 799 then x = 799
     if y < 1 then y =1
     if y > 499 then y =499  
  endif
 
end sub

sub shoot
'DIM integer enemymotion(30,30)
'DIM integer shots(30)
'DIM integer old_ship_coordinates(60,60)
'DIM integer old_ship_x(60)
'DIM integet old_ship_y(60)
'oldcount=0


print @(0,400),spacebarsmash
      
    'play wav "explode.wav"
        spacebarsmash = spacebarsmash + 1   ' this is a delay in the spacebar
    if spacebarsmash > 5 then          ' of the counter equals 20 then let them shoot
    
    'save ship x and y
    'shotalive=1
    'oldcount=0
    'DIM integer shots(30)
    shots(oldcount) = shotalive          ' set the flag for the sprite # to on or off(shotalive=1)
    old_ship_x(oldcount) = x+shotxoffset   ' old ship x and y saved in an array 
    old_ship_y(oldcount) = y - 50           ' this is to mark if the shot is alive in the array
    oldcount = oldcount + 1
    spacebarsmash=0                     ' lets count up the spacebar being held
            if oldcount = 30 then
                 oldcount =0
            end if
    end if
end sub

sub mvshots
 
 for i = 0 to MAX_SHOTS                  ' start and the array 0, is it alive?
     if shots(i) = 1 then                     'then shot is alive
        shotx=old_ship_x(i)
        shoty=old_ship_y(i)
        sprite show i+2, shotx, shoty,2
        
        if shoty <10 then                  ' is the Y < 4? if it is this sprite is dead    
           sprite hide i+2                 ' right now it's 2 because there are not multiple
           shots(i) = 0
        else
        shoty = shoty - 8                    ' this adjusts shot speed
        old_ship_y(i) = shoty
        'print @(0,0):print shotx,shoty
        'sprite show shotnumber, shotx, shoty,2  
        'shotnumber = shotnumber + 1
        end if
    
     end if
next i 
end sub

sub mvenemy
    offset = ((spy*320)+spx)
  

    sprite show 31,oldx+offset,swav,2
    offset = offset + 320

end sub



sub moveenemy
' blit 4,4,00,0,32,32,1  ' orange plane straight down
' blit 4,37,00,32,32,32,1  ' blue plane. Next plane down
' blit 4,70,00,64,32,32,1   ' green plane'
' blit 4,103,00,96,32,32,1   ' grey plane
' blit 4,136,00,128,32,32,1
' blit 4,169,00,160,32,32,1 
' blocks over 
' blit 103,169,32,220,32,32,1    ' explosion 1
' blit 136,169,64,220,32,32,1    ' explosion 1
' blit 169,169,96,220,32,32,1    ' explosion 1
' blit 202,169,128,220,32,32,1    ' explosion 1
' blit 235,169,160,220,32,32,1    ' explosion 1
' blit 268,169,192,220,32,32,1    ' explosion 1

  for i = 1 to maxenemies

    if enemy1.alive(i) =1 then
      enemy1.tmpx = enemy1.x(i)
      enemy1.tmpy = enemy1.y(i)
      enemy1.tmpy = enemy1.tmpy + enemy1.speed(i)
      enemy1.y(i) = enemy1.tmpy
      enemy1stat = rnd*4
      
      if enemy1.y(i) > 200 then enemy1.x(i)=enemy1.x(i)-3 
      if enemy1.y(i) < 200 then enemy1.x(i)=enemy1.x(i)+3 


'      enemy2.tmpx = enemy2.x(i)
'      enemy2.tmpy = enemy2.y(i)
'      enemy2.tmpy = enemy2.tmpy + enemy2.speed(i)
'      enemy2.y(i) = enemy2.tmpy
      
'     enemy2stat = rnd*4'

'      enemy3.tmpx = enemy3.x(i)
'      enemy3.tmpy = enemy3.y(i)
'      enemy3.tmpy = enemy3.tmpy + enemy3.speed(i)
'      enemy3.y(i) = enemy3.tmpy

'      enemy3stat = rnd*4
'
 '     enemy4.tmpx = enemy4.x(i)
'      enemy4.tmpy = enemy4.y(i)
'      enemy4.tmpy = enemy4.tmpy + enemy4.speed(i)

'      enemy4.y(i) = enemy4.tmpy

'      enemy4stat = rnd*4
  

      blit 4,4,enemy1.x(i),enemy1.y(i),32,32,1     'orange plane
'      blit 4,37,enemy2.x(i),enemy2.y(i),32,32,1    ' blue plane
'      blit 4,70,enemy3.x(i),enemy3.y(i),32,32,1    ' green plane
'      blit 4,103,enemy4.x(i),enemy4.y(i),32,32,1   ' grey plane

'      blit 4,37,00,10,26,25,1
'      box 10,10,26,27,,rgb(red)
      if enemy1.y(i) > 559 then enemy1.y(i) = 1:bullet_in_use = bullet_in_use -1
      if enemy2.y(i) > 559 then enemy2.y(i) = 1:bullet_in_use = bullet_in_use -1
      if enemy3.y(i) > 559 then enemy3.y(i) = 1:bullet_in_use = bullet_in_use -1
      if enemy4.y(i) > 559 then enemy4.y(i) = 1:bullet_in_use = bullet_in_use -1


    end if
  next i      
end sub

sub checkbulletcol

  for i = 1 to maxenemies
    
      lefta1 = enemy1.x(i)
      lefta2 = enemy2.x(i)
      lefta3 = enemy3.x(i)
      lefta4 = enemy4.x(i)
      
      topa1 = enemy1.y(i)
      topa2 = enemy2.y(i)
      topa3 = enemy3.y(i)
      topa4 = enemy4.y(i)

      righta1 = enemy1.x(i)+32
      righta2 = enemy2.x(i)+32
      righta3 = enemy3.x(i)+32
      righta4 = enemy4.x(i)+32

      bottoma1 = enemy1.y(i)+32
      bottoma2 = enemy2.y(i)+32
      bottoma3 = enemy3.y(i)+32
      bottoma4 = enemy4.y(i)+32
        
      lefta = enemy1.x(i)
      topa = enemy1.y(i)
      righta = enemy1.x(i)+32
      bottoma = enemy1.y(i)+32


      for j = 1 to MAX_SHOTS
         if bullet.alive(j)=1 then 
            bxa1=bullet.x(j)
            bya1=bullet.y(j)
            bbxa1=bullet.x(j)+26
            bbya1=bullet.y(j)+26

            bx=bullet.x(j)
            by=bullet.y(j)
            bx1=bullet.x(j)+26
            by1=bullet.y(j)+26



         end if      

        if lefta < bx1 and righta > bx and topa < by1 and bottoma >by then
          'bullet.alive(j)=0
              ' play stop
              ' play modfile "explnew3.mod"
              ' play stop

          'play stop
          'play modsample 2,2,64,16000
          'play wav "explode.wav"
          play_sfx("explodea",0)
          enemy1.explosionx(i)=enemy1.x(i)
          enemy1.explosiony(i)=enemy1.y(i)
          enemy1.id(i)=1
          enemy1.alive(i)=0 
          bullet_in_use = bullet_in_use -1          
        end if

'      if lefta2 < bbxa2 and righta2 > bxa2 and topa2 < bbya2 and bottoma2 then
'          'bullet.alive(j)=0
'          enemy2.explosionx(i)=enemy2.x(i)
'          enemy2.explosiony(i)=enemy2.y(i)
'          enemy2.id(i)=1
'          enemy2.alive(i)=0 
'       end if
'      if lefta3 < bbxa3 and righta3 > bxa3 and topa3 < bbya3 and bottoma3 then
'          'bullet.alive(j)=0
'          enemy3.explosionx(i)=enemy3.x(i)
'          enemy3.explosiony(i)=enemy3.y(i)
'          enemy3.id(i)=1
'          enemy3.alive(i)=0 
'       end if

'     if lefta4 < bbxa4 and righta4 > bxa4 and topa4 < bbya4 and bottoma4 then
'         'bullet.alive(j)=0
'         enemy4.explosionx(i)=enemy4.x(i)
'         enemy4.explosiony(i)=enemy4.y(i)
'         enemy4.id(i)=1
'         enemy4.alive(i)=0 
'      end if

    next j

next i

'dim integer enemy1.explosionx(maxenemies)
'dim integer enemy1.explosiony(maxenemies)


'enemy1.id(maxenemies)
'dim integer enemy1.x(maxenemies)
'dim integer enemy1.y(maxenemies)
'dim integer enemy1.alive(maxenemies)
'dim integer 


end sub

sub showexplosion

'dim integer coll1.tmpy(maxenemies)
'dim integer coll1.explosions=6
'dim integer enemy1.explode_delay=1

'if enemy1.explode_delay > 4 then

  for p = 1 to maxenemies

      if enemy1.id(p) =1 then
           enemy1.alive(p)=0
           blit ememy1.exp_framecount,169,enemy1.explosionx(p),enemy1.explosiony(p),32,32,1
           ememy1.exp_framecount = ememy1.exp_framecount + enemy1.framespace
             if ememy1.exp_framecount >268 then enemy1.id(p)=0:enemy1.alive(p)=1:enemy1.x(p)=(rnd()*799):enemy1.y(p)=1:enemy1.explode_delay = 1
      end if



'      if enemy2.id(p) =1 then
'           enemy2.alive(p)=0
'           blit ememy2.exp_framecount,169,enemy2.explosionx(p),enemy2.explosiony(p),32,32,1
'           ememy2.exp_framecount = ememy2.exp_framecount + enemy2.framespace
'               if ememy2.exp_framecount >268 then enemy2.id(p)=0:enemy2.alive(p)=1:enemy2.x(p)=(rnd()*799):enemy2.y(p)=1:enemy2.explode_delay = 1
'      end if



'      if enemy3.id(p) =1 then
'           enemy3.alive(p)=0
'           blit ememy3.exp_framecount,169,enemy3.explosionx(p),enemy3.explosiony(p),32,32,1
'           ememy3.exp_framecount = ememy3.exp_framecount + enemy3.framespace
'             if ememy3.exp_framecount >268 then enemy3.id(p)=0:enemy3.alive(p)=1:enemy3.x(p)=(rnd()*799):enemy3.y(p)=1:enemy3.explode_delay = 1
'      end if


'      if ememy4.exp_framecount >268 then enemy4.id(p)=0:enemy4.alive(p)=1:enemy4.x(p)=(rnd()*799):enemy4.y(p)=1:enemy4.explode_delay = 1
'             if enemy4.id(p) =1 then
'           enemy4.alive(p)=0
'           blit ememy4.exp_framecount,169,enemy4.explosionx(p),enemy4.explosiony(p),32,32,1
'           ememy4.exp_framecount = ememy4.exp_framecount + enemy4.framespace
'             if ememy4.exp_framecount >268 then enemy4.id(p)=0:enemy4.alive(p)=1:enemy4.x(p)=(rnd()*799):enemy4.y(p)=1:enemy4.explode_delay = 1
'       end if
    next p
'end if
  enemy1.explode_delay=enemy1.explode_delay + 1

end sub

sub bullinuse

          for j = 1 to MAX_SHOTS
         if bullet.alive(j)=1 then bullet_in_use = bullet_in_use +1
         next j


end sub

'#################################



sub play_sfx(sfx$,p)

local snd$

if sfx_snd=0 then exit sub

snd$=sfx$+".wav"

if p>=pr_snd then
  pr_snd=p
  if mm.info(sound)="MODFILE" then
  play effect snd$, end_sfx
  END IF
END IF

end sub

Sub end_sfx

  pr_snd=-99

end SUB
