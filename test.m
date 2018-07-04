% Data
clearvars;
%%
x{1} = (.2:.2:2).';
%%
z{1} = rand(10,1);
x{2} = 1:4;
z{2} = randn(4,1);

x{3} = 1:40;
z{3} = randn(40,1);


% Plotting
figure;
hold on;
for i = 1:length(x)
      plot3(x{i}, i*ones(size(x{i})), z{i});
end
hold off;
grid on;
set(gca,'CameraPosition',[-19 -5 5]);
set(gca,'CameraViewAngle',8);
% axlim = axis;
% for i = 1:length(x)
%       patch(axlim([1 1 2 2]), [i i i i], axlim([5 6 6 5]), [.8 .9 .8], 'FaceAlpha', .4);
% end

%%
x=[100 100 200 200];
y=[1 5 5 1];
z=[1114.8 826 1370.4 1711.6 ];
patch(x,y,z);colorbar;


%%
pointsize = 10;
scatter(x, y, pointsize, z);
%% 
clearvars;
[x, y] = meshgrid(1:128, 0:70); % 2d meshgrid
z = sort(rand(size(x))); % sample data, use your own variable
p = pcolor(x,y,z);
p.EdgeAlpha = 0;
colorbar;