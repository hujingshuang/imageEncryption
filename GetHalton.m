function Seq=GetHalton(HowMany, Base)
Seq=zeros(HowMany,1);                       %存放最终结果
NumBits=1+ceil(log(HowMany)/log(Base));     %比特位
VetBase=Base.^(-(1:NumBits));               %倒数
WorkVet=zeros(1,NumBits);
for i=1:HowMany
   j=1;
   ok=0;
   while ok==0
      WorkVet(j)=WorkVet(j)+1;
      if WorkVet(j)<Base
         ok=1;
      else
         WorkVet(j)=0;
         j=j+1;
      end
   end
   Seq(i)=dot(WorkVet,VetBase);             %点乘
end

   
   