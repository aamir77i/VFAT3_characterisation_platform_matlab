function [coeff,gof,out] = rfit_erf(x,y)
x=x(:);
y=y(:);
mediany=median(y,1);


amin = min(mediany);
amax = max(mediany);
idxx= find(mediany > (amin  + 0.01*(amax-amin)) & mediany < (amax - 0.01*(amax-amin)));

if isempty(idxx)
    idxx= find(mediany==median(mediany));
end
if length(idxx)>1
    idx2=idxx(end); 
    idx1=idxx(1);
else
    idx1=idxx;
    idx2=idx1+1; 
end
asigma =  abs(x(idx1) - x(idx2))/4;
amin  = (y(idx1)+ y(idx2)) /2;
amean  = (y(idx1)+ y(idx2)) /2;
xmean = (x(idx1)+x(idx2))/2 ;
%%
A0=[ min(y) range(y) x(round(median(idxx))) asigma ]
%%
opts = fitoptions('method','NonlinearLeastSquares', 'MaxFunEvals', 1000, 'TolX', 1e-5);
    opts= fitoptions(opts, 'StartPoint',A0); 
func='a1 + a2.*(1+erf(sign(xx-a3).*abs(xx-a3)/abs(a4)/sqrt(2)))/2';
mymodel = fittype(func,...
        'independent','xx',...
         'options',opts);
[coeff,gof,out] = fit(x(:),y(:),mymodel);

%figure;
%clf;
%hold on;
%plot(x,y,'x');
%plot(coeff);


%A=coeffvalues(coeff);
%conf= confint(coeff,0.95);
%funcstr =['y = ',char(func)];
%funcstr = strrep(funcstr,'./','/');
%funcstr = strrep(funcstr,'.*','*');
%funcstr = strrep(funcstr,'.^','^');
%for i=1 :length(A)
%    if A(i)<0
%        funcstr=strrep(funcstr,sprintf('A(%i)',i), sprintf('(%.3f)',A(i)));
%    else
%        funcstr=strrep(funcstr,sprintf('A(%i)',i), sprintf('%.3f',A(i)));    
%    end
%end
%if length(funcstr)>80 
%    funcstr = [funcstr(1:min(end,80)) , '......'];
%end
%ht=addtext( sprintf('%s\n%s\n%s\n%s\n%s\n%s',...
%    funcstr,...
%    sprintf('%.4f ',A),...
%    sprintf('%.4f ',conf(2,:)-A),...
%    opts.robust,...
%    sprintf('rsquare=%g', gof.rsquare),... 
%    sprintf('rmse=%g', gof.rmse)),... 
%    0);
%set(ht,'interpreter','none');
