function [nearPatch1,nearPatch] = givePatch(temp1,mask,a,inputTexture)
    
    [m,n] = size(mask);
    temp3 = inputTexture.*inputTexture;
    temp3 = filter2(mask,temp3,'valid');
    temp2 = temp1.*temp1.*mask;
    temp4 = filter2(temp1.*mask,inputTexture,'valid');
    errors = temp3 + sum(temp2(:))-2*temp4;
    minerror = abs(min(errors(:)));
    [x,y] = find(errors <= minerror*1.3);
    randint = randi([1 length(x)],1);
    
    nearPatch1 = a(x(randint):x(randint)+m-1,y(randint):y(randint)+n-1,:);
    nearPatch = inputTexture(x(randint):-1+m + x(randint),y(randint):y(randint)+n-1);
    
end
