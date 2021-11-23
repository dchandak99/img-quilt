function [nearPatch1,nearPatch] = createPatch1(inputTexture, inputTarget,al, a,mask,t1)
    m1 = ones(size(mask));
    [p,q] = size(mask);

    t2 = inputTarget.*inputTarget;
    t3 = filter2(inputTarget,inputTexture,'valid');
    t4 = filter2(m1,inputTexture.*inputTexture,'valid');
    t5 = t1.*t1.*mask;
    t6 = filter2(t1.*mask,inputTexture,'valid');
    t7 = inputTexture.*inputTexture;
    t7 = filter2(mask,t7,'valid');

    errors = al*(sum(t5(:))-2*t6 + t7)+(1-al)*(sum(t2(:)) - 2*t3 + t4);
    
    minerror = abs(min(errors(:)));
    [x,y] = find(errors <= minerror*1.3);
    randint = randi([1 length(x)],1);
    
    nearPatch = inputTexture(x(randint):x(randint)-1+p,y(randint):y(randint)-1 + q);
    nearPatch1 = a(x(randint):-1 + x(randint)+p,y(randint):-1+y(randint)+q,:);
end