function imgOutput=locationExchange(imgInput,based)
[rows,clos]=size(imgInput);
imgOutput=imgInput;
sequence=GetHalton(rows+clos,based);
%行互换
seqRows=sequence(1:rows,1);
[~,sortOrder]=sort(seqRows);
[~,sortOrder]=sort(sortOrder);
%加密：将第i列搬移到第sortOrder(i)列
for i=1:rows
    imgOutput(sortOrder(i),:)=imgInput(i,:);
end

imgTemp=imgOutput;

%列互换
%加密：将第i行搬移到第sortOrder(i)行
seqClos=sequence(rows+1:end,1);
[~,sortOrder]=sort(seqClos);
[~,sortOrder]=sort(sortOrder);
for i=1:clos
    imgOutput(:,sortOrder(i))=imgTemp(:,i);
end