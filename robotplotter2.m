% robotplotter2.m

%% SET DISPLAY AXES
axes = [-7 7 -7 7];

%% MAIN SCRIPT
N = length(simout(1,:));
clear X;
clear Y;
for i = 1:(N/2)
    X(:,i) = simout(:,i);
end

for j = (N/2+1):N
    Y(:,j-(N/2)) = simout(:,j);
end

figure('Position',[0 0 1280 720])

for k = 1:length(X)

    plot(X(1:k,:),Y(1:k,:))
    axis(axes);
    axis square
    hold on
    
    ax = gca;
    ax.ColorOrderIndex = 1;
    
    for z = 1:(N/2)
    plot(X(k,z),Y(k,z),'o')
    end
 
    M(k) = getframe;
    
    hold off
    
end

%% VIDEO OUTPUT
%{
 VIDEO = VideoWriter('filename');
 open(VIDEO);
 writeVideo(VIDEO,M);
 close(VIDEO)
%}
%close all
    
