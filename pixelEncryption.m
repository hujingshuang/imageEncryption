function imgOutput=pixelEncryption(imgInput,based)
[rows,clos]=size(imgInput);
sequence=GetHalton(8*clos,based);
imgOutput=imgInput;
%加密：将每个像素的二进制交换
for i=1:clos    %列
    seqClos=sequence((i-1)*8+1:i*8,1);
    [~,sortOrder]=sort(seqClos);
    [~,sortOrder]=sort(sortOrder);        %序列
    for j=1:rows    %行
        pixelValue=imgInput(j,i);
        pixelBin=dec2bin(pixelValue,8); %8位的二进制
        tempBin=pixelBin;
        for k=1:8
            tempBin(1,k)=pixelBin(1,sortOrder(k));
        end
        imgOutput(j,i)=bin2dec(tempBin);
    end
end
