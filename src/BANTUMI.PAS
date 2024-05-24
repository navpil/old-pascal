uses
  crt;
type
  ukrop=array[0..13]of integer;
  hallofglory=record
                name:string;
                first:array[1..2]of integer;
                second:array[1..2]of integer;
                third:array[1..2]of integer;
              end;
var
  a,best1:ukrop;
  stonenumber,name1,ch,h,g,gre1,txtmd,here,OrigMode,dif,player,level1,nu,i,j,code,numb,stone,x,k:integer;
  exitt,start,man,gre,b:boolean;
  c:char;
  txtfl:text;
  glory:array[1..10]of hallofglory;
  s:string[10];

const
  {k=3;{20 if textmode 2}
  menu1=14;
  menu2=14;
  mx=32;
  my=12;
  ba=16;
  bl=45;
  rdd=6;

procedure redo(var glor:array of hallofglory);forward;

procedure bantumi;
  var
    i:integer;
  begin
    textcolor(11);
    gotoxy(ba,5);write('ÚÄÄÄ¿  ÚÄÄÄ¿  ³\  ³ ÄÄÂÄÄ ³  ³ ³\  /³  ³');
    gotoxy(ba,6);write('ÃÄÄÄ´  ³   ³  ³ \ ³   ³   ³  ³ ³ \/ ³  ³');
    gotoxy(ba,7);write('³   ³  ÃÄÄÄ´  ³  \³   ³   ÀÄÄÙ ³    ³  ³');
    gotoxy(ba,8);write('ÀÄÄÄÙ');
    textcolor(14);
    for i:=ba+15 to ba+17 do begin
      gotoxy(i,i-10-ba);
      writeln('\');
    end;
    for i:=ba+32 to ba+33 do begin
      gotoxy(i,i-27-ba);write('\');
      gotoxy(i+2,ba+38-i);write('/');
    end;
  end;
{
ÚÄÄÄ¿  ÚÄÄÄ¿  ³\  ³ ÄÄÂÄÄ ³  ³ ³\  /³  ³
ÃÄÄÄ´  ³   ³  ³ \ ³   ³   ³  ³ ³ \/ ³  ³
³   ³  ÃÄÄÄ´  ³  \³   ³   ÀÄÄÙ ³    ³  ³
ÀÄÄÄÙ}

procedure drawred(a1:ukrop);          {Draws red numbers}
  var
    i:integer;
  begin
    textcolor(12);
    textbackground(0);
    for i:=12 downto 7 do
      begin
        gotoxy(k+10+(12-i)*3,10);
        write(a[i]);
      end;
  end;

procedure drawblue(a1:ukrop);         {Draws blue numbers}
  var
    i:integer;
  begin
    textcolor(9);
    textbackground(0);
    for i:=0 to 5 do
      begin
        gotoxy(k+10+i*3,12);
        write(a[i]);
      end;
  end;
                         {Changes the value of one particular number}
procedure change(x1,numb1:integer; man1:boolean; var a1:ukrop);
  var
    i:integer;
  begin
    i:=numb1+x1;
    i:=i mod 13;
    if not man1 then if i=0 then i:=13 else if i<7 then dec(i);
    inc(a1[i]);
  end;
{C'a procedura bula doroblena!!!}
                         {In case of finishing on the zero}
procedure takeback(var a1:ukrop; il:integer);
  var
    i:integer;
  begin
    i:=a1[il]+a1[12-il];
    a1[il]:=0;
    a1[12-il]:=0;
    if il>6 then a1[13]:=a1[13]+i+1 else a1[6]:=a1[6]+i+1;
  end;
{C'a procedura tezh bula doroblena}
                         {It checks the last place}
procedure checkpole(numb1,stone1:integer; var man1:boolean; var a1:ukrop);
  var
    i:integer;
  begin
    i:=numb1+stone1;
    i:=i mod 13;
    if not man1 then if i=0 then i:=13 else if i<7 then dec(i);
    man1:=not man1;
    if ((i+1) mod 7)=0 then
      begin
        inc(a1[i]);
        man1:=not man1;
      end
      else if a1[i]<>0 then inc(a1[i])
        else if (not man1 and (i<6)) or (man1 and (i>6)) then takeback(a1,i)
          else inc(a1[i]);
  end;

procedure redo2(var glor: array of hallofglory; s1:string; ch1,dif1,name2:integer);
  {var}

  begin
    dec(name2);
    if glor[name2+5].third[1]=0 then
      begin
        if dif1=5 then
          begin
            glor[name2+5].name:=s1;
            glor[name2+5].third[1]:=a[6];
            glor[name2+5].third[2]:=a[13];
          end else
          if glor[name2+5].second[1]=0 then
            begin
              if dif1=3 then
                begin
                  glor[name2+5].name:=s1;
                  glor[name2+5].second[1]:=a[6];
                  glor[name2+5].second[2]:=a[13];
                end else
                  begin
                    if (glor[name2+5].first[1]=0)or((glor[name2+5].first[1]-glor[name2+5].first[2])<ch) then
                      begin
                        glor[name2+5].name:=s1;
                        glor[name2+5].first[1]:=a[6];
                        glor[name2+5].first[2]:=a[13];
                      end;
                  end;

            end else if dif1=3 then
              begin
                if (glor[name2+5].first[1]=0)or((glor[name2+5].second[1]-glor[name2+5].second[2])<ch) then
                  begin
                    glor[name2+5].name:=s1;
                    glor[name2+5].second[1]:=a[6];
                    glor[name2+5].second[2]:=a[13];
                  end;

              end;
      end else if dif=5 then
        begin
          if (glor[name2+5].first[1]=0)or((glor[name2+5].third[1]-glor[name2+5].third[2])<ch) then
            begin
              glor[name2+5].name:=s1;
              glor[name2+5].third[1]:=a[6];
              glor[name2+5].third[2]:=a[13];
            end;
        end;
    redo(glor);
  end;

procedure redo(var glor:array of hallofglory);
  var
    redo1:hallofglory;
    i1,j1:integer;
    b1:boolean;
  begin
    for i1:=0 to 3 do
      for j1:=i1 to 4 do
        begin
          if (glor[j1].third[1]-glor[j1].third[2])>(glor[i1].third[1]-glor[i1].third[2])then
            begin
              if (glor[j1].third[1]<>0) and (glor[j1].third[2]<>0){ and (glor[i1].third[1]<>0) and (glor[i1].third[2]<>0)} then
                begin
                  redo1:=glor[i1];
                  glor[i1]:=glor[j1];
                  glor[j1]:=redo1;
                end;
            end;
          if (glor[j1].third[1]-glor[j1].third[2])=(glor[i1].third[1]-glor[i1].third[2])then
            begin
              if (glor[j1].second[1]-glor[j1].second[2])>(glor[i1].second[1]-glor[i1].second[2])then
                begin
                  if (glor[j1].second[1]<>0) and (glor[j1].second[2]<>0) {and (glor[i1].second[1]<>0)
                    and (glor[i1].second[2]<>0)} then
                    begin
                      redo1:=glor[i1];
                      glor[i1]:=glor[j1];
                      glor[j1]:=redo1;
                    end;
                end;
              if (glor[j1].second[1]-glor[j1].second[2])=(glor[i1].second[1]-glor[i1].second[2])then
                if (glor[j1].first[1]-glor[j1].first[2])>(glor[i1].first[1]-glor[i1].first[2])then
                  begin
                    if (glor[j1].first[1]<>0) and (glor[j1].first[2]<>0) {and (glor[i1].first[1]<>0)
                      and (glor[i1].first[2]<>0)} then
                      begin
                        redo1:=glor[i1];
                        glor[i1]:=glor[j1];
                        glor[j1]:=redo1;
                      end;
                  end
            end;
        end;
    for i1:=5 to 8 do
      for j1:=i1 to 9 do
        begin
          if (glor[j1].third[1]-glor[j1].third[2])>(glor[i1].third[1]-glor[i1].third[2])then
            begin
              if (glor[j1].third[1]<>0) and (glor[j1].third[2]<>0){ and (glor[i1].third[1]<>0) and (glor[i1].third[2]<>0)} then
                begin
                  redo1:=glor[i1];
                  glor[i1]:=glor[j1];
                  glor[j1]:=redo1;
                end;
            end;
          if (glor[j1].third[1]-glor[j1].third[2])=(glor[i1].third[1]-glor[i1].third[2])then
            begin
              if (glor[j1].second[1]-glor[j1].second[2])>(glor[i1].second[1]-glor[i1].second[2])then
                begin
                  if (glor[j1].second[1]<>0) and (glor[j1].second[2]<>0){ and (glor[i1].second[1]<>0)
                    and (glor[i1].second[2]<>0)} then
                    begin
                      redo1:=glor[i1];
                      glor[i1]:=glor[j1];
                      glor[j1]:=redo1;
                    end;
                end;
              if (glor[j1].second[1]-glor[j1].second[2])=(glor[i1].second[1]-glor[i1].second[2])then
                if (glor[j1].first[1]-glor[j1].first[2])>(glor[i1].first[1]-glor[i1].first[2])then
                  begin
                    if (glor[j1].first[1]<>0) and (glor[j1].first[2]<>0){ and (glor[i1].first[1]<>0)
                      and (glor[i1].first[2]<>0)} then
                      begin
                        redo1:=glor[i1];
                        glor[i1]:=glor[j1];
                        glor[j1]:=redo1;
                      end;
                  end
            end;
        end;
    for i1:=0 to 3 do
      begin
        b:=true;
        if glor[i1].name='' then
          for j1:=i1 to 4 do
            begin
              if (glor[j1].name<>'')and b then
                begin
                  redo1:=glor[j1];
                  glor[j1]:=glor[i1];
                  glor[i1]:=redo1;
                end;
            end;
      end;
    for i1:=5 to 8 do
      begin
        b:=true;
        if glor[i1].name='' then
          for j1:=i1 to 9 do
            begin
              if (glor[j1].name<>'')and b then
                begin
                  redo1:=glor[j1];
                  glor[j1]:=glor[i1];
                  glor[i1]:=redo1;
                end;
            end;
      end;

  end;
                        {Choosing the place, just for player}
procedure choose(m1:boolean; var now:integer; a1:ukrop);
  var
    here, next,y,va:integer;
    ch:char;
    b:boolean;
  begin
    if m1 then
      begin
        y:=12;
        textcolor(9);
      end else
        begin
          y:=10;
          textcolor(9);
        end;
    b:=true;
    while b do
      begin
        drawblue(a1);
        gotoxy(k+28,11);
        write(a1[6]);
        drawred(a1);
        if a1[13]<10 then gotoxy(k+7,11) else gotoxy(k+6,11);
        write(a1[13]);
        gotoxy(k+10+now*3,y);
        textbackground(7);
        if m1 then textcolor(9) else textcolor(12);
        if m1 then write(a1[now]) else write(a1[12-now]);
        {!!!!!!!!!!11}
        if m1 then here:=now+a1[now] else here:=(12-now)+a1[12-now];
        here:=here mod 13;
        if not m1 then if here=0 then here:=13 else if here<7 then dec(here);
        textcolor(12);
        if (here>6) and (here<>13) then gotoxy(k+10+(12-here)*3,10);
        if here=13 then
          if a1[13]<10 then gotoxy(k+7,11) else gotoxy(k+6,11);
        if here<6 then
          begin
            textcolor(9);
            gotoxy(k+10+here*3,12);
          end;
        if here=6 then
          begin
            textcolor(9);
            gotoxy(k+28,11);
          end;
        textbackground(2);
        if ((a1[now]<>0)and m1)or((a1[12-now]<>0)and not m1) then if gre then write(a1[here]);
        if (player mod 2)=0 then gotoxy(k+20,15) else
          if man then gotoxy(k+29,15) else gotoxy(k+28,15);
        {!!!!!!!!!!!!!}
        textcolor(0);
        {!!!!!!!!!!!!!}
        ch:=readkey;
        if ch=#27 then
          begin
            exitt:=true;
            b:=false;
          end;
        if (ch=#13) and ((m1 and (a[now]<>0)) or (not m1 and (a[12-now]<>0))) then b:=false;
        if keypressed then ch:=readkey;
        case ch of
          #75:if now>0 then dec(now);
          #77:if now<5 then inc(now);
        end;
      end;
    textbackground(0);
    if not m1 then now:=5-now;
  end;
                       {Checks whether the program shouldn't finish already}
function empty(a1: ukrop):boolean;
  var
    i:integer;
    b1,b2:boolean;
  begin
    b1:=true;
    b2:=true;
    for i:=0 to 5 do if a1[i]<>0 then b1:=false;
    for i:=7 to 12 do if a1[i]<>0 then b2:=false;
    if b1 or b2 then empty:=true else empty:=false;
  end;
{C'a procedura bula doroblena}

procedure choosepc(var numb1:integer; var best:ukrop; man1:boolean; level:integer);
  var
    ukr:array[1..6]of ukrop;
    a1:ukrop;
    i,j,stone1:integer;
    b:boolean;
  begin
    if man1 then j:=0 else j:=7;
    if not empty(best) then
      for i:=j to (j+5) do
        begin
          a1:=best;
          b:=man1;
          if a1[i]<>0 then
            begin
              stone1:=a1[i];
              a1[i]:=0;
              if stone1>1 then for x:=1 to stone1-1 do
                change(x,i,b,a1);
              checkpole(i,stone1,b,a1);
              if man1=b then choosepc(numb1,a1,b,level);
              if level>1 then choosepc(numb1,a1,b,level-1);
            end;
          if j=0 then ukr[i+1]:=a1 else ukr[i-6]:=a1;
        end;
    for i:=1 to 6 do
      if ((not man1 and (a[i+6]<>0))or(man1 and(a[i-1]<>0))) then
        begin
          best:=ukr[i];
          numb1:=i;
        end;
    for i:=1 to 6 do
      if (not man1 and ((ukr[i][13]-ukr[i][6])>(best[13]-best[6]))) or
        (man1 and ((ukr[i][13]-ukr[i][6])<(best[13]-best[6]))) then
        begin
          if ((not man1 and (a[i+6]<>0))or(man1 and(a[i-1]<>0))) then
            begin
              best:=ukr[i];
              numb1:=i;
            end;
        end;
  end;

begin
  textcolor(0);
{  k:=3;}
{  dif:=1;
  player:=1;
  txtmd:=1;}
  start:=false;
  stonenumber:=4;
  assign(txtfl,'bantumi.txt');
  {$I-}
  reset(txtfl);
  {$I+}
  if IOResult=0 then
    begin
      readln(txtfl,k);
      readln(txtfl,dif);
      readln(txtfl,player);
      readln(txtfl,txtmd);
      readln(txtfl,gre1);
      for i:=1 to 10 do
        begin
          readln(txtfl,glory[i].name);
          for j:=1 to 2 do read(txtfl,glory[i].first[j]);
          for j:=1 to 2 do read(txtfl,glory[i].second[j]);
          for j:=1 to 2 do read(txtfl,glory[i].third[j]);
          readln(txtfl);
        end;
    end else
      begin
        k:=3;dif:=1;player:=1;txtmd:=1;gre1:=2;
        for i:=1 to 10 do
          begin
            glory[i].name:='';
            for j:=1 to 2 do glory[i].first[j]:=0;
            for j:=1 to 2 do glory[i].second[j]:=0;
            for j:=1 to 2 do glory[i].third[j]:=0;
          end;
        rewrite(txtfl);
        writeln(txtfl,k);
        writeln(txtfl,dif);
        writeln(txtfl,player);
        writeln(txtfl,txtmd);
        writeln(txtfl,gre1);
        for i:=1 to 10 do
          begin
            writeln(txtfl,glory[i].name);
            for j:=1 to 2 do write(txtfl,glory[i].first[j]);
            for j:=1 to 2 do write(txtfl,glory[i].second[j]);
            for j:=1 to 2 do write(txtfl,glory[i].third[j]);
            writeln(txtfl);
          end;
      end;
  close(txtfl);

{  k:=3;
  i:=1;
  dif:=1;
  player:=1;
  txtmd:=1;}
  i:=1;
  gre:=true;if gre1=2 then gre:=false;
{  for j:=1 to 5 do
    begin
      glory[j].name:='Anonym';
    end;}

  repeat
    textbackground(0);
    clrscr;
    bantumi;
    textcolor(menu1);
    gotoxy(mx,my-2);write('MAIN MENU');
    gotoxy(mx,my);write('Start game');
    gotoxy(mx,my+1);write('Options');
    gotoxy(mx,my+2);write('Rules');
    gotoxy(mx,my+3);write('Best players');
    gotoxy(mx,my+4);write('Exit');
    textbackground(menu2);
    case i of
      1:begin gotoxy(mx,my);write('Start game');       end;
      2:begin gotoxy(mx,my+1);write('Options');   end;
      3:begin gotoxy(mx,my+2);write('Rules'); end;
      4:begin gotoxy(mx,my+3);write('Best players'); end;
      5:begin gotoxy(mx,my+4);write('Exit');             end;
    end;
    gotoxy(1,1);
    textcolor(0);
    if i<>10 then c:=readkey else
      begin
        c:=#13;
        i:=4;
      end;
    while keypressed do c:=readkey;
    exitt:=false;
    case c of
      #27:i:=5;
      #13:case i of
            1:begin
                OrigMode:=LastMode;
                TextMode(txtmd);
                for i:=0 to 5 do a[i]:=stonenumber;
                for i:=7 to 12 do a[i]:=stonenumber;
                a[6]:=0;
                a[13]:=0;
                man:=true;
                nu:=0;
              {  dif:=;}
              (**The whole program of plaing is below**)
                while not empty(a) and not exitt do
                  begin
                    textbackground(0);
                    clrscr;              {Drawing the field}
                    drawred(a);
                    textcolor(12);
                    if a[13]<10 then
                      begin
                        gotoxy(k+6,10);write('ÚÄ¿');
                        gotoxy(k+6,11);write('³',a[13],'³');
                        gotoxy(k+6,12);write('ÀÄÙ');
                      end else
                        begin
                          gotoxy(k+5,10);write('ÚÄÄ¿');
                          gotoxy(k+5,11);write('³',a[13],'³');
                          gotoxy(k+5,12);write('ÀÄÄÙ');
                        end;

                    textcolor(9);
                    if a[6]<10 then
                      begin
                    gotoxy(k+27,10);write('ÚÄ¿');
                    gotoxy(k+27,11);write('³',a[6],'³');
                    gotoxy(k+27,12);write('ÀÄÙ');
                      end else
                        begin
                          gotoxy(k+27,10);write('ÚÄÄ¿');
                          gotoxy(k+27,11);write('³',a[6],'³');
                          gotoxy(k+27,12);write('ÀÄÄÙ');
                        end;
                    drawblue(a);
                    gotoxy(k+10,15);
                    if not man then textcolor(12) else textcolor(9);
                    if (player mod 2)=1 then
                      if man then write('Blue player moves: ') else write('Red player moves: ');
                    if (player=2) then
                      if man then write('You move: ') else write('Computer moves: ');
                    if (player=4) then
                      if not man then write('You move: ') else write('Computer moves: ');
{                    bantumi;}
                                        {Finish of drawing the field}
                    case player of
                      1,3:begin
                          if not man then nu:=5-nu;
                          choose(man,nu,a);
                          if not exitt then begin
                            numb:=nu;
                            if not man then numb:=numb+7;
                            stone:=a[numb];
                            a[numb]:=0;
                            for x:=1 to stone-1 do
                              change(x,numb,man,a);
                            checkpole(numb,stone,man,a);
                          end;
                        end;
                      2:begin
                          if man then
                            begin
                              choose(man,nu,a);
                              if not exitt then begin
                                numb:=nu;
                                stone:=a[numb];
                                a[numb]:=0;
                                if stone>0 then for x:=1 to stone-1 do
                                  change(x,numb,man,a);
                                checkpole(numb,stone,man,a);
                              end;
                            end else
                              begin
                                best1:=a;
                                level1:=dif;
                                textcolor(12);
                                gotoxy(k+26,15);write('Please wait');
                                choosepc(numb,best1,man,level1);
                                textcolor(0);
                                gotoxy(k+26,15);write('Please wait');
                                textcolor(12);
                                gotoxy(k+26,15);write('Press Enter');
                                textcolor(0);
                                numb:=numb+6;
                                stone:=a[numb];
                                gotoxy(k+10+(12-numb)*3,10);
                                textbackground(7);
                                textcolor(12);
                                {if gre then }write(a[numb]);
                                here:=numb+a[numb];
                                here:=here mod 13;
                                if here=0 then here:=13 else if here<7 then dec(here);
                                textcolor(12);
                                if (here>6) and (here<>13) then gotoxy(k+10+(12-here)*3,10);
                                if here=13 then
                                  if a[13]<10 then gotoxy(k+7,11) else gotoxy(k+6,11);
                                if here<6 then
                                  begin
                                    textcolor(9);
                                    gotoxy(k+10+here*3,12);
                                  end;
                                if here=6 then
                                  begin
                                    textcolor(9);
                                    gotoxy(k+28,11);
                                  end;
                                textbackground(2);
                                if gre then write(a[here]);
                                gotoxy(k+37,15);
                        {!!!!!!!!!!!!!}
                                textcolor(0);
                        {!!!!!!!!!!!!!}
                                c:=readkey;
                                while keypressed do c:=readkey;
                                if c=#27 then exitt:=true;
                                a[numb]:=0;
                                if stone>1 then for x:=1 to stone-1 do
                                  change(x,numb,man,a);
                                checkpole(numb,stone,man,a);
                              end;
                        end;
                      4:begin
                          if not man then
                            begin
                              nu:=5-nu;
                              choose(man,nu,a);
                              if not exitt then begin
                                numb:=nu;
                                numb:=numb+7;
                                stone:=a[numb];
                                a[numb]:=0;
                                if stone>0 then for x:=1 to stone-1 do
                                  change(x,numb,man,a);
                                checkpole(numb,stone,man,a);
                              end;
                            end else
                              begin
                                best1:=a;
                                level1:=dif;
                                textcolor(9);
                                gotoxy(k+26,15);write('Please wait');
                                choosepc(numb,best1,man,level1);
                                textcolor(0);
                                gotoxy(k+26,15);write('Please wait');
                                textcolor(9);
                                gotoxy(k+26,15);write('Press Enter');
                                textcolor(0);
                                numb:=numb-1;
                                stone:=a[numb];
                                gotoxy(k+10+numb*3,12);
                                textbackground(7);
                                textcolor(1);
                                write(a[numb]);
                                here:=numb+a[numb];
                                here:=here mod 13;
                        {        if here=0 then here:=13 else if here<7 then dec(here);}
                                textcolor(12);
                                if (here>6) and (here<>13) then gotoxy(k+10+(12-here)*3,10);
                                if here=13 then
                                  if a[13]<10 then gotoxy(k+7,11) else gotoxy(k+6,11);
                                if here<6 then
                                  begin
                                    textcolor(9);
                                    gotoxy(k+10+here*3,12);
                                  end;
                                if here=6 then
                                  begin
                                    textcolor(9);
                                    gotoxy(k+28,11);
                                  end;
                                textbackground(2);
                                if gre then write(a[here]);
                                gotoxy(k+37,15);
        {!!!!!!!!!!!!!}
                                textcolor(0);
        {!!!!!!!!!!!!!}
                                c:=readkey;
                                while keypressed do c:=readkey;
                                if c=#27 then exitt:=true;
                                a[numb]:=0;
                                if stone>1 then for x:=1 to stone-1 do
                                  change(x,numb,man,a);
                                checkpole(numb,stone,man,a);
                              end;
                        end;
                     end;
                  end;
              (**The whole program is above**)
                if not exitt then begin
                  textbackground(0);
                  clrscr;
                  textcolor(12);
                  for i:=12 downto 7 do
                    begin
                      gotoxy(k+10+(12-i)*3,10);
                      write(a[i]);
                    end;
                  if a[13]<10 then
                    begin
                      gotoxy(k+6,10);write('ÚÄ¿');
                      gotoxy(k+6,11);write('³',a[13],'³');
                      gotoxy(k+6,12);write('ÀÄÙ');
                    end else
                      begin
                        gotoxy(k+5,10);write('ÚÄÄ¿');
                        gotoxy(k+5,11);write('³',a[13],'³');
                        gotoxy(k+5,12);write('ÀÄÄÙ');
                      end;

{    a[6]:=a[13];}

                  textcolor(9);
                  if a[6]<10 then
                    begin
                  gotoxy(k+27,10);write('ÚÄ¿');
                  gotoxy(k+27,11);write('³',a[6],'³');
                  gotoxy(k+27,12);write('ÀÄÙ');
                    end else
                      begin
                        gotoxy(k+27,10);write('ÚÄÄ¿');
                        gotoxy(k+27,11);write('³',a[6],'³');
                        gotoxy(k+27,12);write('ÀÄÄÙ');
                      end;
                  for i:=0 to 5 do
                    begin
                      gotoxy(k+10+i*3,12);
                      write(a[i]);
                    end;
                  gotoxy(k+10,14);
                  nu:=12;
                  if a[13]>a[6] then
                    begin
                      textcolor(12);
                      if (player mod 2)=1 then write('Red player wins!!!')
                        else begin
                          if player=2 then write('Computer wins!!!') else write('You win!!!')
                             end;
                    end else if a[13]<a[6] then
                      begin
                        textcolor(9);
                        if (player mod 2)=1 then write('Blue player wins!!!')
                          else if player=4 then write('Computer wins!!!')
                            else write ('You win!!!');
                      end else while not keypressed do
                                 begin
                                   gotoxy(k+10,14);
                                   if nu=12 then nu:=9 else nu:=12;
                                   textcolor(nu);
                                   delay(200);
                                   write('Nobody wins!!!');
                                 end;
                  textcolor(0);
                  readkey;
                  while keypressed do readkey;
                end;
                textbackground(0);
                clrscr;
                b:=false;
                ch:=1;
                {Check, whether the game was interrupted or it was finished with the help of exitt}
                {Also check whether it's logical to Enter your name}
                if player=2 then begin
                  ch:=a[6]-a[13];h:=5;end
                    else if player=4 then begin
                      ch:=a[13]-a[6];h:=10; end;
                if player mod 2=0 then begin
                case dif of
                  1:if (ch>(glory[h].first[1]-glory[h].first[2]))or(glory[h].first[1]=0) then b:=true;
                  3:if (ch>(glory[h].second[1]-glory[h].second[2]))or(glory[h].second[1]=0) then b:=true;
                  5:if (ch>(glory[h].third[1]-glory[h].third[2]))or(glory[h].third[1]=0) then b:=true;
                end; end;
                ch:=1;
                h:=1;
                i:=1;
              if not exitt and b and (stonenumber=4) then begin
                if (player=2) or (player=4) then
                  begin
                    if Player=2 then
                      begin
                        name1:=0;
                      end else
                        begin
                          name1:=a[6];
                          a[6]:=a[13];
                          a[13]:=name1;
                          name1:=5;
                        end;
                    b:=false;
                    for i:=(1+name1) to (5+name1) do if glory[i].name<>'' then b:=true;
                    if b then
                      begin
                        h:=0;
                        while (h<5)and(glory[h+1+name1].name<>'') do h:=h+1;
                        textcolor(menu1);
                        gotoxy(k,my);write('What is your name?');
                        c:='0';
                        while (c<>#13) and (ch<>1000) do
                          begin
                            textcolor(menu1);
                            textbackground(0);
                            clrscr;
                            textbackground(0);
                            gotoxy(k,my);write('What is your name?');
                            for i:=(1+name1) to (h+name1) do
                              begin
                                gotoxy(k,my+i-name1+1);write(glory[i].name);
                              end;
                            if ch>h then textbackground(menu2);
                            gotoxy(k,my+h+2);write('OTHER...');
                            textbackground(menu2);
                            if ch<=h then
                              begin
                                gotoxy(k,my+1+ch);
                                write(glory[ch+name1].name);
                              end;
        {!!!!!!!!!!!!!}
                            textcolor(0);
        {!!!!!!!!!!!!!}
                            c:=readkey; while keypressed do c:=readkey;
                            case c of
                              #27:ch:=1000;
                              #72:if ch=1 then ch:=h+1 else dec(ch);
                              #80:if ch=h+1 then ch:=1 else inc(ch);
                              #13:begin
                                    if ch=h+1 then
                                      begin
                                        textbackground(0);
                                        clrscr;
                                        textcolor(menu1-8);
                                        gotoxy(k,my+4);write('maximum 10 symbols');
                                        textcolor(menu1);
                                        gotoxy(k,my);write('Enter your name:');
                                        s:='';
                                        repeat
                                          textcolor(menu1);
                                          gotoxy(k,my+2);write(s);
                                          textcolor(0);
                                          c:=readkey;
                                          gotoxy(k,my+2);write(s);
                                          case c of
                                            #0:begin
                                                 c:=readkey;
                                                 if c=#75 then if length(s)>0 then delete(s,length(s),1);
                                               end;
                                            #33..#255:if length(s)<10 then s:=s+c;
                                            #8:if length(s)>0 then delete(s,length(s),1);
                                          end;
                                        until (c=#13) or (c=#27);
                                      end else s:=glory[ch+name1].name;
                                  end;
                            end;
                          end;
                        i:=1;
                        if ch<>1000 then
                          begin
                            b:=false;
                            ch:=a[6]-a[13];
                            for i:=(1+name1)to(5+name1) do if s=glory[i].name then
                              begin
                                h:=i;
                                b:=true;
                              end;
                            if b then
                              begin
                                case dif of
                                  1:if (ch>(glory[h].first[1]-glory[h].first[2]))or(glory[h].first[1]=0) then
                                      begin
                                        glory[h].first[1]:=a[6];
                                        glory[h].first[2]:=a[13];
                                        redo(glory);
                                      end;
                                  3:if (ch>(glory[h].second[1]-glory[h].second[2]))or(glory[h].second[1]=0) then
                                      begin
                                        glory[h].second[1]:=a[6];
                                        glory[h].second[2]:=a[13];
                                        redo(glory);
                                      end;
                                  5:if (ch>(glory[h].third[1]-glory[h].third[2]))or(glory[h].third[1]=0) then
                                      begin
                                        glory[h].third[1]:=a[6];
                                        glory[h].third[2]:=a[13];
                                        redo(glory);
                                      end;
                                end;
                              end;
                            if not b then
                              begin
                                redo2(glory,s,ch,dif,name1);
                              end;
                            i:=10;
                          end
                      end else
                        begin
                          textbackground(0);
                          clrscr;
                          textcolor(menu1-8);
                          gotoxy(k,my+4);write('maximum 10 symbols');
                          textcolor(menu1);
                          gotoxy(k,my);write('Enter your name:');
                          s:='';
                          repeat
                            textcolor(menu1);
                            gotoxy(k,my+2);write(s);
                            textcolor(0);
                            c:=readkey;
                            gotoxy(k,my+2);write(s);
                            case c of
                              #0:begin
                                   c:=readkey;
                                   if c=#75 then if length(s)>0 then delete(s,length(s),1);
                                 end;
                              #33..#255:if length(s)<10 then s:=s+c;
                              #8:if length(s)>0 then delete(s,length(s),1);
                            end;
                          until (c=#13) or (c=#27);
                          if c=#13 then
                            begin
                              glory[1+name1].name:=s;
                              case dif of
                                1:begin
                                    glory[1+name1].first[1]:=a[6];
                                    glory[1+name1].first[2]:=a[13];
                                  end;
                                3:begin
                                    glory[1+name1].second[1]:=a[6];
                                    glory[1+name1].second[2]:=a[13];
                                  end;
                                5:begin
                                    glory[1+name1].third[1]:=a[6];
                                    glory[1+name1].third[2]:=a[13];
                                  end;
                              end;
                              i:=10;
                            end;
                    end;
                  end;
                end;
                {if player}
                TextMode(OrigMode);
              end;
            2:begin
                j:=1;
                repeat
                  textbackground(0);
                  clrscr;
                  bantumi;
                  textcolor(menu1);
                  gotoxy(mx,my-2);write('OPTIONS');
                  gotoxy(mx,my);
                  if j=1 then textbackground(menu2);
                  if (player mod 2)=1 then write('Two players') else write('One player');
                  textbackground(0);
                  gotoxy(mx,my+1);
                  if j=2 then textbackground(menu2);
                  if (player mod 2)=1 then textcolor(menu2-8);
                  if player<3 then write('Your colour: blue') else write('Your colour: red');
                  textbackground(0);
                  gotoxy(mx,my+2);
                  textcolor(menu1);
                  if j=3 then textbackground(menu2);
                  if (player mod 2)=1 then textcolor(menu2-8);
                  case dif of
                    1:write('Level: 1');
                    3:write('Level: 2');
                    5:write('Level: 3');
                  end;
                  textbackground(0);
                  textcolor(menu1);
                  if j=4 then textbackground(menu2);
                  gotoxy(mx,my+3);
                  case txtmd of
                    1:write('Big field');
                    2:write('Small field');
                  end;
                  textbackground(0);
                  gotoxy(mx,my+4);
                  if j=5 then textbackground(menu2);
                  case gre of
                    true:write('Destination field: yes');
                    false:write('Destination field: no');
                  end;
                  textbackground(0);
                  gotoxy(mx,my+5);
                  if j=6 then textbackground(menu2);
                  write('Stones per field: ',stonenumber);
                  textbackground(0);
                  if j=7 then textbackground(menu2);
                  gotoxy(mx,my+6);write('Back to main menu');
                  {************************}
                  textbackground(0);
                  case j of
                    1:i:=3;
                    2:i:=0;
                    3:i:=3;
                    4:i:=4;
                    5:i:=14;
                    6:i:=15;
                    7:i:=2;
                  end;
                  gotoxy(mx-5-i,my+9);
                  textcolor(6);
                  case j of
                    1:write('Choose number of players');
                    2:write('Choose your colour');
                    3:write('Choose the difficulty level');
                    4:write('Show big field or small field');
                    5:write('Show where the last stone will be put (green colour)');
                    6:write('Choose with the cursor keys (4 is the default number)');
                    7:write('Come back to main menu');
                  end;
                  textcolor(0);
                  {************************}
                  c:=readkey;
                  while keypressed do c:=readkey;
                  case c of
                    #27:exitt:=true;
                    #72:begin
                          if j>1 then dec(j) else j:=7;
                          if ((player mod 2)=1) and (j=3) then j:=1;
                        end;
                    #80:begin
                          if j<7 then inc(j) else j:=1;
                          if ((player mod 2)=1) and (j=2) then j:=4;
                        end;
                    #75:if j=6 then if stonenumber>1 then dec(stonenumber);
                    #77:if j=6 then if stonenumber<10 then inc(stonenumber);
                    #13:case j of
                          1:case player of
                              1,3:inc(player);
                              2,4:dec(player);
                            end;
                          2:case player of
                              2:player:=4;
                              4:player:=2;
                            end;
                          3:if dif<5 then dif:=dif+2 else dif:=1;
                          4:if txtmd=1 then
                              begin
                                txtmd:=2;
                                k:=20;
                              end else
                                begin
                                  txtmd:=1;
                                  k:=3;
                                end;
                          5:gre:= not gre;

                          7:exitt:=true;
                        end;
                  end;
                until exitt;
                i:=2;
              end;
{            3:begin
                j:=((dif-1) div 2)+1;
                repeat
                  textbackground(0);
                  clrscr;
                  bantumi;
                  textcolor(menu1);
                  gotoxy(mx,my-2);write('LEVEL (now: ',((dif-1) div 2)+1,')');
                  gotoxy(mx,my);write('First level');
                  gotoxy(mx,my+1);write('Second level');
                  gotoxy(mx,my+2);write('Third level');
                  gotoxy(mx,my+3);write('Back to main menu');
                  textbackground(menu2);
                  case j of
                    1:begin gotoxy(mx,my);write('First level');end;
                    2:begin gotoxy(mx,my+1);write('Second level');end;
                    3:begin gotoxy(mx,my+2);write('Third level');end;
                    4:begin gotoxy(mx,my+3);write('Back to main menu');end;
                  end;
                  c:=readkey;
                  while keypressed do c:=readkey;
                  case c of
                    #27:exitt:=true;
                    #72:if j>1 then dec(j) else j:=4;
                    #80:if j<4 then inc(j) else j:=1;
                    #13:case j of
                          1,2,3:dif:=(j-1)*2+1;
                          4:exitt:=true;
                        end;
                  end;
                until exitt;
              end;}
            3:begin
                textbackground(0);
                clrscr;
                bantumi;
                textcolor(10);
                gotoxy(mx,my-3);
                write('HOW TO START');
                gotoxy(mx-3,my+4);
                write('HOW TO PLAY BANTUMI');
                textcolor(menu1);
                gotoxy(5,my-2);write('Choose whether you want to play with the computer or not in the OPTIONS');
                gotoxy(1,my-1);write('menu. If you play with the comuter choose which colour will you play. Remember');
                gotoxy(1,my);write('that blue starts. If you play with the computer you can also choose the');
                gotoxy(1,my+1);write('difficulty in the OPTIONS menu. To exit press Esc and then Enter. To start the');
                gotoxy(1,my+2);write('game choose START GAME and press Enter.');
                gotoxy(5,my+5);write('With the cursor keys choose the field and press Enter. Then the stones from');
                gotoxy(1,my+6);write('this field will remove one by one to the next fields counterclockwise.');
                gotoxy(1,my+7);write('The stones will not be put in the main bag of the opponent.');
                gotoxy(5,my+8);write('If you finish in your main bag (for blue player on the right side for the');
                gotoxy(1,my+9);write('red player on the left) you have one more turn. If you finish on your empty');
                gotoxy(1,my+10);write('field then all stones from this and the opposite field will go to your main bag.');
                gotoxy(5,my+11);write('The purpose of the game is that in the end of the game (when all fields at');
                gotoxy(1,my+12);write('least one of the players are empty) you should have more stones in your main bag');
                gotoxy(1,my+13);write('than are in the main bag of your opponent.');
                textcolor(0);
                c:=readkey;
                while keypressed do c:=readkey;
              end;
            4:begin
                textbackground(0);
                clrscr;
                bantumi;
                textcolor(menu1-8);
                gotoxy(rdd-1,my+2);write('Level:      1st    2st    3rd');
                gotoxy(bl-1,my+2);write('Level:      1st    2st    3rd');
{                gotoxy(6,my+2);write('        1st    2st    3rd');
                gotoxy(bl+3,my+2);write('        1st    2st    3rd');}

                textcolor(9);
                gotoxy(rdd+5,my);write('BEST BLUE PLAYERS');
                for j:=1 to 5 do
                  begin
                    if glory[j].name<>'' then
                      begin
                        textcolor(9);
                        gotoxy(rdd-4,my+2+j);write(j,') ',glory[j].name);
                        for g:=1 to (9-length(glory[j].name)) do write(' ');
                        if glory[j].first[1]<>0 then
                          begin
                            gotoxy(rdd+10,my+2+j);
                            textcolor(9);
                            write(glory[j].first[1]);
                            textcolor(10);write(':');
                            textcolor(12);
                            write(glory[j].first[2]);
                          end;
                        if glory[j].second[1]<>0 then
                          begin
                            gotoxy(rdd+17,my+2+j);
                            textcolor(9);
                            write(glory[j].second[1]);
                            textcolor(10);write(':');
                            textcolor(12);
                            write(glory[j].second[2]);
                          end;
                        if glory[j].third[1]<>0 then
                          begin
                            gotoxy(rdd+24,my+2+j);
                            textcolor(9);
                            write(glory[j].third[1]);
                            textcolor(10);write(':');
                            textcolor(12);
                            write(glory[j].third[2]);
                          end;
                      end;
                  end;
                textcolor(12);
                gotoxy(bl+5,my);write('BEST RED PLAYERS');
                for j:=6 to 10 do
                  begin
                    if glory[j].name<>'' then
                      begin
                        textcolor(12);
                        gotoxy(bl-4,my+2+j-5);write(j-5,') ',glory[j].name);
                        for g:=1 to (9-length(glory[j].name)) do write(' ');
                        if glory[j].first[1]<>0 then
                          begin
                            gotoxy(bl+10,my+2+j-5);
                            textcolor(12);
                            write(glory[j].first[1]);
                            textcolor(10);write(':');
                            textcolor(9);
                            write(glory[j].first[2]);
                          end;
                        if glory[j].second[1]<>0 then
                          begin
                            gotoxy(bl+17,my+2+j-5);
                            textcolor(12);
                            write(glory[j].second[1]);
                            textcolor(10);write(':');
                            textcolor(9);
                            write(glory[j].second[2]);
                          end;
                        if glory[j].third[1]<>0 then
                          begin
                            gotoxy(bl+24,my+2+j-5);
                            textcolor(12);
                            write(glory[j].third[1]);
                            textcolor(10);write(':');
                            textcolor(9);
                            write(glory[j].third[2]);
                          end;
                      end;
                  end;
                textcolor(0);
                readkey;
              end;
            5:begin
                textbackground(0);
                clrscr;
                start:=true;
              end;
          end;
      #72:if i>1 then dec(i) else i:=5;
      #80:if i<5 then inc(i) else i:=1;
    end;
    if start then textcolor(7);
  until start;
  if gre then gre1:=1 else gre1:=2;
  assign(txtfl,'bantumi.txt');
  rewrite(txtfl);
  writeln(txtfl,k);
  writeln(txtfl,dif);
  writeln(txtfl,player);
  writeln(txtfl,txtmd);
  writeln(txtfl,gre1);
  for i:=1 to 10 do
    begin
      writeln(txtfl,glory[i].name);
      for j:=1 to 2 do write(txtfl,glory[i].first[j],' ');
      for j:=1 to 2 do write(txtfl,glory[i].second[j],' ');
      for j:=1 to 2 do write(txtfl,glory[i].third[j],' ');
      writeln(txtfl);
    end;
  close(txtfl);
  clrscr;
  textcolor(7);
  write('(c) Halfer 2003 Bantumi v1.0');
end.
{6 i 5 ord, chr, val(s,v,code),str;}

ÚÄÄÄ¿  ÚÄÄÄ¿  ³\  ³ ÄÄÂÄÄ ³  ³ ³\  /³  ³
ÃÄÄÄ´  ³   ³  ³ \ ³   ³   ³  ³ ³ \/ ³  ³
³   ³  ÃÄÄÄ´  ³  \³   ³   ÀÄÄÙ ³    ³  ³
ÀÄÄÄÙ