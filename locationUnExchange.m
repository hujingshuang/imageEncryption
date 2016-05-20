function imgOutput=locationUnExchange(imgInput,based)
[rows,clos]=size(imgInput);
imgOutput=imgInput;
sequence=GetHalton(rows+clos,based);
%列互换
seqClos=sequence(rows+1:end,1);
[~,sortOrder]=sort(seqClos);
[~,sortOrder]=sort(sortOrder);
%解密：将第sortOrder(i)列搬移到第i列
for i=1:clos
    imgOutput(:,i)=imgInput(:,sortOrder(i));
end

imgTemp=imgOutput;

%行互换
%解密：将第sortOrder(i)行搬移到第i行
seqRows=sequence(1:rows,1);
[~,sortOrder]=sort(seqRows);
[~,sortOrder]=sort(sortOrder);
for i=1:rows
    imgOutput(i,:)=imgTemp(sortOrder(i),:);
end