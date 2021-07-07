%function [SXB_Value] = read_adas_sxb12_file(fname, Ne, Te, Wvlngth)

%% Info
%Coded by Josh Beers @ ONRL 2019
%fname should point to a file on your computer or server location for the
%relavent element you want to read in
%Ne is in cm-3
%Te is in eV
%Wvlength is your wavelength of intererst given by one of the wavelengths
%at the bottom of the SXB .dat file given in Ang.

%% Begin Code
cleanup

Te=3;
Ne=3.5E10;
Wvlngth=4339.9;

fname = ['C:\Users\cxe\Documents\Open-ADAS\','sxb12#h_pju#h0.dat'];

fid = fopen(fname,'r');
if fid == -1    
    error(['Did not find output file: ',fname])
end
clc
%% Get data
% First line
currentline=fgetl(fid); nsel=str2double(currentline(2:5)); note=currentline(10:end);

% fprintf('Reading file: %s\n',fname);
% fprintf('Wavelength (A): %4.1f\n',wlng); 
% fprintf('Number of densities, temperatures = [%d,%d]\n',ndens,ntemp);
%wlng{1,6864/104}=[];


jj=1;
kk=1;
mm=1;
aa=1;

for ii = 1:1:6865
    currentline=fgetl(fid);
    
    if ii==1 
wlng{jj}=str2double((currentline(1:8))); %Ang     
ndens=str2double(currentline(13:14)); 
ntemp=str2double(currentline(17:19));

    elseif ii==105
jj=jj+1;
wlng{jj}=str2double((currentline(1:8))); %Ang     

     elseif ii==209
jj=jj+1;
wlng{jj}=str2double((currentline(1:8))); %Ang     

    elseif mod(ii-313,104)==0 && ii>=313 && ii< 6864
jj=jj+1;
wlng{jj}=str2double((currentline(1:8))); %Ang     

    elseif ii~=1 && ii~=105 && ii~=209 && mod(ii-313,104)~=0 && ii< 6864
       
        SXB{mm,aa}=str2num(currentline);
        sizeSXB=size(SXB{mm,aa});
        
        if sizeSXB(1,2) == 8
            aa=aa+1;
        elseif sizeSXB(1,2) ~= 8
            mm=mm+1;
            aa=1;
        end
    else
        
    end
end

wlng=cell2mat(wlng);

%Array function SXB matrix to get all values into their own array location
jj=1;
for ii=1:length(SXB)
    
    CurrentSXBline=cell2mat(SXB(ii,:));
    
    if ii==1
        SXB2(ii,:)=CurrentSXBline;
        NewWlng(jj)=ii;
        jj=jj+1;
    elseif size(CurrentSXBline,2)==size(SXB2(1,:),2)
        NewWlng(jj)=ii;
        jj=jj+1;
        SXB2(ii,:)=SXB2(1,:);
    else
        CurrentSXBline(numel((SXB2(1,:))))=0;
    end
    
    SXB2(ii,:)=CurrentSXBline;
    %SXB_mod(ii:size(CurrentSXBline,2))=num2cell(CurrentSXBline,size(CurrentSXBline,2));
end

dens=SXB2(1,1:24);
temps=SXB2(1,25:end);

%% Get SXB values for input Te, Ne, and wavelength of interest
try
[wlng_loc] = find(Wvlngth==wlng);
catch
    disp('Wrong Wavelength Input')
end

[temp_loc] = find(Te==temps);

if isempty(temp_loc)
    firstte=find(abs(temps<Te),1,'last');
    lastte=firstte+1;
end
   
[dens_loc] = find(Ne==dens);

if isempty(dens_loc)
    firstne=find(abs(dens<Ne),1,'last');
    lastne=firstne+1;
end

% if isempty(dens_loc)
%      [~,dens_loc] = min(abs(dens-Ne));
%      Ne=dens(dens_loc);
% end

    if ~isempty(temp_loc) && ~isempty(dens_loc)
SXB_Value=SXB2((NewWlng(wlng_loc)+dens_loc),temp_loc);

    elseif isempty(temp_loc) && ~isempty(dens_loc)
      
        x1=temps(firstte);
        x2=Te;
        x3=temps(lastte);
        y1=SXB2((NewWlng(wlng_loc)+dens_loc),firstte);
        y3=SXB2((NewWlng(wlng_loc)+dens_loc),lastte);
        SXB_Value=(((x2-x1)*(y3-y1))/(x3-x1))+y1;
        
    elseif isempty(dens_loc) && ~isempty(temp_loc)
        
        x1=dens(firstne);
        x2=Ne;
        x3=dens(lastne);
        y1=SXB2((NewWlng(wlng_loc)+firstne),temp_loc);
        y3=SXB2((NewWlng(wlng_loc)+lastne),temp_loc);
        SXB_Value=(((x2-x1)*(y3-y1))/(x3-x1))+y1;
        
    elseif isempty(dens_loc) && isempty(temp_loc)
        
        x1=dens(firstne);
        x2=Ne;
        x3=dens(lastne);
        y1=temps(firstte);
        y2=Te;       
        y3=temps(lastte);
        q11=SXB2((NewWlng(wlng_loc)+firstne),firstte);
        q21=SXB2((NewWlng(wlng_loc)+lastne),firstte);
        q12=SXB2((NewWlng(wlng_loc)+firstne),lastte);
        q22=SXB2((NewWlng(wlng_loc)+lastne),lastte);
        
        SXB_Value=((((x3-x2)*(y3-y2))/((x3-x1)*(y3-y1)))*q11)+...
                  ((((x2-x1)*(y3-y2))/((x3-x1)*(y3-y1)))*q21)+...
                  ((((x3-x2)*(y2-y1))/((x3-x1)*(y3-y1)))*q12)+...
                  ((((x2-x1)*(y2-y1))/((x3-x1)*(y3-y1)))*q22)       
    else
        disp('Error in Interpolation')
        
    end
% SXB_Ne=Ne;
% SXB_Te=Te;
% SXB_Wavelength=Wvlength;



