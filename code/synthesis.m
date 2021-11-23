imname = 'chocolate.png';
savefile = true;
%=============================
% use this for custom images (MS paints)
% a = im2double(imread(append('../input/synthesis/',imname)));

% else
[input_img,map ] = imread(append('../input/synthesis/',imname));
a = ind2rgb(input_img, map);
% ===================================algorithm starts

figure; 

imshow(a); 



if(length(size(a)) -2 ~= 1)
    a = repmat(a,[1 1 3]);
end
textInput = rgb2gray(a);
[m,n] = size(textInput);

magnification = 2;

n1 = ceil(n*magnification/50)*50+17;
m1 = ceil(m*magnification/50)*50+17;

textout_1 = zeros(m1,n1,3);

textout = zeros(m1,n1);


i = 1;
while i - 1 < floor(m1/50)
    for j = 1:floor(n1/50)
        filtermask = zeros(50+17,50+17);
        temp1 = textout((i-1)*50+1:i*50+17,(j-1)*50+1:j*50+17); 


        if(i==1 && j ~=1)
            filtermask(:,1:17) = 1;
            
            [neighbour1,neighbour] = givePatch(temp1,filtermask,a,textInput);
            
            error = (neighbour.*filtermask-temp1.*filtermask).^2;
            error = error(:,1:17);
            
            boundary = zeros(50+17,50+17);
            [cost,path] = findBoundaryHelper1(error);
            boundary(:,1:17) = findBoundaryHelper2(path,ind);
            [~,ind] = min(cost(1,:));
            

        elseif(j==1 && i ~= 1)
            filtermask(1:17,:) = 1;
            
            [neighbour1,neighbour] = givePatch(temp1,filtermask,a,textInput);
            
            error = (neighbour.*filtermask-temp1.*filtermask).^2;
            error = error(1:17,:);
            [cost,path] = findBoundaryHelper1(error');
            [~,ind] = min(cost(1,:));
            boundary = zeros(50+17,50+17);
           
            boundary(1:17,:) = (findBoundaryHelper2(path,ind))';
            
        elseif (i ~=1 && j~= 1)
            filtermask(:,1:17) = 1;
            filtermask(1:17,:) = 1;
            
            [neighbour1,neighbour] = givePatch(temp1,filtermask,a,textInput);
            
            error = (neighbour.*filtermask-temp1.*filtermask).^2;
            error2 = error(:,1:17);
            error1 = error(1:17,:);
            
            [cost2,path2] = findBoundaryHelper1(error2);
            [cost1,path1] = findBoundaryHelper1(error1');
            
            
            
            
            cost = cost1(1:17,:)+cost2(1:17,:);
            
            boundary = zeros(50+17,50+17);
            [~,ind] = min(diag(cost));
            boundary(1:17,ind:50+17) = (findBoundaryHelper2(path1(ind:17+50,:),17-ind+1))';
            
            boundary(ind:17+50,1:17) = findBoundaryHelper2(path2(ind:17+50,:),ind);
            
            boundary(1:ind-1,1:ind-1) = 1;
        else 
            
            
            textout_1(1:50+17,1:50+17,:) = a(1:50+17,1:50+17,:);
            textout(1:50+17,1:50+17) = textInput(1:50+17,1:50+17);
            continue
        end
        
        smoothBoundary1 = repmat(boundary,[1 1 3]);%
        smoothBoundary = boundary;
        
        temp2 = temp1.*(smoothBoundary) + neighbour.*(1-smoothBoundary);
        textout_1((i-1)*50+1:i*50+17,(j-1)*50+1:j*50+17,:) = textout_1((i-1)*50+1:i*50+17,(j-1)*50+1:j*50+17,:).*(smoothBoundary1)+neighbour1.*(1-smoothBoundary1);
        textout((i-1)*50+1:i*50+17,(j-1)*50+1:j*50+17) = temp2;
    end
    i = i + 1;
end

figure;
imshow(a);


figure;
output = textout_1(1:m1-17,1:n1-17,:);

imshow(output);
if savefile
    imwrite(output,append('../output/synthesis/','quilted_',imname));
end


