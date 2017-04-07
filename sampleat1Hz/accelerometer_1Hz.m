%Motion detection from 3-axis accelerometer data
%Created by Thinh Nguyen 2015
% ver 2.0 inverstigate dev on each axis to apply a threshold
% Last updated on 2015 May 08 - 1Hz sampling rate

clear all
data=csvread('K_data.dat',0,0);

x=data(:,5);
y=data(:,6);
z=data(:,7);
 
fs=1; %sampling rate = 1Hz

n=3*fs; %investigate every 3-s time window

for j=1:n:(length(x)-n) 
sum_x=0;
sum_y=0;
sum_z=0;

for i=1:n
    xx(i)=x(j+i);
    sum_x=sum_x+xx(i);
    yy(i)=y(j+i);
    sum_y=sum_y+yy(i);
    zz(i)=z(j+i);
    sum_z=sum_z+zz(i);
end

TR_x=sum_x/n; %average value of time window
TR_y=sum_y/n;
TR_z=sum_z/n;

duration=0;
for i=1:n
      dev_x(j+i)=sqrt((xx(i)-TR_x)^2); %deviation from mean value
      dev_y(j+i)=sqrt((yy(i)-TR_y)^2);
      dev_z(j+i)=sqrt((zz(i)-TR_z)^2);
      
    if  (dev_x(i+j)>5) || (dev_y(i+j)>5) || (dev_z(i+j)>5)
        %duration=duration+1;
        motion(j:(j+n))=200;   %20150508-Dont count duration anymore
    end
    if (duration>(1*fs))      %ì duration of the deviation is longer than 1 second
        %motion(j:(j+n))=200;
    end     
end
end
    
% 
% for i=1:length(motion_pos)
%     Y(i)=200;
% end

% figure(2)
% subplot(2,1,1)
% plot(x,'r');
% title('x');
% axis([0 length(dev_x) 100 300]);
% hold on
% subplot(2,1,2)
% plot(dev_x,'r')
% title('dev_x')
% axis([0 length(dev_x) 0 50]);
% 
% figure(3)
% subplot(2,1,1)
% plot(y,'b');
% axis([0 length(dev_y) 100 300]);
% title('y')
% hold on
% subplot(2,1,2)
% plot(dev_y,'b')
% title('dev_y')
% axis([0 length(dev_y) 0 50]);
% 
% figure(4)
% subplot(2,1,1)
% plot(z,'g');
% title('z')
% axis([0 length(dev_z) 100 300]);
% hold on
% subplot(2,1,2)
% plot(dev_z,'g')
% title('dev_z')
% axis([0 length(dev_z) 0 50]);

% figure(5)
% plot(x,'r')
% hold on  
% plot(y,'b')
% plot(z,'g')

figure(1)
subplot(2,1,1)
plot(x,'r');
title('Accelerometer data');
axis([0 length(z) 150 300]);
xlabel('x1 second')
hold on;
plot(y,'b');
plot(z,'g');
grid on;

subplot(2,1,2)
bar(motion,0.1)
axis([0 length(x) 0 200])
xlabel('x1 second')
title('Motion auto-detection')

