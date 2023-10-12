function [rio,enc]=distance
global calib_flag valid_flag ungauged_flag;
if calib_flag == 1
load('data\data_base\Calibration\temp\fac','fac');
load('data\data_base\Calibration\temp\fdr','fdr');
load('data\data_base\Calibration\temp\R','R');
load('data\data_base\Calibration\temp\tr','tr')
elseif valid_flag == 1
load('data\data_base\Validation\temp\fac','fac');
load('data\data_base\Validation\temp\fdr','fdr');
load('data\data_base\Validation\temp\R','R');
load('data\data_base\Validation\temp\tr','tr') 
elseif ungauged_flag == 1
load('data\data_base\Ungauged\temp\fac','fac');
load('data\data_base\Ungauged\temp\fdr','fdr');
load('data\data_base\Ungauged\temp\R','R');
load('data\data_base\Ungauged\temp\tr','tr')
end

%clc;

[i,j]=size(fac);
fac_n=nan(i+2,j+2);
fdr_n=nan(i+2,j+2);
        
for ii=1:i
    for jj=1:j
        fac_n(ii+1,jj+1)=fac(ii,jj);
        fdr_n(ii+1,jj+1)=fdr(ii,jj);
    end
end
fac=fac_n;
fdr=fdr_n; 

Ta=R(2,1); 
Aux=reshape(fac,1,[]);
A=sort(Aux,'descend');
A=A';
A(isnan(A))=[];
Aux5=nan(size(fac,1),size(fac,2));
[a,b]=find(fac==A(1,1),1);
Aux5(a,b)=1;

v=[-1,-1,2; +1,-1,128; +1,+1,32; -1,+1,8; 0,+1,16; +1,0,64; -1,0,4; 0,-1,1];
enc=zeros(size(fac));
rio=zeros(size(fac));

for i=2:size(A,1);

   for n=1:4
       if fdr(a+v(n,1),b+v(n,2))==v(n,3) 
           if fac(a+v(n,1),b+v(n,2))>tr
           rio(a+v(n,1),b+v(n,2))=sqrt(2*(Ta^2))+rio(a,b);
           enc(a+v(n,1),b+v(n,2))=enc(a,b);
           else
           enc(a+v(n,1),b+v(n,2))=sqrt(2*(Ta^2))+enc(a,b);
           rio(a+v(n,1),b+v(n,2))=rio(a,b);
           end
       end
   end
   for n=5:8
       if fdr(a+v(n,1),b+v(n,2))==v(n,3) 
           if fac(a+v(n,1),b+v(n,2))>tr
           rio(a+v(n,1),b+v(n,2))=Ta+rio(a,b);
           enc(a+v(n,1),b+v(n,2))=enc(a,b);
           else
           enc(a+v(n,1),b+v(n,2))=Ta+enc(a,b);
           rio(a+v(n,1),b+v(n,2))=rio(a,b);
           end
       end
   end

fac(a,b)=-9999;
[a,b]=find(fac==A(i,1),1);
end

end
