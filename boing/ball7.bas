'load boing
'mode 1
page write 1
cls rgb(white)
dim integer xpos=mm.hres/2, ypos=mm.vres/2
dim as integer x_scroll = 1
dim as integer y_scroll = 1
dim as integer adjust_y_scroll =0
CONST leftedge = MM.HRES/8
CONST rightedge = MM.HRES-leftedge
CONST topedge = MM.VRES/5
CONST bottomedge = MM.VRES-topedge
neg =1
fw=1
' blit x1,y1,x2,y2,w,h,page

      for i = 1 to 59
 
                  '  load bmp "00"+str$(i)
      if i < 10 then
         load bmp "down/000"+str$(i)+".bmp"
'         blit 0,0,0,128,128,128,1
        'print "000"+str$(i)+".bmp"
       sprite read i,0,0,128,128,1
         else
         load bmp "down/00"+str$(i)+".bmp"
 '        blit 0,0,0,128,128,128,1
        sprite read i,0,0,128,128,1
        'print "00"+str$(i)
'      sprite show i,100,100,1

     end if 



cls RGB(white)
next i
cls
page write 2
cls RGB(white)

startframe = 1

do

  sprite show startframe,xpos,ypos,2
  draw
  pause 5
  startframe = startframe +1
  if startframe = 59 then
    startframe = 1
  end if 

page copy 2 to 0,b
cls RGB(white)
loop 


sub draw

xpos = xpos + 8*neg
if xpos > 700 then
neg = -1
fw=1
end if
if xpos < 10 then
  neg=1
  fw=-1
end if

end sub
