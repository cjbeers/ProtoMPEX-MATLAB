%%
cleanup
x=1;
y=1;

Answer=test1(x,y)

%%
function qq=test1(x,y)

qq=testx(x)+testy(y);

    function xtest=testx(x)
        xtest=x*3;
    end

 function ytest=testy(y)
        ytest=y*3;
    end
end
