clear;clc;
load('survey_time.mat') 
%%%%%得到所有的时间,并计算为天%%%%%
for i = 1:24
    temp = Survey_time(1+18*(i-1));
    tYear = fix(temp/10000);
    tMonth = mod(fix(temp/100),100);
    tDay = mod(temp,100);
    DateNumber(i) = datenum(tYear,tMonth,tDay);
end
%%%%%计算时间差%%%%%
deltaT(1)=7;
for i = 2:24
    deltaT(i) = DateNumber(i) - DateNumber(i-1);
end
%%%%%20181106为第一天生成时间坐标%%%%%
x(1)=1;
for i = 2:25
    x(i) = x(i-1) + deltaT(i-1);
end


%%%%%获取每组的数据值%%%%%
load('emergenc_all.mat')
for j = 1:9
    Nseed(1,j) = 0;
    Yseed(1,j) = 0;
    Yaccumulate(1,j) = 0;
end
for i = 1:24
    for j = 1:9
        Nseed(i+1,j) = SS1(j+18*(i-1));
        Yseed(i+1,j) = SS1(j+9+18*(i-1));
        Yaccumulate(i+1,j) = Yaccumulate(i,j) + Yseed(i+1,j)
    end
end

%%%%%绘制样地的累积生长曲线%%%%%%
d1=1:1:172; % step
figure('Name','样地的累积生长曲线');
for i=1:9
    yn0=Nseed(:,i);
    yn0=yn0';
    yn(i,:)=interp1(x,yn0,d1,'PCHIP');  
    subplot(3,3,i)
    %plot(d1,yn(i,:));  
    plot(x,yn0,'o',d1,yn(i,:));  
    str_a=sprintf('N第%d块样地',i);
    title(str_a)
end

%%%%%绘制拔除草后生长曲线%%%%%
figure('Name','拔除草后生长曲线');
for i=1:9
    yy0=Yseed(:,i);
    yy0=yy0';
    yy(i,:)=interp1(x,yy0,d1,'PCHIP');  
    subplot(3,3,i)
    %plot(d1,ync(i,:));  
    plot(x,yy0,'o',d1,yy(i,:));  
    str_a=sprintf('第%d块样地',i);
    title(str_a)
end

%%%%%绘制拔除草后累积生长曲线
figure('Name','拔除草后累积生长曲线');
for i=1:9
    yyc0=Yaccumulate(:,i);
    yyc0=yyc0';
    yyc(i,:)=interp1(x,yyc0,d1,'PCHIP');  
    subplot(3,3,i)
    %plot(d1,ync(i,:));  
    plot(x,yyc0,'o',d1,yyc(i,:));  
    str_a=sprintf('第%d块样地',i);
    title(str_a)
end

%%%%%求均值和标准差%%%%%
figure('Name','平均出苗曲线');
%%%%%计算累积出苗%%%%%
yn_ava = mean(Nseed,2);
err = std(Nseed,0,2);
subplot(3,1,1)
errorbar(x,yn_ava,err,'-s','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red')
title('样地的累积平均生长曲线')
%%%%%计算拔草后%%%%%
yy_ava = mean(Yseed,2);
err2 = std(Yseed,0,2);
subplot(3,1,2)
errorbar(x,yy_ava,err2,'-s','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red')
title('样地的周平均生长曲线')

%%%%%计算拔草后%%%%%
%figure('Name','平均累积出苗曲线');
yy_aa = mean(Yaccumulate,2);
err3 = std(Yaccumulate,0,2);
subplot(3,1,3)
errorbar(x,yy_aa,err3,'-s','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red')
title('样地的周平均生长曲线')

