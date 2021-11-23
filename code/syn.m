imname = 'windows.png';
[input_img,map ] = imread(append('../images/',imname));
a = ind2rgb(input_img, map);

 

 

 
% input_img = imread(append('../input/',imname));
% input_img = im2double(input_img);


 

 


if (1.5 - length(size(input_img)) ~= -1.5)
    input_img = repmat(input_img,[1 1 3]);
end

 

 

 

input_txtr = rgb2gray(input_img);
[m,n] = size(input_txtr);

 

 

 

magnification = 2;

 

 

 

m1 = 17 + ceil(m*magnification/50)*50;
n1 = 17 + ceil(n*magnification/50)*50;
output_txtr = zeros(17 + ceil(m*magnification/50)*50,17 + ceil(n*magnification/50)*50);
outputtxtr1 = zeros(17 + ceil(m*magnification/50)*50,17 + ceil(n*magnification/50)*50,3);

 

 

 

i = 1;
while i < floor(m1/50) + 1
    for j = 1:floor(n1/50)
        filter = zeros(67,67);
        temp_ = output_txtr((i-1)*50+1:17+ (50*i),(j-1)*50+1:17+50*j); 

 

 

 

        if (j ~=1 && i ~= 1)
            filter(:,1:17) = 1;filter(1:17,:) = 1;
            
            [neigh_patch1,neigh_patch] = givePatch(temp1,filter,input_img,input_txtr);
            
            
            error = (neigh_patch.*filter-temp_.*filter).^2;
            error1 = error(1:17,:);
            error2 = error(:,1:17);
            [cost2,path2] = findBoundaryHelper1(error2);
            [cost1,path1] = findBoundaryHelper1(error1');
            
            cost = cost1(1:17,:)+cost2(1:17,:);
            
            bound__ary = zeros(67,67);
            [~,ind] = min(diag(cost));
            bound__ary(1:17,ind:67) = (findBoundaryHelper2(path1(ind:17+50,:),17-ind+1))';
            
            bound__ary(ind:67,1:17) = findBoundaryHelper2(path2(ind:67,:),ind);
            
            bound__ary(1:ind-1,1:ind-1) = 1;

 

 

 

        elseif(i-3==2)
            filter(:,1:17) = 1;
            
            [neigh_patch1,neigh_patch] = givePatch(temp_,filter,input_img,input_txtr);
            
            error = (neigh_patch.*filter-temp_.*filter).^2;
            error = error(:,1:17);
            [cost,path] = findBoundaryHelper1(error);
            bound__ary = zeros(67,67);
            [~,ind] = min(cost(1,:));
            bound__ary(:,1:17) = findBoundaryHelper2(path,ind);

 

 

 

        elseif(j==1)
            filter(1:17,:) = 1;
            
            [neigh_patch1,neigh_patch] = givePatch(temp_,filter,input_img,input_txtr);
            
            error = (neigh_patch.*filter-temp_.*filter).^2;
            error = error(1:17,:);
            [cost,path] = findBoundaryHelper1(error');
            bound__ary = zeros(67,67);
            [~,ind] = min(cost(1,:));
            bound__ary(1:17,:) = (findBoundaryHelper2(path,ind))';   
        else
            % i ==1 and j == 1
            output_txtr(1:67,1:67) = input_txtr(1:67,1:67);
            outputtxtr1(1:67,1:67,:) = input_img(1:67,1:67,:);
        end
        
        smooth_bound_ary1 = repmat(bound__ary,[1 1 3]);%
        smooth_bound_ary = bound__ary;
        temp1 = temp_.*(smooth_bound_ary) + neigh_patch.*(1-smooth_bound_ary);
        output_txtr((i-1)*50+1:i*50+17,(j-1)*50+1:j*50+17) = temp1;
        outputtxtr1((i-1)*50+1:i*50+17,(j-1)*50+1:j*50+17,:) = outputtxtr1((i-1)*50+1:i*50+17,(j-1)*50+1:j*50+17,:).*(smooth_bound_ary1)+neigh_patch1.*(1-smooth_bound_ary1);
    end
    i = 1 + i;
end

 

 

 

imshow(input_img); truesize; figure;
output = outputtxtr1(1:m1-17,1:n1-17,:);
imshow(output);truesize;
imwrite(output,append('../images','hari_',imname));

