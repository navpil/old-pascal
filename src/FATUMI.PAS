uses crt;
type boardtype=array[1..5,1..5] of byte;
     counttype=array[1..2]of byte;
const
  stx=13;
  sty=5;
var
  board:boardtype;
  stonesvar:counttype;
  x,y,xone,yone,xto,yto,difficulty:integer;
  compmoves_char:char;
  compmoves:boolean;

procedure generatemove(boardbeg:boardtype; n:integer; var xst,yst,xgo,ygo:integer; var beststones:counttype);forward;

procedure makeboard(var a1:boardtype);
  var
    x1,y1:integer;
  begin
    for x1:=1 to 5 do for y1:=1 to 5 do a1[x1,y1]:=0;
    for x1:=1 to 2 do for y1:=1 to 3 do a1[x1*2,y1*2-1]:=9;
    for x1:=1 to 3 do for y1:=1 to 2 do a1[x1*2-1,y1*2]:=9;
    for x1:=1 to 5 do for y1:=1 to 2 do if a1[x1,y1]=0 then a1[x1,y1]:=2;
    for x1:=1 to 5 do for y1:=4 to 5 do if a1[x1,y1]=0 then a1[x1,y1]:=1;
  end;

procedure drawboard;
  begin
    textcolor(9);
       gotoxy(stx,sty);write('…Õª---…Õª---…Õª');
     gotoxy(stx,sty+1);write('∫ ∫   ∫ ∫   ∫ ∫');
     gotoxy(stx,sty+2);write('»Õº   »Õº   »Õº');
     gotoxy(stx,sty+3);write('| \   /|\   / |');
     gotoxy(stx,sty+4);write('|  …Õª | …Õª  |');
     gotoxy(stx,sty+5);write('|  ∫ ∫ | ∫ ∫  |');
     gotoxy(stx,sty+6);write('|  »Õº | »Õº  |');
     gotoxy(stx,sty+7);write('|  /  \| /  \ |');
     gotoxy(stx,sty+8);write('…Õª   …Õª   …Õª');
     gotoxy(stx,sty+9);write('∫ ∫---∫ ∫---∫ ∫');
    gotoxy(stx,sty+10);write('»Õº   »Õº   »Õº');
    gotoxy(stx,sty+11);write('| \   /|\   / |');
    gotoxy(stx,sty+12);write('|  …Õª | …Õª  |');
    gotoxy(stx,sty+13);write('|  ∫ ∫ | ∫ ∫  |');
    gotoxy(stx,sty+14);write('|  »Õº | »Õº  |');
    gotoxy(stx,sty+15);write('|  /  \| /  \ |');
    gotoxy(stx,sty+16);write('…Õª   …Õª   …Õª');
    gotoxy(stx,sty+17);write('∫ ∫   ∫ ∫   ∫ ∫');
    gotoxy(stx,sty+18);write('»Õº---»Õº---»Õº');
  end;

procedure drawwtgf(x1,y1,stcol:integer);
  begin
    textcolor(stcol);
    gotoxy(stx+x1*3-3,sty+y1*4-4);write('…Õª');
    gotoxy(stx+x1*3-3,sty+y1*4-3);write('∫');
    gotoxy(stx+x1*3-1,sty+y1*4-3);write('∫');
    gotoxy(stx+x1*3-3,sty+y1*4-2);write('»Õº');
  end;

procedure drawwtgt(x1,y1:integer);
  begin
    textcolor(11);
    gotoxy(stx+x1*3-3,sty+y1*4-4);write('…Õª');
    gotoxy(stx+x1*3-3,sty+y1*4-3);write('∫');
    gotoxy(stx+x1*3-1,sty+y1*4-3);write('∫');
    gotoxy(stx+x1*3-3,sty+y1*4-2);write('»Õº');
    textcolor(15);
    gotoxy(stx+x1*3-2,sty+y1*4-3);write('W');
  end;

procedure drawstones;
  var
    x1,y1:integer;
  begin
    for x1:=1 to 5 do for y1:=1 to 5 do
      begin
        gotoxy(stx+x1*3-2,sty+y1*4-3);
        case board[x1,y1] of
          0:begin
              textcolor(0);
              write(' ');
            end;
          2:begin
              textcolor(12);
              write('R');
            end;
          1:begin
              textcolor(15);
              write('W');
            end;

        end;

      end;

  end;

procedure countstones(boardbeg:boardtype; var stonesres:counttype);
  var
    x1,y1:integer;
  begin
    stonesres[1]:=0;
    stonesres[2]:=0;
    for x1:=1 to 5 do for y1:=1 to 5 do
      case boardbeg[x1,y1] of
        1:inc(stonesres[1]);
        2:inc(stonesres[2]);
      end;
  end;

function chooseredstone(st1,st2:counttype):boolean;
  begin
    if (st1[1]<>0)and(st2[1]<>0)then
      begin
        if (st1[2]/st1[1])>(st2[2]/st2[1]) then chooseredstone:=true
          else chooseredstone:=false;
      end;
    if (st1[1]=0)and(st2[1]=0) then
       begin
         if st1[2]>st2[2] then chooseredstone:=true
           else chooseredstone:=false;
       end;
    if (st1[1]=0)and(st2[1]<>0) then chooseredstone:=true;
    if (st1[1]<>0)and(st2[1]=0) then chooseredstone:=false;
  end;

function movedai(smer:integer; boardbeg:boardtype; i,j,stonecolor:integer):boolean;
  begin
    movedai:=false;
    case smer of
      1:if (j>1) and (i>1) and (boardbeg[i-1,j-1]<>stonecolor) then movedai:=true;
      2:if ((j mod 2)=1)and(j>1)and(boardbeg[i,j-2]<>stonecolor) then movedai:=true;
      3:if (j>1)and(i<5)and(boardbeg[i+1,j-1]<>stonecolor) then movedai:=true;
      4:if ((i mod 2)=1)and(i<5)and(boardbeg[i+2,j]<>stonecolor) then movedai:=true;
      5:if (j<5)and(i<5)and(boardbeg[i+1,j+1]<>stonecolor) then movedai:=true;
      6:if ((j mod 2)=1)and(j<5)and(boardbeg[i,j+2]<>stonecolor) then movedai:=true;
      7:if (j<5)and(i>1)and(boardbeg[i-1,j+1]<>stonecolor) then movedai:=true;
      8:if ((i mod 2)=1)and(i>1)and(boardbeg[i-2,j]<>stonecolor) then movedai:=true;
    end;

  end;

procedure movestone(smer:integer; var boardbeg:boardtype; i,j,stonecolor:integer);
  begin
    boardbeg[i,j]:=0;
    case smer of
      1:boardbeg[i-1,j-1]:=stonecolor;
      2:boardbeg[i,j-2]:=stonecolor;
      3:boardbeg[i+1,j-1]:=stonecolor;
      4:boardbeg[i+2,j]:=stonecolor;
      5:boardbeg[i+1,j+1]:=stonecolor;
      6:boardbeg[i,j+2]:=stonecolor;
      7:boardbeg[i-1,j+1]:=stonecolor;
      8:boardbeg[i-2,j]:=stonecolor;
    end;
  end;

procedure createxygo(i,j,smer:integer;var xgo,ygo:integer);
  begin
    case smer of
      1:begin xgo:=i-1;ygo:=j-1;end;
      2:begin xgo:=i;ygo:=j-2;end;
      3:begin xgo:=i+1;ygo:=j-1;end;
      4:begin xgo:=i+2;ygo:=j;end;
      5:begin xgo:=i+1;ygo:=j+1;end;
      6:begin xgo:=i;ygo:=j+2;end;
      7:begin xgo:=i-1;ygo:=j+1;end;
      8:begin xgo:=i-2;ygo:=j;end;
    end;
  end;

procedure generatewhite(boardbeg:boardtype; n:integer; var beststones:counttype);
  var
    i,j,m,xst1,yst1,xgo1,ygo1:integer;
    board1:boardtype;
    movedone:boolean;
    stones1:counttype;
  begin
    movedone:=false;
    beststones[1]:=0;
    beststones[2]:=10;

    for i:=1 to 5 do for j:=1 to 5 do if boardbeg[i,j]=1 then

        for m:=1 to 8 do
          begin
            if movedai(m,boardbeg,i,j,1) then
              begin
                board1:=boardbeg;
                movestone(m,board1,i,j,1);
                countstones(board1,stones1);

                if n>0 then generatemove(board1,n-1,xst1,yst1,xgo1,ygo1,stones1);

                if not chooseredstone(stones1,beststones) then beststones:=stones1;

              end;
          end;

  end;



procedure generatemove(boardbeg:boardtype; n:integer; var xst,yst,xgo,ygo:integer; var beststones:counttype);
  var
    i,j,m:integer;
    board1:boardtype;
    movedone:boolean;
    stones1:counttype;
  begin
    movedone:=false;
    beststones[1]:=10;
    beststones[2]:=0;

    for i:=1 to 5 do for j:=1 to 5 do if boardbeg[i,j]=2 then

        for m:=1 to 8 do
          begin
            if movedai(m,boardbeg,i,j,2) then
              begin
                board1:=boardbeg;
                movestone(m,board1,i,j,2);
                countstones(board1,stones1);

                if n>0 then generatewhite(board1,n-1,stones1);

{*******************************************}

                if not movedone then
                  begin
                    xst:=i;yst:=j;createxygo(i,j,m,xgo,ygo); {finding the best move}
                    movedone:=true;
                  end;

                if chooseredstone(stones1,beststones) then
                  begin
                    xst:=i;yst:=j;createxygo(i,j,m,xgo,ygo); {finding the best move}
                    beststones:=stones1;
                  end;
{*******************************************}


              end;
          end;

  end;

procedure weretogofrom(boardbeg:boardtype; var xst,yst:integer);
  var
    c:char;
    i,j,m:integer;
    endthis:boolean;
  begin
    endthis:=false;
    for i:=1 to 5 do for j:=1 to 5 do if boardbeg[i,j]=1 then
      for m:=1 to 8 do if movedai(m,boardbeg,i,j,1) then
        begin
          xst:=i;yst:=j;
        end;
    while not endthis do
      begin
        drawwtgf(xst,yst,11);
        c:=readkey;
        drawwtgf(xst,yst,9);
        if c=#0 then
          begin
            c:=readkey;
            case c of
              #72:if yst>1 then
                    begin
                      dec(yst);
                      if xst>1 then dec(xst) else inc(xst);
                    end;
              #80:if yst<5 then
                    begin
                      inc(yst);
                      if xst>1 then dec(xst) else inc(xst);
                    end;
              #77:if xst<4 then xst:=xst+2;
              #75:if xst>2 then xst:=xst-2;
              #13:c:=#87;
            end;
          end else if (c=#13)and(boardbeg[xst,yst]=1) then endthis:=true;
     end;
  end;

procedure usermoves(boardbeg:boardtype; var xst,yst,xgo,ygo:integer);
  var
    m:integer;
    endthis:boolean;
    c:char;
  begin
    weretogofrom(boardbeg,xst,yst);
    xgo:=xst;
    ygo:=yst;
    m:=0;
    endthis:=false;
    while not endthis do
      begin
        drawboard;drawstones;
        gotoxy(stx+xst*3-2,sty+yst*4-3);write(' ');
        drawwtgt(xgo,ygo);
        drawwtgf(xst,yst,10);
        c:=readkey;
        case c of
          #27:begin
                drawboard;drawstones;
                weretogofrom(boardbeg,xst,yst);
                xgo:=xst;
                ygo:=yst;
                m:=0;
              end;
          #13:if boardbeg[xgo,ygo]<>1 then endthis:=true;
          #0:begin
               c:=readkey;
               case c of
                 #72:case m of
                       0,8,4:begin
                               if movedai(2,boardbeg,xst,yst,1) then m:=2;
                               if movedai(1,boardbeg,xst,yst,1) then m:=1;
                               if movedai(3,boardbeg,xst,yst,1) then m:=3;
                             end;
                       7,6,5:m:=0;
                       1,3:if movedai(2,boardbeg,xst,yst,1) then m:=2;
                     end;
                 #80:case m of
                       0,8,4:begin
                               if movedai(6,boardbeg,xst,yst,1) then m:=6;
                               if movedai(5,boardbeg,xst,yst,1) then m:=5;
                               if movedai(7,boardbeg,xst,yst,1) then m:=7;
                             end;
                       1,2,3:m:=0;
                       7,5:if movedai(6,boardbeg,xst,yst,1) then m:=6;
                     end;
                 #77:case m of
                       1:if movedai(2,boardbeg,xst,yst,1) then m:=2
                           else if movedai(3,boardbeg,xst,yst,1) then m:=3;
                       2:if movedai(3,boardbeg,xst,yst,1) then m:=3;
                       8:m:=0;
                       0:if movedai(4,boardbeg,xst,yst,1) then m:=4;
                       7:if movedai(6,boardbeg,xst,yst,1) then m:=6 else
                           if movedai(5,boardbeg,xst,yst,1) then m:=5;
                       6:if movedai(5,boardbeg,xst,yst,1) then m:=5;
                     end;
                 #75:case m of
                       3:if movedai(2,boardbeg,xst,yst,1) then m:=2
                           else if movedai(1,boardbeg,xst,yst,1) then m:=1;
                       2:if movedai(1,boardbeg,xst,yst,1) then m:=1;
                       4:m:=0;
                       0:if movedai(8,boardbeg,xst,yst,1) then m:=8;
                       5:if movedai(6,boardbeg,xst,yst,1) then m:=6 else
                           if movedai(7,boardbeg,xst,yst,1) then m:=7;
                       6:if movedai(7,boardbeg,xst,yst,1) then m:=7;
                     end;
                 #13:c:=#87;
                 #27:c:=#87;
               end;
               if m<>0 then createxygo(xst,yst,m,xgo,ygo) else
                 begin
                   xgo:=xst;ygo:=yst;
                 end;

             end;

        end;
      end;

  end;

procedure userchange;
  var
    c:char;
    i,j,m:integer;
    endthis:boolean;
  begin
    endthis:=false;
    i:=1;j:=1;
    while not endthis do
      begin
        drawboard;
        drawwtgf(i,j,11);
        drawstones;
        c:=readkey;
        if c=#0 then
          begin
            c:=readkey;
            case c of
              #72:if j>1 then
                    begin
                      dec(j);
                      if i>1 then dec(i) else inc(i);
                    end;
              #80:if j<5 then
                    begin
                      inc(j);
                      if i>1 then dec(i) else inc(i);
                    end;
              #77:if i<4 then i:=i+2;
              #75:if i>2 then i:=i-2;
              #13:c:=#87;
            end;
          end else case c of
                     ' ':board[i,j]:=0;
                     'w':board[i,j]:=1;
                     'r':board[i,j]:=2;
                     #13:endthis:=true;
                   end;

     end;
  end;

begin
  clrscr;
  writeln('Choose difficulty 1-5');
  readln(difficulty);
  writeln('Computer first? (y/n)');
  readln(compmoves_char);

  clrscr;
  textmode(1);
  textcolor(9);{11 - light blue}
  makeboard(board);
  drawboard;
  drawstones;
  userchange;
  drawboard;
  drawstones;

  compmoves:=false;
  if compmoves_char = 'y' then
  begin
    compmoves := true;
  end;

  countstones(board,stonesvar);

  while (stonesvar[1]>0)and(stonesvar[2]>0) do
    begin
      if compmoves then
        begin
          generatemove(board,difficulty,xone,yone,xto,yto,stonesvar);
          board[xone,yone]:=0;
          board[xto,yto]:=2;
          compmoves:=false;
        end else
          begin
            usermoves(board,xone,yone,xto,yto);
            board[xone,yone]:=0;
            board[xto,yto]:=1;
            compmoves:=true;
          end;
      countstones(board,stonesvar);
      drawboard;
      drawstones;
    end;

  readkey;

end.
