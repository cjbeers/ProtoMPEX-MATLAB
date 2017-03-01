
RandArray= zeros(100, 512);
TestSpectra=zeros(100,512);
TiArray=zeros(100,1);

for i=1:100    
RandArray(i,:)=randi([-500 500],1,512);
TestSpectra(i,:)=Fiber4(8,:)+ RandArray(i,:);

DATA.I=TestSpectra(i,:);
DATA.X=flip(lambdaplot);
BIN=0.874;

TiArray(i,1)=FIT_EXAMPLE(DATA,BIN);
end

%%
SUM(Fiber3(27,
