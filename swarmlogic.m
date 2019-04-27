function set = swarmlogic(XAll,YAll,scale,xr,yr,b)
RepScale=10;
OrbScale=.9;
GradScale=3;
xatt=zeros(1,length(XAll));
yatt=zeros(1,length(YAll));
xrep=zeros(1,length(XAll));
yrep=zeros(1,length(YAll));
xorb=zeros(1,length(XAll));
yorb=zeros(1,length(XAll));
c=zeros(1,length(XAll));
c(1)=NaN;
zr=0;

%Decouple Virtual Leader
if(isnan(XAll(1)))
    index=2;
else
    index=1;
end

for i = index:length(XAll)
    d=sqrt(abs((XAll(i)-xr)^2+(YAll(i)-yr)^2));
    %For Scalar Field
    c(i)=sqrt(abs((XAll(i)-xr)^2+(YAll(i)-yr)^2));
    if (c(i)==0)
        c(i)=NaN;
        zr=scale(i);
    end
    
    %Attraction  
    if (d==0)       %Discount Self
        xatt(i)=0;
    else
        xatt(i)=(XAll(i)-xr);
        yatt(i)=(YAll(i)-yr);
    end

    %Repulsion
    if (d==0)       %Discount Self
        xrep(i)=0;
    else
        xrep(i)=1/(xr-XAll(i))*RepScale;
        xrep(i)=min(1.5, max(-1.5, xrep(i)));
        yrep(i)=1/(yr-YAll(i))*RepScale;
        yrep(i)=min(1.5, max(-1.5, yrep(i)));
    end 

end
%Orbit  b(3)=-1 for ccw
xorb=-(yatt*OrbScale);
yorb=xatt*OrbScale;

%Scalar Field- use 2 nearest neighbors to find gradient
[p,q]=min(c,[],'omitnan');
x1=XAll(q);
y1=YAll(q);
z1=scale(q);
c(q)=NaN;
[p,q]=min(c,[],'omitnan');
x2=XAll(q);
y2=YAll(q);
z2=scale(q);
N=cross([xr-x1,yr-y1,zr-z1],[xr-x2,yr-y2,zr-z2]);
if (N(3)>0)
    N(1)=-N(1);
    N(2)=-N(2);
end
if (b(4)==1) %go up
    xgrad=N(1)*GradScale;
    ygrad=N(2)*GradScale;
elseif(b(4)==-1) %go down
    xgrad=N(1)*GradScale*-1;
    ygrad=N(2)*GradScale*-1;   
else 
    xgrad=0;
    ygrad=0;
end

Vx=xatt*b(1)+xrep*b(2)+xorb*b(3);
Vy=yatt*b(1)+yrep*b(2)+yorb*b(3);

set=[mean(Vx)+xgrad,mean(Vy)+ygrad];