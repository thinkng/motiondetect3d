%Motion detection from 3-axis accelerometer data
%Created by Thinh Nguyen 2015
% ver 2.0 inverstigate dev on each axis to apply a threshold
% 1st updated on 2015 March 31st.
% 1st updated on 2015 October 03rd. Thinh Nguyen


%%
clear all
data=csvread('20150331.dat',0,0);

x=data(151:350,1);  %20seconds of data
y=data(151:350,2);
z=data(151:350,3);
 
figure(1)
subplot(4,1,1)
plot(x,'r');
title('x');
axis([0 length(z) 0 300]);
xlabel('x0.1 second')
hold on;
grid on;

subplot(4,1,2)
plot(y,'b');
title('y');
axis([0 length(z) 0 300]);
xlabel('x0.1 second');
grid on;

subplot(4,1,3)
plot(z,'g');
title('z');
xlabel('x0.1 second');
axis([0 length(z) 0 300]);
grid on;

%% Investigate the motion for 1-s interval
fs=10; %sampling rate = 10Hz
thres = 5;
%n=3*fs; %investigate every 3-s time window
n=fs; %investigate every 3-s time window. 20151003 - Thinh

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

duration=0; % Duration with movement
for i=1:n
      dev_x(j+i)=sqrt((xx(i)-TR_x)^2); %deviation from mean value
      dev_y(j+i)=sqrt((yy(i)-TR_y)^2);
      dev_z(j+i)=sqrt((zz(i)-TR_z)^2);
      
    if  (dev_x(i+j)>thres) || (dev_y(i+j)>thres) || (dev_z(i+j)>thres) %either significant movement is detected on 1 of 3 axes
        duration=duration+1;
    end
    %if (duration>(fs))      % duration of the deviation is longer than 1 second
    if (duration>(0.5*fs))      %ì duration of the deviation is longer than 0.5 second. 20151003. Thinh
        motion(j:(j+n))=200;
    end      
end
end

%% Classify motion into each 1-s epoc

   
% 
% motion_i=1;
% 
% for i=1:length(dev_x)
%     if (dev_x(i)>5) || (dev_y(i)>5) || (dev_z(i)>5)
%         motion_pos(motion_i)=i;
%         motion_i=motion_i+1;
%     end
% end

% 
% for i=1:length(motion_pos)
%     Y(i)=200;
% end
% 
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

subplot(4,1,4)
bar(motion,0.1)
axis([0 length(x) 0 200])
xlabel('x0.1 second')
title('Motion auto-detection')

